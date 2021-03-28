#Storyline: To start and stop the calculator app from powershell
#to start
calc
echo "successfully started"

#to stop
Stop-Process -Name calc
echo "successfully stopped"