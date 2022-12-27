# UBento
Minimal Ubuntu-based WSL distro ideal for targeting Linux-style NodeJs and CMake development environments from Windows platforms

The Ubuntu distro that's available from the MS Store is initialized via a snap called "install RELEASE", and also comes bundled with a rather hefty APT package suite called "ubuntu-wsl". The MS Store Linux distros are also generally bundled with the "WSL2 Distro Launcher", which provides for example the 'Ubuntu.exe' on the Windows-side. This is a nice interoperability, but particularly the snap requirements are quite costly in both storage and performance.

Instead, we can pull Ubuntu-Minimal (Approx. 74mb) from a Docker container, and launch that in WSL. Ubuntu-Minimal has the "unminimize" command which rehydrates the install into the full server version of Ubuntu, and from there we can build a much more streamlined Ubuntu with fewer runtime dependencies and background service requirements (compare by running 'service --status-all'...) and tailor the environment towards a full-powered development environment (with full GUI/desktop support via an encrypted Windows X-Server) with a much reduced footprint, and in many cases, improved runtime performances.

This will hopefully get compiled into an interactive bash script, if time permits. Meanwhile check /etc/profile.d/ubento_helpers.sh (credit to X410 for the original scripts - see refs) and /etc/skel/.profile and .bashrc files to get the idea.

Requirements:

- Windows 11 22h2 or greater
- WSL2 (Windows Subsystem for Linux), optionally with a working Linux kernel/distro
- Docker Desktop for Windows using the WSL2 backend, used for obtaining and running developer environment images

Optional:

- VSCode with Remote Development Extensions, used for editing your code hosted on the WSL2 backend
- X-Server for Windows such as VcXsrv or X410 for GUI/desktop support if desired

Todo:

- X-Server helper
- Use the shared WSLENV variable to link the distro user to the Windows user as a soft default
- Implement as a shell script

Notes:

- It's a good idea to use 'localhost' or at least something different to your Windows Machine ID as your WSL distro's hostname (this is set in /etc/wsl.conf). The unfortunate current default is to simply copy the Win MachineID over to WSL userland. I personally like "localclient" for my Windows machine, and "localhost" for my WSL distro - this is a nice distinction when you are presented with network addresses that point to either 'localclient' or 'localhost'. When launching Node apps, for example, you can view them in your "localclient" browser (i.e., your net browser for Windows) and differentiate the network addresses you are provided for "localhost", for example. This is also very useful when configuring the X-server, especially, when keys might be exchanged both ways.

To get started, run the below in either your Windows Powershell, or your current WSL2 distro's terminal;

# [PRE-INSTALL]

Pull Ubuntu-Minimal from Docker image into .tar (Approx. 74mb)

    docker run -t ubuntu bash
    exit

Take a note of the container ID of the Ubuntu image that was just running, then export it to some handy Windows location, using the .tar extension (WSL can then import it directly), as follows;

    docker container ls -a
    docker export "<dockerContainerID>" > C:\Users\"<username>"\ubuntu.tar

We then have a few options for how we wish to store UBento, such as using the dynamic virtual hard drive (.vhd or .vhdx) format, and backing up and/or running from external storage drives.

option 1; Convert from .tar named 'Ubuntu' to .vhdx named 'UBento', while storing a backup .vhdx of 'Ubuntu'

    wsl --import Ubuntu "D:\Ubuntu" "C:\Users\"<username>"\ubuntu.tar"
    wsl --export Ubuntu "D:\Backup\Ubuntu_22_04_1_LTS.vhdx" --vhd
    wsl --unregister Ubuntu
    wsl --import UBento "D:\UBento" "D:\Backup\Ubuntu_22_04_1_LTS.vhdx" --vhd
    
The above can also be run from another WSL distro by creating an alias;

    alias wsl='/mnt/c/Windows/wsl.exe'

Note that we imported Ubuntu as a .tar, exported it as a resizeable .vhdx, then re-imported the .vhdx under a new name.
Thus, the 'export/unregister Ubuntu' step is optional - you can keep both distro's on your WSL if you like, simply point the ```wsl --import``` argument at a destination folder and a distro-containing .tar or .vhd/x, using whatever name you like (i.e., 'UBento').

The above example stores a backup in 'D:\' drive (can be a smart card or USB memory, etc), but you may of course place the files anywhere you like.

option 2; Convert from .tar named 'Ubuntu' to .vhdx named 'UBento', without storing a backup;

    wsl --import UBento "C:\my\install\folder" "C:\my\backup\folder\ubuntu.tar"

