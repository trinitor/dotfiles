#To create a profile:
#New-Item -path $profile -type file -force
#if ((Test-Path $Profile) -eq "True") {Notepad $Profile} Else {Write-Host "Still no profile file"}

### is admin?
$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$p = New-Object System.Security.Principal.WindowsPrincipal($id)
# If powershell is evaluated
if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
{
  $Host.UI.RawUI.WindowTitle = "Administrator: " + $Host.UI.RawUI.WindowTitle
  $admin_rights = 1
} else {
  $admin_rights = 0
}

### Window Title
# Get username:
  if ($admin_rights -eq 1) {
    $user = "Admin " + $env:Username;
  } else {
    $user = $env:Username
  }
$host.UI.RawUI.WindowTitle = "PS " + $user + "@" + [System.Net.Dns]::GetHostName();


### Prompt
function prompt {
  # Blank line
  Write-Host ("______________________________") -foregroundcolor Black
  # Print the current time:
  Write-Host ("<<< ") -nonewline -foregroundcolor DarkGray
  Write-Host (Get-Date -uformat "%Y-%m-%d %T") -nonewline -foregroundcolor DarkGray
  Write-Host (" >>>") -foregroundcolor DarkGray
  # Print user@host
  Write-Host $env:username -nonewline -foregroundcolor Yellow
  Write-Host ("@")  -nonewline -foregroundcolor Yellow
  Write-Host $env:computername -nonewline -foregroundcolor Yellow
  Write-Host (" ") -nonewline -foregroundcolor Cyan
  # Print the working directory:
  Write-Host ($PWD) -nonewline -foregroundcolor Cyan
  # Print the promot symbol:
  if ($admin_rights -eq 1) {
    Write-Host (" # ") -foregroundcolor Red
  } else {
    Write-Host (" $ ") -foregroundcolor Cyan
  }
  Write-Host (">") -nonewline -foregroundcolor Gray
  return " ";
}


### Functions
function sudo {
  param ($command)
  if ( !$command ) { $command = "powershell"; }
  runas /user:EU\!Thomas.Muller $command
}

function ls-recusive ([string] $glob)
{
  Get-Childitem -recurse -include $glob
}

function New-PSSecureRemoteSession
{
  param ($sshServerName, $Cred)
  $Session = New-PSSession $sshServerName -UseSSL -Credential $Cred -ConfigurationName C2Remote
  Enter-PSSession -Session $Session
}

function pskill
{
  param ($process)
  Get-Process $process | Stop-Process
}

# LS.MSH
# Colorized LS function replacement
# /\/\o\/\/ 2006
# http://mow001.blogspot.com
function ll
{
  $origFg = $host.ui.rawui.foregroundColor

  $dir = "."
  $toList = ls $dir

  foreach ($Item in $toList)
  {
    Switch ($Item.Extension)
    {
      ".exe"  {$host.ui.rawui.foregroundColor = "DarkRed"}
      ".cmd"  {$host.ui.rawui.foregroundColor = "DarkRed"}
      ".doc"  {$host.ui.rawui.foregroundColor = "Blue"}
      ".docx" {$host.ui.rawui.foregroundColor = "Blue"}
      ".xls"  {$host.ui.rawui.foregroundColor = "Cyan"}
      ".xlsx" {$host.ui.rawui.foregroundColor = "Cyan"}
      ".pdf"  {$host.ui.rawui.foregroundColor = "DarkCyan"}
      ".jpeg" {$host.ui.rawui.foregroundColor = "Yellow"}
      ".jpg"  {$host.ui.rawui.foregroundColor = "Yellow"}
      ".gif"  {$host.ui.rawui.foregroundColor = "Yellow"}
      ".png"  {$host.ui.rawui.foregroundColor = "Yellow"}
      ".avi"  {$host.ui.rawui.foregroundColor = "Gray"}
      ".mp4"  {$host.ui.rawui.foregroundColor = "Gray"}
      ".mkv"  {$host.ui.rawui.foregroundColor = "Gray"}
      ".mov"  {$host.ui.rawui.foregroundColor = "Gray"}
      ".mpg"  {$host.ui.rawui.foregroundColor = "Gray"}
      ".mpeg" {$host.ui.rawui.foregroundColor = "Gray"}
      ".iso"  {$host.ui.rawui.foregroundColor = "Magenta"}
      ".zip"  {$host.ui.rawui.foregroundColor = "Magenta"}
      ".tar"  {$host.ui.rawui.foregroundColor = "Magenta"}
      ".bz2"  {$host.ui.rawui.foregroundColor = "Magenta"}
      ".gz"   {$host.ui.rawui.foregroundColor = "Magenta"}
      ".rpm"  {$host.ui.rawui.foregroundColor = "Magenta"}
      Default {$host.ui.rawui.foregroundColor = $origFg}
    }
    if ($item.Mode.StartsWith("d")) {$host.ui.rawui.foregroundColor = "Green"}
      $item
    }
    $host.ui.rawui.foregroundColor = $origFg
}

