# UBento
Minimal Ubuntu-based WSL distro front-end, ideal for targeting Linux-style NodeJs and CMake development environments from Windows platforms.

Quick usage (see 'requirements');

```
> docker run -it ubuntu bash ls /
> docker export -o "/mnt/c/Users/{$username}/ubuntu.tar"  <distronumber>
> wsl --import UBento "C:\Users\{$username}" "C:\Users\{$username}\ubuntu.tar"
> wsl -d Ubento
# swap bash env, profile, and WSL files and reboot the distro - done!
```

## About

The WSL Ubuntu distro that is available from the MS Store is initialized via a snap called "install RELEASE", and also comes bundled with a rather hefty APT package suite called ```ubuntu-wsl```. The MS Store Linux distros are also generally bundled with the "WSL2 Distro Launcher", which provides for example the 'Ubuntu.exe' on the Windows-side. This is a nice interoperability, but particularly the snap requirements are quite costly in both storage and performance. 

The MS Store Ubuntu distro also contains quite a large stash of Bash completion helpers and scripts, covering many packages and libraries that are not actually to be found on the base install but which are still updated regularly at source (e.g., CMake), and the standard APT keyring which holds many outdated packages (e.g., NodeJs v.12...?), yet does not provide other common developer packages (e.g., Yarn) by default.

Instead, we can pull Ubuntu-Minimal - Approx. 74mb - from a Docker container image, and launch that in WSL directly. Ubuntu-Minimal also has the ```unminimize``` command which rehydrates the install into the full server version of Ubuntu; from there, we can build a much more streamlined Ubuntu with fewer runtime dependencies and practically no Linux-side background service requirements of it's own (compare by running ```service --status-all```) and tailor the environment towards a full-powered development environment with full GUI/desktop support via an encrypted Windows X-Server, *and* with a much reduced storage footprint, a fully up-to-date package registry, and - in many cases, - highly improved runtime performances.


## Customisation and tailoring your build to focus only on your needs

A lot of the latest Linux releases of popular coding tools, like NodeJs and CMake, don't have any additional package dependencies in order to be installed and used. WSL-integrated Windows apps like VSCode and Docker Desktop also "just work" straight from the box. Dependencies aside, most Linux GUI apps will happily launch from their Windows icons - or bash shell commands - without any additional self-configuring of, or even launching of, the X-Server. The requirements to run a full visual desktop environment are where the majority of the costs lie; and with otherwise such low runtime integration requirements and portability, the benefits of having a secondary visual desktop environment *on your native visual desktop environment* don't necessarily outweight the performance costs when you really need it most, IME. If your main interest is in getting critical work done, you likely don't need much more than to ```unminimize``` and add a few packages to the keyring, if that. But if what you want is to have a deep and performant Linux experience integrated directly within your Windows environment, you can have that too.

This will hopefully all get compiled into some sort of an interactive bash script... if time permits. Meanwhile, you can check the files provided here in the repo to get the idea - copying these simple bash scripts into the Ubuntu-Minimal docker distro and installing/running a few standard packages is all that is required to achieve the above goals of UBento.

