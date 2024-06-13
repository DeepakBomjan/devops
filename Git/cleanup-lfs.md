If you need to remove a large file from your Git history without using `git filter-repo`, you can use `git rebase` or `git reset` to remove the file from your current branch. However, removing a file from the entire Git history without tools like `git filter-repo` or BFG Repo-Cleaner is more complex. 

For now, I'll guide you through using `git rebase` and `git reset` to remove a large file from your branch and push the changes.

### Steps to Remove a Large File

1. **Remove the file from the index:**

   ```sh
   git rm --cached IaC/Terraform/.terraform/providers/registry.terraform.io/hashicorp/aws/5.31.0/darwin_amd64/terraform-provider-aws_v5.31.0_x5
   ```

2. **Commit the changes:**

   ```sh
   git commit -m "Remove large file"
   ```

3. **Push the changes:**

   ```sh
   git push origin git-hol
   ```

### Remove File from History Using Interactive Rebase

1. **Start an interactive rebase:**

   ```sh
   git rebase -i HEAD~n
   ```

   Replace `n` with the number of commits to go back. If you want to go back 10 commits, use `HEAD~10`.

2. **Mark commits for editing:**

   In the interactive rebase editor, mark the commits that added or modified the large file with `edit`. Save and exit the editor.

3. **Remove the file from each marked commit:**

   For each commit that you marked for editing, remove the large file and amend the commit:

   ```sh
   git rm --cached IaC/Terraform/.terraform/providers/registry.terraform.io/hashicorp/aws/5.31.0/darwin_amd64/terraform-provider-aws_v5.31.0_x5
   git commit --amend --no-edit
   git rebase --continue
   ```

4. **Force push the changes:**

   ```sh
   git push origin --force git-hol
   ```

### Remove the File from History Using Soft Reset

1. **Reset to a previous commit:**

   ```sh
   git reset --soft HEAD~n
   ```

   Replace `n` with the number of commits to go back.

2. **Remove the file:**

   ```sh
   git rm --cached IaC/Terraform/.terraform/providers/registry.terraform.io/hashicorp/aws/5.31.0/darwin_amd64/terraform-provider-aws_v5.31.0_x5
   ```

3. **Recommit the changes:**

   ```sh
   git commit -m "Remove large file from history"
   ```

4. **Force push the changes:**

   ```sh
   git push origin --force git-hol
   ```

### Example Workflow Using Interactive Rebase

1. **Start an interactive rebase:**

   ```sh
   git rebase -i HEAD~10
   ```

2. **Mark the relevant commits for editing:**

   ```
   pick e5e6a3d Initial commit
   edit d4c3b2a Added large file
   pick a1b2c3d Other changes
   ...
   ```

3. **Edit the commit that added the large file:**

   ```sh
   git rm --cached IaC/Terraform/.terraform/providers/registry.terraform.io/hashicorp/aws/5.31.0/darwin_amd64/terraform-provider-aws_v5.31.0_x5
   git commit --amend --no-edit
   git rebase --continue
   ```

4. **Force push the cleaned branch:**

   ```sh
   git push origin --force git-hol
   ```

This workflow will help you remove the large file from the current branch and push the changes, but it does not clean the file from the entire repository history. For comprehensive history cleaning, tools like `git filter-repo` or BFG Repo-Cleaner are highly recommended.
