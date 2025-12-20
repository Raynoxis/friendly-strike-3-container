# Friendly-Strike 3 Container

![Friendly-Strike 3](docs/images/game.png)

**Friendly-Strike 3** est un jeu d'action/arcade 2D multijoueur où jusqu'à 4 joueurs s'affrontent dans des arènes destructibles. Armés de pistolets, fusils, explosifs et équipements variés, les joueurs combattent dans des environnements interactifs avec des bâtiments, des plateformes et des cachettes.

C'est le jeu auquel on jouait à 4 sur un seul clavier quand j'étais au collège. Je voulais le faire perdurer et le rendre jouable sur Linux !

Site officiel : http://lucas.sonzogni.free.fr/fs3_en.htm

---

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
./scripts/run-hoster.sh
```

Ou avec podman-compose :

```bash
podman-compose --profile server up hoster
```

### 2. Configurer le serveur

Dans la fenêtre du Hoster :

1. Renseigne les paramètres (nom du serveur, port, mot de passe...)
2. Va dans le menu **Server** → **Connect** pour lancer l'écoute
3. Le statut passe de "Offline" à "Online"
4. Note l'adresse **Computer local IP** (ex: `192.168.0.20`)

![Configuration du serveur](docs/images/server.png)

### 3. L'hébergeur rejoint son propre serveur

L'hébergeur lance ensuite le jeu sur sa machine :

```bash
./scripts/run-game.sh
```

Dans le jeu :

1. Va dans **Multijoueur** → **Connexion directe**
2. Entre l'IP locale du serveur (Computer local IP, ex: `192.168.0.20`)
3. Entre le port (par défaut `1206`)
4. Connecte-toi au serveur

![Connexion directe](docs/images/connexion.png)

### 4. Créer une partie

Une fois dans le lobby :

1. Clique sur **Créer** pour créer une nouvelle partie
2. Choisis la carte, les options de jeu, etc.
3. Attends que les autres joueurs rejoignent

![Lobby et création de partie](docs/images/create.png)

### 5. Les autres joueurs rejoignent

Sur les autres machines du réseau :

1. Lance le jeu : `./scripts/run-game.sh`
2. Va dans **Multijoueur** → **Connexion directe**
3. Entre l'IP du serveur (la même que l'hébergeur)
4. Rejoins la partie créée par l'hébergeur

### 6. Lancer la partie

Une fois tous les joueurs présents dans le lobby, l'hébergeur peut lancer la partie.

### Ports requis

Assurez-vous que les ports sont ouverts sur le pare-feu :
- **1203/UDP** - Port principal
- **1206/UDP** - Port serveur (configurable)

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