![UBento-icon](https://github.com/StoneyDSP/ubento/blob/4da549bafe71e969ec072987a8b561eb3eb2a5ec/ubento.png)

## System Requirements:

- Windows 11 22h2 or greater
- WSL2 (Windows Subsystem for Linux), optionally with a working Linux kernel/distro
- Docker Desktop for Windows using the WSL2 backend, used for obtaining and running developer environment images

## Optional:

- VSCode with Remote Development Extensions, used for editing your code hosted on the WSL2 backend
- X-Server for Windows such as VcXsrv or X410 for GUI/desktop support if desired

## Todo:

- Finish X-Server encryption helper function
- Use the shared ```$WSLENV``` variable to optionally link the distro userspace, to the Windows userspace
- Try ```$WSLENV``` for sharing a single, translatable path to an '.Xauthority' key between both userspaces (this works for SSH keys and symlinks...)
- Investigate usage of user-login password as an MIT-encrypted env variable (like ```{{ git.SECRET }}``` ) for use with Git control, intializing DBus with as sudo during startup routine, authenticating the X-Server encryption layer step, and so on 
- Implement as a shell-scripted front-end for a fast, flexible, potentially CI-capable* Ubuntu-Minimal deployment 
 
*where the ```unminimize``` command and other rehydrations can be averted from use cases. 


## Notes:

- Run the suggested instructions in either your Windows Powershell (```>```), or your current WSL2 distro's terminal (```$```), but obviously don't bother entering the comment lines (```#```). Make sure to fill in the blanks where ```<variables>``` are concerned.

- You can choose not to ```unminimize``` if you want your distro to be as compact as possible (for CI/Docker runs, for example). As of writing, this command will roughly double the size of the install on disk; Without it, however, there are a large amount of quite low-level symlinks and base libraries missing - though you can still build all the way up to the full equivalent environment of the MS Store version, one package dependency cycle at a time. But if you're skipping it, your bash and apt command line responses might seem quite strange and present you with unfamiliar prompts and errors. While these are often just harmless indicators - especially in short-term runs - you will probably want to accomodate some of their requests and ignore others. Always good test your distro setup with a few manual run-throughs on the terminal!

- Systemd-dependent services and apps are a big investment beyond the original minimized state of the distro, but are often key to having a stable, more robust (certainly mid/long-term) working environment. My suggestion is to avoid systemd for CI/Docker runs, and embrace it for desktop and GUI stuff; same goes for ```unminimize```. 

- Neither ```unminimize``` nor systemd are really required for most developing purposes - see [TIPS]. 

- Name your distro's host server. It's a good idea to use 'localhost' or at least something different to your Windows Machine ID as your WSL distro's hostname (this is set in ```/etc/wsl.conf```). The unfortunate current default is to simply copy the Win MachineID over to WSL userland. I personally like "localclient" for my Windows machine, and "localhost" for my WSL distro - this is a nice distinction when you are presented with network addresses that point to either 'localclient' or 'localhost'. When launching Node apps, for example, you can view them in your "localclient"'s browser (i.e., your net browser for Windows) and differentiate the network addresses your code backend provides from "localhost", for example. This is also very useful when configuring the X-server, especially, where keys might be exchanged both ways.

- Check the [TIPS] and [TROUBLESHOOTING] sections for helpful insights.

- Try it with other Linux flavours and goals.


To get started, run the below in either your Windows Powershell (```>```);


## [PRE-INSTALL]


Pull Ubuntu-Minimal from Docker image into .tar (Approx. 74mb)

```
> docker run -it ubuntu bash ls /
```

Take a note of the container ID of the Ubuntu image that was just running, then export it to some handy Windows location, using the .tar extension (WSL can then import it directly), as follows;

```
> docker container ls -a
> docker export -o "C:\Users\<username>\ubuntu_minimal.tar" "<UbuntuContainerID>"
```

We then have a few options for how we wish to store UBento, such as using the dynamic virtual hard drive (.vhd or .vhdx) format, and backing up and/or running from external storage drives. The ```--export``` command in the below example stores a backup mountable image in the 'D:\' drive (which can be a smart card or USB memory, etc), but you may of course place the files anywhere you like (see [TIPS] for more storage examples).

```
> wsl --import UBento "C:\My\Install\Folder" "C:\Users\<username>\ubuntu_minimal.tar"
    
> wsl --export UBento "D:\My\Backup\Folder\ubento.vhdx" --vhd
```

## Backing up and restarting with a clean slate;


It turns out to be handy to run the following argument around this stage, or whenever you feel you have a good starting point; 

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


- set permission for root folder, restore server packages, and install basic dependencies;

```
$ chmod 755 /
$ apt update && apt install apt-utils dialog

# If you need superuser accesses...
$ apt install sudo && sudo -s
      
# If you wish to 'rehydrate' from Ubuntu Minimal to Ubuntu Server...
$ yes | unminimize

# Choose which base packages you need, I suggest these something like these...
$ apt install less manpages nano vim gawk grep bash-completion bash-doc git curl wget libreadline8 readline-common readline-doc resolvconf gnu-standards xdg-user-dirs openssl ca-certificates lsb-release xauth

# Clear the APT cache if you like...
$ rm -rf /var/lib/apt/lists/*
```

## [SETUP FILES]

(tbc - could just place a bash script and use curl/wget/git to fetch everything...)

```
# Git-clone UBento somewhere locally... you could store it Linux-side
# directory, such as '$HOME/Development/ubento' and adjust this step
# accordingly. See the [TIPS] and [DEVTOOLS KEYRING] sections for ideas. 
# Here's an example where we've git cloned it to our Windows home folder;

$ export UBENTO_WIN_REPO="/mnt/c/Users/${USER}/repos/ubento"

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
# ...and so forth (will script this at some point!)

# *optional, see final post-install step (this file MUST contain your username in the correct field before we reboot!)
$ yes | cp -f "$UBENTO_WIN_REPO/etc/wsl.conf" "/etc/wsl.conf"
```

## [CREATE USER] 

- named "username" (could use ```$WSLENV``` to pull your Win user name here - stay tuned) with the required UID of '1000'. You will be prompted to create a secure login password for your new user;

```
$ export username="<Your Username Name>"
$ export fullname="<Your Full Name>"

$ adduser --home=/home/"${username}" --shell=/bin/bash --gecos="${fullname}" --uid=1000 "${username}"

$ usermod --group=adm,dialout,cdrom,floppy,tape,sudo,audio,dip,video,plugdev "${username}"
```

- Modify ```/etc/wsl.conf``` to export our 'username@localhost' and expose default wsl settings, mount the windows drive in ```/mnt```, and set the required OS interoperabilities*;

```
$ echo -e "[network]\n hostname=localhost\n" >> /etc/wsl.conf
$ echo -e "[user]\n default=${username}\n" >> /etc/wsl.conf
```

*The purpose of this last step is so that the ```[user] default=``` section of your ```/etc/wsl.conf``` contains your username, to ensure we boot into this profile later on our next launch... see next step)


