#!/bin/bash
#
# GNU/Linux - ©NightSec
# GPL - General Public License
# Open Source - Software Libre
#
# ┌══════════┐  ┌════════════┐
# █ URLSpoof █=>█ 18/04/2021 █
# └══════════┘  └════════════┘
#
# ===============================================
#                   VARIABLES
# ===============================================
PWD=$(pwd)
SYSTEM=$(uname -o)
HOME="/data/data/com.termux/files/home"
USR="/data/data/com.termux/files/usr"
# ===============================================
#               HIGHLIGHTED COLORS
# ===============================================
negro="\e[1;30m"
azul="\e[1;34m"
verde="\e[1;32m"
cian="\e[1;36m"
rojo="\e[1;31m"
purpura="\e[1;35m"
amarillo="\e[1;33m"
blanco="\e[1;37m"
# ===============================================
#                  LOW COLORS
# ===============================================
black="\e[0;30m"
blue="\e[0;34m"
green="\e[0;32m"
cyan="\e[0;36m"
red="\e[0;31m"
purple="\e[0;35m"
yellow="\e[0;33m"
white="\e[0;37m"
# ===============================================
#            VERIFICANDO DEPENDENCIAS
# ===============================================
Dependencies(){
	if [ "${SYSTEM}" == "Android" ]; then
		if [ -x ${USR}/bin/curl ]; then
			PWD=$(pwd)
		else
			yes|pkg install curl
		fi
		if [ -x ${USR}/bin/urlspoof ]; then
			PWD=$(pwd)
		else
			echo -e "#!/bin/bash" >> ${USR}/bin/urlspoof
			echo -e "URLSpoof='${PWD}'" >> ${USR}/bin/urlspoof
			echo -e 'cd ${URLSpoof}' >> ${USR}/bin/urlspoof
			echo -e 'exec bash "${URLSpoof}/urlspoof.sh" "$@"' >> ${USR}/bin/urlspoof
			chmod 777 ${USR}/bin/urlspoof
		fi
	else
		if [ -x /bin/curl ]; then
			PWD=$(pwd)
		else
			echo -e "\ncurl: command not found"
			exit
		fi
		if [ -x /bin/urlspoof ]; then
			PWD=$(pwd)
		else
			echo -e "#!/bin/bash" >> /bin/urlspoof
			echo -e "URLSpoof='${PWD}'" >> /bin/urlspoof
			echo -e 'cd ${URLSpoof}' >> /bin/urlspoof
			echo -e 'exec bash "${URLSpoof}/urlspoof.sh" "$@"' >> /bin/urlspoof
			chmod 777 /bin/urlspoof
		fi
	fi
}
# ===============================================
#            BANNER DE TEXTO URLSPOOF
# ===============================================
URLSpoof(){
	sleep 0.5
	clear
echo -e "
${verde}██╗   ██╗██████╗ ██╗     ${negro}███████╗██████╗  ██████╗  ██████╗ ███████╗
${verde}██║   ██║██╔══██╗██║     ${negro}██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝
${verde}██║   ██║██████╔╝██║     ${negro}███████╗██████╔╝██║   ██║██║   ██║█████╗
${verde}██║   ██║██╔══██╗██║     ${negro}╚════██║██╔═══╝ ██║   ██║██║   ██║██╔══╝
${verde}╚██████╔╝██║  ██║███████╗${negro}███████║██║     ╚██████╔╝╚██████╔╝██║
${verde} ╚═════╝ ╚═╝  ╚═╝╚══════╝${negro}╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚═╝"${blanco}
}
# ===============================================
#                REQUESTING URL
# ===============================================
URL(){
	URLSpoof
echo -e -n "${negro}
┌═════════════════┐
█ ${blanco}ENTER A URL ${negro}█
└═════════════════┘
┃
└═>>> "${verde}
read -r URL
sleep 0.5
}
# ===============================================
#             PREGUNTANDO AL USUARIO
# ===============================================
Question(){
echo -e -n "${negro}
┌════════════════════════┐
█ ${blanco}WANT TO SHORTEN THE URL? ${negro}█
└════════════════════════┘
┃    ┌═══════════════════┐
└═>>>█ [${verde}01${negro}] ┃ ${blanco}YES ${negro}█
┃    └═══════════════════┘
┃    ┌═══════════════════┐
└═>>>█ [${verde}02${negro}] ┃ ${blanco} NO ${negro}█
┃    └═══════════════════┘
┃
└═>>> "${verde}
read -r QUESTION
# ===============================================
#          EXECUTING USER ACTION
# ===============================================
if [[ "${QUESTION}" == "1" || "${QUESTION}" == "01" ]]; then
	SHORT=$(curl -s https://is.gd/create.php\?format\=simple\&url\=${URL})
	echo -e "${SHORT}" >> url.txt
	PROTOCOL=$(tail -n1 url.txt | cut -d "/" -f1)
	DOMAIN=$(tail -n1 url.txt | cut -d "/" -f4)
elif [[ "${QUESTION}" == "2" || "${QUESTION}" == "02" ]]; then
	sleep 0.5
	echo -e "${URL}" >> url.txt
	PROTOCOL=$(head -n1 url.txt | cut -d "/" -f1)
	DOMAIN=$(head -n1 url.txt | cut -d "/" -f3)
else
echo -e "${negro}
┌═══════════════════┐
█ ${rojo} WRONG CHOICE ${negro}█
└═══════════════════┘
"${blanco}
	sleep 0.5
	URLSpoof
	Question
fi
}
# ===============================================
#      IMPOSING URLS WITH SOCIAL ENGINEERING
# ===============================================
Spoofing(){
echo -e -n "${negro}
┌══════════════════════════════┐
█ ${blanco}ENTER WORDS FOR THE URL ${negro}█
└══════════════════════════════┘
┃
└═>>> "${verde}
read -r TEXT
sleep 0.5
WORDS=$(echo -e "${TEXT}" | tr ' ' '-')

if [[ "${QUESTION}" == "1" || "${QUESTION}" == "01" ]]; then
echo -e "${negro}
┌══════════════┐
█ ${verde}URL SPOOFING ${negro}█
└══════════════┘
┃
└═>>>${blanco} ${PROTOCOL}//${WORDS}@is.gd/${DOMAIN}"
else
echo -e "${negro}
┌══════════════┐
█ ${verde}URL SPOOFING ${negro}█
└══════════════┘
┃
└═>>>${blanco} ${PROTOCOL}//${WORDS}@${DOMAIN}"
fi
}
# ===============================================
#            WATCHING URL SPOOFING
# ===============================================
Save(){
if [[ "${QUESTION}" == "1" || "${QUESTION}" == "01" ]]; then
	rm url.txt
	echo -e "${URL} => ${PROTOCOL}//${WORDS}@is.gd/${DOMAIN}" >> spoofing.txt
else
	rm url.txt
	echo -e "${URL} => ${PROTOCOL}//${WORDS}@${DOMAIN}" >> spoofing.txt
fi
echo -e "${negro}
┌════════════════════════════┐
█ ${blanco}URL SAVED IN THE FILE ${negro}█
└════════════════════════════┘
┃
└═>>>${verde} nightsec-out.txt
"${blanco}
}
# ===============================================
#              DECLARE FUNCTIONS
# ===============================================
Dependencies
URL
Question
Spoofing
Save
# ===============================================
#     Modified by NS-R00T - NightSec ©2022
# ===============================================
