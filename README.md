![default|690x93](https://forum-cfx-re.akamaized.net/original/5X/f/f/1/8/ff180d0cc4104c2085b23fa740e64677dd7b3bde.jpeg)

Good evening! I'm putting a free HUD script at your disposal. I made it pretty quickly, so if there's any problem, don't hesitate to let me know! I know I'm not an optimization pro.

You can ask me to add things as needed, I don't mind and it will make the script more complete as time goes by!

The script is partly configurable, both technically and visually.

![colored|690x95](https://forum-cfx-re.akamaized.net/original/5X/2/9/1/a/291a5f75c285c1cdbf2be0bbe0d774f1701398d1.jpeg)
![colorconfig|350x328](https://forum-cfx-re.akamaized.net/original/5X/6/0/1/7/6017eb7c2d557d65d2f9d525f74fb60c42891c63.png)

# Exports
**This is a standalone script, so here are a few exports to help you manage the display with your own scripts.**
```lua
exports["jordqn_hud"]:bypassRadar(boolean) -- Allows you to activate or deactivate, via your scripts, the fact of having the radar permanently outside your vehicles (if the option is active, of course).
exports["jordqn_hud"]:setThirst(value) -- Set thirst level.
exports["jordqn_hud"]:setHunger(value) -- Set hunger level.
exports["jordqn_hud"]:setVoiceDistance(0, 1, 2, 3) -- Set voice distance on HUD. (0 = mute, 1 = short, 2 = medium, 3 = long)
exports["jordqn_hud"]:setVoiceTalking(boolean) -- Displays whether the player is speaking or not.
exports["jordqn_hud"]:setVoiceRadio(boolean) -- Displays whether the player is speaking on the radio or not.
exports["jordqn_hud"]:setSeatBelt(boolean) -- Defines whether the belt is fastened or not.
exports["jordqn_hud"]:hudVisibility(boolean) -- Defines whether the HUD is visible or not.
```

**PS: The fuel level is managed by your vehicle's handling and via the native GetVehicleFuelLevel. If you use another method to manage your fuel, please don't hesitate to contact me so we can look into it together.**

# Previews
In vehicle preview: https://streamable.com/fpkn4t
In water preview: https://streamable.com/4hm6j4

# Configuration
![image|417x500](https://forum-cfx-re.akamaized.net/original/5X/8/1/0/3/81038e673bd7a9826cae2892916b4ae555f681b7.png)
![image|415x500](https://forum-cfx-re.akamaized.net/original/5X/a/d/f/b/adfbf249e0fa6827fab06a82d5dc18bb4755ce64.png)

This script works with [nearest-postal](https://github.com/DevBlocky/nearest-postal/tree/master) zips codes.
