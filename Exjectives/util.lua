local AddonName, E = ...

function E.ApplyBackdropStyle(frame,settings)
	local backdrop = settings and settings.backdrop or {
			bgFile   = [[Interface\Buttons\WHITE8X8]],
			edgeFile = [[Interface\Buttons\WHITE8X8]],
			edgeSize = 1,
		}
	local color = settings and settings.backdropColor or { r = 0, g = 0, b = 0, a = .3}
	local borderColor = settings and settings.backdropBorderColor or { r = 0, g = 0, b = 0, a = .7}
	frame:SetBackdrop(backdrop)
	frame:SetBackdropColor(color.r, color.g, color.b, color.a)
	frame:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a)
end

function E.SetFont(fontString,style)
	local settings = E.db.config.font[style] or E.db.config.font.default
	fontString:SetFont(settings.family,settings.size,settings.flag)
	fontString:SetTextColor(settings.color.r, settings.color.g, settings.color.b, settings.color.a)
end

function E.CreateTexture(parent,texture)
	local tex = parent:CreateTexture(nil, 'ARTWORK');
	if texture then 
		tex:SetTexture(texture)
	end
  tex:SetAllPoints()
	return tex;
end

function E.CreateFadeAnimation(frame,aFrom,aTo,duration,smoothing)
	local animGrp = frame:CreateAnimationGroup()
	local anim = animGrp:CreateAnimation("Alpha")
	anim:SetFromAlpha(aFrom)
	anim:SetToAlpha(aTo)
	anim:SetDuration(duration)
	anim:SetSmoothing(smoothing)
	return animGrp
end

-- QUEST OBJECT --
local questObjects = {}

