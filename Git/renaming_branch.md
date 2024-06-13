Renaming a branch in Git can be done either locally or remotely. Here are the steps for both scenarios:

### Renaming a Local Branch

1. **Rename the Current Branch:**

   If you are on the branch you want to rename, use:

   ```sh
   git branch -m <new-branch-name>
   ```

2. **Rename a Branch You're Not Currently On:**

   If you are not on the branch you want to rename, use:

   ```sh
   git branch -m <old-branch-name> <new-branch-name>
   ```

### Renaming a Remote Branch

Renaming a remote branch involves a few more steps since Git does not have a direct command to rename a remote branch.

1. **Rename the Local Branch:**

   First, rename the local branch using the steps mentioned above.

2. **Push the Renamed Branch to the Remote:**

   ```sh
   git push origin <new-branch-name>
   ```

3. **Delete the Old Branch from the Remote:**

   ```sh
   git push origin --delete <old-branch-name>
   ```

4. **Reset the Upstream Branch for the New Local Branch:**

   ```sh
   git push --set-upstream origin <new-branch-name>
   ```

### Example

Let's assume you want to rename the branch `old-feature` to `new-feature`.

1. **Rename the Local Branch:**

   If you are on `old-feature`:

   ```sh
   git branch -m new-feature
   ```

   If you are not on `old-feature`:

   ```sh
   git branch -m old-feature new-feature
   ```

2. **Push the Renamed Branch to the Remote:**

   ```sh
   git push origin new-feature
   ```

3. **Delete the Old Branch from the Remote:**

   ```sh
   git push origin --delete old-feature
   ```

4. **Reset the Upstream Branch for the New Local Branch:**

   ```sh
   git push --set-upstream origin new-feature
   ```

### Summary

Here are the commands combined for clarity:

```sh
# Step 1: Rename the local branch
git branch -m old-feature new-feature

# Step 2: Push the renamed branch to the remote
git push origin new-feature

# Step 3: Delete the old branch from the remote
git push origin --delete old-feature

# Step 4: Set the upstream branch for the new branch
git push --set-upstream origin new-feature
```

This process will rename the branch both locally and remotely, ensuring consistency across your Git environment.
