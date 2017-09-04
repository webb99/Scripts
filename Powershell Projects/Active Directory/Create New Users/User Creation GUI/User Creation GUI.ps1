#ERASE ALL THIS AND PUT XAML BELOW between the @" "@
$inputXML = @"
<Window x:Class="UserAccountCreation.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:UserAccountCreation"
        mc:Ignorable="d"
        Title="Account Creation Toolkit" Height="674.662" Width="393.388">
    <Grid Margin="0,0,5,0.5">
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="121*"/>
            <ColumnDefinition Width="263*"/>
        </Grid.ColumnDefinitions>
        <Image x:Name="Logo" HorizontalAlignment="Left" Height="82" Margin="10,10,0,0" VerticalAlignment="Top" Width="110" Source="Logo.jpg"/>
        <ComboBox x:Name="Domain_Dropbox" HorizontalAlignment="Left" Margin="63,59,0,0" VerticalAlignment="Top" Width="190" Grid.Column="1" Height="22" SelectedIndex="0"></ComboBox>
        <TextBlock x:Name="Domain" HorizontalAlignment="Left" Margin="10,62,0,0" TextWrapping="Wrap" Text="Domain" VerticalAlignment="Top" Height="19" Width="48" RenderTransformOrigin="-0.37,0.424" Grid.Column="1"/>
        <TabControl HorizontalAlignment="Left" Height="537" Margin="10,97,0,0" VerticalAlignment="Top" Width="366" Grid.ColumnSpan="2">
            <TabItem Header="Staff">
                <Grid Background="#FFE5E5E5" Margin="0,0,0,-0.667">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="33*"/>
                        <ColumnDefinition Width="0*"/>
                        <ColumnDefinition Width="476*"/>
                    </Grid.ColumnDefinitions>
                    <TextBlock Grid.Column="1" HorizontalAlignment="Left" Margin="0.5,10,0,0" TextWrapping="Wrap" Text="Staff User" VerticalAlignment="Top" Height="33" Width="114" FontSize="16" Grid.ColumnSpan="2"/>
                    <ComboBox x:Name="JobRole_Dropbox" HorizontalAlignment="Left" Margin="126.5,10,0,0" VerticalAlignment="Top" Width="190" Grid.Column="2" Height="22" SelectedIndex="0"></ComboBox>
                    <TextBlock x:Name="First_Name" HorizontalAlignment="Left" Margin="0.5,55,0,0" TextWrapping="Wrap" Text="First Name" VerticalAlignment="Top" Height="16" Width="77" Grid.Column="2"/>
                    <TextBox x:Name="FirstName_TextField" HorizontalAlignment="Left" Height="23" Margin="126.5,55,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="190" Grid.Column="2"/>
                    <TextBlock x:Name="Last_Name" HorizontalAlignment="Left" Margin="0.5,83,0,0" TextWrapping="Wrap" Text="Last Name" VerticalAlignment="Top" RenderTransformOrigin="0.511,1.586" Height="16" Width="77" Grid.Column="2"/>
                    <TextBox x:Name="LastName_TextField" HorizontalAlignment="Left" Height="23" Margin="126.5,83,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="190" Grid.Column="2"/>
                    <TextBlock x:Name="User_Logon" Margin="0.5,111,260,0" TextWrapping="Wrap" Text="User Logon" VerticalAlignment="Top" RenderTransformOrigin="0.511,1.586" Height="16" Grid.Column="2"/>
                    <TextBox x:Name="UserLogon_TextField" HorizontalAlignment="Left" Height="23" Margin="126.5,111,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="190" Grid.Column="2"/>
                    <TextBlock x:Name="Department" HorizontalAlignment="Left" Margin="23,139,0,0" TextWrapping="Wrap" Text="Department" VerticalAlignment="Top" Height="16" Width="64" Grid.ColumnSpan="3"/>
                    <ComboBox x:Name="Department_Dropbox" HorizontalAlignment="Left" Margin="126.5,139,0,0" VerticalAlignment="Top" Width="190" Grid.Column="2" Height="22">
                        <ComboBoxItem Content="Activities"/>
                        <ComboBoxItem Content="Admissions"/>
                        <ComboBoxItem Content="Art and Design"/>
                        <ComboBoxItem Content="Biology"/>
                        <ComboBoxItem Content="Business Studies &amp; Economics"/>
                        <ComboBoxItem Content="Chaplaincy"/>
                        <ComboBoxItem Content="Chemistry"/>
                        <ComboBoxItem Content="Citizenship, Business, Economics, Politics"/>
                        <ComboBoxItem Content="Classics"/>
                        <ComboBoxItem Content="Computer Science"/>
                        <ComboBoxItem Content="Duke of Edinburgh"/>
                        <ComboBoxItem Content="Drama"/>
                        <ComboBoxItem Content="EAL"/>
                        <ComboBoxItem Content="Economics"/>
                        <ComboBoxItem Content="English "/>
                        <ComboBoxItem Content="Geography"/>
                        <ComboBoxItem Content="Hambleton"/>
                        <ComboBoxItem Content="Haywoods"/>
                        <ComboBoxItem Content="History"/>
                        <ComboBoxItem Content="Italian"/>
                        <ComboBoxItem Content="Jerwoods"/>
                        <ComboBoxItem Content="Languages"/>
                        <ComboBoxItem Content="Learning Support"/>
                        <ComboBoxItem Content="Library"/>
                        <ComboBoxItem Content="Lower School"/>
                        <ComboBoxItem Content="Mathematics"/>
                        <ComboBoxItem Content="Music"/>
                        <ComboBoxItem Content="Peterborough House"/>
                        <ComboBoxItem Content="Physics"/>
                        <ComboBoxItem Content="Politics"/>
                        <ComboBoxItem Content="Religion and Philosophy"/>
                        <ComboBoxItem Content="Round House"/>
                        <ComboBoxItem Content="SMT"/>
                        <ComboBoxItem Content="Social Sciences"/>
                        <ComboBoxItem Content="Sports"/>
                        <ComboBoxItem Content="Stevens"/>
                    </ComboBox>
                    <TextBlock x:Name="Job_Title" HorizontalAlignment="Left" Margin="0.5,166,0,0" TextWrapping="Wrap" Text="Job Title" VerticalAlignment="Top" RenderTransformOrigin="0.33,2.039" Height="16" Width="76" Grid.Column="2"/>
                    <TextBox x:Name="JobTitle_TextField" HorizontalAlignment="Left" Height="23" Margin="126.5,166,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="190" Grid.Column="2"/>
                    <TextBlock x:Name="Office_Phone" HorizontalAlignment="Left" Margin="0.5,194,0,0" TextWrapping="Wrap" Text="Phone" VerticalAlignment="Top" Height="16" Width="77" Grid.Column="2"/>
                    <TextBox x:Name="Phone_TextField" HorizontalAlignment="Left" Height="23" Margin="126.5,194,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="190" Grid.Column="2"/>
                    <TextBlock x:Name="Password" HorizontalAlignment="Left" Margin="0.5,222,0,0" TextWrapping="Wrap" Text="Password" VerticalAlignment="Top" RenderTransformOrigin="0.425,6.04" Height="16" Width="108" Grid.Column="2"/>
                    <TextBox x:Name="Password_TextField" HorizontalAlignment="Left" Height="23" Margin="126.5,222,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="190" Grid.Column="2"/>
                    <TextBlock x:Name="Site" HorizontalAlignment="Left" Margin="0.5,292,0,0" TextWrapping="Wrap" Text="Site" VerticalAlignment="Top" RenderTransformOrigin="0.503,3.109" Height="16" Width="20" Grid.Column="2"/>
                    <ComboBox x:Name="Site_Dropbox" HorizontalAlignment="Left" Margin="126.5,292,0,0" VerticalAlignment="Top" Width="190" Grid.Column="2" Height="22"></ComboBox>
                    <Button x:Name="Submit" Content="Submit" Grid.Column="1" HorizontalAlignment="Left" Margin="226.667,452,0,0" VerticalAlignment="Top" Width="90" Height="32" RenderTransformOrigin="0.508,9.719" Grid.ColumnSpan="2"/>
                    </Grid>
            </TabItem>
            <TabItem Header="Students">
                <Grid Background="#FFE5E5E5"/>
            </TabItem>
            <TabItem Header="Multi-User" Margin="-2,-2,-2,0">
                <Grid Background="#FFE5E5E5"/>
            </TabItem>
        </TabControl>
        <TextBlock Grid.Column="1" HorizontalAlignment="Left" Margin="10,10,0,0" TextWrapping="Wrap" Text="Account Creation Toolkit" VerticalAlignment="Top" Height="35" Width="243" FontSize="22"/>
    </Grid>
