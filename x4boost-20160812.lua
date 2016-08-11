--ROCKMANX4 BOOST (JP) Ver 2016.08.12
fullhp=false --放最上面方便調整
function background_display(switch) --0x01 or 0x00
	memory.writebyte(0x141A93,switch);
	memory.writebyte(0x141AE7,switch);
	--memory.writebyte(0x141B3B,switch);
end

function player_display(switch) --0x01 or 0x00
	memory.writebyte(0x1419AB,switch);
	if switch==0x00 then memory.writebyte(0x141A34,switch); end
end

function scroll_speed(speed)
	memory.writebyte(0x141AD7,speed);
end

function timer_1(addr)
	timer1byte=memory.readbyte(addr);
	if timer1byte > 0x02 then
		memory.writebyte(addr,0x01);
	end
end

function timer_2(addr)
	 --D313C02C 000F E113C02C 00FF 8013C02C 0001--not implement
	--Timer2[[D313C0C8 000F 3013C0C8 0001]]--
	timer2byte=memory.readbyte(addr+0x38);
	timer2word=memory.readword(addr+0x38);
	if (timer2word > 0x000F) then
			memory.writeword(addr+0x38,0x01);
	end
end

function timer_3(addr)
	--Timer3[[E113C033 0080 E113C033 0000 E113C033 00FF E313C033 0012 3013C033 0001]]--
	timer3=memory.readbyte(addr+0x3F);	
	if (timer3 ~= 0x80) and (timer3 ~= 0x00) and (timer3 ~= 0xFF) and (timer3 > 0x12) then
		memory.writebyte(addr+0x3F,0x01);
	end	
end

function timer(addr)
	timer_1(addr);
	timer_2(addr);
	timer_3(addr); 
end

function fill_hp()
	memory.writebyte(0x141A04,memory.readbyte(0x1722BE)); --滿HP
end

function fill_subtank()
	--Lua 5.1 does not have bitwise operation: need to divide manually
	--1722D3 Byte Subtank 10 20 40 80
	--1722D4 E(1) 1722D5 E(2) 1722D6 W
	subtank=math.floor(memory.readbyte(0x1722D3)/16);
	--1/2/4/8 
	if subtank%2 == 1 then
		memory.writebyte(0x1722D4,0x20); --滿E(1)
	end
	subtank=math.floor(subtank/2);
	if subtank%2 == 1 then
		memory.writebyte(0x1722D5,0x20); --滿E(2)
	end
	subtank=math.floor(subtank/2);
	if subtank%2 == 1 then
		memory.writebyte(0x1722D6,0x20); --滿W
	end
	--分別判斷兩個E罐一個W罐存在 如果有的話把內容補滿
end

function boost_switch(boost_value)
	if keypress~=true then
		if boost_value==true then
			boost=false
			print "Boost OFF, welcome back to normal world!"
			print ""
		else
			boost=true
			print "BOOST ON, May the E-tanks be with you. GOOD LUCK."
			print ""
		end
	end
	keypress=true
end

print "ROCKMANX4 BOOST (JP) Ver 2016.08.12"
print "Pleass press Ctrl+A to switch ON/OFF."
print ""
boost=nil;
keypress=nil;
boost_switch(boost) --Boost ON

while true do
key=input.get();
if keypress==nil and key["A"]==true and key["control"]==true then
	boost_switch(boost)
end
if keypress==true and key["A"]~=true then
	keypress=nil
end

