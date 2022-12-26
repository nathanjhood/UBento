# UBento
Minimal Ubuntu-based WSL distro ideal for targeting Linux-style NodeJs and CMake development environments from Windows platforms

The Ubuntu distro that's available from the MS Store is invoked via a snap called "install RELEASE" which provides the Ubuntu.exe on the Windows-side. This is a nice interoperability, but the snap requirements are quite costly in both storage and performance.

Instead, we can pull Ubuntu-Minimal (Approx. 74mb) from a Docker container, and launch that in WSL. Ubuntu-Minimal has the "unminimize" command which rehydrates the install into the full server version of Ubuntu, and from there we can build a much more streamlined Ubuntu with fewer runtime dependencies and background service requirements (compare by running 'service --status-all'...) and tailor the environment towards a full-powered development environment (with full GUI/desktop support via an encrypted Windows X-Server) with a much reduced footprint and in many cases, improved runtime performances.

This will hopefully get compiled into an interactive bash script, if time permits. Meanwhile check /etc/profile.d/ubento_helpers.sh (credit to X410 for the original scripts - see refs) and /etc/skel/.profile and .bashrc files to get the idea.

Requirements:

- Windows 11 22h2 or greater
- WSL2 (Windows Subsystem for Linux) with a working Linux kernel/distro
- X-Server for Windows such as VcXsrv or X410

Optional:

- Docker Desktop for Windows using the WSL2 backend, used for obtaining and running developer environment images
- VSCode with Remote Development Extensions, used for editing your code hosted on the WSL2 backend

Todo:

- Use the shared WSLENV variable to link the distro user to the Windows user as a soft default
- Implement as a shell script

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
    apt update && apt install apt-utils dialog
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

[COPY .PROFILE .BASHRC INTO HOME FOLDERS AND /ETC/SKEL...]

[COPY BASH.BASHRC AND PROFILE INTO /ETC...]

[OPTIONAL - COPY .PROFILE AND .BASHRC FOR ROOT]

[COPY UBENTO_HELPERS.SH INTO /ETC.PROFILE.D AND REBOOT...]

[DESKTOP SETTINGS]

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

The local .profile file contains several pointers for our desktop environment, including additional bin and man paths, as well as linking our home folders;

    export XDG_DESKTOP_DIR="$HOME/Desktop"
    export XDG_DOWNLOAD_DIR="$HOME/Downloads"
    export XDG_TEMPLATES_DIR="$HOME/Templates"
    export XDG_PUBLICSHARE_DIR="$HOME/Public"
    export XDG_DOCUMENTS_DIR="$HOME/Documents"
    export XDG_MUSIC_DIR="$HOME/Music"
    export XDG_PICTURES_DIR="$HOME/Pictures"
    export XDG_VIDEOS_DIR="$HOME/Videos"
    export XDG_CONFIG_HOME="$HOME/.config"

We're using $HOME/.config as our desktop configuration folder. We can set bookmarks for the desktop browser in .config/gtk-3.0/bookmarks as follows;

    file:///home/{username}/Desktop
    file:///home/{username}/Documents
    file:///home/{username}/Downloads
    file:///home/{username}/Music
    file:///home/{username}/Pictures
    file:///home/{username}/Videos

We can also connect our desktop browser to remote servers in .config/gtk-3.0/servers like this;

    <?xml version="1.0" encoding="UTF-8"?>
    <xbel version="1.0"
          xmlns:bookmark="http://www.freedesktop.org/standards/desktop-bookmarks"
          xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info">
      <bookmark href="ftp://ftp.gnome.org/">
          <title>GNOME FTP</title>
      </bookmark>
    </xbel>

Import your Windows fonts to /etc/fonts/local.conf by adding the below;

    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
        <dir>/mnt/c/Windows/Fonts</dir>
    </fontconfig>

