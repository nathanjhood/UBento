# UBento
Minimal Ubuntu-based WSL distro ideal for targeting Linux-style NodeJs and CMake development environments from Windows platforms.

## About

The Ubuntu distro that is available from the MS Store is initialized via a snap called "install RELEASE", and also comes bundled with a rather hefty APT package suite called ```ubuntu-wsl```. The MS Store Linux distros are also generally bundled with the "WSL2 Distro Launcher", which provides for example the 'Ubuntu.exe' on the Windows-side. This is a nice interoperability, but particularly the snap requirements are quite costly in both storage and performance. There is also a large stash of Bash completion helpers and scripts, covering many packages and libraries that are not actually to be found on the base install and which are still updated regularly (e.g., CMake), and the standard APT keyring which holds many outdated packages (e.g., NodeJs v.12...?) and does not provide other common developer packages (e.g., Yarn) by default. 

Instead, we can pull Ubuntu-Minimal (Approx. 74mb) from a Docker container, and launch that in WSL. Ubuntu-Minimal has the "unminimize" command which rehydrates the install into the full server version of Ubuntu, and from there we can build a much more streamlined Ubuntu with fewer runtime dependencies and background service requirements (compare by running ```service --status-all```...) and tailor the environment towards a full-powered development environment (with full GUI/desktop support via an encrypted Windows X-Server) with a much reduced footprint, a fully up-to-date package registry, and in many cases, improved runtime performances.

This will hopefully get compiled into an interactive bash script, if time permits. Meanwhile, you check the files provided here in the repo to get the idea - copying these simple bash scripts into the Ubuntu-Minimal distro and installing/running a few standard packages is all that is required to achieve the above goals.

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

- It's a good idea to use 'localhost' or at least something different to your Windows Machine ID as your WSL distro's hostname (this is set in ```/etc/wsl.conf```). The unfortunate current default is to simply copy the Win MachineID over to WSL userland. I personally like "localclient" for my Windows machine, and "localhost" for my WSL distro - this is a nice distinction when you are presented with network addresses that point to either 'localclient' or 'localhost'. When launching Node apps, for example, you can view them in your "localclient"'s browser (i.e., your net browser for Windows) and differentiate the network addresses your code backend provides from "localhost", for example. This is also very useful when configuring the X-server, especially, where keys might be exchanged both ways.

To get started, run the below in either your Windows Powershell, or your current WSL2 distro's terminal;

## [PRE-INSTALL]

Pull Ubuntu-Minimal from Docker image into .tar (Approx. 74mb)

    docker run -t ubuntu bash
    exit

Take a note of the container ID of the Ubuntu image that was just running, then export it to some handy Windows location, using the .tar extension (WSL can then import it directly), as follows;

    docker container ls -a
    docker export "<UbuntuContainerID>" > "C:\Users\<username>\ubuntu_minimal.tar"

We then have a few options for how we wish to store UBento, such as using the dynamic virtual hard drive (.vhd or .vhdx) format, and backing up and/or running from external storage drives.

    wsl --import Ubuntu "C:\My\Install\Folder" "C:\Users\<username>\ubuntu_minimal.tar"
    wsl --export Ubuntu "D:\My\Backup\Folder\ubuntu_minimal.tar"
    wsl --unregister Ubuntu
    wsl --import UBento "C:\My\Install\Folder" "D:\My\Backup\Folder\ubuntu.tar"
    
The above example stores a backup in 'D:\' drive (can be a smart card or USB memory, etc), but you may of course place the files anywhere you like (see [TIPS] for more!).

Backing up and restarting with a clean slate;

It turns out to be handy to run the following argument around this stage or whenever you feel you have a good starting point, 

    wsl --export <myPerfectDistro> "D:\My\Backup\Folder\my_perfect_distro.vhdx" --vhd

This is because if/when we screw anything up and want to start our distro over, we can then simply;

    wsl --unregister <myBadDistro>

    wsl --import <myPerfectDistro> "D:\My\Install\Folder" "D:\My\Backup\Folder\my_perfect_distro.vhdx"

