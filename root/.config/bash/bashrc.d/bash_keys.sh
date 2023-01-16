# /etc/profile.d/bash_keyring.sh

get_gith()
{
    GH_KEY="/usr/share/keyrings/githubcli-archive-keyring.gpg"

    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | tee $GH_KEY >/dev/null

    echo "deb [arch=$ARCH signed-by=$GH_KEY] https://cli.github.com/packages stable main" | tee $APT_SOURCES/github-cli.list

    apt update

    unset GH_KEY

    # apt install gh
}


get_node()
{
    NODEJS_KEY="/usr/share/keyrings/nodesource.gpg"

    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee $NODEJS_KEY >/dev/null

    echo "deb [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/node_19.x $DISTRO main" | tee $APT_SOURCES/nodesource.list

    echo "deb-src [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/node_19.x $DISTRO main" | tee -a $APT_SOURCES/nodesource.list

    apt update

    unset NODEJS_KEY

    # sudo apt install nodejs

    # npm --global install npm@latest
}


get_yarn()
{
    YARN_KEY="/usr/share/keyrings/yarnkey.gpg"

    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee $YARN_KEY >/dev/null

    echo "deb [arch=$ARCH signed-by=$YARN_KEY] https://dl.yarnpkg.com/debian stable main" | tee $APT_SOURCES/yarn.list

    apt update

    unset YARN_KEY

    # sudo apt install yarn

    # yarn global add npm@latest
}

get_postgres()
{
    curl "https://www.postgresql.org/media/keys/ACCC4CF8.asc" | gpg --dearmor | tee "/etc/apt/trusted.gpg.d/apt.postgresql.org.gpg" >/dev/null

    echo "deb http://apt.postgresql.org/pub/repos/apt $DISTRO-pgdg main" > $APT_SOURCES/pgdg.list

    apt update

    # apt install postgresql postgresql-contrib postgresql-client
}

get_pgadmin()
{
    PGADMIN_KEY="/usr/share/keyrings/packages-pgadmin-org.gpg"

    curl -fsSL "https://www.pgadmin.org/static/packages_pgadmin_org.pub" | gpg --dearmor -o $PGADMIN_KEY

    echo "deb [signed-by=$PGADMIN_KEY] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$DISTRO pgadmin4 main" > $APT_SOURCES/pgadmin4.list

    apt update

    unset PGADMIN_KEY

    # Install for both desktop and web modes:
    # sudo apt install pgadmin4

    # Install for desktop mode only:
    # apt install pgadmin4-desktop

    # Install for web mode only:
    # apt install pgadmin4-web

    # Configure the webserver, if you installed pgadmin4-web:
    # sudo /usr/pgadmin4/bin/setup-web.sh
}


get_cmake()
{
    KITWARE_KEY="/usr/share/keyrings/kitware-archive-keyring.gpg"

    wget -O - "https://apt.kitware.com/keys/kitware-archive-latest.asc" 2>/dev/null | gpg --dearmor - | tee $KITWARE_KEY >/dev/null

    echo "deb [arch=$ARCH signed-by=$KITWARE_KEY] https://apt.kitware.com/ubuntu $DISTRO main" | tee $APT_SOURCES/kitware.list

    apt update

    unset KITWARE_KEY

    # sudo apt install kitware-archive-keyring cmake cmake-data cmake-doc ninja-build
}


get_chrome()
{
    curl "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o "$XDG_DOWNLOAD_DIR/chrome.deb"

    apt install "$XDG_DOWNLOAD_DIR/chrome.deb"
}


get_supabase()
{
    "curl https://github.com/supabase/cli/releases/download/v1.25.0/supabase_1.25.0_linux_amd64.deb" -o "$XDG_DOWNLOAD_DIR/supabase.deb"

    apt install "$XDG_DOWNLOAD_DIR/supabase_1.25.0_linux_amd64.deb"
}


get_nvm()
{
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh" | bash
}


get_postman()
{
    curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | bash

    # postman login
}


get_vcpkg_tool()
{
    . <(curl https://aka.ms/vcpkg-init.sh -L)

    . ~/.vcpkg/vcpkg-init
}
