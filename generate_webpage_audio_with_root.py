import sys
import os
import html

def read_lines(path, skip_hash=False):
    lines = []
    with open(path, 'r', encoding='utf-8') as file:
        for line in file:
            line = line.strip()
            if skip_hash and line.startswith("#"):
                continue
            lines.append(line)
    return lines

def generate_html(title, words, prs, audio, roots, def_roots):
    html_parts = ["""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{}</title>
  <style>
    body {{ font-family: Arial, sans-serif; margin: 2rem; background: #f9f9f9; }}
    h1 {{ text-align: center; color: #2c3e50; }}
    h2 {{ color: #333; }}
    hr {{ border: 1px solid #ccc; margin: 2rem 0; }}
    table {{ width: 100%; border-collapse: collapse; margin-bottom: 2rem; }}
    td, th {{ padding: 0.75rem; border: 1px solid #ddd; text-align: left; font-size: 18px; }}
    audio {{ width: 100%; max-width: 300px; }}

    .root-section {{
      background-color: #e8f0fe;
      border-left: 5px solid #4285f4;
      padding: 1.5rem;
      margin-bottom: 2rem;
      border-radius: 8px;
    }}
    .root-title {{
      font-size: 1.6rem;
      font-weight: bold;
      color: #1a73e8;
    }}
    .root-definition {{
      font-size: 1.3rem;
      color: #333366;
      margin-bottom: 1rem;
    }}
  </style>
</head>
<body>
<h1>{}</h1>
""".format(html.escape(title), html.escape(title))]

    root_index = 0
    for i in range(len(words)):
        if i % 4 == 0 and root_index < len(roots):
            root = roots[root_index]
            raw_definition = def_roots[root_index]

            if root not in ["Number Words", "Medical Words"]:
                # Replace root word with highlighted version inside the definition
                root_escaped = html.escape(root)
                highlight_html = f'<strong class="root-title">{root_escaped}</strong>'
                definition = raw_definition.replace(root, highlight_html)
                audio_filename = root_escaped.replace("/", "_")  # Fix the audio filename

                html_parts.append(f'<div class="root-section" id="{root_escaped}">')
                html_parts.append(f'<div class="root-definition">{definition}</div>')
                html_parts.append(
                    f'<audio controls><source src="root/def_{audio_filename}.wav" type="audio/mpeg">Your browser does not support the audio element.</audio>'
                )
                html_parts.append("</div>")
                html_parts.append("<table>")
                html_parts.append("<thead><tr><th>Word</th><th>Pronunciation</th><th>Audio</th></tr></thead>")
            else:
                html_parts.append(f"<h2>{html.escape(root)}</h2>")

            root_index += 1

        word = html.escape(words[i])
        pronunciation = html.escape(prs[i]) if prs[i] != "null" else ""
        audio_file = html.escape(audio[i]) if audio[i] != "null" else ""

        if pronunciation:
            html_parts.append(f"""<tr>
  <td>{word}</td>
  <td>[{pronunciation}]</td>
  <td><audio controls>
    <source src="audio/{audio_file}.mp3" type="audio/mpeg">
    Your browser does not support the audio element.
  </audio></td>
</tr>""")
        else:
            html_parts.append(f"<tr><td>{word}</td><td colspan='2'></td></tr>")

        if i % 4 == 3 and root_index < len(roots):
            html_parts.append("</table>")

    html_parts.append("</body></html>")
    return "\n".join(html_parts)


def main():
    if len(sys.argv) < 2:
        print("You must add a filename")
        sys.exit(1)

    base_filename = sys.argv[1]
    title = os.path.splitext(os.path.basename(base_filename))[0]

    words = read_lines(base_filename, skip_hash=True)
    prs = read_lines(f"prs_{base_filename}")
    audio = read_lines(f"audio_{base_filename}")
    roots = read_lines(f"root_{base_filename}")
    def_roots = read_lines(f"def_root_{base_filename}")

    html_content = generate_html(title, words, prs, audio, roots, def_roots)

    output_file = f"{base_filename}.html"
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(html_content)

    print(f"✅ HTML generated: {output_file}")

if __name__ == "__main__":
    main()
