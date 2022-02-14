#! /bin/bash
source convert_base_library.sh
SEPARATOR=$( seq -f"-" -s"\0" 20 )
HEADING_SEPARATOR=$( seq -f"=" -s"\0" 20 )

function test_case_heading() {
	local function_name=$1
	echo
	echo $HEADING_SEPARATOR
	echo -e "Test Case for : ${function_name} function"
	echo $HEADING_SEPARATOR
}

function assert_expectations() {
	local actual=$1
	local expected=$2
	local inputs=$3

	local test_result="FAIL"
	if [[ "$expected" == "$actual" ]]
	then
		test_result="PASS"
	fi

	local output="Actual : ${actual}"
	echo "$test_result | ${inputs} | ${output}"
}

## Test function for validate_input

function test_validate_input() {
	local value=$1
	local pattern=$2
	local expected_result=$3

	validate_input "$value" "$pattern"
	local actual_result=$?
	local inputs="Value : ${value} | Pattern : ${pattern} | Expected : ${expected_result}"

	assert_expectations "$actual_result" "$expected_result" "$inputs"
}

# Test cases for validate_input

function test_cases_validate_input(){
	test_case_heading "validate_input"

	echo -e "\nTest Case : Valid Inputs"
	echo $SEPARATOR
	test_validate_input "19" "^[0-9]*$" 0
	test_validate_input "076" "^[0-7]*$" 0
	test_validate_input "101" "^[01]*$" 0
	test_validate_input "A5" "^[0-9A-F]*$" 0

	echo -e "\nTest Case : InValid Inputs"
	echo $SEPARATOR
	test_validate_input "A5" "^[0-9]*$" 1
	test_validate_input "096" "^[0-7]*$" 1
	test_validate_input "141" "^[01]*$" 1
	test_validate_input "U5" "^[0-9A-F]*$" 1
}

# Test function for number_to_character
function test_number_to_character() {
	local value=$1
	local expected_value=$2

	local actual_value=$( number_to_character $value )
	local inputs="Value : $value | Expected : $expected_value"
	assert_expectations "$actual_value" "$expected_value" "$inputs"
}

# Test Cases fot number_to_character
function test_cases_number_to_character() {
	test_case_heading "number_to_character"

	echo -e "\nTest Case : Valid Inputs"
	echo $SEPARATOR
	test_number_to_character 10 A
	test_number_to_character 12 C
	test_number_to_character 20 K

	echo -e "\nTest Case : InValid Inputs"
	echo $SEPARATOR
	test_number_to_character "1A" "1A"
	test_number_to_character C C
	test_number_to_character A5 A5
}

# test function for alphabet_to_number
function test_alphabet_to_number() {
	local value=$1
	local expected_value=$2

	local actual_value=$( alphabet_to_number "$value" )
	local inputs="Value : $value | Expected : $expected_value"
	assert_expectations "$actual_value" "$expected_value" "$inputs"
}

# test cases for alphabet_to_number
function test_cases_alphabet_to_number() {
	test_case_heading "alphabet_to_number"

	echo -e "\nTest Case : Valid Inputs"
	echo $SEPARATOR
	test_alphabet_to_number "A" "10"
	test_alphabet_to_number "C" "12"
	test_alphabet_to_number "F" "15"

	echo -e "\nTest Case : InValid Inputs"
	echo $SEPARATOR
	test_alphabet_to_number "5A" "5A"
	test_alphabet_to_number "10" "10"
	test_alphabet_to_number "F1" "F1"
}

# Test for power
function test_power() {
	local base=$1
	local exponent=$2
	local expected_result=$3

	local actual_result=$( power $base $exponent )
	local inputs="Base : ${base} | Exponent : ${exponent} | Expected : ${expected_result}"

	assert_expectations "$actual_result" "$expected_result" "$inputs"
}


