#requires -version 4

<#

.SYNOPSIS

  User Creation for Oakham School Students and Staff.



.DESCRIPTION

  The script will create accounts in Active directory, connect to onpremise exchange and enable 
  the accounts remote mailbox it will then force a sync with Azure AD before waiting 10 minutes to ensure
  completion. It will then assign licenses to the users in the csv.



.PARAMETER <Parameter_Name>

  <Brief description of parameter input required. Repeat this attribute if required>



.INPUTS

  Will require a CSV file containing necessary user information



.OUTPUTS Log File

  The script log file stored in C:\Logs\UserCreation.log



.NOTES

  Version:        1.0

  Author:         Jack Webb

  Creation Date:  04/08/2017

  Purpose/Change: 
  04/08/2017     Initial script development



.EXAMPLE

  <Example explanation goes here>

  

  <Example goes here. Repeat this attribute for more than one example>

#>



#---------------------------------------------------------[Script Parameters]------------------------------------------------------



Param (

  #Script parameters go here

    [Parameter(Mandatory, ValueFromPipelineByPropertyname)]

	[ValidateNotNullOrEmpty()]

	[string]$FirstName = $_.GivenName,

	

	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]

	[ValidateNotNullOrEmpty()]

	[string]$LastName = $_.Surname,

	

	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]

	[ValidateNotNullOrEmpty()]

	[string]$MiddleInitial,

	

	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]

	[ValidateNotNullOrEmpty()]

	[string]$Department,

	

	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]

	[ValidateNotNullOrEmpty()]

	[string]$Title,

	

	[Parameter(ValueFromPipelineByPropertyname)]

	[ValidateNotNullOrEmpty()]

	[string]$Location = 'OU=Corporate Users',

	

	[Parameter()]

	[ValidateNotNullOrEmpty()]

	[string]$DefaultGroup = 'XYZCompany',

	

	[Parameter()]

	[ValidateNotNullOrEmpty()]

	[string]$DefaultPassword = 'p@$$w0rd12345',


)


            -SamAccountName $_.SamAccountName `
            -UserPrincipalName $_.UserPrincipalName `
            -Name $_.Name `
            -DisplayName $_.DisplayName `
            -GivenName $_.GivenName `
            -SurName $_.SurName `
            -Office $_.Office `
            -EmailAddress $_.UserPrincipalName `
            -Description $_.Description `
            -Department $_.Department `
            -title $_.Title `
            -company $_.Company `
            -profilePath $_.ProfilePath `
            -scriptPath $_.ScriptPath `
            -HomeDirectory $_.homeDirectory `
            -HomeDrive $_.homeDrive `
            -Path $_.Path `
            -AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -force) -PassThru



#---------------------------------------------------------[Initialisations]--------------------------------------------------------



#Set Error Action to Silently Continue

$ErrorActionPreference = 'SilentlyContinue'



#Import Modules & Snap-ins

Import-Module PSLogging



#----------------------------------------------------------[Declarations]----------------------------------------------------------



#Script Version

$sScriptVersion = '1.0'



#Log File Info

$sLogPath = 'C:\Logs'

$sLogName = 'UserCreation.log'

$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName



#-----------------------------------------------------------[Functions]------------------------------------------------------------


Function Connect-OnPremiseExchange {

  Param ()

  Begin {
    Write-LogInfo -LogPath $sLogFile -Message 'Attemtping connection to http://dc-email-01.oakham.rutland.sch.uk/PowerShell/...'
  }

  Process {

    Try {
        $Session_OnPremiseExchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://dc-email-01.oakham.rutland.sch.uk/PowerShell/ -Authentication Kerberos -Credential $UserCredential
        Import-PSSession $Session_OnPremiseExchange   
    }

    Catch {
      Write-LogError -LogPath $sLogFile -Message $_.Exception -ExitGracefully
      Break
    }
  }

  End {
    If ($?) {
      Write-LogInfo -LogPath $sLogFile -Message 'Completed Successfully.'
      Write-LogInfo -LogPath $sLogFile -Message ' '
    }
  }
}

Function Connect_O365 {

  Param ()

  Begin {
    Write-LogInfo -LogPath $sLogFile -Message 'Attemtping connection to https://outlook.office365.com/powershell-liveid/...'
  }

  Process {

    Try {
        $Session_Connect_O365 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $UserCredential -Authentication Basic -AllowRedirection
        Import-PSSession $Session_Connect_O365   
    }

    Catch {
      Write-LogError -LogPath $sLogFile -Message $_.Exception -ExitGracefully
      Break
    }
  }

  End {
    If ($?) {
      Write-LogInfo -LogPath $sLogFile -Message 'Completed Successfully.'
      Write-LogInfo -LogPath $sLogFile -Message ' '
    }
  }
}

Function Check_UserPrincipalName {

  Param ()

  Begin {
    Write-LogInfo -LogPath $sLogFile -Message 'Attemtping connection to https://outlook.office365.com/powershell-liveid/...'
  }

  Process {

    Try {
        Write-Verbose -Message "Checking if [$($Username)] is available"

        if (Get-ADUser -Filter "Name -eq '$Username'"){

	        Write-Warning -Message "The username [$($Username)] is not available."
        }
        else {
            Write-Verbose -Message "The username [$($Username)] is available"
        }
    }

    Catch {
      Write-LogError -LogPath $sLogFile -Message $_.Exception -ExitGracefully
      Break
    }
  }

  }

  End {
    If ($?) {
      Write-LogInfo -LogPath $sLogFile -Message 'Completed Successfully.'
      Write-LogInfo -LogPath $sLogFile -Message ' '
    }
  }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------



Start-Log -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion




Stop-Log -LogPath $sLogFile