Please see the [TIPS] section for much more advice :)

Check UBento is installed and launch it (as root);

    wsl -l -v
    wsl -d UBento

The above line can also be used in a Windows Terminal profile as a launch command, if you append '.exe' to the WSL invocation. Going deeper, we could make a desktop icon launcher that invokes our Windows Shell and runs the above command.... (possibly coming soon)

## [POST-INSTALL]

The below steps are to be run from within your new Ubuntu-based bash terminal in WSL.

- set permission for root folder, restore server packages, and install basic dependencies;

      chmod 755 /
      apt update && apt install apt-utils dialog
      yes | unminimize
      apt install less manpages sudo openssl ca-certificates bash-completion bash-doc libreadline8 readline-common readline-doc resolvconf gnu-standards xdg-user-dirs vim nano lsb-release git curl wget
    
- Create user named "username" (could use ```$WSLENV``` to pull your Win user name here - stay tuned) with the required UID of '1000'. You will be prompted to create a secure login password;

      export userName="<username>"

      adduser --home=/home/$userName --shell=/usr/bin/bash --gecos="<Full Name>" --uid=1000 $userName
      usermod --group=adm,dialout,cdrom,floppy,tape,sudo,audio,dip,video,plugdev $userName

- Make ```/etc/wsl.conf``` to export our 'userName@localhost' and expose default wsl settings, mount the windows drive in ```/mnt```, and set the required OS interoperabilities*;

      echo -e "[automount]\nenabled=true\nroot=/mnt/\nmountFsTab=true\noptions='uid=1000,gid=1000,metadata,umask=000,fmask=000,dmask=000,case=off'\ncrossDistro=true\nldconfig=true\n" >> /etc/wsl.conf
      echo -e "[network]\nhostname=localhost\ngenerateHosts=true\ngenerateResolvConf=true\n" >> /etc/wsl.conf
      echo -e "[interop]\nenabled=true\nappendWindowsPath=true\n" >> /etc/wsl.conf
      echo -e "[user]\ndefault=$userName\n" >> /etc/wsl.conf
      echo -e "[boot]\nsystemd=true\n" >> /etc/wsl.conf
    
(A much clearer method of the last step is to copy the fully-annoted '/etc/wsl.conf' file from this repo to your distro, with the ```[user] default=``` section containing your username to ensure we boot into this profile later on...)

## [COPY .PROFILE .BASHRC /ETC/SKEL...]

## [COPY BASH.BASHRC AND PROFILE INTO /ETC...]

## [COPY UBENTO_HELPERS.SH INTO /ETC.PROFILE.D...]

## [OPTIONAL - COPY .PROFILE AND .BASHRC FOR ROOT...]

Make sure the following two functions from the x410 cookbook are defined in ```/etc/profile.d/ubento_helpers.sh``` and are present/called in ```$HOME/.profile``` for user, but NOT for root (IMPORTANT!) - they should be at the end after the exports;

    set_runtime_dir
    set_session_bus

Setup systemd/dbus and accessibility bus, full restart to login as user;

    apt install systemd dbus at-spi2-core
    wsl -d UBento --shutdown
    wsl -d UBento
    
From now on, you can ```sudo``` from your new user login, and will have access to useful commands like ```shutdown now``` via systemd.

It is CRITICAL that these steps (as a minimum) are taken in the order presented above: 
- launch as root
- install apt-utils, dialog, and sudo
- add new user
- copy wsl.conf
- copy ubuntu-helpers/profile/bashrc files
- install systemd/dbus/at-spi2-core
- shutdown and reboot into new user account*

*this sequence ensures that when the user account is finally accessed, it has the UID of 1000 assigned, and calls the ```set_runtime_dir``` and ```set_session_bus``` functions from the X410 cookbook using this UID during initialization. This sequence creates a runtime directory at ```/run/user/1000``` during initialization where the dbus-daemon (and accessibility bus) is started from, and this runtime location is maintained/used when opening further sessions using this same distro. It is also critical that the root user does NOT call these functions during init (they should not be present at all in ```/root/.profile```).

