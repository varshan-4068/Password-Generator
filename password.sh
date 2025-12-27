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
    echo "  Wi-Fi  → Upper:2  Lower:10  Numbers:2  Symbols:2"
    echo "  SSH    → Upper:4  Lower:12  Numbers:4  Symbols:4"
    echo "  Admin  → Upper:4  Lower:12 Numbers:4  Symbols:4"
    echo
    echo "You can ignore these and choose your own values."
    echo
}

recommendations

input

if [[ -z "$lower" &&  -z "$upper" && -z "$symbols" && -z "$numbers" ]] || [[ "$lower" -eq 0 && "$upper" -eq 0 && "$symbols" -eq 0 && "$numbers" -eq 0 ]];then
	while true;do
		echo "Please enter atleast any one character with non-empty and non-zero numbers"
		echo
		echo "Press Enter to Escape"
		read -r
		clear
		exec "$(pwd)"/password.sh
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
        echo "Invalid input: input must be a non-negative number"
				echo 
				read -rp "$(tput setaf 4)Press Enter to close${color2}"
				exec "$(pwd)"/password.sh
    fi
done

password=$(
  tr -dc 'A-Z' < /dev/urandom | head -c "$upper"
  tr -dc 'a-z' < /dev/urandom | head -c "$lower"
  tr -dc '0-9' < /dev/urandom | head -c "$numbers"
  tr -dc '!@#$%^&*()_+=' < /dev/urandom | head -c "$symbols"
)

password=$(echo "$password" | fold -w1 | shuf | tr -d '\n')

length=${#password}

echo -e "${color1}Password$(tput setaf 4): $password${color3}"

s=$(echo "${color2}|")

echo -e "\n<-- Length: ${color1}$length $s ${color3}Upper: ${color1}$upper $s ${color3}Lower: ${color1}$lower $s ${color3}Numbers: ${color1}$numbers $s ${color3}Symbols: ${color1}$symbols ${color3}-->${color2}"

if [ -n "$WAYLAND_DISPLAY" ]; then
    COPY="wl-copy"
else
    COPY="xclip -selection clipboard"
fi

if ! command -v "$COPY" &>/dev/null; then
	echo "Clipboard tool ($COPY) not found. Install $($COPY | awk '{print $1}') to enable clipboard copy."
else
	echo "$password" | $COPY
fi

if [ "$upper" -eq 2 ] && [ "$lower" -eq 10 ] && [ "$numbers" -eq 2 ] && [ "$symbols" -eq 2 ]; then
	echo -e "\n$(tput setaf 4)Strong enough for home Wi-Fi and other web accounts${color2}"
elif [ "$upper" -eq 4 ] && [ "$lower" -eq 12 ] && [ "$numbers" -eq 4 ] && [ "$symbols" -eq 4 ]; then
	echo -e "\n$(tput setaf 4)Very strong password for server access${color3}"
	echo -e "$(tput setaf 4)Long and complex, suitable for admin/root accounts.${color2}"
fi

score=0
classes=0

if (( length >= 8 ));then 
	score=$(echo "($length - 7)*0.2" | bc)
	if (( $(echo "$score > 5" | bc) )); then
			score=5
	fi
fi

if (( upper > 0 )); then
	((classes++))
fi

if (( lower > 0 ));then
	((classes++))
fi

if (( numbers > 0 ));then
	((classes++))
fi

if (( symbols > 0 )); then 
	((classes++))
fi

score_total=9

score=$(printf "%.0f" "$score")

(( score += classes ))

(( score > score_total )) && score=$score_total

percentage=$(echo "scale=2; $score*100/$score_total" | bc)

percentage=$(printf "%.0f" "$percentage")

bar_total=25

bar_fill=$(echo "($percentage * $bar_total) / 100" | bc)

bar_fill=$(printf "%.0f" "$bar_fill")

(( bar_fill < 1 )) && bar_fill=1

(( bar_fill > bar_total )) && bar_fill=$bar_total

if (( percentage < 30 )); then
    strength="Very Weak"
    bar_color=1
elif (( percentage < 50)); then
		strength="Weak"
		bar_color=3
elif (( percentage < 70)); then
    strength="Moderate"
    bar_color=3
elif (( percentage < 90 )); then
    strength="Strong"
    bar_color=2
else
    strength="Very Strong"
    bar_color=2
fi

filled=$(printf "%${bar_fill}s" | tr ' ' '|')
empty=$(printf "%$((bar_total - bar_fill))s" | tr ' ' '-')

echo
echo -e "${color1}Security Level: $(tput setaf $bar_color)$strength$(tput sgr0)\n"
echo -e "${color1}[$(tput setaf $bar_color)$filled$(tput setaf 7)$empty${color1}] ${color1}$percentage%${color2}\n"

echo -e "${color1}Note: ${color3}Strength rating is indicative only and not a cryptographic guarantee.${color2}"

HASH_FILE="$(pwd)/password_hashes"

if [ ! -f "$HASH_FILE" ];then
	touch "$HASH_FILE"
fi

hash=$(echo -n "$password" | sha256sum | cut -d' ' -f1)

grep -q "$hash" "$HASH_FILE" && echo -e "\nWarning: password reused"

echo "$hash" >> "$HASH_FILE"

echo

echo "password generated and copied to clipboard!"

sleep 1

echo

read -rp "$(tput setaf 4)Press Enter to close${color2}"

exit 0
