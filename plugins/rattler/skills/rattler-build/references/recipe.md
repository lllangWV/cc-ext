# Recipe File Reference

Complete reference for `recipe.yaml` structure.

## Table of Contents

- [context](#context)
- [package](#package)
- [source](#source)
- [build](#build)
- [requirements](#requirements)
- [tests](#tests)
- [about](#about)
- [outputs](#outputs)

## context

Variables for Jinja string interpolation throughout the recipe.

```yaml
context:
  version: "1.1.0"
  name: imagesize
  build_number: 0
  custom_var: "value"
```

Access with `${{ variable }}` syntax.

## package

Package metadata.

```yaml
package:
  name: my-package       # Lowercase, hyphens allowed, no underscores
  version: "1.0.0"       # Quote to prevent float interpretation
```

## source

Source code location. Supports multiple source types.

### URL Source

```yaml
source:
  url: https://example.com/package-1.0.0.tar.gz
  sha256: abc123def456...
  md5: abc123...                  # Alternative to sha256
  patches:
    - fix-build.patch
    - another.patch
  target_directory: src           # Extract to subdirectory
  file_name: custom-name.tar.gz   # Override downloaded filename
```

### Git Source

```yaml
source:
  git: https://github.com/user/repo
  tag: v1.0.0                     # Or branch, rev
  depth: 1                        # Shallow clone
  expected_commit: abc123...      # Optional verification
  lfs: true                       # Enable Git LFS
```

### Local Path

```yaml
source:
  path: ../local-src
  use_gitignore: true            # Respect .gitignore
```

### Multiple Sources

```yaml
source:
  - url: https://example.com/main.tar.gz
    sha256: abc...
    target_directory: main
  - url: https://example.com/extra.tar.gz
    sha256: def...
    target_directory: extra
```

## build

Build configuration.

### Basic Options

```yaml
build:
  number: 0                       # Increment for rebuilds
  string: custom_build_string     # Custom build string
  script:
    - mkdir build
    - cmake ..
    - make install
  # Or single script file:
  # script: build.sh
```

### Skip Conditions

```yaml
build:
  skip:
    - win                         # Skip Windows
    - osx and py37                # Skip macOS + Python 3.7
    - linux and aarch64           # Skip ARM Linux
```

### noarch Packages

```yaml
build:
  noarch: python    # Pure Python package
  # or
  noarch: generic   # Platform-independent (scripts, data)
```

### Python Options

```yaml
build:
  python:
    entry_points:
      - mycommand = mypackage.main:cli
      - other = mypackage.other:main
    skip_pyc_compilation: false   # Include .pyc files
    version_independent: true     # ABI3 support (stable ABI)
```

### Dynamic Linking

```yaml
build:
  dynamic_linking:
    rpath_allowlist:
      - /usr/lib
      - /opt/custom
    binary_relocation: true
    missing_dso_allowlist:
      - /lib64/ld-linux-x86-64.so.2
    overlinking_behavior: error   # error, warning, ignore
    overdepending_behavior: error
```

### File Inclusion/Exclusion

```yaml
build:
  files:
    include:
      - bin/**
      - lib/**
      - share/mypackage/**
    exclude:
      - "**/*.pyc"
      - "**/__pycache__"
```

### Merge Build Host

For packages where build and host should share environment:

```yaml
build:
  merge_build_and_host_envs: true
```

## requirements

Dependencies across build phases.

### Full Example

```yaml
requirements:
  # Build tools (native platform)
  build:
    - ${{ compiler('c') }}
    - ${{ compiler('cxx') }}
    - cmake
    - make
    - pkg-config

  # Target platform dependencies (installed in build env)
  host:
    - python
    - pip
    - numpy
    - libcurl

  # Runtime dependencies (installed with package)
  run:
    - python
    - ${{ pin_compatible('numpy', min_pin='x.x', max_pin='x') }}

  # Optional runtime constraints
  run_constraints:
    - pytorch >=1.0
    - incompatible-package <0  # Block incompatible packages

  # Automatic downstream dependencies
  run_exports:
    weak:
      - ${{ pin_subpackage(name, lower_bound='x.x') }}
    strong:
      - mylib >=1.0,<2.0

  # Ignore problematic upstream exports
  ignore_run_exports:
    by_name:
      - qt
      - gtk
    from_package:
      - libcurl
      - openssl
```

### Run Exports Strength

- **weak**: Applied only when package is in host dependencies
- **strong**: Applied when package is in build OR host dependencies

## tests

Multiple test types supported. Note: `tests` is plural (list).

### Python Import Test

```yaml
tests:
  - python:
      imports:
        - mypackage
        - mypackage.submodule
        - mypackage.utils
      pip_check: true            # Run pip check (default: true)
```

### Script Test

```yaml
tests:
  - script:
      - mycommand --version
      - mycommand --help
      - python -c "import mypackage; assert mypackage.__version__ == '1.0.0'"
    requirements:
      run:
        - pytest
        - pytest-cov
    files:
      source:
        - tests/
```

### Package Contents Test

```yaml
tests:
  - package_contents:
      files:
        - bin/mycommand
        - lib/libmylib.so
      site_packages:
        - mypackage/__init__.py
        - mypackage/core.py
      bin:
        - mycommand
      lib:
        - libmylib.so       # Unix
        - libmylib.dylib    # macOS
      include:
        - myheader.h
      strict: true          # Fail if extra files present
```

### R Package Test

```yaml
tests:
  - r:
      libraries:
        - dplyr
        - tidyr
        - ggplot2
```

### Perl Module Test

```yaml
tests:
  - perl:
      uses:
        - My::Module
        - Another::Module
```

### Downstream Test

Test that downstream packages still work:

```yaml
tests:
  - downstream:
      - dependent-package
```

## about

Package metadata for documentation and discovery.

```yaml
about:
  homepage: https://example.com
  license: MIT
  license_file: LICENSE
  license_family: MIT            # BSD, GPL, Apache, etc.
  summary: Short one-line description
  description: |
    Longer multi-line description
    of what the package does and
    why you might want to use it.
  repository: https://github.com/user/repo
  documentation: https://docs.example.com
  dev_url: https://github.com/user/repo
```

## outputs

Multiple packages from single recipe.

### Basic Multiple Outputs

```yaml
recipe:
  name: myproject
  version: "1.0.0"

source:
  url: https://example.com/myproject-1.0.0.tar.gz
  sha256: abc...

outputs:
  # Runtime library
  - package:
      name: libmylib
    build:
      script: install-lib.sh
    requirements:
      build:
        - ${{ compiler('c') }}
      host:
        - libcurl
      run:
        - libcurl
      run_exports:
        - ${{ pin_subpackage('libmylib', lower_bound='x.x') }}
    tests:
      - script:
          - test -f $PREFIX/lib/libmylib.so

  # Development headers
  - package:
      name: libmylib-dev
    build:
      script: install-headers.sh
      files:
        include:
          - include/**
    requirements:
      run:
        - ${{ pin_subpackage('libmylib', exact=True) }}

  # Python bindings
  - package:
      name: python-mylib
    build:
      script: pip install . --no-deps -vv
    requirements:
      host:
        - python
        - pip
        - ${{ pin_subpackage('libmylib', exact=True) }}
      run:
        - python
        - ${{ pin_subpackage('libmylib') }}
    tests:
      - python:
          imports:
            - mylib
```

### Shared Build Cache

When outputs share build steps:

```yaml
recipe:
  name: myproject
  version: "1.0.0"

cache:
  build:
    script: shared-build.sh
  requirements:
    build:
      - ${{ compiler('c') }}
      - cmake

outputs:
  - package:
      name: libmylib
    build:
      script: install-lib.sh
  - package:
      name: libmylib-dev
    build:
      script: install-dev.sh
```