Back in Powershell (```>```), we can now login as our new user (the ```--user``` argument here shouldn't be necessary due to the 'default user' setting in ```/etc/wsl.conf```, but it doesn't hurt to be sure here on this first re-launch, as this *ensures* we run finish critical initialization procedure correctly!)

```
> wsl -d UBento --shutdown
> wsl -d UBento --user "${username}"
```

## [INTEROPERABILITY]

- Test docker interoperability; (IMPORTANT - do not run this step until AFTER creating your user with UID 1000, otherwise Docker tries to steal this UID!);

```
# make sure the 'UBento' option is checked in Windows Docker Desktop settings > resources for this to work

$ docker run hello-world
$ docker run -it ubuntu bash
```

- We can set Linux-side aliases to our Windows executables in ```/etc/profile.d/bash_aliases.sh``` like this;

```
alias wsl='/mnt/c/Windows/System32/wsl.exe'

wsl --list --verbose
# Will list all of WSL's installed distros and statuses

alias notepad='/mnt/c/Windows/System32/notepad.exe'

notepad .
# Will launch Notepad - careful with those line ending settings!
```

    
- Don't forget to test out VSCode with the Remote Development extension, of course... Just make sure that you DON'T have VSCode installed on the Linux side;

```
cd $HOME
code .

# Will run an installation step for 'vscode-server-remote' on first run....
# Also check the 'extensions' tab for many WSL-based versions of your favourite extensions :)
```


From now on, you can use ```sudo``` invocations from your new user login shell, and will also have access to useful system commands like ```sudo apt update && sudo apt ugrade```. You can also adapt the above command for launching a Windows Terminal profile, for example (see [TIPS]).

## At this point, the distro remains minimal yet fully scalable, GUI apps and Windows integration should be working, and UBento is well-configured to continue on as you please...

