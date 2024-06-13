To merge one repository with another, including all branches, you can follow these steps:

1. **Add the source repository as a remote in the destination repository.**
2. **Fetch all branches from the source repository.**
3. **Check out and merge each branch from the source repository into the destination repository.**
4. **Push the merged branches to the destination repository's remote.**

Here's a detailed step-by-step guide:

### Example

Assuming:
- Source repository URL: `https://github.com/user/source-repo.git`
- Destination repository URL: `https://github.com/user/destination-repo.git`
- Remote name for source repository: `source`
- Remote name for destination repository: `origin`

1. **Navigate to the destination repository:**
   ```sh
   cd path/to/destination-repo
   ```

2. **Add the source repository as a remote:**
   ```sh
   git remote add source https://github.com/user/source-repo.git
   ```

3. **Fetch all branches from the source repository:**
   ```sh
   git fetch source
   ```

4. **List all branches from the source repository:**
   ```sh
   git branch -r
   ```
   This will show all remote branches, including those from `source`.

5. **Create and merge each branch from the source repository:**

   Loop through each branch you want to merge from the source repository:

   ```sh
   for branch in $(git branch -r | grep 'source/' | sed 's/source\///'); do
       git checkout -b $branch source/$branch
       git checkout main  # or master, or whatever your base branch is
       git merge $branch
       git branch -d $branch  # Delete the local branch after merging
   done
   ```

   Alternatively, if you want to keep the branches:

   ```sh
   for branch in $(git branch -r | grep 'source/' | sed 's/source\///'); do
       git checkout -b $branch source/$branch
       git push origin $branch
   done
   ```

6. **Push all branches to the destination repository's remote:**
   ```sh
   git push --all origin
   ```

7. **Optionally, remove the `source` remote if you no longer need it:**
   ```sh
   git remote remove source
   ```

### Full Example Commands

Here is the full example in one go:

```sh
# Navigate to the destination repository
cd path/to/destination-repo

# Add the source repository as a remote
git remote add source https://github.com/user/source-repo.git

# Fetch all branches from the source repository
git fetch source

# List all branches from the source repository
git branch -r

# Loop through each branch from the source repository
for branch in $(git branch -r | grep 'source/' | sed 's/source\///'); do
    # Check out the branch locally
    git checkout -b $branch source/$branch

    # Push the branch to the destination repository's remote
    git push origin $branch
done

# Optionally, remove the source remote
git remote remove source
```

This sequence of commands will merge all branches from the `source-repo` into the `destination-repo`, preserving the history and commits of each branch.
