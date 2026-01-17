# Rattler-Build CLI Reference

## Table of Contents

- [build](#build)
- [test](#test)
- [generate-recipe](#generate-recipe)
- [debug](#debug)
- [publish](#publish)
- [package](#package)
- [rebuild](#rebuild)
- [auth](#auth)

## build

Build conda packages from recipe files.

```bash
rattler-build build [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `-r, --recipe <PATH>` | Path to recipe file (default: recipe.yaml) |
| `-c, --channel <CHANNEL>` | Additional channels for dependencies |
| `-m, --variant-config <PATH>` | Variant configuration file |
| `--target-platform <PLATFORM>` | Cross-compile to platform (linux-64, osx-arm64, etc.) |
| `--output-dir <DIR>` | Output directory for packages |
| `--package-format <FORMAT>` | Package format: tar-bz2, conda, or both |
| `--test` | Run tests after building |
| `--no-build-id` | Disable timestamp in build directory (for caching) |
| `--keep-build` | Keep build environment after completion |
| `--recipe-dir <DIR>` | Build multiple recipes from directory |
| `--skip-existing=all` | Skip packages already in channel |
| `--compression-threads <N>` | Number of compression threads |
| `--no-test` | Skip running tests |

### Examples

```bash
# Basic build
rattler-build build --recipe recipe.yaml

# Build with conda-forge channel
rattler-build build -r recipe.yaml -c conda-forge

# Cross-compile for ARM64 Linux
rattler-build build -r recipe.yaml --target-platform linux-aarch64

# Build with variants
rattler-build build -r recipe.yaml -m variant_config.yaml

# Build multiple recipes
rattler-build build --recipe-dir ./recipes/

# Build with caching support
rattler-build build --no-build-id -r recipe.yaml

# Keep build environment for debugging
rattler-build build --keep-build -r recipe.yaml
```

## test

Test existing conda packages.

```bash
rattler-build test [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `-p, --package-file <PATH>` | Package file to test |
| `-c, --channel <CHANNEL>` | Channels for test dependencies |

### Examples

```bash
rattler-build test --package-file ./mypackage-1.0.0-py311.conda
rattler-build test -p package.tar.bz2 -c conda-forge
```

## generate-recipe

Auto-generate recipes from package registries.

```bash
rattler-build generate-recipe <SOURCE> <PACKAGE> [OPTIONS]
```

### Sources

- `pypi` - Python Package Index
- `cran` - R CRAN repository
- `cpan` - Perl CPAN
- `luarocks` - Lua packages

### Options

| Option | Description |
|--------|-------------|
| `-w, --write` | Write recipe to folder |
| `--version <VERSION>` | Specific package version |
| `-t, --tree` | Generate recipes for all dependencies (CRAN only) |
| `-u, --universe <NAME>` | Select R universe (bioconductor, etc.) |

### Examples

```bash
# Generate Python recipe
rattler-build generate-recipe pypi numpy -w
rattler-build generate-recipe pypi flask --version 2.0.0 -w

# Generate R recipe with dependencies
rattler-build generate-recipe cran dplyr -t -w
rattler-build generate-recipe cran tidyr -u bioconductor -w

# Generate Perl recipe
rattler-build generate-recipe cpan JSON -w
```

## debug

Debug build issues interactively.

```bash
rattler-build debug [OPTIONS]
rattler-build debug-shell
```

### Options

| Option | Description |
|--------|-------------|
| `-r, --recipe <PATH>` | Recipe file to debug |

### Environment Variables

Inside the debug shell:

| Variable | Description |
|----------|-------------|
| `$PREFIX` | Host installation location |
| `$BUILD_PREFIX` | Build tools location |
| `$SRC_DIR` | Source directory |

### Examples

```bash
# Set up build environment without running script
rattler-build debug --recipe recipe.yaml

# Enter shell in latest build environment
rattler-build debug-shell

# Inside shell, run build script with tracing
bash -x conda_build.sh
```

## publish

Build and upload packages to a channel.

```bash
rattler-build publish [OPTIONS] <RECIPE>
```

### Options

| Option | Description |
|--------|-------------|
| `--to <URL>` | Channel URL to publish to |
| `--force` | Overwrite existing packages |

### Examples

```bash
rattler-build publish recipe.yaml --to https://prefix.dev/my-channel
rattler-build publish --to prefix.dev/my-channel --force
```

## package

Inspect or extract conda packages.

```bash
rattler-build package <COMMAND>
```

### Commands

| Command | Description |
|---------|-------------|
| `inspect` | Show package metadata |
| `extract` | Extract package contents |

### Options for inspect

| Option | Description |
|--------|-------------|
| `--all` | Show all metadata details |

### Examples

```bash
rattler-build package inspect package.conda
rattler-build package inspect package.conda --all
rattler-build package extract package.conda
```

## rebuild

Rebuild a package from an existing conda package.

```bash
rattler-build rebuild [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `--package-file <PATH>` | Package file to rebuild |

### Examples

```bash
rattler-build rebuild --package-file mypackage-1.0.0.conda
```

## auth

Manage authentication for channels.

```bash
rattler-build auth <COMMAND>
```

### Commands

| Command | Description |
|---------|-------------|
| `login` | Authenticate with a channel |
| `logout` | Remove authentication |

### Examples

```bash
# prefix.dev (Bearer token)
rattler-build auth login prefix.dev --token <TOKEN>

# anaconda.org (Conda token)
rattler-build auth login conda.anaconda.org --conda-token <TOKEN>

# Self-hosted (Basic auth)
rattler-build auth login my-server.example.com --username <USER> --password <PASS>

# S3 authentication
rattler-build auth login s3://my-bucket --s3-access-key-id <KEY> --s3-secret-access-key <SECRET>

# Remove credentials
rattler-build auth logout prefix.dev
```

## create-patch

Generate patches from modifications made in the source directory.

```bash
rattler-build create-patch [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `--directory <DIR>` | Directory with modifications |
| `--name <NAME>` | Patch file name |
| `--exclude <PATTERN>` | Exclude files matching pattern |
| `--add <FILE>` | Include additional files |

### Examples

```bash
rattler-build create-patch --directory . --name fix-compilation
rattler-build create-patch --exclude "*.log" --add new-file.txt
```
