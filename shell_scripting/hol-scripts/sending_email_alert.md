## Mutt configuration

```
set from = "devopsxsend@gmail.com"
set realname = "Alert Master"
set imap_user = "devopsxsend@gmail.com"
set imap_pass = "7la[E9T~[8Sh"
set folder = "imaps://imap.gmail.com:993"
set spoolfile = "+INBOX"
set postponed ="+[Gmail]/Drafts"
set header_cache =~/.mutt/cache/headers
set message_cachedir =~/.mutt/cache/bodies
set certificate_file =~/.mutt/certificates
set smtp_url = "smtp://user@smtp.gmail.com:587/"
set smtp_pass = "gmail-password"
set move = no 
set imap_keepalive = 900
```

set realname = "Devops Xsend"
set from = "devopsxsend@gmail.com"
set use_from = yes
set envelope_from = yes

set smtp_url = "smtps://devopsxsend@gmail.com@smtp.gmail.com:465/"
set smtp_pass = "7la[E9T~[8Sh"
set imap_user = "devopsxsend@gmail.com"
set imap_pass = "7la[E9T~[8Sh"
set folder = "imaps://imap.gmail.com:993"
set spoolfile = "+INBOX"
set ssl_force_tls = yes

# G to get mail
bind index G imap-fetch-mail
set editor = "vim"
set charset = "utf-8"
set record = ''