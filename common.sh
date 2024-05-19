#!/bin/sh

source_rc() {
    dir="$1"
    pattern="$2"
    FILES="$( find "$dir" -type f -o -type l -name "$pattern" )"

    while read fn; do 
        KKK=111
        case $fn in
            ("") ;;
            (*~) ;;
            (.*~) ;;
            (*) 
                . "$fn"
                ;;
        esac
    done <<EOF
$FILES
EOF

###     find "$dir" -type f -o -type l -name "$pattern" | while read fn; do 
###         case $fn in
###             (*~) ;;
###             (.*~) ;;
###             (*) 
###                 . "$fn"
###                 ;;
###         esac
###     done
}
