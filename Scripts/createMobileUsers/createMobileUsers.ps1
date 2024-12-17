# Defines the parameter for the location of the csv
param (
    [string]$csvPath
)

# Import Active Directory's module
Import-Module ActiveDirectory

#Defines the variables (change them according to needs)
$csvPath = "C:\newusers.csv"
$profileBasePath = "\\SERVER\ProfilesM"
$users = Import-Csv -Path $csvPath
$domain = "madrid.com"
$userADPath = "CN=RRHH,CN=Zara,CN=Inditex,CN=Users,DC=madrid,DC=com"
$HomePath = "\\SERVER\SharedFolders\Inditex"

# Iterate over each row of the csv
foreach ($user in $users) {
    # Variables for the new user
    $name = $user.Name
    $surname = $user.Surname
    $displayName = "$($user.Name) $($user.Surname)"
    $userPrincipalName = "$($user.SamName)@$($domain)"
    $samname = $user.SamName
    $password = $user.Password
    $profilePath = "$profileBasePath\$($user.SamName)"

    # Create the user on the AD
    New-ADUser -SamAccountName $samname `
               -Name $name `
               -GivenName $user.Name `
               -Surname $surname `
               -UserPrincipalName $userPrincipalName `
               -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) `
               -Enabled $true `
               -PasswordNeverExpires $true `
               -Path $userADPath `
               -ProfilePath $profilePath `
               -HomeDrive "I:" `
               -HomeDirectory $HomePath

    # Message that everything has gone well
    Write-Host "User $displayName created" -ForegroundColor Green
}