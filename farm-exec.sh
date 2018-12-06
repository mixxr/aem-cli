#!/usr/bin/env bash
printf "=======\nAEM CLI\n=======\nreading farm configuration from $1\n"
CMD=cmds/"$2"

# if CMD does not exists
if [ ! -e "$CMD" ]; then
    echo $2" command not found!"
    exit 1
fi

while read -r host user 
do 
    
    if [[ $host == "--" && $user == "END" ]]; then 
        echo "<--"
        exit 0
    fi
    if [[ $host == "--" && $user == "START" ]]; then 
        START=1
        echo "-->"
        continue
    fi

    if [[ $START == 1 && ! -z "$host" && ! -z "$user" ]]; then
        var=$(sh $CMD $host $user ${@:3})
        RC=$?
        if [ $RC -ne 0 ]; then
            printf "<--\n$2 exits with error: $var\n"
            exit $RC
        else
            echo $host $user $var
        fi
    fi
done < $1
