# Packetbeat Docker Container

# Build

Download the official image from Docker Hub:

```
# docker pull proteansec/packetpbeat
```

# Run

Run the image by giving it host network permissions in order to be able to sniff the packets from the host network interfaces.

```
docker run --net=host -d proteansec/packetbeat app:start
```
