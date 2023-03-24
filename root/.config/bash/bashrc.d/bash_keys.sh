export DISTRO="$(lsb_release -cs)"
export ARCH="$(dpkg --print-architecture)"
export APT_SOURCES="/etc/apt/sources.list.d"
export KEY_PATH="/usr/share/keyrings"

get_gith()
{
  local GH_KEY="$KEY_PATH/githubcli-archive-keyring.gpg"

  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | tee $GH_KEY >/dev/null

  echo "deb [arch=$ARCH signed-by=$GH_KEY] https://cli.github.com/packages stable main" | tee $APT_SOURCES/github-cli.list

  apt update

  # apt install gh
}


get_node()
{
  local NODEJS_KEY="$KEY_PATH/nodesource.gpg"

  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee $NODEJS_KEY >/dev/null

  echo "deb [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/node_19.x $DISTRO main" | tee $APT_SOURCES/nodesource.list

  echo "deb-src [arch=$ARCH signed-by=$NODEJS_KEY] https://deb.nodesource.com/node_19.x $DISTRO main" | tee -a $APT_SOURCES/nodesource.list

  apt update

  # apt install nodejs

  # npm --global install npm@latest
}


get_yarn()
{
  local YARN_KEY="$KEY_PATH/yarnkey.gpg"

  curl -fsSL "https://dl.yarnpkg.com/debian/pubkey.gpg" | gpg --dearmor | tee $YARN_KEY >/dev/null

  echo "deb [arch=$ARCH signed-by=$YARN_KEY] https://dl.yarnpkg.com/debian stable main" | tee $APT_SOURCES/yarn.list

  apt update

  # sudo apt install yarn

  # yarn global add npm@latest
}

get_postgres()
{
  local PSQL_KEY="$KEY_PATH/apt.postgresql.org.gpg"

  wget -O - "https://www.postgresql.org/media/keys/ACCC4CF8.asc" 2>/dev/null | gpg --dearmor - | tee $PSQL_KEY >/dev/null

  echo "deb [arch=$ARCH signed-by=$PSQL_KEY] http://apt.postgresql.org/pub/repos/apt $DISTRO-pgdg main" | tee $APT_SOURCES/pgdg.list

  apt update

  # apt install postgresql postgresql-contrib postgresql-client
}

get_pgadmin()
{
  local PGADMIN_KEY="$KEY_PATH/packages-pgadmin-org.gpg"

  curl -fsSL "https://www.pgadmin.org/static/packages_pgadmin_org.pub" | gpg --dearmor -o $PGADMIN_KEY

  echo "deb [arch=$ARCH signed-by=$PGADMIN_KEY] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$DISTRO pgadmin4 main" > $APT_SOURCES/pgadmin4.list

  apt update

  # Install for both desktop and web modes:
  # sudo apt install pgadmin4

  # Install for desktop mode only:
  # apt install pgadmin4-desktop

  # Install for web mode only:
  # apt install pgadmin4-web

  # Configure the webserver, if you installed pgadmin4-web:
  # sudo /usr/pgadmin4/bin/setup-web.sh
}

get_vscode()
{
  local VSCODE_KEY="$KEY_PATH/packages.microsoft.gpg"

  wget -O - "https://packages.microsoft.com/keys/microsoft.asc" 2>/dev/null | gpg --dearmor - | tee $VSCODE_KEY >/dev/null

  echo "deb [arch=$ARCH signed-by=$VSCODE_KEY] https://packages.microsoft.com/repos/code stable main" | tee $APT_SOURCES/vscode.list

  apt update
}

get_docker()
{
  local DOCKER_KEY="$KEY_PATH/docker.gpg"

  wget -O - "https://download.docker.com/linux/debian/gpg" | gpg --dearmor | tee $DOCKER_KEY >/dev/null

  echo "deb [arch=$ARCH signed-by=$DOCKER_KEY] https://download.docker.com/linux/debian $DISTRO stable" | tee $APT_SOURCES/docker.list

  apt update
}

get_cmake()
{
  local KITWARE_KEY="$KEY_PATH/kitware-archive-keyring.gpg"

  wget -O - "https://apt.kitware.com/keys/kitware-archive-latest.asc" 2>/dev/null | gpg --dearmor - | tee $KITWARE_KEY >/dev/null

  echo "deb [arch=$ARCH signed-by=$KITWARE_KEY] https://apt.kitware.com/ubuntu $DISTRO main" | tee $APT_SOURCES/kitware.list

  apt update

  # sudo apt install kitware-archive-keyring cmake cmake-data cmake-doc ninja-build
}


get_chrome()
{
  local CHROME_KEY="/usr/share/keyrings/google-chrome.gpg"

  curl "https://dl.google.com/linux/direct/google-chrome-stable_current_$ARCH.deb" -o "/tmp/google-chrome.deb"

  echo "deb [arch=$ARCH signed-by=$CHROME_KEY] https://dl.google.com/linux/chrome/deb stable main"

  apt install "/tmp/google-chrome.deb"

  local CHROME_TMP_KEY="/etc/apt/trusted.gpg.d/google-chrome.gpg"

  cp -rvf $CHROME_TMP_KEY $CHROME_KEY

  rm -rvf $CHROME_TMP_KEY

  apt update
}


get_supabase()
{
  "curl https://github.com/supabase/cli/releases/download/v1.25.0/supabase_1.25.0_linux_$ARCH.deb" -o "/tmp/supabase.deb"

  apt install "/tmp/supabase_1.25.0_linux_amd64.deb"
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
