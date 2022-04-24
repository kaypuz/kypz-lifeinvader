-- Place into qb-core/shared/item.lua
```
-- Lifeinvader Jobs
	["lifehtml"] 			 		 	    = {["name"] = "lifehtml", 							["label"] = "lifehtml",                      ["weight"] = 1000,       ["type"] = "item",      ["image"] = "lifehtml.png",                 ["unique"] = false,     ["useable"] = true,     ["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "lifepaket."},
	["lifecss"] 			 		 	  	= {["name"] = "lifecss", 							  ["label"] = "lifecss",                       ["weight"] = 1000,       ["type"] = "item",      ["image"] = "lifecss.png",                  ["unique"] = false,     ["useable"] = true,     ["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "lifepaket."},
	["lifejava"] 			 		 	    = {["name"] = "lifejava", 							["label"] = "lifejava",                      ["weight"] = 1000,       ["type"] = "item",      ["image"] = "lifejava.png",                 ["unique"] = false,     ["useable"] = true,     ["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "lifepaket."},
	["lifeyazilim"] 			 		 	= {["name"] = "lifeyazilim", 	          ["label"] = "lifeyazilim",                   ["weight"] = 1000,       ["type"] = "item",      ["image"] = "lifeyazilim.png",              ["unique"] = false,     ["useable"] = true,     ["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "lifepaket."},
	["lifepaket"] 			 		 	  = {["name"] = "lifepaket", 						  ["label"] = "lifepaket",                     ["weight"] = 1000,       ["type"] = "item",      ["image"] = "lifepaket.png",                ["unique"] = false,     ["useable"] = true,     ["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "lifepaket."},
 ```
 Place into qb-core/shared/jobs.lua
 ```
    ['lifeinvader'] = {
		label = 'Lifeinvader',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Çalısan',
                payment = 0
            },
			['1'] = {
                name = 'Patron',
                payment = 0,
                isboss = true
            },
        },
	},
  
 ```
