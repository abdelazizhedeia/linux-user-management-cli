#!/bin/bash

# Check root
if [[ $EUID -ne 0 ]]; then
    echo "Run as root!"
    exit 1
fi

while true; do
    OPTION=$(whiptail --title "Main Menu" --menu "Choose an option" 20 60 12 \
    "1" "Add User" \
    "2" "Modify User" \
    "3" "Delete User" \
    "4" "List Users" \
    "5" "Add Group" \
    "6" "Add User to Group" \
    "7" "Delete Group" \
    "8" "List Groups" \
    "9" "Disable User" \
    "10" "Enable User" \
    "11" "Change Password" \
    "12" "About" \
    "0" "Exit" 3>&1 1>&2 2>&3)

    case $OPTION in
        1) # Add User
            USER=$(whiptail --inputbox "Enter username:" 10 50 3>&1 1>&2 2>&3)

            if id "$USER" &>/dev/null; then
                whiptail --msgbox "User already exists!" 10 40
            else
                useradd "$USER" && \
                whiptail --msgbox "User added successfully" 10 40
            fi
            ;;

        2) # Modify User (rename)
            OLD=$(whiptail --inputbox "Enter current username:" 10 50 3>&1 1>&2 2>&3)

            if id "$OLD" &>/dev/null; then
                NEW=$(whiptail --inputbox "Enter new username:" 10 50 3>&1 1>&2 2>&3)

                if id "$NEW" &>/dev/null; then
                    whiptail --msgbox "New username already exists!" 10 40
                else
                    usermod -l "$NEW" "$OLD" && \
                    whiptail --msgbox "User renamed successfully" 10 40
                fi
            else
                whiptail --msgbox "User not found!" 10 40
            fi
            ;;

        3) # Delete User
            USER=$(whiptail --inputbox "Enter username to delete:" 10 50 3>&1 1>&2 2>&3)

            if id "$USER" &>/dev/null; then
                userdel "$USER" && \
                whiptail --msgbox "User deleted successfully" 10 40
            else
                whiptail --msgbox "User does not exist!" 10 40
            fi
            ;;

        4) # List Users
            USERS=$(cut -d: -f1 /etc/passwd)
            whiptail --msgbox "$USERS" 20 60
            ;;

        5) # Add Group
            GROUP=$(whiptail --inputbox "Enter group name:" 10 50 3>&1 1>&2 2>&3)

            if getent group "$GROUP" > /dev/null; then
                whiptail --msgbox "Group already exists!" 10 40
            else
                groupadd "$GROUP" && \
                whiptail --msgbox "Group added successfully" 10 40
            fi
            ;;

        6) # Add User to Group
            USER=$(whiptail --inputbox "Enter username:" 10 50 3>&1 1>&2 2>&3)
            GROUP=$(whiptail --inputbox "Enter group:" 10 50 3>&1 1>&2 2>&3)

            if ! id "$USER" &>/dev/null; then
                whiptail --msgbox "User not found!" 10 40
            elif ! getent group "$GROUP" > /dev/null; then
                whiptail --msgbox "Group not found!" 10 40
            else
                usermod -aG "$GROUP" "$USER" && \
                whiptail --msgbox "User added to group" 10 40
            fi
            ;;

        7) # Delete Group
            GROUP=$(whiptail --inputbox "Enter group to delete:" 10 50 3>&1 1>&2 2>&3)

            if getent group "$GROUP" > /dev/null; then
                groupdel "$GROUP" && \
                whiptail --msgbox "Group deleted successfully" 10 40
            else
                whiptail --msgbox "Group not found!" 10 40
            fi
            ;;

        8) # List Groups
            GROUPS=$(cut -d: -f1 /etc/group)
            whiptail --msgbox "$GROUPS" 20 60
            ;;

        9) # Disable User
            USER=$(whiptail --inputbox "Enter username to lock:" 10 50 3>&1 1>&2 2>&3)

            if id "$USER" &>/dev/null; then
                usermod -L "$USER" && \
                whiptail --msgbox "User locked" 10 40
            else
                whiptail --msgbox "User not found!" 10 40
            fi
            ;;

        10) # Enable User
            USER=$(whiptail --inputbox "Enter username to unlock:" 10 50 3>&1 1>&2 2>&3)

            if id "$USER" &>/dev/null; then
                usermod -U "$USER" && \
                whiptail --msgbox "User unlocked" 10 40
            else
                whiptail --msgbox "User not found!" 10 40
            fi
            ;;

        11) # Change Password
            USER=$(whiptail --inputbox "Enter username:" 10 50 3>&1 1>&2 2>&3)

            if id "$USER" &>/dev/null; then
                passwd "$USER"
            else
                whiptail --msgbox "User not found!" 10 40
            fi
            ;;

        12)
            whiptail --msgbox "User Management Tool\n(Bash + Whiptail)" 10 50
            ;;

        0)
            break
            ;;
    esac
done
