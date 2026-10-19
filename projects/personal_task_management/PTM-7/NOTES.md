# Personal GitHub Setup on a Work Laptop

This repository can use a personal GitHub identity without changing the global Git configuration used by work repositories.

## Set the Local Commit Identity

Run these commands from the repository root:

```bash
git config user.name "Your Personal GitHub Name"
git config user.email "your-personal-github-email@example.com"
```

Use an email address verified on the personal GitHub account so GitHub attributes commits and contributions correctly. These settings apply only to this repository.

Verify the repository-local configuration:

```bash
git config --local --list
```

## Use a Personal SSH Key When Needed

A separate SSH key is only needed when pushing this repository must authenticate as the personal GitHub account. If the existing work SSH key is associated only with a work GitHub account, create a personal key:

```bash
ssh-keygen -t ed25519 -C "your-personal-github-email@example.com" -f ~/.ssh/id_ed25519_github_personal
```

Add the generated public key at `~/.ssh/id_ed25519_github_personal.pub` to the personal GitHub account. Then add this entry to `~/.ssh/config`:

```sshconfig
Host github-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github_personal
  IdentitiesOnly yes
```

Configure this repository to use that SSH host alias:

```bash
git remote set-url origin git@github-personal:skazzwag/zkb.git
ssh -T git@github-personal
```

## Summary

- Local `user.name` and `user.email` control commit attribution.
- A separate SSH key and SSH host alias are only required when personal GitHub authentication is needed for pushing.
- Confirm that storing personal credentials and using personal GitHub repositories on the work laptop complies with employer policy.
