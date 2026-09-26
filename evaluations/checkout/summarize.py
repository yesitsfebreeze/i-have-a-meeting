"""Summarize collected results without selecting or excluding individual trials."""
import json
import statistics
from pathlib import Path

root = Path(__file__).parent
trials = []
for pair in range(1, 4):
    for condition in ('baseline', 'skill'):
        name = f'pair-{pair}-{condition}'
        result = json.loads((root/'results'/name/'acceptance.json').read_text())
        trials.append({'trial': name, 'condition': condition,
                       **{key: value for key, value in result.items() if key != 'groups'}})
groups = {}
for condition in ('baseline', 'skill'):
    rows = [row for row in trials if row['condition'] == condition]
    groups[condition] = {
        'runs': len(rows),
        'requirements_passed': sum(row['requirements_passed'] for row in rows),
        'requirements_total': sum(row['requirements_total'] for row in rows),
        'cases_passed': sum(row['cases_passed'] for row in rows),
        'cases_total': sum(row['cases_total'] for row in rows),
        'all_protected_files_preserved': all(all(row['preserved_files'].values()) for row in rows),
        'all_project_tests_pass': all(row['project_tests_exit'] == 0 for row in rows),
        'median_seconds': statistics.median(row['elapsed_seconds'] for row in rows),
        'median_requirements_per_minute': statistics.median(row['verified_requirements_per_minute'] for row in rows),
    }
summary = {'groups': groups, 'trials': trials}
(root/'results'/'summary.json').write_text(json.dumps(summary, indent=2)+'\n')
print(json.dumps(groups, indent=2))
