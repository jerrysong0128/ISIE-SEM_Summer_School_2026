# MFA-Temoa Quick Start

This repository supports two installation options.

## Option 1: Python 3.12+ Already Installed

If your current Python is `>=3.12`, install from PyPI in a virtual environment at the project root (`MFA-Temoa`):

```bash
python -m venv .venv
# Remove existing virtual environment if it exists
rm -rf .venv  
# Deactivate any active virtual environment
deactivate 2>/dev/null || true

# On Linux/macOS
source .venv/bin/activate

# On Windows
.venv\Scripts\activate
pip install temoa
```

## Option 2: No Suitable Python Installed

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
