// parser/src/main.rs

use indexmap::IndexMap;
use regex::Regex;
use std::collections::HashMap;
use std::env;
use std::fs;
use std::io::Write;
use std::path::Path;

#[derive(Debug, Clone)]
enum Value {
    String(String),
    Nested(IndexMap<String, Value>),
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 3 {
        eprintln!("Usage: {} <input.css> <output.nix>", args[0]);
        std::process::exit(1);
    }

    let input_file = &args[1];
    let output_file = &args[2];

    let css_content =
        fs::read_to_string(input_file).unwrap_or_else(|e| panic!("Failed to read CSS file: {}", e));

    let properties = parse_css_properties(&css_content);
    let resolved = resolve_references(&properties);
    let mut nested = build_nested_structure(&resolved);

    // Add wallpaper collections to the nested structure
    if let Ok(wallpaper_data) = process_wallpapers(&css_content) {
        if let Value::Nested(ref map) = wallpaper_data {
            if !map.is_empty() {
                nested.insert("wallpapers".to_string(), wallpaper_data);
            }
        }
    }

    write_nix_file(output_file, &nested, input_file)
        .unwrap_or_else(|e| panic!("Failed to write Nix file: {}", e));

    println!(
        "Successfully generated {} with {} resolved properties",
        output_file,
        resolved.len()
    );
}

