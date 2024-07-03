
1. Docker compose file for gitlab ce
```yaml
version: '3.6'
services:
  web:
    image: 'gitlab/gitlab-ce:15.9.8-ce.0'
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'https://gitlab.example.com'
        # Add any other gitlab.rb configuration here, each on its own line
    ports:
      - '80:80'
      - '443:443'
      - '22:22'
      - '5050:5050'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    shm_size: '256m'
```

2. Docker compose file for gitlab runner
```yaml
version: "3.5"

services:
  dind:
    image: docker:20-dind
    restart: always
    privileged: true
    environment:
      DOCKER_TLS_CERTDIR: ""
    command:
      - --storage-driver=overlay2
    volumes:
      - ./data/dind/docker:/var/lib/docker

  runner:
    restart: always
    image: registry.gitlab.com/gitlab-org/gitlab-runner:alpine
    volumes:
      - ./config:/etc/gitlab-runner:z
      - ./data/runner/cache:/cache
        ###- /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DOCKER_HOST=tcp://dind:2375
```

3. gitlab.rb file
```ruby
external_url 'https://git.example.com'
gitlab_rails['smtp_pool'] = true
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.gmaill.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_authentication'] = "plain"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_user_name'] = "gitlab@example.com"
gitlab_rails['smtp_password'] = ""
gitlab_rails['smtp_domain'] = "smtp.gmail.com"
gitlab_rails['gitlab_email_from'] = 'gitlab@example.com'
gitlab_rails['gitlab_email_reply_to'] = 'gitlab@example.com'
registry_external_url 'https://example.com:5050'
registry['enable'] = true
letsencrypt['contact_emails'] = ['gitlab@example.com'] # This should be an array of email addresses to add as contacts
letsencrypt['auto_renew'] = true
```