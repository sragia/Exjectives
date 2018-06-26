local AddonName, E = ...
ExjectivesDB = {} -- Init SavedVars
-- debug
E.debug = {
	enabled = false,
	label = "|cffeef441[Exjectives]|r",
	print = function(...)
		if E.debug.enabled then
			print(E.debug.label,...)
		end
	end,
}
E.db = {}
E.db.config = {
	container = {
		height = 1000, -- height of the whole frame
		width = 300,  -- width of the whole frame
		backdrop = {
			bgFile   = [[Interface\Buttons\WHITE8X8]],
			edgeFile = [[Interface\Buttons\WHITE8X8]],
			edgeSize = 1,
		},
		backdropColor = { r = 0, g = 0, b = 0, a = .3},
		backdropBorderColor = { r = 0, g = 0, b = 0, a = .7},
	},
	font = {
		header = {
			family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
			size = 12,
			flag = "OUTLINE",
			color = {r = 1, g =1 , b = 1, a = 1},
		},
		module = {
			family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
			size = 12,
			flag = "OUTLINE",
			color = {r = 1, g =1 , b = 1, a = 1},
		},
		questTitle = {
			family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
			size = 12,
			flag = "OUTLINE",
			color = {r = 1, g =.74 , b = .13, a = 1},
		},
		objectives = {
			family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
			size = 12,
			flag = "OUTLINE",
			color = {r = 1, g =1 , b = 1, a = 1},
		},
    questContainer = {
      family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
      size = 12,
      flag = "OUTLINE",
      color = {r = 1, g =1 , b = 1, a = 1},
    },
		-- DEFAULT -- 
		default = {
			family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
			size = 12,
			flag = "OUTLINE",
			color = {r = 1, g =1 , b = 1, a = 1},
		},
	},
	colors = {

	},
}