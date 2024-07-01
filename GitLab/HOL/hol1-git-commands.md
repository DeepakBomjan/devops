## In this Lab, we will cover following topics
### Part 1:
1. Creating Repository
2. Cloning Repository
3. Changing Git remote
4. Rebasing
5. Creating Pull request
6. Merging
7. Handling Merge Conflicts

Solutions:
### Setting up repository
1. Create Empty Repository
```bash
git init devops-temp
```
2. Change Directory to `devops-temp`
```bash
cd devops-temp
```
3. Check the project upstream
```bash
git remote -v
```
4. Set Remote repository
```bash
git remote add origin https://gitlab.cas.com.np/training/devops.git
```
5. Check branch mapping 
```bash
git branch -vv
```
6. Push changes 
```bash
git push
```
7. Set upstream for branch and push
```bash
 git push --set-upstream origin2 main
```

You may ask the git login credential if first time, [Go to](#configure-git-credentials) 
8. Set tracking branch
```bash
git branch --set-upstream-to=origin2/main main
```
9. Verify
```bash
git branch -vv
```
10. Push changes
```bash
git push
```
Till Now we have set the upstream of our local repostiory and remote tracking branch


Let's continue working on the branch

### Creating branch, Pull Requests(Merge Requests), and Merging changes
1. Create new branch
```bash
git branch feature1
```
2. Check which branch you are in
```bash
git branch
```
3. Switch to new branch
```bash
git checkout feature1
```
4. Add Changes
```bash
cat >> README.md
## Git branching flow
1. Trunk based Development
2. Git Flow
3. GitLab Flow
```
5. Stage the changes
```bash
git add README.md
```
6. Commit the changes
```bash
git commit -m "Update README.md"
```
7. Push the changes
```bash
git push
```
### Creating Merge Requests

## Configure git credentials
Configuring Git credentials involves setting up how Git should authenticate with remote repositories. There are several ways to configure credentials in Git:

1.  [Using Git Credential Helpers](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage)  
 Git can use various credential helpers to store credentials securely. Some common helpers include:
    1. **Cache**: Stores credential in memory for 15 minutes.
    2. **Store**
    3. **Manager**  
 To configure a credential helper globally, you can run:
 ```bash
 git config --global credential.helper cache
```
2. Create **Project Access Tokens**   
    **Go to** Project Setting -> **Access Tokens** -> Select roles and Click **Create Project Access Tokens**

### Git Access Tokens
1. [Personal Access Tokens](https://docs.gitlab.com/17.0/ee/user/profile/personal_access_tokens.html#create-a-personal-access-token)
2. [Project Access Tokens](https://docs.gitlab.com/17.0/ee/user/project/settings/project_access_tokens.html#create-a-project-access-token)
3. [Group Access Tokens](https://docs.gitlab.com/17.0/ee/user/group/settings/group_access_tokens.html#create-a-group-access-token-using-ui)


### During `git pull` you might get below message
```bash
hint: You have divergent branches and need to specify how to reconcile them.
hint: You can do so by running one of the following commands sometime before
hint: your next pull:
hint:
hint:   git config pull.rebase false  # merge
hint:   git config pull.rebase true   # rebase
hint:   git config pull.ff only       # fast-forward only
hint:
hint: You can replace "git config" with "git config --global" to set a default
hint: preference for all repositories. You can also pass --rebase, --no-rebase,
hint: or --ff-only on the command line to override the configured default per
hint: invocation.
fatal: Need to specify how to reconcile divergent branches.
```

### [GitLab Label](https://docs.gitlab.com/ee/user/project/labels.html)

### [How to use GitLab for Agile portfolio planning and project management](https://about.gitlab.com/blog/2020/11/11/gitlab-for-agile-portfolio-planning-project-management/)


### [Setup GitLab Organization](https://docs.gitlab.com/ee/tutorials/manage_user/index.html)
