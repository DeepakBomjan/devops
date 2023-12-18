## Configure GPG
### Generating a new keypair
```bash
gpg --gen-key

# gpg --full-generate-key
# gpg --default-new-key-algo rsa4096 --gen-key

## To list the keys in long form
gpg --list-secret-keys --keyid-format=long

## Export keys
# gpg --armor --export 3AA5C34371567BD2

```
### Exporting gpg keys
```bash
gpg --armor --output public-key.gpg --export user@example.com
```
### Import and Validate a Public Key
```bash
gpg --import public-key.gpg
# gpg --list-keys
# gpg --fingerprint public-key.gpg

```

### Submit Your Public Key to a Key Server

You can submit your public key to a GPG server to make it available to the general public. The GnuPG configuration file ~/.gnupg/gpg.conf by default sets the key server as hkp://keys.gnupg.net and provides examples of other key servers that can be used in the file’s comments. Since key servers around the globe synchronize their keys to each other it should not be necessary to change the default value set in the configuration file.

```bash
# Find the long key ID for the public key you would like to send to the key server:
gpg --keyid-format long --list-keys user@example.com
# To send your public key to the default key server
gpg --send-keys keyid
# Anyone can request your public key from the key server
gpg --recv-keys keyid

```

[Use GPG Keys to Send Encrypted Messages](https://www.linode.com/docs/guides/gpg-keys-to-send-encrypted-messages/)

