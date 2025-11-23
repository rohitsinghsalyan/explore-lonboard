#!/bin/bash
# Helper script to run Jupyter notebooks with uv inside the Docker container

set -e

NOTEBOOK_PATH="${1:-.}"

if [ -z "$1" ]; then
    echo "Usage: $0 <notebook_path>"
    echo "Example: $0 examples/data-filter-extension.ipynb"
    exit 1
fi

# Check if notebook file exists
if [ ! -f "$NOTEBOOK_PATH" ]; then
    echo "Error: Notebook file not found: $NOTEBOOK_PATH"
    exit 1
fi

echo "Running notebook: $NOTEBOOK_PATH"
docker-compose exec lonboard-app jupyter nbconvert --to notebook --execute "$NOTEBOOK_PATH" --output-dir=/app/notebooks
echo "Notebook execution completed!"
