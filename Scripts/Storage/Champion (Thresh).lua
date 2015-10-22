-- TONES OF MISERY v1.21
-- by Iroh 
myHero = GetMyHero()
if myHero.charName ~= "Thresh" then 
return 
end

local noOrb = false
local sxorb = false
local hitted = {}
local asouls = {}
local soul = {}
local version = 1.2
local mobx, moby, mobz, sDistance
local allMobs = {}
local Mob = {name, xpos, ypos, zpos, isDead}
local target
local VP
local CastPosition, HitChance, Poisiton
local cHitChance = nil
local fHitChance = nil
local inHook = false
local pulltime = 0
local flytime = 0
local flylength = 0

local ts
local prevname = nil
local locked = false
local lockprio
local nobp = false
local bpx, bpz

if FileExist(LIB_PATH .. "/SxOrbWalk.lua") then
	require 'SxOrbWalk'
end

if FileExist(LIB_PATH .. "/VPrediction.lua") then
	require 'VPrediction'
else print ("[ERROR] You do not have VPrediction installed.") return end

if FileExist(LIB_PATH .. "/SimpleLib.lua") then
	require 'SimpleLib'
else print ("[ERROR] You do not have SimpleLib installed.") return end

if FileExist(LIB_PATH .. "/HPrediction.lua") then
	require 'HPrediction'
else print ("[ERROR] You do not have HPrediction installed.") return end


------------------ it BEGINS

function OnLoad()
print("<font color=\"#BDF852\">Welcome to Tones of Misery " ..version.."!</font>")
if not _G.Reborn_Loaded and not FileExist(LIB_PATH .. "/SxOrbWalk.lua") then
	print("<font color=\"#BDF852\">Tones of Misery - No orbwalker detected.</font>")
	noOrb = true
end

LoadMobs() -- Initialise mob locations

ts = TargetSelector(TARGET_NEAR_MOUSE, 1300, DAMAGE_MAGIC, false)
-- Set up prediction spells
Thresh_Q1 = HPSkillshot({type = "DelayLine", delay = 0.5, range = 1150, speed = 1850, width = 140, collisionM = true, IsVeryLowAccuracy = true})

