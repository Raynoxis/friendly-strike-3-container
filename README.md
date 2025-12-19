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

### Lancer le jeu (solo)

```bash
./scripts/run-game.sh
```

### Changer la sortie audio

```bash
./scripts/select-audio-output.sh hdmi     # Sortie HDMI
./scripts/select-audio-output.sh analog   # Sortie haut-parleurs
./scripts/select-audio-output.sh list     # Voir les options
```

## Jeu en réseau local (LAN)

### 1. Lancer le serveur (Hoster)

```bash
podman-compose --profile server up hoster
```

Ou manuellement :

```bash
podman run --rm -d \
    --network=host \
    -e DISPLAY=$DISPLAY \
    -v ./build/game/FS3hoster/Data:/game/FS3hoster/Data \
    -v ./build/game/Arenes:/game/Arenes \
    --name fs3-hoster \
    friendly-strike3:latest hoster
```

### 2. Lancer le client (Jeu)

Sur la même machine ou une autre machine du réseau :

```bash
./scripts/run-game.sh
```

### 3. Rejoindre la partie

1. **Dans le Hoster** : Sélectionne une arène, configure les options, clique sur "Héberger"
2. **Dans le Jeu** : Menu "Multijoueur" → "Réseau local" → Sélectionne le serveur

### Connexion depuis un autre PC

Les autres joueurs du réseau local peuvent rejoindre en entrant l'IP du serveur dans le jeu.

Assurez-vous que les ports sont ouverts :
- **1203/UDP** - Port principal
- **1206/UDP** - Port serveur

## Configuration audio

Prérequis sur le serveur hôte :

1. Utilisateur dans le groupe `audio`
2. PipeWire ou PulseAudio actif
3. Socket `/run/user/$(id -u)/pulse/native` existant

Le script `scripts/setup-host-audio.sh` configure tout automatiquement.

## Commandes utiles

```bash
# Voir les conteneurs FS3 en cours
podman ps --filter "name=fs3"

# Arrêter le serveur
podman stop fs3-hoster

# Arrêter le jeu
podman stop fs3-game

# Voir les logs du serveur
podman logs fs3-hoster
```

## Ports réseau

| Port | Protocole | Description |
|------|-----------|-------------|
| 1203 | UDP | Port principal FS3 |
| 1206 | UDP | Port serveur (configurable) |

## Licence

Les fichiers de configuration sont libres. Le jeu Friendly-Strike 3 reste la propriété de ses auteurs.
