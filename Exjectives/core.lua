local AddonName, E = ...
local tinsert, ipairs = tinsert, ipairs
local config = E.db.config

local function spairs(t, order)
  -- collect the keys
  local keys = {}
  for k in pairs(t) do keys[#keys + 1] = k end

  -- if order function given, sort by it by passing the table and keys a, b,
  -- otherwise just sort the keys
  if order then
    table.sort(keys, function(a, b) return order(t, a, b) end)
  else
    table.sort(keys)
  end

  -- return the iterator function
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end
end
-- THE PLAN
-- Modules are for quest/dungeons/timers/etc
-- Core controls the frame while modules add

-- FUNCTIONS
-- E.Add(frame) - Adds frame
-- E.Show(frame,prio) - Shows module
	-- So Add -> Show when needed providing the name
	-- OR just Show when needed providing frame and prio
	-- Show has some Animations. Add it to args like let module to decide?
-- E.RegisterEvents(event,function)

-- LOCAL FUNCTIONS
-- Redraw() - redraws frame

-- Goal:
-- NO FUCKING HARDCODE
-- So setting/config everywhere

-- Container
local container = CreateFrame("Frame", "Exjectives_Container", UIParent)
container:SetClipsChildren(true)
container.collapsed = false
container.animPlaying = false
container.modules = {}
local header = CreateFrame("Frame","Exjectives_Header",UIParent)

local function InitContainer()
	local settings = config.container
	-- Header 
	header:SetSize(settings.width, 20)
	header:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -300, -10)
	--Container
	container:SetSize(settings.width, settings.height)
	E.ApplyBackdropStyle(container,settings)
	container:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, -5)
	-- Animations 
	container.animExpand = E.CreateFadeAnimation(container,0,1,.2,"IN")
	container.animExpand:SetScript("OnFinished",function(self) 
		container:SetAlpha(1) 
		container.animPlaying = false
	end)
	container.animCollapse = E.CreateFadeAnimation(container,1,0,.2,"OUT")
	container.animCollapse:SetScript("OnFinished",function(self) 
		container:Hide() 
		container.animPlaying = false
	end)
	-- Header Contents
	-- Button
	local headerBtn = CreateFrame("Button", nil, header)
	header.btn = headerBtn
	headerBtn:SetSize(15, 15)
	local btnTex = E.CreateTexture(headerBtn,[[Interface\AddOns\Exjectives\Media\collapse.tga]])
	headerBtn.tex = btnTex
	btnTex:SetAllPoints()
	local highlightTex =  E.CreateTexture(headerBtn,[[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
	highlightTex:SetAllPoints()
	headerBtn:SetHighlightTexture(highlightTex,"ADD")
	headerBtn:SetPoint("TOPRIGHT",header,-2,-2)
	headerBtn:SetScript("OnClick",function(self) 
		if container.collapsed then
			E.ExpandContainer()
		else
			E.CollapseContainer()
		end
	end)
	-- Text
	local fs = header:CreateFontString(nil, "OVERLAY")
	header.label = fs
	E.SetFont(fs,"header")
	fs:SetText("Exjectives")
	fs:SetPoint("RIGHT", headerBtn, "LEFT", -5, 0)
end

-- Events
local registeredEvents = {}
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGOUT")

f:SetScript("OnEvent", function(self,event,...)
		if event == "ADDON_LOADED" and AddonName == ... then
			E.Initialize()
			f:UnregisterEvent("ADDON_LOADED")
		elseif event == "PLAYER_LOGOUT" then
		--	ExjectivesDB = E.db -- disabled until config is made
		end
		if registeredEvents[event] then
			for _,func in ipairs(registeredEvents[event]) do
				func(event,...)
			end
		end
	end)

function E.RegisterEvent(event,func)
	if registeredEvents[event] then
		tinsert(registeredEvents[event],func)
	else
		registeredEvents[event] = {}
		tinsert(registeredEvents[event],func)
		xpcall(f.RegisterEvent,function() return true end,f,event) -- just in case of fake events
	end
end

-- Modules
local modules = {}
local function EnableModules()
	for name,func in pairs(modules) do
		func()
	end
end

function E.ReDrawModules()
	for _,frame in spairs(container.modules or {},function(t,a,b) return t[a].prio > t[b].prio end) do
		frame:ClearAllPoints()
	end
	local first = false
	local lastFrame
	for name,frame in spairs(container.modules or {},function(t,a,b) return t[a].prio < t[b].prio end) do
		if not first then
			first = true
			frame:SetPoint("TOPLEFT",container,5,-5)
			frame:SetPoint("TOPRIGHT", container,-5, -5)
			lastFrame = name
		else
			frame:SetPoint("TOPLEFT",container.modules[lastFrame],0,-5)
			frame:SetPoint("TOPRIGHT", container.modules[lastFrame],0, -5)
			lastFrame = name
		end
	end
end

function E.AddModule(name,func)
	modules[name] = func
end

function E.InitModule(name)
	--[[local f = CreateFrame("Frame",nil,container)
	f:SetFrameLevel(container:GetFrameLevel()+1)
	E.ApplyBackdropStyle(f)
  f.children = {}
  f.height = 10
	local fs = f:CreateFontString(nil,"OVERLAY")
	E.SetFont(fs,"module")
	fs:SetText(name)
	fs:SetPoint("TOPLEFT", f, 5, -5)
	f.title = fs
  --tinsert(f.children,fs)
  -- functions --
  function f:AddChildren(frame)
    -- f = frame (QuestObject)
    local lastChildren = self.children[#self.children] or self.title
    tinsert(self.children,frame)
    print(lastChildren,'lastChild')
    frame:SetPoint("TOPLEFT", lastChildren, "BOTTOMLEFT", 0, -2)
    print('setPoint Module')
  end
  function f:SetCalculateHeight()
    self.height = 20
    for _,frame in ipairs(self.children) do
      self.height = self.height + frame:GetHeight()
    end  
    self:SetSize(self:GetParent():GetWidth()-10,self.height) 
  end]]
  local f = E.GetQuestContainer(container)
  f.title:SetText(name)
	container.modules[name] = f
	return f
end

function E.RequestRefresh(moduleName)

end


-- Container Control
function E.CollapseContainer()
	if not container.animPlaying then
		container.collapsed = true
		container.animPlaying = true
		container.animCollapse:Play()
		header.btn.tex:SetTexture([[Interface\AddOns\Exjectives\Media\expand.tga]])
	end
end
function E.ExpandContainer()
	if not container.animPlaying then
		container.animPlaying = true
		container.collapsed = false
		container:SetAlpha(0)
		container:Show()
		container.animExpand:Play()
		header.btn.tex:SetTexture([[Interface\AddOns\Exjectives\Media\collapse.tga]])
	end
end

-- Initialize
function tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

function E.Initialize()
	E.db = tableMerge(E.db,ExjectivesDB)
	config = E.db.config
	InitContainer() -- Setup container
	EnableModules()
	E.ReDrawModules()
end