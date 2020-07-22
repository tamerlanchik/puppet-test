cd /etc/openvpn/keys
wget https://github.com/OpenVPN/easy-rsa/archive/master.zip
unzip master.zip
cd /etc/openvpn/keys/easy-rsa-master/easyrsa3
mv vars.example vars
./easyrsa init-pki
./easyrsa build-ca
./easyrsa gen-req server nopass
./easyrsa sign-req server server < echo "yes"
./easyrsa gen-dh

cp pki/ca.crt /etc/openvpn/ca.crt
cp pki/dh.pem /etc/openvpn/dh.pem
cp pki/issued/server.crt /etc/openvpn/server.crt
cp pki/private/server.key /etc/openvpn/server.key

./easyrsa gen-req client nopass
./easyrsa sign-req client client < echo "yes"