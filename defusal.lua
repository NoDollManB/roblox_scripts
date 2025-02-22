local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DollShot || ✂️Defusal FPS💣[TESTING]",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "DollStudio",
   LoadingSubtitle = "by DollManB",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = ""
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "https://discord.gg/pP4J7D9X", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Defusal | Key",
      Subtitle = "https://discord.gg/pP4J7D9X",
      Note = "Log in to my discord server to find out the key", -- Use this to tell the user how to get a key
      FileName = "ntRM5", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"ntRM5"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local LegitTab = Window:CreateTab("Legit", nil)
local RageTab = Window:CreateTab("Rage", nil)
local SkinsTab = Window:CreateTab("Skins", nil)
local MiscTab = Window:CreateTab("Misc", nil)


local ligth = game:GetService("Lighting")
local sky = game:GetService("Lighting").Sky
local smoke = game:GetService("Lighting").SmokeUp

local boxESPEnabled = false
local boxes = {}
local healthESPEnabled = false

local aimbotEnabled = false
local silentAimEnabled = false
local drawCircleEnabled = false
local circleScale = 50
local circle = Drawing.new("Circle")
circle.Position = Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y)
local aimbotTarget = nil

local spinBotEnabled = false
local spinBotConnection = nil
local speedHackEnabled = false
local hackedSpeed = 60
local normalSpeed = 20
local tpToMeConnection = nil
local speedHackConnection = nil
local godModeEnabled = false

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local savedPosition = nil

local function createBox(character)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.new(1, 0, 0)
    box.Thickness = 2
    box.Filled = false
    box.Parent = game.Workspace.Camera
    box.Character = character

    local function updateBox()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(character.HumanoidRootPart.Position)
            if onScreen then
                local size = 2000 / vector.Z
                box.Size = Vector2.new(size, size)
                box.Position = Vector2.new(vector.X - size / 2, vector.Y - size / 2)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end

    RunService.RenderStepped:Connect(updateBox)
    table.insert(boxes, box)
end

local function removeBox(character)
    for i, box in ipairs(boxes) do
        if box.Character == character then
            box:Remove()
            table.remove(boxes, i)
            break
        end
    end
end

local function onPlayerAdded(newPlayer)
    local character = newPlayer.Character or newPlayer.CharacterAdded:Wait()
    if boxESPEnabled then
        createBox(character)
    end

    newPlayer.CharacterAdded:Connect(function(newCharacter)
        if boxESPEnabled then
            createBox(newCharacter)
        end
    end)
end

local function onPlayerRemoving(player)
    if player.Character then
        removeBox(player.Character)
    end
end

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    if player ~= game:GetService("Players").LocalPlayer then
        onPlayerAdded(player)
    end
end

game:GetService("Players").PlayerAdded:Connect(onPlayerAdded)
game:GetService("Players").PlayerRemoving:Connect(onPlayerRemoving)

local Button = LegitTab:CreateButton({
   Name = "Esp",
   Callback = function()
       boxESPEnabled = not boxESPEnabled
       if boxESPEnabled then
           for _, player in pairs(game:GetService("Players"):GetPlayers()) do
               if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                   createBox(player.Character)
               end
           end
       else
           for _, box in pairs(boxes) do
               box:Remove()
           end
           boxes = {}
       end
   end,
})

local Aimbot = RageTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "aim",
   Callback = function(Value)
       aimbotEnabled = Value
   end,
})

local SilentAim = LegitTab:CreateToggle({
   Name = "Silent Aim",
   CurrentValue = false,
   Flag = "silent_aim",
   Callback = function(Value)
       silentAimEnabled = Value
   end,
})

local DrawCircle = MiscTab:CreateToggle({
   Name = "Draw Aimbot Circle",
   CurrentValue = false,
   Flag = "draw_circle",
   Callback = function(Value)
       drawCircleEnabled = Value
       circle.Visible = Value
   end,
})

local CircleSize = MiscTab:CreateSlider({
   Name = "Aimbot Circle Size",
   Range = {5, 40},
   Increment = 1,
   Suffix = "Size",
   CurrentValue = 5,
   Flag = "circle_size",
   Callback = function(Value)
       circleScale = Value * 10
       circle.Radius = circleScale
   end,
})

