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
		height = 600, -- height of the whole frame
		width = 250,  -- width of the whole frame
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
			color = {r = .78, g =.66 , b = .11, a = 1},
		},
    questTitleHighlight = {
      family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
      size = 12,
      flag = "OUTLINE",
      color = {r = 1, g =.89 , b = .41, a = 1},
    },
		objectives = {
			family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
			size = 12,
			flag = "OUTLINE",
			color = {r = .8, g =.8 , b = .8, a = 1},
		},
    objectivesHighlight = {
      family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
      size = 12,
      flag = "OUTLINE",
      color = {r = 1, g =1 , b = 1, a = 1},
    },
    objectivesCompleted = {
      family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
      size = 12,
      flag = "OUTLINE",
      color = {r = .27, g =.62 , b = 0, a = 1},
    },
    objectivesCompletedHighlight = {
      family = [[Interface\AddOns\Exgistr\Media\font.ttf]],
      size = 12,
      flag = "OUTLINE",
      color = {r = .45, g =.85 , b = 0.16, a = 1},
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