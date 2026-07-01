# MFA-Temoa Quick Start

This repository supports two installation options.

## Option 1: Using uv

if you have `uv` installed, you can add `temoa` 

```bash
uv init --python 3.12 
uv add jupyterlab ipykernel numpy pandas matplotlib scipy openpyxl temoa
# If you already have a uv environment, you can just add temoa to it:
uv add temoa
```

## Option 2: Using Conda

If you do not have Python `>=3.12`, create a Conda environment from `environment.yml` (it installs `temoa` automatically):

```bash
conda env create -f environment.yml
conda activate mfa-temoa
```

## Get Started in 30 Seconds (Both Options)

In a virtual environment with `temoa` installed, run:

```bash
# Create tutorial files in the current directory
# Creates tutorial_config.toml and tutorial_database.sqlite
cd ./data/2_temoa/20_tutorial
temoa tutorial

# Run the model
temoa run tutorial_config.toml
```