local FlyUpButton = RageTab:CreateButton({
    Name = "Fly Up 5m",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        if humanoidRootPart then
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 20, 0)
        end
    end,
 })

local SpinBot = RageTab:CreateToggle({
   Name = "SpinBot",
   CurrentValue = false,
   Flag = "spinbot",
   Callback = function(Value)
       spinBotEnabled = Value
       local player = game:GetService("Players").LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

       if spinBotEnabled then
           spinBotConnection = RunService.Stepped:Connect(function()
               if spinBotEnabled then
                   humanoidRootPart.RotVelocity = Vector3.new(0, 150, 0)
               end
           end)
       else
           if spinBotConnection then
               spinBotConnection:Disconnect()
               spinBotConnection = nil
           end
           humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
       end
   end,
})

local SpeedHack = RageTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Flag = "speed_hack",
   Callback = function(Value)
       speedHackEnabled = Value
       local player = game:GetService("Players").LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local humanoid = character:WaitForChild("Humanoid")

       if speedHackEnabled then
           speedHackConnection = game:GetService("RunService").Stepped:Connect(function()
               if speedHackEnabled then
                   humanoid.WalkSpeed = hackedSpeed
               end
           end)
       else
           if speedHackConnection then
               speedHackConnection:Disconnect()
               speedHackConnection = nil
           end
           humanoid.WalkSpeed = normalSpeed
       end
   end,
})

local TpToMe = RageTab:CreateToggle({
   Name = "Tp To Me",
   CurrentValue = false,
   Flag = "tp_to_me",
   Callback = function(Value)
       if Value then
           tpToMeConnection = RunService.Heartbeat:Connect(function()
               local localPlayerPosition = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position
               if localPlayerPosition then
                   for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
                       if targetPlayer ~= game:GetService("Players").LocalPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                           targetPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(localPlayerPosition)
                       end
                   end
               end
           end)
       else
           if tpToMeConnection then
               tpToMeConnection:Disconnect()
               tpToMeConnection = nil
           end
       end
   end,
})

local RainbowHands = SkinsTab:CreateToggle({
    Name = "Rainbow Hands",
    CurrentValue = false,
    Flag = "rainbow_hands",
    Callback = function(Value)
        local rainbowHandsEnabled = Value
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 127, 0),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(75, 0, 130),
            Color3.fromRGB(148, 0, 211)
        }

        local colorIndex = 1
        local colorChangeInterval = 0.2

        local function changeColor()
            if rainbowHandsEnabled then
                local leftArm = workspace.Camera:FindFirstChild("Arms") and workspace.Camera.Arms:FindFirstChild("CSSArms") and workspace.Camera.Arms.CSSArms:FindFirstChild("Left Arm")
                local rightArm = workspace.Camera:FindFirstChild("Arms") and workspace.Camera.Arms:FindFirstChild("CSSArms") and workspace.Camera.Arms.CSSArms:FindFirstChild("Right Arm")

                if leftArm and rightArm then
                    colorIndex = colorIndex % #colors + 1
                    local currentColor = colors[colorIndex]
                    leftArm.Color = currentColor
                    rightArm.Color = currentColor
                end
            end
        end

        if rainbowHandsEnabled then
            game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
                colorChangeInterval = colorChangeInterval - deltaTime
                if colorChangeInterval <= 0 then
                    changeColor()
                    colorChangeInterval = colorChangeSpeed
                end
            end)
        else
            local leftArm = workspace.Camera:FindFirstChild("Arms") and workspace.Camera.Arms:FindFirstChild("CSSArms") and workspace.Camera.Arms.CSSArms:FindFirstChild("Left Arm")
            local rightArm = workspace.Camera:FindFirstChild("Arms") and workspace.Camera.Arms:FindFirstChild("CSSArms") and workspace.Camera.Arms.CSSArms:FindFirstChild("Right Arm")
            if leftArm and rightArm then
                leftArm.Color = Color3.new(1, 1, 1)
                rightArm.Color = Color3.new(1, 1, 1)
            end
        end
    end,
})

