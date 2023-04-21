#!/usr/bin/env bash
# (c) github.com/goarano

function _lazy_load() {
    func_name=$1
    comp_cmd=$2

    if [ $commands[$func_name] ]; then
        eval "
        function _init_$func_name() {
            unfunction \"\$0\"
            unfunction \"$func_name\"
            unfunction \"_$func_name\"
            source <($comp_cmd) # Load auto-completion
        }

        function $func_name() {
            _init_$func_name
            \$0 \"\$@\" # Execute original command
        }

        #compdef $func_name
        function _$func_name() {
            _init_$func_name
            if typeset -f $func_name > /dev/null; then
                \$0 \"\$@\" # Execute original command
            fi
        }

        if [[ \"\$(basename -- \${(%):-%x})\" != \"_$func_name\" ]]; then
            compdef _$func_name $func_name
        fi
        "
    fi
}
