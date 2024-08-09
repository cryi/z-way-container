Simple container for running z-way-server in docker on aarch64.

Sample compose for orange pi 5 Pro 

```yaml
services:
  z-way-server:
 	image: ghcr.io/cryi/z-way-container:latest
    devices:
      - /dev/ttyS2:/dev/ttyAMA0
    ports:
      - "8083:8083"
    volumes:
	  # Persists z-way-server data
      - ./data:/opt/z-way-server
	  # Persists z-way-server services, this is needed because services are not part of image
      - ./services:/etc/init.d/
    restart: unless-stopped
```

NOTE: The z-way is installed on first run and persisted into volumes.