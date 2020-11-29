#! /bin/bash
#This bash compresses and decompresses files
act=-1 #A variable used to transfer which action has been  chosen
action1="COMPRESS"  
action2="DECOMPRESS"  #action1 & 2 both used for certain echoes

function menu { #The menu
    clear
    local title="----------MENU----------"
    local prompt="PLEASE CHOOSE AN OPTION:"
    local options=("$action1" "$action2" "QUIT")

    echo "$title"
    PS3="$prompt" #Changes the default '#?' that the select command uses to $prompt.
    select option in "${options[@]}";do

        case $option in

            ${options[0]})
            echo "YOU CHOSE $option"
            act=0 #Changes act to 0 , to be used later      
            break   
            ;;

            ${options[1]})
            echo "YOU CHOSE $option"
            act=1 #Changes act to 1 , to be used later              
            break;
            ;;
            ${options[2]}) 
            echo "YOU CHOSE $option"
            exit
            ;;
            *)
            echo "INVALID OPTION, PLEASE CHOOSE BETWEEN 1-3"
            ;;
        esac
        break
    done
}

function ynPrompt { #a y/n prompt to go back to the main menu or exit
    while true #helps to loop the y/n prompt in case of wrong input ex. a343
    do  

        read -r -p "DO YOU WANT TO GO BACK TO THE MAIN MENU? [Y/N] " response
        case $response in

             [yY][eE][sS]|[yY]) #accepts yes or y and ignores casing ex. yEs is accepted.
             continue 2     #continues the outer control loop
             ;;
             [nN][oO]|[nN])     #accepts no or n and ignores casing ex. nO is accepted.     
             exit           #exits the script   
             ;;
             *)
             continue           #shows the message again
            ;;      
        esac
        break
    done
}

function main { #Performs the selected action
    if [ $act -eq 0 ]; then

        if zip -r ${path}.zip ${path}   
        then echo Compression successful
        echo $? #prints 0 
        else echo $? 
        fi


        #echo "$action1"
        #zip -r ${path}.zip ${path}

    elif [ $act -eq 1 ]; then

        if unzip ${path} 
        then echo Decompression successful
        echo ${path}
        echo $? #prints 0
        else echo $?
        fi

        #echo "$action2"
        #unzip ${path}


    else 
        echo "$error"
    fi

}



#~~~~~~~~~~~~ Script start ~~~~~~~~~~~~~~~~
while true #outer control loop
    do
    menu #call menu
    cd /home
    path=$(zenity --file-selection) #Stores the path of the file into path variable through zenity dialog 
#path can only be .zip if i had --file filter *.zip

    if [ -z $path ]; then  #checks length of $path , returns true if length = 0 
        ynPrompt #call ynprompt
    else
        main     #call main
    fi

    break
done
