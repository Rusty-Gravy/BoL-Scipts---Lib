require "NotLib" if GetUser() == "botirk" then NotLib.sugar.IAMFREE() end
if NotLib.game ~= "classic" and NotLib.game ~= "tt" then print("Jungler Slack >> wrong map") return end
print("Jungler Slack >> reminder B0L is bugged, scripts cant interact with items and level spells - ask admins")
local version,gui,timer,bind,object,sugar,myHero = "17 beta",NotLib.gui,NotLib.timer,NotLib.bind,NotLib.object,NotLib.sugar,myHero

local db = setmetatable({},{__index=function(db,dbKey) return db.default end,__newindex=function(db,dbKey,dbValue) if dbKey ~= "default" and dbValue then setmetatable(dbValue,{__index=function(dbValue,dbValueKey) return db.default[dbValueKey] end}) end rawset(db,dbKey,dbValue) end})
do -- fill default
	db.default = {level={}}
	db.default.creepSpawn = function() if GetTarget() and GetTarget().data.class == "creep" then return GetTarget().data.creepSpawn() else 
		local result,resultScore = nil,math.huge
		for k,creepSpawn in pairs(object("creepSpawn",{"side",myHero.team})) do
			local score,get,dist = 0,creepSpawn.data.get()*myHero.ms,myHero:GetDistance(creepSpawn)
			if dist > get then score = dist elseif creepSpawn.data.dead <= 300 or creepSpawn.data.type == "red" or creepSpawn.data.type == "blue" then score = get else score = dist+(get-dist)*1.4 end
			if creepSpawn.data.started() then if creepSpawn.data.respawn > 200 then score = score-3300 else score = score-2000 end
			elseif NotLib.game == "classic" then
				if myHero.level == 1 then if (not fast and creepSpawn.data.type == "golem") or (fast and creepSpawn.data.type == "wight") then score = score-3300 end
				elseif (not gui.jungle_gank.value and myHero.level >= 3) then 
					if (creepSpawn.data.type == "wolf" and (NotLib.object.creepSpawn.oblue.data.get() < 3200/myHero.ms or NotLib.object.creepSpawn.owight.data.get() < 3200/myHero.ms)
					or (creepSpawn.data.type == "wraith" and (NotLib.object.creepSpawn.ored.data.get() < 3200/myHero.ms or NotLib.object.creepSpawn.ogolem.data.get() < 3200/myHero.ms))) then score = score+3300 end 
				end
			end
			if score < resultScore then result,resultScore = creepSpawn,score end
		end
		return result
	end end
	db.default.creepSpawnEx = function() return nil end
	db.default.target = function(creepSpawn,cleave) 
		local target,red = nil,(not cleave and myHero.data.buff.red())
		for k,creep in pairs(creepSpawn.data.creeps()) do
			if target == nil then target = creep
			elseif red == true and (target.data.buff.redSlow() or creep.data.buff.redSlow()) then
				if target.data.buff.redSlow() and not creep.data.buff.redSlow() then target = creep end
			elseif cleave and creep.maxHealth > target.maxHealth then target = creep 
			elseif not cleave and creep.maxHealth < target.maxHealth then target = creep
			elseif creep.maxHealth == target.maxHealth and creep.networkID > target.networkID then target = creep end
		end
		return target
	end
	db.default.targetEx = function(creepSpawn) return nil end
	db.default.channel = function(creepSpawn) return false end
	db.default.cleave = function(creepSpawn) return false end
	db.default.clear = function(creep,creepSpawn) myHero:Attack(creep) end
	db.default.slack = function(creepSpawn) return false end
	db.default.skillCheck = function(creepSpawn) return nil end
	db.default.skillCheckPos = function(creepSpawn)
		if NotLib.game == "classic" then
			if creepSpawn.data.type == "golem" then 
				if creepSpawn.data.side() == TEAM_BLUE then return VEC(8150,3125) else return VEC(6750,11740) end
			elseif creepSpawn.data.type == "blue" then
				if creepSpawn.data.side() == TEAM_BLUE then return VEC(4500,7550) else return VEC(10550,7450) end
			elseif creepSpawn.data.type == "wight" then
				if creepSpawn.data.side() == TEAM_BLUE then return VEC(1820,8000) else return VEC(13050,6850) end
			end
		end
	end
	db.default.skillCheckEx = function(creepSpawn,skill)
		local pos = skillCheckPos(creepSpawn)
		if not pos or myHero:GetDistance(creepSpawn) < myHero:GetDistance(pos)+100 or creepSpawn.data.get() > 0 then return false
		elseif myHero:GetDistance(pos) > 50 then myHero:MoveTo(pos.x,pos.z) return true
		else CastSpell(skill,creepSpawn.x,creepSpawn.z) creepSpawn.data.set(false) return true end
	end