Backing up and restarting with a clean slate;

It turns out to be handy to run the

    wsl --export <myPerfectDistro> "D:\Backup\my_perfect_distro.vhdx" --vhd

argument around this stage or whenever you feel you have a good starting point, because if/when we screw anything up and want to start our distro over, we can then simply;

    wsl --unregister <myBadDistro>

    wsl --import <myPerfectDistro> "D:\My\Runtime\Folder" "D:\Backup\my_perfect_distro.vhdx"

Note that the --vhd flag tells WSL to export as either a .vhd (static volume size) or a .vhdx (dynamic volume size), but you can also drop this flag and instead prepend the export location with ".tar", to store as a Tar file. As mentioned eariler, WSL can import a .tar distro directly (We could even simply ```wsl --import-in-place "<DistroName>" "C:\location\of\distro.tar"```), without needing to be converted to any .vhd/x extension, but this provides a handy additional layer of control over the distro size.

Check UBento is installed and launch it (as root);

    wsl -l -v
    wsl -d UBento

The above line can also be used in a Windows Terminal profile as a launch command, if you append '.exe' to the WSL invocation. Going deeper, we could make a desktop icon launcher that invokes our Windows Shell and runs the above command.... (possibly coming soon)

# [POST-INSTALL]

set permission for root folder, restore server packages, and install basic dependencies;

    chmod 755 /
    apt update && apt install apt-utils dialog
    yes | unminimize
    apt install less manpages sudo openssl ca-certificates bash-completion bash-doc libreadline8 readline-common readline-doc resolvconf gnu-standards xdg-user-dirs vim nano lsb-release git curl wget

create user named "<username>" (could use $WSLENV to pull your Win user name here) with the required uid. You will be prompted to create a secure login password;

    export userName="<username>"

    adduser --home=/home/$userName --shell=/usr/bin/bash --gecos="<Full Name>" --uid=1000 $userName
    usermod --group=adm,dialout,cdrom,floppy,tape,sudo,audio,dip,video,plugdev $userName

make '$userName@localhost' and expose default wsl settings, mount the windows drive in '/mnt', and set the required OS interoperabilities;

    echo -e "[automount]\nenabled=true\nroot=/mnt/\nmountFsTab=true\noptions='uid=1000,gid=1000,metadata,umask=000,fmask=000,dmask=000,case=off'\ncrossDistro=true\nldconfig=true\n" >> /etc/wsl.conf
    echo -e "[network]\nhostname=localhost\ngenerateHosts=true\ngenerateResolvConf=true\n" >> /etc/wsl.conf
    echo -e "[interop]\nenabled=true\nappendWindowsPath=true\n" >> /etc/wsl.conf
    echo -e "[user]\ndefault=$userName\n" >> /etc/wsl.conf
    echo -e "[boot]\nsystemd=true\n" >> /etc/wsl.conf

[COPY .PROFILE .BASHRC INTO HOME FOLDERS AND /ETC/SKEL...]

[COPY BASH.BASHRC AND PROFILE INTO /ETC...]

[COPY UBENTO_HELPERS.SH INTO /ETC.PROFILE.D...]

[OPTIONAL - COPY .PROFILE AND .BASHRC FOR ROOT...]

Make sure the following two functions from the x410 cookbook are defined in '/etc/profile.d/ubento_helpers.sh' and are present/called in $HOME/.profile for user, but NOT for root (IMPORTANT!) - they should be at the end after the exports;

    set_runtime_dir
    set_session_bus

Setup systemd/dbus and accessibility bus,  full restart to login as user;

    apt install systemd dbus at-spi2-core
    wsl -d UBento --shutdown
    wsl -d UBento
    
From now on, you can ```sudo``` from your new user login, and will have access to useful commands like ```shutdown now``` via systemd.

It is CRITICAL that the above steps are taken in the order presented: 
- launch as root
- install sudo
- add new user
- copy wsl.conf
- copy ubuntu-helpers/profile/bashrc files
- install systemd/dbus/at-spi2-core
- shutdown and reboot into new user account*

*this sequence ensures that when the user account is finally accessed, it has the UID of 1000 assigned, and calls the "set_runtime_dir" and "set_session_bus" functions from the X410 cookbook using this UID during initialization. This sequence creates a runtime directory at '/run/user/1000' during initialization where the dbus-daemon (and accessibility bus) is started from, and this runtime location is maintained/used when opening further sessions using this same distro. It is also critical that the root user does NOT call these functions during init (they should not be present at all in /root/.profile).

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

    cd $HOME
    code .
    
    # Will run an installation step for 'vscode-server-remote' on first run....