--hero aliases
enemyMinions = minionManager(MINION_ENEMY, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
EnemyHeroes = GetEnemyHeroes()
Goodmates = GetAllyHeroes()

-- prediction aliases
HPred = HPrediction()
VP = VPrediction()

Menu()
 -- Main TS
end
  
function Menu()
	con = scriptConfig("Tones of Misery", "Thresh")
		con:addSubMenu("Skills", "cmb")
		con.cmb:addParam("q1", "Use Hook during:", SCRIPT_PARAM_LIST, 3, { "Combo", "Harass", "Both", "Never"})
		con.cmb:addParam("q2", "Use Hook-pull during:", SCRIPT_PARAM_LIST, 3, { "Combo", "Harass", "Both", "Never"})
		con.cmb:addParam("flay", "Use targeted flay during: ", SCRIPT_PARAM_LIST, 2, { "Combo", "Harass", "Both", "Never"})
		con.cmb:addParam("aflay", "Use auto-flay during: ", SCRIPT_PARAM_LIST, 1, { "Always, Combo", "Harass", "Both", "Never"})
		con.cmb:addParam("heal", "Use auto-lantern during:", SCRIPT_PARAM_LIST, 1, { "Always", "Combo", "Harass", "Both", "Never"})
		con.cmb:addParam("cage", "Use auto box during:", SCRIPT_PARAM_LIST, 1, { "Always", "Combo", "Never"})
		con.cmb:addParam("boxamount", "Auto-box enemy requirement: ", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
		con.cmb:addParam("flayamount", "Auto-flay enemy requirement: ", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
		con.cmb:addParam("flayc", "Targeted flay mode: ", SCRIPT_PARAM_LIST, 1, { "Pull", "Push"})
	con:addSubMenu("Keys", "keys")
		con.keys:addParam("qkey","Harass", SCRIPT_PARAM_ONKEYDOWN, false, 84)
		con.keys:addParam("cmbo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		con.keys:addParam("jescape","Jungle Escape", SCRIPT_PARAM_ONKEYDOWN, false, 67)
		con.keys:addParam("laneclear", "Laneclear", SCRIPT_PARAM_ONKEYDOWN, false, 86)
	con:addSubMenu("Interrupt with E", "Int")
_Interrupter(con.Int):CheckChannelingSpells():CheckGapcloserSpells():AddCallback(function(target) autoE() end)

--con:addSubMenu("Interrupt with Q", "Int")
--_Interrupter(con.Int):CheckChannelingSpells():CheckGapcloserSpells():AddCallback(function(target) Hook(target) end)
-- Under development
 	con:addSubMenu("Drawing", "draw")	
   	 	con.draw:addParam("qRange", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
   	 	con.draw:addParam("aaRange", "Draw AA range", SCRIPT_PARAM_ONOFF, true)
   		con.draw:addParam("bRange", "Draw Box range", SCRIPT_PARAM_ONOFF, false)
		con.draw:addParam("qLine", "Draw Q line", SCRIPT_PARAM_ONOFF, true)
		con.draw:addParam("drawC", "Combo colour indicator", SCRIPT_PARAM_ONOFF, true)
		con.draw:addParam("drawT", "Harass colour indicator", SCRIPT_PARAM_ONOFF, true)
	con:addSubMenu("Other", "other")
		con.other:addParam("target", "Only lock target when visible", SCRIPT_PARAM_ONOFF, true)
		con.other:addParam("qjescape", "Use quick Jungle Escape", SCRIPT_PARAM_ONOFF, true)
		con.other:addParam("moveto", "Move to mouse cursor", SCRIPT_PARAM_ONOFF, false)
		con.other:addParam("souls", "Auto soul collection", SCRIPT_PARAM_ONOFF, false)
		con.other:addParam("kse", "Killsteal with E", SCRIPT_PARAM_ONOFF, false)
		con.other:addParam("ksq", "Killsteal with Q", SCRIPT_PARAM_ONOFF, false)
	if not noOrb then
		if _G.Reborn_Loaded then
			con:addParam("SACR","SAC:R is loaded.", 5, "")
			print("<font color=\"#BDF852\">Tones of Misery - SAC:R integrated</font>")
			sxorb = false
		else
			con:addSubMenu("SxOrbWalk", "orb")
			SxOrb:LoadToMenu(con.orb)
			sxorb = true
			print("<font color=\"#BDF852\">Tones of Misery - SxOrbWalk integrated</font>")
		end
	end
end

function OnDraw()
if not myHero.dead then
----Draw Jungle escape mobs and arrow

if maxmlocx ~= nil then
	DrawCircle(maxmlocx, maxmlocy, maxmlocz, 60, 0x33AE27F8)
end

if con.keys.jescape then
	for i in pairs(allMobs) do
		if GetDistance(myHero, allMobs[i]) < 2000 then
			DrawCircle(allMobs[i].x, allMobs[i].y, allMobs[i].z, 100,  0x4DAE27F8)
		end
		if sDistance ~= nil and sDistance < 1150 and mobx ~= nil then
			DrawCircle(mobx, moby, mobz, 100, 0xFFAE27F8)
			DrawCircle(mobx, moby, mobz, 60,  0x99AE27F8)
			DrawCircle(mobx, moby, mobz, 20,  0x33AE27F8)
		end
	end
end

-- Draw marker for locked enemy
if lockprio ~= nil and lockprio.visible then
DrawCircle(lockprio.x, lockprio.y, lockprio.z, 100, 0xFFDC0303)
end
-- Draw marker for combo line
if con.draw.drawC and con.keys.cmbo then
DrawCircle(myHero.x, myHero.y, myHero.z, 1150, 0xFFFF8022)
end
-- Draw marker for q only line
if con.keys.qkey and con.draw.drawT then
DrawCircle(myHero.x, myHero.y, myHero.z, 1150, 0xFFF4FA27)
end
-- Draw aa range
if con.draw.aaRange then
	DrawCircle(myHero.x, myHero.y, myHero.z, 475, 0xFF51BDE6)
end
-- Draw box ult range
if con.draw.bRange then
	DrawCircle(myHero.x, myHero.y, myHero.z, 380, 0xFFDFD73C)
end
-- Draw default green Q line
if con.keys.qkey ~= true and con.keys.cmbo ~= true then
	if con.draw.qRange then
	DrawCircle(myHero.x, myHero.y, myHero.z, 1150, 0xFF657C78)
	end
end
-- Draw lines to target.
if con.draw.qLine then
	if target ~= nil and target.visible and fHitChance ~= nil then
		if fHitChance >= 1.3 then
			DrawLine3D(myHero.x, myHero.y, myHero.z, target.x, target.y, target.z, 60, 0x1A92FD5E)
		elseif (con.cmb.q1 == 2 and con.keys.qkey) or (con.cmb.q1 == 1 and con.keys.cmbo) or (con.cmb.q1 == 3 and (con.keys.cmbo or con.keys.qkey)) then
			DrawLine3D(myHero.x, myHero.y, myHero.z, target.x, target.y, target.z, 60, 0x1AFB7B26)
		else
			DrawLine3D(myHero.x, myHero.y, myHero.z, target.x, target.y, target.z, 60, 0x1A000000)
		end
	end
end			
end	
end

function OnTick()  
if not myHero.dead then
----------------
--------------

if con.other.moveto and (con.keys.qkey or con.keys.cmbo or con.keys.jescape) then
 myHero:MoveTo(mousePos.x, mousePos.z)
end

if con.keys.jescape then
	JungleSearch()
	if (con.other.qjescape) and (con.keys.jescape) and (sDistance ~= nil) and (sDistance < 1100) then
		JungleCast() -- go to function for Quick jungle escape
	end
end  

if con.other.souls then -- Auto soul setting
	if (con.keys.cmbo == false) and (con.keys.qkey == false) and (con.keys.jescape == false) then
		--if CheckForEnemiesBroad() == false then
			CollectSouls()
		--end
	end
end

refreshLock()-- update enemy lock
ts:update()
enemyMinions:update()

if sxorb then
SxOrb:ForceTarget(target)
end

if not locked then
	target = ts.target
end

if con.other.kse or con.other.ksq then
	KSMode()
end
-- who needs a map
	-- the CORE
if con.keys.laneclear then
	LaneClear()
end

	if target ~= nil then
		if (con.cmb.q1 == 2 and con.keys.qkey) or (con.cmb.q1 == 1 and con.keys.cmbo) or (con.cmb.q1 == 3 and (con.keys.cmbo or con.keys.qkey)) then
			Claw(target)
		else
			fHitChance = 0
		end
		if (con.cmb.flay == 2 and con.keys.qkey) or (con.cmb.flay == 1 and con.keys.cmbo) or (con.cmb.flay == 3 and (con.keys.cmbo or con.keys.qkey)) and Ready(_W) then
			if con.cmb.flayc == 1 then
				FlayPull(target)
			else
				FlayPush(target)
			end	
		end
	end
		if (con.cmb.heal == 1) or (con.cmb.heal == 2 and con.keys.cmbo) or (con.cmb.heal == 3 and con.keys.q1) or (con.cmb.heal == 4 and (con.keys.cmbo or con.keys.q1)) then
			if CheckForFriends() and CheckForEnemiesBroad() == true and Ready(_W) then 
				HealingGlass() 
			end
		end
		if (con.cmb.aflay == 1) or (con.cmb.aflay == 2 and con.keys.cmbo) or (con.cmb.aflay == 3 and con.keys.q1) or (con.cmb.aflay == 4 and (con.keys.cmbo or con.keys.q1)) then
			if CheckForFlayTargets() >= con.cmb.flayamount then
				PermE() 
			end
		end
		if (con.cmb.cage == 1) or (con.cmb.cage == 2 and con.keys.cmbo) then
			if CheckForEnemies() > con.cmb.boxamount and Ready(_R) then 
				Boxxy() 
			end
		end

end -- end of IsDead check
end

function Ready(skill)
return (player:CanUseSpell(skill) == READY)
end -- saves time

function OnWndMsg(msg,key)
	if msg == WM_LBUTTONDOWN then -- when left mouse button is clicked
		CheckEnemies() -- checks for enemies near mouse
		MakeLock()     
	end

if sDistance ~= nil then -- when the jungle escape key is help and a left click is made within range
	if (con.other.qjescape == false) and (msg == WM_LBUTTONDOWN) and (con.keys.jescape) and (sDistance < 1100) then
		JungleCast()
	end
end
end

function CheckEnemies()
lockprio = nil -- Find's the closest enemy to mouse cursor
	for i, enemy in pairs(EnemyHeroes) do
		if not enemy.dead then
			if GetDistance(mousePos, enemy) < 120 then
				lockprio = enemy -- sets enemy as lock priority
			end
		end
	end
	if locked and lockprio == nil then --if a champion is already locked and ground is selected.
		print("<font color=\"#FCEF52\">Target locked:<font color=\"#F32610\"> None </font>")
		prevname = nil -- prevname is nilled so that you can reselect the same champion
						-- this was to prevent chat spam from multi click same champ
	end
end  

function refreshLock()  --checks whether lock is changed and changes the state of the lock
	if locked and (lockprio == nil or ((con.other.target == true) and (lockprio.visible == false))) then
		locked = false
	end
end

function MakeLock()
	if ((locked == false) and (lockprio ~= nil)) or ((locked == true) and (lockprio ~= nil) and (lockprio.charName ~= prevname)) then
			locked = true
			target = lockprio
		if lockprio.charName ~= prevname or (prevname == nil) then
			print("<font color=\"#FCEF52\">Target locked: </font>".. "<b>"..lockprio.charName.."<b>")
		end
		prevname = lockprio.charName
	end
end

function Claw(unit)
if unit ~= nil then
	Q1Pos, Q1HitChance = HPred:GetPredict(Thresh_Q1, unit, myHero)
	CastPosition, HitChance, Poisiton = VP:GetLineCastPosition(unit, 0.5, 120, 1100, 1850, myHero, true) --Vpred
---------------------------

fHitChance = (Q1HitChance+HitChance)/2
if Q1Pos ~= nil and CastPosition ~=nil then
	if GetDistance(Q1Pos, CastPosition) < 210 then
		bpx = (Q1Pos.x + CastPosition.x)/2
		bpz = (Q1Pos.z + CastPosition.z)/2
	else
	bpx = Q1Pos.x
	bpz = Q1Pos.x
	end
end

if Ready(_Q) and (myHero:GetSpellData(_Q).name:lower() == "threshq") and (target.dead == false) then --EXPERIMENTAL SECTION, NOTHING HERE IS PERMANANENT ATM
		if fHitChance >= 1.3 then
			pulltime = GetInGameTimer()
			CastSpell(_Q, bpx, bpz)
		end

	DelayAction(function() 
	if (con.cmb.q2 == 2 and con.keys.qkey) or (con.cmb.q2 == 1 and con.keys.cmbo) or (con.cmb.q2 == 3) then
	flylength = (GetDistance(myHero, target))/2500
	flytime = GetInGameTimer()
	CastSpell(_Q, myHero) end end, (2))
	end

end
end


function FlayPull() ---PULL
if (GetInGameTimer() > pulltime + 2) and (GetInGameTimer() > flytime + flylength) then
xxx = myHero.x + (myHero.x - target.x)
zzz = myHero.z + (myHero.z - target.z)
    if ValidTarget(target, 450) then
			CastSpell(_E, xxx, zzz)
    end
end
end


function FlayPush() -- POOSH
if (GetInGameTimer() > pulltime + 2) and (GetInGameTimer() > flytime + flylength) then
		if ValidTarget(target, 450) then
               CastSpell(_E, target.x, target.z)
    	end
end
end



function autoE() -- going to be used to anti-gapcloser at somepoint
	if ValidTarget(target, 450) and (target.dead == false) then
		if Ready(_E) then
			CastSpell(_E, target.x, target.z)
		end
	end
end

function CheckForFriends()
	for i, friend in pairs(Goodmates) do -- This first for loop find closest enemy.
	local distance = GetDistance(myHero, friend)
			if distance < 950 and friend.dead == false then
			return true	
			end
	end
end

function CheckForEnemies()
local amount = 0
	for i, enemy in pairs(EnemyHeroes) do -- This first for loop find closest enemy.
	local distance = GetDistance(myHero, enemy)
			if distance < 1100 and enemy.dead == false then
			amount = amount + 1	
			end
	end
return amount
end

function CheckForFlayTargets()
local amount = 0
	for i, enemy in pairs(EnemyHeroes) do -- This first for loop find closest enemy for flay
	local distance = GetDistance(myHero, enemy)
			if distance <= 600 and enemy.dead == false then
			amount = amount + 1	
			end
	end
return amount
end

function CheckForEnemiesBroad()
	for i, enemy in pairs(EnemyHeroes) do -- This first for loop find closest enemy.
	local distance = GetDistance(myHero, enemy)
			if distance < 2000 and enemy.dead == false then
			return true	
			end
	end
end

function HealingGlass()
local prio = nil
local dangerdist = nil
local isDanger = false
		for i, friend in pairs(Goodmates)do
				local distance = GetDistance(myHero, friend)  -- This first for loop find closest enemy.
			    if distance <= 950 and friend.dead == false then
				   if prio == nil then
					  prio = friend
				   elseif friend.health < prio.health then
					  prio = friend
				   end
			    end
	     end


if prio ~= nil and (GetDistance(myHero, prio) < 950) then -- If within range, another for loop is initialised, calculating the
	for i, fiend in pairs(EnemyHeroes) do 	
		if GetDistance(fiend, prio) < fiend.range then			-- the closest enemy to the priority team mate.
			isDanger = true
		end
	end   
		if Ready(_W) and isDanger and (prio.health < prio.maxHealth * 0.35) then --ADD MENU? OPTION
				CastSpell(_W, prio.x, prio.z)
		end
end
end

function Boxxy() -- Simple box function, includes table that hold enemy names of those within box range.
local inbox = {}
	for i, fiend in pairs(EnemyHeroes) do
			local distance = GetDistance(myHero, fiend)
			if distance <= 200  and (fiend.dead == false) then
				table.insert(inbox, #inbox+1, fiend.charName)
			else if distance > 200 then
					for i in pairs(inbox) do
						if inbox[i] == fiend.charName then
						table.remove(inbox, i)
					end
			end
		end
	end
end
	if #inbox >= con.cmb.boxamount then 
			CastSpell(_R, myHero) -- If SET AMOUNT OF ENEMIES inside box, then cast box.
	end
end

function LoadMobs() -- Adding all mobs into table using oofunction.
 	allMobs[1] = addMob("KrugB1", 8532, 51, 2738, 100)
	allMobs[2] = addMob("KrugB2", 8323, 51, 2755, 100)
	allMobs[3] = addMob("KrugR1", 6317, 56, 12146, 100)
	allMobs[4] = addMob("KrugR2", 6547, 56, 12156, 100)

	allMobs[5] = addMob("BirdsB1", 6824, 53, 5458, 100)
	allMobs[6] = addMob("BirdsB2", 6915, 49, 5325, 100)
	allMobs[7] = addMob("BirdsB3", 7060, 55, 5499, 100)
	allMobs[8] = addMob("BirdsB4", 6874, 58, 5608, 100)
	allMobs[9] = addMob("BirdsR1", 7987, 52, 9471, 100)
	allMobs[10] = addMob("BirdsR2", 7854, 52, 9610, 100)
	allMobs[11] = addMob("BirdsR3", 7757, 52, 9451, 100)
	allMobs[12] = addMob("BirdsR4", 7887, 52, 9312, 100)

	allMobs[13] = addMob("WolfB1", 3781, 52, 6444, 100)
	allMobs[14] = addMob("WolfB2", 3981, 52, 6444, 100)
	allMobs[15] = addMob("WolfB3", 3731, 52, 6594, 100)
	allMobs[16] = addMob("WolfR1", 11008, 62, 8387, 100)
	allMobs[17] = addMob("WolfR2", 11058, 62, 8217, 100)
	allMobs[18] = addMob("WolfR3", 10808, 63, 8387, 100)

	allMobs[19] = addMob("GrompB", 2091, 52, 8428, 100)
	allMobs[20] = addMob("GrompR", 12704, 52, 6444, 100)

	allMobs[21] = addMob("BlueB1", 3871, 52, 7901, 300)
	allMobs[22] = addMob("BlueB2", 3778, 51, 8103, 300)
	allMobs[23] = addMob("BlueB3", 3638, 54, 7839, 300)
	allMobs[24] = addMob("BlueR1", 10932, 52, 6991, 300)
	allMobs[25] = addMob("BlueR2", 11140, 52, 7064, 300)
	allMobs[26] = addMob("BlueR1", 11068, 52, 6790, 300)

	allMobs[27] = addMob("RedB1", 7862, 54, 4111, 300)
	allMobs[28] = addMob("RedB2", 7919, 54, 3881, 300)
	allMobs[29] = addMob("RedB3", 7624, 54, 4181, 300)
	allMobs[30] = addMob("RedR1", 7017, 56, 10776, 300)
	allMobs[31] = addMob("RedR2", 6917, 56, 11004, 300)
	allMobs[32] = addMob("RedR3", 7265, 57, 10796, 300)


	allMobs[33] = addMob("Dragon", 9866, -71, 4414, 360)
	allMobs[34] = addMob("Baron", 5007, -71, 10471, 420)

end

function addMob(name, xpos, ypos, zpos, dtimer)
	local mob = setmetatable({}, Mob)
	mob.name = name
	mob.x = xpos
	mob.y = ypos
	mob.z = zpos
	mob.dtimer = dtimer
	mob.isDead = false
	mob.inRange = false
return mob
end

function addSoul(x, y, z)
	local soul = setmetatable({}, soul)
	soul.x = x
	soul.y = y
	soul.z = z
	soul.paused = false
return soul
end

function JungleSearch() -- Used to find mobs all over the map, not limited to range atm.	
	for i in pairs(allMobs) do
			if GetDistance(myHero, allMobs[i]) < 1150 then
				if con.other.qjescape or ((con.other.qjescape == false) and (GetDistance(mousePos, allMobs[i]) < 100)) then
				--prevdist = GetDistance(mousePos, allMobs[i])
				mobx = allMobs[i].x
				moby = allMobs[i].y
				mobz = allMobs[i].z
				end
			end
		
	end	
	if mobx ~= nil then
	sDistance = (math.sqrt((myHero.x-mobx)^2 + (myHero.y-moby)^2 + (myHero.z-mobz)^2))
	end
end

function JungleCast() -- CASTS HOOK AND HOOK2 TO JUNGLE MOB, called from two places.
if sDistance ~= nil then 
local jungdelay = sDistance/(1885)+0.7
	CastSpell(_Q, mobx, mobz)
		DelayAction(function() CastSpell(_Q, myHero) end, (jungdelay))
end
end

function OnDeleteObj(obj)
if con.other.souls then
	if obj.name == 'Thresh_Base_soul_giant.troy' or obj.name =='Thresh_Base_soul.troy' then
		for i in pairs(asouls) do
			if GetDistance(myHero, obj) < 400 then
				table.remove(asouls, i)
			--elseif GetDistance(myHero, obj) > 600 then
			else
				table.remove(asouls, 1)
			end
		end
	end
end
end

function OnCreateObj(obj)
if con.other.souls then
	if obj.name == 'Thresh_Base_soul_giant.troy' or obj.name == 'Thresh_Base_soul.troy'	then
		if GetDistance(myHero, obj) < 2000 then
			local loc = D3DXVECTOR3(obj.x, obj.y, obj.z)
			asouls[#asouls + 1] = addSoul(loc.x, loc.y, loc.z)
		end
	end
end
end

function CollectSouls()
	for i, soul in pairs(asouls) do
		if GetDistance(myHero, soul) < 1000 and GetDistance(myHero, soul) > 250 then
			if not myHero.hasMovePath then
				myHero:MoveTo(soul.x, soul.z)
			end
		end

	end
end

function KSMode()
	for i, enemy in pairs(EnemyHeroes) do
		if con.other.kse and (GetDistance(myHero, enemy) < 450) then
			if enemy.health <= getDmg("E", enemy, myHero) and Ready(_E) then 
				CastP, HitC, P = VP:GetLineCastPosition(enemy, 0.1, 200, 450, 2000, myHero, true)
            	if (HitC >= 2) and (enemy.dead == false) and (GetDistance(CastP) < 450) then
               		    CastSpell(_E, CastP.x, CastP.z)
               	end
            end
        end
        if con.other.ks and (GetDistance(myHero, enemy) < 450) then
        	if (enemy.dead == false) and enemy.health <= getDmg("Q", enemy, myHero) and Ready(_Q) then 
        		Claw(enemy)
        	end
        end
    end
end

function LaneClear()
local mhit = 0
local final = nil
local hitted = {}

	for i, minion in ipairs(enemyMinions.objects) do
		if Ready(_E) then
            	if GetDistance(myHero, minion) < 450 then
               		  table.insert(hitted, #hitted+1, minion)
                end
        end
    end
if hitted ~= nil then
	for i, minyon in pairs(hitted) do
		local ahit = 0
		local mdist = GetDistance(myHero, minyon)
		local maxperc = 450/mdist
		local maxmlocx = myHero.x + (minyon.x-myHero.x)*maxperc
		local maxmlocy = minyon.y
		local maxmlocz = myHero.z + (minyon.z-myHero.z)*maxperc
		local mex = myHero.x - (minyon.x-myHero.x)*maxperc
		local mez = myHero.z - (minyon.z-myHero.z)*maxperc
		ahit = CheckMPath(maxmlocx, maxmlocy, maxmlocz, mex, mez)
		if ahit ~= nil and ((mhit ~= nil and ahit > mhit) or mhit == nil) then
			mhit = ahit
			final = minyon
		end
	end
	--print(mhit)
	if final ~= nil and mhit ~= nil then
		--finalP, finalC, finalP = VP:GetLineCastPosition(final, 0.1, 200, 450, 2000, myHero, true)
		if mhit >= 1 then
			CastSpell(_E, final.x, final.z)
		end
	end
end
end

function CheckMPath(x, y, z, hx, hz)
local alsohit = 0
	for i, minion in ipairs(enemyMinions.objects) do
		local PS, PL, IsOn = VectorPointProjectionOnLineSegment(Vector(hx, myHero.y, hz), Vector(x,y,z), Vector(minion))
		if IsOn and (GetDistanceSqr(minion, PS) <= (minion.boundingRadius + 200)^2) then
			alsohit = alsohit + 1 
		end
	end
	return alsohit
end

function CheckHPath(x, y, z, hx, hz)
local alsohit = 0
	for i, enemy in ipairs(EnemyHeroes) do
		local PS, PL, IsOn = VectorPointProjectionOnLineSegment(Vector(hx, myHero.y, hz), Vector(x,y,z), Vector(enemy))
		if IsOn and (GetDistanceSqr(enemy, PS) <= (enemy.boundingRadius + 200)^2) then
			alsohit = alsohit + 1 
		end
	end
	return alsohit
end

function PermE()
if (GetInGameTimer() > pulltime + 2) and (GetInGameTimer() > flytime + flylength) then	
local hhit = 0
local final = nil
local hitted = {}

	for i, enemy in ipairs(EnemyHeroes) do
		if Ready(_E) then
            	if GetDistance(myHero, enemy) < 450 and (enemy.dead == false) then
               		  table.insert(hitted, #hitted+1, enemy)
                end
        end
    end
if hitted ~= nil then
	for i, enemie in pairs(hitted) do
		local ahit = 0
		local mdist = GetDistance(myHero, enemie)
		local maxperc = 450/mdist
		local maxmlocx = myHero.x + (enemie.x-myHero.x)*maxperc
		local maxmlocy = enemie.y
		local maxmlocz = myHero.z + (enemie.z-myHero.z)*maxperc
		local mex = myHero.x - (enemie.x-myHero.x)*maxperc
		local mez = myHero.z - (enemie.z-myHero.z)*maxperc
		ahit = CheckHPath(maxmlocx, maxmlocy, maxmlocz, mex, mez)
		if ahit ~= nil and ((hhit ~= nil and ahit > hhit) or hhit == nil) then
			hhit = ahit
			final = enemie
		end
	end
	if final ~= nil and hhit ~= nil then
		finalP, finalC, finalP = VP:GetLineCastPosition(final, 0.1, 200, 450, 2000, myHero, true)
		if hhit >= 1 and finalC >= con.cmb.flayamount then
			CastSpell(_E, finalP.x, finalP.z)
		end
	end
end
end
end