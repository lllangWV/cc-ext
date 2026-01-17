# Variants Configuration

Build multiple package variants for different Python versions, NumPy versions, compilers, etc.

## Table of Contents

- [Basic Usage](#basic-usage)
- [variant_config.yaml Structure](#variant_configyaml-structure)
- [Zip Keys](#zip-keys)
- [Pin Run As Build](#pin-run-as-build)
- [How Variants Work](#how-variants-work)
- [Advanced Patterns](#advanced-patterns)

## Basic Usage

```bash
rattler-build build -r recipe.yaml -m variant_config.yaml
```

Multiple variant files can be combined:

```bash
rattler-build build -r recipe.yaml -m base.yaml -m python.yaml -m cuda.yaml
```

## variant_config.yaml Structure

```yaml
# Define variant values
python:
  - "3.10"
  - "3.11"
  - "3.12"

numpy:
  - "1.24"
  - "1.26"

# Compiler settings
c_compiler:
  - gcc
c_compiler_version:
  - "11"

cxx_compiler:
  - g++
cxx_compiler_version:
  - "11"

# Control variant combinations
zip_keys:
  - [python, numpy]

# Runtime pinning strategy
pin_run_as_build:
  numpy:
    max_pin: 'x.x'
  python:
    max_pin: 'x.x'
```

## Zip Keys

Without zip_keys, all combinations are built (cartesian product):
- 3 Python × 2 NumPy = 6 variants

With zip_keys, versions are paired:
- Python 3.10 + NumPy 1.24
- Python 3.11 + NumPy 1.26
- = 2 variants (shortest list determines count)

```yaml
zip_keys:
  - [python, numpy]              # Pair these together
  - [c_compiler, cxx_compiler]   # Pair compilers
```

Multiple zip groups are independent:

```yaml
zip_keys:
  - [python, numpy]
  - [cuda, cudnn]
```

This creates: (python × numpy pairs) × (cuda × cudnn pairs)

## Pin Run As Build

Controls how host dependencies are pinned in run requirements.

```yaml
pin_run_as_build:
  numpy:
    min_pin: 'x.x.x'    # Minimum version constraint
    max_pin: 'x.x'      # Maximum version constraint
  python:
    min_pin: 'x.x'
    max_pin: 'x.x'
```

Pin notation:
- `x` - Major version only (e.g., `>=1,<2`)
- `x.x` - Major.minor (e.g., `>=1.24,<1.25`)
- `x.x.x` - Full version (e.g., `>=1.24.0,<1.24.1`)

## How Variants Work

### Automatic Application

Variants are applied when:
1. A dependency in `requirements.host` matches a variant key
2. The dependency has no explicit version constraint

```yaml
# variant_config.yaml
python:
  - "3.10"
  - "3.11"

# recipe.yaml
requirements:
  host:
    - python      # Uses variant: builds for 3.10 and 3.11
    - numpy       # No variant: uses latest available
```

### Explicit Constraints Override

Explicit version constraints override variants:

```yaml
requirements:
  host:
    - python >=3.10,<3.12   # Ignores python variant
    - python                 # Uses python variant
```

### Build Hash

The build hash (e.g., `py311h123abc`) includes variant values to distinguish builds.

## Advanced Patterns

### Compiler Variants

```yaml
c_compiler:
  - gcc
  - clang

c_compiler_version:
  - "11"
  - "14"

zip_keys:
  - [c_compiler, c_compiler_version]
```

### CUDA Variants

```yaml
cuda:
  - "11.8"
  - "12.0"
  - "12.1"

cudnn:
  - "8.6"
  - "8.9"
  - "8.9"

zip_keys:
  - [cuda, cudnn]
```

### Platform-Specific Variants

Use selectors in variant files:

```yaml
# Linux variants
c_compiler:
  - gcc
c_compiler_version:
  - "11"

# macOS variants (in separate file or with selectors)
# Note: rattler-build handles this via target-platform
```

### Conditional Dependencies Based on Variants

```yaml
requirements:
  host:
    - python
    - if: py >= 311
      then:
        - tomllib
    - if: py < 311
      then:
        - tomli
```

### Extending Variant Matrices

Create specialized builds:

```yaml
# base_variants.yaml
python:
  - "3.10"
  - "3.11"
  - "3.12"

# cuda_variants.yaml
cuda:
  - "11.8"
  - "12.0"
```

```bash
# CPU builds
rattler-build build -r recipe.yaml -m base_variants.yaml

# GPU builds
rattler-build build -r recipe.yaml -m base_variants.yaml -m cuda_variants.yaml
```

### Migrators

For updating packages across an ecosystem:

```yaml
# migrator.yaml
__migrator:
  migration_number: 1

numpy:
  - "2.0"
```

### conda-forge Compatibility

rattler-build is compatible with conda-forge's variant config format. Common conda-forge patterns:

```yaml
# conda_build_config.yaml (conda-forge style)
python:
  - 3.10
  - 3.11
  - 3.12

numpy:
  - 1.24
  - 1.26

zip_keys:
  -
    - python
    - numpy

pin_run_as_build:
  python:
    min_pin: x.x
    max_pin: x.x
```