</Window>
"@       
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .NET is installed."
}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
 
$xaml.SelectNodes("//*[@Name]") | ForEach-Object{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}
 
Function Get-FormVariables {
    if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
    write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
    get-variable WPF*
}
 
Get-FormVariables

#===========================================================================
# Load Modules and Services
#===========================================================================

Import-Module ActiveDirectory

$Session_OnPremExch = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://dc-email-01.oakham.rutland.sch.uk/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session_OnPremExch

Connect-MsolService
#===========================================================================
# Create Custom Objects
#===========================================================================

#Domain combobox
#----------------------------------------------------------------------------

$DomainChoice1 = [PSCustomObject]@{
    Name = "Oakham School"
    Domain = "@oakham.rutland.sch.uk"
}
$DomainChoice2 = [PSCustomObject]@{
    Name = "Home Lab"
    Domain = "@homelab.local"
}

#Job roles combobox
#----------------------------------------------------------------------------
$JobRole_Teacher = [PSCustomObject]@{
    Name = "Teacher"
    scriptPath = "staff.bat";
    HomeDrive = "H";
    HomeDirectory = "\\dc-fs\academic$\"
    profilePath = "\\dc-fs\academic$\"
    Path = "OU=Teachers,OU=Staff,OU=W7 Users,DC=oakham,DC=rutland,DC=sch,DC=uk"
}
$JobRole_Support = [PSCustomObject]@{
    Name = "Support"
    scriptPath = "staff.bat";
    HomeDrive = "H";
    HomeDirectory = "\\dc-fs\support$\"
    profilePath = "\\dc-fs\support$\"
    Path = "OU=Support,OU=Staff,OU=W7 Users,DC=oakham,DC=rutland,DC=sch,DC=uk"
}

