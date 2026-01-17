---
name: rattler-build
description: Build conda packages with rattler-build. Use when working with recipe.yaml files, building conda packages, cross-compiling for different platforms, generating recipes from PyPI/CRAN, debugging build issues, or publishing packages. Triggers include rattler-build commands, conda package creation, recipe writing, variant configuration, and package testing.
---

# Rattler-Build

Rattler-build is a fast, cross-platform conda package builder written in Rust. It creates standard conda packages installable via pixi, mamba, or conda.

## Quick Reference

### Build packages

```bash
rattler-build build --recipe recipe.yaml
rattler-build build -r recipe.yaml -c conda-forge
rattler-build build --target-platform linux-aarch64  # Cross-compile
rattler-build build --keep-build  # Preserve build env for debugging
rattler-build build --no-build-id  # For sccache/ccache
```

### Generate recipes

```bash
rattler-build generate-recipe pypi numpy -w        # From PyPI
rattler-build generate-recipe cran dplyr -w        # From CRAN
rattler-build generate-recipe pypi flask --version 2.0.0 -w
```

### Test and debug

```bash
rattler-build test --package-file ./package.conda
rattler-build debug --recipe recipe.yaml           # Setup build env
rattler-build debug-shell                          # Enter build shell
```

### Inspect and publish

```bash
rattler-build package inspect package.conda
rattler-build publish recipe.yaml --to https://prefix.dev/my-channel
```

See [references/cli.md](references/cli.md) for complete CLI documentation.

## Recipe File Structure (recipe.yaml)

### Minimal Python Package

```yaml
context:
  version: "1.0.0"

package:
  name: mypackage
  version: ${{ version }}

source:
  url: https://pypi.io/packages/.../mypackage-${{ version }}.tar.gz
  sha256: abc123...

build:
  noarch: python
  script: pip install . --no-deps -vv

requirements:
  host:
    - python >=3.8
    - pip
  run:
    - python >=3.8
    - numpy

tests:
  - python:
      imports:
        - mypackage
```

### Key Sections

| Section | Purpose |
|---------|---------|
| `context` | Variables for Jinja interpolation |
| `package` | Name and version |
| `source` | Source code location (URL, git, path) |
| `build` | Build configuration and scripts |
| `requirements` | Dependencies (build, host, run) |
| `tests` | Test definitions |
| `about` | Package metadata |
| `outputs` | Multiple packages from one recipe |

See [references/recipe.md](references/recipe.md) for complete recipe reference.

## Requirements

### Dependency Types

```yaml
requirements:
  # Build tools (run on native platform for cross-compilation)
  build:
    - ${{ compiler('c') }}
    - cmake
    - make

  # Target platform dependencies (installed in build env)
  host:
    - python
    - numpy
    - libcurl

  # Runtime dependencies (installed with package)
  run:
    - python
    - ${{ pin_compatible('numpy', min_pin='x.x', max_pin='x') }}
```

### Run Exports

Automatically add dependencies to downstream packages:

```yaml
requirements:
  run_exports:
    weak:
      - ${{ pin_subpackage(name, lower_bound='x.x') }}
```

## Jinja Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `compiler(lang)` | Cross-platform compiler | `${{ compiler('c') }}` |
| `pin_subpackage(name, ...)` | Pin to recipe output | `${{ pin_subpackage('mylib', exact=True) }}` |
| `pin_compatible(pkg, ...)` | Pin based on resolved version | `${{ pin_compatible('numpy', max_pin='x') }}` |
| `cdt(pkg)` | Core dependency tree | `${{ cdt('mesa-libgl-devel') }}` |
| `env.get(var, default)` | Environment variable | `${{ env.get('CI', 'false') }}` |

## Platform Selectors

Use `if/then` syntax for conditional dependencies:

```yaml
requirements:
  host:
    - if: unix
      then:
        - libcurl
    - if: win
      then:
        - wincurl
    - if: osx and arm64
      then:
        - accelerate
```

Available selectors: `unix`, `win`, `osx`, `linux`, `x86_64`, `arm64`, `aarch64`

## Build Options

### noarch Packages