At this point, the distro is well-configured to continue as you please. But, the idea with UBento is take some minimal steps to greatly enhance the experience where possible. We can choose to tailor our UBento into either/both a fully-configured desktop environment, and/or a fully-configured development environment, by following the steps below.

## [DESKTOP SETTINGS]

The user-local ```$HOME/.profile``` file will contain several pointers for our desktop environment, including additional bin and man paths, as well as linkage to our home folders - we don't need to set these ourselves as they will have been pulled in from ```/etc/skel``` when we created our user (see previous steps!), but these are useful to be aware of when setting up our desktop;

    export XDG_DESKTOP_DIR="$HOME/Desktop"
    export XDG_DOWNLOAD_DIR="$HOME/Downloads"
    export XDG_TEMPLATES_DIR="$HOME/Templates"
    export XDG_PUBLICSHARE_DIR="$HOME/Public"
    export XDG_DOCUMENTS_DIR="$HOME/Documents"
    export XDG_MUSIC_DIR="$HOME/Music"
    export XDG_PICTURES_DIR="$HOME/Pictures"
    export XDG_VIDEOS_DIR="$HOME/Videos"
    export XDG_CONFIG_HOME="$HOME/.config"
    
Now we should start making ourselves at home in the home folder. One excellent touch is to leverage Linux symbolic links to share your user folders between Windows and Linux environments (option 1), or we can create ourselves an alternative userspace by not going outside the distro (option 2).

By providing symbolic links to our Windows user folders, we can get some huge benefits such as a shared "Downloads" folder and a fully "Public"-ly shared folder. Thus, you can download a file in your Windows internet browser, and instantly open it from your WSL user's downloads folder, for example. However, there is some risk in mixing certain file types between Windows and WSL - there are several articles on the web on the subject (to be linked) which you should probably read before proceeding with either (or a mix) of the following;

- option 1; symlink your Windows and UBento user folders with these commands (change the respective usernames if yours don't match);

      # Logged in as user, NOT root(!);

      ln -s /mnt/c/Users/{username}/Desktop /home/{username}/Desktop && \
      ln -s /mnt/c/Users/{username}/Documents /home/{username}/Documents && \
      ln -s /mnt/c/Users/{username}/Downloads /home/{username}/Downloads && \
      ln -s /mnt/c/Users/{username}/Music /home/{username}/Music && \
      ln -s /mnt/c/Users/{username}/Pictures /home/{username}/Pictures && \
      ln -s /mnt/c/Users/{username}/Templates /home/{username}/Templates && \
      ln -s /mnt/c/Users/{username}/Videos /home/{username}/Videos

      # optional - logged in as root;

      ln -s /mnt/c/Users/Administrator/Desktop /root/Desktop
      ...
      ln -s /mnt/c/Users/Administrator/Videos /root/Videos
    
      # optional - 'public' shared folder...
    
      ln -s /mnt/c/Users/Public /home/{username}/Public
      ln -s /mnt/c/Users/Public /root/Public
      
  let's expand our $XDG_DOWNLOAD_DIR variable out...
      
      XDG_DOWNLOAD_DIR = "$HOME/Downloads" = "/home/{username}/Downloads = /mnt/c/{username}/Downloads"
      
  The exact same directory (and it's contents) on the Windows side...
      
      "$HOME\Downloads = C:\Users\{username}\Downloads = \\wsl.localhost\UBento\home\{username}\Downloads"
      
  All of the above are one and the same...!


- option 2; create new UBento user folders with these commands;

      mkdir \
      $HOME/Desktop \
      $HOME/Documents \
      $HOME/Downloads \
      $HOME/Music \
      $HOME/Pictures \
      $HOME/Templates \
      $HOME/Videos \


We're using ```$HOME/.config``` as our desktop configuration folder (you may have to ```mkdir $HOME/.config``` if it's not already present). We can set bookmark tabs for our chosen Linux desktop browser as follows;

    nano $HOME/.config/gtk-3.0/bookmarks
    
then
    
    file:///home/{username}/Desktop
    file:///home/{username}/Documents
    file:///home/{username}/Downloads
    file:///home/{username}/Music
    file:///home/{username}/Pictures
    file:///home/{username}/Videos


- We can also connect our Linux desktop browser to remote servers like this;

      nano $HOME/.config/gtk-3.0/servers
    
  then
    
      <?xml version="1.0" encoding="UTF-8"?>
      <xbel version="1.0"
            xmlns:bookmark="http://www.freedesktop.org/standards/desktop-bookmarks"
            xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info">
        <bookmark href="ftp://ftp.gnome.org/">
            <title>GNOME FTP</title>
        </bookmark>
      </xbel>


- Import your Windows fonts by adding the below to ```/etc/fonts```;

      sudo nano /etc/local.conf

      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
          <dir>/mnt/c/Windows/Fonts</dir>
      </fontconfig>


## [DEVTOOLS KEYRING]

First, do ```sudo -s```, then;

    export DISTRO="$(lsb_release -s -c)"
    export ARCH="$(dpkg --print-architecture)"
    export APT_SOURCES="/etc/apt/sources.list.d"

    get_gith()
    {
        export GH_KEY="/usr/share/keyrings/githubcli-archive-keyring.gpg"

        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | tee $GH_KEY >/dev/null

        echo "deb [arch=$ARCH signed-by=$GH_KEY] https://cli.github.com/packages stable main" | tee $APT_SOURCES/github-cli.list

        apt update
    }
    
    apt install gh
    
Following the above, you can ```exit``` back to your user account, then 
    
    export PUBKEYPATH="$HOME\.ssh\id_ed25519.pub"
    
    gh auth login
    
    # Choose .ssh option...
    
Your Git SSH key is now available at ```$PUBKEYPATH```, and you can use the GitHub CLI commands and credential manager... :)


