# oci-mcp

Public stdio MCP server for Oracle Cloud Infrastructure, built from the public
[`oracle.oci-cloud-mcp-server`](https://pypi.org/project/oracle.oci-cloud-mcp-server/)
package.

Container image:

```
ghcr.io/legido-ai/oci-mcp:latest
```

The image contains no credentials and is public. The OCI signing identity is
provided at runtime through environment variables.

## Usage

```sh
docker run --rm -i \
  --cap-drop=ALL --security-opt=no-new-privileges \
  -e OCI_TENANCY \
  -e OCI_USER \
  -e OCI_FINGERPRINT \
  -e OCI_REGION \
  -e OCI_PRIVATE_KEY_B64 \
  ghcr.io/legido-ai/oci-mcp:latest
```

Required environment:

- `OCI_TENANCY`
- `OCI_USER`
- `OCI_FINGERPRINT`
- `OCI_REGION`
- `OCI_PRIVATE_KEY_B64` (base64-encoded PEM private key)

Optional: `OCI_HOME_REGION` can be passed by the caller when needed.

The entrypoint decodes the key into a mode-600 temporary file, writes a
temporary OCI config, unsets `OCI_PRIVATE_KEY_B64`, and execs the MCP server.
The key is never written to the image or a persistent volume.

## OpenCode MCP config

```json
{
  "mcp": {
    "servers": {
      "oci-cloud": {
        "type": "local",
        "enabled": true,
        "command": [
          "docker", "run", "--rm", "-i",
          "--cap-drop=ALL", "--security-opt=no-new-privileges",
          "-e", "OCI_TENANCY",
          "-e", "OCI_USER",
          "-e", "OCI_FINGERPRINT",
          "-e", "OCI_REGION",
          "-e", "OCI_PRIVATE_KEY_B64",
          "ghcr.io/legido-ai/oci-mcp:latest"
        ]
      }
    }
  }
}
```

The OCI variables already present in the OpenCode container environment are
forwarded with `docker run -e`; no additional Compose `.env` keys are needed.

## Build

```sh
docker build -t oci-mcp .
```

The GitHub workflow builds and pushes multi-arch images (`linux/amd64` and
`linux/arm64`) to GHCR on every push to `main`.
