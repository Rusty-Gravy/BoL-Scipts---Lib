if myHero.charName ~= "Kayle" then return end
 
require "SxOrbWalk"
local minionlane = minionManager(MINION_ENEMY, 525, myHero, MINION_SORT_HEALTH_ASC)
local minionjungle = minionManager(MINION_JUNGLE, 525, myHero, MINION_SORT_HEALTH_ASC)
 
function OnLoad()
        k = scriptConfig(">>> AISmartKayle", "kayle")
        k:addSubMenu("Orbwalker", "SxOrb")
                SxOrb:LoadToMenu(k.SxOrb)
  ts = TargetSelector(TARGET_LESS_CAST, 650, DAMAGE_MAGIC, false)
        k:addSubMenu("Combo", "combo")
    k.combo:addParam("useq", "Q", SCRIPT_PARAM_ONOFF, true)
    k.combo:addParam("usee", "E", SCRIPT_PARAM_ONOFF, true)
    k.combo:addParam("usew", "W", SCRIPT_PARAM_ONOFF, true)
    k.combo:addParam("scriptActive", "combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  k:addSubMenu("Lane/jungle Clear", "clearlane")
    k.clearlane:addParam("dolaneclear", "clear minions with E", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
    k.clearlane:addParam("inf3", " >> need this same orbwalk laneclear key", SCRIPT_PARAM_INFO, "")
  k:addSubMenu("Auto Heal", "wset")
    k.wset:addParam("use", "AutoHeal", SCRIPT_PARAM_ONOFF, true)
    k.wset:addParam("min", "minimum Health % to W", SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
  k:addSubMenu("Auto Ult", "rset")
    k.rset:addParam("use", "AutoUlt", SCRIPT_PARAM_ONOFF, true)
    k.rset:addParam("min", "minimum Health % to R", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
  PrintChat(" >>> AISmartKayle Loaded!")
end
 
function OnTick()
  ts:update()
  SxOrb:ForceTarget(ts.target)
  if k.clearlane.dolaneclear and myHero.mana > 45 then
  minionlane:update()
  minionjungle:update()
    for i in pairs(minionlane.objects) do
      CastSpell(_E)
    end
    for j in pairs(minionjungle.objects) do
      CastSpell(_E)
    end
  end
  if k.combo.scriptActive then
    if k.combo.useq and myHero.mana < 135 then
      if ts.target and ts.target.health < 600 and (myHero:CanUseSpell(_Q) == READY) and GetDistance(ts.target) < 650 then
        CastSpell(_Q, ts.target)
      elseif ts.target and ts.target.health > 600 and (myHero:CanUseSpell(_E) == READY) and GetDistance(ts.target) < 650 then
        CastSpell(_E)
      end
    elseif ts.target and k.combo.useq and myHero.mana >= 135 and (myHero:CanUseSpell(_Q) == READY) and GetDistance(ts.target) < 650 then
      CastSpell(_Q, ts.target)
    end
    if ts.target and k.combo.usee and (myHero:CanUseSpell(_E) == READY) and GetDistance(ts.target) < 650 then
      CastSpell(_E)
    end
    if k.combo.usew and (myHero:CanUseSpell(_W) == READY) then
      if ts.target and ts.target.health < 600 and myHero.mana > 235 and GetDistance(ts.target) > 500 then
        CastSpell(_W, myHero)
      elseif ts.target and ts.target.health < 300 and myHero.mana > 145 and GetDistance(ts.target) > 500 then
        CastSpell(_W, myHero)
      end
    end
  end
  if not IsRecalling(myHero) and ts.target and (myHero:CanUseSpell(_R) == READY) and k.rset.use and ((myHero.health/myHero.maxHealth)*100 <= k.rset.min) and (myHero.health/myHero.maxHealth)*100 < (ts.target.health/ts.target.maxHealth)*100 and GetDistance(ts.target) < 600 then
    CastSpell(_R, myHero)
  end
  if not IsRecalling(myHero) and myHero:CanUseSpell(_W) == READY and k.wset.use and (myHero.health/myHero.maxHealth)*100 <= k.wset.min then
    if myHero.mana < 235 then
      if myHero.health < 300 then
        CastSpell(_W, myHero)
      elseif myHero.health > 300 then
        return
      end
    elseif myHero.mana >= 235 then
      CastSpell(_W, myHero)
    end
  end
end
 
function IsRecalling(unit)
  if unit == nil then if self == nil then return else unit = self end end
  for i=1, unit.buffCount do
   local buff = unit:getBuff(i)
   if buff and buff.valid and buff.name then
    if string.find(buff.name, "recall") or string.find(buff.name, "Recall") or string.find(buff.name, "teleport") or string.find(buff.name, "Teleport") then return true end
   end
  end
  return false
end