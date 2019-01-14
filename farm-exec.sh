#!/usr/bin/env bash
list(){


for entry in ./cmds/*
do
    if [[ $entry != "./cmds/errors" ]]; then 
        echo "$entry" | awk -F '/' '{print $3}'
    fi
done

echo "---- HELP: ----"
echo "try: $1 $2 command usage"

}
printf "=======\nAEM CLI\n=======\nReading farm configuration from $1\n"
CMD=cmds/"$2"

# if farm file does not exist
if [ ! -e "$1" ]; then
    echo $1" file not found!"
    exit 1
fi

# if CMD does not exists
if [[ -z "$2" ]]; then
    echo "Please insert a command:"
    list $0 $1
    exit 2
fi
if [ ! -e "$CMD" ]; then
    echo $2" command not found!"
    exit 3
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
            if [ $RC -eq 255 ]; then
                printf "<--\n$2 command usage:\n $var\n"
            else    
                printf "<--\n$2 exits with error: $var\n"
            fi   
            exit $RC
        else
            echo $host $user $var
        fi
    fi
done < $1