...but, the idea with UBento is take some minimal steps to greatly enhance the experience where possible. We can choose to tailor our UBento towards either/both a fully-configured desktop environment, and/or a fully-configured development environment; the scripts below are presented as suggestions, largely based on exposed defaults that can be found on actual Linux desktop machines made portable - and, with small tweaks to further explore some of the more useful, powerful, and interesting desktop interoperability opportunities that an otherwise feather-weight WSL/Ubuntu-Minimal distro can provide.

![UBento-icon](https://github.com/StoneyDSP/ubento/blob/4da549bafe71e969ec072987a8b561eb3eb2a5ec/ubento.png)


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
``` 

The directories indicated in all of the above *should* exist in some form, for a working desktop. One excellent touch is to leverage Linux symbolic links to share your user folders between Windows and Linux environments (option 1), or we can create ourselves an alternative userspace by not going outside the distro (option 2).

By providing symbolic links to our Windows user folders, we can get some huge benefits such as a shared "Downloads" folder and a fully "Public"-ly shared folder. Thus, you can download a file in your Windows internet browser, and instantly access it from your WSL user's downloads folder (which is the exact same file address), for example. However, there is some risk in mixing certain file types between Windows and WSL - there are several articles on the web on the subject (to be linked) which you should probably read before proceeding with either, or a mix, of the following;


## option 1 - linked storage; symlink your Windows and UBento user folders with these commands (change the respective usernames if yours don't match);

```
# Logged in as user, NOT root(!);
$ ln -s "/mnt/c/Users/${username}/Desktop"    "/home/${username}/Desktop"   && \
ln -s "/mnt/c/Users/${username}/Documents"    "/home/${username}/Documents" && \
ln -s "/mnt/c/Users/${username}/Downloads"    "/home/${username}/Downloads" && \
ln -s "/mnt/c/Users/${username}/Music"        "/home/${username}/Music"     && \
ln -s "/mnt/c/Users/${username}/Pictures"     "/home/${username}/Pictures"  && \
ln -s "/mnt/c/Users/${username}/Templates"    "/home/${username}/Templates" && \
ln -s "/mnt/c/Users/${username}/Videos"       "/home/${username}/Videos"

# optional - logged in as root;
$ ln -s "/mnt/c/Users/Administrator/Desktop" "/root/Desktop"
...
$ ln -s "/mnt/c/Users/Administrator/Videos" "/root/Videos"
    
# optional - 'public' shared folder...
$ ln -s "/mnt/c/Users/Public" "/home/${username}/Public"
$ ln -s "/mnt/c/Users/Public" "/root/Public"
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

```
# Run this once as the user, then once as root...
      
$ mkdir \
$HOME/Desktop \
$HOME/Documents \
$HOME/Downloads \
$HOME/Music \
$HOME/Pictures \
$HOME/Templates \
$HOME/Videos
```

With this option, no linkage is created to your Windows user folders or hard disk; all storage remains local to your distro's portable vhd.


We're using ```$HOME/.config``` as our desktop configuration folder (you may have to ```mkdir $HOME/.config``` if it's not already present). There are some useful things we should set up in here.


## We can set bookmark tabs for our chosen Linux-side desktop explorer;

```
nano $HOME/.config/gtk-3.0/bookmarks
```

add the following:

```
file:///home/${USER}/Desktop
file:///home/${USER}/Documents
file:///home/${USER}/Downloads
file:///home/${USER}/Music
file:///home/${$USER}/Pictures
file:///home/${USER}/Videos
```

These locations will now appear in the tab bar of your Linux-side desktop explorer, as they should.

## We can also connect our Linux-side desktop explorer to remote servers;

```
nano $HOME/.config/gtk-3.0/servers
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


## Import your Windows fonts by adding the below to ```/etc/fonts```;

```
sudo nano /etc/fonts/local.conf
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


## [DEVTOOLS KEYRING]

Requires some of the basic packages from earlier, such as wget/curl/git.