# [Configuring encrypted X-Server sessions]

(tbc)

# [DEVTOOLS KEYRING]

As sudo...

    export DISTRO="$(lsb_release -s -c)"
    export ARCH="$(dpkg --print-architecture)"
    export APT_SOURCES="/etc/apt/sources.list.d"

    get_gith()
    {
        export GH_KEY="/usr/share/keyrings/githubcli-archive-keyring.gpg"

        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | tee $GH_KEY >/dev/null

        echo "deb [arch=$ARCH signed-by=$GH_KEY] https://cli.github.com/packages stable main" | tee $APT_SOURCES/github-cli.list

        apt update

        apt install gh
    }
    
    Following the above, you can ```export PUBKEYPATH="$HOME\.ssh\id_ed25519.pub"``` and then ```gh auth login``` from your user account. Your Git SSH key is now available at $PUBKEYPATH... :)

    get_node()
    {
        export NODEJS_KEY="usr/share/keyrings/nodesource.gpg"

        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee $NODEJS_KEY >/dev/null

        echo "deb [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/node_19.x $DISTRO -cs) main" | tee $APT_SOURCES/nodesource.list

        echo "deb-src [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/node_19.x $DISTRO main" | tee -a $APT_SOURCES/nodesource.list

        apt update

        apt install nodejs
    }

    get_yarn()
    {
        export YARN_KEY="/usr/share/keyrings/yarnkey.gpg"

        curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee $YARN_KEY >/dev/null

        echo "deb [arch=$ARCH signed-by=$YARN_KEY] https://dl.yarnpkg.com/debian stable main" | tee $APT_SOURCES/yarn.list

        apt update

        apt install yarn
    }

    get_pgadmin()
    {
        export PGADMIN_KEY="/usr/share/keyrings/packages-pgadmin-org.gpg"
        
        curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor -o $PGADMIN_KEY

        echo "deb [signed-by=$PGADMIN_KEY] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$DISTRO pgadmin4 main" > $APT_SOURCES/pgadmin4.list

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
        export KITWARE_KEY="/usr/share/keyrings/kitware-archive-keyring.gpg"
        
        wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee $KITWARE_KEY >/dev/null

        echo "deb [arch=$ARCH signed-by=$KITWARE_KEY] https://apt.kitware.com/ubuntu $DISTRO main" | tee $APT_SOURCES/kitware.list

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

        curl "https://github.com/supabase/cli/releases/download/v1.25.0/supabase_1.25.0_linux_amd64.deb" -o "$XDG_DOWNLOAD_DIR/supabase.deb"

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

Optional packages;

    sudo apt install ubuntu-wsl 
    sudo apt install snapd
    sudo snap refresh
    sudo snap list

No default snaps (cool!), but all the "/snapd" folder locations should be appended to the $PATH variable - make sure to check /etc/profile and the troubleshooting tips below :)

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

Making the most of your $PATHS variable:

In "ubento_helpers.sh", we have a useful bash logic to check if a directory is present, and if so, to append it to a given variable, such as;

    if [ -d "/usr/bin" ] ; then
        PATH="/usr/bin:$PATH"
    fi

    if [ -d "/usr/local/games" ] ; then
        PATH="/usr/local/games:$PATH"
    fi

    if [ -d "$HOME/.local/bin" ] ; then
        PATH="$HOME/.local/bin:$PATH"
    fi

    export PATH

Make sure that you always append for example ":$PATH" in these cases, to retain the previously-set values on this variable. The PATH variable on particular should also contain your full Windows PATH variable, when explanded;

    echo $PATH

If you don't see your Windows paths in the terminal on calling the above, check all of your $PATH calls and the /etc/wsl.conf interoperability settings.

There is also a very large APT package suite named 'ubuntu-wsl' that we can instead break down into smaller dependency cycles, as and where required. But you can go ahead and ```apt install ubtuntu-wsl``` if you do experience any issues. Note that the package 'wsl-setup' attempts to run the Ubiquity "install-RELEASE" snap that creates the default WSL Ubuntu install for us, should you be interested (requires apt install snapd).

Shutting down:

Note that if you choose not to 'unminimize', not install systemd, or otherwise have no real shutdown strategy in your distro, you can always make an alias to ```wsl.exe -d <myDistro> --shutdown```.

References and sources:

Microsoft WSL docs ()
Docker Desktop for Win/WSL2 docs ()
X410 cookbook ()
SO thread about X server encryption ()
Package keys; please see respective repos on GH.
