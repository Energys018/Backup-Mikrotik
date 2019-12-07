# This file create user and send pub_key for ssh on your mikrotik.
#Req on mikrotik ssh and full privilege user.
#!/bin/bash

exec 5<&0
exec 6<&0
exec 7<&0
exec 8<&0
exec 0< .myfile
count=1
while read line
do
echo "Line #$count: $line"
count=$(( $count + 1 ))
done

exec 0<&5
read -p "Enter IP: " ipadd
case $ipadd in
esac

exec 0<&6
read -p "Enter Port: " ipport
case $ipport in
esac

exec 0<&7
read -p "Username: " username
case $username in
esac

exec 0<&8
read -p "Password: " password
case $password in
esac

hosts=( ) #Main massive
        hosts+=(${ipadd})
        hosts+=(${ipport})
        hosts+=(${username})
        hosts+=(${password})

cmd_user="/ user add name=bak password=awldkmalwdu group=read"
path_pub="/BakMik/conf/id_rsa_bak"    #file id_rsa ssh key
cmd_instkey="/user ssh-keys import public-key-file=id_rsa_bak user=bak"

sshpass -f <(printf '%s\n' ${hosts[3]}) ssh ${hosts[2]}@${hosts[0]} -p ${hosts[1]} "${cmd_user}"        # Create user bak
echo 1
sshpass -p ${hosts[3]} scp -P ${hosts[1]} ${path_pub} ${hosts[2]}@${hosts[0]}:/                         # Copy ssh_pub key
echo 2
sshpass -f <(printf '%s\n' ${hosts[3]}) ssh ${hosts[2]}@${hosts[0]} -p ${hosts[1]} "${cmd_instkey}"     # Install key from bak user
echo 3
echo Done