*NOTE: These bash functions are already pre-defined in the root user's ```~/.bashrc.d/bash_keyring.sh```, which is accessed by called ```sudo -s``` (to enter a shell as the root user with sudo privileges), then just entering the name of the function, such as ```get_node```. Back in your user-space you then just ```sudo apt install nodejs``` to install the latest release, per the function definition. These are reproduced here in altered form for convenience and testing. This convention is just an "average", based on the APT-key instructions provided by each vendor, which all vary slightly but more or less follow the below formula (get key, add to lst, update cache).*

```
$ export DISTRO="$(lsb_release -cs)"
$ export ARCH="$(dpkg --print-architecture)"
$ export APT_SOURCES="/etc/apt/sources.list.d"

$ alias apt_cln='rm -rf /var/lib/apt/lists/*'

$ get_chrome()
{
    curl "https://dl.google.com/linux/direct/google-chrome-stable_current_$ARCH.deb" -o "$XDG_DOWNLOAD_DIR/chrome.deb"

    apt install "$XDG_DOWNLOAD_DIR/chrome.deb"
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
$ apt install gh

# * *Note that if you have w3m installed by now, the gh CLI can actually open and display the GitHub webpage in ASCII format, directly in the Linux terminal, if it must ;)*
```

Following the above, you can ```exit``` back to your user account, then 

```
$ export PUBKEYPATH="$HOME\.ssh\id_ed25519.pub"

$ alias g="git"

$ g -g config user.name "<Your Git Name>"
$ g -g config user.email "<Your Git Email>"

$ gh auth login
# Choose .ssh option... then;

$ nano $HOME/.gitconfig
```

Your Git SSH key credentials can now managed by the GitHub CLI client, and the GitHub CLI commands and credential manager tools are available to use, along with the regular Git and SSH commands. You can now invoke your SSH key (available at ```$PUBKEYPATH```) with an expanded set of Git-based commands using SSH encryption;

```
$ export DEV_DIR="$HOME/Development"

$ g clone git@github.com:StoneyDSP/ubento.git "$DEV_DIR/UBento"

# Or....

$ gh repo clone git@github.com:StoneyDSP/ubento.git "$DEV_DIR/UBento"
```

Here are some other common tools for development - again, do ```sudo -s``` first (if you are running these commands directly from this README.md file);


- Node (latest)
    
      export DISTRO="$(lsb_release -cs)"
      export ARCH="$(dpkg --print-architecture)"
      export APT_SOURCES="/etc/apt/sources.list.d"
      
      export SYS_NODE_V="node_19.x"
      
      get_node()
      {
          export NODEJS_KEY="/usr/share/keyrings/nodesource.gpg"

          curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee $NODEJS_KEY >/dev/null

          echo "deb [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/$SYS_NODE_V $DISTRO main" | tee $APT_SOURCES/nodesource.list

          echo "deb-src [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/$SYS_NODE_V $DISTRO main" | tee -a $APT_SOURCES/nodesource.list

          apt update
      }
    
      apt install nodejs

      npm --global install npm@latest


- Yarn (latest)
    
      export ARCH="$(dpkg --print-architecture)"
      export APT_SOURCES="/etc/apt/sources.list.d"

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
    
      export DISTRO="$(lsb_release -cs)"
      export APT_SOURCES="/etc/apt/sources.list.d"
      
      get_pgadmin()
      {
          export PGADMIN_KEY="/usr/share/keyrings/packages-pgadmin-org.gpg"
        
          curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor -o $PGADMIN_KEY

          echo "deb [signed-by=$PGADMIN_KEY] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$DISTRO pgadmin4 main" > $APT_SOURCES/pgadmin4.list

          apt update
      }
      
      # Might be needed - make sure to generate the bash completion scripts!
      apt install postgresql postgresql-contrib apache2 apache2-doc
    
      # Install for both desktop and web modes:
      apt install pgadmin4

      # Install for desktop mode only:
      # apt install pgadmin4-desktop

      # Install for web mode only:
      # apt install pgadmin4-web

      # Configure the webserver, if you installed pgadmin4-web:
      /usr/pgadmin4/bin/setup-web.sh
      
      # Postgres also has some well-used bash completion scripts such as 'createdb'.
      # We can give our user(s) the correct priviliges to access these commands.
      
      # create a password, for example 'postgres'...
      passwd postgres 
      
      # enter psql shell as user 'postgres'...
      psql -u postgres 
      
      # in the psql shell, list our users, create two more, and list again before exiting...
      \du
      CREATE ROLE root CREATEDB CREATEROLE SUPERUSER; 
      CREATE ROLE {username} CREATEDB CREATEROLE SUPERUSER;
      \du
      \q
      
      # Now your user can use the full PostgresQL (and PGAdmin) tools on the CL... without invoking 'sudo'.


