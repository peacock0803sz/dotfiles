#!/usr/bin/env python3

import shutil
import subprocess
from datetime import datetime
from pathlib import Path

MAX_BITES = 10**6


def get_nvim_log_path():
    cmd = ["nvim", "--headless", "-c", "echo stdpath('log') | q"]
    result = subprocess.run(cmd, capture_output=True)
    return Path(result.stderr.decode().strip())


def main():
    today = datetime.today().date().isoformat()

    for path in get_nvim_log_path().rglob("*.log"):
        dest = path.parent / f"{path.stem}.{today}.log"
        if MAX_BITES < path.lstat().st_size:
            print(f"{path.name} is large, moving to {dest.name}")
            _ = shutil.move(path, dest)


if __name__ == "__main__":
    main()