local function CreateQuestObjectFrame()
  local questFrame = CreateFrame("Frame")
  questFrame.free = true
  -- TEST --
  E.ApplyBackdropStyle(questFrame,{
    height = 500, -- height of the whole frame
    width = 250,  -- width of the whole frame
    backdrop = {
      bgFile   = [[Interface\Buttons\WHITE8X8]],
      edgeFile = [[Interface\Buttons\WHITE8X8]],
      edgeSize = 1,
    },
    backdropColor = { r = 1, g = 0, b = 0, a = .3},
    backdropBorderColor = { r = 1, g = 0, b = 0, a = .7},
  })
  -- TEST --
  tinsert(questObjects,questFrame)
  -- Quest Title --
  local questTitle = questFrame:CreateFontString(nil, "OVERLAY")
  questFrame.title = questTitle
  E.SetFont(questTitle,"questTitle")
  questTitle:SetPoint("TOPLEFT", questFrame,5,-5)
  -- Quest Objectives --
  questFrame.objectiveFrames = {}
  questFrame.activeFrames = {}
  function questFrame:CreateObjective()
    local objectiveContainer = CreateFrame("Frame","ObjectiveFrame"..math.random(),self)
    objectiveContainer.free = true
    tinsert(questFrame.objectiveFrames,objectiveContainer)
    -- TEST --
    E.ApplyBackdropStyle(objectiveContainer,{
    height = 500, -- height of the whole frame
    width = 250,  -- width of the whole frame
    backdrop = {
      bgFile   = [[Interface\Buttons\WHITE8X8]],
      edgeFile = [[Interface\Buttons\WHITE8X8]],
      edgeSize = 1,
    },
    backdropColor = { r = 1, g = 1, b = 0, a = .3},
    backdropBorderColor = { r = 1, g = 1, b = 0, a = .7},
    })
    -- TEST --
    -- Objective Text --
    local objective = objectiveContainer:CreateFontString(nil, "OVERLAY")
    objectiveContainer.text = objective
    E.SetFont(objective,"objectives")
    objective:SetWidth(0)
    objective:SetPoint("LEFT",objectiveContainer,5,0)
    -- Completed Icon --
    local completedIcon = CreateFrame("Frame",nil,self)
    completedIcon:SetSize(16, 16)
    objectiveContainer.completed = completedIcon
    local completedTex = E.CreateTexture(completedIcon,[[Interface\RAIDFRAME\ReadyCheck-Ready.PNG]])
    completedTex:SetAllPoints()
    completedIcon.texture = completedTex
    completedIcon:SetPoint("RIGHT", objective, "LEFT", -2, 0)
    completedIcon:Hide()
    function objectiveContainer:SetText(...)
      self.text:SetText(...)
    end
    return objectiveContainer
  end
  function questFrame:GetObjective()
    for _,frame in ipairs(self.objectiveFrames) do
      if frame.free then 
        frame.free = false
        return frame
      end
    end
    return self:CreateObjective()
  end
  function questFrame:SetObjective(data)
  -- {text = "",objectIndx = 0, completed = bool, progress = { current = 0, max = 0}, hasProgress = bool}
    local frame = self:GetObjective()
    frame.free = false
    frame.objectIndx = data.objectIndx
    if #self.activeFrames <= 0 then 
      -- first
      frame:SetPoint("TOPLEFT", self.title, "BOTTOMLEFT", 10, -5)
    else
      frame:SetPoint("TOPLEFT", self.activeFrames[#self.activeFrames], "BOTTOMLEFT", 0, -5)
    end
    frame:SetText(data.text)
    if data.completed then
      frame.completed:Show()
    else
      frame.completed:Hide()
    end
    tinsert(self.activeFrames,frame)
    return frame
  end
  function questFrame:RefreshObjective(data)
    local frame
    for _,oframe in ipairs(self.activeFrames) do
      if oframe.objectIndx == data.objectIndx then
        frame = oframe
      end
    end
    if not frame then
      frame = self:SetObjective(data)
    else
      frame:SetText(data.text)
      if data.completed then
        frame.completed:Show()
      else
        frame.completed:Hide()
      end
    end
    -- Setup Size
    local width,height = frame.text:GetSize()
    width = width + 18
    frame:SetSize(width,height)
  end
  function questFrame:ClearData()
    self.data = nil
    -- TODO
  end
  function questFrame:Refresh()
    local data = self.data
    local height = 0
    self.title:SetText(data.title)
    height = self.title:GetHeight() + 5 
    for _,obj in ipairs(data.objectives) do
      self:RefreshObjective(obj)
    end
    for _,oframe in ipairs(self.activeFrames) do
      height = height + oframe:GetHeight() + 5
    end
    self.height = height
    self:SetSize(self:GetParent():GetWidth()-10, self.height+10)
  end
  -- 
  return questFrame
end

local function GetQuestObjectFrame()
  for _,f in ipairs(questObjects) do
    if f.free then
      f.free = false
      return f
    end
  end
  local frame = CreateQuestObjectFrame()
  frame.free = false
  return frame
end


function E.GetQuestObject(parent,data)
  --[[ data = {
      title = "",
      objectives = {
        {text = "",questId = 0, completed = bool, progress = { current = 0, max = 0}, hasProgress = bool}
      }
    }
  ]]
  local f = GetQuestObjectFrame()
  f:SetParent(parent)
  f.data = data
  f:Refresh()
  return f
end


-- QUEST CONTAINER -- 
local questContainer = {}
local function CreateQuestContainer()
  local f = CreateFrame("Frame")
  f:SetClipsChildren(true)
  f.free = true
  f.height = 20
  f.children = {}
  E.ApplyBackdropStyle(f)
  tinsert(questContainer,f)
  -- hacky, tbd if works
  function f:Collapse()
    self:SetHeight(20)
    local parent = self:GetParent()
    if parent.SetCalculateHeight then
      self:GetParent():SetCalculateHeight()
    end
  end
  function f:Expand(height)
    self:SetHeight(height)
    local parent = self:GetParent()
    if parent.SetCalculateHeight then
      self:GetParent():SetCalculateHeight()
    end
  end
  -- Button
  local btn = CreateFrame("Button",nil,f)
  f.btn = btn
  btn.collapsed = false
  btn:SetSize(10,10)
  local btnTex = E.CreateTexture(btn,[[Interface\AddOns\Exjectives\Media\collapse.tga]])
  btnTex:SetAllPoints()
  btn:SetPoint("TOPLEFT", f, 0, -5)
  btn:SetScript("OnClick",function(self)
    if self.collapsed then
      f:Expand(f.height)
      self.collapsed = false
    else
      f:Collapse()
      self.collapsed = true
    end
  end)
  -- Text
  local fs = f:CreateFontString(nil, "OVERLAY")
  f.title = fs
  E.SetFont(fs,"questContainer")
  fs:SetText("container")
  fs:SetPoint("LEFT",btn,"RIGHT",3,0)
  -- FUNCTION --
  function f:AddChildren(frame)
    local lastChildren = self.children[#self.children] or self.btn
    tinsert(self.children,frame)
    frame:SetPoint("TOPLEFT", lastChildren, "BOTTOMLEFT", 0, -2)
  end
  function f:Clear()
    for i=#self.children, 1 do
      self.children[i]:ClearAllPoints()
    end
    self.children = {}
    self.title:SetText("")
    self.height = 10
    self.btn.collapsed = false
  end
  function f:SetCalculateHeight()
    self.height = 20
    for _,frame in ipairs(self.children) do
      self.height = self.height + frame:GetHeight()
    end  
    self:SetSize(self:GetParent():GetWidth()-10,self.height) 
  end
  return f
end

local function GetQuestContainer()
  for _,f in ipairs(questContainer) do
    if f.free then
      f.free = false
      return f
    end
  end
  local frame = CreateQuestContainer()
  frame.free = false
  return frame
end

function E.GetQuestContainer(parent)
  local f = GetQuestContainer()
  f:SetParent(parent)
  f:SetWidth(parent:GetWidth()-10)
  return f
end