- CMake (you should have Make and/or other build tools, and check out Visual Studio with WSL - you can now use MSBuild tools on Linux-side code!)
    
      export DISTRO="$(lsb_release -cs)"
      export ARCH="$(dpkg --print-architecture)"
      export APT_SOURCES="/etc/apt/sources.list.d"
      
      get_cmake()
      {
          export KITWARE_KEY="/usr/share/keyrings/kitware-archive-keyring.gpg"
        
          wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee $KITWARE_KEY >/dev/null

          echo "deb [arch=$ARCH signed-by=$KITWARE_KEY] https://apt.kitware.com/ubuntu $DISTRO main" | tee $APT_SOURCES/kitware.list

          apt update
      }
    
      apt install kitware-archive-keyring cmake cmake-data cmake-doc ninja-build


- Google Chrome (latest stable)
    
      export ARCH="$(dpkg --print-architecture)"
      
      get_chrome()
      {
          curl "https://dl.google.com/linux/direct/google-chrome-stable_current_$ARCH.deb" -o "$XDG_DOWNLOAD_DIR/chrome.deb"

          apt install "$XDG_DOWNLOAD_DIR/chrome.deb"
      }


- Supabase (check repo for latest release version number, these outdate quickly...)
    
      export ARCH="$(dpkg --print-architecture)"
      
      export SYS_SUPABASE_V="1.27.0"
      
      get_supabase()
      {
          curl "https://github.com/supabase/cli/releases/download/v$SYS_SUPABASE_V/supabase_$SYS_SUPABASE_V_linux_$ARCH.deb" -o "$XDG_DOWNLOAD_DIR/supabase.deb"

          apt install "$XDG_DOWNLOAD_DIR/supabase_$SYS_SUPABASE_V_linux_$ARCH.deb"
      }
      
      # as user...
      supabase login


- Node Version Manager (note that it will install into ```$XDG_CONFIG_DIR```, so ```$HOME/.config/nvm```) 
    
      get_nvm()
      {
          curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh" | bash
      }
      
      # Choose as preferred...
      
      # nvm install --lts
      # nvm install node
      nvm use system


- Postman (will save your login key to your home folder)
    
      get_postman()
      {
          curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | bash
      }
      
      # as user...
      postman login


