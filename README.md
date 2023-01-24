# UBento
Minimal, bento-box style Ubuntu-based WSL distro front-end, ideal for targeting Linux-style NodeJs and CMake development environments from Windows platforms.

Quick start (see 'requirements');

```
# Download ubento.tar from the releases page to "C:\Users\${username}\ubento.tar"
# Import Ubento into WSL and launch;
> wsl --import UBento "C:\Users\${username}\UBento" "C:\Users\${username}\ubento.tar"
> wsl -d UBento
$ make_user "${username}" "${full name}"
# Supply and confirm a password... and welcome to UBento :)
```

Alternative - Build from source (see 'requirements' and [TIPS]:Building from source);

```
> docker run -it ubuntu bash ls /
> docker export -o "C:\Users\${username}\ubuntu.tar"  ${distronumber}
> wsl --import UBento "C:\Users\${username}\UBento" "C:\Users\${username}\ubuntu.tar"
> wsl -d Ubento
# Copy UBento files (see README.md!)
$ make_user "${username}" "${full name}"
# Supply and confirm a password... and welcome to UBento :)
```


![UBento-icon](https://github.com/StoneyDSP/ubento/blob/4da549bafe71e969ec072987a8b561eb3eb2a5ec/ubento.png)


## About

The WSL Ubuntu distro that is available from the MS Store is initialized via a snap called "install RELEASE", and also comes bundled with a rather hefty APT package suite called ```ubuntu-wsl```. The MS Store Linux distros are also generally bundled with the "WSL2 Distro Launcher", which provides for example the 'Ubuntu.exe' on the Windows-side. This is a nice interoperability, but particularly the snap requirements are quite costly in both storage and performance.

The MS Store Ubuntu distro also contains quite a large stash of Bash completion helpers and scripts, covering many packages and libraries that are not actually to be found on the base install but which are still updated regularly at source (e.g., CMake), and the standard APT keyring which holds many outdated packages (e.g., NodeJs v.12...?), yet does not provide other common developer packages (e.g., Yarn) by default.

Instead, we can pull Ubuntu-Minimal - Approx. 74mb - from a Docker container image, and launch that in WSL directly. Ubuntu-Minimal also has the ```unminimize``` command which rehydrates the install into the full "interactive login" version of Ubuntu; from there, we can build a much more streamlined Ubuntu with fewer runtime dependencies and practically no Linux-side background service requirements of it's own (compare by running ```service --status-all```) and tailor the environment towards a full-powered development environment with full GUI/desktop support via an encrypted Windows X-Server, *and* with a much reduced storage footprint, a fully up-to-date package registry, and - in many cases, - highly improved runtime performances.

This will hopefully all get compiled into some sort of an interactive bash script... if time permits. Meanwhile, you can check the files provided here in the repo to get the idea - copying these simple bash scripts into the Ubuntu-Minimal docker distro and installing/running a few standard packages is all that is required to achieve the above goals of UBento.


## System Requirements:

- Windows 11 22h2 or greater
- WSL2 (Windows Subsystem for Linux), optionally with a working Linux kernel/distro

## Optional:

- VSCode with Remote Development Extensions, used for editing your code hosted on the WSL2 backend
- X-Server for Windows such as VcXsrv or X410 for GUI/desktop support if desired
- Docker Desktop for Windows using the WSL2 backend, used for obtaining and running developer environment images and building from source

## Todo:

- Finish X-Server encryption helper function
- Use the shared ```$WSLENV``` variable to optionally link the distro userspace, to the Windows userspace
- Try ```$WSLENV``` for sharing a single, translatable path to an '.Xauthority' key between both userspaces (this works for SSH keys and symlinks...)
- Investigate usage of user-login password as an MIT-encrypted env variable (like ```{{ git.SECRET }}``` ) for use with Git control, intializing DBus with as sudo during startup routine, authenticating the X-Server encryption layer step, and so on
- Implement as a shell-scripted front-end for a fast, flexible, potentially CI-capable* Ubuntu-Minimal deployment

*where the ```unminimize``` command and other rehydrations can be averted from use cases.


## Notes:

- Run the suggested instructions in either your Windows Powershell (```>```), or your current WSL2 distro's terminal (```$```), but obviously don't bother entering the comment lines (```#```). Make sure to fill in the blanks where ```<variables>``` are concerned.

- Neither ```unminimize``` nor systemd are really required for most developing purposes - see [TIPS].

- Check the [TIPS] and [TROUBLESHOOTING] sections for helpful insights.

- Try it with other Linux flavours and goals.


![UBento-icon](https://github.com/StoneyDSP/ubento/blob/4da549bafe71e969ec072987a8b561eb3eb2a5ec/ubento.png)


To get started, run the below in either your Windows Powershell (```>```) or your Linux Bash (```$```) terminal;


## [PRE-INSTALL]

First, we need to get a copy of the distro and import it into WSL, all on the Windows-side. There are currently two different strategies to achieve this; a quick-start method that will have all the benefits of UBento pre-loaded and ready to be executed, or alternatively you can choose to build a distro from source, and follow the suggestions and specifications highlighted in this document for yourself (see "[TIPS]:Building from source").

- Opt 1 - Download the pre-configured distro for a quick start;

    Check the "Releases" page here and grab the latest UBento version, which should specifically be a .tar file with no further extension types; i.e., ```ubento-v1-0-1.tar```.

Then, you can use WSL to directly import that .tar file, immediately launching a mostly-configured UBento as 'root' user, by proceeding to the next step.


- Opt 2 - Pull Ubuntu-Minimal from a Docker Desktop image into .tar (Approx. 74mb) to build from source

    ```
    > docker run -it ubuntu bash ls /
    ```

    Take a note of the container ID of the Ubuntu image that was just running, then export it to some handy Windows location, using the .tar extension (WSL can then import it directly), as follows;

    ```
    > docker container ls -a
    > docker export -o "C:\Users\<username>\ubuntu_minimal.tar" "<UbuntuContainerID>"
    ```

    NOTE: If you're choosing option 2 of the above - building a distro from source, by pulling a clean Ubuntu image from Docker Desktop and importing it - then I strongly suggest scrolling down to [TIPS:Building from source] for a clear understanding of the difference between the image hosted on the UBento "Release" page, and the Ubuntu image hosted by Docker. If building from source, the majority of this document only applies if you follow the provided instructions in [TIPS] correctly, before proceeding any further. If you choose to deviate from these instructions, you will simply have to adjust all the given advice accordingly - just a friendly dev-to-dev FYI :)

## Importing the .tar file to run as a distro in WSL

We then have a few options for how we wish to store UBento, such as using the dynamic virtual hard drive (.vhd or .vhdx) format, and backing up and/or running from external storage drives. The ```--export``` command in the below example stores a backup mountable image in the 'D:\' drive (which can be a smart card or USB memory, etc), but you may of course place the files anywhere you like (see [TIPS] for more storage examples).

```
> wsl --import UBento "C:\My\Install\Folder" "C:\Users\<username>\ubento.tar"

> wsl --export UBento "D:\My\Backup\Folder\ubento.vhdx" --vhd
```

## Backing up for restarting with a clean slate;


It later turns out to be handy to run that previous ```--export``` argument around this stage, or whenever you feel you have a good starting point;

```
> wsl --export <myPerfectDistro> "D:\My\Backup\Folder\my_perfect_distro.vhdx" --vhd
```

This is because if/when we screw anything up in our distro and want to start over from scratch, we can then simply;

```
> wsl --unregister <myBadDistro>

> wsl --import <myPerfectDistro> "D:\My\Install\Folder" "D:\My\Backup\Folder\my_perfect_distro.vhdx"
```

And that puts us back to exactly where we last ran the ```--export``` command. Please see the [TIPS] section for much more advice on distro importing, exporting, and storage.


## Check UBento is installed and launch it;

```
> wsl -l -v
# UBento should be listed amongst your WSL distros...


> wsl -d UBento
# The docker Ubuntu Minimal image we pulled earlier - now named 'UBento' - will now launch in the terminal...
```

## [POST-INSTALL]


The below steps are to be run from within your new WSL Ubuntu-based bash terminal (```$```).


- set permission for root folder (see '[TIPS]:Building from source' for info on this command), restore server packages, and install basic dependencies;

```
$ init_permissions
$ apt update && apt install apt-utils dialog

# If you need superuser accesses...
$ apt install sudo && sudo -s

# If you wish to 'rehydrate' from Minimal to a fully interactive, login-based install...
$ yes | unminimize

# Choose which base packages you need, I suggest something like these...
$ apt install less manpages nano vim gawk grep bash-completion bash-doc git curl wget libreadline8 readline-common readline-doc resolvconf gnu-standards xdg-user-dirs openssl ca-certificates lsb-release xauth

# Clear the APT cache if you like...
$ rm -rf /var/lib/apt/lists/*
```

## [CREATE USER]

- named "username" (could use ```$WSLENV``` to pull your Win user name here - stay tuned) with the required UID of '1000'. You will be prompted to create a secure login password for your new user;

```
$ export username="<Your Username Name>"
$ export fullname="<Your Full Name>"
$ export email="<Your Email>"

make_user()
{
    adduser --home=/home/"${1}" --shell=/bin/bash --gecos="${2}" --uid=1000 "${1}"

    usermod --group=adm,dialout,cdrom,floppy,tape,sudo,audio,dip,video,plugdev "${1}"

    login ${1}

    git config --global user.name "${1}"

    git config --global user.email "${3}"

    echo -e "[user]\n default=${1}\n" >> /etc/wsl.conf
}

$ make_user "${username}" "${fullname}" "${email}"

# The output of the above function will prompt you to create and confirm a secure login password, then to repeat it again to complete the actual log in process. Once complete, you will be in your linux user-space
```

From now on, you can use ```sudo``` invocations from your new user login shell (assuming you already installed sudo), and will also have access to useful system commands like ```sudo apt update && sudo apt ugrade```.

Back in Powershell (```>```), we can now login as our new user (the ```--user``` argument here shouldn't be necessary due to the 'default user' setting in ```/etc/wsl.conf```, but it doesn't hurt to be sure here on this first re-launch, as this *ensures* we run finish critical initialization procedure correctly!)

```
> wsl -d UBento --shutdown
> wsl -d UBento --user "${username}"
```

*You can also adapt the above command for launching a Windows Terminal profile, for example (see [TIPS]).*

## At this point, the distro remains minimal yet fully scalable, GUI apps and Windows integration should be working, and UBento is well-configured to continue on as you please...


...but, the idea with UBento is take some minimal steps to greatly enhance the experience where possible. We can choose to tailor our UBento towards either/both a fully-configured desktop environment, and/or a fully-configured development environment; the scripts below are presented as suggestions, largely based on exposed defaults that can be found on actual Linux desktop machines made portable - and, with small tweaks to further explore some of the more useful, powerful, and interesting desktop interoperability opportunities that an otherwise feather-weight WSL/Ubuntu-Minimal distro can provide.


![UBento-icon](https://github.com/StoneyDSP/ubento/blob/4da549bafe71e969ec072987a8b561eb3eb2a5ec/ubento.png)


## [DEVTOOLS KEYRING]

Requires some of the basic packages from earlier, such as wget/curl/git/gpg/lsb-release/openssh-client.

```
$ sudo apt install wget curl git gpg lsb-release openssh-client

$ export DISTRO="$(lsb_release -cs)"
$ export ARCH="$(dpkg --print-architecture)"
$ export APT_SOURCES="/etc/apt/sources.list.d"
$ alias apt_cln='rm -rf /var/lib/apt/lists/*'
```

The following bash functions are already pre-defined in the root user's ```~/.bashrc.d/bash_keyring.sh```, which is accessed by called ```sudo -s``` (to enter a shell as the root user with sudo privileges), then just entering the name of the function, such as ```get_node```. Back in your user-space you then just ```sudo apt install nodejs``` to install the latest release, per the function definition. If any of them don't work, just make sure that ```sudo``` has the above export locations when doing ```get_<key>```. 

These are reproduced here in altered form for convenience and testing. The following function convention is just an "average", based on the APT-key instructions provided by each vendor, which all vary slightly but more or less follow the below formula ('get key, add to lst, update cache'...).

- Node (latest)

```
$ export DISTRO="$(lsb_release -cs)"
$ export ARCH="$(dpkg --print-architecture)"
$ export APT_SOURCES="/etc/apt/sources.list.d"

$ export SYS_NODE_V="node_19.x"

$ get_node()
{
    export NODEJS_KEY="/usr/share/keyrings/nodesource.gpg"

    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee $NODEJS_KEY >/dev/null

    echo "deb [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/$SYS_NODE_V $DISTRO main" | tee $APT_SOURCES/nodesource.list

    echo "deb-src [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/$SYS_NODE_V $DISTRO main" | tee -a $APT_SOURCES/nodesource.list

    apt update
}

$ apt install nodejs

$ npm --global install npm@latest
```


- Yarn (latest)

```
$ export ARCH="$(dpkg --print-architecture)"
$ export APT_SOURCES="/etc/apt/sources.list.d"

$ get_yarn()
{
    export YARN_KEY="/usr/share/keyrings/yarnkey.gpg"

    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee $YARN_KEY >/dev/null

    echo "deb [arch=$ARCH signed-by=$YARN_KEY] https://dl.yarnpkg.com/debian stable main" | tee $APT_SOURCES/yarn.list

    apt update
}

$ apt install yarn

$ yarn global add npm@latest
```


- Node Version Manager (note that it will install into ```$XDG_CONFIG_DIR```, so ```$HOME/.config/nvm```)

```
$ get_nvm()
{
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh" | bash
}

# Choose as preferred...

# nvm install --lts
# nvm install node
$ nvm use system

# The useful "cd_nvm()" function is already provided in /etc/profile.d/bash_functions.sh - so, when navigating between Node project repo's on the command line, feel free to...

$ cd_nvm <Node Project Repo>

# ...and NVM should do it's thing.
```


- Fully ssh-authenticated Git and Chrome integration

```
$ export DISTRO="$(lsb_release -cs)"
$ export ARCH="$(dpkg --print-architecture)"
$ export APT_SOURCES="/etc/apt/sources.list.d"

# Requirements...
$ apt install curl wget git gpg

$ get_chrome()
{
    curl "https://dl.google.com/linux/direct/google-chrome-stable_current_$ARCH.deb" -o "$XDG_DOWNLOADS_DIR/chrome.deb"

    apt install "$XDG_DOWNLOADS_DIR/chrome.deb"
}

$ get_gith()
{
    export GH_KEY="/usr/share/keyrings/githubcli-archive-keyring.gpg"

    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | tee $GH_KEY >/dev/null

    echo "deb [arch=$ARCH signed-by=$GH_KEY] https://cli.github.com/packages stable main" | tee $APT_SOURCES/github-cli.list

    apt update
}

# Optionally install Chrome...*
$ get_chrome

$ get_gith


# * *Note that if you have w3m installed by now but not a full browser such as Chrome, the gh CLI can actually open and display the GitHub authentication webpage in ASCII format, directly in the Linux terminal, if it must ;)*
```

Following the above, you can ```exit``` back to your user account, then

```
$ export PUBKEYPATH="$HOME/.ssh/id_ed25519.pub"

$ alias g="git"

$ sudo apt install gh
$ g config --global user.name "<Your Git Name>"
$ g config --global user.email "<Your Git Email>"
$ gh auth login
# Choose .ssh option... then;
$ gh auth setup-git

$ nano $XDG_CONFIG_HOME/git/config
```

As nano shows, your Git SSH key credentials can now managed by the GitHub CLI client, and the GitHub CLI commands and credential manager tools are available to use, along with the regular Git and SSH commands. You can now invoke your SSH key (available at ```$PUBKEYPATH```) with an expanded set of Git-based commands using SSH encryption;

```
$ export DEV_DIR="$HOME/Development"

$ g clone git@github.com:StoneyDSP/ubento.git "$DEV_DIR/UBento"

# Or....

$ gh repo clone git@github.com:StoneyDSP/ubento.git "$DEV_DIR/UBento"
```

Here are some other common tools for development - again, do ```sudo -s``` first (if you are running these commands directly from this README.md file);


- PGAdmin (for PostgreSQL)

```
export DISTRO="$(lsb_release -cs)"
export APT_SOURCES="/etc/apt/sources.list.d"

get_pgadmin()
{
    export PGADMIN_KEY="/usr/share/keyrings/packages-pgadmin-org.gpg"

    curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor -o $PGADMIN_KEY

    echo "deb [signed-by=$PGADMIN_KEY] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$DISTRO pgadmin4 main" > $APT_SOURCES/pgadmin4.list

    apt update
}


# install packages - the postgresql package will create a new user named 'postgres', as needed...
$ sudo apt install apache2 apache2-bin apache2-data apache2-utils apache2-doc postgresql postgresql-contrib postgresql-15-doc

# start the server...
$ sudo service postgresql start

# Install for both desktop and web modes:
$ sudo apt install pgadmin4

# set up pgAmdmin with your user email and password...
$ sudo /usr/pgadmin4/bin/setup-web.sh

# create a password, for example 'postgres'...
$ sudo passwd postgres

# enter psql shell as user 'postgres'...
$ sudo -u postgres psql

# in the psql shell, give 'postgres' a password, list all users, create two more, and list again before exiting...
> ALTER ROLE postgres WITH PASSWORD 'postgres';
> \du
> CREATE ROLE root CREATEDB CREATEROLE SUPERUSER LOGIN;
> CREATE ROLE <username> CREATEDB CREATEROLE SUPERUSER LOGIN;
> ALTER ROLE root WITH PASSWORD 'root';
> ALTER ROLE <username> WITH PASSWORD '<password>';
> \du
> \q

# open the link in a browser* to log in to pgAdmin (works on either Windows or Linux side);
http://localhost/pgadmin4

# Choose 'Register new server'
# On 'General' tab, choose any name you wish
# Go to 'connection' tab and enter as follows;

# Hostname/address: localhost
# Port: 54322
# Maintenance database: postgres
# Username: postgres
# Password: postgres

# Click 'save' - you should now see your local db's etc listed under 'servers'!

# The above combination will also be served at;

postgresql://postgres:postgres@localhost:54322/postgres

# which is equivalent to;

{service}://{user}:{password}@{address}:{port}/{database}

# Note that some WSL users have reported better performance by using address value of '127.0.0.1' - I can't be too sure, but having your distro's hostname be renamed to something *other than* the Windows name tends to be helpful in these situations; I again suggest i.e., Windows host name = "localclient", Linux host name = "localhost". It throws a small warning in the WSL debug terminal on launch, but the operation is still allowed to pass.

# Now your user(s) can also use the full PostgresQL (and PGAdmin) tools on the CL... without invoking 'sudo'.
# Postgres also has some well-used bash completion scripts such as 'createdb'. Make sure to generate the bash completion scripts!
# *note that that you can also launch the 'pgAdmin4-desktop' app instead of the web-based interface, if you prefer...
```


- Supabase (check repo for latest release version number, these outdate quickly...)

```
$ export ARCH="$(dpkg --print-architecture)"

$ export SYS_SUPABASE_V="1.27.0"

$ get_supabase()
{
    curl "https://github.com/supabase/cli/releases/download/v$SYS_SUPABASE_V/supabase_$SYS_SUPABASE_V_linux_$ARCH.deb" -o "$XDG_DOWNLOAD_DIR/supabase.deb"

    apt install "$XDG_DOWNLOAD_DIR/supabase_$SYS_SUPABASE_V_linux_$ARCH.deb"

    supabase completion bash > /etc/bash_completion.d/supabase
}

$ get_supabase

# as user...
$ supabase login
```


- Postman (will save your login key to your home folder)

```
& get_postman()
{
    curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | bash
}

# as user...
$ postman login
```


- CMake (you should have Make and/or other build tools, and check out Visual Studio with WSL - you can now use MSBuild tools on Linux-side code!)

```
$ export DISTRO="$(lsb_release -cs)"
$ export ARCH="$(dpkg --print-architecture)"
$ export APT_SOURCES="/etc/apt/sources.list.d"

$ sudo apt install build-essential gnu-standards pkgconfig

$ get_cmake()
{
    export KITWARE_KEY="/usr/share/keyrings/kitware-archive-keyring.gpg"

    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee $KITWARE_KEY >/dev/null

    echo "deb [arch=$ARCH signed-by=$KITWARE_KEY] https://apt.kitware.com/ubuntu $DISTRO main" | tee $APT_SOURCES/kitware.list

    apt update
}

$ apt install kitware-archive-keyring cmake cmake-data cmake-doc ninja-build
$ cmake completion bash > /etc/bash_completion.d/cmake # not sure of the actual correct command here, check cmake docs to confirm...
```


- vcpkg-tool (still working on this, note that you can get vcpkg itself quite easily too)

```
$ get_vcpkg_tool()
{
    . <(curl https://aka.ms/vcpkg-init.sh -L)

    . ~/.vcpkg/vcpkg-init

    vcpkg integrate install

    vcpkg integrate bash

    vcpkg completion bash > /etc/bash_completion.d/vcpkg
}
```

Untested; integrating ```pkg-config``` to detect ```.pc``` files stored on either system... check the following (and my CMake repo);

```
$ pkgconfig --list-all
```


## [INTEROPERABILITY]

- We can set Linux-side aliases to our Windows executables in ```/etc/profile.d/bash_aliases.sh``` like this;

```
alias wsl='/mnt/c/Windows/System32/wsl.exe'

$ wsl --list --verbose
# Will list all of WSL's installed distros and statuses

alias notepad='/mnt/c/Windows/System32/notepad.exe'

$ notepad .
# Will launch Notepad - careful with those line ending settings!
```

- What about using our Linux-side libs and binaries on our Windows-side files, in PowerShell? Well...


Let's call the WSL Ubento user-login shell with a command line invocation, to create and open a new Windows-local file named 'nanotest';

```
> wsl --shell-type login -d ubento --exec nano ./nanotest
```

Type the word 'success!' and press 'Ctrl-s', then 'Ctrl-x', to save and exit nano, then execute the below in PowerShell to 'cat' the result;

```
> wsl --shell-type login -d ubento --exec cat ./nanotest
# success!
```

Be very wary of file permissions, line-ending settings, and conversions that the above basic text editors are unknowingly capable of, and leverage every interoperability opportunity that you can find among their individual configuration files. For example, GNU nano uses a 'nanorc' or '*.nanorc' file to control certain configuration aspects, handily on a per-filetype basis. Some 'nanorc' settings to be very watchful of (suggested settings below) - this file usually exists at system-level in ```/etc/nanorc``` and user-level in ```$XDG_CONFIG_HOME/nano/nanorc```;

```
## Don't convert files from DOS/Mac format.
set noconvert
## Save files by default in Unix format (also when they were DOS or Mac).
# set unix
```


- Don't forget to test out VSCode with the Remote Development extension installed on the Windows side, of course... ;

This is an excellent example of WSL capable is offering; your code-base is stored and served from "localhost", i.e., the Linux (back-end) side, while the VS Code graphical code-editor application runs in "localclient", i.e., your Windows-side software and hardware

```
$ cd $HOME
$ code .

# Will run an installation step for 'vscode-server-remote' on first run....
# Also check the 'extensions' tab for many WSL-based versions of your favourite extensions
# Make sure that you *don't* already have VSCode installed on the Linux side before doing this, as that's *not* how the Remote Dev extension works! ;) 
```

- Test Docker Desktop interoperability, if you have it; (IMPORTANT - do not run this step until AFTER creating your user with UID 1000, otherwise Docker tries to steal this UID!);

```
# make sure the 'UBento' option is checked in Windows Docker Desktop settings > resources for this to work

$ docker run hello-world
$ docker run -it alpine bash
```


![UBento-icon](https://github.com/StoneyDSP/ubento/blob/4da549bafe71e969ec072987a8b561eb3eb2a5ec/ubento.png)


## [TROUBLESHOOTING]

## Enabling Hyper-V, Virtual Machine Platform, and WSL on Windows.

- Get the required packages (save as "HyperV.bat" and launch in PowerShell):

```
pushd "%~dp0"

dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hv.txt

for /f %%i in ('findstr /i . hv.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"

Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL

pause
```

Restart your Windows machine once the above is complete.


- Enable the Windows features (run each command in PowerShell):


Virtual Machine Platform;

```
> dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Hyper Virtualization;

```
> dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V /all /limitaccess /all /norestart
```

Windows Subsystem for Linux;

```
> dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

Restart your Windows machine once the above is complete.


## Storage considerations


Think very carefully about how/where you choose to store your runtime distro on disk, and linkages between environments - particularly the user desktop, downloads, documents folders, and other regularly accessed locations. 

It is generally safe to have access to your Windows-side file system via the Linux-side ```/mnt``` directory *and* to use symbolic links from Linux-side (user's "download" folders, etc) to the Windows environment. However, based on some experience, I would recommend *against* combining this with running your distro from an external/removable storage drive, like USB or SD card. 

While the mounting/linkage practices are both quite safe enough to be default behaviour in WSL, *and* it mounts and runs just fine from external storage which I happily depend upon daily, you could be running some risk when attempting to write to your Windows file system from the Linux-side and experiencing a hardware failure, such as a cat chewing on your USB stick and causing some file-corruption. 

Desktop linkage is really cool, as is external storage - but I'd have to recommend *not* to mix the two, in the case of WSL.


## Still having package/service dependency issues?

The MS Store Ubuntu distro ships with a very large APT package suite named ```ubuntu-wsl``` that we can instead break down into smaller dependency cycles, as and where (or even if) required. But you can go ahead and ```apt install ubtuntu-wsl``` if you do experience any issues.

```
sudo apt install ubuntu-wsl
```

Note that the package ```wsl-setup``` attempts to run the Ubiquity "install-RELEASE" snap that creates the default WSL Ubuntu install for us, should you be interested (requires apt install snapd).

```
sudo apt install snapd
sudo snap refresh
sudo snap list
```

No default snaps (cool!), but all the ```/snapd/bin``` folder locations should be appended to the $PATH variable - make sure to check ```/etc/profile``` and the troubleshooting tips below :)

To get back to the MS Store version from here, you can

```
sudo snap install ubuntu-desktop-installer --classic
sudo wsl-setup
```


## Defining Runtime Behaviour

This step need not apply if you are happy running Linux GUI apps (with excellent performance) but aren't looking to explore the desktop capabilities of your distro. GUI apps will already be working smoothly at this stage, directly from their Windows launchers. But if you're doing anything that requires systemd to be installed, then it is quite important provide some control over certain system-level runtime behaviours; particularly, for our user's first launch into systemd.

```
$ echo -e "[boot]\n systemd=true\n" >> /etc/wsl.conf
```

Make sure the following two modified functions from the x410 cookbook are defined in ```/etc/profile.d/ubento_helpers.sh``` and are present/called in ```$HOME/.profile``` for user, but *NOT* for root (IMPORTANT!) - they should be at the end after the exports;

```
set_runtime_dir
set_session_bus

# https://x410.dev/cookbook/wsl/running-ubuntu-desktop-in-wsl2/
```

Setup systemd/dbus and accessibility bus, do a full shutdown;

```
$ apt install systemd dbus at-spi2-core
$ wsl.exe -d UBento --shutdown
```

It is CRITICAL* during systemd configuration that of the previous steps, the following (as a minimum) are taken in the correct order, as summarized;

- launch distro as root to install apt-utils, dialog, and sudo
- copy ubuntu-helpers/profile/bashrc/wsl.conf files
- add new user and password
- install systemd/dbus/at-spi2-core
- shutdown distro and reboot as new user


*this sequence ensures that when the distro default user account is finally accessed, it has the UID of 1000 assigned, and calls the ```set_runtime_dir``` and ```set_session_bus``` functions from the X410 cookbook using this UID during initialization. This sequence creates a runtime directory at ```/run/user/1000``` during initialization where the dbus-daemon (and accessibility bus) is started from, and this runtime location is maintained/used when opening further sessions using this same distro. It is also critical that the root user does NOT have access to these functions (they should not be present at all in ```/root/.profile```).


## Help! My distro is broken ('read-only' file system errors)

If you are unable to load your distro and recieve errors such as the above...

- DON'T use anything except NFTS as your storage volume type - in particular, FAT32 file systems do NOT allow file sizes above 4gb. Your distro will fail on a FAT32 storage drive once it reaches 4gb - simply move the file to a backup location, re-format the storage to NTFS and try again.
- Enable the 'debug' option in your C:\Users\{username}\.wslconfig file to launch an additional terminal read-out to gather more info on the issue, it's usually one of two things... 
- Make sure that the storage location of your distro's ext4.vhd is not full, i.e., if using external/remote storage
- If it appears that you are very low on disk space, do ```$ ls -la /var/log``` - you may find a few thousand mb's worth of log files, particularly from the X server (tip welcome!), which you can ```$ sudo rm -rvf /var/log/Xorg*``` to remove entirely.
- If disk space continues to be the issue (i.e, the above command appears to have worked, but your ext4.vhdx didn't actually shrink so you are still out of disk space), then you are probably using .vhdx (i.e., 'dynamic' sized virtual disk) where plain old .vhd (i.e., 'static' sized virtual disk) would have done the trick... you can use WSL as a handy and easy .vhd/x conversion tool with ```wsl --export <distro> 'C:\some\storage\location\ext4.vhd' --vhd``` and ```wsl --import-in-place <distro> 'C:\some\storage\location\ext4.vhd' --vhd``` in a matter of seconds. See [TIPS]:Storage for more.
- If it does not appear to be a disk space issue but rather some strange permissions error... there are a few reasons why this can happen, which can often easily be fixed using the below (which even works on the 'permission-error' distro itself);

```
## In PowerShell, we will first unmount the .vhd then re-import it to ensure the correct mount location is given (as it can get corrupted from time to time);
> wsl -d <distro> --unmount
> wsl --import-in-place <distro> 'C:\my\install\location\ext4.vhdx' # Or .vhdx, or even .tar...
> wsl --shutdown # Wait until wsl -l -v shows all distros totally offline
> wsl -d <distro>

## Now in your distro;
$ init_permissions()
{
    chmod 755 / && \
    chmod 1777 /tmp &&\
    find /tmp \
        -mindepth 1 \
        -name '.*-unix' -exec chmod 1777 {} + -prune -o \
        -exec chmod go-rwx {} +

    # https://unix.stackexchange.com/questions/71622/what-are-correct-permissions-for-tmp-i-unintentionally-set-it-all-public-recu
}
$ init_permissions
$ mount | grep ext4
## Note which entry contains "/" exclusively - should probably be under "sdc", but sometimes will be "sdd" or something else (usuaully when broken)...
$ sudo e2fsck /dev/sdc -y # Use /sdd or whichever entry as per the previous command!
```

The final command above may take a while - in fact, it sometimes seems to be need to be run twice - and it's likely wise to ```wsl --shutdown``` between attempts. However, all of the above steps have revived a seemingly-dead distro for me ever since discovering them, whereas I once was faced with simply deleting and starting again on any error which was of course heavily disheartening.

Thus, I firmly recommend examing the above suggestions in the case of a seemingly "broken" distro - it does seem that the fixes are usually just a few terminal commands and nothing more.


## [TIPS]

## Buidling from source

(tbc - could just place a bash script and use curl/wget/git to fetch everything... alternatively, check the pre-releases tab for a pre-build!)

```
> docker run -it ubuntu bash ls /
> docker export -o "C:\Users\${username}\ubuntu.tar"  ${distronumber}
> wsl --import UBento "C:\Users\${username}\UBento" "C:\Users\${username}\ubuntu.tar"
> wsl -d Ubento

$ init_permissions()
{
    chmod 755 / && \
    chmod 1777 /tmp &&\
    find /tmp \
        -mindepth 1 \
        -name '.*-unix' -exec chmod 1777 {} + -prune -o \
        -exec chmod go-rwx {} +

    # https://unix.stackexchange.com/questions/71622/what-are-correct-permissions-for-tmp-i-unintentionally-set-it-all-public-recu
}
$ export -f init_permissions

$ init_permissions
$ apt update
$ apt install apt-utils dialog && apt install sudo && sudo -s
$ sudo unminimize
$ apt install nano less lsb-release curl wget git # And whatever other dependencies you might need...
```

Git-clone the UBento source files somewhere locally... you could store it Linux-side directory, such as '$HOME/Development/ubento' and adjust this step accordingly. See the [TIPS] and [DEVTOOLS KEYRING] sections for ideas.

Here's an example where we've git cloned this repo it to our Windows home folder;

```
$ export UBENTO_WIN_REPO="/mnt/c/Users/${username}/repos/ubento"

$ git clone "https://github.com/StoneyDSP/ubento.git" "$UBENTO_WIN_REPO"

$ yes | cp -f "$UBENTO_WIN_REPO/etc/profile.d/*.sh"              "/etc/profile.d/*.sh"              && \
yes | cp -f "$UBENTO_WIN_REPO/etc/skel/.bash_profile"            "/etc/skel/.bash_profile"          && \
yes | cp -f "$UBENTO_WIN_REPO/etc/skel/.bash_logout"             "/etc/skel/.bash_logout"           && \
yes | cp -f "$UBENTO_WIN_REPO/etc/skel/.bashrc"                  "/etc/skel/.bashrc"                && \
yes | cp -f "$UBENTO_WIN_REPO/etc/bash.bashrc"                   "/etc/bash.bashrc"                 && \
yes | cp -f "$UBENTO_WIN_REPO/etc/profile"                       "/etc/profile"                     && \
yes | cp -f "$UBENTO_WIN_REPO/etc/environment"                   "/etc/environment"                 && \
yes | cp -f "$UBENTO_WIN_REPO/root/.bashrc"                      "/root/.bashrc"                    && \
yes | cp -f "$UBENTO_WIN_REPO/root/.bash_profile"                "/root/.bash_profile"
# ...and so forth (will executable-script this operation at some point!)

# *optional, see final post-install step
$ yes | cp -f "$UBENTO_WIN_REPO/etc/wsl.conf" "/etc/wsl.conf"
```

Note that we don't go making and copying stuff into ```/home/{username}``` at all, since we didn't create a user yet - instead, we place all of our desired user-level config files in ```/etc/skel```, then run an ```adduser```- style command to securely create a new system user, with all the correct file permissions and user specs (UID = 1000, for example) taken care of, which is itself populated by the contents of ```/etc/skel```.

To do that, we can;

```
$ export username="<Your User Name>"
$ export fullname="<Your Full Name>"

$ make_user()
{
    adduser --home=/home/"${1}" --shell=/bin/bash --gecos="${2}" --uid=1000 "${1}"

    usermod --group=adm,dialout,cdrom,floppy,tape,sudo,audio,dip,video,plugdev "${1}"
    
    echo -e "[user]\n default=${1}\n" >> /etc/wsl.conf

    login ${1}
}

$ make_user "${username}" "${fullname}"
```


## [DESKTOP SETTINGS]

Now we can make ourselves at home in the ```$HOME``` folder.

The user-local ```$HOME/.bash_profile``` file will contain several pointers for our desktop environment, including additional bin and man paths, as well as linkage to our home folders - we don't need to set these ourselves as they will have been pulled in from ```/etc/skel``` when we created our user (see previous steps!), but these are useful to be aware of when setting up our desktop;

```
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/man" ]; then
    MANPATH="$HOME/man:$MANPATH"
fi

if [ -d "$HOME/info" ]; then
    INFOPATH="$HOME/info:$INFOPATH"
fi

export PATH MANPATH INFOPATH

if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi

if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -z "$XDG_STATE_HOME" ]; then
    export XDG_STATE_HOME="$HOME/.local/state"
fi

export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_VIDEOS_DIR="$HOME/Videos"

# And so forth...
```

The directories indicated in all of the above *should* exist in some form, for a working desktop. One excellent touch is to leverage Linux symbolic links to share your user folders between Windows and Linux environments (option 1), or we can create ourselves an alternative userspace by not going outside the distro (option 2).

By providing symbolic links to our Windows user folders, we can get some huge benefits such as a shared "Downloads" folder and a fully "Public"-ly shared folder. Thus, you can download a file in your Windows internet browser, and instantly access it from your WSL user's downloads folder (which is the exact same file address), for example. However, there is some risk in mixing certain file types between Windows and WSL - there are several articles on the web on the subject (to be linked) which you should probably read before proceeding with either, or a mix, of the following;


## option 1 - linked storage; 

Symlink your Windows and UBento user folders with these commands (change the respective usernames if yours don't match);

- Logged in as user, NOT root(!);

    ```
    $ ln -s "/mnt/c/Users/${username}/Desktop"    "/home/${username}/Desktop"   && \
    ln -s "/mnt/c/Users/${username}/Documents"    "/home/${username}/Documents" && \
    ln -s "/mnt/c/Users/${username}/Downloads"    "/home/${username}/Downloads" && \
    ln -s "/mnt/c/Users/${username}/Music"        "/home/${username}/Music"     && \
    ln -s "/mnt/c/Users/${username}/Pictures"     "/home/${username}/Pictures"  && \
    ln -s "/mnt/c/Users/${username}/Templates"    "/home/${username}/Templates" && \
    ln -s "/mnt/c/Users/${username}/Videos"       "/home/${username}/Videos"
    ```

- optional - logged in as root;

    ```
    $ ln -s "/mnt/c/Users/Administrator/Desktop" "/root/Desktop"
    ...
    $ ln -s "/mnt/c/Users/Administrator/Videos" "/root/Videos"
    ```

- optional - 'public' shared folder...
    
    ```
    $ ln -s "/mnt/c/Users/Public" "/home/${username}/Public"
    $ ln -s "/mnt/c/Users/Public" "/root/Public"
    ```

- Alternatively, make a function;
    
    ```
    $ link_home_dirs()
    {
        ln -s /mnt/c/Users/${1}/${2} $HOME/${2}
    }

    $ link_home_dirs "<Windows User Name>" "Downloads"
    # ...etc
    ```


Let's expand our $XDG_DOWNLOAD_DIR variable out...

    ```
    # (this is NOT a terminal command!!!)
    XDG_DOWNLOAD_DIR = "$HOME/Downloads" = "/home/${username}/Downloads = /mnt/c/${username}/Downloads"
    ```

The exact same directory (and it's contents) on the Windows side...

    ```
    # (this is NOT a terminal command!!!)
    "$HOME\Downloads" = "C:\Users\${username}\Downloads" = "\\wsl.localhost\UBento\home\${username}\Downloads"
    ```

All of the above are one and the same directory...! Storage is on the Windows-side hard drive; the distro simply symlinks the user to the same filesystem address.


## option 2 - local storage; create new UBento user folders with these commands;

- Run this once as the user, then once as root...
    
    ```
    $ mkdir \
    $HOME/Desktop \
    $HOME/Documents \
    $HOME/Downloads \
    $HOME/Music \
    $HOME/Pictures \
    $HOME/Public \
    $HOME/Templates \
    $HOME/Videos
    ```

- Alternatively, use the handy XDG package to do it for us;
    
    ```
    $ sudo apt install xdg-user-dirs
    $ xdg-user-dirs-defaults
    ```

With this option, no linkage is created to your Windows user folders or hard disk; all storage remains local to your distro's portable vhd, wherever you chose to store it.



We're using ```$XDG_CONFIG_HOME``` = ```$HOME/.config``` for our desktop configuration folder (you may have to ```mkdir $HOME/.config``` if it's not already present). There are some useful things we should set up in here.


## We can set bookmark tabs for our chosen Linux-side desktop explorer;

```
$ nano $HOME/.config/gtk-3.0/bookmarks
```

add the following (with the correct username):

```
file:///home/${username}/Desktop
file:///home/${username}/Documents
file:///home/${username}/Downloads
file:///home/${username}/Music
file:///home/${username}/Pictures
file:///home/${username}/Videos
```

These locations will now appear in the tab bar of your Linux-side desktop explorer, as they should.

## We can also connect our Linux-side desktop explorer to remote servers;

```
$ nano $HOME/.config/gtk-3.0/servers
```

add the following:

```
<?xml version="1.0" encoding="UTF-8"?>
<xbel version="1.0"
      xmlns:bookmark="http://www.freedesktop.org/standards/desktop-bookmarks"
      xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info">
  <bookmark href="ftp://ftp.gnome.org/">
      <title>GNOME FTP</title>
  </bookmark>
</xbel>
```

Check your Linux-side desktop explorer's "other locations" or network options to discover this connection.


## Import your Windows fonts;

```
$ sudo nano /etc/fonts/local.conf
```

add the following:

```
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <dir>/mnt/c/Windows/Fonts</dir>
</fontconfig>
```

Slick.


## User Trash Can setup;

The XDG freedesktop specs suggest creating the following directories in your userspaces, for trash can management that integrates widely across a variety of desktop browsers (particularly in the wide world of Linux);

```
$ mkdir $HOME/.local/share/Trash/info
$ mkdir $HOME/.local/share/Trash/files
$ mkdir $HOME/.local/share/Trash/expunged
```

The above creates a Trash Can that works properly with, for example, Nautilus and Gnome. The same can (and probably should) be done for the root user. Reading up on the XDG desktop specs is well advised, if you're interested in building from source.


## Making the most of your $PATHS variable:

In "bash_paths.sh", we have a useful bash logic to check if a directory is present, and if so, to append it to a given variable, such as;

```
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
```

Make sure that you always append (for example) ```":$PATH"``` in these cases, in order to retain the previously-set values on this variable. The ```$PATH``` variable in particular *should* also contain your full Windows PATH variable, when expanded;

```
$ echo $PATH
# This list should contain all your Windows PATH entries as well as your distro's...
```

If you don't see your Windows env paths in the terminal on calling the above, check all of your ```$PATH``` calls in ```/etc/profile```, ```$HOME/.profile```, and the ```/etc/wsl.conf``` interoperability settings. Furthermore, when installing new software on the Linux-side, these occasionally attempt to add further values to certain variables such as ```$PATH```, so try to keep a check on it's output behaviour.

You could adapt a tidy function like the one below, if you prefer (note that the logic differs, though);

```
# Append "$1" to $PATH when not already in.
# Copied from Arch Linux, see #12803 for details.
append_path () {
      case ":$PATH:" in
              *:"$1":*)
                      ;;
              *)
                      PATH="${PATH:+$PATH:}$1"
                      ;;
      esac
}

append_path "/usr/local/sbin"
append_path "/usr/local/bin"
append_path "/usr/sbin"
append_path "/usr/bin"
append_path "/sbin"
append_path "/bin"
unset -f append_path

export PATH
```

## Bash Completion

Many, perhaps most, modern CLI applications also ship with completion scripts. Though these scripts aren't as prone to frequent updates as the applications themeselves are, there can still be large delays between a vendor's latest stable release version, and the corresponding version bound to APT's default keyring. On top of this, the WSL Ubuntu build in the MS Store also ships with quite a variety of bash completion scripts, split between several different directories (```/etc/bash_completion.d``` and ```/usr/share/bash_completion```), which correspond to the application versions... which are bound to APT's default keyring. 

Thus, if you're binding the latest APT keys as suggested in the [DEVTOOLS KEYRING] section to install latest sotware versions, then you can usually find a 'completion' command (eg ```supabase completion bash```) which you can use to populate whichever bash_completion directories you please, and version-update the content accordingly. Who knows, maybe this could be incorporated into some of the ```get_app()``` function definitions, one day.?


## Storage

As seen in the [PRE-INSTALL] step earlier, WSL handily provides lots of ways to manage the storage of our virtual distros, including packing them as .tar files and importing them as dynamically-sized, mountable drives. 

We can fully leverage this in the spirit of a lightweight, portable development environment that can be easily backed up to external storage, re-initialized from a clean slate, duplicated, and converted and transferred between various storages and virtual hard drive formats.

Let's look at a few things we can do.


- option 1; Convert from ```docker export``` .tar-format distro named 'Ubuntu' to .vhdx-format distro named 'UBento', while storing a mountable backup (.vhdx) of 'Ubuntu' along the way;

```
> wsl --import Ubuntu "D:\Ubuntu" "C:\Users\<username>\ubuntu_minimal.tar"
> wsl --export Ubuntu "D:\Backup\Ubuntu_22_04_1_LTS.vhdx" --vhd
> wsl --unregister Ubuntu
> wsl --import UBento "D:\UBento" "D:\Backup\Ubuntu_22_04_1_LTS.vhdx" --vhd
```

Note that we imported Ubuntu from a ```.tar``` file, exported it into a resizeable ```.vhdx```, then re-imported that ```.vhdx``` under a new distro name.

So in fact, the ```wsl --export/unregister Ubuntu``` steps above are *optional* - you can keep *both* distros on your WSL simultaneously, if you like; simply point the ```wsl --import``` argument at *any* destination folder, followed by *any* Linux distro (stored in .tar or .vhd/x format), using whatever unique distro name you like (i.e., 'Ubuntu', 'UBento'...).


- option 2; Convert an ```ubuntu.tar``` backup file, to a mounted ```.vhdx``` containing distro named 'UBento', without storing a backup;

```
> wsl --import UBento "C:\my\install\folder" "C:\my\backup\folder\ubuntu.tar"
```

- option 3; Just import a ```.vhd/x``` from storage directly;

```
> wsl --import-in-place "C:\my\install\folder\ubuntu.vhdx"
```

- Docker desktop and data storage (including images) can be managed in the exact same way;

```
# Docker front-end storage...

> wsl --export docker-desktop "D:\Backup\Docker_desktop.vhdx" --vhd
> wsl --unregister docker-desktop
> wsl --import docker-desktop "D:\Docker" "D:\Backup\Docker_desktop.vhdx" --vhd


# Docker back-end storage...

> wsl --export docker-desktop-data "D:\Backup\Docker_desktop_data.vhdx" --vhd
> wsl --unregister docker-desktop-data
> wsl --import docker-desktop-data "D:\Docker\Data" "D:\Backup\Docker_desktop_data.vhdx" --vhd
```


- All of the above can also be run from another WSL distro's terminal (```$```) by creating an alias;

```
$ alias wsl='/mnt/c/Windows/System32/wsl.exe'

$ wsl --import Ubuntu "D:\Ubuntu" "C:\Users\<username>\ubuntu_minimal.tar"

# etc...
```

## Interoperability with Fonts and Wallpapers

Notice in the post-install steps the suggestion to use ```/etc/fonts/local.conf``` to import your Windows fonts (the entire function is provided in the steps). If you're interested in taking this further, take a look at the MS Store WSL Ubuntu's install folder - it ships with mutliple assets, such as several windows-friendly formats of the famous Ubuntu font, a Yaru-themed wallpaper, and several re-usable icons. The WSL Launcher distro's repo provides artwork templates in various shapes and sizes for shipment to the MS Store. Finally, you can actually get the entire Ubuntu font family - which includes a Windows Terminal-friendly 'monospace' version - from the Ubuntu website*, as well as from common sources such as Google Fonts. 

While these are probably superfluous touches, they do really highlight the interesting experience of different working environments *sharing* the resources on one machine in realtime. Personally, I am interested to see how far this can be further leveraged for the purposes of both reducing the linux-side storage footprint, while simultaneously extending the Windows desktop environment into new reaches.

*The official Ubuntu fonts are here - https://design.ubuntu.com/font/


## X-Server Display Authentication (WIP!)

https://en.wikipedia.org/wiki/X_Window_authorization

(tbc - this is a rough sketch of the idea...)

```
## Just in case...!
sudo apt install xauth iceauth resolvconf scp

## Add some Windows-side user environment variables (careful!)
$ cmd.exe /C setx BASH_ENV /etc/bash.bashrc
$ cmd.exe /C setx XAUTHORITY $XAUTHORITY
$ cmd.exe /C setx ICEAUTHORITY $ICEAUTHORITY
$ cmd.exe /C setx WSLENV BASH_ENV/up:ICEAUTHORITY/up:XAUTHORITY/up

## Set some easy, portable names...
$ export ICEAUTHORITY="$XDG_RUNTIME_DIR/ICEauthority"
$ export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

$ alias iceauth_lin='iceauth -f $ICEAUTHORITY'
$ alias xauth_lin='xauth -f $XAUTHORITY'

$ alias iceauth_win='wsl.exe --shell-type login -d ubento --system --user wslg --exec iceauth -f $ICEAUTHORITY'
$ alias xauth_win='wsl.exe --shell-type login -d ubento --system --user wslg --exec xauth -f $XAUTHORITY'

## Screen number
$ export DISPLAY_NUMBER="0"

## Auth key
$ export DISPLAY_TOKEN="$(cat '/etc/resolv.conf' | tr -d '\n\r' | md5sum | gawk '{print $1;}' )"

## Server address
$ export DISPLAY_ADDRESS="$(cat '/etc/resolv.conf' | grep nameserver | awk '{print $2; exit;}' )"

## Encrypted X session address
$ export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.$DISPLAY_TOKEN"

## Unencrypted X session address (if authentication fails, swap the above for this...)
# export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.0"

## GL rendering - worth experimenting with these two!
$ export LIBGL_ALWAYS_INDIRECT=1
$ export GDK_BACKEND=x11


$ auth_x()
{
    if [ -z "$DISPLAY" ]; then
        echo "Error: DISPLAY environment variable is not set."
    else

        echo "Display set to: $DISPLAY\n"
        # Will print your encrypted X address...

        echo " Windows X Server keys: \n" && xauth_win list
        echo " Linux X Server keys: \n" && xauth_lin list

        # Authorize key on Linux side and pass to Windows
        xauth_lin add $DISPLAY_ADDRESS:$DISPLAY_NUMBER . $DISPLAY_TOKEN
        xauth_win generate $DISPLAY_ADDRESS:$DISPLAY_NUMBER . trusted timeout 604800

        # Vice-versa...
        xauth_win add $DISPLAY_ADDRESS:$DISPLAY_NUMBER . $DISPLAY_TOKEN
        xauth_lin generate $DISPLAY_ADDRESS:$DISPLAY_NUMBER . trusted timeout 604800

        echo "Windows X Server keys:" && xauth_win list
        echo "Linux X Server keys:" && xauth_lin list

    fi

    # Notes;
    # WIP!!!
    # Useage of cp should be substituted for scp, possibly via SSH...?
}

```
Call the authentication function (this still needs some work - stay tuned!);

```
    auth_x
```


## Windows Terminal and launcher

It's easy to launch UBento from the excellent new Windows Terminal app, by simply creating a new profile named "UBento" and with the following command line invocation;

```
C:\WINDOWS\system32\wsl.exe -d UBento
```

Launching this profile should place you directly in your home folder as your user, which in turn will also call the initialization routines we have set up so far.

Going deeper, we could make a simple desktop-icon launcher that simply invokes our Windows Shell and runs the above command.... (possibly coming soon). Meanwhile, you're welcome to copy my UBento launcher settings (this Windows Terminal profile launches you directly into your user home directory, with the init steps taken care of) into your "Windows Terminal > Settings > Open JSON File" by adding the following;

```
{
    "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "profiles":
    {
        "list":
        [
            {
                "colorScheme": "StoneyDSP",
                "hidden": false,
                "icon": "C:\\Users\\{username}\\repos\\ubento\\ubento.png",
                "name": "UBento",
                "source": "Windows.Terminal.Wsl"
            }
        ]
    },
    "schemes":
    [
        {
            "background": "#300A24",
            "black": "#000000",
            "blue": "#0000CC",
            "brightBlack": "#444444",
            "brightBlue": "#0000FF",
            "brightCyan": "#00FFFF",
            "brightGreen": "#00FF00",
            "brightPurple": "#FF00FF",
            "brightRed": "#FF0000",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#FFFF00",
            "cursorColor": "#FFFFFF",
            "cyan": "#00CCCC",
            "foreground": "#FFFFFF",
            "green": "#00CC00",
            "name": "StoneyDSP",
            "purple": "#CC00CC",
            "red": "#CC0000",
            "selectionBackground": "#FFFFFF",
            "white": "#CCCCCC",
            "yellow": "#CCCC00"
        }
    ]
}
```

The profile's 'command line' option should be set to ```C:\WINDOWS\system32\wsl.exe -d UBento``` - you can also append ```--user {username}``` if you like.


## Accessing the underlying WSL2 Linux Kernel (CL Mariner Linux)

Microsoft's WSL2 is, functionally speaking, a re-branded custom Linux kernel that has been adapted to run as a shell environment natively on Windows drivers. This custom kernel is Microsoft's ArchLinux-based CL-Mariner Linux kernel, which can be found in their Git repos (will link shortly). This custom kernel (which runs natively on Windows) mounts your chosen Linux distro (in it's own ```/mnt``` folder) and provides it's Windows-friendly systemd and GUI libraries to your distro, acting as a kind of bridge between both environments, and thus allowing your chosen Linux distro to "pipe" it's data to and from your Windows OS environment. The actual kernel used to do this can in fact be customized/changed by use of the Windows'side ```C:\Users\{username}\.wslconfig``` file. It is quite useful to note that you can in fact use a Windows command-line argument to login to your WSL2 distro as one of two "system"-level users, which will actually log you in to the Microsoft ArchLinux-based CL-Mariner kernel, which is the very heart of your WSL install - here, I present a series of commands to log in to CL-Mariner as the 'root' user, obtain the ```sudo``` package, and then proceed as the default-user (pre-named 'WSLg') with full sudo/yum package manager access;

```
# The '--system' flag accesses the underlying kernel as '--user root';
> wsl --distro ubento --system --user root

# The above should have you logged in as a root user with a red-colored prompt for the below;
$ no | yum update
$ yum install sudo
$ sudo passwd WSLg
# create and confirm a desired password for user 'wslg', can be anything... I've no idea what the default is set to!
$ usermod --group=adm,dialout,cdrom,floppy,tape,sudo,audio,dip,video wslg
$ login wslg
# Enter the password you had just created to log in as user 'wslg' - you should now have a green-colored prompt;
$ sudo yum update
$ sudo yum upgrade -y
$ sudo yum install nano vim
# etc... in fact, don't forget to check the '/etc' folder, as well as the two user directories, for some interesting bashscripts :) 
```

Now, while still logged in with the '--system' flag, take a look here;

```
$ cd /mnt/wslg/runtime-dir
$ ls -la
```

Take note of the contents, such as the wayland and pulseaudio stuff...

Once you log out of '--system' and back in to your distro as per normal, do this;

```
$ cd $XDG_RUNTIME_DIR
$ ls -la
```

It turns out to be the same folder, right? It seems the runtime directory itself is something of a symlink, or portal, between your running distro, and the underlying CL-Mariner kernel.

Launch a few keyrings and services, then check the contents again...

```
$ sudo service dbus start
$ /usr/libexec/at-spi-bus-launcher --launch-immediately --a11y=1 &
$ google-chrome 2>/dev/null &
$ code $HOME
$ ls -la $XDG_RUNTIME_DIR
```

Since this particular location (as found at $XDG_RUNTIME_DIR) is accessible on both the Windows *and* Linux sides, it seems to be a perfect candidate for storing shared cookies, socket connections, and other temp runtime data. 

You should note that this underlying kernel is re-formatted every time it is cold-booted (that is, all previous WSL sessions closed, then launching a new session). Any changes you make here do not persist once WSL goes offline, such as with ```wsl --shutdown```. Without further testing, I believe this has something to do with a persistent system variable that is hard-wired to the WSL2 distro-launcher's command line (something like "WSL_ROOT_INIT=1"...), and that it may be possible to control or influence the bahviour of this variable; as to what end, I'm not particularly sure. You can actually clone the latest build of MS's CL-Mariner kernel from their Git repo, along with instructions on how to build it from source (plus the usage instructions found in the '.wslconfig' documentation). They do also provide some encouragement for user to 'tinker' with the kernel to their own ends. 


## Customisation and tailoring your build to focus only on your needs

- A lot of the latest Linux releases of popular coding tools, like NodeJs and CMake, don't have any additional package dependencies in order to be installed and used. WSL-integrated Windows apps like VSCode and Docker Desktop also "just work" straight from the box. Dependencies aside, most Linux GUI apps will happily launch from their Windows icons - or bash shell commands - without any additional self-configuring of, or even launching of, the X-Server. The requirements to run a full visual desktop environment are where the majority of the costs lie; and with otherwise such low runtime integration requirements and portability, the benefits of having a secondary visual desktop environment *on your native visual desktop environment* don't necessarily outweight the performance costs when you really need it most, IME. If your main interest is in getting critical work done, you likely don't need much more than to ```unminimize``` and add a few packages to the keyring, if that. But if what you want is to have a deep and performant Linux experience integrated directly within your Windows environment, you can have that too.

- You can choose not to ```unminimize``` if you want your distro to be as compact as possible (for CI/Docker runs, for example). As of writing, this command will less-than-double the size of the install on disk; Without it, however, there are a large amount of quite low-level symlinks and base libraries missing - though you can still build all the way up to the full equivalent environment of the MS Store version, one package dependency cycle at a time. But if you're skipping it, your bash and apt command line responses might seem quite strange and present you with unfamiliar prompts and errors. While these are often just harmless indicators - especially in short-term runs - you will probably want to accomodate some of their requests and ignore others. Always good test your distro setup with a few manual run-throughs on the terminal!

- Systemd-dependent services and apps are a big investment beyond the original minimized state of the distro, but are often key to having a stable, more robust (certainly mid/long-term) working environment. My suggestion is to avoid systemd for CI/Docker runs, and embrace it for desktop and GUI stuff; same goes for ```unminimize```.

- Name your distro's host server. It's a good idea to use 'localhost' or at least something different to your Windows Machine ID as your WSL distro's hostname (this is set in ```/etc/wsl.conf```). The unfortunate current default is to simply copy the Win MachineID over to WSL userland. I personally like "localclient" for my Windows machine, and "localhost" for my WSL distro - this is a nice distinction when you are presented with network addresses that point to either 'localclient' or 'localhost'. When launching Node apps, for example, you can view them in your "localclient"'s browser (i.e., your net browser for Windows) and differentiate the network addresses your code backend provides from "localhost", for example. This is also very useful when configuring the X-server, especially, where keys might be exchanged both ways.


## Git tip from microsoft WSL docs

When handling a single repo on both your Windows and Linux file systems, it's a good idea to weary of line endings. Microsoft suggests adding a ```.gitattributes``` to the repo's root folder with the following, to ensure that no script files are corrupted;

```
* text=auto eol=lf
*.{cmd,[cC][mM][dD]} text eol=crlf
*.{bat,[bB][aA][tT]} text eol=crlf
```


## Make yourself a local-storage "~/Development" directory, and do cool stuff in there

```
$ mkdir "$HOME/Development"
$ export DEV_DIR="$HOME/Development"
$ cd "$DEV_DIR"

$ git clone git@github.com:StoneyDSP/ubento.git

# If you're cd-'ing around between NodeJs-based repo's, consider checking out nvm-sh's 'cd_nvm' function :)
```


## Shutting down

Note that if you choose not to ```unminimize``` your distro, not install systemd, or otherwise have no real shutdown strategy in your distro, you can always

```
$ alias shutdown="wsl.exe -d <myDistro> --shutdown && logout"
```

then

```
$ shutdown
```


## [REFERENCES AND SOURCES]

## Microsoft WSL docs

- https://learn.microsoft.com/en-us/windows/wsl/


## Docker Desktop for Win/WSL2 docs

- https://docs.docker.com/desktop/windows/wsl/


## Microsoft VSCode WSl & Remote Development Extension docs

- https://code.visualstudio.com/docs/remote/troubleshooting#_wsl-tips
- https://code.visualstudio.com/docs/remote/wsl
- https://learn.microsoft.com/en-us/cpp/build/walkthrough-build-debug-wsl2?view=msvc-170


## X410 cookbook

- https://x410.dev/cookbook/wsl/running-ubuntu-desktop-in-wsl2/


## SO thread about X server encryption

- https://stackoverflow.com/questions/61110603/how-to-set-up-working-x11-forwarding-on-wsl2?noredirect=1&lq=1


## Sharing environment variables between Windows and Linux;

- https://devblogs.microsoft.com/commandline/share-environment-vars-between-wsl-and-windows/
- https://superuser.com/questions/1745166/verify-that-config-value-applied-in-wsl


## Package keys;

- Please see respective repos on GH, and study the "get key" routine as found here and elsewhere;
- https://apt.kitware.com/