end
do -- fill repeater
	db.repeater = {level={}}
	db.repeater.clear = function(creep,creepSpawn) 
		if myHero.data.inRange(creep) then
			if db.repeater[_Q] then db.repeater[_Q](creep,creepSpawn) end
			if db.repeater[_W] then db.repeater[_W](creep,creepSpawn) end
			if db.repeater[_E] then db.repeater[_E](creep,creepSpawn) end
		end
		myHero:Attack(creep)
	end
	AddProcessSpellCallback(function(unit,spell) if unit.isMe and gui.jungle_repeater.value and timer.jungle.running() then
		for _T=_Q,_R do if not db.repeater[_T] and spell.name == myHero:GetSpellData(_T).name then
			if spell.target then
				if spell.target.data.class == "creep" then db.repeater[_T] = function(creep) CastSpell(_T,creep) end
				elseif spell.target.isMe then db.repeater[_T] = function() CastSpell(_T) end end
			elseif spell.endPos and #object("creep",{"attack",myHero,"dist",{VEC(spell.endPos.x,spell.endPos.z),100}}) > 0 then
				db.repeater[_T] = function(creep) CastSpell(_T,creep.x,creep.z) end
			end
		end end
	end end)
end
do -- fill db
	db.Warwick = {level={_W,_Q}}
	db.Warwick.clear = function(creep,creepSpawn)
		if CastSpell(_Q,creep) then return
		elseif myHero.data.inRange(creep) then
			if (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) and CastSpell(_W) then return end
		end
		myHero:Attack(creep)
	end
	db.Udyr = {level={_R,_W}}
	db.Udyr.cleave = function() return myHero:GetSpellData(_R).level > 1 and myHero.mana > 100 end
	db.Udyr.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			CastSpell(_R)
			CastSpell(_Q)
			if myHero.health/myHero.maxHealth < 0.7 then CastSpell(_W) end
		end
		myHero:Attack(creep)
	end
	db.Trundle = {level={_Q,_W}}
	db.Trundle.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			CastSpell(_Q)
			if myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage() then CastSpell(_W,creep.x,creep.z) end
		end
		myHero:Attack(creep)
	end
	db.Nunu = {level={_Q,_W}}
	db.Nunu.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			local bigCreep = creepSpawn.data.bigCreep()
			if (myHero.level < 3 or bigCreep.health > myHero.data.smiteDamage()) then
				CastSpell(_W,myHero)
				if CastSpell(_Q,bigCreep) then return end
			end
			if CastSpell(_E,bigCreep) then return end
		end
		myHero:Attack(creep)
	end
	db.Sejuani = {level={_W,_Q,_E}}
	db.Sejuani.cleave = function() return myHero:CanUseSpell(_W) == READY or myHero.data.buff("SejuaniNorthernWinds","sejuaninorthernwindsenrage") end
	db.Sejuani.clear = function(creep,creepSpawn)
		local bigCreep = creepSpawn.data.bigCreep()
		if myHero.data.inRange(creep) then
			CastSpell(_W)
			CastSpell(_E)
		elseif myHero.mana > 175 and (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) 
		and myHero.pos:GetDistance(bigCreep.pos) < 650 and not bigCreep.hasMovePath and CastSpell(_Q,bigCreep.pos.x,bigCreep.pos.z) then return end
		myHero:Attack(creep)
	end
	db.Sejuani.skillCheck = function() if myHero.mana > 175 and myHero:CanUseSpell(_Q) == READY then return _Q end end
	db.Amumu = {level={_W,_E}}
	db.Amumu.cleave = function() return true end
	db.Amumu.despair = function() for i=0,objManager.maxObjects do local unit = objManager:getObject(i) if unit and unit.valid and unit.visible and unit.name == "Despairpool_tar.troy" and unit:GetDistance(myHero) < 99 then return true end end return false end
	db.Amumu.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			if not db.Amumu.despair() then CastSpell(_W) end
			if #creepSpawn.data.creeps() >= 2 then CastSpell(_E) end
		elseif myHero.mana > 175 and (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage())
		and myHero.pos:GetDistance(creep.pos) < 1100 and not creep.hasMovePath and CastSpell(_Q,creep.pos.x,creep.pos.z) then return end
		myHero:Attack(creep)
	end
	db.Amumu.slack = function() if db.Amumu.despair() then CastSpell(_W) end end
	db.Amumu.skillCheck = function() if myHero.mana > 175 and myHero:CanUseSpell(_Q) == READY then return _Q end end
	db.Evelynn = {level={_Q,_E}}
	db.Evelynn.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			CastSpell(_E,creep)
			CastSpell(_Q)
		end
		myHero:Attack(creep)
	end
	db.Shaco = {level={_W,_E}}
	db.Shaco.box = function() return #object("pet",{"name","Jack in the Box","assist",myHero,"dist",{myHero,500}}) > 0 end
	db.Shaco.cleave = function(creepSpawn) return not creepSpawn.data.started() or myHero:CanUseSpell(_E) == READY or myHero:CanUseSpell(_W) == READY end
	db.Shaco.clear = function(creep,creepSpawn)
		if not creep.hasMovePath and (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) then  
			if myHero.data.inRange(creep) then
				local behind = math.pos2d(creep,math.rad2d(myHero,creep),100)
				if myHero:GetDistance(behind) < 425 and CastSpell(_W,behind.x,behind.z) then return end
			end
		end
		myHero:Attack(creep)
	end
	db.Shaco.slack = function(creepSpawn) return myHero.pos:GetDistance(creepSpawn.pos) < 250 and creepSpawn.data.get() > 0 and creepSpawn.data.get() < 55 and CastSpell(_W,creepSpawn.pos.x,creepSpawn.pos.z) end
	db.Shaco.skillCheck = function() if myHero.mana > 175 and myHero:CanUseSpell(_Q) == READY then return _Q end end
	db.MasterYi = {level={_Q,_W}}
	db.MasterYi.w = function() return #object("visual",{"visible",true,"name","MasterYi_Base_W","dist",{myHero,50}}) > 0 end
	db.MasterYi.channel = function() return myHero.health < myHero.maxHealth and db.MasterYi.w() end
	db.MasterYi.cleave = function() local q = myHero:GetSpellData(_Q) return q.level > 0 and q.currentCd < 4 end
	db.MasterYi.clear = function(creep,creepSpawn) 
		if not creepSpawn.data.started() and db.MasterYi.slack(creepSpawn) then return
		elseif myHero.data.inRange(creep) and (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) then
			CastSpell(_Q,creep)
			CastSpell(_E)
		end
		myHero:Attack(creep)
	end
	db.MasterYi.slack = function(creepSpawn) return myHero.health/myHero.maxHealth < 0.5 and myHero.lifeSteal*myHero.totalDamage+10 < 20 and CastSpell(_W) end
	db.FiddleSticks = {level={_W,_E}}
	db.FiddleSticks.w = function() return #object("visual",{"visible",true,"name","FiddleSticks_Base_drain","dist",{myHero,50}}) > 0 end
	db.FiddleSticks.channel = function() return db.FiddleSticks.w() end
	db.FiddleSticks.cleave = function() return myHero:CanUseSpell(_W) == READY or myHero:CanUseSpell(_E) == READY end
	db.FiddleSticks.clear = function(creep,creepSpawn)
		if #creepSpawn.data.creeps() >= 2 then CastSpell(_E,creep) end
		if creepSpawn.data.started() and CastSpell(_W,creep) then return end
		myHero:Attack(creep)
	end
	db.Volibear = {level={_W,_E}}
	db.Volibear.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			if CastSpell(_W,creepSpawn.data.bigCreep()) then return end
			if (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) then CastSpell(_E) end
		end
		myHero:Attack(creep)
	end
	db.XinZhao = {level={_Q,_W}}
	db.XinZhao.cleave = function() return myHero:CanUseSpell(_E) == READY end
	db.XinZhao.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			CastSpell(_Q)
			if (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) then 
				CastSpell(_E,creep) 
				CastSpell(_W)
			end
		elseif myHero.mana > 175 then CastSpell(_E,creep) end
		myHero:Attack(creep)
	end
	db.Nautilus = {level={_W,_E}}
	db.Nautilus.cleave = function() return myHero:CanUseSpell(_W) == READY or myHero.data.buff("nautiluspiercinggazeshield") end
	db.Nautilus.clear = function(creep,creepSpawn) 
		if myHero.data.inRange(creep) then
			CastSpell(_W)
			if (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) then CastSpell(_E) end
		elseif myHero.mana > 175 and (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage())
		and myHero.pos:GetDistance(creep.pos) < 1100 and not creep.hasMovePath and math.pass2d(myHero,math.rad2d(myHero,creep),myHero:GetDistance(creep),true) == nil then CastSpell(_Q,creep.x,creep.z) end
		myHero:Attack(creep)
	end
	db.Malphite = {level={_E,_W}}
	db.Malphite.cleave = function() return GetSpellData(_W).level > 1 and (myHero:CanUseSpell(_W) == READY or myHero.data.buff("malphitecleave")) end
	db.Malphite.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			CastSpell(_W)
			CastSpell(_E)
			if myHero.mana > 175 and (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) and CastSpell(_Q,creepSpawn.data.bigCreep()) then return end
		end
		myHero:Attack(creep)
	end
	db.Elise = {level={_W,_Q}}
	db.Elise.spider = function() return GetSpellData(_R).name == "EliseRSpider" end
	db.Elise.rappel = function() return myHero.data.buff("elisespidere") end
	db.Elise.clear = function(creep,creepSpawn)
		if not db.Elise.spider() then
			local bigCreep = creepSpawn.data.bigCreep()
			if myHero.data.inRange(bigCreep) then
				if (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) then
					CastSpell(_W,bigCreep.x,bigCreep.z)
					CastSpell(_E,bigCreep.x,bigCreep.z)
				end
				CastSpell(_Q,bigCreep)
			end
			CastSpell(_R)
			myHero:Attack(bigCreep)
		else
			if myHero.data.inRange(creep) then
				CastSpell(_Q,creep)
				CastSpell(_W)
			elseif myHero.pos:GetDistance(creep.pos) < 750 and not creepSpawn.data.started() then CastSpell(_E,creep) end
			if myHero:GetSpellData(_W).currentCd > 3 and not myHero.data.buff("EliseSpiderW") then CastSpell(_R) end
			myHero:Attack(creep)
		end
		
	end
	db.Elise.slack = function() if not db.Elise.spider() then CastSpell(_R) end end
	db.Elise.skillCheck = function() if db.Elise.spider() and myHero:CanUseSpell(_E) == READY then return _E end end
	db.Kayle = {level={_E,_W}}
	db.Kayle.cleave = function() return GetSpellData(_E).level > 1 and (myHero:CanUseSpell(_E) == READY or myHero.data.buff("JudicatorRighteousFury")) end
	db.Kayle.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			if (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) and CastSpell(_Q,creepSpawn.data.bigCreep()) then return end
			if myHero.health/myHero.maxHealth < 0.5 then CastSpell(_W,myHero) end
			CastSpell(_E)
		end
		myHero:Attack(creep)
	end
	db.Kayle.slack = function() if myHero:GetDistance(creep) > 200 and myHero.mana/myHero.maxMana > 0.5 then CastSpell(_W,myHero) end end
	db.Diana = {level={_W,_Q}}
	db.Diana.r = function(unit) return #object("visual",{"visible",true,"dist",{unit,10},"name","Diana_Base_Q"}) > 0 end
	db.Diana.clear = function(creep,creepSpawn)
		if myHero:GetDistance(creep) < 830 then
			CastSpell(_Q,creep.x,creep.z)
			if myHero.data.inRange(creep) then CastSpell(_W) end
		end
		if db.Diana.r(creep) then CastSpell(_R,creep) end
		myHero:Attack(creep)
	end
	db.Diana.skillCheck = function() if myHero.mana > 175 and myHero:CanUseSpell(_R) == READY and myHero:CanUseSpell(_Q) == READY then return _R end end
	db.Darius = {level={_Q,_W}}
	db.Darius.cleave = function() return myHero:CanUseSpell(_Q) == READY end
	db.Darius.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			CastSpell(_Q)
			CastSpell(_W)
		end
		myHero:Attack(creep)
	end
	db.Hecarim = {level={_Q,_W}}
	db.Hecarim.cleave = function(creepSpawn) return GetSpellData(_Q).level > 1 and (myHero:CanUseSpell(_W) == READY or myHero.data.buff("HecarimW") or creepSpawn.data.name == "wraith") end
	db.Hecarim.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			CastSpell(_Q)
			if (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) then CastSpell(_W) end
		end
		myHero:Attack(creep)
	end
	db.Jax = {level={_E,_W}}
	db.Jax.cleave = function() return myHero:CanUseSpell(_E) == READY or db.Jax.cs() end
	db.Jax.cs = function() return myHero.data.buff("JaxCounterStrike") end
	db.Jax.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			CastSpell(_W)
			if (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) and not db.Jax.cs() then CastSpell(_E) end
		elseif myHero.mana > 175 then CastSpell(_Q,creep) end
		myHero:Attack(creep)
	end
	db.Shen = {level={Q,_W}}
	db.Shen.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then
			CastSpell(_Q,creep)
			CastSpell(_W)
		end
		myHero:Attack(creep)
	end
	db.Shen.skillCheck = function() if myHero:CanUseSpell(_E) == READY then return _E end end
	db.Rammus = {level={_W,_Q}}
	db.Rammus.stance = function() return myHero.data.buff("PowerBall") or myHero.data.buff("DefensiveBallCurl") end
	db.Rammus.clear = function(creep,creepSpawn)
		if not db.Rammus.stance() and myHero.data.inRange(creep) then CastSpell(_W) end
		myHero:Attack(creep)
	end
	db.Rammus.slack = function(creepSpawn) if not db.Rammus.stance() and creepSpawn.data.get() == 0 and myHero:GetDistance(creepSpawn) > 200 and myHero:GetDistance(creepSpawn) < 2100 then CastSpell(_Q) end end
	db.Akali = {level={_Q,_E}}
	--db.Akali.creepSpawnEx = function() if myHero.level == 1 and object.creepSpawn.ored.data.get() == 0 then return object.creepSpawn.ored end end
	db.Akali.cleave = function() return myHero:CanUseSpell(_E) == READY or myHero:CanUseSpell(_Q) == READY or GetSpellData(_Q).cd-GetSpellData(_Q).currentCd < 1 end 
	db.Akali.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then CastSpell(_E)
		elseif myHero:GetDistance(creep) > 250 and myHero:GetDistance(creep) < 700 then CastSpell(_R,creep) end
		if not CastSpell(_Q,creep) then myHero:Attack(creep) end
	end
	db.DrMundo = {level={_Q,_E}}
	db.DrMundo.w = function() for i=0,objManager.maxObjects do local unit = objManager:getObject(i) if unit and unit.valid and unit.visible and unit.name == "DrMundo_Base_W_cas.troy" and unit:GetDistance(myHero) < 99 then return true end end return false end
	db.DrMundo.cleave = function() return myHero:CanUseSpell(_Q) == READY end
	db.DrMundo.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then 
			CastSpell(_E)
			if (not db.DrMundo.w() and #creepSpawn.data.creeps() > 1) or (db.DrMundo.w() and #creepSpawn.data.creeps() <= 1) then CastSpell(_W) end
			if (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) then 
				CastSpell(_Q,creep.x,creep.z) 
				if myHero.health/myHero.maxHealth < 0.2 then CastSpell(_R) end
			end
		end
		myHero:Attack(creep)
	end
	db.DrMundo.slack = function() if db.DrMundo.w() then CastSpell(_W) end end
	db.Shyvana = {level={_W,_E}}
	db.Shyvana.w = function() return myHero.data.buff("ShyvanaImmolationAura") end
	db.Shyvana.cleave = function() return myHero:CanUseSpell(_W) == READY or (myHero:GetSpellData(_W).level > 1 and db.Shyvana.w()) end
	db.Shyvana.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then 
			if (myHero.level < 3 or creepSpawn.data.health() > myHero.data.smiteDamage()) then CastSpell(_E,creep.x,creep.z) end
			CastSpell(_W)
			CastSpell(_Q)
		end
		myHero:Attack(creep)
	end
	db.Shyvana.slack = function(creepSpawn) if myHero:GetDistance(creepSpawn) > myHero.ms*GetSpellData(_W).cd then CastSpell(_W) end end
	db.LeeSin = {level={_Q,_W}}
	db.LeeSin.passive = function() for i=0,objManager.maxObjects do local unit = objManager:getObject(i) if unit and unit.valid and unit.visible and unit.name == "blindMonk_passive_buf.troy" and unit:GetDistance(myHero) < 99 then return true end end return false end
	db.LeeSin.first = function(spell,...) return myHero:GetSpellData(spell).name:find("One") and CastSpell(spell,...) end
	db.LeeSin.second = function(spell,...) return myHero:GetSpellData(spell).name:find("two") and CastSpell(spell,...) end
	db.LeeSin.cleave = function() return myHero:CanUseSpell(_Q) == READY end
	db.LeeSin.clear = function(creep,creepSpawn)
		if myHero.data.inRange(creep) then 
			if myHero:GetDistance(creep) < 50 and myHero:CanUseSpell(_Q) == READY then
				local pos = math.pos2d(creep,math.rad2d(creep,myHero),125)
				myHero:MoveTo(pos.x,pos.z)
			elseif not db.LeeSin.passive() then
				if db.LeeSin.first(_Q,creep.pos.x,creep.pos.z) or db.LeeSin.second(_Q) or (#creepSpawn.data.creeps() > 1 and db.LeeSin.first(_E))
				or db.LeeSin.first(_W,myHero) or db.LeeSin.second(_W) or db.LeeSin.first(_E) or db.LeeSin.second(_E) then return end
			end
		elseif not db.LeeSin.second(_Q) and myHero:GetDistance(creep) < 1100 then db.LeeSin.first(_Q,creep.pos.x,creep.pos.z) end
		myHero:Attack(creep)
	end
	db.LeeSin.skillCheck = function() if myHero:CanUseSpell(_Q) == READY and myHero.mana >= 70 then return _Q end end
	if not db[myHero.charName] then print("Jungler Slack >> "..myHero.charName.." skills are not yet supported") end
end
do -- fill gui
	gui.jungle.transform("anchor")
	gui.jungle.x,gui.jungle.y,gui.jungle[1],gui.jungle[2],gui.jungle[3] = 100,100,gui.jungle_desc,gui.jungle_farm_line,gui.jungle_advice
	gui.jungle_desc.transform("button").text = "Jungler Slack v"..version
	for k,creepSpawn in pairs(object.creepSpawn) do
		gui["jungle_timer_"..creepSpawn.hash].transform("world").pos = creepSpawn.pos
		gui["jungle_timer_"..creepSpawn.hash][1],gui["jungle_timer_"..creepSpawn.hash][2] = gui["jungle_timer_"..creepSpawn.hash.."_text"],gui["jungle_timer_"..creepSpawn.hash.."_smite"]
		gui["jungle_timer_"..creepSpawn.hash.."_text"].transform("text")
		gui["jungle_timer_"..creepSpawn.hash.."_smite"].transform("tick").text = "smite"
		gui["jungle_timer_"..creepSpawn.hash.."_smite"].visible,gui["jungle_timer_"..creepSpawn.hash.."_smite"].value = (myHero.data.smite ~= nil),true
	end
	gui.jungle_farm_line.transform("line")
	gui.jungle_farm_line[1],gui.jungle_farm_line[2],gui.jungle_farm_line[3],gui.jungle_farm_line[4],gui.jungle_farm_line[5] = gui.jungle_farm,gui.jungle_repeater,gui.jungle_gank,gui.jungle_level,gui.jungle_skillCheck
	gui.jungle_farm.transform("tick").text = "farm"
	gui.jungle_farm.proc = function(state) if state then timer.jungle.start(true) else timer.jungle.stop() end end
	bind.jungle_rmb.callback = function(down) if down then gui.jungle_farm.value = false end end
	bind.jungle_rmb.key = 0x2
	bind.jungle_f1.callback = function(down) if down then gui.jungle_farm.value = not gui.jungle_farm.value end end
	bind.jungle_f1.key = 0x70
	gui.jungle_repeater.transform("tick").text = "repeat"
	gui.jungle_gank.transform("tick").text = "gank path"
	gui.jungle_gank.value = (myHero.level == 1 and myHero.parType ~= 0)
	gui.jungle_level.transform("tick").text = "level"
	gui.jungle_level.value = false
	gui.jungle_level.visible = false
	gui.jungle_skillCheck.transform("tick").text = "skill check"
	gui.jungle_skillCheck.value = (db[myHero.charName] ~= nil and db[myHero.charName].skillCheck ~= nil)
	gui.jungle_skillCheck.visible = (db[myHero.charName] ~= nil and db[myHero.charName].skillCheck ~= nil)
	gui.jungle_advice.transform("anchor")
	gui.jungle_advice[1],gui.jungle_advice[2],gui.jungle_advice[3] = gui.jungle_top,gui.jungle_mid,gui.jungle_bot
	gui.jungle_top.transform("line")
	gui.jungle_top[1],gui.jungle_top[2],gui.jungle_top[3] = gui.jungle_top_text,gui.jungle_top_bar,gui.jungle_top_desc
	gui.jungle_top_text.transform("text").text = "top"
	gui.jungle_top_bar.transform("bar")
	gui.jungle_top_bar.min,gui.jungle_top_bar.max = 0,100
	gui.jungle_top_desc.transform("text")
	gui.jungle_mid.transform("line").visible = (NotLib.game == "classic")
	gui.jungle_mid[1],gui.jungle_mid[2],gui.jungle_mid[3] = gui.jungle_mid_text,gui.jungle_mid_bar,gui.jungle_mid_desc
	gui.jungle_mid_text.transform("text").text = "mid"
	gui.jungle_mid_bar.transform("bar")
	gui.jungle_mid_bar.min,gui.jungle_mid_bar.max = 0,100
	gui.jungle_mid_desc.transform("text")
	gui.jungle_bot.transform("line")
	gui.jungle_bot[1],gui.jungle_bot[2],gui.jungle_bot[3] = gui.jungle_bot_text,gui.jungle_bot_bar,gui.jungle_bot_desc
	gui.jungle_bot_text.transform("text").text = "bot"
	gui.jungle_bot_bar.transform("bar")
	gui.jungle_bot_bar.min,gui.jungle_bot_bar.max = 0,100
	gui.jungle_bot_desc.transform("text")
end
do -- fill logic
	local repeater = db.repeater
	local db = db[myHero.charName]
	timer.jungle.callback = function()
		-- dead
		if myHero.dead then return
		-- recall
		elseif myHero.data.recall() then if myHero.data.nearFontain() then myHero:MoveTo(myHero.x,myHero.z) end return
		-- fontain
		elseif myHero.data.nearFontainRegen() then return end
		-- level spells
		if gui.jungle_level.value then myHero.data.level(db.level) end
		-- search creep spawn
		local creepSpawn = db.creepSpawnEx() or db.creepSpawn()
		-- search creep
		local creep = db.targetEx(creepSpawn) or db.target(creepSpawn,db.cleave(creepSpawn))
		if creep then
			-- pot
			if myHero.health/myHero.maxHealth < 0.45 and not myHero.data.buff.healthPot() then CastSpell(myHero.data.item.healthPot()) end
			-- channel
			if db.channel(creepSpawn) then return
			-- repeater logic 
			elseif gui.jungle_repeater.value then repeater.clear(creep,creepSpawn)
			-- logic
			else db.clear(creep,creepSpawn) end
		-- channel
		elseif db.channel(creepSpawn) then return
		-- slack
		elseif db.slack(creepSpawn) then return
		else
			-- skill check
			local skillCheck,skillCheckPos = db.skillCheck(),db.skillCheckPos(creepSpawn)
			if gui.jungle_skillCheck.value and skillCheck and skillCheckPos and db.skillCheckEx(creepSpawn,skillCheck,skillCheckPos) then return
			-- run
			elseif creepSpawn:GetDistance(myHero) > 50 then creepSpawn.data.moveTo() end
		end
	end
	timer.jungle.cooldown = 0.25
	if myHero.charName == "FiddleSticks" then timer.jungle.cooldown = 0.4 end
	timer.jungle.random = function() return math.random(-10,10)/100 end
end
do -- maintenance 
	timer.jungle_advice.cooldown,timer.jungle_advice.callback = 0.1,function() 
		if gui.jungle_top.visible then gui.jungle_top_bar.value,gui.jungle_top_bar.max,gui.jungle_top_desc.text = sugar.pushPower("top") end
		if gui.jungle_mid.visible then gui.jungle_mid_bar.value,gui.jungle_mid_bar.max,gui.jungle_mid_desc.text = sugar.pushPower("mid") end
		if gui.jungle_bot.visible then gui.jungle_bot_bar.value,gui.jungle_bot_bar.max,gui.jungle_bot_desc.text = sugar.pushPower("bot") end
	end
	timer.jungle_advice.start()
	timer.jungle_refresh.callback = function()
		for k,creepSpawn in pairs(object.creepSpawn) do 
			creepSpawn.data.refresh() 
			gui["jungle_timer_"..creepSpawn.hash.."_text"].text = tostring(math.floor(creepSpawn.data.get()))
		end
	end
	timer.jungle_refresh.start()
	timer.jungle_smite.callback = function() if myHero:CanUseSpell(myHero.data.smite) == READY then
		local damage = myHero.data.smiteDamage()
		for k,creep in pairs(NotLib.object("creep",{"attack",myHero,"dist",{myHero,850}})) do
			local creepSpawn = creep.data.creepSpawn()
			if creep.maxHealth > damage*2 and creepSpawn.data.started() and gui["jungle_timer_"..creepSpawn.hash.."_smite"].value and (creep.health <= damage 
			or (creepSpawn.data.type ~= "red" and creepSpawn.data.type ~= "blue" and creepSpawn.data.type ~= "dragon" and creepSpawn.data.type ~= "nashor" and creepSpawn.data.type ~= "cancer" 
			and #object("player",{"dist",{creep,1500},"dead",false,"isMe",false}) == 0)) then CastSpell(myHero.data.smite,creep) end
		end
	end end
	if myHero.data.smite then timer.jungle_smite.start() end
end