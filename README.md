# FIVEM-AutoDownload
Automatic download for Fivem artifacts on windows

## Prerequisites

`` curl, 7zip ``
## Some fixing cuz windows is fucked up

First set the path for 7-Zip so it can be accessed via cmd then restart the terminal

`` setx path "%path%;C:\Program Files\7-Zip" ``

or use the Environment Variables editor in windows

## Running

After you've done everything you can run the ``.cmd`` or ``.ps1`` script and the server will install itself

### OR

Use the command:

```
irm https://raw.githubusercontent.com/superhoridev/FIVEM-AutoDownload/refs/heads/main/fivem-install-windows.ps1 | iex
```