fn process_wallpapers(css_content: &str) -> Result<Value, Box<dyn std::error::Error>> {
    let wallpaper_regex = Regex::new(r#"--wallpapers-([^:]+):\s*["']([^"']+)["']"#)?;
    let wallpapers_dir = Path::new("assets/wallpapers");

    let mut collections = IndexMap::new();

    for capture in wallpaper_regex.captures_iter(css_content) {
        let collection_name = &capture[2]; // The value, not the CSS variable name

        if let Some(wallpaper_data) = scan_wallpaper_directory(collection_name, wallpapers_dir) {
            collections.insert(collection_name.to_string(), wallpaper_data);
        } else {
            eprintln!("Warning: No wallpapers found for collection '{}'", collection_name);
        }
    }

    if collections.is_empty() {
        return Ok(Value::Nested(IndexMap::new()));
    }

    Ok(Value::Nested(collections))
}

fn scan_wallpaper_directory(collection_name: &str, wallpapers_dir: &Path) -> Option<Value> {
    let collection_path = wallpapers_dir.join(collection_name);

    if !collection_path.exists() || !collection_path.is_dir() {
        return None;
    }

    let mut wallpapers = Vec::new();

    if let Ok(entries) = fs::read_dir(&collection_path) {
        for entry in entries.flatten() {
            if let Some(file_name) = entry.file_name().to_str() {
                if is_image_file(file_name) {
                    wallpapers.push(file_name.to_string());
                }
            }
        }
    }

    if wallpapers.is_empty() {
        return None;
    }

    // Sort alphabetically
    wallpapers.sort();

    let mut collection_data = IndexMap::new();
    collection_data.insert("collection".to_string(), Value::String(collection_name.to_string()));

    for (index, wallpaper) in wallpapers.iter().enumerate() {
        let entry_name = format!("wallpaper_{:02}", index + 1);
        collection_data.insert(entry_name, Value::String(wallpaper.clone()));
    }

    Some(Value::Nested(collection_data))
}

fn is_image_file(filename: &str) -> bool {
    let lower = filename.to_lowercase();
    lower.ends_with(".jpg")
        || lower.ends_with(".jpeg")
        || lower.ends_with(".png")
        || lower.ends_with(".webp")
}

fn parse_css_properties(css: &str) -> HashMap<String, String> {
    let mut properties = HashMap::new();
    let prop_regex = Regex::new(r"--([a-zA-Z0-9-]+)\s*:\s*([^;]+);").unwrap();

    for capture in prop_regex.captures_iter(css) {
        let name = capture[1].to_string();
        let value = capture[2].trim().to_string();
        properties.insert(name, value);
    }

    properties
}

fn resolve_references(properties: &HashMap<String, String>) -> HashMap<String, String> {
    let mut resolved = HashMap::new();
    let var_regex = Regex::new(r"var\(--([^)]+)\)").unwrap();

    for (name, value) in properties {
        let mut resolved_value = value.clone();
        let mut max_iterations = 10; // Prevent infinite loops

        while var_regex.is_match(&resolved_value) && max_iterations > 0 {
            let mut new_value = resolved_value.clone();
            for capture in var_regex.captures_iter(&resolved_value) {
                let var_name = &capture[1];
                if let Some(var_value_ref) = properties.get(var_name) {
                    new_value = new_value.replace(&capture[0], var_value_ref);
                } else {
                    // If a var cannot be resolved, it will be handled by clean_value_for_nix
                }
            }

            if new_value == resolved_value {
                break; // No more changes
            }
            resolved_value = new_value;
            max_iterations -= 1;
        }

        resolved_value = clean_value_for_nix(name, &resolved_value);
        resolved.insert(name.clone(), resolved_value);
    }

    resolved
}

fn clean_value_for_nix(name: &str, value: &str) -> String {
    let mut clean = value.trim().to_string();

    // For any font-related properties, extract just the first font name
    if name.contains("font") {
        let parts: Vec<&str> = clean.split(',').collect();
        if let Some(first_font_part) = parts.get(0) {
            let mut primary_font = first_font_part.trim().to_string();
            // Remove quotes from font names
            if (primary_font.starts_with('"')
                && primary_font.ends_with('"')
                && primary_font.len() >= 2)
                || (primary_font.starts_with('\'')
                    && primary_font.ends_with('\'')
                    && primary_font.len() >= 2)
            {
                primary_font = primary_font[1..primary_font.len() - 1].to_string();
            }
            clean = primary_font;
        }
    }

    // Remove any unresolved var() references
    let var_regex = Regex::new(r",?\s*var\([^)]+\)").unwrap();
    clean = var_regex.replace_all(&clean, "").trim().to_string();
    clean = clean.trim_end_matches(',').trim().to_string();

    // Normalize whitespace
    let space_regex = Regex::new(r"\s+").unwrap();
    clean = space_regex.replace_all(&clean, " ").to_string();

    // Remove surrounding quotes if present (for string values that come with quotes)
    let trimmed = clean.trim();
    if (trimmed.starts_with('"') && trimmed.ends_with('"') && trimmed.len() >= 2)
        || (trimmed.starts_with('\'') && trimmed.ends_with('\'') && trimmed.len() >= 2)
    {
        clean = trimmed[1..trimmed.len() - 1].to_string();
    }

    clean.trim().to_string()
}

fn build_nested_structure(properties: &HashMap<String, String>) -> IndexMap<String, Value> {
    let mut root = IndexMap::new();

    let mut sorted_keys: Vec<_> = properties.keys().collect();
    sorted_keys.sort();

    for key in sorted_keys {
        let value = &properties[key];

        if key.starts_with("font-family-") {
            // Special handling for font-family keys to preserve dashes in font type
            let font_type = &key[12..];
            let parts = vec!["font", "family", font_type];
            insert_nested(&mut root, &parts, value.clone());
        } else {
            let parts: Vec<&str> = key.split('-').collect();
            insert_nested(&mut root, &parts, value.clone());
        }
    }

    root
}

fn insert_nested(node: &mut IndexMap<String, Value>, path: &[&str], value: String) {
    if path.is_empty() {
        return;
    }

    if path.len() == 1 {
        node.insert(sanitize_key(path[0]), Value::String(value));
        return;
    }

    let key = sanitize_key(path[0]);
    let child = node
        .entry(key)
        .or_insert_with(|| Value::Nested(IndexMap::new()));

    if let Value::Nested(ref mut map) = child {
        insert_nested(map, &path[1..], value);
    }
}

fn sanitize_key(key: &str) -> String {
    if key.chars().all(|c| c.is_numeric()) {
        return format!("n{}", key);
    }
    if key.chars().next().map_or(false, |c| c.is_numeric()) {
        return format!("_{}", key);
    }
    if key.starts_with("base0") {
        // Keep base16 names as is
        return key.to_string();
    }
    // Preserve dashes in font family keys and other special cases
    if key.contains("alt") || key.contains("icons") {
        return key.to_string();
    }
    key.replace('-', "_")
}

fn write_nix_file(
    path: &str,
    structure: &IndexMap<String, Value>,
    source_file: &str,
) -> std::io::Result<()> {
    let mut file = fs::File::create(path)?;

    writeln!(
        file,
        "# Generated Nix expression for Chiaroscuro Theme Tokens"
    )?;
    writeln!(
        file,
        "# Do not edit this file directly. It is generated from {}",
        source_file
    )?;
    writeln!(file)?;
    writeln!(file, "{{")?;
    write_value(&mut file, structure, 1)?;
    writeln!(file, "}}")?;

    Ok(())
}

fn write_value<W: Write>(
    writer: &mut W,
    node: &IndexMap<String, Value>,
    indent_level: usize,
) -> std::io::Result<()> {
    let indent = "  ".repeat(indent_level);

    for (key, value) in node.iter() {
        let key_str = if key.contains('-') || key.chars().next().map_or(false, |c| c.is_numeric()) {
            format!("\"{}\"", key)
        } else {
            key.clone()
        };

        match value {
            Value::String(s) => {
                // NO ESCAPING! Just write the string as-is
                writeln!(writer, "{}{} = \"{}\";", indent, key_str, s)?;
            }
            Value::Nested(map) => {
                writeln!(writer, "{}{} = {{", indent, key_str)?;
                write_value(writer, map, indent_level + 1)?;
                writeln!(writer, "{}}};", indent)?;
            }
        }
    }

    Ok(())
}
