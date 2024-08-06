#!/bin/bash

yay -S --noconfirm --needed btrfs-assistant-git
yay -S --noconfirm --needed grub-btrfs
yay -S --noconfirm --needed snap-pac-git
yay -S --noconfirm --needed snapper
yay -S --noconfirm --needed snap-pac-grub

sudo snapper -c root create-config /

echo "${INFO} First manual snapshot"

sudo snapper -c root create --description "initial snapshot"

sudo chmod a+rx /.snapshots
sudo chown :users /.snapshots
