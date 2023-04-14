#!/bin/sh

#  First run the create_root_and_intermediate_certs.sh if you haven't already
#
#  Run this to create a key and cert
#  for a server with both
#  TLS Web Server Authentication, TLS Web Client Authentication extended attributes
#  signed by a test intermediate and root CA
#
#  Arguments: $1 = hostname of server to create the cert for
#             $2 = ip address of hostname to create the cert for

create_server_private_key()
{
    openssl genrsa -out $1.key 2048
}

create_server_csr_conf()
{
    cat > $1_csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = US
ST = Minneosta
L = Bloomington
O = TEST-CERTS
OU = CERTS
CN = $1

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $1
IP.1 =  $2

EOF
}

create_server_csr()
{
    openssl req -new -key $1.key -out $1.csr -config $1_csr.conf
}

create_server_cert_conf()
{
    cat > $1_cert.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = $1
IP.1 =  $2

EOF
}

create_server_cert()
{
    openssl x509 -req \
        -in $1.csr \
        -CA intermediateCA.crt -CAkey intermediateCA.key \
        -CAcreateserial -out $1.crt \
        -days 730 \
        -sha256 -extfile $1_cert.conf
}


###
# Main 
###
echo ""
echo ""
echo "Creating key and cert for $1 with IP address: $2..."
echo ""
echo ""

create_server_private_key $1
create_server_csr_conf $1 $2
create_server_csr $1
create_server_cert_conf $1 $2
create_server_cert $1

echo ""
echo ""
echo "Done."
echo ""
echo "You should have a $1.key and $1.crt"
echo "The cert is in PEM format and the key is in "
echo "  PKCS8 unencrypted format."
echo ""
echo "These certs are ONLY for testing"
echo "  and should NOT be used in a production environment."
echo ""