function rdp
{
  param ($servername)
  mstsc /v:$servername
}

function bash { C:\cygwin\cygwin.bat }

function df {
  $table = New-Object system.Data.DataTable "Volumes"
  $DeviceID    = New-Object system.Data.DataColumn DeviceID,([string])
  $Description = New-Object system.Data.DataColumn Description,([string])
  $FileSystem  = New-Object system.Data.DataColumn FileSystem,([string])
  $Size        = New-Object system.Data.DataColumn Size,([string])
  $FreeSpace   = New-Object system.Data.DataColumn FreeSpace,([string])
  $table.columns.add($DeviceID)
  $table.columns.add($Description)
  $table.columns.add($FileSystem)
  $table.columns.add($Size)
  $table.columns.add($FreeSpace)

  $devices = Get-wmiObject -class "Win32_LogicalDisk" -namespace "root\CIMV2" -computername localhost

  foreach ($device in $devices)
  {
    $row = $table.NewRow()
    $row.DeviceID = $device.DeviceID
    $row.Description = $device.Description
    $row.FileSystem = $device.FileSystem
    $row.Size = ($device.Size / 1GB).ToString("f3")
    $row.FreeSpace = ($device.FreeSpace / 1GB).ToString("f3")
    $table.Rows.Add($row)
  }
  $table | format-table -AutoSize
}

### Alias
Set-Alias open Invoke-Item;
Set-Alias l ls
Set-Alias grep Select-String
Set-Alias which Get-Command
Set-Alias ifconfig ipconfig

Set-Alias connect New-PSRemoteSession
Set-Alias connect-secure New-PSSecureRemoteSession
Set-Alias ssh "C:\Data\Software\SSH\Putty\plink.exe"
Set-Alias scp "C:\Data\Software\SSH\Putty\pscp"

Set-Alias np "notepad.exe"
Set-Alias npp "C:\Data\Software\Editor\Notepad++\notepad++.exe"
Set-Alias subl "C:\Data\Software\Editor\Sublime_Text2.0.1\sublime_text.exe"

Set-Alias word "C:\Program Files (x86)\Microsoft Office\Office15\winword.exe"
Set-Alias excel "C:\Program Files (x86)\Microsoft Office\Office15\excel.exe"

Set-Alias user-info "C:\Data\Scripts\powershell\AD-user_info.ps1"

### Defaults
$env:EDITOR = "C:\Data\Software\Editor\Notepad++\notepad++.exe"
$MaximumHistoryCount = 10KB

### Locations
# 'go' command and targets
$GLOBAL:go_locations = @{}
if( $GLOBAL:go_locations -eq $null ) {
  $GLOBAL:go_locations = @{}
}
function go ([string] $location) {
  if( $go_locations.ContainsKey($location) ) {
    set-location $go_locations[$location];
  } else {
    write-output "The following locations are defined:";
    write-output $go_locations;
  }
}

$go_locations.Add("home", "$env:USERPROFILE")
$go_locations.Add("Downloads", "$env:USERPROFILE/Downloads")
$go_locations.Add("Desktop", "$env:USERPROFILE/Desktop")
$go_locations.Add("scripts", "C:\Data\Scripts")
$go_locations.Add("temp", "C:\Data\Temp")
$go_locations.Add("doc", "X:\Projects\doc")

### Window Size and color
$Shell = $Host.UI.RawUI
$size = $Shell.WindowSize
$shell.BackgroundColor = "Black"
#$host.privatedata.ErrorForegroundColor = 'green'

### default location
Set-Location C:\

Clear-Host
