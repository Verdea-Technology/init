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

## Step 3: Create a new SSH key (if you don't have one)
Generate an ed25519 key with your email.
```bash
ssh-keygen -t ed25519 -C "your_email@company.com"
```
- Press Enter to accept the default location (~/.ssh/id_ed25519)
- Enter a passphrase when prompted (optional but recommended)

## Step 4: Add key to ssh-agent
Load your key into the SSH agent.
```bash
ssh-add ~/.ssh/id_ed25519
```
macOS only:
```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

## Step 5: Copy your public key
Send this to your admin to add to GitHub.

macOS:
```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Linux:
```bash
cat ~/.ssh/id_ed25519.pub
```

Windows CMD:
```bash
type %USERPROFILE%\.ssh\id_ed25519.pub
```

Windows PowerShell:
```bash
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub | Set-Clipboard
```

## Step 6: Add key to GitHub
1. Go to GitHub Settings → SSH and GPG Keys → New SSH Key
2. Paste your public key
3. Notify your admin you've added your key

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
