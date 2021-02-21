#storyline: Extract IPs from emergingthreats.net and create a firewall ruleset 

#Checking to see if the threat file exists

tFile="/tmp/emerging-drop.suricata.rules"

if [[ -f "{tFile}" ]]
then 
echo "the file exists"
#Prompt to redownload
echo -n "Should we redownload? Y|N"
read to_download
else
#Prompt to download
echo -n "should we download it? Y|N "
read to_download
fi
#Processing the prompt
if [[ "${to_download}" == "N" || "${to_download}" == "n" ]]
then
echo "exiting"
elif [[ "${to_download}" == "Y" || "${to_download}" == "y" ]]
then
#Download the file
wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
echo "Downloaded"
fi

#create a firewall ruleset
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' "${tFile}" | sort -u | tee badIPs.txt
#for Linux
for eachIP in $(cat badIPs.txt)
do
	#For MAC
	echo "block in from ${eachIP} to any" | tee -a pf.conf
	#For linux
	echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
done
#for MAC
mFile="pf.conf"

if [[ -f "{mFile}" ]]
then
echo "the file exists"
else
echo '
scrub-anchor "com.apple/*"
nat-anchor "com.apple/*"
rdr-anchor "come.apple/*"
dummynet-anchor "com.apple/*"
anchor "com.apple/*"
load anchor "com.apple" from "/etc/pf.anchors/com.apple"
' | tee pf.conf
fi
for eachIP in $(cat badIPs.txt)
do
        #For MAC
        echo "block in from ${eachIP} to any" | tee -a pf.conf
done

#Menu
function menu() {
echo "[C]isco blocklist generator"
echo "[D]omain URL blocklist generator"
echo "[N]etscreen blocklist generator"
echo "[W]indows blocklist generator"
read -p "Please enter a choice above: " choice

case "$choice" in
esac
}
#Adding another switch to parse the csv
