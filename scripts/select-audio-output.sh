#!/bin/bash
# =============================================================================
# select-audio-output.sh - Sélection rapide de la sortie audio
# =============================================================================
#
# Usage: ./select-audio-output.sh [hdmi|analog|list]
#
# =============================================================================

set -e

# Trouver la carte audio Intel
CARD_NAME=$(pactl list cards short 2>/dev/null | grep -E "alsa_card\.(pci|usb)" | head -1 | awk '{print $2}')

if [ -z "$CARD_NAME" ]; then
    echo "Erreur: Aucune carte audio trouvée"
    echo "Assurez-vous que PipeWire/PulseAudio est démarré."
    exit 1
fi

case "${1:-list}" in
    hdmi)
        echo "Activation de la sortie HDMI..."
        pactl set-card-profile "$CARD_NAME" output:hdmi-stereo
        echo "Sortie HDMI activée."
        ;;
    analog|speakers)
        echo "Activation de la sortie analogique (haut-parleurs/casque)..."
        pactl set-card-profile "$CARD_NAME" output:analog-stereo
        echo "Sortie analogique activée."
        ;;
    list)
        echo "Carte audio: $CARD_NAME"
        echo ""
        echo "Profils disponibles:"
        pactl list cards 2>/dev/null | grep -A 50 "Name: $CARD_NAME" | \
            grep -E "^\s+(output:|off:)" | head -10
        echo ""
        echo "Profil actif:"
        pactl list cards 2>/dev/null | grep -A 50 "Name: $CARD_NAME" | \
            grep "Active Profile:" | head -1
        echo ""
        echo "Usage: $0 [hdmi|analog|list]"
        ;;
    *)
        echo "Usage: $0 [hdmi|analog|list]"
        echo ""
        echo "  hdmi    - Sortie HDMI/DisplayPort"
        echo "  analog  - Sortie haut-parleurs/casque"
        echo "  list    - Afficher les profils disponibles"
        exit 1
        ;;
esac
