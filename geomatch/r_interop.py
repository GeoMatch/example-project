import json
import logging
import os
import re
import subprocess
from datetime import datetime, timedelta
from subprocess import CompletedProcess
from typing import Any, Dict, Optional

BASE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
R_DIRECTORY = os.path.join(BASE, "rcode")

class SubprocessOutput:
    def __init__(
        self,
        result: CompletedProcess,
        runtime: timedelta,
    ) -> None:
        self.result = result
        self.runtime = runtime

    @property
    def is_error(self) -> bool:
        return self.result.returncode != 0

    @staticmethod
    def deserialize(data: Dict[str, Any]) -> "SubprocessOutput":
        return SubprocessOutput(
            result=CompletedProcess(
                args=[],
                returncode=data["return_code"],
                stdout=data["stdout"],
                stderr=data["stderr"],
            ),
            runtime=timedelta(seconds=data["subprocess_runtime_seconds"]),
        )


def run_subprocess(
    cmd: list[str], extra_env: dict = {}
) -> SubprocessOutput:
    """
    Args:
        message (_type_): stdout or stderr output
        error (bool): If true, message is sterr output

    Returns:
        _type_: Dict for storing in DB
    """
    start = datetime.now()

    env = dict(os.environ, **extra_env)
    res = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        cwd=R_DIRECTORY,
        env=env,
    )
    out = SubprocessOutput(res, datetime.now() - start)
    return out
  
