#!/bin/sh

echo "what will you call this computer"
read sys_name
echo "do you have a UEFI system [y/n]"
read boot_ans

echo "setting up timezone"
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc

echo "creating locales"
echo "en_US-UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "installing networkmanager"
systemctl enable NetworkManager

echo "$sys_name" > /etc/hostname

if [ "$boot_ans" == "y" ]; then
	echo "installing grub"
	pacman -S grub efibootmgr
	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
else
	echo "installing grub"
	pacman -S grub
	grub-install --target=i386-pc $drive
fi


echo "enter a username"
read user_name

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
useradd -m -g wheel $user_name
passwd $user_name

sleep 1

echo "basic installation finished"
