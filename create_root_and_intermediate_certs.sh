#!/bin/sh

create_root_pair()
{
    openssl req -x509 \
            -sha256 -days 3560 \
            -nodes \
            -newkey rsa:2048 \
            -subj "/CN=ROOT-CA/C=US/ST=Minnesota/L=Bloomington/O=TEST-CA/OU=CERTS" \
            -keyout rootCA.key -out rootCA.crt 
}

create_intermediate_private_key()
{
    openssl genrsa -out intermediateCA.key 2048
}

create_intermediate_csr_conf()
{
    cat > intermediateCA_csr.conf <<EOF
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
O = TEST-CA
OU = CERTS
CN = INTERMEDIATE-CA

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = INTERMEDIATE-CA

EOF
}

create_intermediate_csr()
{
    openssl req -new -key intermediateCA.key -out intermediateCA.csr -config intermediateCA_csr.conf
}

create_intermediate_cert_conf()
{
    cat > intermediateCA_cert.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=critical,CA:TRUE
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
subjectAltName = @alt_names

[alt_names]
DNS.1 = INTERMEDIATE-CA

EOF
}

create_intermediate_cert()
{
 openssl x509 -req \
    -in intermediateCA.csr \
    -CA rootCA.crt -CAkey rootCA.key \
    -CAcreateserial -out intermediateCA.crt \
    -days 3649 \
    -sha256 -extfile intermediateCA_cert.conf   
}


###
# Main
###
echo ""
echo ""
echo "Creating root and intermediate CA's..."
echo ""
echo ""

create_root_pair
create_intermediate_private_key
create_intermediate_csr_conf
create_intermediate_csr
create_intermediate_cert_conf
create_intermediate_cert

echo ""
echo ""
echo "Done."
echo "You should have a rootCA.key, rootCA.crt"
echo "  intermediateCA.key and intermediateCA.crt."
echo "These certs are ONLY for testing and signing "
echo "  other test certs and should NOT be used"
echo "  in a production environment."
echo ""
