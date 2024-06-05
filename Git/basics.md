Certainly! Here are Git commands categorized from basics to advanced:

### Basics

1. **Initialization**
   - `git init`: Initialize a new Git repository.

2. **Cloning**
   - `git clone <repository-url>`: Clone an existing repository into a new directory.

3. **Adding and Committing**
   - `git add <file>`: Add file(s) to the staging area.
   - `git commit -m "message"`: Commit staged changes to the repository.

4. **Status and Logs**
   - `git status`: Show the status of files in the working directory.
   - `git log`: Display commit history.

### Branching and Merging

5. **Branch Management**
   - `git branch <branch-name>`: Create a new branch.
   - `git branch -d <branch-name>`: Delete a branch.
   - `git branch -m <old-branch-name> <new-branch-name>`: Rename a branch.

6. **Switching and Merging**
   - `git checkout <branch-name>`: Switch to a different branch.
   - `git merge <branch-name>`: Merge changes from one branch into another.

### Collaboration and Remote

7. **Remote Configuration**
   - `git remote add <name> <url>`: Add a remote repository.
   - `git remote -v`: List remote repositories.

8. **Pushing and Pulling**
   - `git push <remote> <branch>`: Push local changes to a remote repository.
   - `git pull <remote> <branch>`: Fetch and integrate changes from a remote repository.

9. **Fetching**
   - `git fetch <remote>`: Fetch changes from a remote repository.

### Advanced

10. **Stashing**
    - `git stash`: Stash changes in the working directory.

11. **Rebasing**
    - `git rebase <branch-name>`: Reapply commits on top of another base tip.

12. **Interactive Rebase**
    - `git rebase -i <commit>`: Interactively rebase commits.

13. **Cherry-Picking**
    - `git cherry-pick <commit>`: Apply changes introduced by some existing commits.

14. **Reflog**
    - `git reflog`: Show a log of the commit references.

15. **Submodules**
    - `git submodule add <repository-url>`: Add a submodule to the repository.
    - `git submodule update --init --recursive`: Update submodules.

These commands range from the essential operations like adding and committing changes to more advanced tasks like rebasing and cherry-picking commits.
