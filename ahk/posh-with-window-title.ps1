# this is a script to launch POSH terminal that will periodically force
# window title to given parameter if it has changed.
param([string]$windowTitle)

# install the ThreadJob module if not avail; from https://stackoverflow.com/a/74503434 :
if ($PSVersionTable.PSVersion.Major -lt 6 -and -not (Get-Command -ErrorAction Ignore -Type Cmdlet Start-ThreadJob)) {
  Write-Verbose "Installing module 'ThreadJob' on demand..."
  Install-Module -ErrorAction Stop -Scope CurrentUser ThreadJob
}


# hack to periodically force the terminal window title, so programs such as nvim can't highjack it (from https://stackoverflow.com/a/72487943):
# Start a thread job to periodically reset the console window title
$null = Start-ThreadJob { param( $rawUI, $title )
    while( $true ) {
        # If the window title has changed, reset it
        if( $rawUI.WindowTitle -ne $title ) {
            $rawUI.WindowTitle = $title
        }
        # A delay is important so the CPU is not hogged
        Start-Sleep -Millis 2000
    }
} -ArgumentList $host.ui.RawUI, $windowTitle
