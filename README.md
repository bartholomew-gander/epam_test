# Test repository

## Contents

- `app` - FastAPI application
- `iac` - Terraform configuration
- `tools` - Python scripts for working with Terraform configuration

### Python virtual envirment

It is recommended to use a virtual environment for Python development and usage of tools.

```bash
python3 -m venv .venv
source .venv/bin/activate
```

## App

### Usage and development

1. Activate Python virtual environment
2. Install dependencies:

```bash
pip install -r app/requirements.txt
```

3. Run the FastAPI application:

```bash
fastapi run app/main.py
```

### Docker

Dockerfile uses port 8000 by default.

1. Build the Docker image:

```bash
docker build -t myapp:latest -f app/Dockerfile app/
```

2. Run the Docker container:

```bash
docker run --rm -p 8000:8000 myapp:latest
```

## Tools

Install dependencies for tools:

```bash
pip install -r tools/requirements.txt
```

Then run the tools as needed.

### tools/generate.py

This script reads the Terraform configuration and generates tfvars file with default values for all variables.

```bash
python tools/generate.py iac/ -v -o tfvars
```
