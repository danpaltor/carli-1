 #!/bin/bash

print_line() { 
    printf "%$(tput cols)s\n"|tr ' ' '-'
} 

pause_function() { 
    print_line
    read -e -sn 1 -p "Press enter to continue..."
} 

loadkeys es
 
timedatectl set-ntp true

# PARTITION THE DISKS
echo "###################################################"
echo "With the command lsblk we discover our harddisks"
echo "###################################################"

lsblk
pause_function

cfdisk

lsblk
pause_function

mkswap /dev/sda1
swapon /dev/sda1

mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3


mount /dev/sda3 /mnt
mount /dev/sda2 /mnt/boot

pacstrap /mnt base base-devel linux linux-firmware nano

genfstab -U /mnt >> /mnt/etc/fstab

less /mnt/etc/fstab

arch-chroot /mnt


ln -sf /usr/share/America/Caracas /etc/localtime

hwclock --systohc

locale-gen


#SHORTER ALTERNATIVE
echo LANG=es_VE.UTF-8 > /etc/locale.conf
echo KEYMAP=es > /etc/vconsole.conf


#SHORTER ALTERNATIVE
echo Archlinux > /etc/hostname



echo 127.0.0.1	localhost > /etc/hosts
echo ::1        localhost >> /etc/hosts
echo 127.0.0.1	Archlinux.localdomain	Archlinux >> /etc/hosts

# NETWORK CONFIGURATION
pacman -S networkmanager
systemctl enable NetworkManager

# ROOT PASSWORD
passwd


# BOOT LOADER
pacman -S grub
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg


# REBOOTING

exit
umount -R /mnt
reboot












