import json
import os
import replicate
from pathlib import Path
import requests


def generate_image(prompt, output_path):
    # Check if the file already exists
    if os.path.exists(output_path):
        print(f"Image already exists at {output_path}. Skipping generation.")
        return

    input_data = {"prompt": prompt, "output_format": "webp"}
    output = replicate.run("black-forest-labs/flux-dev", input=input_data)

    # Assuming the output is a list with the image URL as the first item
    image_url = output[0]

    response = requests.get(image_url)
    with open(output_path, "wb") as f:
        f.write(response.content)

    print(f"Image generated and saved to {output_path}")


def process_jsonl(input_file, output_dir):
    Path(output_dir).mkdir(parents=True, exist_ok=True)

    with open(input_file, "r") as f:
        for line in f:
            data = json.loads(line)
            project_data = data["data"]["project"]
            project_key = data["data"]["key"]
            project_description = project_data["projectDescription"]

            output_path = os.path.join(output_dir, f"{project_key}.webp")
            generate_image(project_description, output_path)


if __name__ == "__main__":
    import sys

    # if len(sys.argv) != 3:
    #     print("Usage: python script.py <input_jsonl_file> <output_directory>")
    #     sys.exit(1)

    input_file = sys.argv[1] if len(sys.argv) > 1 else "./static/ideas/positive.jsonl"
    output_dir = sys.argv[2] if len(sys.argv) > 2 else "./static/ideas/images_dev"

    process_jsonl(input_file, output_dir)
