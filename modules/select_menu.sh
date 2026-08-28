select_menu() {
    local options=("$@")
    local selected=0
    local num_options=${#options[@]}
    
    # Задаем размер видимого окна (сколько строк показывать одновременно)
    local max_visible=60
    local offset=0

    stty -echo
    tput civis
    clear

    while true; do
        tput cup 0 0
        
        # Вычисляем границы видимой области списка
        local end=$((offset + max_visible))
        if [ $end -gt $num_options ]; then
            end=$num_options
        fi

        # Рисуем только видимый диапазон элементов
        for ((i=offset; i<end; i++)); do
            if [ $i -eq $selected ]; then
                printf " > \e[7m %s \e[0m\e[K\n" "${options[$i]}"
            else
                printf "   %s \e[K\n" "${options[$i]}"
            fi
        done

        # Читаем клавишу
        IFS= read -rsN1 key
        if [[ $key == $'\e' ]]; then
            read -rsn2 -t 0.1 rest
            key+="$rest"
        fi

        case "$key" in
            $'\e[A') # Стрелка вверх
                ((selected--))
                if [ $selected -lt 0 ]; then
                    selected=$((num_options - 1))
                    offset=$((num_options - max_visible))
                    [ $offset -lt 0 ] && offset=0
                elif [ $selected -lt $offset ]; then
                    ((offset--))
                fi
                ;;
            $'\e[B') # Стрелка вниз
                ((selected++))
                if [ $selected -ge $num_options ]; then
                    selected=0
                    offset=0
                elif [ $selected -ge $end ]; then
                    ((offset++))
                fi
                ;;
            "" | $'\n' | $'\r')
                break
                ;;
        esac
    done

    stty echo
    tput cnorm
    clear
    REPLY="${options[$selected]}"
}

