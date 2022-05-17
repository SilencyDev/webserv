#!/bin/bash

EXE_NAME="loader.exe"
CONF_PATH="./confs/*"
INC_PATH="../inc"
SRCS_PATH="../srcs/"
OUT_PATH="./test_output/"

Reset='\033[0m'       # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'

echo -e "To redirect the output of each test add 1 argument\n"
echo -e "${Red}Compiling....${Reset}\n"
clang++ -Wall -Wextra -I$INC_PATH -g -fsanitize=address ${SRCS_PATH}Loader.cpp ${SRCS_PATH}Server.cpp ${SRCS_PATH}Route.cpp ${SRCS_PATH}loader_treatment.cpp ${SRCS_PATH}utils.cpp ./main_test_loader.cpp -o ${EXE_NAME}

i=1
if test -f "./${EXE_NAME}"
then
	for f in $CONF_PATH
	do
		echo -e "${Cyan}+ Executing Test nº$i${Reset} - ${Purple}FILE : $f${Reset}"
		if [ $# -eq 1 ] 
		then
			./${EXE_NAME} $f > ${OUT_PATH}test_${i}.out
			j=$(cat ${OUT_PATH}test_${i}.out | wc -l)
			#diff ./confs/error_msg.out ${OUT_PATH}test_${i}.out > diff.txt
			if [ $j -ne 3 ]
			then
				echo -e "${Green}=> Configuration file passed the parsing${Reset}\n"
			else
				echo -e "${Red}=> Configuration file do not passed the parsing, an error has been thrown${Reset}\n"
			fi
		else
			./${EXE_NAME} $f 
		fi
		((i=i+1))
	done
	if [ $# -eq 1 ]
	then
		echo -e "\n${Green}The output of each tests has been redirected in a file test_<test number>.out in the test_output folder${Reset}"
	fi
else
	echo -e "\n${Red}Error: Compilation Failed${Reset}"
fi
rm -rf ${EXE_NAME} ${EXE_NAME}.dSYM diff.txt
