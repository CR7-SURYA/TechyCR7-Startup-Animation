#!/data/data/com.termux/files/usr/bin/bash

CONFIG_DIR="$HOME/.termux-animation"
CONFIG_FILE="$CONFIG_DIR/config.txt"
LOGIN_SCRIPT="$HOME/.termux-login.sh"
PROFILE_SCRIPT="$HOME/.bash_profile"

# Create config directory
mkdir -p "$CONFIG_DIR"

clear
echo -e "\033[1;36mWelcome to the Termux Setup Script!\033[0m"
echo ""
read -p "Enter your name (will be shown in animation): " username
echo "USERNAME=\"$username\"" > "$CONFIG_FILE"

# Ask for password
read -p "Do you want to set a Termux password lock? (y/n): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    read -sp "Enter a password: " userpass
    echo ""
    read -sp "Confirm password: " confirm
    echo ""
    if [[ "$userpass" != "$confirm" ]]; then
        echo -e "\n\033[1;31m❌ Passwords do not match. Exiting...\033[0m"
        exit 1
    fi
    echo "PASSWORD=\"$userpass\"" >> "$CONFIG_FILE"
else
    echo "PASSWORD=" >> "$CONFIG_FILE"
fi

# Create the login animation script
cat > "$LOGIN_SCRIPT" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

source "$HOME/.termux-animation/config.txt"

clear

# Password check
if [ ! -z "$PASSWORD" ]; then
    echo -e "\033[1;36mWelcome to Termux\033[0m"
    echo ""
    read -sp "🔒 Enter Password: " input
    echo ""
    if [[ "$input" != "$PASSWORD" ]]; then
        echo -e "\033[1;31m❌ Incorrect password. Access denied!\033[0m"
        sleep 1
        clear
        exit
    fi
fi

# Animation
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}$(toilet -f big "$USERNAME" | lolcat)${NC}"
sleep 0.5

echo -e "${GREEN}"
echo "╔════════════════════════════════════════╗"
echo "║              LOADING...               ║"
echo "╚════════════════════════════════════════╝"
sleep 0.3

for i in {1..20}; do
    filled=$(printf "█%.0s" $(seq 1 $i))
    empty=$(printf "░%.0s" $(seq $((20 - i))))
    percent=$((i * 5))
    echo -ne "${GREEN}   [${filled}${empty}] ${percent}%\r"
    sleep 0.08
done

echo -e "\n"
sleep 0.5

echo -e "${CYAN}"
echo "╔══════════════════════════════════════╗"
echo "║        ✅  ACCESS GRANTED           ║"
echo "╚══════════════════════════════════════╝"
echo -e "${NC}"
EOF

chmod +x "$LOGIN_SCRIPT"

# Hook it into bash_profile only once
if ! grep -qF "$LOGIN_SCRIPT" "$PROFILE_SCRIPT"; then
    echo -e "\n# Auto-run animation on Termux start" >> "$PROFILE_SCRIPT"
    echo "bash $LOGIN_SCRIPT" >> "$PROFILE_SCRIPT"
fi

clear
echo -e "\033[1;32m✅ Setup complete! Restart Termux to see the animation.\033[0m"