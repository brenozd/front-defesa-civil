# App-defesa-civil fronted

## ADB com WSL2

1) No windows baixe o [adb](https://dl.google.com/android/repository/platform-tools-latest-windows.zip) e extraia ele
2) Navegue até o diretório em que você extraiu o adb e o execute com o comando

        .\adb.exe -a -P 5038 nodaemon server
3) Faça o port-forwaring da porta 5038 de seu Windows para a 5037 de seu PC (requer privilégios de administrador)

        netsh interface portproxy set v4tov4 listenport=5038 listenaddress=0.0.0.0 connectport=5037 connectaddress=$(wsl hostname -I) 

4) Em seu WSL2 exporte a variável *ADB_SERVER_SOCKET* setando ela para o seu IP do Windows junto com a porta 5038

        export ADB_SERVER_SOCKET=tcp:$(ipconfig.exe | grep 'vEthernet (WSL)' -A4 | cut -d":" -f 2 | tail -n1 | sed -e 's/\s*//g'):5038
        adb devices
