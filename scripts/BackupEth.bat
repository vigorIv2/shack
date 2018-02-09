@echo off
SET todaysdate=%date:~-4,4%%date:~-10,2%%date:~7,2%
cd "C:\Users\%USERNAME%\"

xcopy ".\AppData\Roaming\Ethereum\keystore" 
.\Desktop\BackupETH\%todaysdate%\keystore\ /S /E /Y /H 
xcopy ".\AppData\Roaming\Ethereum\rinkeby\keystore" .\Desktop\BackupETH\%todaysdate%\rinkeby\keystore\  /S /E /Y /H

rem The line below is to copy to a USB flash drive, copy paste as many as many flash drives in teh system
xcopy ".\Desktop\BackupETH\%todaysdate%" "F:\BackupETH\%todaysdate%\" /S /E /Y /H

echo "Do not forget to record the content of .\Desktop\BackupETH\%todaysdate% to DVD, then ship it to 'safe heaven'"
pause
exit 
