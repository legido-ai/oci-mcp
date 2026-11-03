FROM python:3.14-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Public OCI MCP server package, installed into an isolated venv.
RUN python -m venv /opt/oci-mcp \
    && /opt/oci-mcp/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/oci-mcp/bin/pip install --no-cache-dir oracle.oci-cloud-mcp-server

COPY oci-mcp-entrypoint /usr/local/bin/oci-mcp-entrypoint
RUN chmod 0755 /usr/local/bin/oci-mcp-entrypoint

USER 10001:10001
ENTRYPOINT ["/usr/local/bin/oci-mcp-entrypoint"]
