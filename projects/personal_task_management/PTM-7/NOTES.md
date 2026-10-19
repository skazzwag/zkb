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
ssh-keygen -t ed25519 -C "your-personal-github-email@example.com" ~/.ssh/id_ed25519_github_personal
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

## Sign Commits with the Personal SSH Key

After adding the public key as a signing key in the personal GitHub account, configure SSH signing locally in this repository:

```bash
git config --local gpg.format ssh
git config --local user.signingkey ~/.ssh/id_ed25519_github_personal.pub
git config --local commit.gpgSign true
```

Use the public-key path for `user.signingkey`. This signs future commits in this repository by default.

Create and inspect a signed test commit:

```bash
git commit --allow-empty -m "Test SSH commit signing"
git log --show-signature -1
```

GitHub should display a `Verified` badge after the commit is pushed when the signing key is registered with the personal GitHub account and the commit email is verified on that account.

The `~/.ssh/config` host alias only selects the key used to authenticate Git pushes. It is unrelated to commit signing. The same key may be used for authentication and signing if it is registered with GitHub for both purposes; separate keys also work.

## Summary

- Local `user.name` and `user.email` control commit attribution.
- A separate SSH key and SSH host alias are only required when personal GitHub authentication is needed for pushing.
- Local SSH signing configuration signs commits with the personal signing key.
- Confirm that storing personal credentials and using personal GitHub repositories on the work laptop complies with employer policy.
