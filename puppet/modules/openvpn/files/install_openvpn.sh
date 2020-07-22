cd /etc/openvpn/keys
FILE = /etc/openvpn/keys/master.zip
if [ -f "$FILE" ]; then
    echo "master.zip is already downloaded"
else
    wget https://github.com/OpenVPN/easy-rsa/archive/master.zip
fi

DIR = /etc/openvpn/keys/easy-rsa-master/easyrsa3
if [ -d "DIR" ]; then
    echo "master.zip is already unzipped"
else
    unzip master.zip
fi

cd /etc/openvpn/keys/easy-rsa-master/easyrsa3
# mv vars.example vars
# ./easyrsa init-pki
# ./easyrsa build-ca
# ./easyrsa gen-req server nopass
# ./easyrsa sign-req server server < echo "yes"
# ./easyrsa gen-dh

# cp pki/ca.crt /etc/openvpn/ca.crt && \
# cp pki/dh.pem /etc/openvpn/dh.pem && \
# cp pki/issued/server.crt /etc/openvpn/server.crt && \
# cp pki/private/server.key /etc/openvpn/server.key

# ./easyrsa gen-req client nopass
# ./easyrsa sign-req client client < echo "yes"