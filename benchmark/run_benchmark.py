#!/usr/bin/env python3
import os
import csv
import subprocess
import argparse
import xml.etree.ElementTree as ET


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
            problem_file = "problems/"+row["problem_filename"]+ ".gms"
            # order = row["order"]
            # quiet = row["quiet"]
            # sparsity = row["sparsity"]
            # useTSSOS = row["useTSSOS"]
            # tolSOS = row["tolSOS"]
            quiet = "true"
            useTSSOS = "false"
            tolSOS = "1e-6"
            for order in ["2"]:
                for sparsity in ["single"]:

                    # Build subdirectory name
                    subfolder_name = f"{safe_name(problem_file)}-{order}_{sparsity}"
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
                        sparsity,
                        useTSSOS,
                        tolSOS
                    ]

                    print(f"Running: {' '.join(cmd)}")
                    try:
                        subprocess.run(cmd, check=True)
                    except subprocess.CalledProcessError as e:
                        print(f"Error while running {cmd}: {e}")
                    except Exception as e:
                        print(f"Unexpected error while running {cmd}: {e}")
                    continue
        
    output_values_dict = {'time':['Total', 'Julia initialize','Julia prepare', 'Lasserre total','CallbackExternalHyperplaneGeneration'], 'other':['InitialDualObjectiveBound','DualObjectiveBound'] }
    print_sol(output_dir,output_values_dict)

def print_sol(output_dir, output_values_dict):
    # Ensure output_dir exists
    os.makedirs(output_dir, exist_ok=True)
    
    # get list of all subdirectories
    folders = [f for f in os.listdir(output_dir) if os.path.isdir(os.path.join(output_dir, f))]
    folders.sort()

    # store output values
    list_header = ["problem"]
    list_header.extend([v for k in  output_values_dict.keys() for v in output_values_dict[k]]) 
    sol_list = [list_header]

    for f in folders: 
        sol_prob = [f]
        output_dir_problem = os.path.join(output_dir,f)
        
        #check if problem was solved
        try:
            tree = ET.parse(os.path.join(output_dir_problem,"SHOT.osrl"))
        except FileNotFoundError:
            print(f"No solution file found for problem {f}.")
            continue
        
        root = tree.getroot()

        # define namespace 
        ns = {"os": "os.optimizationservices.org"}
        
        # get values form SHOT.osrl
        for k in output_values_dict.keys():
            if k == "time":
                for v in output_values_dict[k]:
                    t = root.find(f".//os:time[@type='{v}']", ns)
                    sol_prob.append(t.text)
            elif k == "other":
                for v in output_values_dict[k]:
                    val = root.find(f".//os:other[@name='{v}']", ns)
                    sol_prob.append(val.attrib.get("value"))
            
        sol_list.append(sol_prob)
    
    # save values in csv
    with open(os.path.join(output_dir,"soshyp_sol.csv"), "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerows(sol_list)




if __name__ == "__main__":
    main()