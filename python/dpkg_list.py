import json
import re
import argparse


def dpkg_to_json(input_filename, output_filename):
    with open(input_filename, "r") as f:
        lines = f.readlines()

    pkgs = {}
    for line in lines:
        if line.startswith("ii"):
            parsed_line_core = re.split(r" {2,}", line)
            if len(parsed_line_core) >= 5:
                name = parsed_line_core[1]
                version = parsed_line_core[2]
                architecture = parsed_line_core[3]
                description = parsed_line_core[4].strip()
                pkgs[name] = {
                    "Version": version,
                    "Architecture": architecture,
                    "Description": description,
                }

    json_output = json.dumps(pkgs, indent=4)

    with open(output_filename, "w") as f:
        f.write(json_output)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert dpkg list to json.")
    parser.add_argument("-i", "--input", type=str, required=True, help="Input file")
    parser.add_argument("-o", "--output", type=str, default=None, help="Output file")
    args = parser.parse_args()

    output_filename = args.output if args.output else args.input

    dpkg_to_json(args.input, output_filename)
    # --input "Z:/cloudflare-warp_linux_amd64.log"
