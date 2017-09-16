FETCH_ERROR=1
ENSURE_ERROR=2
ARG_ERROR=3
EXTRACT_ERROR=4
EXEC_ERROR=5

function logIt() {
    case "${2}" in
    d)
        printf "Debug: %s\n" "${1}"
        ;;
    i)
        printf "Info: %s\n" "${1}"
        ;;
    w)
        printf "Warn: %s\n" "${1}" >&2
        ;;
    e)
        printf "Error: %s\n" "${1}" >&2
        ;;
    *)
        printf "Notice: %s\n" "${1}"
        ;;
    esac
}

function abort() {
    xc=$2
    logIt "${1}" "e"
    printf "Exit Code: %s\n" "${xc}"
    exit ${xc}
}

function ensureString() {
    if [[ -z "$1" ]];
    then
        abort "$2" $ENSURE_ERROR
    fi
}

function fetchBytes() {
    wget -O - -o /dev/null "${1}"
    if [ $? != 0 ]
    then
        abort "Failed to fetch bytes for ${1}" $FETCH_ERROR
    fi
}

function extractArchive() {
    tar xf "${1}"
    if [ $? != 0 ]
    then
        abort "Failed to extract archive at ${1}" $EXTRACT_ERROR
    fi
}

function findAndCd() {

    p=$(find . -maxdepth 2 -type f -name "${1}" | head -n1)
    cd $(dirname "${p}")

    if [ $? != 0 ]
    then
        logIt "Unabled to find app directory." "w"
        logIt "$(ls | xargs)" "d"
        abort "Failed to change to app directory" $EXTRACT_ERROR
    fi
}
