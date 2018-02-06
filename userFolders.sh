#!/bin/bash
sleep 10s

create_link() {
    local target=$1
    local link=$2
    ln -sf $target $link
}

variable="$(getent group lightfoot | cut -d':' -f4)"
IFS=","
for name in $variable
do
getent passwd | egrep -i $name
  if [ $? -eq 0 ]; then
      mkhomedir_helper $name
      if [[ -h "/home/$name/sdal" ]]; then
          unlink /home/$name/sdal;
      fi
      create_link /home/sdal /home/$name/sdal
  fi
done