if boost==true then
	--手把狀態 目前沒有用到 備用
	pad=joypad.get(1);
	current_frame=pcsx.framecount();
	--滿血方便測試
	if fullhp==true then
		fill_hp();
	end
	
	--高速補E 0命0HP時當前E罐W罐補滿 MaxHP:0x1722BE
	--HP: 0x141A04  Lives: 0x1722BC
	current_Lives=memory.readbyte(0x1722BC);
	current_HP=memory.readbyte(0x141A04);
	checkpoint=memory.readbyte(0x172295);
	stage_modifier=memory.readbyte(0x172284);
	area_modifier=memory.readbyte(0x172285);
	--Stage Modifier 0x172284 Area 0x172285 0/1 Checkpoint 0x172295
	--00 Sky Lagoon / 01 Jungle / 02 Snow Base / 03 Bio Lab / 04 Volcano
	--05 Marine Base / 06 Cyber Space / 07 Air Force / 08 Military Train / 09 (估計是Memory Hall)
	--0A Space Port / 0B Final Weapon 1 / 0C Final Weapon 2 / 0D 選關 / 0E TITLE
	
	
	if stage_modifier==0x04 and (area_modifier~=0x01 or checkpoint~=0x03) then
		--火龍關，火球物件產生加速
		addr=0x14308C --原本選0x1432CC/0x0F
		for i = 0,20 do
			if memory.readbyte(addr) > 0x17 then
				memory.writebyte(addr,0x17) 
			end
			addr=addr+0x30
		end
	elseif stage_modifier==0x06 and area_modifier==0x00 and current_HP > 0x00 then --孔雀關ACT1
		if checkpoint==0x00 then
			if current_frame % 120 < 60 then background_display(0x01); else background_display(0x00); end
		elseif checkpoint==0x02 then
			if current_frame % 120 < 60 then player_display(0x00); else player_display(0x01); end
		elseif checkpoint==0x04 then
			if current_frame % 120 < 60 then background_display(0x01); player_display(0x00);
			else background_display(0x00); player_display(0x01); end
		end
	
	elseif stage_modifier==0x05 and checkpoint==0x00 then--魟魚關車段
		scroll_speed(0x09)
	elseif stage_modifier==0x0D then	
		fill_subtank();--滿E罐
	elseif stage_modifier==0x0C then --再checkpoint是1的時候滿HP 老西面前可以滿E checkpoint位址要找
		if (area_modifier==0x00 and (checkpoint<0x02 or checkpoint>0x09) )then
			--滿HP MaxHP:0x1722BE
			--checkpoint 02~09是八大頭目
			--02 Magma Dragoon	--03 Cyber Peacock 	--04 Split Mushroom 	--05 Jet Stingray
			--06 Storm Owl		--07 Web Spider		--08 Slash Beast		--09 Frost Walrus
			fill_hp();
		end
	end
	
	--死亡把E罐補滿--分別判斷兩個E罐一個W罐存在 如果有的話把內容補滿
	if current_HP==0x00 then 
		fill_subtank();
	end
	
	
	--修改敵人數據 第一隻位置固定0x13BFF4(雖然顯然不是起點 但是是某個計數器) 每隻9C格
	addr=0x13BFF4;
	for i = 0,12 do
		--3013BFF4 0001
		case=0 --default
		--enemyid=memory.readdword(0x13BFE0);
		enemyid=memory.readdword(addr-0x14);
		if (i==0) then --First Enemy: identify bosses
			--D313C02C 000F E113C02C 00FF 8013C02C 0001--
			if enemyid==(0x80105950) then
				case=1 --Sigma(Final), but treat as default now.
				if memory.readbyte(addr+0x18)==0 then
				case=20
				end
			elseif enemyid==(0x800FF640) then
				case=2 --Web Spider, ID 800FF640, do not boost before HP>0
			elseif enemyid==(0x801020CC) then
				case=3 --Split Mushroom (分身也是801020CC) --13C010 05走 06滾跳 --13C011 00正常 01無敵 --13C037 彈跳次數 02可以彈來彈去 01會盡早下來
			elseif enemyid==(0x80103558) then --magma dragoon 13C03D套路配置
				case=4 --暫且共用
			elseif enemyid==(0x80101BA8) then --storm owl 套路配置
				case=5			
			elseif enemyid==(0x801013D8) then --frost walrus
				case=6 --frost walrus		
			elseif enemyid==(0x80100DC0) then 
				case=7 --Jet Stingray
			elseif enemyid==(0x80103C84) then 
				case=8 --80103C84 Iris
			elseif enemyid==(0x801043CC) then 
				case=9 --801043CC Sigma 1		
			elseif enemyid==(0x800FAEA4) then 
				case=197 --Intro Stage Boss
			elseif enemyid==(0x800FFA54) then 
				case=198 --mid boss of slash beast
			elseif enemyid==(0x800FC3F0) then 
				case=199 --mid boss of frost walrus
			elseif enemyid==(0x800FE020) then
				case=200 --mid boss of split mushroom
			end
		end
	
		if case==0 then --default		
			--addr=0x13BFF4;
			timer(addr)
			--80104D9C大型機甲兵 --enemyid=memory.readdword(0x13BFE0);
			if enemyid==0x80104D9C then
				if memory.readbyte(addr+0x48) > 1 then
					memory.writebyte(addr+0x48,1)
				end
			end
			--蜂巢 0x800FCBC4
			if enemyid==0x800FCBC4 then
				if memory.readbyte(addr+0x40) > 0x02 then
					memory.writebyte(addr+0x40,0x01)
				end
			end
			--小矮兵 0x800FBC88
			if enemyid==0x800FBC88 then
				if(memory.readword(addr-0x22)==0x0001) then --horizontal speed? 0x13BFD2 C06E C10A C1A6 C242
					memory.writeword(addr-0x22,0x0005) --horizontal speed?
				elseif(memory.readword(addr-0x22)==0xFFFF) then --horizontal speed?
					memory.writeword(addr-0x22,0xFFFB) --horizontal speed?
				end			
			end
			--小蝙蝠 0x800FDE44
			if enemyid==0x800FDE44 then
				if(memory.readword(addr-0x22)==0x0003) then --horizontal speed?
					memory.writeword(addr-0x22,0x0009) --horizontal speed?
				elseif(memory.readword(addr-0x22)==0xFFFD) then --horizontal speed?
					memory.writeword(addr-0x22,0xFFF7) --horizontal speed?
				end			
			end
		end	
		
		if case==1 then --sigma --13C02C 雷射炮次數 5 4 3 2 1 0 13C045:雷射炮on off
			phase=memory.readbyte(0x13C046);    --當前敵人 7,0gun 1,2head 3,4ground 5,6head
			headphase=memory.readbyte(0x13C03C) --三頭的出現phase 0appear, 1standby, 2action, 3dissappear -0x13C03D 0~7 different set of heads
			headtype=memory.readbyte(0x13C03D)  --三頭配置 00:火 01:雷 02:冰 03:掃射 05:雷射炮x5 06吹風 07吸
			if(phase==0) then  --如果是雷射槍老西  搭配藍頭
				memory.writebyte(0x13C03D,2) --搭配藍頭
				if(headphase==0) then		 --phase0的出現
					memory.writebyte(0x13C03C,2) --改成phase2的使用動作
				end
			end
			if headtype<6 and headtype~=8 then --只要不是大頭就用原本的timer
				timer(addr)
			else --是大頭 timer1和3可以繼續用 2的部分修改成手動減frame 相當於時間減半
				timer_1(addr)
				--timer_2(addr)
				timer_3(addr)
				timer2word=memory.readword(0x13C02C);
				if (timer2word > 0x000F) then				
					memory.writeword(0x13C02C,memory.readword(0x13C02C)-1);
				end
			end
			
		
		end
		
		if case==2 then --Web Spider (分身也是801020CC)
			if flagstart then		
				timer_1(addr);
				timer_2(addr);
				timer_3(addr);
				if memory.readbyte(0x13C02C)>0x01 then --額外加速 
					memory.writebyte(0x13C02C,0x01);
				end
			end
			if memory.readbyte(0x13C00C)==0x00 then
				flagstart=false -- 一定會從00開始 當作在歸零
			elseif memory.readbyte(0x13C00C)==0x30 then
				flagstart=true  --一定會從0x30開始戰鬥 當作在歸零
				--flagweb=false --沒有用到了
			end
		end
		
		if case==3 then --Split Mushroom (分身也是801020CC)
			if memory.readbyte(addr+0x18)~=0x00 then
				timer(addr);
			end
		--13C010 05走 06滾跳 --13C011 00正常 01無敵 --13C037 彈跳次數 02可以彈來彈去 01會盡早下來
		end
		if case==4 then  --magma dragoon 13C03D套路配置
			if memory.readbyte(addr+0x18)~=0x00 then
				timer(addr);
			end
			--memory.writebyte(0x13C03D, 0x03)
		end
		if case==5 then -- Storm Owl: enemyid==(0x80101BA8)
		--0x13C03A=12:大龍捲 9:電風扇 3飛入 4抓取 5飛走 6丟一顆球 7四風球(C03D計數器) 8子彈連射
			owl_status=memory.readbyte(0x13C03A)
			--四風球模組2
			if(owl_status==0x07) then --四風球
				memory.writebyte(0x13C03E, 0x01)
				if ballcount==nil then
					ballcount=0;
				end
				if(memory.readbyte(0x13C03D)==0x03) then --四風球
					ballcount=ballcount+1 --(2+ballcount的個數)
					if ballcount<5 then --風球七連射
						memory.writebyte(0x13C03D, 0x02) --往回一格	
					else 
						memory.writebyte(0x13C03D, 0x04) --往回一格	
					end
				end
				if(pcsx.framecount()%8==0) then
				timer(addr)
				end
			else
				ballcount=0;
			end
			if(owl_status==3 or owl_status==4 or owl_status==5 or owl_status==6 or owl_status==8 or owl_status==12) then
				timer(addr)
			end
			if(owl_status==0x09) then --電風扇:+1
				--memory.writebyte(0x13C040,math.random(0,15)) 電風扇亂舞	
				if(pcsx.framecount()%10==0) then
					memory.writebyte(0x13C040, (memory.readbyte(0x13C040)+1)%16 )
				end
			end
		end
		if case==6 then --frost walrus
			walrus_status=memory.readbyte(0x13C038); 
			--8D準備8E走路8F撲 91準備92走路93拍拍撲 
			--9B冰刺 95走路 96撲 97冰刺 99走路 9A拍拍撲
			--9D走路9E噴冰9F噴冰A0拍拍撲 A5走路A6噴冰A7滑撲 
			--A9走路AA冰刺AB滑撲 AD走路 AE冰刺 AF冰刺 B0拍拍撲
			--B5火燒後滑撲 B6回位 B8準備 B9吐霧 BA回位
			--記得往前推一格	
			timer_1(addr);
			timer_3(addr);
			if(pcsx.framecount()%120<30) then
			memory.writebyte(0x13C038,0x8E)
			elseif(pcsx.framecount()%120<60) then
			memory.writebyte(0x13C038,0x92)
			elseif(pcsx.framecount()%120<90) then
			memory.writebyte(0x13C038,0x9E)		
			else
			memory.writebyte(0x13C038,0x9E)
			end
			if(walrus_status==0x9E or walrus_status==0xA5) then --噴冰 13C038=0x9E --13C02E=0x10 --13F490=0x01 --13C02C change
				memory.writebyte(0x13C02E,0x10)
				memory.writebyte(0x13F490,0x01)
				if(memory.readbyte(0x13C02C)>0x41) then --C02C倒數 40時集冰 0時放出
					memory.writebyte(0x13C02C,0x41)
				elseif(memory.readbyte(0x13C02C)>0x39) then
					memory.writebyte(0x13C02C,0x01)
				end
			end
			if(memory.readword(addr-0x22)>0xFF00) then --horizontal speed?
				memory.writeword(addr-0x22,0xFFFC) --horizontal speed?
			elseif(memory.readword(addr-0x22)>0) then --horizontal speed?
				memory.writeword(addr-0x22,0x0004) --horizontal speed?
			end					
		end
		if case==7 then --Jet Stingray
			--C00C是HP
			--C010似乎是衝刺 6一般7飛行 C004也有這現象 84/A8
			--C02E似乎是小魚數量 03020100
			--C034 D1放魚 D2衝刺 D5放魚 D6下水 DD放紅魚 DE下水 E1放紅魚 E2亂衝
			stingray_status=memory.readbyte(0x13C034); 
			stingray_hp=memory.readbyte(0x13C00C); 
			if(stingray_hp>12) then -- HP48~12之間持續衝刺加速
				speed=9+(48-stingray_hp)*9/36;
			else --HP12以下固定兩倍衝刺速度
				speed=18
			end
			if(memory.readbyte(0x13C034)==0xE2) then --上下衝
				if(memory.readword(0x13BFD6)==0xFFF7) then --Vertical speed?
					memory.writeword(0x13BFD6,-speed) --Vertical speed?
				elseif(memory.readword(0x13BFD6)==0x0009) then --Vertical speed?
					memory.writeword(0x13BFD6,speed) --Vertical speed?
				end
			end
			--橫衝
				if(memory.readword(0x13BFD2)==0x0006) then --horizontal speed?
					memory.writeword(0x13BFD2,speed) --horizontal speed?
				elseif(memory.readword(0x13BFD2)==0xFFFA) then --horizontal speed?
					memory.writeword(0x13BFD2,-speed) --horizontal speed?
				end
			--拋物線
			if(memory.readbyte(0x13BFDD)==0xBE) then
				if(pcsx.framecount()%8==0) then
					memory.writeword(0x13BFD6,memory.readword(0x13BFD6)+1);--Vertical speed?
				end
				if(memory.readword(0x13BFD2)==0x0005) then --horizontal speed?
					memory.writeword(0x13BFD2,speed) --horizontal speed?
				elseif(memory.readword(0x13BFD2)==0xFFFB) then --horizontal speed?
					memory.writeword(0x13BFD2,-speed) --horizontal speed?
				end
			elseif(memory.readbyte(0x13BFDD)==0x30) then
				if(memory.readword(0x13BFD6)==0xFFFE) then --Vertical speed?
					memory.writeword(0x13BFD6,0xFFEF) --Vertical speed?
				end
			end
			
			if(stingray_status==0xC9 or stingray_status==0xD1) then
				memory.writebyte(0x13C034,0xE1);
				memory.writebyte(0x13C02E,0x00);
			end
			if(memory.readbyte(0x13C02E)==0x03) then
				fishcount=0;
			elseif(memory.readbyte(0x13C02E)==0x01) then
				memory.writebyte(0x13C02E,0x02);
				fishcount=fishcount+1 --魚數是fishcount+2
				if(fishcount==8) then 
					memory.writebyte(0x13C02E,0x00);
				end
			end
			timer(addr);
			--timer_1(addr);
			--timer_2(addr);
			--timer_3(addr);
		end
		if case==8 then --Iris
			timer(addr);
			if memory.readbyte(0x13C035)>0xC0 then --0x13C035砲擊前置時間
				memory.writebyte(0x13C035,0xC0);
			end
			memory.writebyte(0x13C034,0x00); --小怪數統計
		end
		if case==9 then --Sigma1&Sigma2
			if(memory.readbyte(0x13BFB2)==0x00) then --sigma1
				timer(addr);
				if(memory.readbyte(0x13C03C)==0x00) then
					ballcount=0;
				elseif(memory.readbyte(0x13C03C)==0x02) then
					memory.writebyte(0x13C03C,0x01);
					ballcount=ballcount+1 
					if(ballcount>50) then 
						memory.writebyte(0x13C03C,0x02);
					end
				end
			else --sigma2
				memory.writebyte(0x13C03F,math.random(0,2))
			end
		end
		if case==197 then --Intro Stage Boss
			timer(addr);
			if(memory.readword(0x13BFD2)==0x0008) then --horizontal speed?
				memory.writeword(0x13BFD2,0x0010) --horizontal speed?
				memory.writeword(0x13BFD6,0xFFFE) --vertical speed?
			elseif(memory.readword(0x13BFD2)==0xFFF7) then --horizontal speed?
				memory.writeword(0x13BFD2,0xFFF0) --horizontal speed?
				memory.writeword(0x13BFD6,0xFFFE) --vertical speed?
			end
			if(memory.readword(0x13BFD2)==0x0001) then --horizontal speed?
				memory.writeword(0x13BFD2,0x0008) --horizontal speed?
			elseif(memory.readword(0x13BFD2)==0xFFFF) then --horizontal speed?
				memory.writeword(0x13BFD2,0xFFF7) --horizontal speed?
			end		
		end
		if case==198 then --mid boss of slash beast
			timer(addr);
			spike_addr=0x13F42A;
			for j = 0,2 do
				if     memory.readword(spike_addr)==0xFFFC then memory.writeword(spike_addr,0xFFFA); 
				elseif memory.readword(spike_addr)==0x0006 then memory.writeword(spike_addr,0x0009); 
				elseif memory.readword(spike_addr)==0xFFFE then memory.writeword(spike_addr,0xFFFD); 
				end
				spike_addr=spike_addr+0x9C;
			end
		end
		if case==199 then --mid boss in snow base
			if(memory.readbyte(0x13C00C)==0x30) then
				flag=true
			elseif(memory.readbyte(0x13C00C)==0x00) then
				flag=false
			end
			if(flag) then 		
				timer_1(addr);
				timer_3(addr);
				memory.writebyte(0x13BFBF,0x08)
				if(memory.readword(0x13BFD2)>0xF000) then --horizontal speed?
					memory.writeword(0x13BFD2,0xFFFA) --horizontal speed?
				end	
			end
		end	
		if case==200 then --mid boss in bio lab
			--timer(addr);
			if(memory.readbyte(0x13C02C)>0x1E) then
				memory.writebyte(0x13C02C,0x1E);
			end
			--enemyid=memory.readdword(0x13BFE0);
			if(memory.readword(addr-0x1E)==0x0004) then 
				memory.writeword(addr-0x1E,0x0007) --VSpeed
			elseif(memory.readword(addr-0x1E)==0x0006) then
				memory.writeword(addr-0x1E,0x0000) --VSpeed
			end				
			if(memory.readword(addr-0x22)==0x0004) then 
				memory.writeword(addr-0x22,0x0008) --HSpeed
			elseif(memory.readword(addr-0x22)==0x0007) then
				memory.writeword(addr-0x22,0x0001) --HSpeed
			elseif(memory.readword(addr-0x22)==0xFFFC) then
				memory.writeword(addr-0x22,0xFFF8) --HSpeed
			elseif(memory.readword(addr-0x22)==0xFFF9) then
				memory.writeword(addr-0x22,0xFFFF) --HSpeed
			end				
		end		
		
		addr = addr+0x9C
	end
end

pcsx.frameadvance()
end
