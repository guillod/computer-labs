#!/bin/sh
if [ "$USER" = "guest" ]; then
   rm -rf /home/guest
fi
exit 0
