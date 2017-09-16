#!/usr/bin/env bash

source $(dirname $(readlink -f $0))/functions.sh

function showHelp() {
    echo "$(basename $0) [OPTIONS]"
    echo ""
    echo "OPTIONS"
    echo " -h Show Help Message"
    echo " -u The URL to a TGZ file containing the executable."
    echo " -x The command to execute after extracting the executable."
}

echo "--------------------------------------------------"
echo "Mesos Playground"
echo "Service Container Exection Environment"
echo "--------------------------------------------------"

U=""
X="npm start"

while getopts :u:w:x:h opt; do

    case "${opt}" in
    h)
        showHelp && exit 0 ;;
    u)
        U="${OPTARG// }" ;;
    x)
        X="${OPTARG// }" ;;
    :)
        abort "Option -${OPTARG} requires an argument. Try -h for more information." $ARG_ERROR ;;
    *)
        abort "Unknown option -${OPTARG}. Try -h for more information." $ARG_ERROR ;;
    esac

done

ensureString "${U}" "Missing required argument -u. try -h for more information."

ARCHIVE=$(tempfile)

logIt "Fetching application from ${U}" "i"
logIt "Saving archive bytes in ${ARCHIVE}" "d"

fetchBytes "${U}" > "${ARCHIVE}"
extractArchive "${ARCHIVE}"
#findAndCd "package.json"

logIt "Removing temp files." "d"
rm -f "${ARCHIVE}"

logIt "Bootstrap complete." "i"
logIt "Handing off execution to your code." "i"

exec $X

abort "Execution failed! See above for errors." $EXEC_ERROR