#Address list combobox
#----------------------------------------------------------------------------
$Address1 = [PSCustomObject]@{
    name = "The Barraclough"
    OtherAttributes = @{postOfficeBox = "The Barraclough"; l = "Oakham"}
    st = "Rutland"
    postalCode = "LE15 6QG" 
}
$Address2 = [PSCustomObject]@{
    name = "building 2"
    OtherAttributes = @{postOfficeBox = "The Chapel"; l = "Oakham"}
    st = "Rutland"
    postalCode = "LE15 6QG" 
}
$Address3 = [PSCustomObject]@{
    name = "building 3"
    OtherAttributes = @{postOfficeBox = "The Chapel"; l = "Oakham"}
    st = "Rutland"
    postalCode = "LE15 6QG" 
}

#===========================================================================
# Populate Dropbox with Custom Objects
#===========================================================================

#Populate Domain Dropbox
$DomainChoice1,$DomainChoice2 | Select-Object Name -ExpandProperty Name | ForEach-object {$WPFDomain_Dropbox.AddChild($_)}

#Populate JobRole Dropbox
$JobRole_Teacher,$JobRole_Support | Select-Object Name -ExpandProperty Name | ForEach-object {$WPFJobRole_Dropbox.AddChild($_)}

#Populate Site Dropbox
$Address1,$Address2,$Address3 | Select-Object name -ExpandProperty name | ForEach-object {$WPFSite_Dropbox.AddChild($_)}

#===========================================================================
# Functions
#===========================================================================

