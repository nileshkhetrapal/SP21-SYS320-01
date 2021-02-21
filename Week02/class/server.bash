#!/bin/bash



# Storyline:script to create a wireguard server



#Create private key

p="$(wg genkey)"



#create public key

pub="$(echo ${p} | wg pubkey)"



#Set the addresses

address="10.254.132.0/24,172.16.28.0/24"



#Set server Ip addresses

ServerAddress="10.254.132.1/24,172.16.28.1/24"





#Set the listeing port

lport="4282"



#creata the format fot the client config file

peerInfo="# ${address} 198.199.97.163:4282 ${pub} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"





echo "${peerInfo}

[Interface]

Address = ${ServerAddress}

# PostUP = /etc/Wireguard/wg-up.bash

#PostDown = /etc/Wireguard/wg-down.bash

ListenPort = ${lport}

PrivateKey = ${p}

" > wg0.conf
