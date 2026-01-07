# init


## 1. Clone this repo with HTTPS
Test your access to github
```bash
git clone https://github.com/Verdea-Technology/init.git
```

## 2. Run shell helper
```bash
./init-ssh-helper.sh
```


## 2. Create a SSH key
```bash
ssh-keygen -y -f ~/.ssh/[key_filename] > ~/.ssh/[key_filename].pub
```

Test your access to github
```bash
ssh -T git@github.com
```

Switch to SSH instead of HTTPS
(all other repos should use SSH)
```bash
git remote set-url origin git@github.com:Verdea-Technology/init.git
```

Check if you have keys
```bash
ls -al ~/.ssh
```

Set permissions if needed
```bash
chmod 600 ~/.ssh/[key_filename]
```

MacOS - add key to keychain
```bash
ssh-add --apple-use-keychain ~/.ssh/[key_filename]
```


```bash
pbcopy < ~/.ssh/[key_filename].pub
```

```bash
cd ..
```
```bash
git clone git@github.com:Verdea-Technology/verdea-website.git
```
```bash
git clone git@github.com:Verdea-Technology/verdea-app.git
```

## SSH Access Helper Script

Use the `init-ssh-helper.sh` script to diagnose SSH connection issues:

```bash
./init-ssh-helper.sh
```

The script will:
- Check SSH and Git installation
- List your SSH keys and analyze permissions
- Test connection to GitHub
- Provide step-by-step guidance if connection fails

