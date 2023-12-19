## nginx conf
```
server {
        listen 443 ssl;
	server_name _;

	access_log   /var/log/nginx/access.log  combined;

	ssl_certificate    /home/ubuntu/react-quiz-form/mkcert/example.com+5.pem;
    ssl_certificate_key  /home/ubuntu/react-quiz-form/mkcert/example.com+5-key.pem;

	location / {
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "Upgrade";
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    		proxy_pass http://localhost:3000;
	}
}

```