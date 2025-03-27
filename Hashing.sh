#!/bin/bash

AZ='\033[0;34m'
BL='\033[1;37m'
RS='\033[0m'

gen_salt() {
    openssl rand -hex 16
}

gen_ppr() {
    (date +%s; cat /proc/sys/kernel/random/uuid; echo $RANDOM) | sha256sum | base64 | head -c 32
}

gen_hash() {
    local inp="$1"
    local salt="$2"
    local ppr="$3"
    local hsh_val=0
    local itr=5

    for ((i=0; i<${#inp}; i++)); do
        local chr_asc=$(printf "%d" "'${inp:$i:1}")
        
        for ((j=0; j<itr; j++)); do
            chr_asc=$((chr_asc * 0x5bd1e995))
            hsh_val=$((hsh_val ^ chr_asc))
            hsh_val=$(((hsh_val << 13) | (hsh_val >> 19)))
            hsh_val=$((hsh_val | (chr_asc & 0xFFFF)))
            hsh_val=$((hsh_val ^ (chr_asc << 7)))
        done
        
        hsh_val=$((hsh_val % 4294967296))
    done

    hsh_val=$((hsh_val ^ $(echo -n "$salt" | cksum | cut -d' ' -f1)))
    hsh_val=$((hsh_val ^ $(echo -n "$ppr" | cksum | cut -d' ' -f1)))

    printf "%x\n" "$hsh_val"
}

sv_salt_ppr() {
    local salt=$(gen_salt)
    local ppr=$(gen_ppr)
    
    echo "$salt" > salt.txt
    echo "$ppr" > pepper.txt
    
    clear
    echo -e "${AZ}"
    cat << "EOF"

   _____                           _   _               _____ _____   _____ 
  / ____|                         | | (_)             |_   _|  __ \ / ____|
 | |  __  ___ _ __   ___ _ __ __ _| |_ _ _ __   __ _    | | | |  | | (___  
 | | |_ |/ _ \ '_ \ / _ \ '__/ _` | __| | '_ \ / _` |   | | | |  | |\___ \ 
 | |__| |  __/ | | |  __/ | | (_| | |_| | | | | (_| |  _| |_| |__| |____) |
  \_____|\___|_| |_|\___|_|  \__,_|\__|_|_| |_|\__, | |_____|_____/|_____/ 
                                                __/ |                      
                                               |___/                       
  
EOF
    echo -e "${RS}"
    echo -e "${AZ}===== GENERACIÓN DE SALT Y PEPPER =====${RS}"
    echo -e "${BL}Salt generado: $salt${RS}"
    echo -e "${BL}Pepper generado: $ppr${RS}"
    echo -e "${AZ}PRECAUCIÓN: Guarde estos valores de forma segura${RS}"
    read -p "Pulse Enter: " 
}

ld_salt_ppr() {
    if [[ -f salt.txt && -f pepper.txt ]]; then
        salt=$(cat salt.txt)
        ppr=$(cat pepper.txt)
        return 0
    else
        echo -e "${AZ}No se encontraron archivos de Salt o Pepper${RS}"
        return 1
    fi
}

shw_menu() {
    clear
    echo -e "${AZ}"
    cat << "EOF"

  _    _           _     _               _____           _            _   _             
 | |  | |         | |   (_)             |  __ \         | |          | | (_)            
 | |__| | __ _ ___| |__  _ _ __   __ _  | |__) | __ ___ | |_ ___  ___| |_ _  ___  _ __  
 |  __  |/ _` / __| '_ \| | '_ \ / _` | |  ___/ '__/ _ \| __/ _ \/ __| __| |/ _ \| '_ \ 
 | |  | | (_| \__ \ | | | | | | | (_| | | |   | | | (_) | ||  __/ (__| |_| | (_) | | | |
 |_|  |_|\__,_|___/_| |_|_|_| |_|\__, | |_|   |_|  \___/ \__\___|\___|\__|_|\___/|_| |_|
                                  __/ |                                                 
                                 |___/                          By: ALetsee                         
                                      
                      
EOF
    echo -e "${RS}"
    echo -e "${AZ}===== GENERADOR DE HASH PERSONALIZADO =====${RS}"
    echo -e "${BL}1. Generar Hash${RS}"
    echo -e "${BL}2. Generar Nuevo Salt y Pepper${RS}"
    echo -e "${BL}3. Salir${RS}"
    echo -e "${AZ}==========================================${RS}"
    read -p "Seleccione opción: " choice
}

gen_hash_animation() {
    clear
    echo -e "${AZ}"
    cat << "EOF"


  _    _           _     _             
 | |  | |         | |   (_)            
 | |__| | __ _ ___| |__  _ _ __   __ _ 
 |  __  |/ _` / __| '_ \| | '_ \ / _` |
 | |  | | (_| \__ \ | | | | | | | (_| |
 |_|  |_|\__,_|___/_| |_|_|_| |_|\__, |
                                  __/ |
                                 |___/ 
      
                                    

EOF
    echo -e "${RS}"
    echo -e "${AZ}Preparando generación de hash...${RS}"
    sleep 1
    
    for i in {1..3}; do
        echo -ne "${BL}Procesando${RS}"
        for j in {1..3}; do
            echo -ne "."
            sleep 0.5
        done
        echo -ne "\r                   \r"
    done
}

while true; do
    shw_menu

    case $choice in
        1)
            gen_hash_animation
            clear
            if ld_salt_ppr; then
                read -p "Ingrese Salt: " -s usr_salt
                echo
                read -p "Ingrese Pepper: " -s usr_ppr
                echo

                if [[ "$usr_salt" != "$salt" ]]; then
                    echo -e "${AZ}Error: El Salt no coincide${RS}"
                    read -p "Pulse Enter: " 
                    continue
                fi

                if [[ "$usr_ppr" != "$ppr" ]]; then
                    echo -e "${AZ}Error: El Pepper no coincide${RS}"
                    read -p "Pulse Enter: " 
                    continue
                fi

                read -p "Texto a hashear: " usr_inp
               clear
echo -e "${AZ}"
cat << "EOF"


  _    _           _              _ 
 | |  | |         | |            | |
 | |__| | __ _ ___| |__   ___  __| |
 |  __  |/ _` / __| '_ \ / _ \/ _` |
 | |  | | (_| \__ \ | | |  __/ (_| |
 |_|  |_|\__,_|___/_| |_|\___|\__,_|
                                    
                                    

      
                                    

EOF
echo -e "${RS}"
echo -e "${AZ}Hash generado: $(gen_hash "$usr_inp" "$salt" "$ppr")${RS}"
read -p "Pulse Enter: "

            fi
            read -p "Pulse Enter: " 
            ;;
        2)
            sv_salt_ppr
            ;;
        3)
            echo -e "${AZ}Saliendo del programa...${RS}"
            exit 0
            ;;
        *)
            echo -e "${AZ}Opción inválida. Presione Enter para continuar...${RS}"
            read -p "Pulse Enter: " 
            ;;
    esac
done