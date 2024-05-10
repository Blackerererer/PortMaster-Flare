#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
source $controlfolder/device_info.txt
get_controls

GAMEDIR=/$directory/ports/drillbertiidiggeredoo

export XDG_DATA_HOME="$GAMEDIR/saves" # allowing saving to the same path as the game
export XDG_CONFIG_HOME="$GAMEDIR/saves"
export LD_LIBRARY_PATH="$GAMEDIR/libs.${DEVICE_ARCH}:$LD_LIBRARY_PATH"

cd $GAMEDIR

$GPTOKEYB "love.${DEVICE_ARCH}" -c "./drillbertiidiggeredoo.gptk" &
./bin/love.${DEVICE_ARCH} gamedata 2>&1 | tee -a ./log.txt

$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" > /dev/tty0


