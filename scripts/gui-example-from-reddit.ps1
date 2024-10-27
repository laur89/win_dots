# from https://www.reddit.com/r/PowerShell/comments/os0hm2/always_on_top_script_powershell/h6on5xk/
#Requires -Version 2.0 

$signature = @"

    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X,int Y, int cx, int cy, uint uFlags);

    const UInt32 SWP_NOSIZE = 1;   // Window is not changing size.
    const UInt32 SWP_NOMOVE = 2;   // Window is not changing position.


    public static void toggleTopMost (IntPtr fHandle, bool setTopMost)
    {                                               
        IntPtr TOPMOST_SETTING = setTopMost ? new IntPtr(-1) : new IntPtr(-2); // HWND_TOPMOST or HWND_NOTTOPMOST

        SetWindowPos(fHandle, TOPMOST_SETTING, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
    }
"@


$winAPIHelper = Add-Type -MemberDefinition $signature -Name Win32Window -Namespace WinAPIhelper -PassThru

function Show-GUI {

    param(
        [string[]] $openApplications = @('No applications given')
    )

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    $script:shouldToggleTopMost = $true
    $script:shouldKeepRunning = $true

    $form                   = New-Object -TypeName System.Windows.Forms.Form 
    $form.Text              = "Toggle Always On Top"
    $form.Size              = New-Object -TypeName System.Drawing.Size(300,200) 
    $form.StartPosition     = "CenterScreen"

    $form.KeyPreview = $True
    $form.Add_KeyDown({ if ($_.KeyCode -eq 'Escape') { $script:shouldToggleTopMost = $false; $script:shouldKeepRunning = $false; $form.Close() }})

    $toggleButton              = New-Object -TypeName System.Windows.Forms.Button
    $toggleButton.Location     = New-Object -TypeName System.Drawing.Size(75,120)
    $toggleButton.Size         = New-Object -TypeName System.Drawing.Size(75,23)
    $toggleButton.Text         = "Toggle"
    $toggleButton.Add_Click({ $form.Close() })
    $form.Controls.Add($toggleButton)

    $QuitButton          = New-Object -TypeName System.Windows.Forms.Button
    $QuitButton.Location = New-Object -TypeName System.Drawing.Size(150,120)
    $QuitButton.Size     = New-Object -TypeName System.Drawing.Size(75,23)
    $QuitButton.Text     = "Quit"
    $QuitButton.Add_Click({ $script:shouldToggleTopMost = $false; $script:shouldKeepRunning = $false; $form.Close() })
    $form.Controls.Add($QuitButton)

    $label                 = New-Object -TypeName System.Windows.Forms.Label
    $label.Location        = New-Object -TypeName System.Drawing.Size(10,20) 
    $label.Size            = New-Object -TypeName System.Drawing.Size(280,20) 
    $label.Text            = "Select a window to keep on top:"
    $form.Controls.Add($label) 

    $listBox               = New-Object -TypeName System.Windows.Forms.ListBox 
    $listBox.Location      = New-Object -TypeName System.Drawing.Size(10,40) 
    $listBox.Size          = New-Object -TypeName System.Drawing.Size(260,20) 
    $listBox.Height        = 80

    $listBox.Items.AddRange($openApplications)

    $form.Controls.Add($listBox) 

    $form.Topmost = $True

    $form.Add_Shown({$form.Activate()})
    [void] $form.ShowDialog()

    if ($script:shouldToggleTopMost) {
        $listBox.SelectedItem
    }
    $form.Close()

}

[array]$openApplications = Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object Id, Name, MainWindowHandle, MainWindowTitle, @{Label='SetTopModeNextTime'; Expression={$true}}

do {
    $chosenApplicationName = Show-GUI $openApplications.MainWindowTitle

    if ($null -ne $chosenApplicationName)
    {
        $app = $openApplications | Where-Object { $_.MainWindowTitle -eq $chosenApplicationName }
        $winAPIHelper::toggleTopMost($app.MainWindowHandle, $app.SetTopModeNextTime)

        $app.SetTopModeNextTime = $false
    }

} while ($script:shouldKeepRunning)