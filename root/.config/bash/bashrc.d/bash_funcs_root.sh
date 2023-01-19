
make_user()
{
    adduser --home=/home/"${1}" --shell=/bin/bash --gecos="${2}" --uid=1000 "${1}"

    usermod --group=adm,dialout,cdrom,floppy,tape,sudo,audio,dip,video,plugdev "${1}"

    echo -e "[user]\n default=${1}\n" >> /etc/wsl.conf

    #git config --global user.name "${1}"
    #git config --global user.email "${3}"

    #gh auth login

    #gh auth setup-git

    login ${1}
}

## make_user "<username>" "<full name>"" "<email>"
