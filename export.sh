#!/bin/bash
hosts=(
        ip.ad.re.ses_PORT_Organisation_mikrotik-identity \
        8.8.8.8_22_google_gw-dns #example \
)

sdate=`date +%d-%m-%Y`  # System date
tdate=`date +%H:%M:%S`  # System time
adate=`date +%h`        # Archive date

dir_b="/BackupMik/backups/" # Storage for backups
dir_a="/BackupMik/archive/"   # Storage for archive
dir_l="/BackupMik/logs/"      # Storage for logs
dir_c="/BackupMik/conf/"      # Storage for conf

username="bak"                  # SSH user
cmd="/ export"                  # Command of backup configuration
key="-i ${dir_c}/id_rsa"        # SSH private key for user "$username"
 
for host in ${hosts[*]}
do
value=($(echo ${host} | tr "_" " "))                    #create structure massive.
old_dir="${dir_b}${value[2]}/${value[3]}"               #/*.*/backups/XXXX/XXXXXX
new_dir="${dir_b}${value[2]}/${value[3]}/${sdate}"      #/*.*/backups/XXXX/XXXXXX/XX:XX:XXXX
mkdir -p ${new_dir}
if ssh ${key} ${username}@${value[0]} -p ${value[1]} "${cmd}" >> ${new_dir}/${tdate}.txt; then # Send cmd for export, and write on log file.
        echo "Success_${tdate}_${sdate}_${value[2]}_${value[3]}" >> ${dir_l}/messages_${sdate}.log
else
        rm "${new_dir}/${tdate}.txt"
        echo "Fail_${tdate}_${sdate}_${value[2]}_${value[3]}" >> ${dir_l}/messages_${sdate}.log
fi
done
#find /BackupMik/backups/* -ctime +180 -type f -exec tar -rvf /BackupMik/archive/archive-${adate}.tar.gz {} +
#find /BackupMik/backups/* -ctime +180 -type f -exec rm {} +
        echo "====================="    >> ${dir_l}/messages_${sdate}.log

#zip -r -tt $(date +%Y-%m-01) -t $(date +%Y-%m-01 -d 'last month') \
#    "${dir_b}$(date +%Y-%m-%d)" ${dir_a}
#find ${old_dir} -mindepth 0 -mtime ${age} -type f -exec cd ${old-dir} && tar -czvf ${adate}-00-00.tar.gz ${new_dir} {} \;
