#StoryLine- Incident Response Toolkit

#Display

#UserInput

    #Variable for Directory
    $directory = Read-Host -Prompt "Please enter the directory to store all the information generated by this script"
    
    #Input checking directory
    $testPath = Test-Path $directory
    #for testing
    #echo $testPath
    #Do while statements can be really helpful
    DO {
        if ( !$testPath){
            $directory = Read-Host -Prompt "Please enter a valid directory. Example: D:\drink\water"
            $testPath = Test-Path $directory
            }
        } while(!$testPath)
    #Variable for which Functions
    
    #Boolean for input error. Using a random thing to use it as a boolean
    $inputerror = "abc".Length -eq 5
    #Variable for the Hash Function
    DO {
        $hash = Read-Host -Prompt "Please enter hash function you want to use. Enter for default (MD5). Enter MD4, MD5, SHA1, SHA256 or SHA512"
        #Default value
        if ($hash -like ""){
        $hash = "MD5"
        #for testing
        #echo $hash
        }
        #Create an array for valid inputs
        $hashnames = @("MD4", "MD5", "SHA1", "SHA256", "SHA512")
    
        #Loop for checking hash input
    
            Foreach ($hashname in $hashnames){
            #if statement to check if the input is valid
                if ($hash = $hashname){
                    $inputerror = "abc".Length -eq 3
                    }
                   }
            } while(!$inputerror)
            

#Function to save files to CSV
Function saveFile($VariableName, $fileName){
    #Renaming- With date and time
    $date = Get-Date -Format "dd-MM-yyyy-HH-mm"
    $exportName = $fileName + "-" + $date
    #checking
    echo $exportName
    #Create path name
    $path = $directory + "\" + $exportName + ".csv"
    echo $path
    #echo $VariableName
    echo $VariableName | Export-Csv -Path $path -NoTypeInformation -ErrorAction Inquire

    #Creating Hashes
    #Certutil -hashfile {$path} {$hash}
    #creating variable for the filehash file
    $hashLoc = $directory + "\Hashcheck-" + $date + ".csv"
    #for testing
    echo $hashLoc
    Get-FileHash $path | Export-Csv -Path $hashLoc -Append
    }

#Running processes and the path for each process
Function Get-Processes{
    #Get the good stuff
    #Assign the value to Variable
    $process = @( Get-Process |Select-Object ProcessName, Path )
    #Call save function
    saveFile $process "Processes"
    }
#All registered services and the path to the executable controlling the service
Function Get-Services{
    #Get the good stuff
    #Assign the value to Variable
    $service = @( Get-WmiObject win32_service | select DisplayName, State, PathName, Name )
    #Call save function
    saveFile $service "RegisteredServices"
    }

#All TCP network sockets
Function NetTCPConnections{
    #Get the good stuff
    #Assign the value to Variable
    $NetTCPConnection = @( Get-NetTCPConnection )
    #Call save function
    saveFile $NetTCPConnection "TcpConnections"
    }

#All user account information (you'll need to use WMI)
Function UserAccount{
    #Get the good stuff
    #Assign the value to Variable
    $UserAccount = @( Get-WmiObject -Class Win32_UserAccount )
    #Call save function
    saveFile $UserAccount "AccountInformation"
    }

#All NetworkAdapterConfiguration information
Function NetAdapter{
    #Get the good stuff
    #Assign the value to Variable
    $NetAdapter = @( Get-NetAdapter -Name * -IncludeHidden )
    #Call save function
    saveFile $NetAdapter "NetworkAdapters"
    }

#All EventLogS 
    #Getting all logs is important in case of an incident.
    #This will also help  clean the data found from running proccesses search from earlier.

    #Get names of Logs into an array
    
    #Loop Names of logs
        
        #Get the good stuff

         
        #Get-EventLog -logName

        #Assign the value to Variable
        #Call save function

#Get-ExecutionPolicy
    #This can be helpful to see if there were any execution policies defined.
    #This can also show if any execution policy was changed.
Function ExecutionPolicy{
    #Get the good stuff
    #Assign the value to Variable
    $ExecutionPolicy = @( Get-ExecutionPolicy -List )
    #Call save function
    saveFile $ExecutionPolicy "ExecutionPolicy"
    }

#Create copy of the hard drive.
    
    #It is important to create a vhd copy of the hard drive. This would normally be done before turning the computer on.
    #There isn't enough space on my drive to create an entire copy of it so this code is going to commented out.
   function disk2vhd{
    #Get the good stuff
    #Assign the value to Variable
    $disk2vhd = @( disk2vhd  * $directory )
    #Call save function
    saveFile $disk2vhd "disk2vhd"
    }
    #disk2vhd

#Collect Hardware specification
    
    #It is important to keep a note of all the hardware specifications of the computer.
function Spec{
    $obj = @{}
    #Get the good stuff
    #Assign the value to Variable
    $cpu_info = Get-WmiObject win32_processor 
    $ram_size = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | Foreach {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))}

    $obj.RamCapacity_Gb = $ram_size

    $cpu_info | Format-Table | saveFile $cpu_info "cpu_info"
    $obj| Format-Table | saveFile $obj "RamSize"
    #Call save function

}
    

#Collect OS information
    #In all the other information, it is important to keep note of the OS and the version for future use.
    
function Os{
    #Get the good stuff
    #Assign the value to Variable
    $os_info = Get-CimInstance -ClassName Win32_OperatingSystem |Select-Object Caption, Version, OSArchitecture
    #Call save function
    saveFile $os_info "OS_Information"
}

function MainMenu{
    cls
    echo "This is the main menu"
    $userInput = Read-Host -Prompt "Default runs all the tools except the complete VHD hdd backup. Type q to quit, all to run all tools, list to use a single tool."
    DO {
    if ($userInput -like "q"){
    Exit
    }
    ElseIf ($userInput -like "all"){
    Get-Processes
    Get-Services
    NetTCPConnections
    UserAccount
    NetAdapter
    ExecutionPolicy
    Spec
    Os
    disk2vhd
    MainMenu
    }
    ElseIf ($userInput -like ""){
    Get-Processes
    Get-Services
    NetTCPConnections
    UserAccount
    NetAdapter
    ExecutionPolicy
    Spec
    Os
    MainMenu
    }
    ElseIf ($userInput -like "list"){
    echo "
    These are the possible tools:
    Get-Processes
    Get-Services
    NetTCPConnections
    UserAccount
    NetAdapter
    ExecutionPolicy
    Spec
    Os
    disk2vhd"
    $inputerror2 = "abc".Length -eq 5
    #Create an array for valid inputs
    $ToolNames = @("Get-Processes", "Get-Services", "NetTCPConnections", "UserAccount", "NetAdapter", "ExecutionPolicy", "Spec", "Os", "disk2vhd")
    DO {
        $ToolName = Read-Host -Prompt "Enter the name of the tool you want to run. Enter to return to the main menu"
        #Default value
        if ($ToolName -like ""){
        MainMenu
        #for testing
        #echo $hash
        }
        #Loop for checking toolname
    
            Foreach ($tool in $ToolNames){
            #if statement to check if the input is valid
                if ($ToolName = $tool){
                    $inputerror2 = "abc".Length -eq 3
                    }
        }
        } while(!$inputerror2)
   if ($inputerror2){
   Invoke-Expression $ToolName
   }
            
            Else {
            echo "Your syntax is incorrect. Accepted commands are *enter, all, q, list"
            sleep 2
            MainMenu
            $Error = "abc".Length -eq 5
            }}
    } While (!$Error)
    }
    
MainMenu

