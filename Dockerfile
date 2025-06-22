FROM python:3.11-slim

# Install system dependencies for pymssql and FreeTDS
RUN apt-get update && apt-get install -y \
    freetds-dev \
    freetds-bin \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the source code
COPY src/ ./src/
COPY pyproject.toml .
COPY README.md .

# Install the package
RUN pip install -e .

# Set environment variables with defaults
ENV MSSQL_SERVER=localhost
ENV MSSQL_DATABASE=""
ENV MSSQL_USER=""
ENV MSSQL_PASSWORD=""
ENV MSSQL_PORT=""
ENV MSSQL_ENCRYPT=false
ENV MSSQL_WINDOWS_AUTH=false

# Run the MCP server
CMD ["python", "-m", "mssql_mcp_server"]