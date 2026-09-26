"""Capture an independent evaluation and a worker's final fixture snapshot."""
import argparse
import json
import shutil
import subprocess
import sys
from pathlib import Path
from evaluate import evaluate

parser = argparse.ArgumentParser()
parser.add_argument('checkout', type=Path)
parser.add_argument('destination', type=Path)
parser.add_argument('--elapsed-seconds', required=True, type=int)
args = parser.parse_args()
source = args.checkout.resolve()
destination = args.destination.resolve()
if destination.exists():
    parser.error('destination already exists; preserve previous results')
if args.elapsed_seconds <= 0:
    parser.error('elapsed seconds must be positive')
result = evaluate(source)
tests = subprocess.run([sys.executable, '-m', 'unittest', 'discover', '-s', 'tests', '-v'],
                       cwd=source, capture_output=True, text=True, timeout=30)
result.update({'elapsed_seconds': args.elapsed_seconds,
               'verified_requirements_per_minute': result['requirements_passed']*60/args.elapsed_seconds,
               'project_tests_exit': tests.returncode})
destination.mkdir(parents=True)
shutil.copytree(source, destination/'checkout', ignore=shutil.ignore_patterns('__pycache__', '*.pyc'))
(destination/'acceptance.json').write_text(json.dumps(result, indent=2)+'\n')
(destination/'project-tests.txt').write_text(tests.stdout+tests.stderr)
print(json.dumps({k:v for k,v in result.items() if k != 'groups'}, indent=2))
