#!/bin/sh
if [ "$USER" = "guest" ]
then
   rm -rf /home/guest
   # copy files from skel
   cp -r /etc/skel /home/guest
   chown -R guest:guest /home/guest
else
   # copy files from skel (if do not exist)
   sudo -u "$USER" cp -rn /etc/skel/. "$HOME"
fi
# create defaults dirs
sudo -u "$USER" xdg-user-dirs-update
# remove empty default directories
rmdir "$HOME/Documents" "$HOME/Images" "$HOME/Modèles" "$HOME/Musique" "$HOME/Public" "$HOME/Vidéos"
exit 0
