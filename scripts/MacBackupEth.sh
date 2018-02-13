#!/bin/bash
todaysdate=`date +%Y%m%d`
mkdir -p ~/Desktop/BackupETH/$todaysdate/keystore
mkdir -p ~/Desktop/BackupETH/$todaysdate/rinkeby/keystore
cp -r ~/Library/Ethereum/rinkeby/keystore ~/Desktop/BackupETH/$todaysdate/rinkeby/
cp -r ~/Library/Ethereum/keystore ~/Desktop/BackupETH/$todaysdate/
echo "Do not forget to record the content of ~/Desktop/BackupETH/$todaysdate to DVD, then ship it to 'safe heaven'"
pause
exit
