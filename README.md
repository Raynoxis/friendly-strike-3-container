# 🎮 Friendly-Strike 3 on Linux

![Friendly-Strike 3](docs/images/game.png)

> **4 players. 1 keyboard. 0 limits on fun.**

Remember those school breaks with four people crammed around one PC, fingers fighting on the same keyboard, trying not to get caught by the supervisors? **Friendly-Strike 3** is exactly that.

This project makes this Windows gem run on **Linux** with Wine and Podman/Docker. Great games should not die.

---

## 🔥 Why this game rules

| | |
|---|---|
| 👥 **Up to 4 players on ONE KEYBOARD** | Yes, it is chaos. Yes, it is awesome. Enable Sticky Keys (every 30s) and go. |
| 🌐 **LAN multiplayer** | Run old-school LAN parties. Each player on their own PC, all on the same network. |
| 🔫 **48 weapons of destruction** | 38 buyable between rounds + 10 legendary weapons hidden in arenas |
| 💣 **Tactical arsenal** | Grenades, napalm, smoke bombs, remote-controlled rockets... |
| 🤖 **Tough AI** | 4 difficulty levels for solo play or to fill teams |
| 🏗️ **Arena editor** | Create your own maps with 19 different worlds |
| 🎯 **Destructible arenas** | Walls explode, floors collapse, chaos takes over |

*"Be a smart strategist or big barbarian, it's up to you to choose!"*

---

## 📖 The story behind this project

This is the game we played with four people on one keyboard in middle school. Hours of frantic matches between classes, laughs, clutch wins at the last second — always keeping one eye on the door in case a supervisor showed up.

I wanted to keep it alive and playable on Linux. Mission accomplished.

🌐 **Official site**: http://lucas.sonzogni.free.fr/fs3_en.htm

---

## 🚀 Quick install

```bash
# Clone the project
git clone https://github.com/Raynoxis/friendly-strike-3-container.git
cd friendly-strike-3-container

# Pull the Docker Hub image
podman pull docker.io/raynoxis/friendly-strike-3:latest

# PLAY!
./scripts/run-game.sh
```

If you want to use a different image:

```bash
export FS3_IMAGE=docker.io/raynoxis/friendly-strike-3:latest
```

Optional (local build):

```bash
podman build -t docker.io/raynoxis/friendly-strike-3:latest ./build
```

---

## 🎮 Game modes

### 🖥️ Solo / Local (up to 4 players on 1 PC)

```bash
./scripts/run-game.sh
```

Gather around the keyboard and may the best win!

**💡 Windows tip**: Enable Sticky Keys to avoid key conflicts. The game will prompt you every 30 seconds.

### 🌐 LAN multiplayer (up to 4 players over the network)

Run a real LAN party! Each player on their PC, all connected to the same local network.

<details>
<summary><b>📋 Full LAN guide (click to expand)</b></summary>

#### Step 1: Start the server

On the host PC:

```bash
./scripts/run-hoster.sh
```

#### Step 2: Configure the server

![Server setup](docs/images/server.png)

1. Fill in the server name, port, password...
2. Menu **Server** → **Connect** to start listening
3. Note the **Computer local IP** (ex: `192.168.0.20`)

#### Step 3: Join the server

On **each PC** (including the host):

```bash
./scripts/run-game.sh
```

Then in the game:

![Direct connection](docs/images/connexion.png)

1. **Multiplayer** → **Direct connection**
2. Enter the server IP (ex: `192.168.0.20`)
3. Port: `1206` (default)

#### Step 4: Create and start the match

![Lobby](docs/images/create.png)

1. The host clicks **Create**
2. Pick the map and options
3. Other players join the match
4. **GO!**

#### Ports to open (firewall)

| Port | Protocol | Description |
|------|----------|-------------|
| 1203 | UDP | Main port |
| 1206 | UDP | Server port |

</details>

---

## 🔊 HDMI audio (ALSA)

The most reliable path tested here is ALSA over HDMI, run as root.

```bash
# Default HDMI (often hw:0,3)
sudo ./scripts/run-game-hdmi.sh

# Other possible HDMI outputs
sudo ./scripts/run-game-hdmi.sh hw:0,7
sudo ./scripts/run-game-hdmi.sh hw:0,8

# List available HDMI outputs
cat /proc/asound/pcm | grep HDMI
```

For a regular launch (without forcing HDMI):

```bash
./scripts/run-game.sh
```

---

## 📁 Project structure

```
├── build/                      # Image build
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── game/                   # Game files
│
├── scripts/                    # Run scripts
│   ├── run-game.sh             # Start the game
│   ├── run-game-hdmi.sh         # Start the game with HDMI audio (ALSA)
│   ├── run-hoster.sh           # Start the LAN server
│   └── publish-image.sh        # Build + push the image to Docker Hub
│
├── docker-compose.yml
└── README.md
```

---

## 🛠️ Useful commands

```bash
# See running containers
podman ps --filter "name=fs3"

# Stop the game
podman stop fs3-game

# Stop the server
podman stop fs3-hoster

# Server logs
podman logs fs3-hoster
```

---

## 📦 Docker Hub publishing (maintainer)

```bash
./scripts/publish-image.sh
```

The script reuses the `dockerpass` alias from `~/.bashrc` for the token.
Useful variables: `DOCKERHUB_USER`, `DOCKERHUB_TOKEN`, `FS3_IMAGE`.

---

## 📜 License

This project's configuration files are free to use.
The **Friendly-Strike 3** game remains the property of its authors.

---

<div align="center">

**Made with ❤️ to preserve a piece of our teenage years**

*If you also have memories of epic matches in the school break room, give the project a ⭐!*

</div>
