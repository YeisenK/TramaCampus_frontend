#!/usr/bin/env python3
"""
Derives Flutter-format catalog JSON files from backend catalog sources.
Run from the repo root: python3 tool/sync_catalogs.py

NEVER edit _derived/ files manually — always update the backend source and re-run.
Frontend-authored catalogs (_frontend/) are not touched by this script.
"""

import json
import re
import os
from datetime import date

BACKEND_DIR = os.path.join(
    os.path.dirname(__file__),
    '../../Trama_back/matching_service/src/shared/catalogs',
)
OUT_DIR = os.path.join(
    os.path.dirname(__file__),
    '../assets/catalogs/_derived',
)
VERSION = str(date.today())


def slug(text: str) -> str:
    """Convert a human-readable label to a stable lowercase identifier."""
    s = text.strip().lower()
    s = re.sub(r'[&]', 'and', s)
    s = re.sub(r"['’]", '', s)
    s = re.sub(r'[\s\-/,]+', '_', s)
    s = re.sub(r'[^a-z0-9_À-ɏ]', '', s)  # keep accented chars
    s = re.sub(r'_+', '_', s).strip('_')
    return s


def item_id(key: str) -> str:
    """Backend parameter key → canonical frontend id (lowercase trimmed)."""
    return key.strip().lower()


def build_standard_catalog(name: str, source_file: str, label_map: dict | None = None) -> dict:
    """
    Convert a backend Catalog-struct JSON (with sets/subsets/parameters) to
    Flutter frontend format.
    label_map: optional override for set/subset labels (key = original name, value = display label)
    """
    src = os.path.join(BACKEND_DIR, source_file)
    with open(src) as f:
        data = json.load(f)

    raw_sets = data.get('sets', {})
    raw_subsets = data.get('subsets', {})
    raw_params = data.get('parameters', {})

    # Build set registry
    sets_out = []
    for set_name, set_data in raw_sets.items():
        set_id = slug(set_name)
        child_subset_names = set_data.get('subsets', [])
        subsets_out = []
        for sub_name in child_subset_names:
            sub_id = slug(sub_name)
            sub_label = (label_map or {}).get(sub_name, sub_name)
            subsets_out.append({'id': sub_id, 'label': sub_label})
        set_label = (label_map or {}).get(set_name, set_name)
        sets_out.append({'id': set_id, 'label': set_label, 'subsets': subsets_out})

    # Build item list
    items_out = []
    for key, val in raw_params.items():
        iid = item_id(key)
        item_sets = [slug(s) for s in val.get('sets', [])]
        item_subsets = [slug(s) for s in val.get('subsets', [])]
        items_out.append({
            'id': iid,
            'label': key,  # original human-readable label
            'sets': item_sets,
            'subsets': item_subsets,
        })

    return {
        'catalog': name,
        '_source': f'matching_service/src/shared/catalogs/{source_file}',
        'version': VERSION,
        'sets': sets_out,
        'items': items_out,
    }


def write(name: str, data: dict):
    path = os.path.join(OUT_DIR, f'{name}.json')
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f'  wrote {path}  ({len(data.get("items", data.get("campuses", [])))} items)')


# ── SKILLS ─────────────────────────────────────────────────────────────────────
write('skill', build_standard_catalog('skill', 'skill_catalog.json'))

# ── HOBBIES ────────────────────────────────────────────────────────────────────
write('hobby', build_standard_catalog('hobby', 'hobby_catalog.json'))

# ── RESEARCH INTERESTS ─────────────────────────────────────────────────────────
write('research_interest', build_standard_catalog(
    'research_interest', 'research_interest_catalog.json'))

# ── SPORTS ─────────────────────────────────────────────────────────────────────
write('sport', build_standard_catalog('sport', 'sport_catalog.json'))

# ── MUSIC GENRES ───────────────────────────────────────────────────────────────
write('music_genre', build_standard_catalog('music_genre', 'music_genre_catalog.json'))

# ── PERSONALITY TRAITS ─────────────────────────────────────────────────────────
write('personality_trait', build_standard_catalog(
    'personality_trait', 'personality_trait_catalog.json'))

# ── GOALS ──────────────────────────────────────────────────────────────────────
write('goal', build_standard_catalog('goal', 'goal_catalog.json'))

# ── CAMPUS ─────────────────────────────────────────────────────────────────────
src = os.path.join(BACKEND_DIR, 'campus_catalog.json')
with open(src) as f:
    campus_raw = json.load(f)
write('campus', {
    'catalog': 'campus',
    '_source': 'matching_service/src/shared/catalogs/campus_catalog.json',
    'version': VERSION,
    'items': [
        {
            'id': c['code'],
            'label': c['name'],
            'alias': c['alias'],
            'city': c['city'],
        }
        for c in campus_raw.get('campuses', [])
    ],
})

# ── ACADEMIC (MAJORS) ──────────────────────────────────────────────────────────
src = os.path.join(BACKEND_DIR, 'academic_catalog.json')
with open(src) as f:
    acad_raw = json.load(f)

# Build area registry from all majors
areas: dict[str, str] = {}  # code -> display label
for val in acad_raw.get('majors', {}).values():
    area = val.get('area', '')
    if area and area not in areas:
        area_labels = {
            'BUS': 'Business & Management', 'COM': 'Communication',
            'LAW': 'Law', 'DSN': 'Design', 'FIN': 'Finance',
            'ENG': 'Engineering', 'TEC': 'Technology', 'HLT': 'Health',
            'ARC': 'Architecture', 'EDU': 'Education', 'GLB': 'Global Studies',
            'HUM': 'Humanities', 'SPT': 'Sports', 'MED': 'Medicine',
            'SCI': 'Sciences', 'ART': 'Arts',
        }
        areas[area] = area_labels.get(area, area)

areas_out = [{'id': code, 'label': label} for code, label in sorted(areas.items())]
items_out = []
for val in acad_raw.get('majors', {}).values():
    items_out.append({
        'id': val['code'],        # stable 3-5 char code sent to backend
        'label': val['name'],
        'area': val.get('area', ''),
    })
# Sort by area then label for a better grouped UX
items_out.sort(key=lambda x: (x['area'], x['label']))

write('academic', {
    'catalog': 'academic',
    '_source': 'matching_service/src/shared/catalogs/academic_catalog.json',
    'version': VERSION,
    'areas': areas_out,
    'items': items_out,
})

print('\nDone. All derived catalogs written to assets/catalogs/_derived/')
