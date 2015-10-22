--[[
NotLib
by Ivan[RUSSIA]

GPL v2 license
--]]
-- NILL CALLBACK
local NCB,NCBT,NCBF,NCB0,NCBV = function() end,function() return true end,function() return false end,function() return 0 end,function() return VEC(0,0) end
-- CAST SPELL FIX
local OriginalCastSpell = _G.CastSpell
_G.CastSpell = function(id,...) if id == nil then return false elseif myHero:CanUseSpell(id) ~= READY then return false else OriginalCastSpell(id,...) return true end end
-- TABLE
local setproxytable = function(t,cb) return setmetatable({},{__len = function(p) return #t end,__index = function(p,k) return t[k] end,__newindex = function(p,k,v) if t[k] ~= v then t[k] = v cb(k) end end}) end
-- START MAGIC
NotLib = {}
do -- math
	_G.VEC = function(x,z) local result = D3DXVECTOR3(x,95,z) result.pos = result return result end
	math.dist2d = function(x1,y1,x2,y2) return math.sqrt((x2-x1)^2+(y2-y1)^2) end
	math.pos2d = function(pos,rad,range) return VEC(pos.x+math.cos(rad)*range,pos.z+math.sin(rad)*range) end
	math.center2d = function() return D3DXVECTOR3(cameraPos.x,-161.1643,cameraPos.z+(cameraPos.y+161.1643)*math.sin(0.6545)) end
	math.rad2d = function(pos1,pos2)
		if pos2.z > pos1.z then return math.atan2(pos2.z-pos1.z,pos2.x-pos1.x) -- 0-180
		else return math.pi*2+math.atan2(pos2.z-pos1.z,pos2.x-pos1.x) end -- 180-360
	end
	math.normal2d = function(pos1,pos2)
		local rad = math.rad2d(pos1,pos2)
		return VEC(math.sin(rad),math.cos(rad))
	end
	math.proj2d = function(dotPos,linePos1,linePos2)
		local m = (linePos2.z-linePos1.z)/(linePos2.x-linePos1.x) -- convert line to vector > line tangent
		local b = linePos1.z-(m*linePos1.x) -- K (ax+by+k)
		local x = (m*dotPos.z+dotPos.x-m*b)/(m^2+1) -- hipoX / secans = adj
		local z = (m^2*dotPos.z+m*dotPos.x+b)/(m^2+1) -- hipoZ / secans = adj
		return VEC(x,z)
	end
	math.pass2d = function(pos,rad,scanRange,state)
		for i=0,scanRange,20 do
			local candidate = math.pos2d(pos,rad,i)
			if IsWall(candidate) == state then return candidate,i end
		end
	end
	math.vision2d = function(pos,rad,scanRange)
		for i=0,scanRange,20 do
			local candidate = math.pos2d(pos,rad,i)
			if IsWall(candidate) or IsGrass(candidate) then return false end
		end
		return true
	end
end
do -- timer
	NotLib.timer = setmetatable({},{__call=function(timer,hkey,cooldown) 
		timer[hkey].cooldown = (cooldown or timer[hkey].cooldown) 
		return timer[hkey]
	end,__index=function(timer,hkey) 
		local h = {hkey=hkey,lastcall=math.huge,cooldown=0,callback=NCB}
		h.random = function() return 0 end
		h.stop = function() h.lastcall = math.huge end
		h.pause = function(timeline) h.lastcall = h.lastcall + timeline end
		h.start = function(callback) h.lastcall = GetTickCount()/1000 if callback then h.callback() end end
		h.running = function() return h.lastcall < math.huge end
		h.disable = function() timer[hkey] = nil end
		timer[hkey] = h
		return timer[hkey]
	end})
	AddTickCallback(function()
		local clock = GetTickCount()/1000
		for hkey,h in pairs(NotLib.timer) do if h.lastcall + h.cooldown <= clock then
			h.lastcall = h.lastcall+h.cooldown+h.random()
			h.callback()
		end end
	end)
end
do -- bind
	NotLib.bind = setmetatable({},{__call=function(bind,hkey,key) 
		bind[hkey].key = (key or bind[hkey].key) 
		return bind[hkey] 
	end,__index=function(bind,hkey)
		local h = {hkey=hkey,key=math.huge,callback=NCB,mouse=NCB}
		h.disable = function() bind[hkey] = nil end
		bind[hkey] = h
		return bind[hkey]
	end})
	AddMsgCallback(function(msg,wParam)
		if msg == 0x200 then wParam,msg = 0x0,KEY_DOWN elseif msg == 0x202 then wParam,msg = 0x1,KEY_UP 
		elseif msg == 0x205 then wParam,msg = 0x2,KEY_UP elseif msg == 0x208 then wParam,msg = 0x4,KEY_UP end
		for hkey,h in pairs(NotLib.bind) do 
			if wParam == 0 then h.mouse()
			elseif h.key == wParam then h.callback(msg ~= KEY_UP) end
			if NotLib.bind[hkey] == nil then break end
		end
	end)
end
do -- gui
	NotLib.gui = setmetatable({},{__call=function(gui,hkey) return gui[hkey] end,__index=function(gui,hkey)
		local h = {x=0,y=0,visible=true,bind=NotLib.bind(#NotLib.bind+1,0x1),children={}}
		h.parent = function() for key,parent in pairs(gui) do for i=1,#parent do if parent[i] == h then return parent end end end end
		h.inside = function(pos) return pos.x >= h.x and pos.x <= h.x+h.w and pos.y >= h.y and pos.y <= h.y+h.h end
		h.screen = function() return true end
		h.reset = function() 
			h.changed,h.refresh,h.proc,h.callback,h.bind.callback,h.bind.mouse = NCB,NCB,NCB,NCB,NCB,NCB
			h.w,h.h,h.tSize,h.lSize,h.font,h.back = 0,0,WINDOW_H/40,WINDOW_H/225,0xAAFFFF00,0xBB964B00 
		end
		h.transform = function(to)
			h.reset()
			if to == "text" then
				h.text = ""
				h.refresh = function() h.w,h.h = GetTextArea(h.text,h.tSize).x,h.tSize end
				h.callback = function() DrawText(h.text,h.tSize,h.x,h.y,h.font) end
			end
			if to == "button" then
				h.down,h.text = false,"text"
				h.refresh = function() h.w,h.h = GetTextArea(h.text,h.tSize).x+h.tSize,h.tSize end
				h.callback = function()
					if h.down == false then 
						DrawLine(h.x,h.y+h.tSize/2,h.x+h.w,h.y+h.tSize/2,h.h,h.back)
						DrawText(h.text,h.tSize,h.x+h.tSize/2,h.y,h.font)
					else
						DrawLine(h.x,h.y+h.tSize/2,h.x+h.w,h.y+h.tSize/2,h.h,h.font)
						DrawText(h.text,h.tSize,h.x+h.tSize/2,h.y,h.back)
					end
				end
				h.bind.callback = function(down) 
					if h.visible == true and h.inside(GetCursorPos()) == true then
						if down == false and h.down == true then h.proc() end
						h.down = down
					else h.down = false end
				end
			end
			if to == "tick" then
				h.value,h.text = false,""
				h.refresh = function() h.w,h.h = h.tSize+h.lSize*2+GetTextArea(h.text,h.tSize).x,h.tSize end
				h.callback = function() 
					if h.value == true then DrawLine(h.x+h.tSize/2,h.y+h.lSize*1.5,h.x+h.tSize/2,h.y+h.tSize-h.lSize*1.5,h.tSize-h.lSize*3,h.font) end
					DrawLine(h.x,h.y,h.x+h.tSize,h.y,h.lSize,h.back) -- top
					DrawLine(h.x,h.y+h.tSize,h.x+h.tSize,h.y+h.tSize,h.lSize,h.back) -- bot
					DrawLine(h.x,h.y,h.x,h.y+h.tSize,h.lSize,h.back) -- left
					DrawLine(h.x+h.tSize,h.y,h.x+h.tSize,h.y+h.tSize,h.lSize,h.back) -- right
					DrawText(h.text,h.tSize,h.x+h.tSize+h.lSize*2,h.y,h.font) -- text
				end
				h.bind.callback=function(down) if down and h.visible == true and h.inside(GetCursorPos()) == true then h.value = not h.value end end
			end
			if to == "bar" then
				h.value,h.min,h.max = 0,0,1
				h.refresh = function() h.w,h.h = h.tSize*5.5+math.max(GetTextArea(tostring(h.min),h.tSize).x,GetTextArea(tostring(h.max),h.tSize).x),h.tSize end
				h.callback = function()
					DrawLine(h.x,h.y+h.tSize/2,h.x+h.tSize*5,h.y+h.tSize/2,h.tSize,h.back)
					local valueX = h.x+(h.tSize*5)/(h.max-h.min)*(h.value-h.min)
					DrawLine(h.x,h.y+h.tSize/2,valueX,h.y+h.tSize/2,h.tSize,h.font)
					DrawText(tostring(h.value),h.tSize,h.x+h.tSize*5.25,h.y,h.font)
				end
			end
			if to == "slider" then
				h.down,h.value,h.min,h.max = false,0,0,1
				h.refresh = function() h.w,h.h = h.tSize*5.5+h.lSize+math.max(GetTextArea(tostring(h.min),h.tSize).x,GetTextArea(tostring(h.max),h.tSize).x),h.tSize end
				h.callback = function()
					DrawLine(h.x,h.y+h.tSize/2,h.x+h.tSize*5,h.y+h.tSize/2,h.lSize,h.back)
					local valueX = h.x+(h.tSize*5)/(h.max-h.min)*(h.value-h.min)
					DrawLine(valueX,h.y,valueX,h.y+h.tSize,h.lSize*2,h.font)
					DrawText(tostring(h.value),h.tSize,h.x+h.tSize*5.25+h.lSize,h.y,h.font)
				end
				h.bind.callback = function(down) 
					h.down = (down == true and h.visible == true and h.inside(GetCursorPos()) == true and h.inside(GetCursorPos()) == true)
					if h.down == true then h.bind.mouse() end				
				end
				h.bind.mouse = function() if h.down == true then 
					local result = math.floor(h.min+(GetCursorPos().x-h.x)*(h.max-h.min)/(h.tSize*5)+0.5)
					h.value = math.min(h.max,math.max(h.min,result))
				end end
			end
			if to == "line" then
				h.refresh = function()
					local x,y = 0,0
					for i=1,#h do if h[i].w > 0 then
						h[i].x,h[i].y = h.x+x,h.y
						x,y = x+h[i].w+h.lSize*2,math.max(y,h[i].h)
					end end
					h.w,h.h = math.max(0,x-h.lSize*2),y
				end
			end
			if to == "list" then
				h.refresh = function()
					local x,y = 0,0
					for i=1,#h do if h[i].w > 0 then
						h[i].y,h[i].x = h.y+y,h.x
						y,x = y+h[i].h+h.lSize*2,math.max(x,h[i].w)
					end end
					h.h,h.w = math.max(0,y-h.lSize*2),x
				end
			end
			if to == "anchor" then
				h.refresh = function()
					local x,y = 0,h.lSize*4
					for i=1,#h do if h[i].w > 0 then
						h[i].y,h[i].x = h.y+y,h.x
						y,x = y+h[i].h+h.lSize*2,math.max(x,h[i].w)
					end end
					h.h,h.w = math.max(h.lSize*2,y-h.lSize*2),x
				end
				h.callback = function() DrawLine(h.x,h.y+h.lSize,h.x+h.w,h.y+h.lSize,h.lSize*2,h.font) end
				h.bind.callback = function(down) 
					if down == true and h.visible == true and GetCursorPos().x >= h.x and GetCursorPos().x <= h.x+h.w 
					and GetCursorPos().y >= h.y and GetCursorPos().y <= h.y+h.lSize*2 then h.point = {x=GetCursorPos().x-h.x,y=GetCursorPos().y-h.y}
					else h.point = nil end
				end
				h.bind.mouse = function() if h.point ~= nil then
					h.x = math.min(WINDOW_W-h.w,math.max(0,GetCursorPos().x-h.point.x))
					h.y = math.min(WINDOW_H-h.h,math.max(0,GetCursorPos().y-h.point.y))
				end end
			end
			if to == "world" then
				h.pos = {x=0,z=0}
				h.refresh = function()
					local x,y = 0,0
					for i=1,#h do if h[i].w > 0 then
						h[i].y,h[i].x = h.y+y,h.x
						y,x = y+h[i].h+h.lSize*2,math.max(x,h[i].w)
					end end
					h.h,h.w = math.max(0,y-h.lSize*2),x
				end
				h.screen = function()
					local pos = WorldToScreen(h.pos)
					h.x,h.y = pos.x,pos.y
					return (h.x+h.w >= WINDOW_X) and (h.y+h.h >= WINDOW_Y) and (h.x <= WINDOW_W) and (h.y <= WINDOW_H)
				end
			end
			if to == "question" then
				gui[hkey.."qtext"].transform("text")
				gui[hkey.."qbutton1"].transform("button")
				gui[hkey.."qbutton1"].text,gui[hkey.."qbutton1"].proc = "yes",function() h.disable() h.proc(true) end
				gui[hkey.."qbutton2"].transform("button")
				gui[hkey.."qbutton2"].text,gui[hkey.."qbutton2"].proc = "no",function() h.disable() h.proc(false) end 
				gui[hkey.."qline"].transform("line")
				gui[hkey.."qline"][1],gui[hkey.."qline"][2] = gui[hkey.."qbutton1"],gui[hkey.."qbutton2"]
				h.transform("anchor")
				h[1],h[2],h.changed = gui[hkey.."qtext"],gui[hkey.."qline"],function(k) if k == "text" then gui[hkey.."qtext"].text = (h.text or "") end end
			end
			if to == "test" then
				h.transform("question").text = "test?"
				h.proc = function(value) if value == true then
					gui[hkey.."testtick"].transform("tick").text = "NotLib.gui test"
					gui[hkey.."testtick"].proc = function(value) gui[hkey.."testline"].visible = value end
					gui[hkey.."testbar"].transform("bar")
					gui[hkey.."testbar"].value,gui[hkey.."testbar"].min,gui[hkey.."testbar"].max = 15,10,20
					gui[hkey.."testslider"].transform("slider").proc = function(value) gui[hkey.."testbar"].value = value end
					gui[hkey.."testslider"].value,gui[hkey.."testslider"].min,gui[hkey.."testslider"].max = 15,10,20
					gui[hkey.."testbutton"].transform("button").proc = function() gui[hkey.."testslider"].value = 15 end
					gui[hkey.."testbutton"].text = "reset"
					gui[hkey.."testline"].transform("line").visible = false
					gui[hkey.."testline"][1],gui[hkey.."testline"][2],gui[hkey.."testline"][3] = gui[hkey.."testbar"],gui[hkey.."testslider"],gui[hkey.."testbutton"]
					gui[hkey.."test"].transform("world").pos = myHero
					gui[hkey.."test"][1],gui[hkey.."test"][2] = gui[hkey.."testtick"],gui[hkey.."testline"]
					h.refresh()
				end end
			end
			return h
		end
		h.disable = function() 
			h.bind.disable()
			for i=1,#h do h[i].disable() end
			gui[hkey] = nil
		end
		h.reset()
		h = setproxytable(h,function(k)
			if (k == "w" or k == "h") and h.parent() ~= nil then h.parent().refresh()
			elseif k == "value" then h.proc(h.value)
			else
				if k == "visible" then for i=1,#h do h[i].visible = h.visible end
				elseif type(k) == "number" and h[k] ~= nil and h.visible == false then h[k].visible = false end
				if h.visible then h.refresh() else h.w,h.h = 0,0 end
			end
			h.changed(k)
		end)
		gui[hkey] = h
		return gui[hkey]
	end})
	AddDrawCallback(function()
		for hkey,h in pairs(NotLib.gui) do if h.visible and h.screen() then
			h.callback()
			if NotLib.gui[hkey] == nil then break end
		end end
	end)
end
do -- filter
	NotLib.map = setmetatable({},{__call=function(map,t,param)
		local result = {}
		for k,unit in pairs(t) do
			local flag = true
			for i=1,#param,2 do
				flag = flag and map[param[i]](unit,param[i+1])
				if flag == false then break end
			end
			if flag == true then result[#result+1] = unit end
		end
		return result
	end,__newindex=function(map,k,v)
		rawset(map,k,v)
		rawset(map,"!"..k,function(unit,var) return not v(unit,var) end)
	end,__index=function(map,k) 
		if k:sub(1,1) == "!" then k = k:sub(2) end
		map[k] = function(unit,var) return unit[k] == var end
		return map[k]
	end})
	NotLib.map["number"] = function(unit,var) return unit.data.number == var end
	NotLib.map["buff"] = function(unit,var) return unit.data.buff(var) end
	NotLib.map["side"] = function(unit,var) return unit.data.side() == var end
	NotLib.map["top"],NotLib.map["mid"],NotLib.map["bot"] = function(unit,var) return NotLib.sugar.isTop(unit) == var end,function(unit,var) return NotLib.sugar.isMid(unit) == var end,function(unit,var) return NotLib.sugar.isBot(unit) == var end
	NotLib.map["type"] = function(unit,var) return unit.data.type == var end
	NotLib.map["name"] = function(unit,var) return unit.name:lower():find(var:lower()) ~= nil end
	NotLib.map["names"] = function(unit,var) for k,var in pairs(var) do if unit.name:lower():find(var:lower()) ~= nil then return true end end return false end
	NotLib.map["aa"] = function(unit,var) return unit.pos:GetDistance(var.pos) <= var.range+var.boundingRadius+unit.boundingRadius end
	NotLib.map["dist"] = function(unit,var) return unit.pos:GetDistance(var[1].pos) <= var[2] end -- unit,range
	NotLib.map["targetable"] = function(unit,var) return unit.bTargetable == var end 
	NotLib.map["health"] = function(unit,var) return unit.health >= var end
	NotLib.map["healthPct"] = function(unit,var) return unit.health/unit.maxHealth >= var end
	NotLib.map["mana"] = function(unit,var) return unit.mana >= var end
	NotLib.map["manaPct"] = function(unit,var) return unit.mana/unit.maxMana >= var end
	NotLib.map["recent"] = function(unit,var) return (unit.tick or unit.data.tick) <= var end
	NotLib.map["assist"] = function(unit,var) return not unit.dead and unit.visible and unit.team == var.team and unit.bTargetableToTeam and not unit.data.buff("zhonyasringshield") end
	NotLib.map["assistEx"] = function(unit,var) return not unit.dead and unit.visible and unit.team == var.team and unit.bTargetableToTeam and not unit.data.buff("zhonyasringshield") and not unit.data.recall() and not unit.data.nearShop() end
	NotLib.map["attack"] = function(unit,var) return not unit.dead and unit.visible and unit.team ~= var.team and unit.bTargetable end
	NotLib.map["safe"] = function(unit,var) return unit.data.safe(var[1],var[2]) end -- units,range
	NotLib.reduce = setmetatable({},{__call=function(reduce,t,param,var)
		param = reduce[param]
		local result = nil
		for k,unit in pairs(t) do if not result then result = unit else result = param(result,unit,var) end end
		return result
	end,__newindex=function(reduce,k,v)
		rawset(reduce,k,v)
		rawset(reduce,"!"..k,function(result,unit,var) return select(2,v(result,unit,var)) end)
	end})
	NotLib.reduce["dist"] = function(result,unit,var) if unit.pos:GetDistance(var.pos) < result.pos:GetDistance(var.pos) then return unit,result else return result,unit end end
	NotLib.reduce["range"] = function(result,unit,var) if unit.pos:GetDistance(var.pos)-unit.boundingRadius < result.pos:GetDistance(var.pos)-result.boundingRadius then return unit,result else return result,unit end end
	NotLib.reduce["health"] = function(result,unit) if unit.health > result.health then return unit,result else return result,unit end end
	NotLib.reduce["mana"] = function(result,unit) if unit.mana > result.mana then return unit,result else return result,unit end end
	NotLib.reduce["last"] = function(result,unit) if (unit.tick or unit.data.tick) > (result.tick or result.data.tick) then return unit,result else return result,unit end end
end
do -- object
	NotLib.object = setmetatable({},{__index=function(object,key)
		if key:find("+") then
			local result = {}
			for class in key:gmatch("%w+") do for hash,unit in pairs(object[class]) do result[#result+1] = unit end end
			return result
		end
		object[key] = {}
		return object[key]
	end,__call=function(object,key,map,reduce,var) 
		local result = object[key]
		if map then result = NotLib.map(result,map) end
		if reduce then result = NotLib.reduce(result,reduce,var) end
		return result
	end})
	-- unit classification
	NotLib.object.class = function(unit)
		local type = unit.type
		if type ==  "obj_Turret" or type == "obj_Levelsizer" or type == "obj_NavPoint" or type ==  "LevelPropSpawnerPoint" 
		or type ==  "LevelPropGameObject" or type == "GrassObject" or type ==  "obj_Lake" or type ==  "obj_LampBulb" or type ==  "DrawFX" then return "useless"
		elseif type ==  "obj_GeneralParticleEmitter" or type == "obj_AI_Marker" or type == "FollowerObject" then return "visual"
		elseif type ==  "obj_AI_Minion" then
			local name = unit.name:lower()
			if name:find("minion") then return "minion"
			elseif name:find("ward") then return "ward"
			elseif name:find("buffplat") or name == "odinneutralguardian" then return "point"
			elseif name:find("shrine") or name:find("relic") then return "event"
			elseif NotLib.game == "classic" and unit.name:find("%d+%.%d+") and (name:find("baron")  or name:find("dragon") or name:find("blue") or name:find("red") or name:find("krug") or name:find("crab") or name:find("gromp") or name:find("wolf") or name:find("razor")) then return "creep"
			elseif NotLib.game == "tt" and unit.name:find("%d+%.%d+") and (name:find("wraith") or name:find("golem") or name:find("wolf") or name:find("spider")) then return "creep"
			elseif unit.bTargetableToTeam == false or unit.bTargetable == false then return "trap" 
			else return "pet" end
		elseif type ==  "obj_AI_Turret" then return "tower"
		elseif type == "AIHeroClient" then return "player"
		elseif type ==  "obj_Shop" then return "shop"
		elseif type ==  "obj_HQ" then return "nexus"
		elseif type ==  "obj_BarracksDampener" then return "inhibitor"
		elseif type ==  "obj_SpawnPoint" then return "spawn"
		elseif type ==  "obj_Barracks" then return "minionSpawn"
		elseif type ==  "NeutralMinionCamp" then return "creepSpawn"
		elseif type ==  "obj_InfoPoint" then return "event"
		elseif type == "SpellMissileClient" or type == "SpellCircleMissileClient" or type == "SpellLineMissileClient" or type == "SpellChainMissileClient" then return "spell" end
		return "error"
	end 
	-- game 
	for i=0,objManager.maxObjects do local unit = objManager:getObject(i) if unit and unit.valid and NotLib.object.class(unit) == "spawn" then 
		if NotLib.game then 
			NotLib.game = NotLib.game:GetDistance(unit)
			if NotLib.game < 12810 then NotLib.game = "dom" elseif NotLib.game < 13270 then NotLib.game = "tt"
			elseif NotLib.game < 15185 then NotLib.game = "pg" elseif NotLib.game < 19725 then NotLib.game = "classic" else NotLib.game = "unknown" end
			break
		else NotLib.game = unit end
	end end
	-- general upgrade
	NotLib.object.upgrade = setmetatable({},{__call= function(upgrade,unit) -- general unit upgrade
		if unit.data == nil or unit.data ~= "table" then unit.data = {} end 
		unit.data.class = NotLib.object.class(unit)
		unit.data.type = unit.data.class
		unit.data.tick= GetTickCount()/1000
		unit.data.moveTo = function() myHero:MoveTo(unit.x+math.random(-50,50)/10,unit.z+math.random(-50,50)/10) end
		unit.data.calcDamage = function(target,v) local armor=target.armor*unit.armorPenPercent-unit.armorPen if armor > 0 then return v*(100/(100+armor)) else return v*(2-100/(100+armor)) end end
		unit.data.calcMagicDamage = function(target,v) local armor=target.magicArmor*unit.magicPenPercent-unit.magicPen if armor > 0 then return v*(100/(100+armor)) else return v*(2-100/(100+armor)) end end
		unit.data.side = function()
			local dist = NotLib.object.allySpawn:GetDistance(unit.pos)-NotLib.object.enemySpawn:GetDistance(unit.pos)
			if dist > 1250 then return TEAM_ENEMY elseif dist < -1250 then return myHero.team else return TEAM_NEUTRAL end
		end
		unit.data.inRange = function(target)
			local result = unit.range+unit.boundingRadius+target.boundingRadius
			return result >= unit.pos:GetDistance(target.pos)
		end
		unit.data.safe = function(targets,range) return #NotLib.map(targets,{"attack",unit,"dist",{unit,range}}) == 0 end 
		unit.data.buff = setmetatable({},{__call=function(buff,...)
			local list = {...}
			for i=0,unit.buffCount do
				local buff = unit:getBuff(i)
				if buff.valid then for h=1,#list,1 do if buff.name == list[h] then return true end end end
			end
			return false
		end})
		unit.data.buff.healthPot = function() return unit.data.buff("ItemCrystalFlask","RegenerationPotion","ItemMiniRegenPotion") end
		unit.data.buff.recall = function() return unit.data.buff("recall","recallimproved") end
		unit.data.buff.red = function() return unit.data.buff("blessingofthelizardelder") end
		unit.data.buff.wound = function() return unit.data.buff("grievouswound") end
		unit.data.buff.redSlow = function() return unit.data.buff("blessingofthelizardelderslow") end
		unit.data.item = setmetatable({},{__call=function(item,...)
			local item,usable = {...},false
			if type(item[#item]) == "boolean" then 
				usable = item[#item]
				table.remove(item,#item)
			end
			for i1=1,#item do for i2=ITEM_1,ITEM_7 do if item[i1] == unit:getInventorySlot(i2) and (usable ~= true or unit:CanUseSpell(i2) == READY) then return i2 end end end
		end})
		unit.data.item.healthPot = function() return unit.data.item(2041,2003,2010,2009,true) end
		unit.data.path = function()
			local result = {unit.pos}
			if unit.hasMovePath then for i=unit.pathIndex,unit.pathCount do result[#result+1] = unit:GetPath(i) end end
			return result
		end
		unit.data.pathDistance = function()
			local result,path = 0,unit.data.path()
			for i=2,#path do result = result+path[i-1]:GetDistance(path[i]) end
			return result
		end
		unit.data.pathPredict = function(time)
			local result,path = 0,unit.data.path()
			for i=2,#path do
				local localResult = path[i-1]:GetDistance(path[i])/myHero.ms 
				if result+localResult < time then result = result+localResult 
				else return math.pos2d(path[i-1],math.rad2d(path[i-1],path[i]),(time-result)*myHero.ms) end
			end
			return path[#path]
		end
		if upgrade[unit.data.class] ~= nil then upgrade[unit.data.class](unit) end
	end})
	-- upgrade minion
	NotLib.object.upgrade.minion = function(unit)
		unit.data.type,unit.data.projSpeed = "default",math.huge
		if unit.charName:lower():find("wizard") then unit.data.type,unit.data.projSpeed = "wizard",640
		elseif unit.charName:lower():find("cannon") then unit.data.type,unit.data.projSpeed = "cannon",1150 end
	end
	-- upgrade creep
	NotLib.object.upgrade.creep = function(unit)
		unit.data.number = tonumber(unit.name:sub(unit.name:find("%d+"),unit.name:find("%.")-1))
		if unit.data.number >= 21 then unit.data.number = unit.data.number%10 end --fix
		unit.data.creepSpawn = function() for k,creepSpawn in pairs(NotLib.object.creepSpawn) do if creepSpawn.data.number == unit.data.number then return creepSpawn end end end
	end
	-- upgrade creepSpawn
	NotLib.object.upgrade.creepSpawn = function(unit)
		unit.data.number = tonumber(unit.name:sub(unit.name:find("%d+")))
		unit.data.creeps = function() return NotLib.object("creep",{"attack",myHero,"number",unit.data.number,"dist",{unit,1000}}) end
		unit.data.bigCreep = function() return NotLib.object("creep",{"attack",myHero,"number",unit.data.number,"dist",{unit,1000}},"health") end
		unit.data.health = function() local result = 0 for k,creep in pairs(unit.data.creeps()) do result = result+creep.health end return result end
		unit.data.dead,unit.data.respawn = 120,100
		if NotLib.game == "classic" then
			if unit.data.number == 6 then unit.data.type,unit.data.dead,unit.data.respawn = "dragon",150,360
			elseif unit.data.number == 12 then unit.data.type,unit.data.dead,unit.data.respawn = "nashor",750,420
			elseif unit.data.number == 1 or unit.data.number == 7 then unit.data.type,unit.data.respawn = "blue",300
			elseif unit.data.number == 4 or unit.data.number == 10  then unit.data.type,unit.data.respawn = "red",300
			elseif unit.data.number == 2 or unit.data.number == 8 then unit.data.type = "wolf"
			elseif unit.data.number == 3 or unit.data.number == 9  then unit.data.type = "wraith"
			elseif unit.data.number == 5 or unit.data.number == 11 then unit.data.type = "golem"
			elseif unit.data.number == 13 or unit.data.number == 14 then unit.data.type = "wight"			
			elseif unit.data.number == 15 or unit.data.number == 16 then unit.data.type,unit.data.dead,unit.data.respawn = "cancer",150,180 end
		end
		unit.data.started = function() return #NotLib.map(unit.data.creeps(),{"!healthPct",0.999}) > 0 end
		unit.data.runTime = function(tp) if tp == true then return 8.5 else return 2+myHero:GetDistance(unit.pos)/myHero.ms end end
		unit.data.set = function(state) if state then unit.data.dead = 0 else unit.data.dead = GetInGameTimer()+unit.data.respawn end end
		unit.data.get = function() return math.max(0,unit.data.dead-GetInGameTimer()) end
		unit.data.refresh = function(force)
			if #NotLib.object("creep",{"visible",true,"dead",false,"number",unit.data.number,"dist",{unit,1000}}) > 0 then unit.data.set(true)
			elseif unit.data.get() <= 0 and (force or (not myHero.dead and unit.data.type ~= "cancer" and myHero:GetDistance(unit) < 1200 and math.vision2d(myHero,math.rad2d(myHero,unit),myHero:GetDistance(unit)-15))) then unit.data.set(false)
			elseif #NotLib.object("creep",{"visible",true,"dead",true,"number",unit.data.number,"dist",{unit,1000}}) > 0 then unit.data.set(false) end
		end
		unit.data.target = function(cleave)
			local target,red = nil,(not cleave and myHero.data.buff.red())
			for k,creep in pairs(unit.data.creeps()) do
				if target == nil then target = creep
				elseif red == true and (target.data.buff.redSlow() or creep.data.buff.redSlow()) then
					if target.data.buff.redSlow() and not creep.data.buff.redSlow() then target = creep end
				elseif cleave and creep.maxHealth > target.maxHealth then target = creep 
				elseif not cleave and creep.maxHealth < target.maxHealth then target = creep
				elseif creep.maxHealth == target.maxHealth and creep.networkID > target.networkID then target = creep end
			end
			return target
		end
	end
	-- upgrade player
	NotLib.object.upgrade.player = function(unit)
		unit.data.nearShop = function() return unit.dead or unit:GetDistance(NotLib.object("shop",{"team",unit.team})[1]) < 1250 end
		unit.data.nearFontain = function() return unit.dead or unit:GetDistance(NotLib.object("spawn",{"team",unit.team})[1]) < 1100 end
		unit.data.nearFontainRegen = function()
			return unit.dead or (unit:GetDistance(NotLib.object("spawn",{"team",unit.team})[1]) < 1100 
			and (unit.health/unit.maxHealth+0.1 <= 1-0.1*(1100-myHero:GetDistance(NotLib.object("spawn",{"team",unit.team})[1]))/unit.ms 
			or (unit.parType == 0 and unit.mana/unit.maxMana+0.3 <= 1-0.1*(1100-myHero:GetDistance(NotLib.object("spawn",{"team",unit.team})[1]))/unit.ms)))
		end
		unit.data.smiteDamage = function()
			local damage = 370 + unit.level*20
			if unit.level > 4 then damage = damage+(unit.level-4)*10 end
			if unit.level > 9 then damage = damage+(unit.level-9)*10 end
			if unit.level > 14 then damage = damage+(unit.level-14)*10 end
			return damage
		end
		unit.data.recall = function() return unit.data.buff.recall() and #NotLib.object("visual",{"name","teleporthome","dist",{unit,25}}) > 0 end
		for i=SUMMONER_1,SUMMONER_2,(SUMMONER_2-SUMMONER_1) do
			local name = unit:GetSpellData(i).name
			if name:find("smite") then unit.data.smite = i
			elseif name == "summonerhaste" then unit.data.ghost = i
			elseif name == "summonerrevive" then unit.data.revive = i
			elseif name == "summonerheal" then unit.data.heal = i
			elseif name == "summonerteleport" then unit.data.teleport = i
			elseif name == "summonerflash" then unit.data.flash = i
			elseif name == "summonerdot" then unit.data.ignite = i
			elseif name == "summonerbarrier" then unit.data.barrier = i
			elseif name == "summonerexhaust" then unit.data.exhaust = i
			elseif name == "summonerboost" then unit.data.cleanse = i
			elseif name == "summonermana" then unit.data.clarity = i end
		end
		unit.data.ward = function(wards)
			local slot = unit.data.item(3340,3361,2049,2045,3154,2044,true)
			if wards == nil then return slot
			elseif slot ~= nil then
				if type(wards) ~= "table" then wards = {wards} end
				local pos = NotLib.object.filter(wards,{one=true,range=600})
				if pos ~= nil and #NotLib.object("ward",{"dist",{pos,1600},"dead",false,"visible",true,"team",myHero.team}) == 0 then 
					if unit.data.overWall(pos,500,true) == false then CastSpell(slot,pos.x,pos.z) end
					return true
				end
			end
			return false
		end
		if unit.isMe == false then return end -- myHero upgrade
		unit.data.wasAtSpawn = true
		unit.data.simpleRangedTarget = function() return NotLib.object("player",{leastHealth=true,targetable=true,dead=false,visible=true,atackable=myHero,range=myHero.range}) end
		unit.data.simpleMeleeTarget = function() return NotLib.object("player",{closest=true,targetable=true,dead=false,visible=true,atackable=myHero,range=500}) end
		unit.data.level = function(list)
			local lev,req,name = {},{},unit.charName
			for i=_Q,_R,(_W-_Q) do req[i],lev[i] = 0,unit:GetSpellData(i).level end
			if name == "Elise" or name == "Karma" or name == "Jayce" or name == "Nidalee" or name == "Gnar" then lev[_R] = lev[_R]-1 end
			for i=1,#list do
				req[list[i] ] = req[list[i] ]+1
				if req[list[i] ] > lev[list[i] ] then LevelSpell(list[i]) return end
			end
		end
		unit.data.overWall = function(pos,range,dash)
			if unit:GetDistance(pos) < range then return false end
			range = range-unit.boundingRadius-20
			local rad = math.rad2d(pos,unit)
			local wallStart,passDist = math.pass2d(pos,rad,range,true)
			if wallStart == nil then return false end
			local wallEnd,wallDist = math.pass2d(wallStart,rad,range,false)
			if wallEnd == nil or (dash == true and wallDist+passDist > range) then return false end
			if unit:GetDistance(wallEnd) < unit.boundingBox+20 then return false end
			if unit.isMe == true then unit:MoveTo(wallEnd.x,wallEnd.z) end
			return true
		end
		-- item number - shop visit - price - id - parent items
		-- buylist[1] = {1,325,1039,3106,3154,3160}
		unit.data.buyList = {}
		unit.data.buyListRefresh = function()
			local i=1
			while i <= #unit.data.buyList do
				local bought = nil
				for x=3,#unit.data.buyList[i] do bought = bought or IsItemPurchasable(unit.data.buyList[i][x]) == false or unit.data.item(unit.data.buyList[i][x]) ~= nil end
				if bought ~= nil and bought ~= false then table.remove(unit.data.buyList,i) else i = i+1 end
			end
		end
		unit.data.buyListPrice = function()
			unit.data.buyListRefresh()
			local price = 0
			if unit.data.buyList[1] ~= nil then 
				local visit = unit.data.buyList[1][1] 
				for i=1,#unit.data.buyList do if visit == unit.data.buyList[i][1] then price = price+unit.data.buyList[i][2] end end
			end
			return price
		end
		unit.data.buyListWait = function() unit.data.buyListRefresh() return unit.data.buyList[1] == nil or myHero.gold < unit.data.buyList[1][2] end
		unit.data.buyListEnable = function()
			NotLib.timer.buyListEnable.callback = function() if unit.data.nearShop() then unit.data.wasAtSpawn = true if not unit.data.buyListWait() then BuyItem(unit.data.buyList[1][3]) end end end
			NotLib.timer.buyListEnable.cooldown = GetLatency()/200
			NotLib.timer.buyListEnable.start()
		end
	end
	-- collection
	for i=0,objManager.maxObjects do local unit = objManager:getObject(i) if unit and unit.valid then NotLib.object.upgrade(unit) NotLib.object[unit.data.class][unit.hash] = unit end end
	AddCreateObjCallback(function(unit) NotLib.object.upgrade(unit) NotLib.object[unit.data.class][unit.hash] = unit end)
	AddDeleteObjCallback(function(unit) if unit.data then NotLib.object[unit.data.class][unit.hash] = nil end end)
	-- spawns
	NotLib.object.allySpawn,NotLib.object.allyShop = NotLib.object("spawn",{"team",myHero.team})[1],NotLib.object("shop",{"team",myHero.team})[1]
	NotLib.object.enemySpawn,NotLib.object.enemyShop = NotLib.object("spawn",{"!team",myHero.team})[1],NotLib.object("shop",{"!team",myHero.team})[1]
end
do -- sugar (everything theoretic)
	NotLib.sugar = {}
	-- creepSpawn skillCheck
	for k,creepSpawn in pairs(NotLib.object.creepSpawn) do
		if creepSpawn.data.type == "golem" then 
			if creepSpawn.data.side() == TEAM_BLUE then creepSpawn.data.skillCheck = VEC(8150,3125) else creepSpawn.data.skillCheck = VEC(6750,11740) end
		elseif creepSpawn.data.type == "blue" then
			if creepSpawn.data.side() == TEAM_BLUE then creepSpawn.data.skillCheck = VEC(4500,7550) else creepSpawn.data.skillCheck = VEC(10550,7450) end
		elseif creepSpawn.data.type == "wight" then
			if creepSpawn.data.side() == TEAM_BLUE then creepSpawn.data.skillCheck = VEC(1820,8000) else creepSpawn.data.skillCheck = VEC(13050,6850) end
		end
	end
	-- creepSpawn names
	NotLib.sugar.creepSpawn = function()
		local result = {}
		for k,creepSpawn in pairs(NotLib.object.creepSpawn) do
			if creepSpawn.data.side() == myHero.team and not result["o"..creepSpawn.data.type] then result["o"..creepSpawn.data.type] = creepSpawn 
			elseif creepSpawn.data.side() ~= TEAM_NEUTRAL and not result["e"..creepSpawn.data.type] then result["e"..creepSpawn.data.type] = creepSpawn
			elseif not result[creepSpawn.data.type] then result[creepSpawn.data.type] = creepSpawn 
			else result[creepSpawn.hash] = creepSpawn end
		end
		return result
	end
	NotLib.object.creepSpawn = NotLib.sugar.creepSpawn()
	-- farming creepSpawn
	NotLib.sugar.farmCreepSpawn = function(tp,fast)
		local result,resultScore = nil,math.huge
		for k,creepSpawn in pairs(NotLib.object("creepSpawn",{"side",myHero.team})) do
			local score,get,dist = 0,creepSpawn.data.get()*myHero.ms,myHero:GetDistance(creepSpawn)
			if dist > get then score = dist elseif creepSpawn.data.dead <= 300 or creepSpawn.data.type == "red" or creepSpawn.data.type == "blue" then score = get else score = dist+(get-dist)*1.4 end
			if creepSpawn.data.started() then if creepSpawn.data.respawn > 200 then score = score-3300 else score = score-2000 end
			elseif NotLib.game == "classic" then
				if myHero.level == 1 then if (not fast and creepSpawn.data.type == "golem") or (fast and creepSpawn.data.type == "wight") then score = score-3300 end
				elseif (fast and myHero.level >= 3) then 
					if (creepSpawn.data.type == "wolf" and (NotLib.object.creepSpawn.oblue.data.get() < 3200/myHero.ms or NotLib.object.creepSpawn.owight.data.get() < 3200/myHero.ms)
					or (creepSpawn.data.type == "wraith" and (NotLib.object.creepSpawn.ored.data.get() < 3200/myHero.ms or NotLib.object.creepSpawn.ogolem.data.get() < 3200/myHero.ms))) then score = score+3300 end 
				end
			end
			if score < resultScore then result,resultScore = creepSpawn,score end
		end
		return result
	end
	-- copy spell
	NotLib.sugar.copySpell = function(spell)
		local result = {name=spell.name:lower(),tick=GetTickCount()/1000,windUpTime=spell.windUpTime,animationTime=spell.animationTime}
		if spell.target ~= nil then result.target = spell.target end
		if spell.startPos ~= nil then result.startPos = VEC(spell.startPos.x,spell.startPos.z) end
		if spell.endPos ~= nil then result.endPos = VEC(spell.endPos.x,spell.endPos.z) end
		result.windUp = function() return result.tick+result.windUpTime-GetLatency()/1000/2 >= GetTickCount()/1000 end
		result.animation = function() return result.tick+result.animationTime-GetLatency()/1000 >= GetTickCount()/1000 end
		result.canAttack = function(target) return result.animation() == false end
		result.canMove = function(target) return result.windUp() == false end
		return result
	end
	-- free user
	NotLib.sugar.IAMFREE = function() _G.CLoLPacket,_G.Packet,_G.VIP_USER = nil,nil,false end
	-- pos
	local top = {classic={VEC(2200,12550),VEC(1150,2400),VEC(1260,10250),VEC(12500,13700),VEC(4000,13650)},tt={VEC(2121,9000),VEC(13285,9000)}}
	NotLib.sugar.isTop = function(pos)
		return (NotLib.game ==  "classic" and (pos:GetDistance(top.classic[1]) <= 1100 or pos:GetDistance(math.proj2d(pos,top.classic[2],top.classic[3])) <= 850 
		or pos:GetDistance(math.proj2d(pos,top.classic[4],top.classic[5])) <= 850)) or (NotLib.game ==  "tt" and pos:GetDistance(math.proj2d(pos,top.tt[1],top.tt[2])) <= 1300)
	end
	local mid = {classic={VEC(1375,1550),VEC(13400,13450)},tt=VEC(7700,6700),dom=VEC(6900,6460)}
	NotLib.sugar.isMid = function(pos)
		return (NotLib.game ==  "classic" and pos:GetDistance(math.proj2d(pos,mid.classic[1],mid.classic[2])) <= 850) or (NotLib.game == "tt" and pos:GetDistance(mid.tt) <= 1100)
		or (NotLib.game ==  "dom" and pos:GetDistance(mid.dom) <= 1100) or NotLib.game ==  "pg"
	end
	local bot = {classic={VEC(12600,2400),VEC(2340,1300),VEC(10800,1300),VEC(13680,12650),VEC(13550,4450)},tt={VEC(2121,5600),VEC(13285,5600)}}
	NotLib.sugar.isBot = function(pos)
		return (NotLib.game == "classic" and (pos:GetDistance(bot.classic[1]) <= 1100 or pos:GetDistance(math.proj2d(pos,bot.classic[2],bot.classic[3])) <= 850 
		or pos:GetDistance(math.proj2d(pos,bot.classic[4],bot.classic[5])) <= 850)) or (NotLib.game ==  "tt" and pos:GetDistance(math.proj2d(pos,bot.tt[1],bot.tt[2])) <= 950)
	end
	-- push power [float towerDist,float towerMaxDist,string situation]
	NotLib.sugar.pushPower = function(lane)
		--floats
		local allyTower = NotLib.object("tower",{"dead",false,"team",myHero.team,lane,true},"dist",NotLib.object.enemySpawn)
		if not allyTower then return 0,1,"" end
		local enemyTower = NotLib.object("tower",{"dead",false,"team",TEAM_ENEMY,lane,true},"dist",NotLib.object.allySpawn)
		if not enemyTower then return 0,1,"" end
		local enemyMinion = NotLib.object("minion",{"dead",false,"team",TEAM_ENEMY,lane,true},"dist",NotLib.object.allySpawn)
		if not enemyMinion then return 0,1,"" end
		local dist,maxDist = math.floor(enemyTower:GetDistance(enemyMinion)+0.5),math.floor(enemyTower:GetDistance(allyTower)+0.5)
		dist = math.max(0,math.min(maxDist,dist))
		-- players
		local players = NotLib.object("player",{lane,true,"dist",{allyTower,maxDist+775*2}})
		if #players == 0 then return dist,maxDist,"" end
		-- enemy tower dive
		local situation = ""
		if dist < 775*2 then
			local ally = NotLib.reduce(NotLib.map(players,{"assist",myHero,"!healthPct",0.5,"dist",{allyTower,775*2}}),"dist",enemyTower)
			if ally and #NotLib.map(players,{"attack",myHero,"dist",{ally,775*2}}) > 0 then enemyPos = "enemy can tower dive; " end
		-- ally tower dive
		elseif maxDist-dist < 775*2 then
			local enemy = NotLib.reduce(NotLib.map(players,{"attack",myHero,"!healthPct",0.5,"dist",{enemyTower,775*2}}),"dist",allyTower)
			if enemy and #NotLib.map(players,{"assist",myHero,"dist",{enemy,775*2}}) > 0 then enemyPos = "ally can tower dive; " end
		end
		-- flash
		for k,enemy in pairs(NotLib.map(players,{"attack",myHero})) do if enemy.data.flash and enemy:CanUseSpell(enemy.data.flash) ~= READY then situation = situation..enemy.charName.." noflash; " end end
		-- finish
		return dist,maxDist,situation
	end
end