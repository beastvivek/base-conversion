#! /bin/bash
source convert_base_library.sh

# Function to invoke appropriate conversion function
function convert_base()
{
	local operation=$1
	local number=$2
	local result

	if [[ $operation == "decimal_to_binary" ]]
	then
		result=$( decimal_to_any_base $number 2 )
	elif [[ $operation == "binary_to_decimal" ]]
	then
		result=$( any_base_to_decimal $number 2 )
	elif [[ $operation == "decimal_to_octal" ]]
	then
		result=$( decimal_to_any_base $number 8 )
	elif [[ $operation == "octal_to_decimal" ]]
	then
		result=$( any_base_to_decimal $number 8 )
	elif [[ $operation == "decimal_to_hexadecimal" ]]
	then
		result=$( decimal_to_any_base $number 16 )
	elif [[ $operation == "hexadecimal_to_decimal" ]]
	then
		result=$( any_base_to_decimal $number 16 )
	fi
	echo $result
}


## Function to perform selected operation
function perform_operation() {
	local operation=$1
	local number
	local result

	local operation_heading=$( echo $operation | tr "_" " " | tr "[:lower:]" "[:upper:]" )

	echo
	echo -e "OPERATION : $operation_heading"
	echo

	read -p"Enter a number : " number

	result=$( convert_base $operation $number )
	echo "Result : $result"
	echo
}


## Function to quit the process
function to_quit() {
	local operation=$1

	if [[ -z $operation ]]
	then
		clear
		exit 0
	fi
}


## Function to select operation
function select_operation() {
	local operations=$1
	local operation

	PS3=$( echo -e "\nEnter your choice ( in number ) : ")
	select operation in $operations
	do
		break
	done

	echo $operation
}


## Main function
function main() {
	local operations="decimal_to_binary binary_to_decimal decimal_to_octal octal_to_decimal decimal_to_hexadecimal hexadecimal_to_decimal"
	local preserve_operation="No"
	local operation

	while true
	do
		clear

		if [[ $preserve_operation != "Yes" ]]
		then
			echo "Press any character or number other than the given options to quit."
			echo
			operation=$( select_operation "$operations" )
			to_quit $operation
		fi

		perform_operation $operation

		PS3=$( echo -e "\nDecision (1 or 2)? : ")
		echo "Do you want to continue with the same operation ?"
		select preserve_operation in Yes No
		do
			break
		done
	done
}

main
