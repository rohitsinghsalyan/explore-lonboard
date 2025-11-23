# Use Python 3.12 slim image as base
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install uv package manager
RUN pip install --no-cache-dir uv

# Copy pyproject.toml to install dependencies
COPY pyproject.toml .

COPY requirements.txt .
# Install dependencies using uv
RUN uv pip install --system --no-cache-dir -r requirements.txt

# Expose Jupyter port
EXPOSE 8888

# Default command starts Jupyter
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
