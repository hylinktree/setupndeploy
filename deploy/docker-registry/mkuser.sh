rm -rf .auth 2>/dev/null 
mkdir .auth 2>/dev/null
htpasswd -Bc .auth/registry.password iii 

# docker run --rm -it \
#   -p 5009:5000 \
#   -e "REGISTRY_AUTH=htpasswd" \
#   -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
#   -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
#   -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/auth.crt \
#   -e REGISTRY_HTTP_TLS_KEY=/certs/auth-no.key \
#   -v "$(pwd)"/data:/data \
#   -v "$(pwd)"/auth:/auth \
#   -v "$(pwd)"/certs:/certs \
#   registry:2 