Here are some more common tools for development - again, do ```sudo -s``` first;

- Node (latest)
    
      get_node()
      {
          export NODEJS_KEY="usr/share/keyrings/nodesource.gpg"

          curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee $NODEJS_KEY >/dev/null

          echo "deb [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/node_19.x $DISTRO main" | tee $APT_SOURCES/nodesource.list

          echo "deb-src [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/node_19.x $DISTRO main" | tee -a $APT_SOURCES/nodesource.list

          apt update
      }
    
      apt install nodejs

      npm --global install npm@latest


- Yarn (latest)
    
      get_yarn()
      {
          export YARN_KEY="/usr/share/keyrings/yarnkey.gpg"

          curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee $YARN_KEY >/dev/null

          echo "deb [arch=$ARCH signed-by=$YARN_KEY] https://dl.yarnpkg.com/debian stable main" | tee $APT_SOURCES/yarn.list

          apt update
      }
    
      apt install yarn

      yarn global add npm@latest


- PGAdmin (for PostgreSQL)
    
      get_pgadmin()
      {
          export PGADMIN_KEY="/usr/share/keyrings/packages-pgadmin-org.gpg"
        
          curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor -o $PGADMIN_KEY

          echo "deb [signed-by=$PGADMIN_KEY] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$DISTRO pgadmin4 main" > $APT_SOURCES/pgadmin4.list

          apt update
      }
    
      # Install for both desktop and web modes:
      apt install pgadmin4

      # Install for desktop mode only:
      # apt install pgadmin4-desktop

      # Install for web mode only:
      # apt install pgadmin4-web

      # Configure the webserver, if you installed pgadmin4-web:
      /usr/pgadmin4/bin/setup-web.sh


- CMake (Make sure you have Make or other build tools, and check out Visual Studio Remote with WSL!)
    
      get_cmake()
      {
          export KITWARE_KEY="/usr/share/keyrings/kitware-archive-keyring.gpg"
        
          wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee $KITWARE_KEY >/dev/null

          echo "deb [arch=$ARCH signed-by=$KITWARE_KEY] https://apt.kitware.com/ubuntu $DISTRO main" | tee $APT_SOURCES/kitware.list

          apt update
      }
    
      apt install kitware-archive-keyring cmake cmake-data cmake-doc ninja-build


