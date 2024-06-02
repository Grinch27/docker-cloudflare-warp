import json
import re
import argparse
import os


def dpkg_to_json(input_filename, output_filename):
    with open(input_filename, "r") as f:
        lines = f.readlines()

    pkgs = {}
    for line in lines:
        if line.startswith("ii"):
            parsed_line_core = re.split(r" {2,}", line)
            if len(parsed_line_core) >= 5:
                status = parsed_line_core[0]
                full_name = parsed_line_core[1]
                if ":" in full_name:
                    package_name, _ = full_name.split(":")
                else:
                    package_name = full_name
                version = parsed_line_core[2]
                architecture = parsed_line_core[3]
                description = parsed_line_core[4].strip()
                pkgs[full_name] = {
                    "Package": package_name,
                    "Version": version,
                    "Architecture": architecture,
                    "Description": description,
                    "Status": status,
                }

    json_output = json.dumps(pkgs, indent=4)

    with open(output_filename, "w") as f:
        f.write(json_output)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert dpkg list to json.")
    parser.add_argument("-i", "--input", type=str, required=True, help="Input file")
    parser.add_argument("-o", "--output", type=str, default=None, help="Output file")
    args = parser.parse_args()

    if args.output:
        output_filename = args.output
    else:
        base_name = os.path.splitext(args.input)[0]
        output_filename = base_name + ".json"

    dpkg_to_json(args.input, output_filename)
    # --input "Z:/cloudflare-warp_linux_amd64.log"
