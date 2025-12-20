# Lightweight Dockerfile for Friendly-Strike 3
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Add the WineHQ repository for the latest versions
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        wget \
    && mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        winehq-stable \
        x11-utils \
        libgl1-mesa-glx:i386 \
        libgl1-mesa-dri:i386 \
        fonts-liberation \
        fonts-dejavu-core \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Wine configuration
ENV WINEARCH=win32
ENV WINEPREFIX=/wine

# Lightweight Wine initialization (no extra fonts)
RUN mkdir -p /wine && \
    wineboot --init 2>/dev/null || true && \
    wineserver -k || true

# Create the game directory
WORKDIR /game

# Copy game files
COPY game/ /game/

# Entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1203 1206

ENTRYPOINT ["/entrypoint.sh"]
CMD ["game"]
