# Friendly-Strike 3 Container

Conteneurisation du jeu Windows **Friendly-Strike 3** pour Linux avec Wine et Podman/Docker.

## Structure

```
├── build/                      # Construction de l'image
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── game/                   # Fichiers du jeu
│
├── scripts/                    # Scripts d'exécution
│   ├── run-game.sh             # Lancer le jeu
│   ├── run-hoster.sh           # Lancer le serveur
│   ├── setup-host-audio.sh     # Config audio serveur
│   └── select-audio-output.sh  # Sélection HDMI/analog
│
├── docker-compose.yml
└── README.md
```

## Installation

```bash
# Cloner
git clone https://github.com/Raynoxis/friendly-strike-3-container.git
cd friendly-strike-3-container

# Construire l'image
podman build -t friendly-strike3:latest ./build

# Configurer l'audio (une seule fois)
sudo ./scripts/setup-host-audio.sh
```

## Utilisation

### Lancer le jeu

```bash
./scripts/run-game.sh
```

### Changer la sortie audio

```bash
./scripts/select-audio-output.sh hdmi     # Sortie HDMI
./scripts/select-audio-output.sh analog   # Sortie haut-parleurs
./scripts/select-audio-output.sh list     # Voir les options
```

### Avec docker-compose

```bash
# Jeu
podman-compose --profile client up game

# Serveur avec GUI
podman-compose --profile server up hoster

# Serveur headless
podman-compose --profile server-headless up -d hoster-headless
```

## Configuration audio

Prérequis sur le serveur hôte :

1. Utilisateur dans le groupe `audio`
2. PipeWire ou PulseAudio actif
3. Socket `/run/user/$(id -u)/pulse/native` existant

Le script `scripts/setup-host-audio.sh` configure tout automatiquement.

## Ports réseau

| Port | Description |
|------|-------------|
| 1203/UDP | Port principal |
| 1206/UDP | Port serveur |

## Licence

Les fichiers de configuration sont libres. Le jeu Friendly-Strike 3 reste la propriété de ses auteurs.
