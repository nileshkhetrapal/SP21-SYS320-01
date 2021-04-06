#Storyline: To start and stop the calculator app from powershell
#to start
Start-Process -Name Calculator
echo "successfully started"

#to stop
Stop-Process -Name Calculator
echo "successfully stopped"
