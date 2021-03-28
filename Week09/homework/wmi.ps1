#Use the Get-WMIobject cmdlet
#Getting information about all the network adapters
#Get-WmiObject -Class Win32_NetworkAdapter
#Get IP address, default gateway and DNS servers
Get-WmiObject Win32_NetworkAdapterConfiguration | Select ServiceName, DHCPServer, IPAddress, DNSServerSearchOrder|  Where { $_.IPAddress, $_.DHCPServer, $_.DNSServerSearchOrder }
