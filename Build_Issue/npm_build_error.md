The error you're encountering is related to the OpenSSL library used by Node.js for cryptographic operations. It seems that your current Node.js version (v21.7.3) has some compatibility issues with the OpenSSL configuration.

Here are the steps you can take to resolve this issue:

### 1. Update Node.js
Make sure you are using the latest stable version of Node.js. Sometimes, using an experimental version can cause such issues. You can use a Node Version Manager (NVM) to manage and switch between different Node.js versions easily.

To install NVM:
```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
```

To install and use the latest LTS version of Node.js:
```sh
nvm install --lts
nvm use --lts
```

### 2. Set Node.js Environment Variable
Set the `NODE_OPTIONS` environment variable to use legacy OpenSSL providers. This can help bypass the issue with unsupported digital envelope routines.

On Unix-based systems (macOS, Linux):
```sh
export NODE_OPTIONS=--openssl-legacy-provider
```

On Windows (cmd):
```cmd
set NODE_OPTIONS=--openssl-legacy-provider
```

On Windows (PowerShell):
```powershell
$env:NODE_OPTIONS="--openssl-legacy-provider"
```

### 3. Reinstall Dependencies
After setting the environment variable, remove the existing `node_modules` directory and `package-lock.json` file, then reinstall the dependencies.

```sh
rm -rf node_modules package-lock.json
npm install
```

### 4. Build Again
Now, try building your project again.

```sh
npm run build
```

### Additional Tips
- Ensure your project's dependencies are up-to-date. Run `npm outdated` to check for outdated packages.
- If you are using any specific package that requires OpenSSL, check its documentation for any additional configuration needed.

By following these steps, you should be able to resolve the `ERR_OSSL_EVP_UNSUPPORTED` error and successfully build your project.
