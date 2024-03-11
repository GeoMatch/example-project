import argparse
from r_interop import run_subprocess

def run_r_sync():
    """
    Runs R in subprocess synchronously
    """
    res = run_subprocess(["Rscript", "pipeline_entry_example.R"])
    print(res.result.stderr)
    print(res.result.stdout)

if __name__ == "__main__":
    run_r_sync()
