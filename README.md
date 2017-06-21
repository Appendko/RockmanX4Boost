![RockmanX4 BOOST logo](https://raw.githubusercontent.com/Appendko/RockmanX4Boost/master/RMX4_Boost_Logo.png)

#RockmanX4 BOOST (JP) Ver 2016.08.14

- (PS) [PCSX-ReRecording+LuaScript](https://goo.gl/WNMZVF)
- (PS) [LuaScript Only](https://goo.gl/f8qz2U) 
- (PC) [CheatEngine Trainer Executable](https://goo.gl/QGURGs)
- (PC) [CheatEngine Trainer](https://goo.gl/Fy3W7U)

This version only works on Japanese version.  
(I'll work on LuaScript for US version MMX4 later.)  

--------------------------------------

##Introduction

RockmanX4 BOOST is a fan-made mod of Rockman X4 (japanese version of Mega Man X4).  
In contrast to most of the ROM-hacks, this mod is done by directly write some bytes into memory blocks.  
For PS version, this is achieved with Lua Script feature in PCSX-ReRecording;  
for PC version, this is achieved by a Cheat Engine-based Trainer.  

This mod is inspired by a video [一部敵がちょっと速い　ロックマンX4](http://www.nicovideo.jp/watch/sm5973813),  
which utilize a set of gameshark codes to reset the cooldown period every single frame.  
This makes the gameplay very different, but it also leads to a lot of problems;  
I then fix most of the problems with lua scripts and also strengthen all of the bosses and some of the enemies,  
extending concept "changing lesser values and making more difference".  
Surely, this is still too simple, but I think it is quite good right now.  

Note that there are many places which is impossible to pass through without any damage;  
I add the feature to refill the subtanks more easily, so please don't hestitate whenever you need it.  

I tried to make the mod to be friendly to every one who can finish the original MMX4 in 3~4 hours;  
hence, please don't hesitate give it a try if you're interested in MMX4!  

--------------------------------------

##Usage
This mod is implemented for PS version first, then ported to PC version using CheatEngine.  
I personally suggest PS version for stability issues; there is still a small chance to crash in PC version.  


##Usage: PS Version
For PS version, I use the Lua Script feature in PCSX-ReRecording(pcsx-rr) to control the memory.  

(1) Setup pcsx-rr: Configuration -> Plugins & Bios  
BIOS: Normally I use SCPH1001.  
Video/Audio: I use defaults (TAS Soft Graphics Plugin/TAS Sound Plugin).  
But you can use anything you like if you're experienced in PSX emulators. 
Controller: I suggest Lilypad, especially if you're using a gamepad.  
CD-ROM: You'll need the RockmanX4 disc, or an RockmanX4 image in ISO or BIN format  
_Hint: You may check **"ecm tools"** if necessary._
 

(2) Loading the Lua Script  
File -> Lua Scripting -> New Lua Script Window, Browse  
(or, if you've begun the gameplay, press CTRL-L to open the Lua script window.)  
Choose "x4boost-20160814.lua", then Press Run.  

(3) File->Run CD  
Note that you cannot go to the settings after you run the game, so do all setup things first.  
You can press CTRL-A to switch on/off the mod anytime,  
and you can see the status in the Output Console in the Lua Script window.  

Hint: Press Start+Select for 5 seconds and you can return to Title screen anytime.  


##Usage: PC Version
For PC version, I use CheatEngine to write bytes into memory directly.  
(Hence it would be alarmed by some anti-virus software. You can decide whether you trust CheatEngine or not.)  
You can choose "CheatEngine Trainer Executable" to run the trainer without installing CheatEngine,  
or choose "[CheatEngine Trainer]" and run the trainer after you install CheatEngine manually.  

It's very easy to use. Just run the game (RMX4.EXE), and open the trainer (executable or CE Trainer),  
Then "PRESS CTRL-A", and you'll find the RED text "BOOST" in the trainer. That's it.  
You have to run the game BEFORE you press CTRL-A.  
You can press CTRL-A to switch on/off the mod anytime.  

--------------------------------------

##New Feature
- Auto-Refill all subtanks everytime you die or you enter a stage/area. 
- Auto-Refill Lifebar after each battle in the bosses refights.

##Suggested order

X: Jet Stingray -> Magma Dragoon -> Web Spidus -> Storm Fukuroul -> Anyone you like.  
Z: Jet Stingray -> Magma Dragoon -> Cyber Kujacker -> Storm Fukuroul -> Web Spidus -> Split Mushroom -> Frost Kibatodos -> Slash BeastLeo  
    
- Remember you can always **get the subtank in Marine Base First**, even if you cannot beat the Stingray.
- If you're using X, it is highly recommended that **get the Foot Parts before fighting Colonel**.
- If you're using Zero and cannot get the subtank in Cyberspace, try it again after you get the Kuuenzan.


##Known Bugs  
- Generaid Core: You may be unable to fight the Storm Owl if you use Ultimate armor X and performed Nova Strikes on Generaid Core.  

--------------------------------------

##THAT's ALL

Yes, that's all.  
**_May the subtanks be with you._**

Append     
Email: Append@gmail.com  
Twitch: http://www.twitch.tv/append
Facebook: https://www.facebook.com/Appendko/

Last Update: June 21st, 2017
