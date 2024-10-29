# from https://www.red-gate.com/simple-talk/sysadmin/powershell/building-a-countdown-timer-with-powershell/
####################################################

# no other statements prior to param()!
#param([int]$Delay_Sec=3, [string]$EventLabel="This is a test")

# these 2 lines are to hide the terminal window: (from https://stackoverflow.com/a/75919843/3344729)
# note to fully hide, it still requires launching posh.exe via conhost like: (conhost bit is from https://www.reddit.com/r/PowerShell/comments/1cxeirf/how_do_you_completely_hide_the_powershell/l525neq/)
#  conhost  powershell -NoProfile -nologo -WindowStyle hidden -ExecutionPolicy Bypass -File %A_ScriptDir%\..\scripts\launch-steam-game-gui.ps1
Add-Type -name user32 -namespace win32 -memberDefinition '[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'
[win32.user32]::showWindow((get-process -id $pid).mainWindowHandle, 0)

Add-Type -AssemblyName System.Windows.Forms

$Active_game=578080
$Steam_id_to_name = @{
    578080  = 'PUBG'
}

$Delay_Sec=10  # in sec
$Alert_Threshold_Sec=5  # should be less than $Delay_Sec
#############################################


Function Update_Labels_And_Position_Elements() {
    #$Counter_Event_Label.Left = ($Counter_Form.Width/2)-($EventLabel_Size.Width/2)
    #$Counter_Event_Label.Top = ($Counter_Form.Height/2)-($EventLabel_Size.Height/2)
    $Counter_Event_Label.Left = ($Counter_Form.Width/2)-($EventLabel_Size.Width/2)
    $Counter_Event_Label.Top = $Counter_Form.Height * .3 # We want it near the bottom of the screen.
    
    #$Counter_OKButton.Left = ($Counter_Form.Width/2)-($EventLabel_Size.Width/2)
    $Counter_OKButton.Left = ($Counter_Form.Width/2) - $Counter_OKButton.Width - 5
    #$Counter_OKButton.Top = ($Counter_Form.Height/2)-($EventLabel_Size.Height/2)
    $Counter_OKButton.Top = $Counter_Form.Height - 80
    
    $Counter_CancelButton.Left = $Counter_OKButton.Left + $Counter_OKButton.Width + 10
    #$Counter_CancelButton.Top = 40
    $Counter_CancelButton.Top = $Counter_Form.Height - 80
    
    
    #$Counter_Label.Top = $Counter_Form.Height * .3 # We want it near the bottom of the screen.
    $Counter_Label.Top = ($Counter_Form.Height/2)-($EventLabel_Size.Height/2)
    
    $Counter_Label.Text = Pprint_Remaining_Time
    
    if ($Delay_Sec -gt $Alert_Threshold_Sec) {
        #$Counter_Label.Font = $normalfont  # already set in the global scope
        $Counter_LabelSize = [System.Windows.Forms.TextRenderer]::MeasureText($Counter_Label.Text, $normalfont)  # we need this so we can figure where to put the countdown labeled, centered.
    } else {
        $Counter_Label.ForeColor = "Red"
        $Counter_Label.Font = $warningfont
        $Counter_LabelSize = [System.Windows.Forms.TextRenderer]::MeasureText($Counter_Label.Text, $warningfont)
        $Counter_Label.Width = $Counter_LabelSize.Width + 10        
    }
    
    $Counter_Label.Left = ($Counter_Form.Width/2)-($Counter_LabelSize.Width/2)
    $Counter_Label.AutoSize = $true
}


Function On_Timer_Tick() {
    #$Counter_Form.Text = Get-Date -Format "HH:mm:ss"  # sets the window title
    $global:Delay_Sec -= 1
    
    if ($Delay_Sec -gt 0) {
        Update_Labels_And_Position_Elements
    } else {
        Do_Action
    }
}


Function Pprint_Remaining_Time() {
    $msg = "" + ($Delay_Sec % 60) + " sec"
    $min = [int](([string]($Delay_Sec/60)).split('.')[0])
    if ($min -gt 0) {
        $msg = "" + $min + " min " + $msg
    }
    
    return $msg
}


