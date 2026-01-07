#!/bin/bash

# Help function
show_help() {
    cat <<EOF
=== Verdea GitHub SSH Access Helper ===

Usage: $0 [OPTIONS]

This script guides developers through testing SSH access to GitHub
and debugging permissions issues for cloning Verdea repositories.

Options:
  -h, --help    Show this help message
  (no options)  Run the interactive SSH test

The script will:
1. Check for SSH and Git installation
2. List SSH keys in your .ssh directory
3. Test connection to GitHub
4. Provide step-by-step diagnosis if connection fails

For more details, see README.md
EOF
    exit 0
}

# Function to analyze SSH keys and permissions
analyze_ssh_keys() {
    local dir="$1"
    echo "🔍 Analyzing SSH keys and permissions..."
    
    # Check .ssh directory permissions
    local dir_perm=$(stat -f %A "$dir" 2>/dev/null || stat -c %a "$dir" 2>/dev/null)
    if [ "$dir_perm" != "700" ]; then
        echo "⚠️  .ssh directory permissions are $dir_perm (should be 700)"
        echo "   Fix with: chmod 700 $dir"
    else
        echo "✅ .ssh directory permissions are correct (700)"
    fi
    
    # Find private keys
    local private_keys=()
    for key in "$dir"/id_*; do
        if [ -f "$key" ] && [[ "$key" != *.pub ]]; then
            private_keys+=("$key")
        fi
    done
    
    if [ ${#private_keys[@]} -eq 0 ]; then
        echo "❌ No private SSH keys found in $dir"
        echo "   You have public key files but no private keys."
        return 1
    fi
    
    echo "✅ Found ${#private_keys[@]} private key(s)"
    
    # Check each private key
    for key in "${private_keys[@]}"; do
        local key_perm=$(stat -f %A "$key" 2>/dev/null || stat -c %a "$key" 2>/dev/null)
        if [ "$key_perm" != "600" ]; then
            echo "⚠️  Private key $key permissions are $key_perm (should be 600)"
            echo "   Fix with: chmod 600 $key"
        else
            echo "✅ Private key $key permissions are correct (600)"
        fi
        
        # Check if corresponding .pub exists
        if [ -f "$key.pub" ]; then
            echo "✅ Public key exists: $key.pub"
        else
            echo "⚠️  No public key found for $key"
            echo "   Generate with: ssh-keygen -y -f $key > $key.pub"
        fi
    done
    
    # Check ssh-agent
    if ssh-add -l >/dev/null 2>&1; then
        echo "✅ SSH agent is running and has loaded keys"
        ssh-add -l | head -5
    else
        echo "⚠️  SSH agent not running or no keys loaded"
        echo "   Start with: eval \"\\$(ssh-agent -s)\""
    fi
    
    return 0
}


# Check for help argument
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
fi

if [ $# -gt 0 ]; then
    echo "⚠️  Unknown arguments ignored. Use -h for help."
fi

echo "=== Verdea GitHub SSH Access Helper ==="
echo "This script guides you through testing your SSH key setup."
echo ""

# Dependency checks
command -v ssh >/dev/null 2>&1 || { echo "❌ SSH not installed."; exit 1; }
command -v git >/dev/null 2>&1 || { echo "❌ Git not installed."; exit 1; }

# SSH directory input
echo "Enter path to your .ssh directory (default: ~/.ssh):"
read -r ssh_dir
ssh_dir="${ssh_dir:-~/.ssh}"
ssh_dir="${ssh_dir/#\~/$HOME}"
if [ ! -d "$ssh_dir" ]; then
    echo "❌ Directory $ssh_dir does not exist."
    exit 1
fi

echo "📁 Keys in $ssh_dir:"
ls -la "$ssh_dir" | grep -E "\.pub$|id_"

analyze_ssh_keys "$ssh_dir"

# Test GitHub SSH connection
echo ""
echo "🔍 Testing SSH connection to GitHub..."
if ssh -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH connection successful!"
    echo ""
    echo "To clone the repositories, run:"
    echo "  git clone git@github.com:Verdea-Technology/verdea-website.git"
    echo "  git clone git@github.com:Verdea-Technology/verdea-app.git"
    exit 0
else
    echo "❌ SSH connection failed. Let's diagnose."
fi

# Diagnosis steps
echo ""
echo "=== Diagnosis Steps ==="
echo "1. Check for SSH keys in $ssh_dir"
echo "   Look for files like id_rsa, id_ed25519, etc."
echo ""
echo "2. If no key exists, generate one:"
echo "   ssh-keygen -t ed25519 -C \"your_email@example.com\""
echo "   (Save to $ssh_dir/id_ed25519)"
echo ""
echo "3. Set correct permissions:"
echo "   chmod 600 $ssh_dir/id_ed25519"
echo ""
echo "4. Add key to ssh‑agent:"
echo "   eval \"\$(ssh-agent -s)\""
echo "   ssh-add $ssh_dir/id_ed25519"
if [[ "$(uname)" == "Darwin" ]]; then
    echo "   On macOS, use: ssh-add --apple-use-keychain $ssh_dir/id_ed25519"
fi
echo ""
echo "5. Get your public key for the admin:"
echo "   cat $ssh_dir/id_ed25519.pub"
echo "   Copy the output and send it to your admin."
echo "   The admin will add this public key to GitHub to grant you access."
echo ""
echo "6. After the admin adds your key to GitHub, run this script again to test."
echo ""
echo "For more details, see the README.md file."
exit 1