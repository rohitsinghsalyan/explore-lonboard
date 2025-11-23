# Lonboard + DuckDB Exploration

A containerized application for exploring geospatial data using Lonboard (interactive web maps) and DuckDB (in-process SQL database).

## Features

- **Python 3.12**: Latest Python runtime
- **Lonboard**: Interactive geospatial data visualization
- **DuckDB**: Fast in-process SQL database for data analysis
- **Jupyter Notebook**: Interactive data exploration
- **uv Package Manager**: Fast Python package installation
- **Docker & Docker Compose**: Containerized environment with volume syncing

## Requirements

- Docker
- Docker Compose

## Quick Start

### 1. Build the Docker Image

```bash
make build
```

Or manually:

```bash
docker-compose build
```

### 2. Start the Application

```bash
make up
```

Or manually:

```bash
docker-compose up -d
```

### 3. Access Jupyter Notebook

Get the Jupyter URL from the logs:

```bash
make logs
```

Look for a URL like `http://127.0.0.1:8888/?token=...`

Open it in your browser.

### 4. Run Example Notebooks

Execute the data filter extension example:

```bash
docker-compose exec lonboard-app jupyter nbconvert --to notebook --execute examples/data-filter-extension.ipynb
```

Or use `uvx`:

```bash
docker-compose exec lonboard-app bash -c "cd /app && uvx jupyter run examples/data-filter-extension.ipynb"
```

## Project Structure

```
├── Dockerfile              # Docker image configuration
├── docker-compose.yml      # Docker Compose configuration
├── Makefile                # Make commands for common tasks
├── pyproject.toml          # Python project configuration with uv
├── .env.example            # Example environment variables
├── examples/               # Example notebooks
│   └── data-filter-extension.ipynb
├── notebooks/              # Your Jupyter notebooks
├── data/                   # Data files directory
└── README.md               # This file
```

## Common Commands

### Using Make

```bash
make build      # Build Docker image
make up         # Start container in background
make down       # Stop container
make logs       # View container logs
make shell      # Access container shell
make clean      # Remove containers and clean up
```

### Using Docker Compose Directly

```bash
# Start in foreground
docker-compose up

# Start in background
docker-compose up -d

# Stop
docker-compose down

# View logs
docker-compose logs -f

# Execute command in container
docker-compose exec lonboard-app bash
```

## File Synchronization

The following directories are synced between your host and the container:

- `./notebooks/` → `/app/notebooks` - Your Jupyter notebooks
- `./data/` → `/app/data` - Data files
- `./examples/` → `/app/examples` - Example notebooks

Any changes to files in these directories on your host are immediately reflected in the container.

## Usage Examples

### Load and Query Data with DuckDB

```python
import duckdb
import pandas as pd

# Create connection
con = duckdb.connect(':memory:')

# Load CSV
df = pd.read_csv('/app/data/your_data.csv')

# Query with SQL
result = con.execute("SELECT * FROM df WHERE column > 100").fetchall()
```

### Visualize with Lonboard

```python
from lonboard import Map, ScatterplotLayer
import duckdb

con = duckdb.connect(':memory:')
df = con.execute("SELECT latitude, longitude FROM locations").df()

layer = ScatterplotLayer.from_data_frame(
    df,
    get_position=['longitude', 'latitude'],
)

map_view = Map(layers=[layer])
map_view
```

## Environment Variables

Create a `.env` file based on `.env.example` to customize:

```bash
cp .env.example .env
```

## Troubleshooting

### Port Already in Use

If port 8888 is already in use, modify the port mapping in `docker-compose.yml`:

```yaml
ports:
  - "8889:8888"  # Change 8889 to your desired port
```

### Jupyter Token/Password

If you want to set a Jupyter token, edit `docker-compose.yml`:

```yaml
command: >
  bash -c "jupyter notebook 
  --ip=0.0.0.0 
  --port=8888 
  --no-browser 
  --allow-root 
  --NotebookApp.token='your_token_here'"
```

### Container Won't Start

Check logs:

```bash
make logs
```

Rebuild the image:

```bash
make build
```

## Development

To add new Python packages:

1. Add them to `pyproject.toml`
2. Rebuild the Docker image:

```bash
make build
```

## License

See LICENSE file for details.