Function On_Form_Load() {
    #$Counter_Form.Text = "Timer started"
    $Counter_Label.Text = Pprint_Remaining_Time
    #$Counter_Label.Text = "Timer started"
    #$Counter_Label.Font = $normalfont
    $Counter_Label.AutoSize = $true
    
    Update_Labels_And_Position_Elements
    $timer.Start()
}


Function Stop_Timer_And_Close() {
    $timer.Stop()
    $counter_form.Close() 
}


Function Do_Action() {
    Stop_Timer_And_Close
    Start-Process "steam://rungameid/$Active_game"
}


# Get monitor resolution of primary monitor
$monitordetails = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize
$monitorheight = $monitordetails.Height
$monitorwidth = $monitordetails.Width


# Setup initial form
$Counter_Form = New-Object System.Windows.Forms.Form
$Counter_Form.Text = "Countdown"  # window title
$Counter_Form.Height = $monitorheight * .30
$Counter_Form.Width = $monitorwidth * .40
$Counter_Form.WindowState = "Normal"
$Counter_Form.StartPosition = "CenterScreen"  # automatically places window to the center

#$Counter_Form.Top = $monitorheight *.10
#$Counter_Form.Left = $monitorwidth *.10
#$Counter_Form.StartPosition = "manual"     # this ensures we can control where on the screen the form appears

# Setup our fonts
$normalfont = New-Object System.Drawing.Font("Verdana", 28, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$warningfont = New-Object System.Drawing.Font("Verdana", 28, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Underline))

# Setup initial label
$Counter_Label = New-Object System.Windows.Forms.Label
$Counter_Label.ForeColor = "Green"
$Counter_Label.Font = $normalfont


$EventLabel_Text = "Launching $($Steam_id_to_name[$Active_game]) in..."
$EventLabel_Size = [System.Windows.Forms.TextRenderer]::MeasureText($EventLabel_Text, $normalfont)
$Counter_Event_Label = New-Object System.Windows.Forms.Label
$Counter_Event_Label.Width = $EventLabel_Size.Width+6  # Apparently despite giving it the string, we need a little extra room.
$Counter_Event_Label.Height= $EventLabel_Size.Height
$Counter_Event_Label.Text = $EventLabel_Text
$Counter_Event_Label.Font = $normalfont

# Now add the labels we want.
$Counter_Form.Controls.Add($Counter_Label)
$Counter_Form.Controls.Add($Counter_Event_Label)

# Setup and handle the OK button
$Counter_OKButton = New-Object System.Windows.Forms.Button
$Counter_OKButton.AutoSize = $true 
$Counter_OKButton.Text = "Ok"
$Counter_OKButton.Add_Click({Do_Action})
$Counter_Form.Controls.Add($Counter_OKButton)

# Setup and handle the cancel button
$Counter_CancelButton = New-Object System.Windows.Forms.Button
$Counter_CancelButton.AutoSize = $true
$Counter_CancelButton.Text = "Cancel"
$Counter_CancelButton.Add_Click({Stop_Timer_And_Close})
$Counter_Form.Controls.Add($Counter_CancelButton)

# Setup and handle keyboard Enter/Escape
$Counter_Form.AcceptButton=$Counter_OKButton
$Counter_Form.CancelButton=$Counter_CancelButton


$Counter_Form.Add_Load({On_Form_Load})
$Counter_Form.Add_Resize({Update_Labels_And_Position_Elements})

# Create the loop timer:
$timer = New-Object System.Windows.Forms.Timer
#$timer = [Diagnostics.Stopwatch]::StartNew()
$timer.Interval = 1000
$timer.Add_Tick({On_Timer_Tick})


# Finally, we show the dialog
$topmost = New-Object 'System.Windows.Forms.Form' -Property @{TopMost=$true}  # ensure window is on the top
$Counter_Form.ShowDialog($topmost) | Out-Null  # absorbs cancel message at end
