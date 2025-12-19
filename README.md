# Friendly-Strike 3 Container

Conteneurisation du jeu Windows **Friendly-Strike 3** pour Linux avec Wine et Podman/Docker.

## Fonctionnalités

- Jeu Windows natif fonctionnant sous Linux via Wine
- Affichage X11 local ou distant
- Audio via PulseAudio/PipeWire (HDMI ou analogique)
- Serveur de parties (hoster) avec mode headless

## Prérequis

- Podman ou Docker
- Serveur X11 (local ou distant)
- PipeWire ou PulseAudio pour l'audio
- Les fichiers du jeu Friendly-Strike 3

## Installation

```bash
# Cloner le repo
git clone https://github.com/Raynoxis/friendly-strike-3-container.git
cd friendly-strike-3-container

# Copier les fichiers du jeu dans le dossier game/
mkdir -p game
cp -r /chemin/vers/FriendlyStrike3/* game/

# Construire l'image
podman build -t friendly-strike3:latest .

# Configurer l'audio du serveur (une seule fois)
sudo ./setup-host-audio.sh
```

## Utilisation

### Lancer le jeu

```bash
./run-game.sh
```

### Changer la sortie audio

```bash
# Voir les sorties disponibles
./select-audio-output.sh list

# Activer HDMI
./select-audio-output.sh hdmi

# Activer haut-parleurs
./select-audio-output.sh analog
```

### Avec docker-compose

```bash
# Jeu client
podman-compose --profile client up game

# Serveur avec GUI
podman-compose --profile server up hoster

# Serveur headless
podman-compose --profile server-headless up -d hoster-headless
```

## Structure

```
├── Dockerfile              # Image Wine + jeu
├── docker-compose.yml      # Orchestration
├── entrypoint.sh           # Script démarrage conteneur
├── run-game.sh             # Lancer le jeu
├── run-hoster.sh           # Lancer le serveur
├── setup-host-audio.sh     # Config audio serveur
├── select-audio-output.sh  # Sélection sortie audio
└── game/                   # Fichiers du jeu (non inclus)
```

## Configuration audio

Le son passe par le socket PulseAudio de l'hôte. Prérequis :

1. L'utilisateur doit être dans le groupe `audio`
2. PipeWire/PulseAudio doit être actif
3. Le socket `/run/user/$(id -u)/pulse/native` doit exister

Voir `setup-host-audio.sh` pour la configuration automatique.

## Ports réseau (serveur)

| Port | Description |
|------|-------------|
| 1203/UDP | Port principal FS3 |
| 1206/UDP | Port serveur |

## Licence

Ce projet contient uniquement les fichiers de configuration pour la conteneurisation.
Les fichiers du jeu Friendly-Strike 3 ne sont pas inclus et restent la propriété de leurs auteurs.
