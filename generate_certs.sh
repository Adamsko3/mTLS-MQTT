#!/bin/bash

# Création des répertoires
mkdir -p certs csr
chmod 700 certs csr

# Création de la CA Root
openssl genrsa -out ca.key 2048
openssl req -new -x509 -key ca.key -out ca.crt -days 3650 \
-subj "/C=fr/ST=ile-de-france/L=paris/O=IB/OU=IB-Data/CN=MQTT-CA"

# Génération des Clés Privées et CSR pour le Broker et le Client
openssl genrsa -out broker.key 2048
openssl genrsa -out client.key 2048
openssl req -new -key broker.key -out broker.csr \
-subj "/C=FR/ST=Ile-de-France/L=Paris/O=IB/OU=IB-Data/CN=MQTT-test"
openssl req -new -key client.key -out client.csr \
-subj "/C=FR/ST=Ile-de-France/L=Paris/O=IB/OU=IB-Data/CN=iot-client-iba"

# Signature des Certificats avec la CA
openssl x509 -req -in broker.csr -CA ca.crt -CAkey ca.key \
-CAcreateserial -out broker.crt -days 365
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key \
-CAcreateserial -out client.crt -days 365

# Vérification des Certificats
openssl x509 -in broker.crt -text -noout | grep "MQTT-test"
openssl x509 -in client.crt -text -noout | grep "iba"
openssl x509 -in ca.crt -text -noout | grep "MQTT-CA"

# Sécurisation des Fichiers
chmod 600 *.key
chmod 644 *.crt *.csr

echo "Certificats et clés générés avec succès dans le répertoire courant."
