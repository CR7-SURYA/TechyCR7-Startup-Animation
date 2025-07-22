#!/data/data/com.termux/files/usr/bin/bash

clear

# Install requirements
pkg update -y > /dev/null 2>&1
pkg upgrade -y > /dev/null 2>&1
pkg install toilet figlet ruby termux-api tsu -y > /dev/null 2>&1
gem install lolcat > /dev/null 2>&1

# Fix TERM in case toilet hangs
export TERM=xterm

# Show animated banner
toilet -f big -F gay "Made by Surya" | lolcat
echo
sleep 1

# Ask for user's name
read -p $'\e[1;32m🔹 Enter your name for the animation: \e[0m' username

# Ask for password (optional)
read -p $'\e[1;36m🔐 Do you want to set a password on Termux launch? (y/n): \e[0m' choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    read -p $'\e[1;33m🔑 Enter your password: \e[0m' password
else
    password=""
fi

# Create animation script
cat > ~/.termux_anim.sh <<EOF
#!/data/data/com.termux/files/usr/bin/bash
clear
export TERM=xterm
toilet -f big -F gay "Welcome, $username" | lolcat
sleep 1
EOF

# If password is set, add prompt
if [[ -n "$password" ]]; then
cat >> ~/.termux_anim.sh <<EOF
echo
read -sp \$'\e[1;31m🔐 Enter password to continue: \e[0m' userpass
if [[ "\$userpass" != "$password" ]]; then
    echo -e "\n\e[1;31m❌ Incorrect password. Exiting...\e[0m"
    exit
fi
EOF
fi

# Add executable permission
chmod +x ~/.termux_anim.sh

# Set up Termux boot script
mkdir -p ~/.termux/boot
echo -e "#!/data/data/com.termux/files/usr/bin/bash\nbash ~/.termux_anim.sh" > ~/.termux/boot/start.sh
chmod +x ~/.termux/boot/start.sh

echo -e "\n\e[1;32m✅ All done! Restart Termux to see the animation.\e[0m"
