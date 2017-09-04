Import-Module ActiveDirectory

        New-ADUser `
            -SamAccountName jpw2 `
            -UserPrincipalName jpw@oakham.rutland.sch.uk `
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
            -AccountPassword (ConvertTo-SecureString password -AsPlainText -force) -PassThru

        Set-ADUser `
            -Identity $_.Name`
            -Enabled $True `
            -ChangePasswordAtLogon $True


		Add-ADGroupMember "Pupils" $_.Name
		
		# Grant user full control of home folder
		New-Item -ItemType Directory -Path $_.homeDirectory
        icacls $newFolderFull /inheritance:d
		$ACL = (Get-ACL -Path $_.homeDirectory)
		$FolderAccess = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"DOMAIN\$UserName","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
		$ACL.AddAccessRule($FolderAccess)
		Set-ACL -Path $_.homeDirectory $ACL