local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "🥷DollShot🥷 || Defusal FPS💣✂️", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

OrionLib:MakeNotification({
 Name = "Set Up..",
 Content = "the cheat has been successfully launched, the creator of the cheat is DollManB",
 Image = "rbxassetid://10956284646",
 Time = 10
})

local espTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://120129574453255",
    PremiumOnly = false
})
local AimTab = Window:MakeTab({
    Name = "Aim",
    Icon = "rbxassetid://11162755592",
    PremiumOnly = false
})
local RageTab = Window:MakeTab({
    Name = "Rage",
    Icon = "rbxassetid://13288149634",
    PremiumOnly = false
})
local SkinsTab = Window:MakeTab({
    Name = "Skins",
    Icon = "rbxassetid://11127408662",
    PremiumOnly = false
})
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://92905124685036",
    PremiumOnly = false
})

--Dannie

local plr = game:GetService("Players")
local l_plr = plr.LocalPlayer

--UI

espTab:AddToggle({
	Name = "ESP Box",
	Default = false,
	Callback = function(Value)
		
	end    
})
espTab:AddColorpicker({
	Name = "ESP Color",
	Default = Color3.fromRGB(255, 0, 0),
	Callback = function(Value)
		
	end	  
})
espTab:AddToggle({
	Name = "ESP Filled",
	Default = false,
	Callback = function(Value)
		
	end    
})
espTab:AddToggle({
	Name = "Gun ESP",
	Default = false,
	Callback = function(Value)
		
	end    
})
espTab:AddToggle({
	Name = "Wall Hack",
	Default = false,
	Callback = function(Value)
		
	end    
})
espTab:AddToggle({
	Name = "Health Bar",
	Default = false,
	Callback = function(Value)
		
	end    
})
AimTab:AddToggle({
	Name = "Aim Bot(RMB)",
	Default = false,
	Callback = function(Value)
		
	end    
})
AimTab:AddToggle({
	Name = "Silent Aim",
	Default = false,
	Callback = function(Value)
		
	end    
})
AimTab:AddToggle({
	Name = "Aim Fov",
	Default = false,
	Callback = function(Value)
		
	end    
})
AimTab:AddSlider({
	Name = "Aim Fov Size",
	Min = 5,
	Max = 1000,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "aimfov",
	Callback = function(Value)
		
	end    
})

RageTab:AddToggle({
	Name = "WallBang",
	Default = false,
	Callback = function(Value)
		
	end    
})

RageTab:AddBind({
	Name = "Fly Up Bind",
	Default = Enum.KeyCode.Z,
	Hold = false,
	Callback = function()
		local character = l_plr.Character or l_plr.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 20, 0)
	end    
})

RageTab:AddToggle({
	Name = "Fast Shooting",
	Default = false,
	Callback = function(Value)
		
	end    
})

RageTab:AddToggle({
	Name = "No Recoil",
	Default = false,
	Callback = function(Value)
		
	end    
})

MiscTab:AddToggle({
    Name = "Buy everywhere",
    Default = false,
    Callback = function(Value)

    end
})
MiscTab:AddToggle({
    Name = "Night Mode",
    Default = false,
    Callback = function(Value)

    end
})
SkinsTab:AddButton({
	Name = "Skin Hub",
	Callback = function()
      		print("button pressed")
  	end    
})
