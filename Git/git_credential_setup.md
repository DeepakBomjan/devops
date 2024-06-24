```markdown
**Attention:**
This method saves the credentials in plaintext on your PC's disk. Everyone on your computer can access it, e.g. malicious NPM modules.

Run:

```sh
git config --global credential.helper store
```

Then:

```sh
git pull
```

Provide a username and password, and those details will then be remembered later. The credentials are stored in a file on the disk, with the disk permissions of "just user readable/writable" but still in plaintext.

If you want to change the password later:

```sh
git pull
```

Will fail because the password is incorrect. Git then removes the offending user+password from the `~/.git-credentials` file, so now re-run:

```sh
git pull
```

To provide a new password so it works as earlier. You can use the git config to enable credentials storage in Git.

```sh
git config --global credential.helper store
```

When running this command, the first time you pull or push from the remote repository, you'll get asked about the username and password. Afterwards, for consequent communications with the remote repository, you don't have to provide the username and password.

The storage format is a `.git-credentials` file, stored in plaintext.

Also, you can use other helpers for the git config `credential.helper`, namely memory cache:

```sh
git config credential.helper 'cache --timeout=<timeout>'
```

This takes an optional timeout parameter, determining for how long the credentials will be kept in memory. Using the helper, the credentials will never touch the disk and will be erased after the specified timeout. The default value is 900 seconds (15 minutes).

You can again use `--global` to define for the whole system.

```sh
git config --global credential.helper 'cache --timeout=<timeout>'
```

**Warning:** If you use this method, your Git account passwords will be saved in plaintext format, in the global `.gitconfig` file, e.g., in Linux, it will be `/home/[username]/.gitconfig`.

If this is undesirable to you, use an SSH key for your accounts instead.
```
