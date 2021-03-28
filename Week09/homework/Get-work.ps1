#Storyline: Using the get-process and Get-service
Get-Process |Select-Object ProcessName| Export-Csv -Path "C:\users\ASUS TUF GAMING\Desktop\myprocesses.csv" -NoTypeInformation
Get-Service |Select-Object ServiceName| Export-Csv -Path "C:\users\ASUS TUF GAMING\Desktop\myservices.csv" -NoTypeInformation