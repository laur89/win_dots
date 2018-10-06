@echo off
REM from: https://gist.github.com/mpicker0/a6a3f10e6b9278074f93
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set INTELLIJ=true
::set TERM=vt100
set PATH="C:\tools\cygwin\bin";%PATH%

bash --login -i

REM This works in IntelliJ 16
REM Change the shell path in IntelliJ's Tools > Terminal to:
REM C:\path\to\this\script\run_bash.bat