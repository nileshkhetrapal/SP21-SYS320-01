#Storyline: send an email
#Variable can have ana underscore or any alphanumeric value

#body of the email
$msg = "General Kenobi"

#Echo to the screen
write-host -BackgroundColor Red -ForegroundColor White $msg

#Email from Address
$email = "nilesh.khetrapal@mymail.champlain.edu"

#To address
$toEmail = "deployer@csi-web"

#Sending the email
Send-MailMessage -From $email -To $toEmail -Subject "Hello There" -body $msg -SmtpServer 192.168.6.71