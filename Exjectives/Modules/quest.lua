local AddonName, E = ...
local moduleName = "Quests"
local prio = 10
local f

local questObjects = {}
local function Enable()
  f = E.InitModule(moduleName)
  f.prio = prio
  f.children = {}
  f:SetHeight(200)
  TEST = f
end
E.AddModule(moduleName,Enable)

local function GetNeededHeight(objectiveCount)
  local fonts = E.db.config.font
  local height = 0
  local factor = 1.52
  height = fonts.questTitle.size * factor + height
  height = fonts.objectives.size * factor * objectiveCount + height
  return height
end

local function SetModuleHeight()
  local height = 35
  for _,frame in ipairs(questObjects) do
    height = height + frame:GetHeight()
  end
  f:SetHeight(height)
end

local function AnchorQuest(frame)
  if #questObjects < 1 then
    frame:SetPoint("TOPLEFT",f.title,"BOTTOMLEFT",5,-2)
  else
    frame:SetPoint("TOPLEFT",questObjects[#questObjects],"BOTTOMLEFT",0,-2)
  end
end

local function DrawQuests(questData)
  --[[
    local container = E.GetQuestContainer(f)
      container.title:SetText(title)
      container.children = {}
      container:SetSize(220, 20)
      local lastObject = f.children[#f.children] or f.title
      container:SetPoint("TOPLEFT",lastObject,"BOTTOMLEFT",0,-2)
      tinsert(f.children,container)
      lastContainer = container

       local quest = E.GetQuestObject(parent,questInfo)
       quest:SetWidth(220)
       quest:SetHeight(GetNeededHeight(numObjectives))
       local lastObject = parent.children[#parent.children] or parent.title
       quest:SetPoint("TOPLEFT",lastObject,"BOTTOMLEFT",0,-2)
       parent.height = parent.height or 20
       parent.height = parent.height + GetNeededHeight(numObjectives)
       parent:SetHeight(parent.height)
       tinsert(parent.children,quest)
  ]]
  ViragDevTool_AddData(questData)
  if questData[0] then
    for _,questInfo in ipairs(questData[0].quests) do
      print('adding',questInfo.title)
      local questObj = E.GetQuestObject(f,questInfo)
      --questObj:SetPoint("TOPRIGHT")
      f:AddChildren(questObj)
      f:SetCalculateHeight()
    end
  end
  for i,header in ipairs(questData) do
    if header.questCount > 0 then
      print('adding header',header.title)
      local containerObj = E.GetQuestContainer(f)
      containerObj.title:SetText(header.title)
      --containerObj:SetCalculateHeight()
      f:AddChildren(containerObj)
      for _,questInfo in ipairs(header.quests) do
        local questObj = E.GetQuestObject(containerObj,questInfo)
        containerObj:AddChildren(questObj)
        --parent:SetCalculateHeight()
      end
      containerObj:SetCalculateHeight()
    end
  end
  f:SetCalculateHeight()
end


local function EnteredWorld()
  local questData = {
    [0] = {
      questCount = 0,
      quests = {}
    },
  }
  local numEntries, numQuests = GetNumQuestLogEntries()
  local lastHeader
  local index = 1
  for questLogIndex = 1, numEntries do
    local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling = GetQuestLogTitle(questLogIndex);
    if isHeader then
      lastHeader = index
      questData[index] = {
        title = title,
        quests = {},
        questCount = 0,
      }
      index = index + 1
    elseif not isBounty or not isHidden then
      local header = lastHeader or 0
      local numObjectives = GetNumQuestLeaderBoards(questLogIndex)
      local questInfo = {title = title, objectives = {}, questId = questID}
      for objectiveIndex = 1, numObjectives do
        local text, objectiveType, finished = GetQuestLogLeaderBoard(objectiveIndex, questLogIndex)
        tinsert(questInfo.objectives,{text = text,objectIndx = objectiveIndex, completed = finished})
      end
      tinsert(questData[header].quests,questInfo)
      questData[header].questCount = questData[header].questCount + 1
    end
  end
  DrawQuests(questData)
end
E.RegisterEvent("PLAYER_ENTERING_WORLD",EnteredWorld)