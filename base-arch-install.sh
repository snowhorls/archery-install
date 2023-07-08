#!/bin/sh


echo "Welcome to my install script"


echo "connect to the internet"
iwctl

lsblk
echo "enter the drive"
read drive

echo "please create your partition layout"
fdisk $drive


echo "creating the file systems"
sleep 1

echo "where is your root partition"
read root_part

echo "where is your home partition"
read home_part

echo "where is your swap partition"
read swap_part

mkfs.ext4 $root_part
mkfs.ext4 $home_part

mkswap $swap_part
swapon $swap_part

echo "done"

echo "do you have an UEFI system [y/n]"
read boot_ans

if [ "$boot_ans" == "y" ]; then
	echo "what is your efi partition"
	read efi_part
	mkfs.fat -F 32 $efi_part
	mount --mkdir $efi_part /mnt/boot
fi

echo "mounting the partitions..."

mount $root_part /mnt
mount --mkdir $home_part /mnt/home
echo "done"

sleep 1

echo "installing base packages"
pacstrap /mnt base base-devel linux linux-firmware

echo "generating fstab file"
genfstab -U /mnt >> /mnt/etc/fstab
systemctl daemon-reload

echo "chrooting into new envirment"
cp ~/archery/arch-install.sh /mnt
chmod +x /mnt/arch-install.sh
arch-chroot /mnt ./arch-install.sh
