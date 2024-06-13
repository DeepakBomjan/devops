Sure, here's a step-by-step guide to manually deploying a site using the Netlify CLI.

### Prerequisites

1. **Netlify Account**: Ensure you have a Netlify account. You can sign up at [Netlify](https://www.netlify.com/).
2. **Netlify CLI**: You need to have Netlify CLI installed. If you haven't installed it yet, you can install it globally using npm:

   ```sh
   npm install -g netlify-cli
   ```

3. **Netlify Site**: If you don't already have a site created on Netlify, you can create one through the Netlify UI or using the Netlify CLI.

### Steps to Deploy

#### 1. Log in to Netlify

First, you need to log in to your Netlify account using the CLI:

```sh
netlify login
```

This will open a browser window asking you to authorize the CLI to use your Netlify account.

#### 2. Initialize Your Project (if not already initialized)

If you haven't set up your project for Netlify, you can initialize it. This will create a `netlify.toml` configuration file:

```sh
netlify init
```

Follow the prompts to link an existing site or create a new one. This step is optional if you already have your project set up.

#### 3. Set Environment Variables (if needed)

If your project requires specific environment variables, you can set them using the Netlify CLI:

```sh
netlify env:set VARIABLE_NAME variable_value
```

Repeat this command for each environment variable your project needs.

#### 4. Build Your Project

Make sure your project is built. This typically involves running a build command like:

```sh
npm run build
```

Ensure that the output directory (e.g., `dist`, `build`, etc.) is ready for deployment.

#### 5. Deploy Your Site

Use the following command to deploy your site to Netlify. Replace `./build` with the path to your build directory if different.

```sh
netlify deploy --prod --dir=./build
```

- `--prod`: This flag specifies that you want to deploy to your production environment.
- `--dir=./build`: This specifies the directory where your built site is located.

You will be prompted to select a site if you haven't already linked your local directory to a Netlify site.

### Summary of Commands

```sh
# Install Netlify CLI if not installed
npm install -g netlify-cli

# Log in to Netlify
netlify login

# Initialize project (optional, if not already done)
netlify init

# Set environment variables (if needed)
netlify env:set VARIABLE_NAME variable_value

# Build your project
npm run build

# Deploy your project
netlify deploy --prod --dir=./build
```

### Additional Tips

- **Deploy to Draft URL**: If you want to deploy to a draft URL (for testing purposes), you can omit the `--prod` flag:
  
  ```sh
  netlify deploy --dir=./build
  ```

- **Deploy Message**: You can add a deploy message using the `--message` flag:

  ```sh
  netlify deploy --prod --dir=./build --message "Deploying the latest version"
  ```

Following these steps will allow you to manually deploy your site using the Netlify CLI.
