# UBento
Minimal Ubuntu-based WSL distro ideal for targeting Linux-style NodeJs and CMake development environments from Windows platforms

Requirements:

- Windows 11 22h2 or greater
- WSL2 (Windows Subsystem for Linux) with a working Linux kernel/distro
- X-Server for Windows such as VcXsrv or X410

Optional:

- Docker Desktop for Windows using the WSL2 backend, used for obtaining and running developer environment images
- VSCode with Remote Development Extensions, used for editing your code hosted on the WSL2 backend

Run the below in your current WSL2 distro's terminal

# [PRE-INSTALL]

Pull Ubuntu-Minimal from Docker image into .tar (Approx. 74mb)

    docker run -t ubuntu bash
    dockerContainerID=$(docker container ls -a | grep -i ubuntu | awk '{print $1}')
    docker export $dockerContainerID > /mnt/c/Users/{username}/ubuntu.tar

option 1; Convert from .tar named 'Ubuntu' to .vhdx named 'UBento', while storing a backup .vhdx of 'Ubuntu'

    alias wsl='/mnt/c/Windows/wsl.exe'

    wsl --import Ubuntu "D:\Ubuntu" "C:\Users\{username}\ubuntu.tar"
    wsl --export Ubuntu "D:\Backup\Ubuntu_22_04_1_LTS.vhdx" --vhd
    wsl --unregister Ubuntu
    wsl --import UBento "D:\UBento" "D:\Backup\Ubuntu_22_04_1_LTS.vhdx" --vhd

(Note that we imported Ubuntu as a .tar, exported it as a resizeable .vhdx, then re-imported the .vhdx under a new name.
Thus, the 'unregister Ubuntu' step is optional - you can keep both distro's on your WSL if you like.)
The above example stores a backup in 'D:\' drive (can be a smart card or USB memory, etc), but you may place the files anywhere you like.

option 2; Convert from .tar named 'Ubuntu' to .vhdx named 'UBento', without storing a backup;

    wsl --import UBento "C:\my\install\folder" "C:\my\backup\folder\ubuntu.tar"

Check UBento is installed and launch it (as root);

    wsl -l -v
    wsl -d UBento

# [POST-INSTALL]

set permission for root folder, restore server packages, and install wsl dependencies;

    chmod 755 / && yes | unminimize
    apt update && apt install ubuntu-wsl
    apt install less manpages sudo openssl ca-certificates bash-completion bash-doc libreadline8 readline-common readline-doc resolvconf gnu-standards xdg-user-dirs vim nano lsb-release git curl wget

create user named 'dev' with the required uid (you will be prompted to create a secure login password);

    adduser --home=/home/dev --shell=/usr/bin/bash --gecos="WSL Developer" --uid=1000 dev
    usermod --group=adm,dialout,cdrom,floppy,tape,sudo,audio,dip,video,plugdev dev

make 'dev@localhost' and expose default wsl settings, mount the windows drive in '/mnt', and set the required OS interoperabilities;

    echo -e "[automount]\nenabled=true\nroot=/mnt/\nmountFsTab=true\noptions='uid=1000,gid=1000,metadata,umask=000,fmask=000,dmask=000,case=off'\ncrossDistro=true\nldconfig=true\n" >> /etc/wsl.conf
    echo -e "[network]\nhostname=localhost\ngenerateHosts=true\ngenerateResolvConf=true\n" >> /etc/wsl.conf
    echo -e "[interop]\nenabled=true\nappendWindowsPath=true\n" >> /etc/wsl.conf
    echo -e "[user]\ndefault=dev\n" >> /etc/wsl.conf
    echo -e "[boot]\nsystemd=true\n" >> /etc/wsl.conf

full restart to login as dev;

    shutdown now
    wsl -d UBento
    sudo apt install systemd dbus at-spi2-core
    
option 1; symlink your Windows and UBento user folders

    ln -s /mnt/c/Users/{username}/Desktop /home/dev/Desktop
    ln -s /mnt/c/Users/{username}/Documents /home/dev/Documents
    ln -s /mnt/c/Users/{username}/Downloads /home/dev/Downloads
    ln -s /mnt/c/Users/{username}/Music /home/dev/Music
    ln -s /mnt/c/Users/{username}/Pictures /home/dev/Pictures
    ln -s /mnt/c/Users/{username}/Public /home/dev/Public
    ln -s /mnt/c/Users/{username}/Template /home/dev/Template
    ln -s /mnt/c/Users/{username}/Videos /home/dev/Videos
    ln -s /mnt/c/Users/Public /home/dev/Public
    
    ln -s /mnt/c/Users/Administrator/Desktop /root/Desktop
    ...
    ln -s /mnt/c/Users/Administrator/Videos /root/Videos
    
option 2; create new UBento user folders

    mkdir $HOME/Desktop $HOME/Documents $HOME/Downloads $HOME/Music $HOME/Pictures $HOME/Templates $HOME/Videos
    
Test docker interoperability (make sure the UBento option is checked in Windows Docker Desktop's settings > resources);

    docker run hello-world
    docker run -it ubuntu bash

# [Configuring encrypted X-Server sessions]

(tbc)

# [TROUBLESHOOTING]

Enabling Hyper-V on Windows.

Get the required packages:

    pushd "%~dp0"

    dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hv.txt

    for /f %%i in ('findstr /i . hv.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"

    Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL

    pause

Enable the Windows features:

    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V /all /limitaccess /all /norestart

    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    
Restart your Windows machine once the above is complete. 
