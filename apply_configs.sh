#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"

case "$(uname -s)" in
    Linux)
        ${DIR}/gsettings.sh
        ${DIR}/apply_sysctl_config.sh
        ;;
    Darwin)
        ;;
    *)
        echo 'Unknown OS'
        ;;
esac
