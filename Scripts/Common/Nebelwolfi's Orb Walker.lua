_G.NebelwolfisOrbWalkerVersion = 0.463
_G.NebelwolfisOrbWalkerInit    = true
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("VILKPOHMQNO") 

DelayAction(function()
  if not _G.NebelwolfisOrbWalkerLoaded then
    now = NebelwolfisOrbWalker()
  end
end, 0.25)

class "NebelwolfisOrbWalker" -- {

  function NebelwolfisOrbWalker:__init(Cfg)
    _G.NebelwolfisOrbWalkerLoaded = true
    self.altAttacks = Set { "caitlynheadshotmissile", "frostarrow", "garenslash2", "kennenmegaproc", "lucianpassiveattack", "masteryidoublestrike", "quinnwenhanced", "renektonexecute", "renektonsuperexecute", "rengarnewpassivebuffdash", "trundleq", "xenzhaothrust", "xenzhaothrust2", "xenzhaothrust3" }
    self.resetAttacks = Set { "dariusnoxiantacticsonh", "fioraflurry", "garenq", "hecarimrapidslash", "jaxempowertwo", "jaycehypercharge", "leonashieldofdaybreak", "luciane", "lucianq", "monkeykingdoubleattack", "mordekaisermaceofspades", "nasusq", "nautiluspiercinggaze", "netherblade", "parley", "poppydevastatingblow", "powerfist", "renektonpreexecute", "rengarq", "shyvanadoubleattack", "sivirw", "takedown", "talonnoxiandiplomacy", "trundletrollsmash", "vaynetumble", "vie", "volibearq", "xenzhaocombotarget", "yorickspectral", "reksaiq", "riventricleave", "itemtitanichydracleave", "itemtiamatcleave" }
    if not UPLloaded and not _G.HP then 
      require("HPrediction") 
      self.HP = HPrediction() 
      _G.HP = self.HP 
    else 
      if UPLloaded then
        self.HP = UPL.HP 
      elseif _G.HP then
        self.HP = _G.HP
      end
    end
    if not UPLloaded then require("VPrediction") self.VP = VPrediction() else self.VP = UPL.VP end
    self:Load(Cfg)
    print("<font color=\"#ff0000\">[</font><font color=\"#ff2000\">N</font><font color=\"#ff4000\">e</font><font color=\"#ff5f00\">b</font><font color=\"#ff7f00\">e</font><font color=\"#ff9f00\">l</font><font color=\"#ffbf00\">w</font><font color=\"#ffdf00\">o</font><font color=\"#ffff00\">l</font><font color=\"#ccff00\">f</font><font color=\"#99ff00\">i</font><font color=\"#66ff00\">'</font><font color=\"#33ff00\">s</font><font color=\"#00ff00\"> </font><font color=\"#00ff40\">O</font><font color=\"#00ff80\">r</font><font color=\"#00ffbf\">b</font><font color=\"#00ffff\"> </font><font color=\"#00bfff\">W</font><font color=\"#0080ff\">a</font><font color=\"#0040ff\">l</font><font color=\"#0000ff\">k</font><font color=\"#2300ff\">e</font><font color=\"#4600ff\">r</font><font color=\"#6800ff\">]</font><font color=\"#8b00ff\">:</font> <font color=\"#FFFFFF\">Loaded! (v".._G.NebelwolfisOrbWalkerVersion..")</font>") 
    self:Update()
    _G.NebelwolfisOrbWalker = self
    return self
  end

  function NebelwolfisOrbWalker:Update()
    CScriptUpdate(_G.NebelwolfisOrbWalkerVersion, true, "raw.githubusercontent.com", "/nebelwolfi/BoL/master/Nebelwolfi%27s%20Orb%20Walker.version", "/nebelwolfi/BoL/master/Nebelwolfi%27s%20Orb%20Walker.lua?rand="..math.random(1,10000), SCRIPT_PATH.."Nebelwolfi's Orb Walker.lua", function() end, function() end, function(NewVersion,OldVersion) print("<font color=\"#ff0000\">[</font><font color=\"#ff2000\">N</font><font color=\"#ff4000\">e</font><font color=\"#ff5f00\">b</font><font color=\"#ff7f00\">e</font><font color=\"#ff9f00\">l</font><font color=\"#ffbf00\">w</font><font color=\"#ffdf00\">o</font><font color=\"#ffff00\">l</font><font color=\"#ccff00\">f</font><font color=\"#99ff00\">i</font><font color=\"#66ff00\">'</font><font color=\"#33ff00\">s</font><font color=\"#00ff00\"> </font><font color=\"#00ff40\">O</font><font color=\"#00ff80\">r</font><font color=\"#00ffbf\">b</font><font color=\"#00ffff\"> </font><font color=\"#00bfff\">W</font><font color=\"#0080ff\">a</font><font color=\"#0040ff\">l</font><font color=\"#0000ff\">k</font><font color=\"#2300ff\">e</font><font color=\"#4600ff\">r</font><font color=\"#6800ff\">]</font><font color=\"#8b00ff\">:</font> <font color=\"#FFFFFF\">Updated. (v"..OldVersion.." -> v"..NewVersion..")</font>") end, function() print("<font color=\"#ff0000\">[</font><font color=\"#ff2000\">N</font><font color=\"#ff4000\">e</font><font color=\"#ff5f00\">b</font><font color=\"#ff7f00\">e</font><font color=\"#ff9f00\">l</font><font color=\"#ffbf00\">w</font><font color=\"#ffdf00\">o</font><font color=\"#ffff00\">l</font><font color=\"#ccff00\">f</font><font color=\"#99ff00\">i</font><font color=\"#66ff00\">'</font><font color=\"#33ff00\">s</font><font color=\"#00ff00\"> </font><font color=\"#00ff40\">O</font><font color=\"#00ff80\">r</font><font color=\"#00ffbf\">b</font><font color=\"#00ffff\"> </font><font color=\"#00bfff\">W</font><font color=\"#0080ff\">a</font><font color=\"#0040ff\">l</font><font color=\"#0000ff\">k</font><font color=\"#2300ff\">e</font><font color=\"#4600ff\">r</font><font color=\"#6800ff\">]</font><font color=\"#8b00ff\">:</font> <font color=\"#FFFFFF\">Error downloading.....</font>") end)
    CScriptUpdate(_G.NebelwolfisOrbWalkerVersion, true, "raw.githubusercontent.com", "/nebelwolfi/BoL/master/Nebelwolfi%27s%20Orb%20Walker.version", "/nebelwolfi/BoL/master/Nebelwolfi%27s%20Orb%20Walker.lua?rand="..math.random(1,10000), LIB_PATH.."Nebelwolfi's Orb Walker.lua", function() end, function() end, function(NewVersion,OldVersion) end, function() end)
  end