local ColorChangeSpeedSlider = SkinsTab:CreateSlider({
    Name = "Color Change Speed",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = "Seconds",
    CurrentValue = 0.1,
    Flag = "color_change_speed",
    Callback = function(Value)
        colorChangeSpeed = Value
    end,
})

local NightMode = MiscTab:CreateToggle({
    Name = "Night Mode",
    CurrentValue = false,
    Flag = "night",
    Callback = function(Value)
        if Value then
            sky.SkyboxBk = "http://www.roblox.com/asset/?id=48020371"
            sky.SkyboxDn = "http://www.roblox.com/asset/?id=48020144"
            sky.SkyboxFt = "http://www.roblox.com/asset/?id=48020234"
            sky.SkyboxLf = "http://www.roblox.com/asset/?id=48020211"
            sky.SkyboxRt = "http://www.roblox.com/asset/?id=48020254"
            sky.SkyboxUp = "http://www.roblox.com/asset/?id=48020383"
    
            ligth.Brightness = 1
            ligth.Ambient = Color3.fromRGB(155, 157, 255)
    
            smoke.TintColor = Color3.fromRGB(144, 140, 255)
        else
            sky.SkyboxBk = "http://www.roblox.com/asset/?id=98202165"
            sky.SkyboxDn = "http://www.roblox.com/asset/?id=98202176"
            sky.SkyboxFt = "http://www.roblox.com/asset/?id=98202152"
            sky.SkyboxLf = "http://www.roblox.com/asset/?id=98202161"
            sky.SkyboxRt = "http://www.roblox.com/asset/?id=98202146"
            sky.SkyboxUp = "http://www.roblox.com/asset/?id=98202169"
    
            ligth.Brightness = 2.799999952316284
            ligth.Ambient = Color3.fromRGB(170, 170, 170)
    
            smoke.TintColor = Color3.fromRGB(255,255,255)
        end
    end,
})

local skinHub = SkinsTab:CreateButton({
    Name = "Skin Hub",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/NoDollManB/roblox_scripts/refs/heads/main/skinhub.lua'))()
    end,
})


circle.Visible = false
circle.Color = Color3.fromRGB(255, 0, 230)
circle.Thickness = 2
circle.Radius = circleScale
circle.Filled = false
circle.NumSides = 64
circle.Transparency = 1

local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

local function onTargetDied()
    aimbotTarget = nil
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton2 and aimbotEnabled then
        local closestPlayer = nil
        local shortestDistance = math.huge
        local mouseLocation = UserInputService:GetMouseLocation()

        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local screenPos, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouseLocation.X, mouseLocation.Y)).Magnitude
                    if distance < circle.Radius and distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end

        if closestPlayer then
            aimbotTarget = closestPlayer.Character.Head
            closestPlayer.Character.Humanoid.Died:Connect(onTargetDied)
        end
    end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 and silentAimEnabled then
        local closestPlayer = nil
        local shortestDistance = math.huge
        local mouseLocation = UserInputService:GetMouseLocation()
        
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local screenPos, onScreen = camera:WorldToViewportPoint(player.Character.Head.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouseLocation.X, mouseLocation.Y)).Magnitude
                    if distance < circle.Radius and distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        
        if closestPlayer then
            local originalCFrame = camera.CFrame
            camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Character.Head.Position)
            task.wait(0.001) -- Wait for 1 millisecond
            camera.CFrame = originalCFrame
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and aimbotEnabled then
        aimbotTarget = nil
    end
end)

RunService.RenderStepped:Connect(function()
    if aimbotTarget and aimbotTarget.Parent and aimbotTarget.Parent:FindFirstChild("Humanoid") and aimbotTarget.Parent.Humanoid.Health > 0 then
        local screenPos, onScreen = camera:WorldToViewportPoint(aimbotTarget.Position)
        if onScreen then
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)).Magnitude
            if distance < circle.Radius then
                camera.CFrame = CFrame.new(camera.CFrame.Position, aimbotTarget.Position)
            else
                aimbotTarget = nil
            end
        else
            aimbotTarget = nil
        end
    else
        aimbotTarget = nil
    end

    if drawCircleEnabled then
        local mouseLocation = UserInputService:GetMouseLocation()
        circle.Position = mouseLocation
    end
end)
