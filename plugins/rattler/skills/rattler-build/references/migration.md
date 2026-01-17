# Migration from conda-build

Guide for converting conda-build recipes (meta.yaml) to rattler-build (recipe.yaml).

## Table of Contents

- [Quick Reference](#quick-reference)
- [Automatic Conversion](#automatic-conversion)
- [Syntax Changes](#syntax-changes)
- [Section-by-Section Migration](#section-by-section-migration)
- [Common Patterns](#common-patterns)

## Quick Reference

| conda-build | rattler-build |
|-------------|---------------|
| `meta.yaml` | `recipe.yaml` |
| `{% set version = "1.0" %}` | `context:` section |
| `{{ variable }}` | `${{ variable }}` |
| `# [win]` selector comment | `if: win` / `then:` blocks |
| `test:` (singular) | `tests:` (plural, list) |
| `git_url`, `git_rev` | `git:`, `tag:` |
| `build.run_exports` | `requirements.run_exports` |
| `build.ignore_run_exports` | `requirements.ignore_run_exports.by_name` |
| `bld.bat`, `build.sh` | `build.bat`, `build.sh` or inline `script:` |

## Automatic Conversion

### Using conda-recipe-manager

```bash
# Install
pip install conda-recipe-manager

# Convert
conda-recipe-manager convert meta.yaml > recipe.yaml
```

### Using feedrattler (conda-forge)

For conda-forge feedstocks, use the feedrattler tool for automated conversion.

## Syntax Changes

### Variables and Jinja

**conda-build:**
```yaml
{% set name = "mypackage" %}
{% set version = "1.0.0" %}

package:
  name: {{ name }}
  version: {{ version }}
```

**rattler-build:**
```yaml
context:
  name: mypackage
  version: "1.0.0"

package:
  name: ${{ name }}
  version: ${{ version }}
```

Note the `$` prefix: `{{ }}` becomes `${{ }}`.

### Selectors

**conda-build:**
```yaml
requirements:
  host:
    - libcurl  # [unix]
    - wincurl  # [win]
    - python >=3.8  # [py>=38]
```

**rattler-build:**
```yaml
requirements:
  host:
    - if: unix
      then:
        - libcurl
    - if: win
      then:
        - wincurl
    - if: py >= 38
      then:
        - python >=3.8
```

### Inline Jinja (alternative)

```yaml
requirements:
  run:
    - ${{ "pywin32" if win }}
    - ${{ "python >=3.8" if py >= 38 else "python" }}
```

## Section-by-Section Migration

### Source

**conda-build:**
```yaml
source:
  url: https://example.com/{{ name }}-{{ version }}.tar.gz
  sha256: abc123...
  git_url: https://github.com/user/repo
  git_rev: v1.0.0
  git_depth: 1
```

**rattler-build:**
```yaml
source:
  url: https://example.com/${{ name }}-${{ version }}.tar.gz
  sha256: abc123...
  # OR for git:
  git: https://github.com/user/repo
  tag: v1.0.0
  depth: 1
```

### Build Section

**conda-build:**
```yaml
build:
  number: 0
  skip: true  # [win]
  script: python setup.py install
  entry_points:
    - mycli = mypackage:main
  run_exports:
    - {{ pin_subpackage(name, max_pin='x.x') }}
  ignore_run_exports:
    - qt
```

**rattler-build:**
```yaml
build:
  number: 0
  skip:
    - win
  script: python setup.py install
  python:
    entry_points:
      - mycli = mypackage:main

requirements:
  run_exports:
    weak:
      - ${{ pin_subpackage(name, max_pin='x.x') }}
  ignore_run_exports:
    by_name:
      - qt
```

### Requirements

**conda-build:**
```yaml
requirements:
  build:
    - {{ compiler('c') }}
  host:
    - python
    - numpy
  run:
    - python
    - {{ pin_compatible('numpy') }}
  run_constrained:
    - pytorch >=1.0
```

**rattler-build:**
```yaml
requirements:
  build:
    - ${{ compiler('c') }}
  host:
    - python
    - numpy
  run:
    - python
    - ${{ pin_compatible('numpy') }}
  run_constraints:
    - pytorch >=1.0
```

Note: `run_constrained` becomes `run_constraints`.

### Test Section

**conda-build:**
```yaml
test:
  imports:
    - mypackage
  commands:
    - mycommand --version
  requires:
    - pytest
```

**rattler-build:**
```yaml
tests:
  - python:
      imports:
        - mypackage
  - script:
      - mycommand --version
    requirements:
      run:
        - pytest
```

Key change: `test:` (singular) becomes `tests:` (plural list).

### About Section

**conda-build:**
```yaml
about:
  home: https://example.com
  license: MIT
  license_file: LICENSE
  summary: Short description
  dev_url: https://github.com/user/repo
  doc_url: https://docs.example.com
```

**rattler-build:**
```yaml
about:
  homepage: https://example.com
  license: MIT
  license_file: LICENSE
  summary: Short description
  repository: https://github.com/user/repo
  documentation: https://docs.example.com
```

Note: `home` → `homepage`, `dev_url` → `repository`, `doc_url` → `documentation`.

### Outputs (Multiple Packages)

**conda-build:**
```yaml
outputs:
  - name: libmylib
    script: install-lib.sh
    requirements:
      run_exports:
        - {{ pin_subpackage('libmylib', max_pin='x.x') }}
  - name: libmylib-devel
    requirements:
      run:
        - {{ pin_subpackage('libmylib', exact=True) }}
```

**rattler-build:**
```yaml
outputs:
  - package:
      name: libmylib
    build:
      script: install-lib.sh
    requirements:
      run_exports:
        weak:
          - ${{ pin_subpackage('libmylib', max_pin='x.x') }}
  - package:
      name: libmylib-devel
    requirements:
      run:
        - ${{ pin_subpackage('libmylib', exact=True) }}
```

## Common Patterns

### noarch Python Package

**conda-build:**
```yaml
build:
  noarch: python
  script: {{ PYTHON }} -m pip install . -vv
```

**rattler-build:**
```yaml
build:
  noarch: python
  script: pip install . --no-deps -vv
```

### Skip Based on Python Version

**conda-build:**
```yaml
build:
  skip: true  # [py<38]
```

**rattler-build:**
```yaml
build:
  skip:
    - py < 38
```

### Platform-Specific Dependencies

**conda-build:**
```yaml
requirements:
  run:
    - pywin32  # [win]
    - pyobjc  # [osx]
```

**rattler-build:**
```yaml
requirements:
  run:
    - if: win
      then:
        - pywin32
    - if: osx
      then:
        - pyobjc
```

### Pin Functions

**conda-build:**
```yaml
{{ pin_subpackage('pkg', max_pin='x.x') }}
{{ pin_compatible('numpy', max_pin='x') }}
```

**rattler-build:**
```yaml
${{ pin_subpackage('pkg', max_pin='x.x') }}
${{ pin_compatible('numpy', max_pin='x') }}
```

Parameters are the same, just add `$` prefix to Jinja.

### Compiler Functions

**conda-build:**
```yaml
- {{ compiler('c') }}
- {{ compiler('cxx') }}
- {{ compiler('fortran') }}
```

**rattler-build:**
```yaml
- ${{ compiler('c') }}
- ${{ compiler('cxx') }}
- ${{ compiler('fortran') }}
```

### CDT Packages

**conda-build:**
```yaml
- {{ cdt('mesa-libgl-devel') }}
```

**rattler-build:**
```yaml
- ${{ cdt('mesa-libgl-devel') }}
```
