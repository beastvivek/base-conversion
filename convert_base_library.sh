## validating function

function validate_input() {
	local value=$1
	local pattern=$2

	if echo $value | grep -q "$pattern"
	then
		return 0
	fi

	return 1
}

## Converting digits to alphabets

function number_to_character() {
	local number=$1
	local alphabet=$number
	local string=$( echo $number | grep "[A-Za-z]" )
	if [[ -z $string ]]
	then
		local ascii_value=$(( 55 + $number ))
		alphabet=$( jot -c 1 $ascii_value )
	fi
	echo $alphabet
}

# Converting alphabets to digits

function alphabet_to_number()
{
	local alphabet=$1
	local number=$alphabet
	local string=$( echo $alphabet | grep "[0-9]" )
	if [[ -z $string ]]
	then
		local ascii_value=$( jot 1 $alphabet )
		number=$(( $ascii_value - 55 ))
	fi
	echo $number
}

## power function

function power() {
	local base=$1
	local exponent=$2
	local power_result=1

	while (( exponent > 0 ))
	do
		power_result=$(( $power_result * $base ))
		exponent=$(( $exponent - 1 ))
	done
	echo $power_result
}

## from decimal to any base

function decimal_to_any_base()
{
	local decimal_number=$1
	local base=$2
	local converted_number

	validate_input $decimal_number "^[0-9]*$"

	if [[ $? == 1 ]]
	then
		echo "Error ! Wrong Input"
		return 1
	fi

	if [[ $decimal_number -le 0 ]]
	then
		echo "$decimal_number"
		return 0
	fi

	local remainder
	while [[ $decimal_number -gt 0 ]]
	do
		remainder=$(( $decimal_number % $base ))
		if [[ $remainder -gt 9 ]]
		then
			remainder=$( number_to_character $remainder )
		fi
		decimal_number=$(( $decimal_number / $base ))
		converted_number="${remainder}${converted_number}"
	done
	echo "$converted_number"
}

## Hexadecimal to decimal

function hexadecimal_to_decimal()
{
	local number="$1"
	local character_count=${#number}
	local exponent=0
	local power_result=0
	local converted_number=0
	local character=""

	validate_input $number "^[0-9A-F]*$"
	if [[ $? == 1 ]]
	then
		echo "Error ! Wrong Input"
		return 1
	fi

	while [[ $character_count -gt 0 ]]
	do
		character=$( echo "$number" | cut -c${character_count} )
		character=$( alphabet_to_number $character )
		power_result=$( power 16 $exponent )
		converted_number=$(( $converted_number + $character * $power_result ))
		character_count=$(( $character_count - 1 ))
		exponent=$(( $exponent + 1 ))
	done
	echo $converted_number
}

## from any base to decimal number

function any_base_to_decimal()
{
	local number=$1
	local base=$2
	local exponent=0
	local decimal_number=0
	local power_result=0
	if [[ $base == 16 ]]
	then
		hexadecimal_to_decimal $number
		return 0
	fi

	local validation_pattern=""
	if [[ $base == 2 ]]
	then
		validate_input $number "^[01]*$"
	elif [[ $base == 8 ]]
	then
		validate_input $number "^[0-7]*$"
	fi

	if [[ $? == 1 ]]
	then
		echo "Error ! Wrong Input"
		return 1
	fi

	if [[ $number -le 0 ]]
	then
		echo "$number"
	else
		while [[ $number -gt 0 ]]
		do
			digit=$(( $number % 10 ))
			number=$(( $number / 10 ))
			power_result=$( power $base $exponent )
			decimal_number=$(( $digit * $power_result + $decimal_number ))
			exponent=$(( $exponent + 1 ))
		done
		echo "$decimal_number"
	fi
}
