## [Sample mern project](https://github.com/mohamedsamara/mern-ecommerce)

## Generate ENV variables

1. Generate JWT_SECRET
```bash
 node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
 ```

## Installing mongosh
```bash
wget -qO- https://www.mongodb.org/static/pgp/server-7.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-7.0.asc
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-mongosh
sudo apt-get install -y mongodb-mongosh-shared-openssl3
```


## References
1. [Install mongosh](https://www.mongodb.com/docs/mongodb-shell/install/)
