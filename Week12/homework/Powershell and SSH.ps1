cls
# Login to a remote SSH server
#New-SSHSession -ComputerName '192.168.0.28' —Credential (Get-credential kali)
<#
while ($true) {
# Add a prompt to run commands
$the_cmd = read-host -Prompt "please enter a command"
# Run command on remote SSH server
(Invoke-SSHCommand -index 0 $the_cmd).Output
}
#>

#I am not on campus, so I used a Kali VM as my SSH server

Set-SCPFile -ComputerName '192.168.0.28' -Credential (Get-credential kali) `
-RemotePath '/home/kali' -LocalFile 'C:\Users\nilek\OneDrive\Documents\hello.zip' -Verbose
#made it verbose to see if the file was uploaded properly or not.

$file = Get-FileHash "C:\Users\nilek\OneDrive\Documents\hello.zip" 

#using SCP to check if it is there
Get-SCPFile -ComputerName '192.168.0.28' -Credential (Get-credential kali) `
-RemoteFile '/home/kali/hello.zip' -LocalFile 'C:\Users\nilek\OneDrive\Pictures\hello.zip'
$check = Get-FileHash 'C:\Users\nilek\OneDrive\Pictures\hello.zip'

echo $file
echo $check