#Collect information from form to hash
function Get-StaffFormFields { 

    $Global:UserLogon = $WPFUserLogon_TextField.Text

    
    
    $HashArguments = @{
        GivenName = $WPFFirstName_TextField.Text;
        SurName = $WPFLastName_TextField.Text;
        Name = $WPFUserLogon_TextField.Text;
        Department = $WPFDepartment_Dropbox.Text;
        Description = $WPFJobTitle_TextField.Text;
        title = $WPFJobTitle_TextField.Text;
        AccountPassword = ($WPFPassword_TextField.Text | ConvertTo-SecureString -AsPlainText -Force);
        DisplayName = $WPFFirstName_TextField.Text+" "+$WPFLastName_TextField.Text;
        email = $WPFUserLogon_TextField.Text+"@oakham.rutland.sch.uk";
        SamAccountName = $WPFUserLogon_TextField.Text; 
        UserPrincipalName= $WPFUserLogon_TextField.Text+"@oakham.rutland.sch.uk";
        #telephoneNumber = $WPFPhone_TextField.Text;
    } 

    $HashArguments

    #Add additional dynamic hash contents based on form options

    #Set hash arguments based on selection
    if($WPFDomain_Dropbox.Text -eq 'Oakham School'){
        $Domain = $DomainChoice1.Domain
    }
    if($WPFDomain_Dropbox.Text -eq 'Home Lab'){
        $Domain = $DomainChoice2.Domain
    }

    #Job Role
    if($WPFJobRole_Dropbox.Text -eq ‘Teacher’){

        $Global:HomeDirectory = $JobRole_Teacher.HomeDirectory+$Global:UserLogon

        $HashArguments.Add(‘ScriptPath’,$JobRole_Teacher.scriptPath)
        $HashArguments.Add(‘HomeDrive’,$JobRole_Teacher.HomeDrive)
        $HashArguments.Add(‘HomeDirectory’,$JobRole_Teacher.HomeDirectory+$Global:UserLogon)
        $HashArguments.Add(‘profilePath’,$JobRole_Teacher.profilePath+$Global:UserLogon+"\profile")
        $HashArguments.Add(‘Path’,$JobRole_Teacher.Path)
    }
    elseif($WPFJobRole_Dropbox.Text -eq ‘Support’){
        $HashArguments.Add(‘ScriptPath’,$JobRole_Support.scriptPath)
        $HashArguments.Add(‘HomeDrive’,$JobRole_Support.HomeDrive)
        $HashArguments.Add(‘HomeDirectory’,$JobRole_Support.HomeDirectory+$UserLogon)
        $HashArguments.Add(‘profilePath’,$JobRole_Teacher.profilePath+$UserLogon+"\profile")
        $HashArguments.Add(‘Path’,$JobRole_Support.Path)
    }

    #Sites
    if($WPFSite_Dropbox.Text -eq ‘The Barraclough’){
        $HashArguments.Add(‘OtherAttributes’,$Address1.OtherAttributes)
        $HashArguments.Add(‘state’,$Address1.st)
        $HashArguments.Add(‘postalcode’,$Address1.postalcode)
    }
    elseif($WPFSite_Dropbox.Text -eq ‘The Chapel’){
        $HashArguments.Add(‘OtherAttributes’,$Address1.postOfficeBox)
        $HashArguments.Add(‘state’,$Address1.st)
        $HashArguments.Add(‘postalcode’,$Address1.postalcode)
    }
}

function Get-AdditionalDetails {
    $HashArguments2 = @{
        Identity = $Global:UserLogon;
        Enabled = $true;
        ChangePasswordAtLogon = $true
    }
    $HashArguments2
}

#need to get homedirectory to equal the variable selected by jobrole
function CreateHomeFolder{
	New-Item -ItemType Directory -Path $Global:HomeDirectory
    icacls $Global:HomeDirectory /inheritance:d
    $ACL = (Get-ACL -Path $Global:HomeDirectory)
    
    $UserAccount = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\$Global:UserLogon","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$DesktopSupportAdmin = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Desktop Support Tech","Modify", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $DomainAdmins = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"Oakham.rutland.sch.uk\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	$SYSTEM = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
	
    $everyone = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))
    $Staff = (New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.NTAccount]"staff","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"))

    $FolderAccess = @($UserAccount, $DomainAdmins, $SYSTEM, $DesktopSupportAdmin)

    foreach ($SecurityPerm in $FolderAccess) {
	$ACL.AddAccessRule($SecurityPerm)
    $ACL.RemoveAccessRuleAll($everyone)
    $ACL.RemoveAccessRuleAll($staff)
	Set-ACL -Path $Global:HomeDirectory $ACL
    }

}

function UserMailbox {
    #$Name = $WPFUserLogon_TextField.Text;

    #targetAddress

    Enable-RemoteMailbox -Identity $Global:UserLogon -RemoteRoutingAddress "$Global:UserLogon@oakham.mail.onmicrosoft.com"
    Invoke-Command -ComputerName dc-sec { Start-ADSyncSyncCycle -PolicyType Delta }
    Start-Sleep -Seconds 30
}

function License {
    #$Name = $WPFUserLogon_TextField.Text;
    Set-MsolUser -UserPrincipalName "$Global:UserLogon@oakham.rutland.sch.uk" -UsageLocation "GB"
    Set-MsolUserLicense -UserPrincipalName "$Global:UserLogon@oakham.rutland.sch.uk" -AddLicenses "oakham:STANDARDWOFFPACK_FACULTY", "oakham:OFFICESUBSCRIPTION_FACULTY"
}

# Submit Hash data
#--------------------------------------------------------------------------
$WPFSubmit.Add_Click({
        #Resolve Form Settings
        $hash = Get-StaffFormFields
        New-ADUser @hash -PassThru
        $hash2 = Get-AdditionalDetails
        Set-ADUser @hash2 -PassThru
        CreateHomeFolder
        UserMailbox
       #License
        #$form.Close()
    })
 
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" -ForegroundColor Cyan

function Show-Form{
    $Form.ShowDialog() | out-null
}

Show-Form