```yaml
build:
  noarch: python  # Pure Python, works across platforms
  # or
  noarch: generic  # Platform-independent assets
```

### Entry Points

```yaml
build:
  python:
    entry_points:
      - mycli = mypackage.cli:main
```

### Skip Platforms

```yaml
build:
  skip:
    - win
    - osx and py37
```

## Tests

```yaml
tests:
  # Python imports
  - python:
      imports:
        - mypackage
        - mypackage.submodule
      pip_check: true

  # Script commands
  - script:
      - mycommand --version
      - python -c "import mypackage; print(mypackage.__version__)"
    requirements:
      run:
        - pytest

  # Package contents
  - package_contents:
      files:
        - bin/mycommand
      site_packages:
        - mypackage/__init__.py
```

## Variants (variant_config.yaml)

Build multiple package variants:

```yaml
# variant_config.yaml
python:
  - "3.10"
  - "3.11"
  - "3.12"

numpy:
  - "1.24"
  - "1.26"

zip_keys:
  - [python, numpy]  # Pair versions together

pin_run_as_build:
  numpy:
    max_pin: 'x.x'
```

```bash
rattler-build build -r recipe.yaml -m variant_config.yaml
```

See [references/variants.md](references/variants.md) for advanced variant configuration.

## Cross-Compilation

```bash
rattler-build build --recipe recipe.yaml --target-platform linux-aarch64
```

Supported platforms: `linux-64`, `linux-aarch64`, `osx-64`, `osx-arm64`, `win-64`

## Multiple Outputs

Create multiple packages from one recipe:

```yaml
recipe:
  name: myproject
  version: "1.0.0"

outputs:
  - package:
      name: libmylib
    build:
      script: install-lib.sh
    requirements:
      host:
        - libcurl
      run_exports:
        - ${{ pin_subpackage('libmylib', lower_bound='x.x') }}

  - package:
      name: libmylib-dev
    requirements:
      run:
        - ${{ pin_subpackage('libmylib', exact=True) }}
```

## Debugging Builds

```bash
# Keep build environment after failure
rattler-build build --keep-build --recipe recipe.yaml

# Enter interactive debug shell
rattler-build debug --recipe recipe.yaml
rattler-build debug-shell

# Inside shell:
# $PREFIX - host installation
# $BUILD_PREFIX - build tools
# $SRC_DIR - source directory
bash -x conda_build.sh  # Run with tracing
```

## Common Patterns

### C++ Library

```yaml
package:
  name: mylib
  version: "2.0.0"

source:
  git: https://github.com/user/mylib
  tag: v2.0.0

build:
  script:
    - cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -B build
    - cmake --build build --target install

requirements:
  build:
    - ${{ compiler('cxx') }}
    - cmake
    - ninja
  host:
    - libcurl
  run:
    - libcurl
  run_exports:
    - ${{ pin_subpackage(name, lower_bound='x.x') }}
```

### Python with Extensions

```yaml
package:
  name: mypackage
  version: "1.0.0"

build:
  script: pip install . --no-deps -vv

requirements:
  build:
    - ${{ compiler('c') }}
  host:
    - python
    - pip
    - cython
    - numpy
  run:
    - python
    - ${{ pin_compatible('numpy') }}
```

## Converting from conda-build

| conda-build | rattler-build |
|-------------|---------------|
| `{% set version = "1.0" %}` | `context:` section |
| `{{ variable }}` | `${{ variable }}` |
| `# [win]` selector | `if: win` / `then:` |
| `meta.yaml` | `recipe.yaml` |
| `test:` (singular) | `tests:` (plural, list) |

See [references/migration.md](references/migration.md) for detailed migration guide.

## Integration with Pixi

Use `pixi-build-rattler-build` backend for pixi projects:

```toml
[workspace]
preview = ["pixi-build"]

[package.build]
backend = { name = "pixi-build-rattler-build", version = "*" }
```

## Resources

- Documentation: https://rattler-build.prefix.dev/latest/
- GitHub: https://github.com/prefix-dev/rattler-build
- Recipe Reference: https://rattler-build.prefix.dev/latest/reference/recipe_file/
