#!/usr/bin/env bash

# SCRIPT TO CHECK IF A GIVEN /32 IPv4 ADDRESS IS 
# PART OF A SUBNET OR NOT, CHECK THE "USAGE1" FUNCTION
# CODED BY - MOHNA BALA VENKATA KRISHNA (BVKMOHAN)
# EMAIL - MOHAN.BVK.143@GMAIL.COM
# V 1.0 - STABLE AND TESTED

# START

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# EXIT ON USE OF AN UNDECLARED VARIABLE
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
set -o nounset

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# CHECKS IF A GIVEN IP IN DOTTED NOTION FORMATE FALLS IN THE RANGE OF 1.0.0.0 TO 255.255.255.255. IF IT FALLS, THIS WILL RETURN 0, IF NOT, 1
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function validate_ip_in_valid_ipv4_range () {
if [[ ${1} =~ ^(([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))$ ]] ; then
	echo 0
else
	echo 1
fi
}

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# CHECKS IF THE GIVEN MASK IN DOTTED NOTION FALLS IN THE CORRECT SUBNET MASKS. IF IT FALLS, THIS WILL RETURN 0, IF NOT, 1
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function validate_mask_in_dot_and_slash () {
if [[ ${1} =~ ^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$ ]] ; then 
	echo 0
elif [[ ${1} =~ ^(8|9|1[0-9]|2[0-9]|3[0-2])$ ]] ; then
	echo 2
else 
	echo 1
fi
}

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# FOR A GIVEN SUBNET MASK IN SLASH NOTION, THIS WILL RETURN THE DOTTED NOTION
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function slash_to_mask () {
case ${1} in
	0) echo "0.0.0.0" ;;
	1) echo "128.0.0.0" ;;
	2) echo "192.0.0.0" ;;
	3) echo "224.0.0.0" ;;
	4) echo "240.0.0.0" ;;
	5) echo "248.0.0.0" ;;
	6) echo "252.0.0.0" ;;
	7) echo "254.0.0.0" ;;
	8) echo "255.0.0.0" ;;
	9) echo "255.128.0.0" ;;
	10) echo "255.192.0.0" ;;
	11) echo "255.224.0.0" ;;
	12) echo "255.240.0.0" ;;
	13) echo "255.248.0.0" ;;
	14) echo "255.252.0.0" ;;
	15) echo "255.254.0.0" ;;
	16) echo "255.255.0.0" ;;
	17) echo "255.255.128.0" ;;
	18) echo "255.255.192.0" ;;
	19) echo "255.255.224.0" ;;
	20) echo "255.255.240.0" ;;
	21) echo "255.255.248.0" ;;
	22) echo "255.255.252.0" ;;
	23) echo "255.255.254.0" ;;
	24) echo "255.255.255.0" ;;
	25) echo "255.255.255.128" ;;
	26) echo "255.255.255.192" ;;
	27) echo "255.255.255.224" ;;
	28) echo "255.255.255.240" ;;
	29) echo "255.255.255.248" ;;
	30) echo "255.255.255.252" ;;
	31) echo "255.255.255.254" ;;
	32) echo "255.255.255.255" ;;
esac
}

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# REUSABLE PRINT STATEMENTS
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function invalid_parameter () {
echo ""
echo " Invalid input value \"$1\" detected at [parameter ${2}]"
usage1
clear_and_exit1
}

function usage1 () {
echo ""
echo " Usage:"
echo "            [parameter 1] [parameter 2] [parameter 3]"
echo "            [IP Address]  [Network]     [MASK]"
echo ""
echo " Examples:"
echo "            ./$(basename "$0") 192.168.10.1 192.168.10.0 24"
echo "            ./$(basename "$0") 192.168.10.1 192.168.10.0 255.255.255.0"
echo "            ./$(basename "$0") 10.1.1.1 10.0.0.0 8"
echo "            ./$(basename "$0") 100.100.100.1 100.100.100.0 255.255.255.252"
echo "            ./$(basename "$0") 8.8.8.8 8.8.0.0 16"
echo ""
clear_and_exit1
}

function ip_is_part () {
echo ""
echo " IP Address is part of the network"
echo ""
}

function ip_is_not_part () {
echo ""
echo " IP Address is not part of the network"
echo ""
}

function network_is_incorrect () {
echo ""
echo " Network is incorrect for the given IP"
echo ""
}

function no_parameters_passed () {
echo ""
echo " Less/More/No parameters passed"
}

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# EXIT FUNCTIONS
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function clear_and_exit0 () {
	exit 0
}

function clear_and_exit1 () {
	exit 1
}

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

if [ $# -ne 0 ] && [ $# -eq 3 ]; then
	arg_one=${1}
	arg_two=${2}
	arg_thr=${3}
	if [ "$(validate_ip_in_valid_ipv4_range ${arg_one})" -eq 1 ] ; then
		invalid_parameter ${arg_one} 1
	else
		ip_address=${arg_one}
		if [ "$(validate_ip_in_valid_ipv4_range ${arg_two})" -eq 1 ] ; then
			invalid_parameter ${arg_two} 2
		else
			network=${arg_two}
			if [ "$(validate_mask_in_dot_and_slash ${arg_thr})" -eq 0 ] ; then
				subnet_mask=${arg_thr}
			elif [ "$(validate_mask_in_dot_and_slash ${arg_thr})" -eq 2 ] ; then
				subnet_mask=$(slash_to_mask ${arg_thr})
			else
				invalid_parameter ${arg_thr} 3
			fi
		fi
	fi
else
	no_parameters_passed
	usage1
fi

##
##
##

# echo ""
# echo $ip_address
# echo $network
# echo $subnet_mask
# echo ""

IFS=. read -r ip1 ip2 ip3 ip4 <<< $ip_address
IFS=. read -r su1 su2 su3 su4 <<< $subnet_mask

if [ "$((ip1 & su1)).$((ip2 & su2)).$((ip3 & su3)).$((ip4 & su4))" == $network ]; then
	ip_is_part
else
	ip_is_not_part
fi

# END
