$name = 'ugetdm'
$packageSource = 'https://sourceforge.net/projects/urlget/files/uget%20%28stable%29/2.0.8/uget-2.0.8-win32%2Bgtk3.7z/download'
$localeSource = 'https://sourceforge.net/projects/urlget/files/uget%20%28stable%29/2.0.8/uget-2.0.8-win32-locale.7z/download'
$localeEmbeddedFolder = 'uget-win32-locale\share' # Unlike the packageSource zip, the files we need are one directory deep
$unzipLocation = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$checksumType = 'sha512'
$packageChecksum = '2c11286180a9eaa8a15c1525ed65f280853b4d1b92ae30ef1c60d43a374d4578736b8677da4994b8aed6f56c2ac6f972b908f3b7bda6a5e231bddbc49b343539'
$localeChecksum = '2316b8d5fc3da14d11a61f4acbdc45d47d1cd1089f57fb9cd4eef6e03def0520e371f04ebcf739280c8c77ba7a1f8629822940fc084874245733053d31584b5a'

# ugetdm binaries
Install-ChocolateyZipPackage `
  -PackageName $name `
  -Url $packageSource `
  -UnzipLocation $unzipLocation `
  -ChecksumType $checksumType `
  -Checksum $packageChecksum

# NOTE: This started as a workaround for a bug with Install-ChocolateyZipPackage with regards to the -SpecificFolder parameter not working.
# However, 7zip does not seem to support extracting directories without the parent tree as well. Since the bugfix would not give me
# the desired behavior, I download, unzip, and copy the locales manually to the installation directory myself. Note that since this is all
# installed to the package directory, custom uninstallation magic is not necessary.

# Download locale archive
Write-Debug "Downloading locale source..."
$tempOut = "${env:temp}\uget-locale-" + (Get-Date).Ticks
$tempOutZip = $tempOut + ".7z"
iwr -UseBasicParsing -Uri $localeSource -OutFile $tempOutZip -UserAgent [Microsoft.Powershell.Commands.PSUserAgent]::Chocolatey

# Unzip to tempdir
Write-Debug "Unzipping locale source to temporary directory..."
$7zip = Join-path "$helpersPath" '..\tools\7z.exe'
$7zParams = "x -aoa -bd -bb1 -o`"$tempOut`" -y `"$tempOutZip`""
iex "$7zip $7zParams"

# Copy to installation dir
Write-Debug "Copying locale files to ugetdm installation..."
iex "cp -Recurse -Force $tempOut\$localeEmbeddedFolder\* $unzipLocation"
