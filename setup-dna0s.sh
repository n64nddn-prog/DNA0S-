```bash
#!/usr/bin/env bash
set -oue pipefail

# Wrapper that opens .exe and .msi files
cat > /usr/bin/dna0s-run-exe << 'EOF'
#!/usr/bin/env bash
export WINEPREFIX="$HOME/.dna0s/prefix"
export PROTONPATH=GE-Proton
export GAMEID=umu-default
mkdir -p "$WINEPREFIX"
file="$1"
cd "$(dirname "$file")"
case "${file,,}" in
*.msi) exec umu-run msiexec /i "$file" ;;
*) exec umu-run "$file" ;;
esac
EOF
chmod +x /usr/bin/dna0s-run-exe

# Desktop entry
cat > /usr/share/applications/dna0s-run-exe.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=DNA0S Windows App Runner
Exec=/usr/bin/dna0s-run-exe %f
NoDisplay=true
MimeType=application/x-ms-dos-executable;application/x-msdownload;application/vnd.microsoft.portable-executable;application/x-msi;application/x-ms-installer;
EOF

# Make it the default for .exe and .msi
mkdir -p /etc/xdg
cat > /etc/xdg/mimeapps.list << 'EOF'
[Default Applications]
application/x-ms-dos-executable=dna0s-run-exe.desktop
application/x-msdownload=dna0s-run-exe.desktop
application/vnd.microsoft.portable-executable=dna0s-run-exe.desktop
application/x-msi=dna0s-run-exe.desktop
application/x-ms-installer=dna0s-run-exe.desktop
EOF

update-desktop-database /usr/share/applications || true

# Branding
echo "DNA0S - based on Bazzite (Fedora)" > /etc/dna0s-release
```