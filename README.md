# init

## Step 1: Clone this repo (HTTPS)
Verify you can access GitHub.
```bash
git clone https://github.com/Verdea-Technology/init.git
```

## Step 2: Run the helper script (macOS/Linux)
Automatically diagnose and fix SSH issues.
```bash
./init-ssh-helper.sh
```

## Step 2.5: Switch to SSH (if you want to PUSH to the init repo)
Update this repository to use SSH instead of HTTPS.
```bash
git remote set-url origin git@github.com:Verdea-Technology/init.git
```

## Step 3: Create a new SSH key (if you don't have one)
Generate an ed25519 key with your company email (or use your personal email).
```bash
ssh-keygen -t ed25519 -C "your_email@verdea.io"
```
- Press Enter to accept the default location (~/.ssh/verdea_ed25519)
- Enter a passphrase when prompted (optional but recommended)

## Step 4: Add key to ssh-agent 
Load your key into the SSH agent.
```bash
ssh-add ~/.ssh/verdea_ed25519
```
macOS only:
```bash
ssh-add --apple-use-keychain ~/.ssh/verdea_ed25519
```

## Step 5: Copy your public key
Send this to your admin to add to GitHub.

macOS - Copies your public key to the clipboard.
```bash
pbcopy < ~/.ssh/verdea_ed25519.pub
```

Linux - Displays your public key (select and copy).
```bash
cat ~/.ssh/verdea_ed25519.pub
```

Windows CMD - Displays your public key (select and copy).
```bash
type %USERPROFILE%\.ssh\verdea_ed25519.pub
```

Windows PowerShell - Copies your public key to the clipboard.
```bash
Get-Content $env:USERPROFILE\.ssh\verdea_ed25519.pub | Set-Clipboard
```

## Step 6: Send your public key to your admin
Only the admin can add keys to the GitHub organization.

1. Send the **public key** (`~/.ssh/verdea_ed25519.pub`) to your admin
2. The admin will add it to the GitHub organization
3. Once added, you'll have access to private Verdea repos

Never share your private key (`verdea_ed25519` without `.pub`).

## Step 7: Test your connection
Verify SSH access works.
```bash
ssh -T git@github.com
```

## Step 8: Clone other repos (using SSH)
Clone Verdea repositories with SSH.
```bash
git clone git@github.com:Verdea-Technology/verdea-website.git
git clone git@github.com:Verdea-Technology/verdea-app.git
```

---

**Windows/Linux manual setup:** If the helper script doesn't work, follow Steps 3-7 directly.
