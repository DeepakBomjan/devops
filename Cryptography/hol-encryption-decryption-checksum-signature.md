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
guser@example.com
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
e keyid
# Anyone can request your public key from the key server
gpg --recv-keys keyid
# gpg --recv-keys --keyserver ipv4.pool.sks-keyservers.net 04EE7237B7D453EC

```

## Example - Verifying ubuntu download

```bash
# Download Ubuntu key
gpg --keyid-format long --keyserver hkp://keyserver.ubuntu.com --recv-keys 0x46181433FBB75451 0xD94AA3F0EFE21092
# gpg --keyid-format long --list-keys --with-fingerprint 0x46181433FBB75451 0xD94AA3F0EFE21092

gpg --keyid-format long --verify SHA256SUMS.gpg SHA256SUMS

```
[Download Package here](http://archive.ubuntu.com/ubuntu/)

https://www.openssl.org/source/

```bash
gpg --keyserver 'keys.openpgp.org' --recv-keys 'A21FAB74B0088AA361152586B8EF1A6BA9DA2D5C'
gpg --verify openssl-3.0.7.tar.gz.asc openssl-3.0.7.tar.gz
```
## Using public key outside keyring
```bash
gpg --no-default-keyring --keyring /path/to/pubkey.gpg --verify /path/to/file.txt.gpg
```



## Encrypt Message
```bash
# gpg --sign --encrypt --recipient 9031D00871B98507 --output sample.text.gpg sample.txt
gpg --output encrypted-sample.gpg --encrypt --sign --armor --recipient 9031D00871B98507 sample.txt
```

## Decrypt Message
```bash
gpg --output decrypted-doc --decrypt encrypted-sample.gpg
```
[Use GPG Keys to Send Encrypted Messages](https://www.linode.com/docs/guides/gpg-keys-to-send-encrypted-messages/)


