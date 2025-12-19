#!/bin/bash
# =============================================================================
# setup-host-audio.sh - Configuration audio du serveur hôte pour Friendly-Strike 3
# =============================================================================
#
# Ce script configure le serveur Linux pour permettre au conteneur d'utiliser
# l'audio via PipeWire/PulseAudio.
#
# Usage: sudo ./setup-host-audio.sh [username]
#        username: l'utilisateur qui exécutera le jeu (défaut: $SUDO_USER)
#
# =============================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Vérification root
if [ "$EUID" -ne 0 ]; then
    log_error "Ce script doit être exécuté en root (sudo)"
    exit 1
fi

# Utilisateur cible
TARGET_USER="${1:-$SUDO_USER}"
if [ -z "$TARGET_USER" ] || [ "$TARGET_USER" = "root" ]; then
    log_error "Impossible de déterminer l'utilisateur cible."
    echo "Usage: sudo $0 <username>"
    exit 1
fi

TARGET_UID=$(id -u "$TARGET_USER")
XDG_RUNTIME="/run/user/$TARGET_UID"

log_info "Configuration audio pour l'utilisateur: $TARGET_USER (UID: $TARGET_UID)"

# =============================================================================
# Étape 1: Ajouter l'utilisateur au groupe audio
# =============================================================================
log_info "Vérification du groupe 'audio'..."

if id -nG "$TARGET_USER" | grep -qw "audio"; then
    log_info "L'utilisateur '$TARGET_USER' est déjà dans le groupe 'audio'"
else
    log_info "Ajout de '$TARGET_USER' au groupe 'audio'..."
    usermod -aG audio "$TARGET_USER"
    log_warn "L'utilisateur a été ajouté au groupe 'audio'."
    log_warn "Une déconnexion/reconnexion est nécessaire pour que le changement prenne effet."
    NEED_RELOGIN=1
fi

# =============================================================================
# Étape 2: Vérifier que PipeWire/PulseAudio est installé
# =============================================================================
log_info "Vérification de PipeWire..."

if ! command -v pipewire &> /dev/null; then
    log_error "PipeWire n'est pas installé."
    log_info "Installation recommandée:"
    echo "  dnf install pipewire pipewire-pulseaudio wireplumber"
    echo "  # ou"
    echo "  apt install pipewire pipewire-pulse wireplumber"
    exit 1
fi

# =============================================================================
# Étape 3: Vérifier que les services PipeWire sont actifs
# =============================================================================
log_info "Vérification des services PipeWire pour '$TARGET_USER'..."

check_service() {
    sudo -u "$TARGET_USER" XDG_RUNTIME_DIR="$XDG_RUNTIME" \
        systemctl --user is-active "$1" &>/dev/null
}

SERVICES_OK=1
for service in pipewire wireplumber pipewire-pulse; do
    if check_service "$service"; then
        log_info "  $service: actif"
    else
        log_warn "  $service: inactif"
        SERVICES_OK=0
    fi
done

if [ "$SERVICES_OK" -eq 0 ]; then
    log_info "Démarrage des services PipeWire..."
    sudo -u "$TARGET_USER" XDG_RUNTIME_DIR="$XDG_RUNTIME" \
        systemctl --user start pipewire wireplumber pipewire-pulse || true
fi

# =============================================================================
# Étape 4: Vérifier le socket PulseAudio
# =============================================================================
PULSE_SOCKET="$XDG_RUNTIME/pulse/native"
log_info "Vérification du socket PulseAudio: $PULSE_SOCKET"

if [ -S "$PULSE_SOCKET" ]; then
    log_info "Socket PulseAudio trouvé et accessible"
else
    log_error "Socket PulseAudio non trouvé!"
    log_info "Assurez-vous que pipewire-pulse est démarré."
    exit 1
fi

# =============================================================================
# Étape 5: Lister les sorties audio disponibles
# =============================================================================
log_info "Sorties audio disponibles:"

# Utiliser wpctl si disponible
if command -v wpctl &> /dev/null; then
    sudo -u "$TARGET_USER" XDG_RUNTIME_DIR="$XDG_RUNTIME" wpctl status 2>/dev/null | \
        grep -A 20 "Sinks:" | head -20
else
    log_warn "wpctl non disponible, impossible de lister les sorties"
fi

# =============================================================================
# Étape 6: Afficher les instructions pour HDMI
# =============================================================================
echo ""
echo "============================================================================="
echo "CONFIGURATION HDMI (optionnel)"
echo "============================================================================="
echo ""
echo "Pour activer la sortie HDMI, exécutez en tant que '$TARGET_USER':"
echo ""
echo "  # Lister les profils disponibles:"
echo "  pactl list cards | grep -A 30 'Profiles:'"
echo ""
echo "  # Activer la sortie HDMI:"
echo "  pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:hdmi-stereo"
echo ""
echo "  # Ou utiliser le script fourni:"
echo "  ./select-audio-output.sh hdmi"
echo ""

# =============================================================================
# Résumé
# =============================================================================
echo "============================================================================="
echo "RÉSUMÉ"
echo "============================================================================="
echo ""
log_info "Configuration terminée!"
echo ""
echo "Socket PulseAudio: $PULSE_SOCKET"
echo ""
echo "Pour lancer le jeu avec audio:"
echo ""
echo "  podman run --rm -it \\"
echo "      --network=host \\"
echo "      -e DISPLAY=\$DISPLAY \\"
echo "      -e PULSE_SERVER=unix:/run/user/$TARGET_UID/pulse/native \\"
echo "      -v /run/user/$TARGET_UID/pulse/native:/run/user/$TARGET_UID/pulse/native \\"
echo "      friendly-strike3:latest game"
echo ""

if [ "${NEED_RELOGIN:-0}" -eq 1 ]; then
    log_warn "IMPORTANT: Déconnectez-vous et reconnectez-vous pour appliquer"
    log_warn "           le changement de groupe 'audio'."
fi
