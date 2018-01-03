
#!/usr/bin/env bash

# SCRIPT TO CALUCULATE THE SUBNET MASK, CHECK THE "USAGE1" FUNCTION
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
# DISPLAYS AN ERROR FOR INVALID INPUT ARGUMENT
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function invalid_parameter () {
echo ""
echo " Invalid input value \"$1\" detected at [parameter ${2}]"
# echo 1
usage1
clear_and_exit1
}	

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DISPLAYS THE USAGE OF THE SCRIPT
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

function usage1 () {
echo ""
echo " Usage:"
echo "            [parameter 1] [parameter 2] [parameter 3]"
echo "            [IP Address]  [Network]     [MASK]"
echo ""
echo " Examples:"
echo "            192.168.10.1 192.168.10.0 24"
echo "            192.168.10.1 192.168.10.0 255.255.255.0"
echo "            10.1.1.1 10.0.0.0 8"
echo "            100.100.100.1 100.100.100.0 255.255.255.252"
echo "            8.8.8.8 8.8.0.0 16"
echo ""
clear_and_exit1
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
	echo ""
	echo " Less/More/No parameters passed"
	# echo 3
	usage1
fi

##
##
##

block_size=0
block_tub=0
octet_match=0
full_mask=0
blocks[0]=0
block_begin=300

function loop_the_block () {
for loop in `seq ${1} ${2}` ; do
	if [ "$(echo ${ip_address} | cut -d "." -f${octet})" = "${loop}" ] ; then
		octet_match=1
		break
	fi
done
if [ "${octet_match}" -eq 0 ] ; then
	# RETURN 1
	# echo 1
	echo ""
	echo " IP Address is not part of the network"
	echo ""
	clear_and_exit1
elif [ "${octet_match}" -eq 1 ] ; then
	if [ "${octet}" -eq 4 ] ; then
		echo ""
		echo " IP Address is part of the network"
		echo ""
		# echo 0
		clear_and_exit1
	fi
else
	echo "3"
	clear_and_exit1
fi
}

for octet in `seq 1 4` ; do
	if [ "$(echo ${subnet_mask} | cut -d "." -f${octet})" -eq 255 ] ; then
		if [ ! "$(echo ${ip_address} | cut -d "." -f${octet})" = "$(echo ${network} | cut -d "." -f${octet})" ] ; then
			# RETURN 1 
			# echo 1
			echo ""
			echo " IP address is not part of the network"
			echo ""
			break
		else
			full_mask=$((${full_mask}+1))
			if [ "${full_mask}" -eq 4 ] ; then
				echo ""
				echo " IP Address is part of the network"
				echo ""
				# echo 0
				break
			fi
		fi
	elif [ "$(echo ${subnet_mask} | cut -d "." -f${octet})" -lt 255 ] && [ "$(echo ${subnet_mask} | cut -d "." -f${octet})" -gt 0 ] ; then
		block_size=$((256-$(echo ${subnet_mask} | cut -d "." -f${octet})))
		for (( k=1; k<256; k++ )) ; do
			block_tub=$((${block_tub}+${block_size}))
			if [ ! "${block_tub}" -eq 256 ] ; then
				blocks[${k}]=${block_tub}
			else
				break
			fi
		done
		for l in ${blocks[@]} ; do
			if [ "$(echo ${network} | cut -d "." -f${octet})" = "${l}" ] ; then
				block_begin=${l}
				if [ "${block_begin}" -eq 0 ] ; then
					block_end=$((${block_size}-1))
				else
					block_end=$((${block_begin}+$((${block_size}-1))))
				fi
				break
			fi
		done
		if [ ! "${block_begin}" -eq 300 ] ; then
			loop_the_block ${block_begin} ${block_end}
		else
			# RETURN 2
			# echo 2
			echo ""
			echo " Network is incorrect for the given IP"
			echo ""
			break
		fi
	elif [ "$(echo ${subnet_mask} | cut -d "." -f${octet})" -eq 0 ] ; then
			loop_the_block 0 255 ; 
	else
		# RETURN 3
		# echo 3
		echo "Duh ..."
	fi
done

# END