- Google Chrome (latest stable)
    
      get_chrome()
      {
          curl "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o "$XDG_DOWNLOAD_DIR/chrome.deb"

          apt install "$XDG_DOWNLOAD_DIR/chrome.deb"
      }


- Supabase (check repo for latest release version number, these outdate quickly...)
    
      get_supabase()
      {
          curl "https://github.com/supabase/cli/releases/download/v1.25.0/supabase_1.25.0_linux_amd64.deb" -o "$XDG_DOWNLOAD_DIR/supabase.deb"

          apt install "$XDG_DOWNLOAD_DIR/supabase_1.25.0_linux_amd64.deb"
      }


- Node Version Manager (note that it will install into ```$XDG_CONFIG_DIR```, so ```$HOME/.config/nvm```) 
    
      get_nvm()
      {
          curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh" | bash

          # nvm use system... or as preferred
      }

- Postman (will save your login key to your home folsder)
    
      get_postman()
      {
          curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | bash

          postman login
      }

- vcpkg-tool (still working on this, note that you can get vcpkg itself quite easily too)
    
      get_vcpkg_tool()
      {
          . <(curl https://aka.ms/vcpkg-init.sh -L)

          . ~/.vcpkg/vcpkg-init
      }

## [INTEROPERABILITY]

Test docker interoperability; (IMPORTANT - do not run this step until AFTER creating your user with UID 1000, otherwise Docker tries to steal this UID!);

    # make sure the 'UBento' option is checked in Windows Docker Desktop settings > resources for this to work
    
    docker run hello-world
    docker run -it ubuntu bash

We can set Linux-side aliases to our Windows executables in ```/etc/ubento_helpers.sh``` like this;

    alias wsl='/mnt/c/Windows/wsl.exe'

    wsl --list --verbose
    # Will list all of WSL's installed distros and statuses
    
    alias notepad='/mnt/c/Windows/notepad.exe'

    notepad .
    # Will launch Notepad - careful with those line endings!
    
Don't forget to test out VSCode with the Remote Development extension, of course... Just make sure that you DON'T have VSCode installed on the Linux side;

    cd $HOME
    code .
    
    # Will run an installation step for 'vscode-server-remote' on first run....
    # Also check the 'extensions' tab for many WSL-based versions of your favourite extensions :)

## [Configuring encrypted X-Server sessions]

(tbc)

## [TROUBLESHOOTING]

## Enabling Hyper-V, Virtual Machine Platform, and WSL on Windows.

- Get the required packages (in PowerShell):

      pushd "%~dp0"

      dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hv.txt

      for /f %%i in ('findstr /i . hv.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"

      Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL

      pause

Restart your Windows machine once the above is complete.
    
- Enable the Windows features (in PowerShell):

      dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

      dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V /all /limitaccess /all /norestart

      dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

Restart your Windows machine once the above is complete.

## Still having package/service dependency issues?
    
The MS Store Ubuntu distro ships with a very large APT package suite named ```ubuntu-wsl``` that we can instead break down into smaller dependency cycles, as and where (or even if) required. But you can go ahead and ```apt install ubtuntu-wsl``` if you do experience any issues. 
    
    sudo apt install ubuntu-wsl 
  
Note that the package ```wsl-setup``` attempts to run the Ubiquity "install-RELEASE" snap that creates the default WSL Ubuntu install for us, should you be interested (requires apt install snapd).

    sudo apt install snapd
    sudo snap refresh
    sudo snap list

No default snaps (cool!), but all the ```/snapd/bin``` folder locations should be appended to the $PATH variable - make sure to check ```/etc/profile``` and the troubleshooting tips below :)

To get back to the MS Store version from here, you can

    sudo snap install ubuntu-desktop-installer --classic
    sudo wsl-setup

## - [TIPS]

## Making the most of your $PATHS variable:

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

Make sure that you always append (for example) ```":$PATH"``` in these cases, in order to retain the previously-set values on this variable. The ```$PATH``` variable in particular *should* also contain your full Windows PATH variable, when expanded;

    echo $PATH
    # This list should contain all your Windows PATH entries as well as your distro's...

If you don't see your Windows env paths in the terminal on calling the above, check all of your ```$PATH``` calls in ```/etc/profile```, ```$HOME/.profile```, and the ```/etc/wsl.conf``` interoperability settings.

## Storage

As seen in the [PRE-INSTALL] step earlier, WSL handily provides lots of ways to manage the storage of our virtual distros, including packing them as .tar files and importing them as dynamically-sized mount drives. We can fully leverage this in the spirit of a lightweight, portable development environment that can be easily backed up to external storage, re-initialized from a clean slate, duplicated, and converted between various storage and virtual hard drive formats.
    
Let's look at a few things we can do.
    
- option 1; Convert from ```docker export``` .tar-based distro named 'Ubuntu' to .vhdx-based one named 'UBento', while storing a backup .vhdx of 'Ubuntu' along the way;

      wsl --import Ubuntu "D:\Ubuntu" "C:\Users\<username>\ubuntu_minimal.tar"
      wsl --export Ubuntu "D:\Backup\Ubuntu_22_04_1_LTS.vhdx" --vhd
      wsl --unregister Ubuntu
      wsl --import UBento "D:\UBento" "D:\Backup\Ubuntu_22_04_1_LTS.vhdx" --vhd
   
Note that we imported Ubuntu as a ```.tar```, exported it as a resizeable ```.vhdx```, then re-imported the ```.vhdx``` under a new distro name.

Thus, the ```wsl export/unregister Ubuntu``` steps are optional - you can keep both distros on your WSL simultaneously if you like; simply point the ```wsl --import``` argument at a destination folder, and a distro-containing ```.tar``` or ```.vhd/x```, using whatever name you like (i.e., 'UBento').

- option 2; Convert from .tar-based backup named to .vhdx-based distro named 'UBento', without storing a backup;

      wsl --import UBento "C:\my\install\folder" "C:\my\backup\folder\ubuntu.tar"
    
- Docker desktop and data storage can be managed in the exact same way;
    
      wsl --export docker-desktop "D:\Backup\Docker_desktop.vhdx" --vhd
      wsl --unregister docker-desktop
      wsl --import docker-desktop "D:\Docker" "D:\Backup\Docker_desktop.vhdx" --vhd

      wsl --export docker-desktop-data "D:\Backup\Docker_desktop_data.vhdx" --vhd
      wsl --unregister docker-desktop-data
      wsl --import docker-desktop-data "D:\Docker\Data" "D:\Backup\Docker_desktop_data.vhdx" --vhd
    
- All of the above can also be run from another WSL distro's terminal by creating an alias;

      alias wsl='/mnt/c/Windows/wsl.exe'
    
      wsl --import Ubuntu "D:\Ubuntu" "C:\Users\<username>\ubuntu_minimal.tar"
    
      # etc...
   
## Git tip from microsoft WSL docs

When handling a single repo on both your Windows and Linux file systems, it's a good idea to weary of line endings. They suggest adding a ```.gitattributes``` to the repo's root folder with the following, to ensure that no script files are corrupted;    

    * text=auto eol=lf
    *.{cmd,[cC][mM][dD]} text eol=crlf
    *.{bat,[bB][aA][tT]} text eol=crlf

## Shutting down

Note that if you choose not to ```unminimize```, not install systemd, or otherwise have no real shutdown strategy in your distro, you can always 
    
    alias shutdown=wsl.exe -d <myDistro> --shutdown && logout

then
    
    shutdown

## [REFERENCES AND SOURCES]

- Microsoft WSL docs ...
- Docker Desktop for Win/WSL2 docs ...
- X410 cookbook ...
- SO thread about X server encryption ...
- Package keys; please see respective repos on GH ...
