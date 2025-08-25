#!/usr/bin/env python3
import os
import csv
import subprocess
import argparse


def safe_name(name: str) -> str:
    """Strip directory and extension, and make it filesystem-safe."""
    base = os.path.splitext(os.path.basename(name))[0]
    return base.replace("/", "_").replace("\\", "_")

def main():
    # ---------------------------
    # Parse command-line arguments
    # ---------------------------
    parser = argparse.ArgumentParser(
        description="Run benchmarks with test_lasserre on a list of problems."
    )
    parser.add_argument(
        "--executable", "-e", required=True,
        help="Path to the test_lasserre executable"
    )
    parser.add_argument(
        "--problem_list", "-p", required=True,
        help="Path to the problem_list.csv file"
    )
    parser.add_argument(
        "--output_dir", "-o", required=True,
        help="Directory to store all result files"
    )

    args = parser.parse_args()

    executable = args.executable
    problem_list = args.problem_list
    output_dir = args.output_dir

    # Ensure output_dir exists
    os.makedirs(output_dir, exist_ok=True)

    # ---------------------------
    # Read CSV and run executable
    # ---------------------------
    with open(problem_list, newline='') as csvfile:
        filtered_lines = (line for line in csvfile if not line.strip().startswith("#"))
        reader = csv.DictReader(filtered_lines)

        for row in reader:
            problem_file = row["problem_filename"]
            order = row["order"]
            assign = row["assign"]

            # Build subdirectory name
            subfolder_name = f"{safe_name(problem_file)}-{order}_{assign}"
            problem_output_dir = os.path.join(output_dir, subfolder_name)
            
            # Skip if already exists
            if os.path.exists(problem_output_dir):
                print(f"Skipping {problem_file} (already exists: {problem_output_dir})")
                continue
            
            os.makedirs(problem_output_dir, exist_ok=True)
            quiet = "true"
            log_file = os.path.join(problem_output_dir, "SHOT.log")
            # Build command
            cmd = [
                executable,
                problem_file,
                problem_output_dir,
                "SHOT.opt",
                order,
                quiet,
                assign
            ]

            print(f"Running: {' '.join(cmd)}")
            try:
                subprocess.run(cmd, check=True)
            except subprocess.CalledProcessError as e:
                print(f"Error while running {cmd}: {e}")


if __name__ == "__main__":
    main()