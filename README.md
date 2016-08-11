##ROCKMANX4 BOOST (JP) Ver 2016.08.12 (原 "敵加速‧改 Ver2") 使用說明 
- [PC版CheatEngine Trainer下載](https://goo.gl/8xxrPe)
- [PS版PCSX-ReRecording+LuaScript下載](https://goo.gl/HVMISi) 
註：必須搭配日版遊戲使用。

--------------------------------------

#新增功能：
(1) 進入選關畫面or死亡時會把身上的E罐自動補滿。
(2) 逆襲戰打倒任何一隻頭目後會把HP補滿。

#推薦攻略順序：
X: 魟魚→火龍→蜘蛛→之後任意
請務必在打卡尼爾之前取得腳部裝備。(無腳部打得贏，但是相當痛苦。)

Zero:魟魚→火龍→孔雀→貓頭鷹→蜘蛛→磨菇→海象→獅子

#已知Bug；
(1) 貓頭鷹關中頭目：如果用究鎧Nova清怪會發現破圖，然後Boss區域的Warning不會結束。

--------------------------------------

#[PC版]
使用CheatEngine進行記憶體控制。(因為是直接修改遊戲的記憶體，有些防毒軟體會誤認他是病毒。)
對許多敵人有明顯強化，同時對部分關卡有一些改造。
由於許多地方必須要換血甚至分配命數通過，
附上方便的補E機制，沒事多喝E，多喝E沒事。
部分頭目改造過後變得非常困難，請妥善分配關卡順序。

操作方式非常容易，開啟遊戲之後，打開修改器 RMX4BOOST_JP_Ver_20160812.EXE ，(或是安裝Cheat Engine後開啟.CT檔)
按下Ctrl+A，看到BOOST字樣變紅就可以了。

--------------------------------------

#[PS版]
使用PCSX-Rerecording(pcsx-rr)的LuaScript功能進行記憶體控制。
對許多敵人有明顯強化，同時對部分關卡有一些改造。
由於許多地方必須要換血甚至分配命數通過，
附上方便的補E機制，沒事多喝E，多喝E沒事。
部分頭目改造過後變得非常困難，請妥善分配關卡順序。

(1) 點選Configuration→Plugins&Bios，設定pcsx-rr。
重要的有：
BIOS(我習慣使用1001)
控制器(手把必須使用LilyPad，鍵盤估計可以直接設定)
CD-ROM(要載入的X4映像檔要在這裡設定)
※以下兩者可以使用和epsxe一樣的插件，如果有偏好可以直接複製過來
影像(我用預設的TAS Soft Graphics Plugin，請設定自己喜歡的大小，或是推薦Pete系列插件)
聲音(我用預設的TAS Sound Plugin，不過也推薦Eternal SPU Plugin)

(2) 讀取程式碼
File->Lua Scripting->New Lua Script Window，
(或是在打開遊戲後按Ctrl-L叫出這個視窗)
Browse選擇x4boost-20160812.lua，進入遊戲後點選run。

(3) File->Run CD開始進行遊戲
請注意PCSX-RR似乎沒有辦法在遊戲中回到設定畫面。
務必都先設定好再正式開始遊戲。
遊戲進行中可以使用Ctrl+A啟動/取消Boost，狀態會顯示在Lua Script視窗的Output Console。

----------------------------------------------------

以上，祝各位玩家武運昌隆。

Append (鴉片) 2016.08.12

Email: Append@gmail.com

FB: Appendko

※貼心小提醒：PS版X4~X6 Start+Select長按可以回標題畫面


