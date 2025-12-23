#!/usr/bin/env bash

clear

color1="$(tput setaf 2)"
color2="$(tput setaf 7)"
color3="$(tput setaf 3)"

function input(){
	read -rp "${color1}Enter no. of uppercase letters: " upper
	echo
	read -rp "${color3}Enter no. of lowercase letters: " lower
	echo
	read -rp "${color1}Enter no. of numbers to be kept: " numbers
	echo
	read -rp "${color3}Enter the no. of special characters to be present: ${color2}" symbols
	echo
}

function recommendations() {
    echo "$(tput setaf 6)Recommended presets (optional):$(tput sgr0)"
    echo "  Wi-Fi  → Upper:2  Lower:8  Numbers:2  Symbols:2"
    echo "  SSH    → Upper:4  Lower:8  Numbers:4  Symbols:4"
    echo "  Admin  → Upper:4  Lower:10 Numbers:4  Symbols:4"
    echo
    echo "You can ignore these and choose your own values."
    echo
}

recommendations

input

if [[ -z "$lower" &&  -z "$upper" && -z "$symbols" && -z "$numbers" ]];then
	while true;do
		echo "Please enter atleast any one character"
		echo
		echo "Press Enter to Escape"
		read -r
		clear
		exec ~/Password-Generator/password.sh
		if [[ -z "$lower" ]] || [[ -z "$upper" ]] || [[ -z "$symbols" ]] || [[ -z "$numbers" ]];then
			break
		fi
	done
fi

if [[ -z "$numbers" ]]; then
	numbers=0
fi

if [[ -z "$symbols" ]]; then
	symbols=0
fi

if [[ -z "$upper" ]]; then
	upper=0
fi

if [[ -z "$lower" ]]; then
	lower=0
fi

for var in upper lower numbers symbols; do
    if ! [[ "${!var}" =~ ^[0-9]+$ ]]; then
        echo "Invalid input: input must be a number"
				echo 
				read -rp "$(tput setaf 4)Press Enter to close${color2}"
				exec ~/Password-Generator/password.sh
    fi
done

password=$(
  tr -dc 'A-Z' < /dev/urandom | head -c "$upper"
  tr -dc 'a-z' < /dev/urandom | head -c "$lower"
  tr -dc '0-9' < /dev/urandom | head -c "$numbers"
  tr -dc '!@#$%^&*()_+=' < /dev/urandom | head -c "$symbols"
)

password=$(echo "$password" | fold -w1 | shuf | tr -d '\n')

echo -e "${color1}Password$(tput setaf 4): $password${color3}"

echo "$password" | wl-copy

HASH_FILE="$HOME/Password-Generator/password_hashes"

if [ ! -f "$HASH_FILE" ];then
	touch "$HASH_FILE"
fi

hash=$(echo -n "$password" | sha256sum | cut -d' ' -f1)

grep -q "$hash" "$HASH_FILE" && echo -e "\nWarning: password reused\n"

echo "$hash" >> "$HASH_FILE"

echo

echo "password generated and copied to clipboard!"

sleep 1.4

echo

read -rp "$(tput setaf 4)Press Enter to close${color2}"

exit 0