Test docker interoperability (make sure the UBento option is checked in Windows Docker Desktop's settings > resources);

    docker run hello-world
    docker run -it ubuntu bash

We can sent aliases to our Windows executables in /etc/ubento_helpers.sh like this;

    alias wsl='/mnt/c/Windows/wsl.exe'

    wsl --list --verbose

Don't forget VSCode with the Remote Development extension, of course... No Linux/server-side install required;

    code .

Make sure the following two functions from the x410 cookbook are present/called in $HOME/.profile for user, but NOT for root (IMPORTANT!) - they should be at the end after the exports;

    set_runtime_dir
    set_session_bus

# [Configuring encrypted X-Server sessions]

(tbc)

# [DEVTOOLS KEYRING]

As sudo...

    export PUBKEYPATH="$HOME\.ssh\id_ed25519.pub"
    export DISTRO="$(lsb_release -s -c)"
    export ARCH="$(dpkg --print-architecture)"

    get_gith()
    {
        export GH_KEY="/usr/share/keyrings/githubcli-archive-keyring.gpg"

        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | tee $GH_KEY >/dev/null

        echo "deb [arch=$ARCH signed-by=$GH_KEY] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list

        apt update

        apt install gh

        gh auth login
    }

    Your Git SSH key is now available at $PUBKEYPATH...

    get_node()
    {
        export NODEJS_KEY="usr/share/keyrings/nodesource.gpg"

        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee $NODEJS_KEY >/dev/null

        echo "deb [arch=$(dpkg --print-architecture) signed-by=$NODEJS_KEY] https://deb.nodesource.com/node_19.x $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/nodesource.list

        echo "deb-src [arch=$(dpkg --print-architecture) signed-by=$NODEJS_KEY] https://deb.nodesource.com/node_19.x $(lsb_release -cs) main" | tee -a /etc/apt/sources.list.d/nodesource.list

        apt update

        apt install nodejs
    }

    get_yarn()
    {
        export YARN_KEY="/usr/share/keyrings/yarnkey.gpg"

        curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee $YARN_KEY >/dev/null

        echo "deb [arch=$ARCH signed-by=$YARN_KEY] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list

        apt update

        apt install yarn
    }

    get_pgadmin()
    {
        curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

        echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list

        apt update

        # Install for both desktop and web modes:
        apt install pgadmin4

        # Install for desktop mode only:
        # apt install pgadmin4-desktop

        # Install for web mode only:
        # apt install pgadmin4-web

        # Configure the webserver, if you installed pgadmin4-web:
        /usr/pgadmin4/bin/setup-web.sh
    }

    get_cmake()
    {
        # wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

        echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kitware.list

        apt update

        apt install kitware-archive-keyring cmake cmake-data cmake-doc ninja-build
    }

    get_chrome()
    {
        curl "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o "$XDG_DOWNLOAD_DIR/chrome.deb"

        apt install "$XDG_DOWNLOAD_DIR/chrome.deb"
    }

    get_supabase()
    {
        # Check repo for latest release, these outdate quickly...

        "curl https://github.com/supabase/cli/releases/download/v1.25.0/supabase_1.25.0_linux_amd64.deb" -o "$XDG_DOWNLOAD_DIR/supabase.deb"

        apt install "$XDG_DOWNLOAD_DIR/supabase_1.25.0_linux_amd64.deb"
    }

    get_nvm()
    {
        curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh" | bash

        # nvm use system... or as preferred
    }

    get_postman()
    {
        curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | bash

        postman login
    }

    get_vcpkg_tool()
    {
        . <(curl https://aka.ms/vcpkg-init.sh -L)

        . ~/.vcpkg/vcpkg-init
    }

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

Optional;

    sudo apt install ubuntu-wsl snapd
    sudo snap refresh
    sudo snap list

No snaps, but they should be in the $PATH - make sure to check /etc/profile :)

References and sources:

Microsoft WSL docs ()
Docker Desktop for Win/WSL2 docs ()
X410 cookbook ()
SO thread about X server encryption ()
Package keys; please see respective repos on GH.
