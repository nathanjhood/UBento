
if [ -d "/usr/local/psql" ] ; then

    # https://www.postgresql.org/docs/13/install-post.html
    if [ -d "/usr/local/pgsql/bin" ] ; then
        PATH="/usr/local/pgsql/bin:$PATH"
    fi

    if [ -d "/usr/local/pgsql/share/man" ] ; then
        MANPATH="/usr/local/pgsql/share/man:$MANPATH"
    fi

    if [ -d "/usr/local/pgsql/lib" ] ; then
        LD_LIBRARY_PATH="/usr/local/pgsql/lib:$LD_LIBRARY_PATH"
    fi

    if [ -z "$DATABASE_URL" ]; then
        export DATABASE_URL="postgresql://postgres:postgres@localhost:54322/postgres"
    fi
fi
