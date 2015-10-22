--[[
  _    _       _  __ _          _   _____              _ _      _   _               _      _ _                          
 | |  | |     (_)/ _(_)        | | |  __ \            | (_)    | | (_)             | |    (_) |                         
 | |  | |_ __  _| |_ _  ___  __| | | |__) | __ ___  __| |_  ___| |_ _  ___  _ __   | |     _| |__  _ __ __ _ _ __ _   _ 
 | |  | | '_ \| |  _| |/ _ \/ _` | |  ___/ '__/ _ \/ _` | |/ __| __| |/ _ \| '_ \  | |    | | '_ \| '__/ _` | '__| | | |
 | |__| | | | | | | | |  __/ (_| | | |   | | |  __/ (_| | | (__| |_| | (_) | | | | | |____| | |_) | | | (_| | |  | |_| |
  \____/|_| |_|_|_| |_|\___|\__,_| |_|   |_|  \___|\__,_|_|\___|\__|_|\___/|_| |_| |______|_|_.__/|_|  \__,_|_|   \__, |
                                                                                                                   __/ |
                                                                                                                  |___/ 
  By Nebelwolfi


  How To Use:

    require("UPL")
    UPL = UPL()

    UPL:AddToMenu(Menu)
    Will add prediction selector to the given scriptConfig

    UPL:AddSpell(_Q, { speed = 1800, delay = 0.25, range = 900, width = 70, collision = true, aoe = false, type = "linear" })
    Will add the spell to all predictions

    CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, Target)
    if HitChance >= X then
      CastSpell(_Q, CastPosition.x, CastPosition.y)
    end
  
  Supports and auto-detects: VPrediction, Prodiction, DivinePrediction, HPrediction, TKPrediction

]]--

class "UPL"

--Scriptstatus tracker (usercounter)
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("PCFEDDEJJKJ") 
--Scriptstatus tracker (usercounter)

function UPL:__init()
  if not _G.UPLloaded then
    _G.UPLversion = 2.8
    _G.UPLautoupdate = true
    _G.UPLloaded = false
    self.ActiveP = 1
    self.LastRequest = 0
    self.Config = nil
    self.Config2 = nil
    self.VP  = nil
    self.DP  = nil
    self.HP  = nil
    self.SP = nil
    self.HPSpells  = {}
    self.spellData = {
      [_Q] = { speed = 0, delay = 0, range = 0, width = 0, collision = true, aoe = false, type = "linear"},
      [_W] = { speed = 0, delay = 0, range = 0, width = 0, collision = true, aoe = false, type = "linear"},
      [_E] = { speed = 0, delay = 0, range = 0, width = 0, collision = true, aoe = false, type = "linear"},
      [_R] = { speed = 0, delay = 0, range = 0, width = 0, collision = true, aoe = false, type = "linear"}}
    self.predTable = {}

    if FileExist(LIB_PATH .. "SPrediction.lua") then
      if _G.SP then
        self.SP = _G.SP
        table.insert(self.predTable, "SPrediction")
      else
        require("SPrediction")
        self.SP = SPrediction()
        _G.SP = self.SP
        table.insert(self.predTable, "SPrediction")
      end
    end
    
    if FileExist(LIB_PATH .. "VPrediction.lua") then
      if _G.VP then
        self.VP = _G.VP
        table.insert(self.predTable, "VPrediction")
      else
        require("VPrediction")
        self.VP = VPrediction()
        _G.VP = self.VP
        table.insert(self.predTable, "VPrediction")
      end
    end

    if FileExist(LIB_PATH .. "Prodiction.lua") then
      --require("Prodiction")
      --table.insert(self.predTable, "Prodiction")
    end

    if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then
      require "DivinePred"
      self.DP = DivinePred()
      table.insert(self.predTable, "DivinePrediction")
    end

    if FileExist(LIB_PATH .. "HPrediction.lua") then
      if _G.HP then
        self.HP = _G.HP
        table.insert(self.predTable, "HPrediction")
      else
        require("HPrediction")
        self.HP = HPrediction()
        _G.HP = self.HP
        table.insert(self.predTable, "HPrediction")
      end
    end

    self:Update()
    DelayAction(function() self:Loaded() end, 3)
    return self
  end
end

function UPL:Update()
  local UPL_UPDATE_HOST = "raw.github.com"
  local UPL_UPDATE_PATH = "/nebelwolfi/BoL/master/Common/UPL.lua".."?rand="..math.random(1,10000)
  local UPL_UPDATE_FILE_PATH = LIB_PATH.."UPL.lua"
  local UPL_UPDATE_URL = "https://"..UPL_UPDATE_HOST..UPL_UPDATE_PATH
  if UPLautoupdate then
    local UPLServerData = GetWebResult(UPL_UPDATE_HOST, "/nebelwolfi/BoL/master/Common/UPL.version")
    if UPLServerData then
      UPLServerVersion = type(tonumber(UPLServerData)) == "number" and tonumber(UPLServerData) or nil
      if UPLServerVersion then
        if tonumber(UPLversion) < UPLServerVersion then
          self:Msg("New version available v"..UPLServerVersion)
          self:Msg("Updating, please don't press F9")
          DelayAction(function() DownloadFile(UPL_UPDATE_URL, UPL_UPDATE_FILE_PATH, function () self:Msg("Successfully updated. ("..UPLversion.." => "..UPLServerVersion.."), press F9 twice to load the updated version") end) end, 3)
          return true
        end
      end
    else
      self:Msg("Error downloading version info")
    end
  end
  return false
end

function UPL:Loaded()
  local preds = ""
  for k,v in pairs(self.predTable) do
    preds=preds.." "..v
    if k ~= #self.predTable then preds=preds.."," end
  end
  self:Msg("Loaded the latest version (v"..UPLversion..")")
  self:Msg("Detected predictions: "..preds)
  UPLloaded = true
end

function UPL:Msg(msg)
  print("<font color=\"#ff0000\">[</font><font color=\"#ff2000\">U</font><font color=\"#ff4000\">n</font><font color=\"#ff5f00\">i</font><font color=\"#ff7f00\">f</font><font color=\"#ff9900\">i</font><font color=\"#ffb200\">e</font><font color=\"#ffcc00\">d</font><font color=\"#ffe500\">P</font><font color=\"#ffff00\">r</font><font color=\"#bfff00\">e</font><font color=\"#80ff00\">d</font><font color=\"#40ff00\">i</font><font color=\"#00ff00\">c</font><font color=\"#00ff40\">t</font><font color=\"#00ff80\">i</font><font color=\"#00ffbf\">o</font><font color=\"#00ffff\">n</font><font color=\"#00ccff\">L</font><font color=\"#0099ff\">i</font><font color=\"#0066ff\">b</font><font color=\"#0033ff\">r</font><font color=\"#0000ff\">a</font><font color=\"#2300ff\">r</font><font color=\"#4600ff\">y</font><font color=\"#6800ff\">]</font><font color=\"#8b00ff\">:</font> <font color=\"#FFFFFF\">"..msg.."</font>") 
end

function UPL:Predict(spell, source, Target)
  if Target == nil then 
    Target = source 
    source = myHero
  end
  if not self:ValidRequest(spell) then return Vector(Target), -1, Vector(Target) end
  if self:ActivePred(spell) == "VPrediction" then
      return self:VPredict(Target, self.spellData[spell], source)
  elseif self:ActivePred(spell) == "Prodiction" then
      local Position, info = Prodiction.GetPrediction(Target, self.spellData[spell].range, self.spellData[spell].speed, self.spellData[spell].delay, self.spellData[spell].width, source)
      if Position ~= nil and not info.mCollision() then
        return Position, 2, Vector(Target)
      else
        return Vector(Target), 0, Vector(Target)
      end
  elseif self:ActivePred(spell) == "DivinePrediction" then
      local State, Position, perc = self:DPredict(Target, spell, source)
      if perc and Position then
        return Position, perc/33, (Vector(Target)-Position):normalized()
      else
        return Vector(Target), 0, Vector(Target)
      end
  elseif self:ActivePred(spell) == "HPrediction" then
      return self:HPredict(Target, spell, source)
  elseif self:ActivePred(spell) == "SPrediction" then
      return self.SP:Predict(Target, self.spellData[spell].range, self.spellData[spell].speed, self.spellData[spell].delay, self.spellData[spell].width, (myHero.charName == "Lux" or myHero.charName == "Veigar") and 1 or self.spellData[spell].collision, source)
  end
end

function UPL:AddToMenu(Config)
  Config:addParam("pred", "Prediction", SCRIPT_PARAM_LIST, self.ActiveP, self.predTable)
  self.Config = Config
end

function UPL:AddToMenu2(Config, state)
  Config:addSubMenu("Prediction Menu", "UPL")
  self.addToMenu2 = true
  self.Config = Config.UPL
end

function UPL:AddSpell(spell, array)
  if not UPLloaded then
    DelayAction(function() self:AddSpell(spell,array) end, 1)
  else
    self.spellData[spell] = {speed = array.speed, delay = array.delay, range = array.range, width = array.width, collision = array.collision, aoe = array.aoe, type = array.type}
    if self.HP ~= nil then self:SetupHPredSpell(spell) end
    if self.DP ~= nil then self:SetupDPredSpell(spell) end
    if self.addToMenu2 then
      str = {[-3] = "P", [-2] = "Q3", [-1] = "Q2", [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
      DelayAction(function() self.Config:addParam(str[spell], str[spell].." Prediction", SCRIPT_PARAM_LIST, self.ActiveP, self.predTable) end, 1)
    end
  end
end

function UPL:GetSpellData(spell)
  return self.spellData[spell]
end

function UPL:HPredict(Target, spell, source)
  local col = self.spellData[spell].collision and ((myHero.charName=="Lux" or myHero.charName=="Veigar") and 1 or 0) or math.huge
  local x, y, z = self.HP:GetPredict(self.HPSpells[spell], Target, source, col)
  return x, y*2, z
end

function UPL:SetupHPredSpell(spell)
  k = spell
  spell = self.spellData[k]
  if spell.type == "linear" then
      if spell.speed ~= math.huge then 
        if spell.collision then
          self.HPSpells[k] = HPSkillshot({type = "DelayLine", range = spell.range, speed = spell.speed, width = 2*spell.width, delay = spell.delay, collisionM = spell.collision, collisionH = spell.collision})
        else
          self.HPSpells[k] = HPSkillshot({type = "DelayLine", range = spell.range, speed = spell.speed, width = 2*spell.width, delay = spell.delay})
        end
      else
        self.HPSpells[k] = HPSkillshot({type = "PromptLine", range = spell.range, width = 2*spell.width, delay = spell.delay})
      end
  elseif spell.type == "circular" then
      if spell.speed ~= math.huge then 
        self.HPSpells[k] = HPSkillshot({type = "DelayCircle", range = spell.range, speed = spell.speed, radius = spell.width, delay = spell.delay})
      else
        self.HPSpells[k] = HPSkillshot({type = "PromptCircle", range = spell.range, radius = spell.width, delay = spell.delay})
      end
  else --Cone!
    self.HPSpells[k] = HPSkillshot({type = "DelayLine", range = spell.range, speed = spell.speed, width = 2*spell.width, delay = spell.delay})
  end
end

function UPL:SetupDPredSpell(spell)
  local str = (({[-3] = "P", [-2] = "Q3", [-1] = "Q2", [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"})[spell])
  local Spell = nil
  local spell = self.spellData[spell]
  local col = spell.collision and ((myHero.charName=="Lux" or myHero.charName=="Veigar") and 1 or 0) or math.huge
  if spell.type == "linear" then
    Spell = LineSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
  elseif spell.type == "circular" then
    Spell = CircleSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
  elseif spell.type == "cone" then
    Spell = ConeSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
  end
  self.DP:bindSS(str, Spell, 1)
end

function UPL:DPredict(Target, spell, source)
  str = {[-3] = "P", [-2] = "Q3", [-1] = "Q2", [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
  return self.DP:predict(str[spell], Target, Vector(source))
end

--[[function UPL:DPredict(Target, spell, source) -- @Salt-Override-Desu
  local nextPosition, minions, nextHealth = TargetPrediction(spell.range, spell.speed, spell.delay, spell.width, 99):GetPrediction(Target)
  return nextPosition, 2, Vector(Target)
end]]

function UPL:VPredict(Target, spell, source)
  if spell.type == "linear" then
    if spell.aoe then
      return self.VP:GetLineAOECastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero)
    else
      return self.VP:GetLineCastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
    end
    elseif spell.type == "circular" then
    if spell.aoe then
      return self.VP:GetCircularAOECastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero)
    else
      return self.VP:GetCircularCastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
    end
    elseif spell.type == "cone" then
    if spell.aoe then
      return self.VP:GetConeAOECastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero)
    else
      return self.VP:GetLineCastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
    end
  end
end

function UPL:ReturnPred(x, spell)
    if self:ActivePred(spell) == "VPrediction" then
      return self.VP
    elseif self:ActivePred(spell) == "HPrediction" then
      return self.HP
    elseif self:ActivePred(spell) == "SPrediction" then
      return self.SP
    elseif self:ActivePred(spell) == "DivinePrediction" then
      return self.DP
    end
end

function UPL:ActivePred(spell)
    local str = {[-3] = "P", [-2] = "Q3", [-1] = "Q2", [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
    local int = not self.addToMenu2 and (self.Config.pred and self.Config.pred or self.ActiveP) or (self.Config[str[spell]] and self.Config[str[spell]] or 1)
    return tostring(self.predTable[int])
end

function UPL:SetActive(pred)
  for i=1,#self.predTable do
    if self.predTable[i] == pred then
      self.ActiveP = i
    end
  end
end

function UPL:ValidRequest(x)
    if GetInGameTimer() - self.LastRequest < self:TimeRequest(x) then
        return false
    else
        self.LastRequest = GetInGameTimer()
        return true
    end
end

function UPL:TimeRequest(spell)
    if self:ActivePred(spell) == "VPrediction" or self:ActivePred(spell) == "HPrediction" or self:ActivePred(spell) == "SPrediction" then
      return 0.001
    elseif self:ActivePred(spell) == "DivinePrediction" then
      return 0.2
    else
      return 0.01
    end
end