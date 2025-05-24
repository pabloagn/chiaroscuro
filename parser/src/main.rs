// parser/src/main.rs

use indexmap::IndexMap;
use regex::Regex;
use std::collections::HashMap;
use std::env;
use std::fs;
use std::io::Write;

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

    // Read CSS file
    let css_content = fs::read_to_string(input_file)
        .unwrap_or_else(|e| panic!("Failed to read CSS file: {}", e));

    // Parse CSS custom properties
    let properties = parse_css_properties(&css_content);

    // Resolve var() references
    let resolved = resolve_references(&properties);

    // Build nested structure
    let nested = build_nested_structure(&resolved);

    // Generate Nix file
    write_nix_file(output_file, &nested, input_file)
        .unwrap_or_else(|e| panic!("Failed to write Nix file: {}", e));

    println!("Successfully generated {} with {} resolved properties", output_file, resolved.len());
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

        // Resolve all var() references
        while var_regex.is_match(&resolved_value) && max_iterations > 0 {
            let mut new_value = resolved_value.clone();

            for capture in var_regex.captures_iter(&resolved_value) {
                let var_name = &capture[1];
                if let Some(var_value) = properties.get(var_name) {
                    new_value = new_value.replace(&capture[0], var_value);
                }
            }

            if new_value == resolved_value {
                break; // No more changes
            }
            resolved_value = new_value;
            max_iterations -= 1;
        }

        // Clean up the value for Nix
        resolved_value = clean_value_for_nix(&resolved_value);
        resolved.insert(name.clone(), resolved_value);
    }

    resolved
}

fn clean_value_for_nix(value: &str) -> String {
    let mut clean = value.trim().to_string();

    // Remove any remaining var() references that couldn't be resolved
    let var_regex = Regex::new(r",?\s*var\([^)]+\)").unwrap();
    clean = var_regex.replace_all(&clean, "").to_string();

    // Clean up font families - remove trailing commas and quotes
    clean = clean.trim_end_matches(',').trim().to_string();

    // Clean up multiple spaces
    let space_regex = Regex::new(r"\s+").unwrap();
    clean = space_regex.replace_all(&clean, " ").to_string();

    clean
}

fn build_nested_structure(properties: &HashMap<String, String>) -> IndexMap<String, Value> {
    let mut root = IndexMap::new();

    // Sort keys for consistent output
    let mut sorted_keys: Vec<_> = properties.keys().collect();
    sorted_keys.sort();

    for key in sorted_keys {
        let value = &properties[key];
        let parts: Vec<&str> = key.split('-').collect();
        insert_nested(&mut root, &parts, value.clone());
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
    let child = node.entry(key).or_insert_with(|| Value::Nested(IndexMap::new()));

    if let Value::Nested(ref mut map) = child {
        insert_nested(map, &path[1..], value);
    }
}

fn sanitize_key(key: &str) -> String {
    // Handle numeric keys - prefix with 'n' for valid Nix identifiers
    if key.chars().all(|c| c.is_numeric()) {
        return format!("n{}", key);
    }

    // For keys starting with number, prefix with underscore
    if key.chars().next().map_or(false, |c| c.is_numeric()) {
        return format!("_{}", key);
    }

    // Keep base16 scheme names as-is
    if key.starts_with("base0") {
        return key.to_string();
    }

    // Replace hyphens with underscores for valid Nix identifiers
    key.replace('-', "_")
}

fn write_nix_file(path: &str, structure: &IndexMap<String, Value>, source_file: &str) -> std::io::Result<()> {
    let mut file = fs::File::create(path)?;

    writeln!(file, "# Generated Nix expression for Chiaroscuro Theme Tokens")?;
    writeln!(file, "# Do not edit this file directly. It is generated from {}", source_file)?;
    writeln!(file)?;
    writeln!(file, "{{")?;
    write_value(&mut file, structure, 1)?;
    writeln!(file, "}}")?;

    Ok(())
}

fn write_value<W: Write>(writer: &mut W, node: &IndexMap<String, Value>, indent_level: usize) -> std::io::Result<()> {
    let indent = "  ".repeat(indent_level);

    for (key, value) in node.iter() {
        match value {
            Value::String(s) => {
                // Escape the string value for Nix
                let escaped = s.replace('\\', "\\\\").replace('"', "\\\"");
                writeln!(writer, "{}{} = \"{}\";", indent, key, escaped)?;
            }
            Value::Nested(map) => {
                writeln!(writer, "{}{} = {{", indent, key)?;
                write_value(writer, map, indent_level + 1)?;
                writeln!(writer, "{}}};", indent)?;
            }
        }
    }

    Ok(())
}
