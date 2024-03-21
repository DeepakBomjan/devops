external_url 'https://gitlab.example.com'
gitlab_rails['smtp_pool'] = true
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.gmail.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_authentication'] = "plain"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_user_name'] = "git@gmail.com"
gitlab_rails['smtp_password'] = "changeme"
gitlab_rails['smtp_domain'] = "smtp.gmail.com"
gitlab_rails['gitlab_email_from'] = 'git@gmail.com'
gitlab_rails['gitlab_email_reply_to'] = 'git@gmail.com'
registry_external_url 'https://gitlab.example.com:5050'
registry['enable'] = true
letsencrypt['contact_emails'] = ['devopsxsend@gmail.com'] # This should be an array of email addresses to add as contacts
letsencrypt['auto_renew'] = true


gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.gmail.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "devopsxsend@gmail.com"
gitlab_rails['smtp_password'] = "eoxa fibb ptst fprg"
gitlab_rails['smtp_domain'] = "smtp.gmail.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false
gitlab_rails['smtp_openssl_verify_mode'] = 'peer' # Can be: 'none', 'peer', 'client_once', 'fail_if_no_peer_cert', see http://api.rubyonrails.org/classes/ActionMailer/Base.html


Notify.test_email('devopsxsend@gmail.com', 'Hello World', 'This is a test message').deliver_now

