# Dockerfile léger pour Friendly-Strike 3
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Ajout du dépôt WineHQ pour les dernières versions
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
        xvfb \
        x11-utils \
        libgl1-mesa-glx:i386 \
        libgl1-mesa-dri:i386 \
        fonts-liberation \
        fonts-dejavu-core \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configuration de Wine
ENV WINEARCH=win32
ENV WINEPREFIX=/wine
ENV DISPLAY=:99

# Initialisation légère de Wine (sans polices externes)
RUN mkdir -p /wine && \
    wineboot --init 2>/dev/null || true && \
    wineserver -k || true

# Création du répertoire du jeu
WORKDIR /game

# Copie des fichiers du jeu
COPY game/ /game/

# Script de démarrage
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1203 1206

ENTRYPOINT ["/entrypoint.sh"]
CMD ["game"]
