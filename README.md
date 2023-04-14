# Make your own CA and Certificates for testing
NOT TO BE USED IN PRODUCTION ENVIRONMENTS - test environments only.

This repo contains 2 shell scripts to:
- Create a root and intermediate certificate authority
- Create a server certificate signed by the intermediate authority that has both TLS Web Server Authentication, TLS Web Client Authentication extended attributes.

# Requirements
- A linux like environment that can run bash shell scripts
- openssl must be installed and available

# Usage
- Clone or download the scripts into the same directory on your system.
- Run create_root_and_intermediate_certs.sh to create the root and intermediate CAs. (You only have to do this ONCE - you can create multiple server certs and keys from the same root and intermediate CA.
- Second, run create_server_key_and_certificate.sh [hostname] [ip address] for the server/ip you want to create a certificate for. (Create as many separate server certs that you need.)

# Output
- rootCA.crt, rootCA.key
- intermediateCA.crt, intermediateCA.key
- [server].crt, [server].key
- as well as a bunch of .conf, .csr files...

  The crt files will be in PEM format.
  The key files will be in unencrypted PKCS8.  
  
# To Do
- I may add more options later to create in PKCS12/PFX/DER
- I may add more options later to create keys in PKCS1 encrypted/unencrypted
