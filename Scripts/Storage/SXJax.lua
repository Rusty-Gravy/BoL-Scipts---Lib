if myHero.charName ~= "Jax"  then return end
local version = 0.2
local AUTOUPDATE = true
local SCRIPT_NAME = "SXJax"
require 'VPrediction'
require "SxOrbwalk"
--require 'Prodiction' 
--require 'Collision'
require 'DivinePred'
require 'HPrediction'

--Credit Trees

-- Constants --

local ignite, igniteReady = nil, nil
local ts = nil
local VP = nil
local qOff, wOff, eOff, rOff = 0,0,0,0
local abilitySequence = {1,2,3,1,1,4,1,3,1,3,4,3,3,2,2,4,2,2}
local Ranges = { AA = 125 }
local skills = {
	SkillQ = { ready = true, name = "Leap Strike" , range = 700, delay = 0.5, speed = 1150, width = 60 },
	SkillW = { ready = true, name = "Empower", range = 10, delay = 025, speed = 1200, width = 100 },
	SkillE = { ready = true, name = "Counter Strike", range = 187.5, delay = 0.25, speed = 1200, width = 100 },
	SkillR = { ready = true, name = "Grandmaster's Might ", range = 10, delay = 0, speed = 0, width = 0 },
}
--[[ Slots Itens ]]--
local tiamatSlot, hydraSlot, youmuuSlot, bilgeSlot, bladeSlot, dfgSlot, divineSlot = nil, nil, nil, nil, nil, nil, nil
local tiamatReady, hydraReady, youmuuReady, bilgeReady, bladeReady, dfgReady, divineReady = nil, nil, nil, nil, nil, nil, nil

--[[Auto Attacks]]--
local lastBasicAttack = 0
local swingDelay = 0.25
local swing = false

--[[Misc]]--
local lastSkin = 0
local isSAC = false
local isMMA = false
local target = nil
--Credit Trees
function GetCustomTarget()
	ts:update()
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
  if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1500) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	return ts.target
end
function OnLoad()
	if _G.ScriptLoaded then	return end
	_G.ScriptLoaded = true
	initComponents()
   Jax_Q =  HPSkillshot({type = "DelayLine", delay = 0.5, range = 1100, speed = 1150, width = 120 })
--HookPackets()
--HPSkillshot({type = "DelayLine", delay = 0.25, range = 1525, speed = 1200, collisionM = true, collisionH = true, width = 90, IsVeryLowAccuracy = true})
    divineQSkill = SkillShot.PRESETS['JaxQ']
   
    
end



