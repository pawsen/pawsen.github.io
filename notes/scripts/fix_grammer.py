import difflib
from pathlib import Path
import language_tool_python
import sys
import argparse

def should_skip_line(line):
    """Check if the line should be skipped for grammar checking"""
    stripped = line.strip()
    
    # Skip empty lines, very short lines, or lines without letters
    if len(stripped) < 3 or not any(c.isalpha() for c in line):
        return True
        
    # Skip Org-mode specific lines
    if (stripped.startswith('{{{') and stripped.endswith('}}}')) or \
            stripped.startswith('#') or stripped.startswith(':'):
        return True
        
    return False

def clean_org_syntax(text):
    """Remove Org-mode syntax elements from text before checking"""
    import re
    
    # Remove [[links]], keeping only the description if present
    text = re.sub(r'\[\[([^][]*?)(?:\[([^][]*)\])?\]\]', 
                 lambda m: m.group(2) if m.group(2) else m.group(1), text)
    
    # Remove ~code~ and =verbatim= markers
    text = re.sub(r'[~=]([^~=\n]+)[~=]', r'\1', text)
    
    # Remove file: and http links that might be in the middle of text
    text = re.sub(r'\b(file|https?):[^\s]+', '', text)
    
    return text

def main():
    parser = argparse.ArgumentParser(description='Check and correct grammar in a text file.')
    parser.add_argument('input_file', help='Path to the input file')
    parser.add_argument('--lang', default='en-US', 
                       help='Language code for grammar checking (default: en-US)')
    args = parser.parse_args()

    input_path = Path(args.input_file)
    if not input_path.exists():
        print(f"Error: File '{input_path}' not found.")
        sys.exit(1)

    original_text = input_path.read_text(encoding="utf-8")
    lines = original_text.splitlines(keepends=True)

    tool = language_tool_python.LanguageTool(args.lang)
    corrected_lines = []

    for line in lines:
        if should_skip_line(line):
            corrected_lines.append(line)
            continue

        # Clean Org-mode syntax before checking
        clean_line = clean_org_syntax(line)
        
        # Only check if there's still text left after cleaning
        if any(c.isalpha() for c in clean_line):
            matches = tool.check(clean_line)
            corrected_clean_line = language_tool_python.utils.correct(clean_line, matches)
            
            # Only modify the original line if corrections were made
            if corrected_clean_line != clean_line:
                corrected_lines.append(corrected_clean_line)
            else:
                corrected_lines.append(line)
        else:
            corrected_lines.append(line)

    corrected_text = ''.join(corrected_lines)

    diff = difflib.unified_diff(
        original_text.splitlines(keepends=True),
        corrected_text.splitlines(keepends=True),
        fromfile=str(input_path),
        tofile=str(input_path) + ".corrected",
    )

    print("".join(diff))

if __name__ == "__main__":
    main()
