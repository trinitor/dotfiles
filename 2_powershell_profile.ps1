Set-ExecutionPolicy remotesigned

New-Item -path $profile -type file -force
echo ". C:\cygwin\home\user01\.dotfiles\Microsoft.PowerShell_profile.ps1" > $profile
