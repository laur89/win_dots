# adding startup scripts executed as admin (from [here](https://superuser.com/a/1005216/716639)):

## method 1
- open 'Task Scheduler'
- click 'Create Task'
- in 'General' tab:
  - select name, e.g. 'run-sync-time'
  - tick 'Run only when user is logged on' or 'Run whether user is logged on or not' (mainly using latter)
  - tick 'Run with highest privileges'
- in 'Triggers' tab, add New and  Begin the task->At startup
  - or alternatively 'At logon' & Specific user: select your user
- in 'Actions' tab, choose 'Start a program' from dropdown add new and point script path to target
- ~~in 'Conditions' tab, at the botton under 'Network' section,
  tick 'Start only if...', and select 'Network' from dropdown~~
  - !! nope, looks like it's [broken](https://superuser.com/a/1146860/716639). if you `Enable All Tasks History` 
    and reproduce, then in task's History tab I got `Task Category: Launch condition not met, network unavailable`.
	Instead of this condition, just add a delay under the trigger: advanced settings -> delay for X seconds.
    Or add network-waiting loop in the script itself.

- note root_startup/ dir also contains some exported task scheduler jobs (.xml) as reference

## method 2 (doesn't work)

- create link/shortcut to startup folder (ctrl+r -> `shell:startup`)
- right click on shortcut -> properties -> shortcut tab -> advanced -> tick `run as administrator`
- as noted, this method doesn't work. haven't tested, but it's possible to get it to work if
  our program is launched by a vbscript wrapper, see [this superuser answer](https://superuser.com/a/1039156)
