ugetdm-chocolatey
===================

Chocolatey package source for [uGet Open Source Download Manager](http://ugetdm.com).

# Installing from Chocolatey
`choco install ugetdm`

# Building and Instaling the Packages from Source

First, remember to clone the source.
`git clone https://github.com/metalseargolid/ugetdm-chocolatey`

To build and install the package:
```powershell
choco pack
cinst -y ./ugetdm/2.0.8.nupkg
```