- vcpkg-tool (still working on this, note that you can get vcpkg itself quite easily too)
    
      get_vcpkg_tool()
      {
          . <(curl https://aka.ms/vcpkg-init.sh -L)

          . ~/.vcpkg/vcpkg-init
      }


## [DEFINING RUNTIME BEHAVIOUR]

This step need not apply if you are happy running Linux GUI apps (with excellent performance) but aren't looking to explore the desktop capabilities of your distro. GUI apps will already be working smoothly at this stage, directly from their Windows launchers. But if you're doing anything that requires systemd to be installed, then it is quite important provide some control over certain system-level runtime behaviours; particularly, for our user's first launch into systemd.

```
$ echo -e "[boot]\n systemd=true\n" >> /etc/wsl.conf
```

Make sure the following two functions from the x410 cookbook are defined in ```/etc/profile.d/ubento_helpers.sh``` and are present/called in ```$HOME/.profile``` for user, but *NOT* for root (IMPORTANT!) - they should be at the end after the exports;

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

## It is *CRITICAL* during systemd configuration that of the previous steps, the following (as a minimum) are taken in the correct order, as summarized; 

- launch distro as root to install apt-utils, dialog, and sudo
- copy ubuntu-helpers/profile/bashrc/wsl.conf files
- add new user and password
- install systemd/dbus/at-spi2-core
- shutdown distro and reboot as new user


*this sequence ensures that when the distro default user account is finally accessed, it has the UID of 1000 assigned, and calls the ```set_runtime_dir``` and ```set_session_bus``` functions from the X410 cookbook using this UID during initialization. This sequence creates a runtime directory at ```/run/user/1000``` during initialization where the dbus-daemon (and accessibility bus) is started from, and this runtime location is maintained/used when opening further sessions using this same distro. It is also critical that the root user does NOT have access to these functions (they should not be present at all in ```/root/.profile```).


## [X-SERVER DISPLAY]

https://en.wikipedia.org/wiki/X_Window_authorization

(tbc - this is a rough sketch of the idea...)

    sudo apt install xauth resolveconf scp
    # Just in case...!
    
    # Set some easy names...
    alias vcxsrv="/mnt/c/'Program Files'/VcXsrv/vcxsrv.exe &"
    alias xlaunch="/mnt/c/'Program Files'/VcXsrv/xlaunch.exe &"
    alias xauth_win="/mnt/c/'Program Files'/VcXsrv/xauth.exe -f C://Users//${username}//.Xauthority"
    alias xauth_lin="xauth"

    sudo_autopasswd()
    {
        echo "<your_user_password>" | sudo -Svp ""
        # Default timeout for caching your sudo password: 15 minutes
        
        # TBC: I'd like to find a way to capture our password using an 
        # ecryption routine here to store our pwd into some kind of cookie file for 
        # local re-use (xauth?)
    }

    # Screen number
    export DISPLAY_NUMBER="0" 
    
    # Auth key
    export DISPLAY_TOKEN="$(echo '{sudo_autopasswd}' | tr -d '\n\r' | md5sum | gawk '{print $1;}' )" 
    
    # Server address
    export DISPLAY_ADDRESS="$(cat '/etc/resolv.conf' | grep nameserver | awk '{print $2; exit;}' )" 
    
    # Encrypted X session address
    export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.$DISPLAY_TOKEN"
    
    # Unencrypted X session address (if authentication fails, swap the above for this...)
    # export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.0"

    #GL rendering
    export LIBGL_ALWAYS_INDIRECT=1
    

    auth_x()
    {
        if [ -z "$DISPLAY" ]; then
            echo "Error: DISPLAY environment variable is not set."
        else
        
            echo "$DISPLAY" 
            # Will print your encrypted X address...

            vcxsrv
            # Will launch your X-Server Windows executable...

            echo "Linux X Server keys:" && xauth_lin list

            echo "Windows X Server keys:" && xauth_win list

            # Authorize key on Linux side and pass to Windows
            xauth_lin add $DISPLAY_ADDRESS:$DISPLAY_NUMBER . $DISPLAY_TOKEN

            cp -f "$HOME/.Xauthority" "/mnt/c/Users/{username}/.Xauthority"

            xauth_win generate $DISPLAY_ADDRESS:$DISPLAY_NUMBER . trusted timeout 604800


            # Vice-versa...
            xauth_win add $DISPLAY_ADDRESS:$DISPLAY_NUMBER . $DISPLAY_TOKEN

            cp -f "/mnt/c/Users/{username}/.Xauthority" "$HOME/.Xauthority"

            xauth_lin generate $DISPLAY_ADDRESS:$DISPLAY_NUMBER . trusted timeout 604800


            # For backup/restoration...
            cp -f "$HOME/.Xauthority" "$HOME/.config/.Xauthority"


            echo "Linux X Server keys:" && xauth_lin list

            echo "Windows X Server keys:" && xauth_win list
        
        fi
        
        # Notes;
        # Useage of cp should be substituted for scp, possibly via SSH...?
        # "/mnt/c/Users/{username}/.Xauthority" = "C:\Users\{username}\.Xauthority"
        # - Could be a WSLENV translatable path? Or even a symlink to a Windows-side file?
        # Hmmm, what's this "XAUTHORITY" variable about...?
        # Furthermore, would be ideal to store cookie in $XDG_RUNTIME_DIR!
    }
    
Call the authentication function (this still needs some work - stay tuned!);

    auth_x


## [TROUBLESHOOTING]

## Enabling Hyper-V, Virtual Machine Platform, and WSL on Windows.

- Get the required packages (save as "HyperV.bat" and launch in PowerShell):

      pushd "%~dp0"

      dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hv.txt

      for /f %%i in ('findstr /i . hv.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"

      Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL

      pause

Restart your Windows machine once the above is complete.


- Enable the Windows features (run each command in PowerShell):


Virtual Machine Platform;

      dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart


Hyper Virtualization;

      dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V /all /limitaccess /all /norestart


Windows Subsystem for Linux;

      dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart


Restart your Windows machine once the above is complete.


## Storage considerations


Think very carefully about how/where you choose to store your runtime distro on disk, and linkages between environments - particularly the user desktop, downloads, documents folders, and other regularly accessed locations. It is generally safe to have access to your Windows-side file system via the Linux-side ```/mnt``` directory *and* to use symbolic links from Linux-side (user's "download" folders, etc) to the Windows environment. However, based on some experience, I would recommend *against* combining this with running your distro from a removable storage drive, like USB or SD card. While the mounting/linkage practices are both quite safe enough to be default behaviour in WSL, *and* it mounts and runs just fine from external storage which I happily depend upon daily, you could be running some risk when attempting to write to your Windows file system from the Linux-side and experiencing a hardware failure, such as a cat chewing on your USB stick and causing some file-corruption. Desktop linkage is really cool, as is external storage - but I'd have to recommend not to mix the two, in the case of WSL.


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


## [TIPS]


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

Many, perhaps most, modern CLI applications also ship with completion scripts. Though these scripts aren't as prone to frequent updates as the applications themeselves are, there can still be large delays between a vendor's latest stable release version, and the corresponding version bound to APT's default keyring. On top of this, the WSL Ubuntu build in the MS Store also ships with quite a variety of bash completion scripts, split between several different directories (```/etc/bash_completion.d``` and ```/usr/share/bash_completion```), which correspond to the application versions... which are bound to APT's default keyring. Thus, if you're binding the latest APT keys as suggested in the [DEVTOOLS KEYRING] section to install latest sotware versions, then you can usually find a 'completion' command (eg ```supabase completion bash```) which you can use to populate whichever bash_completion directories you please, and version-update the content accordingly. Who knows, maybe this could be incorporated into some of the ```get_app()``` function definitions, one day.?

## Storage

As seen in the [PRE-INSTALL] step earlier, WSL handily provides lots of ways to manage the storage of our virtual distros, including packing them as .tar files and importing them as dynamically-sized, mountable drives. We can fully leverage this in the spirit of a lightweight, portable development environment that can be easily backed up to external storage, re-initialized from a clean slate, duplicated, and converted and transferred between various storages and virtual hard drive formats.
    
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

Notice in the post-install steps the suggestion to use ```/etc/fonts/local.conf``` to import your Windows fonts (the entire function is provided in the steps). If you're interested in taking this further, take a look at the MS Store WSL Ubuntu's install folder - it ships with mutliple assets, such as several windows-friendly formats of the famous Ubuntu font, a Yaru-themed wallpaper, and several re-usable icons. The WSL Launcher distro's repo provides artwork templates in various shapes and sizes for shipment to the MS Store. Finally, you can actually get the entire Ubuntu font family - which includes a Windows Terminal-friendly 'monospace' version - from the Ubuntu website*, as well as from common sources such as Google Fonts. While these are probably superfluous touches, they do really highlight the interesting experience of different working environments *sharing* the resources on one machine in realtime. Personally, I am interested to see how far this can be further leveraged for the purposes of both reducing the linux-side storage footprint, while simultaneously extending the Windows desktop environment into new reaches.

*The official Ubuntu fonts are here - https://design.ubuntu.com/font/


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
    
# If you're cd-'ing around between NodeJs-based repo's, consider checking out
# nvm-sh's 'cd_nvm' function.
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