checkDP = 0
TimeDP = math.huge
function initComponents()
VP = VPrediction()
  DP = DivinePred()
    HPred = HPrediction()

   ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 4000)
  
 Menu = scriptConfig("SXJax by SyraX", "JaxMA")

   if _G.MMA_Loaded ~= nil then
     PrintChat("<font color = \"#33CCCC\">MMA Status:</font> <font color = \"#fff8e7\"> Loaded</font>")
     isMMA = true
 elseif _G.AutoCarry ~= nil then
      PrintChat("<font color = \"#33CCCC\">SAC Status:</font> <font color = \"#fff8e7\"> Loaded</font>")
     isSAC = true
 else
  PrintChat("<font color = \"#33CCCC\">OrbWalker not found:</font> <font color = \"#fff8e7\"> Loading SX</font>")
    Menu:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		SxOrb:LoadToMenu(Menu.Orbwalking)

   -- Menu:addTS(ts)
    end
  
 Menu:addSubMenu("["..myHero.charName.." - Combo]", "JaxCombo")
    Menu.JaxCombo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Menu.JaxCombo:addSubMenu("Q Settings", "qSet")
  Menu.JaxCombo.qSet:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
 
 Menu.JaxCombo:addSubMenu("W Settings", "wSet")
  Menu.JaxCombo.wSet:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)

  
 Menu.JaxCombo:addSubMenu("E Settings", "eSet")
  Menu.JaxCombo.eSet:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)

 Menu.JaxCombo:addSubMenu("R Settings", "rSet")
  Menu.JaxCombo.rSet:addParam("useR", "use R in combo ", SCRIPT_PARAM_ONOFF, true)
  Menu.JaxCombo.rSet:addParam("RMode", "Use Ultimate enemy count:", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
Menu.JaxCombo.rSet:addParam("Tower", "Dive with Q:", SCRIPT_PARAM_ONOFF, false)
  -- Menu.JaxCombo.rSet:addParam("Click", "Ult target on double click target", SCRIPT_PARAM_ONOFF, false)
  

   

 Menu:addSubMenu("["..myHero.charName.." - Harass]", "Harass")
  Menu.Harass:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
  Menu.Harass:addParam("useQ", "Use Q in Harass", SCRIPT_PARAM_ONOFF, true)
    Menu.Harass:addParam("useW", "Use W in Harass", SCRIPT_PARAM_ONOFF, false)
   Menu.Harass:addParam("useE", "Use E in Harass", SCRIPT_PARAM_ONOFF, true)
    
 Menu:addSubMenu("["..myHero.charName.." - Laneclear]", "Laneclear")
    Menu.Laneclear:addParam("lclr", "Laneclear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
  Menu.Laneclear:addParam("useClearQ", "Use Q in Laneclear", SCRIPT_PARAM_ONOFF, true)
 Menu.Laneclear:addParam("useClearW", "Use W in Laneclear", SCRIPT_PARAM_ONOFF, false)
    Menu.Laneclear:addParam("useClearE", "Use E in Laneclear", SCRIPT_PARAM_ONOFF, true)
 
 Menu:addSubMenu("["..myHero.charName.." - Jungleclear]", "Jungleclear")
    Menu.Jungleclear:addParam("jclr", "Jungleclear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
  Menu.Jungleclear:addParam("useClearQ", "Use Q in Jungleclear", SCRIPT_PARAM_ONOFF, true)
 Menu.Jungleclear:addParam("useClearW", "Use W in Jungleclear", SCRIPT_PARAM_ONOFF, false)
    Menu.Jungleclear:addParam("useClearE", "Use E in Jungleclear", SCRIPT_PARAM_ONOFF, true)
    
   
 Menu:addSubMenu("["..myHero.charName.." - Additionals]", "Ads")
    Menu.Ads:addParam("autoLevel", "Auto-Level Spells", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads:addSubMenu("Killsteal", "KS")
   --Menu.Ads:addParam("Prod", "Use VP in Second cast Q", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads.KS:addParam("ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.KS:addParam("igniteRange", "Minimum range to cast Ignite", SCRIPT_PARAM_SLICE, 470, 0, 600, 0)
  Menu.Ads.KS:addParam("KS", "Killsteal", SCRIPT_PARAM_ONOFF, false)
 -- Menu.Ads.KS:addParam("R", " KSCombo Use r count", SCRIPT_PARAM_ONOFF, false)
  

 -- Menu.Ads.KS:addParam("autoQ", "OnGapClose", SCRIPT_PARAM_ONOFF, false) -- Menu.Ads.KS.autoQ
  --Menu.Ads.KS:addParam("KSWE", "Killsteal with W and Q", SCRIPT_PARAM_ONOFF, false)--Menu.Ads.KS.KSWE
  --Menu.Ads:addSubMenu("JaxP", "JaxP")
   -- Menu.Ads.JaxP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
 -- Menu.Ads.JaxP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 5)
 
    --[[
 Menu:addSubMenu("["..myHero.charName.." - Target Selector]", "targetSelector")
 Menu.targetSelector:addTS(ts)
    ts.name = "Focus"--]]
  
 Menu:addSubMenu("["..myHero.charName.." - Drawings]", "drawings")
  Menu.drawings:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
  Menu.drawings:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Menu.drawings:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    Menu.drawings:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
    Menu.drawings:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
    
 targetMinions = minionManager(MINION_ENEMY, 360, myHero, MINION_SORT_MAXHEALTH_DEC)
  allyMinions = minionManager(MINION_ALLY, 360, myHero, MINION_SORT_MAXHEALTH_DEC)
 jungleMinions = minionManager(MINION_JUNGLE, 360, myHero, MINION_SORT_MAXHEALTH_DEC)
 

  
 PrintChat("<font color = \"#FFA319\">SX</font><font color = \"#52524F\">Jax</font> <font color = \"#FFA319\">by SyraX V"..version.."</font>")
end


function OnTick()
	target = GetCustomTarget()
	targetMinions:update()
	allyMinions:update()
	jungleMinions:update()
	CDHandler()
	KillSteal()
  KS()
--print(Drain)

  
 
    if click == 2 then
       DoubleClick()
       if click == 2 then
         click = 0
        end
   end
   if click >= 3 then
   click = 0
   end
   if click == 1 then
      if time + 0.4 <= GetGameTimer() then
         click = 0
         time  = math.huge
      end
    end 

	if Menu.Ads.autoLevel then
		AutoLevel()
	end
	
	if Menu.JaxCombo.combo then
		Combo()
	end
	
	if Menu.Harass.harass then
		Harass()
	end
	
	if Menu.Laneclear.lclr then
		LaneClear()
	end
	
	if Menu.Jungleclear.jclr then
		JungleClear()
	end

end

function CDHandler()
	-- Spells

	skills.SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	skills.SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	skills.SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	skills.SkillR.ready = (myHero:CanUseSpell(_R) == READY)


   

	-- Items
	tiamatSlot = GetInventorySlotItem(3077)
	hydraSlot = GetInventorySlotItem(3074)
	youmuuSlot = GetInventorySlotItem(3142) 
	bilgeSlot = GetInventorySlotItem(3144)
	bladeSlot = GetInventorySlotItem(3153)
	dfgSlot = GetInventorySlotItem(3128)
	--divineSlot = GetInventorySlotItem(3131)
	
	tiamatReady = (tiamatSlot ~= nil and myHero:CanUseSpell(tiamatSlot) == READY)
	hydraReady = (hydraSlot ~= nil and myHero:CanUseSpell(hydraSlot) == READY)
	youmuuReady = (youmuuSlot ~= nil and myHero:CanUseSpell(youmuuSlot) == READY)
	bilgeReady = (bilgeSlot ~= nil and myHero:CanUseSpell(bilgeSlot) == READY)
	bladeReady = (bladeSlot ~= nil and myHero:CanUseSpell(bladeSlot) == READY)
	dfgReady = (dfgSlot ~= nil and myHero:CanUseSpell(dfgSlot) == READY)
	--diJaxneReady = (diJaxneSlot ~= nil and myHero:CanUseSpell(diJaxneSlot) == READY)

	-- Summoners
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
		ignite = SUMMONER_2
	end
	igniteReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
DamageCalculation()
end-- Harass --

function Harass()	
if target ~= nil and target.team ~= myHero.team and target.type == myHero.type then
  if skills.SkillQ.ready and ValidTarget(target, skills.SkillQ.range) and Menu.Harass.useQ then
    CastSpell(_Q, target)
  end
  if skills.SkillW.ready and ValidTarget(target, 300) and Menu.Harass.useW then
    CastSpell(_W, myHero)
  end
  if skills.SkillE.ready and ValidTarget(target, skills.SkillE.ready)and Menu.Harass.useE  then
    CastSpell(_E, target)
  end
  


end
end


     
  
  



-- Combo Selector --

function Combo()
	local typeCombo = 0
	if target ~= nil then
		AllInCombo(target, 0)
   -- print("allincombo")
	end


end
  
	function AllInCombo(target, typeCombo)
    if target ~= nil and target.team ~= myHero.team and target.type == myHero.type and not target.dead then
      local Etimer = math.huge
     local E = false
      if skills.SkillQ.ready and skills.SkillE.ready and ValidTarget(target, skills.SkillQ.range) then
       CastSpell(_E, myHero)
       Etimer = GetGameTimer()
       E = true
      end
      
       if Etimer + 1.5 <= GetGameTimer() then 
         
         CastSpell(_W)
         E = false
         Etimer = math.huge
         if skills.SkillQ.ready and ValidTarget(target, skills.SkillQ.range) then
          CastSpell(_Q, target)
        end
      end
      
       
      if skills.SkillQ.ready and ValidTarget(target, skills.SkillQ.range) and Menu.JaxCombo.qSet.useQ and not E then
        CastSpell(_Q, target)
      end
      if skills.SkillW.ready and ValidTarget(target, 200) and Menu.JaxCombo.wSet.useW then
        CastSpell(_W)
      end
      if skills.SkillE.ready and ValidTarget(target, skills.SkillE.range) and Menu.JaxCombo.eSet.useE then
        CastSpell(_E, target)
        end
       if skills.SkillR.ready and ValidTarget(target, skills.SkillR.range) and Menu.JaxCombo.rSet.useR and AreaEnemyCount() >= Menu.JaxCombo.rSet.RMode  then
          CastSpell(_R, myHero)
        end
      --[[if Menu.JaxCombo.rSet.Tower then
       
      elseif not Menu.JaxCombo.rSet.Tower and not UnitAtTower(target,100) then
         if skills.SkillR.ready and ValidTarget(target, skills.SkillR.range) and Menu.JaxCombo.rSet.useR and skills.SkillQ.ready and skills.SkillW.ready and AreaEnemyCount() >= Menu.JaxCombo.rSet.RMode  then
          CastSpell(_R, target.x, target.z)
        end
        end
        
  end--]]
end


end


function OnApplyBuff(source, unit, buff)
  --if buff then print(buff.name) end
  if buff and buff.name:find("Flee") then
    Taunt = true
  end
  
  end

 function OnRemoveBuff(unit, buff)
   if buff and buff.name:find("Flee") then
    Taunt = false
  end
   
 end
 Drain = false
function OnProcessSpell(unit, spell)
  if not unit.isMe then return end
 -- if spell then print(spell.name) end
  if spell.name == "Drain" then
   Drain = true
  
  end
end

function OnAnimation(unit, animation)
  if not unit.isMe then return end

    
  end

function LaneClear()
	for i, targetMinion in pairs(targetMinions.objects) do
		if targetMinion ~= nil then
if skills.SkillQ.ready and ValidTarget(jungleMinion, skills.SkillQ.range) and Menu.Laneclear.useClearQ then
  CastSpell(_Q, jungleMinion)
end
if skills.SkillW.ready and ValidTarget(jungleMinion, 200)and Menu.Laneclear.useClearW then
CastSpell(_W, myHero)
end
if skills.SkillE.ready and ValidTargt(jungleMinion, skills.SkillE.range) and Menu.Laneclear.useClearE then 
  CastSpell(_E, jungleMInion)
end
			
	end
		
	end
end

function JungleClear()
	for i, jungleMinion in pairs(jungleMinions.objects) do
		if jungleMinion ~= nil then
if skills.SkillQ.ready and ValidTarget(jungleMinion, skills.SkillQ.range) and Menu.Jungleclear.useClearQ then
  CastSpell(_Q, jungleMinion)
end
if skills.SkillW.ready and ValidTarget(jungleMinion, 200) and Menu.Jungleclear.useClearW then
CastSpell(_W, myHero)
end
if skills.SkillE.ready and ValidTargt(jungleMinion, skills.SkillE.range) and Menu.Jungleclear.useClearE then 
  CastSpell(_E, jungleMInion)
end
  end
	end
end


function KillSteal()
	if Menu.Ads.KS.ignite then
		IgniteKS()
	end
  
   if Menu.Ads.ESC then
   -- Escape()
    Monster()
  end
  


  
  
end

-- Auto Ignite get the maximum range to avoid over kill --

function IgniteKS()
	if igniteReady then
		local Enemies = GetEnemyHeroes()
		for i, val in ipairs(Enemies) do
			if ValidTarget(val, 600) then
				if getDmg("IGNITE", val, myHero) > val.health and GetDistance(val) >= Menu.Ads.KS.igniteRange then
					CastSpell(ignite, val)
				end
			end
		end
	end
end

-- Auto Ignite --

function HealthCheck(unit, HealthValue)
	if unit.health > (unit.maxHealth * (HealthValue/100)) then 
		return true
	else
		return false
	end
end

function ItemUsage(target)

	if dfgReady then CastSpell(dfgSlot, target) end
	if youmuuReady then CastSpell(youmuuSlot, target) end
	if bilgeReady then CastSpell(bilgeSlot, target) end
	if bladeReady then CastSpell(bladeSlot, target) end
	--if diJaxneReady then CastSpell(diJaxneSlot, target) end

end

-- Change skin function, made by Shalzuth
function GenModelPacket(champ, skinId)
	p = CLoLPacket(0x97)
	p:EncodeF(myHero.networkID)
	p.pos = 1
	t1 = p:Decode1()
	t2 = p:Decode1()
	t3 = p:Decode1()
	t4 = p:Decode1()
	p:Encode1(t1)
	p:Encode1(t2)
	p:Encode1(t3)
	p:Encode1(bit32.band(t4,0xB))
	p:Encode1(1)--hardcode 1 bitfield
	p:Encode4(skinId)
	for i = 1, #champ do
		p:Encode1(string.byte(champ:sub(i,i)))
	end
	for i = #champ + 1, 64 do
		p:Encode1(0)
	end
	p:Hide()
	RecvPacket(p)
end



function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
 radius = radius or 300
 quality = math.max(8,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
 quality = 2 * math.pi / quality
 radius = radius*.92
 local points = {}
 for theta = 0, 2 * math.pi + quality, quality do
  local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
  points[#points + 1] = D3DXVECTOR2(c.x, c.y)
 end
 DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle2(x, y, z, radius, color)
 local vPos1 = Vector(x, y, z)
 local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
 local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
 local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
 if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
  self:DrawCircleNextLvl(x, y, z, radius, 1, color, 75)
 end
end

function CircleDraw(x,y,z,radius, color)
	self:DrawCircle2(x, y, z, radius, color)
end--[[ Kill Text ]]--
TextList = {"Harass him", "Q", "W", "E", "ULT HIM !", "Items", "All In", "Skills Not Ready"}
KillText = {}
colorText = ARGB(229,229,229,0)
_G.ShowTextDraw = true


  
    
     
      
-- Damage Calculation Thanks Skeem for the base --

function DamageCalculation()
  for i=1, heroManager.iCount do
    local enemy = heroManager:GetHero(i)
    if ValidTarget(enemy) and enemy ~= nil then
      qDmg = getDmg("Q", enemy,myHero)
      wDmg = getDmg("W", enemy,myHero)
      eDmg = getDmg("E", enemy,myHero)
      rDmg = getDmg("R", enemy,myHero)
      dfgDmg = getDmg("DFG", enemy, myHero)


      if not skills.SkillQ.ready and not skills.SkillW.ready and not skills.SkillE.ready and not skills.SkillR.ready then
        KillText[i] = TextList[8]
        return
      end

      if enemy.health <= qDmg then
        KillText[i] = TextList[2]
      elseif enemy.health <= wDmg then
        KillText[i] = TextList[3]
      elseif enemy.health <= eDmg then
        KillText[i] = TextList[4]
      elseif enemy.health <= rDmg then
        KillText[i] = TextList[5]
      elseif enemy.health <= qDmg + wDmg then
        KillText[i] = TextList[2] .."+".. TextList[3]
      elseif enemy.health <= qDmg + eDmg then
        KillText[i] = TextList[2] .."+".. TextList[4]
      elseif enemy.health <= qDmg + rDmg then
        KillText[i] = TextList[2] .."+".. TextList[5]
      elseif enemy.health <= wDmg + eDmg then
        KillText[i] = TextList[3] .."+".. TextList[4]
      elseif enemy.health <= wDmg + rDmg then
        KillText[i] = TextList[3] .."+".. TextList[5]
      elseif enemy.health <= eDmg + rDmg then
        KillText[i] = TextList[4] .."+".. TextList[5]
      elseif enemy.health <= qDmg + wDmg + eDmg then
        KillText[i] = TextList[2] .."+".. TextList[3] .."+".. TextList[4]
      elseif enemy.health <= qDmg + wDmg + eDmg + rDmg then
        KillText[i] = TextList[2] .."+".. TextList[3] .."+".. TextList[4] .."+".. TextList[5]
      elseif enemy.health <= dfgDmg + ((qDmg + wDmg + eDmg + rDmg) + (0.2 * (qDmg + wDmg + eDmg + rDmg))) then
        KillText[i] = TextList[7]
      else
        KillText[i] = TextList[1]
      end
    end
  end
end

function OnDraw() 
  if not myHero.dead then
        if Menu.drawings.drawAA then DrawCircle(myHero.x, myHero.y, myHero.z, 550, ARGB(25 , 255, 51, 153)) end
        if Menu.drawings.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillQ.range, ARGB(25 ,255, 51, 153)) end
        if Menu.drawings.drawW then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillW.range, ARGB(25 ,255, 51, 153)) end
        if Menu.drawings.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillE.range, ARGB(25 , 255, 51, 153)) end
        if Menu.drawings.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillR.range, ARGB(25 , 255, 51, 153)) end
    end
if _G.ShowTextDraw then
    for i = 1, heroManager.iCount do
	    local enemy = heroManager:GetHero(i)
	    if ValidTarget(enemy) and enemy ~= nil then
	      local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z)) --(Credit to Zikkah)
	      local PosX = barPos.x - 35
	      local PosY = barPos.y - 10
	      if KillText[i] ~= 10 then
	        DrawText(TextList[KillText[i]], 16, PosX, PosY, colorText)
	      else
	        DrawText(TextList[KillText[i]] .. string.format("%4.1f", ((enemy.health - (qDmg + pDmg + eDmg + itemsDmg)) * (1/rDmg)) * 2.5) .. "s = Kill", 16, PosX, PosY, colorText)
	      end
	    end
	end
end
if not myHero.dead and target ~= nil then	
		if ValidTarget(target) then 
		--	if Settings.drawing.text then 
				DrawText3D("Focus This Bitch!",target.x-100, target.y-50, target.z, 20, 0xFFFF9900) --0xFF9900
			end
			--[[if target ~= nil then 
				DrawCircle(target.x, target.y, target.z, 150, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
			end--]]
		end
end

function level()
  return myHero.level

end

  
    


  



lastLeftClick = 0 
--- thxx too klokje!

lastLeftClick = 0 
--- thxx too klokje!
kijk = 0
tijd = math.huge
click = 0
time = math.huge
function OnWndMsg(Msg, Key)
	
	
	if Msg == WM_LBUTTONUP then
        click = click + 1
        time = GetGameTimer()
      
		local minD = 0
		local target = nil
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) and unit.type == myHero.type then
				if GetDistance(unit, mousePos) <= minD or target == nil then
					minD = GetDistance(unit, mousePos)
					target = unit
         
    
    
    if target and minD < 115 then
        
			if SelectedTarget and target.charName == SelectedTarget.charName then
				SelectedTarget = nil
			else
				SelectedTarget = target
        pis = true
        kut = GetGameTimer()
   
             
          end
			end
		end
  end
  end
      
      end
        
	end
function DoubleClick()
if target ~= nil and target.type == myHero.type and target.team ~= myHero.team then
  if skills.SkillR.ready and ValidTarget(target, skills.SkillR.range) and Menu.JaxCombo.rSet.Click then
    CastSpell(_R, target)
  end
  end
end









function KS()

  if target ~= nil and target.type == myHero.type and target.team ~= myHero.team and Menu.Ads.KS.KS then
  for i=1, heroManager.iCount do
    local enemy = heroManager:GetHero(i)
    if ValidTarget(enemy) and enemy ~= nil then
      qDmg = getDmg("Q", enemy,myHero)
      qmDmg = getDmg("QM", enemy,myHero)
      wDmg = getDmg("W", enemy,myHero)
      eDmg = getDmg("E", enemy,myHero)
      rDmg = getDmg("R", enemy,myHero)
      dfgDmg = getDmg("DFG", enemy, myHero)
      
   
    end
  end
end
end

function AreaEnemyCount()
	local count = 0
		for _, enemy in pairs(GetEnemyHeroes()) do
			if enemy and not enemy.dead and enemy.visible and GetDistance(myHero, enemy) < 1000 then
				count = count + 1
			end
		end              
	return count
end
function OnTowerFocus(tower, target) 
 
  if target ~= nil and tower ~= nil then
       if tower.team ~= myHero.team then
         if unit.team ~= myHero.team then
          return true
       end
     end
  end
 

end


-- thx HTTF<3



function UnitAtTower(unit,offset)
  for i, turret in pairs(GetTurrets()) do
    if turret ~= nil and GetDistance(target) <= 1550 then
      if turret.team ~= myHero.team then
        if GetDistance(unit, turret) <= turret.range+offset then
          return true
        end
      end
    end
  end
  return false
end

    local JungleMobs = {}
       JungleNames = { 


["SRU_BlueMini21.1.3"]        = true,
["SRU_BlueMini1.1.2"]         = true,
["SRU_RedMini4.1.2"]          = true,
["SRU_RedMini4.1.3"]          = true,
["SRU_MurkwolfMini2.1.3"]     = true,
["SRU_MurkwolfMini2.1.2"]     = true, 
["SRU_RazorbeakMini3.1.2"]    = true,
["SRU_RazorbeakMini3.1.3"]    = true,
["SRU_RazorbeakMini3.1.4"]    = true,
["SRU_KrugMini5.1.1"]         = true,
["SRU_BlueMini27.1.3"]        = true,
["SRU_BlueMini7.1.2"]         = true,
["SRU_RedMini10.1.3"]         = true,
["SRU_RedMini10.1.2"]         = true,
["SRU_MurkwolfMini8.1.3"]     = true,
["SRU_MurkwolfMini8.1.2"]     = true,
["SRU_RazorbeakMini9.1.2"]    = true,
["SRU_RazorbeakMini9.1.3"]    = true,
["SRU_RazorbeakMini9.1.4"]    = true,    
["SRU_KrugMini11.1.1"]        = true,
["SRU_Blue1.1.1"]             = true,
["SRU_Red4.1.1"]              = true,
["SRU_Murkwolf2.1.1"]         = true,
["SRU_Razorbeak3.1.1"]        = true,
["SRU_Krug5.1.2"]             = true,
["SRU_Gromp13.1.1"]           = true,
["Sru_Crab15.1.1"]            = true,
["SRU_Blue7.1.1"]             = true,
["SRU_Red10.1.1"]             = true,
["SRU_Murkwolf8.1.1"]         = true,
["SRU_Razorbeak9.1.1"]        = true,
["SRU_Krug11.1.2"]            = true,
["SRU_Gromp14.1.1"]           = true,
["Sru_Crab16.1.1"]            = true,
["SRU_Dragon6.1.1"]           = true,        
["SRU_Baron12.1.1"]           = true,
}



function GetJungleMob()
 -- print("1")
	if JungleMobs ~= nil and #JungleMobs > 0 then
   --  print("2")
        for i, Mob in ipairs(JungleMobs) do
                if ValidTarget(Mob, 1100) and Mob.name ~= nil then return Mob end
        end
    else
    	return nil
    end
end



function OnDeleteObj(obj)

	if obj ~= nil then
		for i, Mob in ipairs(JungleNames) do
			if obj.name == Mob.name then
				table.remove(JungleMobs, i)
			end
		end
	
	
end
end


    camp1 = {x = 8400, y = 50.904, z = 2692}
    camp2 = {x = 7772, y = 53.937, z = 4008}
    camp3 = {x = 6902, y = 54.194, z = 5468}
    camp4 = {x = 3856, y = 52.463, z = 6510}
    camp5 = {x = 3874, y = 51.890, z = 7806}
    camp6 = {x = 2046, y = 51.777, z = 8458}
    camp7 = {x = 5030, y = -71.240, z = 10456}
    camp8 = {x = 6492, y = 56.476, z = 12128}
    camp9 = {x = 6894, y = 55.999, z = 10744}
    camp10 = {x = 7902, y = 5.359, z = 9448}
    camp11 = {x = 10910, y = 62.664, z = 8282}
    camp12 = {x = 10870, y = 51.722, z = 7056}
    camp13 = {x = 12762, y = 51.667, z = 6506}
    camp14 = {x = 9760, y = -71.240, z = 4364}
  

function Monster()
  --print(" hij komt hier")
  if skills.SkillQ.ready  then
  
  if GetDistance(camp1, myHero) <= 1100 then
 --   print(" hier ook")
    CastSpell(_Q, camp1.x, camp1.z)
 elseif GetDistance(camp2, myHero) <= 1100 then
    CastSpell(_Q, camp2.x, camp2.z)
    elseif GetDistance(camp3, myHero) <= 1100 then
    CastSpell(_Q, camp3.x, camp3.z)
    elseif GetDistance(camp4, myHero) <= 1100 then
    CastSpell(_Q, camp4.x, camp4.z)
    elseif GetDistance(camp5, myHero) <= 1100 then
    CastSpell(_Q, camp5.x, camp5.z)
    elseif GetDistance(camp6, myHero) <= 1100 then
    CastSpell(_Q, camp6.x, camp6.z)
    elseif GetDistance(camp7, myHero) <= 1100 then
    CastSpell(_Q, camp7.x, camp7.z)
    elseif GetDistance(camp8, myHero) <= 1100 then
    CastSpell(_Q, camp8.x, camp8.z)
    elseif GetDistance(camp9, myHero) <= 1100 then
    CastSpell(_Q, camp9.x, camp9.z)
    elseif GetDistance(camp10, myHero) <= 1100 then
    CastSpell(_Q, camp10.x, camp10.z)
    elseif GetDistance(camp11, myHero) <= 1100 then
    CastSpell(_Q, camp11.x, camp11.z)
    elseif GetDistance(camp12, myHero) <= 1100 then
    CastSpell(_Q, camp12.x, camp12.z)
    elseif GetDistance(camp2, myHero) <= 1100 then
    CastSpell(_Q, camp13.x, camp13.z)
    elseif GetDistance(camp2, myHero) <= 1100 then
    CastSpell(_Q, camp14.x, camp14.z)
    end
  
  end
  end

function Escape()
  --print(TargetJungleMob)
	TargetJungleMob = GetJungleMob()
	if TargetJungleMob ~= nil and ValidTarget(TargetJungleMob, 1100) and GetDistance(TargetJungleMob, myHero) < 1100 then
			if skills.SkillQ.ready and not TargetJungleMob.dead then
     --   print("stap2")
				CastSpell(_Q, TargetJungleMob.x, TargetJungleMob.z)
       
			end
			
	end
end

function ASLoadMinions()    
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then  
			if JungleNames[object.name] then
				table.insert(JungleMobs, object)
			end

end
end
end
