#Sets active power plan to High Performance
powercfg -setactive 8C5E7fda-e8bf-4a96-9a85-a6e23a8c635c
#Disables Hibernation
powercfg -hibernate off
#Changes the value of "Turn off the display:"
powercfg -change -monitor-timeout-ac 0
#Changes the value of "Put the computer to sleep:"
powercfg -change -standby-timeout-ac 0