  function NebelwolfisOrbWalker:Load(Cfg)
    self:LoadVars(Cfg)
    self:LoadMenu()
    self:LoadCallbacks()
  end

  function NebelwolfisOrbWalker:LoadVars(Cfg)
    DelayAction(function()
      self.melee = (myHero.range < 450 or myHero.charName == "Rengar") and myHero.charName ~= "Nidalee" and myHero.charName ~= "Jayce" and myHero.charName ~= "Elise"
    end, 2)
    self.Mobs = MinionManager()
    self.orbDisabled = false
    local delay = 0
    if (Set {"Akali", "Maokai", "Olaf", "Shaco"})[myHero.charName] then
      delay = -0.1
    elseif (Set {"Kennen", "Teemo"})[myHero.charName] then
      delay = -0.0947
    elseif (Set {"Draven", "MasterYi", "Pantheon", "Rengar", "Sion", "Twitch", "Warwick"})[myHero.charName] then
      delay = -0.08
    elseif (Set {"Fiora", "XinZhao"})[myHero.charName] then
      delay = -0.07
    elseif (Set {"Hecarim", "Sejuani", "Trundle", "Tryndamere"})[myHero.charName] then
      delay = -0.0672
    elseif (Set {"Ahri", "KhaZix", "Nocturne", "Quinn", "Talon"})[myHero.charName] then
      delay = -0.065
    elseif (Set {"RekSai"})[myHero.charName] then
      delay = -0.063
    elseif (Set {"Irelia", "KogMaw", "Renekton"})[myHero.charName] then
      delay = -0.06
    elseif (Set {"Ashe", "Fizz", "JarvanIV", "Jayce", "Kalista", "Katarina", "Orianna", "Shyvana", "Sivir", "Udyr", "Varus", "Vayne", "Viktor", "Vladimir", "Volibear", "Wukong", "Yasuo", "Zed"})[myHero.charName] then
      delay = -0.05
    elseif (Set {"MissFortune", "Tristana", "Ziggs"})[myHero.charName] then
      delay = -0.04734
    elseif (Set {"Aatrox", "Gangplank", "Gragas", "LeeSin", "Shen", "TwistedFate"})[myHero.charName] then
      delay = -0.04
    elseif (Set {"Cassiopeia"})[myHero.charName] then
      delay = -0.034
    elseif (Set {"Braum", "Ekko", "Nami", "Rumble", "Sona", "Urgot", "Vi"})[myHero.charName] then
      delay = -0.03
    elseif (Set {"Kassadin"})[myHero.charName] then
      delay = -0.025
    elseif (Set {"Amumu", "Galio", "Jax", "Kayle", "Lucian", "Malphite", "Nasus", "Nidalee", "Poppy", "Zac"})[myHero.charName] then
      delay = -0.02
    elseif (Set {"Olaf", "Shaco"})[myHero.charName] then
      delay = -0.01
    elseif (Set {"Nautilus", "Singed", "TahmKench"})[myHero.charName] then
      delay = 0.02
    elseif (Set {"Mordekaiser"})[myHero.charName] then
      delay = 0.04
    elseif (Set {"Annie"})[myHero.charName] then
      delay = 0.08
    end
    self.orbTable = { lastAA = 0, windUp = 13.37, animation = 13.37, aaDelay = delay }
    self.doAA = true
    self.doMove = true
    self.myRange = myHero.range+myHero.boundingRadius*2
    self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, self.myRange, DAMAGE_PHYSICAL, false, true)
    self.Target = nil
    self.soldiers = {}
    ArrangeTSPriorities()
    self.Config = Cfg or scriptConfig("NebelwolfisOrbWalker", "SW"..myHero.charName)
  end

  function NebelwolfisOrbWalker:LoadMenu()
    self.Config:addSubMenu("Modes", "m")
      self.Config.m:addSubMenu("Carry Mode", "Combo")
        self.Config.m.Combo:addParam("Attack", "Attack", SCRIPT_PARAM_ONOFF, true)
        self.Config.m.Combo:addParam("Move", "Move", SCRIPT_PARAM_ONOFF, true)
      self.Config.m:addSubMenu("Harass Mode", "Harass")
        self.Config.m.Harass:addParam("Priority", "Priority", SCRIPT_PARAM_LIST, 1, {"LastHit", "Harass"})
        self.Config.m.Harass:addParam("Attack", "Attack", SCRIPT_PARAM_ONOFF, true)
        self.Config.m.Harass:addParam("Move", "Move", SCRIPT_PARAM_ONOFF, true)
      self.Config.m:addSubMenu("LastHit Mode", "LastHit")
        self.Config.m.LastHit:addParam("AttackE", "Attack Enemy on Lasthit (Anti-Farm)", SCRIPT_PARAM_ONOFF, true)
        self.Config.m.LastHit:addParam("Attack", "Attack", SCRIPT_PARAM_ONOFF, true)
        self.Config.m.LastHit:addParam("Move", "Move", SCRIPT_PARAM_ONOFF, true)
      self.Config.m:addSubMenu("LaneClear Mode", "LaneClear")
        --self.Config.m.LaneClear:addParam("AttackW", "Attack Wards", SCRIPT_PARAM_ONOFF, true) -- soon
        self.Config.m.LaneClear:addParam("Attack", "Attack", SCRIPT_PARAM_ONOFF, true)
        self.Config.m.LaneClear:addParam("Move", "Move", SCRIPT_PARAM_ONOFF, true)
    self.Config:addSubMenu("Hotkeys", "k")
      self.Config.k:addParam("info", "                    Mode Hotkeys", SCRIPT_PARAM_INFO, "")
      self.Config.k:addDynamicParam("Combo", "Carry Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
      self.Config.k:addDynamicParam("Harass", "Harass Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
      self.Config.k:addDynamicParam("LastHit", "LastHit Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
      self.Config.k:addDynamicParam("LaneClear", "LaneClear Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
      self.Config.k:addParam("info", "", SCRIPT_PARAM_INFO, "")
      self.Config.k:addParam("info", "                    Other Hotkeys", SCRIPT_PARAM_INFO, "")
      self.Config.k:addParam("Mouse", "Left-Click Action", SCRIPT_PARAM_LIST, 1, {"None", "Carry Mode", "Target Lock"})
      self.Config.k:addParam("TargetLock", "Target Lock", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
      self.Config.k:addParam("LaneFreeze", "Lane Freeze (F1)", SCRIPT_PARAM_ONKEYTOGGLE, false, 112)
    self.Config:addSubMenu("Settings", "s")
      self.Config.s:addParam("Buildings", "Attack Selected Buildings", SCRIPT_PARAM_ONOFF, true)
      self.Config.s:addParam("WindUpNoticeStart", "Show AA notice on GameStart", SCRIPT_PARAM_ONOFF, true)
      self.Config.s:addParam("OverHeroStopMove", "Mouse over Hero to stop move", SCRIPT_PARAM_ONOFF, false)
    self.Config:addSubMenu("Target Selector", "ts")
      self.Config.ts:addTS(self.ts)
    self.Config:addSubMenu("Items", "i")
      self.Config.i:addSubMenu("Carry Mode", "Combo")
        self.Config.i.Combo:addParam("BRK", "Blade of the Ruined King", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Combo:addParam("BWC", "Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Combo:addParam("HXG", "Hextech Gunblade", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Combo:addParam("HYDRA", "Ravenous Hydra", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Combo:addParam("TITANICHYDRA", "Titanic Hydra", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Combo:addParam("TIAMAT", "Tiamat", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Combo:addParam("ENT", "Entropy", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Combo:addParam("YGB", "Yomuu's Ghostblade", SCRIPT_PARAM_ONOFF, true)
      self.Config.i:addSubMenu("Harass Mode", "Harass")
        self.Config.i.Harass:addParam("BRK", "Blade of the Ruined King", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Harass:addParam("BWC", "Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Harass:addParam("HXG", "Hextech Gunblade", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Harass:addParam("HYDRA", "Ravenous Hydra", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Harass:addParam("TITANICHYDRA", "Titanic Hydra", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Harass:addParam("TIAMAT", "Tiamat", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Harass:addParam("ENT", "Entropy", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Harass:addParam("YGB", "Yomuu's Ghostblade", SCRIPT_PARAM_ONOFF, true)
      self.Config.i:addSubMenu("Farm Modes", "Farm")
        self.Config.i.Farm:addParam("BRK", "Blade of the Ruined King", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Farm:addParam("BWC", "Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Farm:addParam("HXG", "Hextech Gunblade", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Farm:addParam("HYDRA", "Ravenous Hydra", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Farm:addParam("TITANICHYDRA", "Titanic Hydra", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Farm:addParam("TIAMAT", "Tiamat", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Farm:addParam("ENT", "Entropy", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Farm:addParam("YGB", "Yomuu's Ghostblade", SCRIPT_PARAM_ONOFF, true)
        self.Config.i.Farm:addParam("info", "", SCRIPT_PARAM_INFO, "")
        self.Config.i.Farm:addParam("tialast", "Use Tiamat/Hydra to Lasthit", SCRIPT_PARAM_ONOFF, true)
    self.Config:addSubMenu("Farm Settings", "f")
      self.Config.f:addSubMenu("Masteries", "m")
        self.Config.f.m:addParam("Butcher", "Butcher", SCRIPT_PARAM_ONOFF, false)
        self.Config.f.m:addParam("ArcaneBlade", "Arcane Blade", SCRIPT_PARAM_ONOFF, false)
        self.Config.f.m:addParam("Havoc", "Havoc", SCRIPT_PARAM_ONOFF, false)
        self.Config.f.m:addParam("DESword", "Double-Edged Sword", SCRIPT_PARAM_ONOFF, false)
        self.Config.f.m:addParam("Executioner", "Executioner", SCRIPT_PARAM_SLICE, 0, 0, 3, 0)
      self.Config.f:addParam("l", "LaneClear method", SCRIPT_PARAM_LIST, 1, {"Highest", "Stick to 1"})
    DelayAction(function()
      if (myHero.range < 450 or myHero.charName == "Rengar") and myHero.charName ~= "Nidalee" and myHero.charName ~= "Jayce" and myHero.charName ~= "Elise" then
        self.Config:addSubMenu("Melee Settings", "melee")
          self.Config.melee:addParam("wtt", "Walk/Stick to target", SCRIPT_PARAM_ONOFF, true)
      end
    end, 2)
    self.Config:addSubMenu("Draw Settings", "d")
      self.Config.d:addSubMenu("Minion Drawing", "md")
      self.Config.d.md:addParam("HPB", "Draw Cut HP Bars (LastHit Mode)", SCRIPT_PARAM_ONOFF, false)
      self.Config.d.md:addParam("LHI", "Draw LastHit Indicator (LastHit Mode)", SCRIPT_PARAM_ONOFF, true)
      self.Config.d.md:addParam("HPBa", "Always Draw Cut HP Bars", SCRIPT_PARAM_ONOFF, false)
      self.Config.d.md:addParam("LHIa", "Always Draw LastHit Indicator", SCRIPT_PARAM_ONOFF, false)
      self.Config.d:addParam("AAS", "Own AA Circle", SCRIPT_PARAM_ONOFF, true)
      self.Config.d:addParam("AAE", "Enemy AA Circles", SCRIPT_PARAM_ONOFF, true)
      self.Config.d:addParam("LFC", "Lag Free Circles", SCRIPT_PARAM_ONOFF, true)
      self.Config.d:addParam("d", "Draw - General toggle", SCRIPT_PARAM_ONOFF, true)
    self.Config:addSubMenu("Timing Settings", "t")
      self.Config.t:addParam("cad", "Cancel AA adjustment", SCRIPT_PARAM_SLICE, 0, -100, 100, 0)
      self.Config.t:addParam("lhadj", "Lasthit adjustment", SCRIPT_PARAM_SLICE, 0, -100, 100, 0)
      self.Config.t:addParam("time", "Humanizer", SCRIPT_PARAM_SLICE, 0, 0, 1000, 0)
    self.Config:addParam("info1", "", SCRIPT_PARAM_INFO, "")
    self.Config:addParam("info2", "Version:", SCRIPT_PARAM_INFO, "v"..NebelwolfisOrbWalkerVersion)
  end

  function NebelwolfisOrbWalker:LoadCallbacks()
    AddTickCallback(function() self:Tick() end)
    AddDrawCallback(function() self:Draw() end)
    AddProcessSpellCallback(function(x,y) self:ProcessSpell(x,y) end)
    if VIP_USER then
      AddRecvPacketCallback2(function(p) self:RecvPacket(p) end)
    end
    AddCreateObjCallback(function(o) self:CreateObj(o) end)
  end

  oTick=0;function NebelwolfisOrbWalker:Tick()
    if self:DoOrb() and oTick <= os.clock() then
      oTick = os.clock() + self.Config.t.time / 1000
      self.Target = self:AcquireTarget()
      self.myRange = myHero.range+myHero.boundingRadius+(self.Target and self.Target.boundingRadius or myHero.boundingRadius)
      self:Orb(self.Target)
    end
  end

  function NebelwolfisOrbWalker:DoOrb()
    return self.Config.k.Combo or (IsKeyDown(1) and self.Config.k.Mouse == 2) or self.Config.k.Harass or self.Config.k.LastHit or self.Config.k.LaneClear
  end

  function NebelwolfisOrbWalker:DoAA()
    return self.doAA and ((self.Config.k.Combo or (IsKeyDown(1) and self.Config.k.Mouse == 2)) and self.Config.m.Combo.Attack) or (self.Config.k.Harass and self.Config.m.Harass.Attack) or (self.Config.k.LastHit and self.Config.m.LastHit.Attack) or (self.Config.k.LaneClear and self.Config.m.LaneClear.Attack)
  end

  function NebelwolfisOrbWalker:DoMove()
    return self.doMove and ((self.Config.k.Combo or (IsKeyDown(1) and self.Config.k.Mouse == 2)) and self.Config.m.Combo.Move) or (self.Config.k.Harass and self.Config.m.Harass.Move) or (self.Config.k.LastHit and self.Config.m.LastHit.Move) or (self.Config.k.LaneClear and self.Config.m.LaneClear.Move)
  end

  function NebelwolfisOrbWalker:Orb(unit)
    if self:TimeToAttack() and unit then
      self:Attack(unit)
    elseif self:TimeToMove() then
      local pos = nil
      if self.melee and self.Config.melee and self.Config.melee.wtt and unit and unit.type == myHero.type then
        if GetDistance(unit) > GetDistance(myHero.minBBox) then
          if unit.hasMovePath then
            pos = Vector(unit:GetPath(unit.pathIndex))
          else
            pos = unit.pos
          end
        end
      else
        pos = mousePos
      end
      self:Move(self.fPos or pos)
    end
  end

  function NebelwolfisOrbWalker:TimeToAttack()
    return os.clock() - GetLatency() / 2000 > self.orbTable.lastAA + self.orbTable.animation and self:DoAA()
  end

  function NebelwolfisOrbWalker:TimeToMove()
    return os.clock() - GetLatency() / 2000 > self.orbTable.lastAA + self.orbTable.windUp + self.Config.t.cad/1000 and self:DoMove()
  end

  function NebelwolfisOrbWalker:Draw()
    if not self.Config.d.d then return end
    if (self.orbTable.windUp == 13.37 or self.orbTable.animation == 13.37) and self.Config.s.WindUpNoticeStart then
      DrawText("Please attack something with an unbuffed autoattack", 20, WINDOW_W/3, WINDOW_H/6, ARGB(255,255,255,255))
    end
    if self.Config.d.AAS then
      SCircle(myHero, myHero.range+GetDistance(myHero.minBBox), self.Config.d.LFC, 0x7F00FF00)
      if myHero.charName == "Azir" then
        for _, thing in pairs(self.soldiers) do
          if thing.time > os.clock() then
            SCircle(thing.obj, 350, self.Config.d.LFC, 0x7F00FF00)
          end
        end
      end
    end
    if self.Config.d.AAE then
      for _, enemy in pairs(GetEnemyHeroes()) do
        if enemy and not enemy.dead and enemy.visible and GetDistanceSqr(enemy) < (self.myRange*2)^2 then
          SCircle(enemy, enemy.range+GetDistance(enemy,enemy.minBBox), self.Config.d.LFC, 0x7FFF0000)
        end
      end
    end
    if (self.Forcetarget or self.Locktarget) and self.Target then
      SCircle(self.Target, self.Target.boundingRadius*2-10, self.Config.d.LFC, 0xFFFF0000)
      SCircle(self.Target, self.Target.boundingRadius*2-5, self.Config.d.LFC, 0xFFFF0000)
      SCircle(self.Target, self.Target.boundingRadius*2, self.Config.d.LFC, 0xFFFF0000)
      local barPos = WorldToScreen(D3DXVECTOR3(self.Target.x, self.Target.y, self.Target.z))
      DrawText("Target-Lock", 18, barPos.x - 35, barPos.y, ARGB(255, 255, 255, 255))
    end
    if self.Mobs then
      if (self.Config.d.md.HPB and self.Config.k.LastHit or self.Config.d.md.HPBa) or (self.Config.d.md.LHI and self.Config.k.LastHit or self.Config.d.md.LHIa) then
        for i, minion in pairs(self.Mobs.objects) do
          if minion and not minion.dead and minion.visible then
            if self.Config.d.md.HPB and self.Config.k.LastHit or self.Config.d.md.HPBa then
              local barPos = GetUnitHPBarPos(minion)
              local barOffset = GetUnitHPBarOffset(minion)
              local drawPos = {x = barPos.x + barOffset.x - 32, y = barPos.y + barOffset.y - 2.5}
              DrawRectangleOutline(drawPos.x, drawPos.y, 63, 5, 0x5f000000, 2)
              local dmg = self:GetDmg(myHero, minion)
              local width = 63 * dmg / minion.maxHealth
              local loss = 63 * (minion.maxHealth - minion.health) / minion.maxHealth
              for _ = 0, 63 - loss - width, width do
                DrawRectangleOutline(drawPos.x + _, drawPos.y, width, 5, 0x5f000000, 1)
              end
            end
            if self.Config.d.md.LHI and self.Config.k.LastHit or self.Config.d.md.LHIa then
              local hp = self.HP:PredictHealth(minion, (math.min(self.myRange, GetDistance(myHero, minion)) / (self.VP.projectilespeeds[myHero.charName] or 1800) + self.orbTable.windUp + self.Config.t.lhadj/100 - 0.07))
              local hp2 = self.HP:PredictHealth(minion, 2 * (math.min(self.myRange, GetDistance(myHero, minion)) / (self.VP.projectilespeeds[myHero.charName] or 1800) + self.orbTable.windUp + self.Config.t.lhadj/100 - 0.07))
              local barPos = GetUnitHPBarPos(minion)
              local barOffset = GetUnitHPBarOffset(minion)
              local drawPos = {x = barPos.x + barOffset.x - 62, y = barPos.y + barOffset.y - 15}
              dmg = self:GetDmg(myHero, minion)
              if dmg and (hp <= dmg or minion.health <= dmg) then
                DrawText(">>", 30, drawPos.x, drawPos.y, 0xFF00FF00)
                DrawText("<<", 30, drawPos.x+63+30, drawPos.y, 0xFF00FF00)
              elseif dmg and (hp2 <= dmg or minion.health <= dmg*2) then
                DrawText(">>", 30, drawPos.x, drawPos.y, 0xFFFFFFFF)
                DrawText("<<", 30, drawPos.x+63+30, drawPos.y, 0xFFFFFFFF)
              end
            end
          end
        end
      end
    end
  end

  function NebelwolfisOrbWalker:GetAttackSpeed()
    return myHero.attackSpeed/(1/(0.625/(1+self.orbTable.aaDelay)))
  end

  function NebelwolfisOrbWalker:ProcessSpell(unit, spell)
    if unit and spell and spell.name then
      if unit.isMe then
        if spell.name:lower():find("attack") or self.altAttacks[spell.name:lower()] then
          local windUp = 1 / (1.6 * (0.3 + self.Config.t.cad))*myHero.attackSpeed
          self.orbTable.windUp = spell.windUpTime + GetLatency() / 2000
          self.orbTable.animation = 1 / self:GetAttackSpeed()
          self.orbTable.lastAA = os.clock()
          DelayAction(function()
            self:WindUp(self.Target) 
          end, spell.windUpTime + GetLatency() / 2000)
        end
        if self.resetAttacks[spell.name:lower()] then
          self.orbTable.lastAA = os.clock() - GetLatency() / 2000 - self.orbTable.animation
        end
        if spell.name == "AzirQ" then
          for _, thing in pairs(self.soldiers) do
            if thing.time > os.clock() then 
              thing.time = thing.time + 1
            end
          end
        end
      elseif unit.team ~= myHero.team and unit.type == myHero.type then
        if ValidTarget(unit, self.myRange) and self:TimeToAttack() and (spell.name:lower():find("attack") or self.altAttacks[spell.name:lower()]) and spell.target.type ~= myHero.type and self.Config.m.LastHit.AttackE and self.Config.k.LastHit and spell.target.health <= self:GetDmg(unit, spell.target) then
          myHero:Attack(unit)
        end
      end
    end
  end

  function NebelwolfisOrbWalker:RecvPacket(p)
    if p.header == 0x00F4 then
      p.pos=2
      if p:DecodeF() == myHero.networkID then
        p.pos=16
        if p:Decode1() == 0xEE then
          self.orbTable.lastAA = os.clock() - GetLatency() / 2000 - self.orbTable.animation
        end
      end
    end
  end

  function NebelwolfisOrbWalker:CreateObj(object)
    if object and object.valid and object.name then
      if object.name == "AzirSoldier" then
        self.soldiers[object.networkID] = { obj = object, time = os.clock() + 9}
      end
    end
  end

  function NebelwolfisOrbWalker:WindUp(unit)
    local Items = {
      ["ItemSwordOfFeastAndFamine"]   = { id = 3153, config = "BRK", range = 450, target = true},
      ["BilgewaterCutlass"]           = { id = 3144, config = "BWC", range = 450, target = true},
      ["HextechGunblade"]             = { id = 3146, config = "HXG", range = 700, target = true},
      ["OdinEntropicClaymore"]        = { id = 3184, config = "ENT", range = 350, target = false},
      ["ItemTiamatCleave"]            = { id = 3074, config = "HYDRA", range = 350, target = false},
      ["ItemTiamatCleave"]            = { id = 3077, config = "TIAMAT", range = 350, target = false},
      ["ItemTitanicHydraCleave"]      = { id = 3748, config = "TITANICHYDRA", range = 550, target = false},
      ["YoumusBlade"]                 = { id = 3142, config = "YGB", range = 600, target = false},
    }
    local Config = self.Config.k.Combo and self.Config.i.Combo or self.Config.k.Harass and self.Config.i.Harass or self.Config.k.LastHit and self.Config.i.LastHit or self.Config.k.LaneClear and self.Config.i.LaneClear or nil
    if Config and ValidTarget(unit, 700) then
      for slot = ITEM_1, ITEM_6 do
        local item = Items[myHero:GetSpellData(slot).name]
        if item then
          if Config[item.config] and GetDistance(unit) < item.range and myHero:CanUseSpell(slot) == READY then
            if item.target and unit.type == myHero.type then
              CastSpell(slot, unit)
            else
              if unit.type ~= myHero.type and (item.id == 3077 or item.id == 3074) and Config.tialast then
                if unit.health < GetDmg(myHero, unit)*0.6 then
                  CastSpell(slot)
                end
              else
                CastSpell(slot)
              end
            end
          end
        end
      end
    end
  end

  function NebelwolfisOrbWalker:AcquireTarget()
    local Target = nil
    self.ts:update()
    self.ts.range = (self.melee and self.Config.melee and self.Config.melee.wtt) and self.myRange*2 or (myHero.charName == "Azir" and 1100 or self.myRange)
    Target = self.ts.target
    if self.Config.k.Harass then
      target, health = self:GetLowestPMinion(self.myRange)
      dmg = self:GetDmg(myHero, target)
      if target and dmg and health <= dmg and (self.Config.Priority == 1 or not Target) then
        Target = target
      end
    elseif self.Config.k.LastHit then
      target, health = self:GetLowestPMinion(self.myRange)
      dmg = self:GetDmg(myHero, target, self.Config.k.LaneFreeze)
      if target and dmg and health <= dmg then
        Target = target
      end
      if health < 0 then 
        Target = nil 
      end
    elseif self.Config.k.LaneClear and self.Mobs then
      local t = GetTarget()
      if t and ValidTarget(t, self.myRange) and self.Config.s.Buildings and (t.type == "obj_AI_Turret" or t.type == "obj_HQ" or t.type == "obj_BarracksDampener") and t.team ~= myHero.team then
        Target, health = self:GetLowestPMinion(self.myRange)
        dmg = self:GetDmg(myHero, Target)
        if Target and dmg and health > dmg then
          Target = t
        end
        if health < 0 then Target = t end
      else
        Target = self:GetJMinion(self.myRange)
        if not Target then
          target, health, health2 = self:GetLowestPMinion(self.myRange)
          dmg = self:GetDmg(myHero,target)
          if dmg and health > dmg and health2 > dmg then
            if self.Config.f.l == 1 then
              mtarget, health, count = self:GetHighestPMinion(self.myRange)
              if mtarget == target and health ~= mtarget.health and count > 0 then
                Target = nil
              else
                Target = mtarget
              end
            elseif self.Config.f.l == 2 then
              if self.Target and self.Target.type == obj_AI_Minion then
                Target = self.Target
              else
                if health2 and health and dmg and health2 < dmg and health > dmg then
                  Target = nil
                else
                  Target = target
                end
              end
            end
          else
            if health2 and health and dmg and health2 <= dmg and health > dmg then
              Target = nil
            else
              Target = target
            end
          end
        end
      end
    else
      local t = GetTarget()
      if t and ValidTarget(t, self.myRange) and self.Config.k.Combo and self.Config.s.Buildings and (t.type == "obj_AI_Turret" or t.type == "obj_HQ" or t.type == "obj_BarracksDampener") and t.team ~= myHero.team then
        Target = t
      end
      if (self.Config.k.TargetLock or (IsKeyDown(1) and self.Config.k.Mouse == 3)) then
        if ValidTarget(Target) and not self.Locktarget then
          self.Locktarget = Target
        elseif self.Locktarget and ValidTarget(self.Locktarget, self.myRange*1.5) then
          Target = self.Locktarget
        else
          self.Locktarget = nil
        end
      else
        self.Locktarget = nil
      end
      if self.Forcetarget and ValidTarget(self.Forcetarget, self.myRange*1.5) then
        Target = self.Forcetarget
      else
        self.Forcetarget = nil
      end
    end
    return Target
  end

  function NebelwolfisOrbWalker:Attack(unit)
    if _G.Evade or _G.Evading or _G.evade or _G.evading or not self:DoAA() or not ValidTarget(unit) then return end
    myHero:Attack(unit)
  end

  function NebelwolfisOrbWalker:Move(pos)
    if _G.Evade or _G.Evading or _G.evade or _G.evading or not self:DoMove() or not pos then return end
    if self.Config.s.OverHeroStopMove then
      local movePos = myHero + (Vector(pos) - myHero):normalized() * myHero.boundingRadius * 2
      if GetDistance(pos) > myHero.boundingRadius then
        myHero:MoveTo(movePos.x, movePos.z)
      end
    else
      local movePos = myHero + (Vector(pos) - myHero):normalized() * 250
      if GetDistance(pos) > myHero.boundingRadius then
        myHero:MoveTo(movePos.x, movePos.z)
      else
        local movePos = myHero + (Vector(pos) - myHero):normalized() * 250
        myHero:MoveTo(movePos.x, movePos.z)
      end
    end
  end

  function NebelwolfisOrbWalker:SetAA(bool)
    self.doAA = bool
  end

  function NebelwolfisOrbWalker:SetMove(bool)
    self.doMove = bool
  end

  function NebelwolfisOrbWalker:SetOrb(bool)
    self.doAA = bool
    self.doMove = bool
  end

  function NebelwolfisOrbWalker:SetTarget(unit)
    self.Forcetarget = unit
  end

  function NebelwolfisOrbWalker:GetTarget()
    if not self.Target then
      self.Target = self:AcquireTarget()
    end
    return self.Target
  end

  function NebelwolfisOrbWalker:ForcePos(pos)
    self.fPos = pos
  end

  function NebelwolfisOrbWalker:GetLowestPMinion(range)
    local minionTarget = nil
    local health, health2 = 0, 0
    if self.Mobs then
      for i, minion in pairs(self.Mobs.objects) do
        if minion and not minion.dead and minion.visible and minion.maxHealth < 100000 and (minion.team == 100 or minion.team == 200) and GetDistanceSqr(minion) < range^2 then
          local hp = self.HP:PredictHealth(minion, (GetDistance(myHero, minion) / (self.VP.projectilespeeds[myHero.charName] or 1800) + self.orbTable.windUp + self.Config.t.lhadj/100 - 0.07))
          local hp2 = self.HP:PredictHealth(minion, 2 * (GetDistance(myHero, minion) / (self.VP.projectilespeeds[myHero.charName] or 1800) + self.orbTable.windUp + self.Config.t.lhadj/100 - 0.07))
          if minionTarget == nil and hp > 0 then 
            minionTarget = minion
            health = hp
            health2 = hp2
          elseif health >= hp and hp > 0 then
            minionTarget = minion
            health = hp
            health2 = hp2
          end
        end
      end
    end
    return minionTarget, health, health2
  end

  function NebelwolfisOrbWalker:GetHighestPMinion(range)
    local minionTarget = nil
    local health = 0
    local count = 0
    if self.Mobs then
      for i, minion in pairs(self.Mobs.objects) do
        if minion and not minion.dead and minion.visible and minion.maxHealth < 100000 and (minion.team == 100 or minion.team == 200) and GetDistanceSqr(minion) < range^2 then
          count = count + 1
          local hp = self.HP:PredictHealth(minion, (GetDistance(myHero, minion) / (self.VP.projectilespeeds[myHero.charName] or 1800) + self.orbTable.windUp + self.Config.t.lhadj/100 - 0.07))
          if minionTarget == nil then 
            minionTarget = minion
            health = hp
          elseif health <= hp and hp > 0 then
            minionTarget = minion
            health = hp
          end
        end
      end
    end
    return minionTarget, health, count
  end

  function NebelwolfisOrbWalker:GetJMinion(range)
    local minionTarget = nil
    if self.Mobs then
      for i, minion in pairs(self.Mobs.objects) do
        if minion and minion.visible and not minion.dead and minion.maxHealth < 100000 and minion.team > 200 and GetDistanceSqr(minion) < range^2 then
          if not minionTarget then
            minionTarget = minion
          elseif minionTarget.maxHealth < minion.maxHealth then
            minionTarget = minion
          end
        end
      end
    end
    return minionTarget
  end

  function NebelwolfisOrbWalker:GetDmg(source, target, freeze)
    if target == nil or source == nil then
      return
    end
    local ADDmg            = 0
    local APDmg            = 0
    local TRUEDmg          = 0
    local AP               = source.ap
    local Level            = source.level
    local TotalDmg         = source.totalDamage
    local crit             = myHero.critChance
    local crdm             = myHero.critDmg
    local ArmorPen         = math.floor(source.armorPen)
    local ArmorPenPercent  = math.floor(source.armorPenPercent*100)/100
    local MagicPen         = math.floor(source.magicPen)
    local MagicPenPercent  = math.floor(source.magicPenPercent*100)/100

    local Armor             = target.armor*ArmorPenPercent-ArmorPen
    local ArmorPercent      = Armor > 0 and math.floor(Armor*100/(100+Armor))/100 or math.ceil(Armor*100/(100-Armor))/100
    local MagicArmor        = target.magicArmor*MagicPenPercent-MagicPen
    local MagicArmorPercent = MagicArmor > 0 and math.floor(MagicArmor*100/(100+MagicArmor))/100 or math.ceil(MagicArmor*100/(100-MagicArmor))/100

    ADDmg = freeze and source.damage or TotalDmg
    if source.charName == "Ashe" then
      ADDmg = TotalDmg*1.1+(1+crit)*(1+crdm)
    elseif source.charName == "Kalista" then
      ADDmg = ADDmg * 0.9
    elseif source.charName == "Teemo" then
      APDmg = APDmg + 10*myHero:GetSpellData(_E).level+0.3*AP
    elseif source.charName == "Orianna" then
      APDmg = APDmg + 2 + 8 * math.ceil(Level/3) + 0.15*AP
    end
    if crit >= 0.9 then
      ADDmg = ADDmg*(2 - (source.charName == "Yasuo" and 0.2 or 0))
    end
    if GetMaladySlot() then
      APDmg = 15 + 0.15*AP
    end

    dmgMod = 1
    if source == myHero and not freeze then
      if target.type ~= myHero.type then
        if self.Config.f.m.Butcher then
          TRUEDmg = TRUEDmg + 2
        end
      elseif self.Config.f.m.Executioner > 0 then
        if target.health/target.maxHealth < (.2 + .15 * self.Config.f.m.Executioner) then
          dmgMod = dmgMod + .05
        end
      end
      if self.Config.f.m.ArcaneBlade then
        APDmg = APDmg + 0.05*AP
      end
      if self.Config.f.m.Havoc then
        dmgMod = dmgMod + .03
      end
      if self.Config.f.m.DESword then
        dmgMod = dmgMod + (self.melee and .02 or .015)
      end
    end
    dmg = math.floor(ADDmg*(1-ArmorPercent))+math.floor(APDmg*(1-MagicArmorPercent))+TRUEDmg
    dmg = math.floor(dmg*dmgMod) * (TargetHaveBuff("summonerexhaust", source) and 0.6 or 1)
    --print("[NebelwolfisOrbWalker] "..source.charName.." will do "..dmg.." dmg on "..target.charName)
    return dmg
  end

-- }

class 'SCircle' -- {

  function SCircle:__init(obj, r, LFC, color)
    if LFC then
      DrawCircle3D(obj.x, obj.y, obj.z, r, 1, color or 0xffffffff, 32)
    else
      DrawCircle(obj.x, obj.y, obj.z, r, color or 0xffffffff)
    end
  end

-- }

  function ArrangeTSPriorities() -- last seen at "I don't even know who"
    local priorityTable2 = {
        p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "JarvanIV", "Leona", "Lulu", "Malphite", "Nasus", "Nautilus", "Nunu", "Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac"},
        p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
        p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Janna", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nami", "Nidalee", "Riven", "Shaco", "Sona", "Soraka", "TahmKench", "Vladimir", "Yasuo", "Zilean", "Zyra"},
        p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Ekko", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
        p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
    }
     local priorityOrder = {
        [1] = {1,1,1,1,1},
        [2] = {1,1,2,2,2},
        [3] = {1,1,2,3,3},
        [4] = {1,2,3,4,4},
        [5] = {1,2,3,4,5},
    }
    local function _SetPriority(table, hero, priority)
        if table ~= nil and hero ~= nil and priority ~= nil and type(table) == "table" then
            for i=1, #table, 1 do
                if hero.charName:find(table[i]) ~= nil and type(priority) == "number" then
                    TS_SetHeroPriority(priority, hero.charName)
                end
            end
        end
    end
    local enemies = #GetEnemyHeroes()
    if priorityTable2~=nil and type(priorityTable2) == "table" and enemies > 0 then
      for i, enemy in ipairs(GetEnemyHeroes()) do
        _SetPriority(priorityTable2.p1, enemy, math.min(1, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p2, enemy, math.min(2, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p3, enemy, math.min(3, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p4, enemy, math.min(4, #GetEnemyHeroes()))
        _SetPriority(priorityTable2.p5, enemy, math.min(5, #GetEnemyHeroes()))
      end
    end
  end

  function Set(list)
    local set = {}
    for _, l in ipairs(list) do 
      set[l] = true 
    end
    return set
  end

  function GetMaladySlot()
    for slot = ITEM_1, ITEM_7, 1 do
      if myHero:GetSpellData(slot).name and myHero:GetSpellData(slot).name:lower():find("malady") then
        return slot
      end
    end
    return nil
  end

-- { MinionManager

  class "MinionManager"

  function MinionManager:__init()
    self.objects = {}
    for k=1,objManager.maxObjects,1 do
      local object = objManager:getObject(k)
      if object and object.valid and object.type == "obj_AI_Minion" and object.team ~= myHero.team and object.name and (object.name:find('Minion_T') or object.name:find('Blue') or object.name:find('Red') or object.team == TEAM_NEUTRAL or object.name:find('Bilge') or object.name:find('BW')) then
        self.objects[#self.objects+1] = object
      end
    end
    AddCreateObjCallback(function(o) self:CreateObj(o) end)
    return self
  end

  function MinionManager:CreateObj(object)
    if object and object.valid and object.type == "obj_AI_Minion" and object.team ~= myHero.team and object.name and (object.name:find('Minion_T') or object.name:find('Blue') or object.name:find('Red') or object.team == TEAM_NEUTRAL or object.name:find('Bilge') or object.name:find('BW')) then
      self.objects[self:FindDeadPlace() or #self.objects+1] = object
    end
  end

  function MinionManager:FindDeadPlace()
    for i=1, #self.objects do
      local object = self.objects[i]
      if not object or not object.valid or object.dead then
        return i
      end
    end
  end

-- }

class "CScriptUpdate" -- {

  function CScriptUpdate:__init(LocalVersion,UseHttps, Host, VersionPath, ScriptPath, SavePath, CallbackUpdate, CallbackNoUpdate, CallbackNewVersion,CallbackError)
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..math.random(99999999)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..math.random(99999999)
    self.SavePath = SavePath
    self.CallbackUpdate = CallbackUpdate
    self.CallbackNoUpdate = CallbackNoUpdate
    self.CallbackNewVersion = CallbackNewVersion
    self.CallbackError = CallbackError
    self:CreateSocket(self.VersionPath)
    self.DownloadStatus = 'Connect to Server for VersionInfo'
    AddTickCallback(function() self:GetOnlineVersion() end)
    return self
  end

  function CScriptUpdate:print(str)
    print('<font color="#FFFFFF">'..os.clock()..': '..str)
  end

  function CScriptUpdate:CreateSocket(url)
    if not self.LuaSocket then
      self.LuaSocket = require("socket")
    else
      self.Socket:close()
      self.Socket = nil
      self.Size = nil
      self.RecvStarted = false
    end
    self.LuaSocket = require("socket")
    self.Socket = self.LuaSocket.tcp()
    self.Socket:settimeout(0, 'b')
    self.Socket:settimeout(99999999, 't')
    self.Socket:connect('sx-bol.eu', 80)
    self.Url = url
    self.Started = false
    self.LastPrint = ""
    self.File = ""
  end

  function CScriptUpdate:Base64Encode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
      local r,b='',x:byte()
      for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
      return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
      if (#x < 6) then return '' end
      local c=0
      for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
      return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
  end

  function CScriptUpdate:GetOnlineVersion()
    if self.GotScriptVersion then return end

    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
      self.Started = true
      self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
      self.RecvStarted = true
      self.DownloadStatus = 'Downloading VersionInfo (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</s'..'ize>') then
      if not self.Size then
        self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
      end
      if self.File:find('<scr'..'ipt>') then
        local _,ScriptFind = self.File:find('<scr'..'ipt>')
        local ScriptEnd = self.File:find('</scr'..'ipt>')
        if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
        local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
        self.DownloadStatus = 'Downloading VersionInfo ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
      end
    end
    if self.File:find('</scr'..'ipt>') then
      self.DownloadStatus = 'Downloading VersionInfo (100%)'
      local a,b = self.File:find('\r\n\r\n')
      self.File = self.File:sub(a,-1)
      self.NewFile = ''
      for line,content in ipairs(self.File:split('\n')) do
        if content:len() > 5 then
          self.NewFile = self.NewFile .. content
        end
      end
      local HeaderEnd, ContentStart = self.File:find('<scr'..'ipt>')
      local ContentEnd, _ = self.File:find('</sc'..'ript>')
      if not ContentStart or not ContentEnd then
        if self.CallbackError and type(self.CallbackError) == 'function' then
          self.CallbackError()
        end
      else
        self.OnlineVersion = (Base64Decode(self.File:sub(ContentStart + 1,ContentEnd-1)))
        self.OnlineVersion = tonumber(self.OnlineVersion)
        if self.OnlineVersion > self.LocalVersion then
          if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
            self.CallbackNewVersion(self.OnlineVersion,self.LocalVersion)
          end
          self:CreateSocket(self.ScriptPath)
          self.DownloadStatus = 'Connect to Server for ScriptDownload'
          AddTickCallback(function() self:DownloadUpdate() end)
        else
          if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
            self.CallbackNoUpdate(self.LocalVersion)
          end
        end
      end
      self.GotScriptVersion = true
    end
  end

  function CScriptUpdate:DownloadUpdate()
    if self.GotCScriptUpdate then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
      self.Started = true
      self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
      self.RecvStarted = true
      self.DownloadStatus = 'Downloading Script (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</si'..'ze>') then
      if not self.Size then
        self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
      end
      if self.File:find('<scr'..'ipt>') then
        local _,ScriptFind = self.File:find('<scr'..'ipt>')
        local ScriptEnd = self.File:find('</scr'..'ipt>')
        if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
        local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
        self.DownloadStatus = 'Downloading Script ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
      end
    end
    if self.File:find('</scr'..'ipt>') then
      self.DownloadStatus = 'Downloading Script (100%)'
      local a,b = self.File:find('\r\n\r\n')
      self.File = self.File:sub(a,-1)
      self.NewFile = ''
      for line,content in ipairs(self.File:split('\n')) do
        if content:len() > 5 then
          self.NewFile = self.NewFile .. content
        end
      end
      local HeaderEnd, ContentStart = self.NewFile:find('<sc'..'ript>')
      local ContentEnd, _ = self.NewFile:find('</scr'..'ipt>')
      if not ContentStart or not ContentEnd then
        if self.CallbackError and type(self.CallbackError) == 'function' then
          self.CallbackError()
        end
      else
        local newf = self.NewFile:sub(ContentStart+1,ContentEnd-1)
        local newf = newf:gsub('\r','')
        if newf:len() ~= self.Size then
          if self.CallbackError and type(self.CallbackError) == 'function' then
            self.CallbackError()
          end
          return
        end
        local newf = Base64Decode(newf)
        if type(load(newf)) ~= 'function' then
          if self.CallbackError and type(self.CallbackError) == 'function' then
            self.CallbackError()
          end
        else
          local f = io.open(self.SavePath,"w+b")
          f:write(newf)
          f:close()
          if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
            self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
          end
        end
      end
      self.GotCScriptUpdate = true
    end
  end

-- }