# Test cases for power
function test_cases_power() {
	test_case_heading "power"

	echo -e "\nTest Case : Valid Inputs"
	echo $SEPARATOR
	test_power 1 1 1
	test_power 2 3 8
	test_power 4 2 16
	test_power 2 0 1

	echo -e "\nTest Case : InValid Inputs"
	echo $SEPARATOR
	test_power A 2 0
	test_power B 1 0
	test_power F 2 0
}

# test function for decimal_to_any_base
function test_decimal_to_any_base() {
	local value=$1
	local base=$2
	local expected_result=$3

	local actual_result=$( decimal_to_any_base $value $base )
	local inputs="Value : $value | Base : $base | Expected : $expected_result"
	assert_expectations "$actual_result" "$expected_result" "$inputs"
}

# test cases for decimal_to_any_base
function test_cases_decimal_to_any_base() {
	test_case_heading "decimal_to_any_base"

	echo -e "\nTest Case : Valid Inputs"
	echo $SEPARATOR
	test_decimal_to_any_base 12 2 "1100"
	test_decimal_to_any_base 12 8 "14"
	test_decimal_to_any_base 12 16 "C"
	test_decimal_to_any_base 165 16 "A5"

	echo -e "\nTest Case : Invalid Inputs"
	echo $SEPARATOR
	test_decimal_to_any_base "A5" 2 "Error ! Wrong Input"
	test_decimal_to_any_base "B6" 8 "Error ! Wrong Input"
	test_decimal_to_any_base "F" 16 "Error ! Wrong Input"
	test_decimal_to_any_base "1A" 16 "Error ! Wrong Input"

}

# Test function for hexadecimal_to_decimal
function test_hexadecimal_to_decimal() {
	local value=$1
	local expected_result=$2

	local actual_result=$( hexadecimal_to_decimal $value )
	local inputs="Value : $value | Expected : $expected_result"
	assert_expectations "$actual_result" "$expected_result" "$inputs"
}


# Test cases for hexadecimal_to_decimal
function test_cases_hexadecimal_to_decimal() {
	test_case_heading "hexadecimal_to_decimal"

	echo -e "\nTest Case : Valid Inputs"
	echo $SEPARATOR
	test_hexadecimal_to_decimal "A5" "165"
	test_hexadecimal_to_decimal "B5" "181"
	test_hexadecimal_to_decimal "5A" "90"

	echo -e "\nTest Case : Invalid Inputs"
	echo $SEPARATOR
	test_hexadecimal_to_decimal "K5" "Error ! Wrong Input"
	test_hexadecimal_to_decimal "6P" "Error ! Wrong Input"
	test_hexadecimal_to_decimal "LQ" "Error ! Wrong Input"
}

# test function for any_base_to_decimal
function test_any_base_to_decimal() {
	local value=$1
	local base=$2
	local expected_result=$3

	local actual_result=$( any_base_to_decimal $value $base )
	local inputs="Value : $value | Base : $base | Expected : $expected_result"
	assert_expectations "$actual_result" "$expected_result" "$inputs"
}

# test cases for any_base_to_decimal
function test_cases_any_base_to_decimal() {
	test_case_heading "any_base_to_decimal"

	echo -e "\nTest Case : Valid Inputs"
	echo $SEPARATOR
	test_any_base_to_decimal "101" 2 5
	test_any_base_to_decimal "14" 8 12
	test_any_base_to_decimal "A5" 16 165
	test_any_base_to_decimal "12" 10 12

	echo -e "\nTest Case : Invalid Inputs"
	echo $SEPARATOR
	test_any_base_to_decimal "78" 8 "Error ! Wrong Input"
	test_any_base_to_decimal "102" 2 "Error ! Wrong Input"
	test_any_base_to_decimal "G5" 16 "Error ! Wrong Input"
}

# running on all test cases
function run_all_tests() {
	test_cases_validate_input
	test_cases_number_to_character
	test_cases_alphabet_to_number
	test_cases_power
	test_cases_decimal_to_any_base
	test_cases_hexadecimal_to_decimal
	test_cases_any_base_to_decimal
}

run_all_tests
