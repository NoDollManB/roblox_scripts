local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoDollManB/gui/refs/heads/main/lib.lua"))()

local Main = library:CreateWindow("DollShot || Arsenal", "Crimson")

local tab = Main:CreateTab("visual")
local tab2 = Main:CreateTab("rage")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local espEnabled = false
local espBoxes = {}
local twisterEnabled = false
local twistSpeed = 1
local aimbotEnabled = false
local drawCircleEnabled = false
local aimbotTarget = nil
local circle = Drawing.new("Circle")
local circleScale = 50

circle.Visible = false
circle.Color = Color3.fromRGB(255, 0, 230) -- Color for the circle
circle.Thickness = 2
circle.Radius = circleScale
circle.Filled = false -- Make the circle hollow

local function createESPBox(playerCharacter)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(0, 102, 255) -- Color for the box
    box.Thickness = 2
    box.Filled = false

    RunService.RenderStepped:Connect(function()
        if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
            local vector, onScreen = camera:WorldToViewportPoint(playerCharacter.HumanoidRootPart.Position)
            if onScreen then
                local size = (Vector2.new(2000, 2000) / vector.Z) * 1.5
                box.Size = Vector2.new(size.X, size.Y)
                box.Position = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end)

    playerCharacter:WaitForChild("Humanoid").Died:Connect(function()
        box:Remove()
        espBoxes[playerCharacter] = nil
    end)

    espBoxes[playerCharacter] = box
end

local function removeESPBox(playerCharacter)
    if espBoxes[playerCharacter] then
        espBoxes[playerCharacter]:Remove()
        espBoxes[playerCharacter] = nil
    end
end

local function onPlayerAdded(newPlayer)
    local character = newPlayer.Character or newPlayer.CharacterAdded:Wait()
    if espEnabled then
        createESPBox(character)
    end

    newPlayer.CharacterAdded:Connect(function(newCharacter)
        if espEnabled then
            createESPBox(newCharacter)
        end
    end)
end

local function onPlayerRemoving(player)
    if espBoxes[player.Character] then
        removeESPBox(player.Character)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        onPlayerAdded(player)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

tab:CreateToggle("esp box", function(state)
    espEnabled = state
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if state then
                onPlayerAdded(player)
            else
                removeESPBox(player.Character)
            end
        end
    end
end)

tab2:CreateToggle("twister", function(state)
    twisterEnabled = state
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    RunService.RenderStepped:Connect(function()
        if twisterEnabled and camera.CameraType == Enum.CameraType.Custom then
            humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(twistSpeed), 0) -- Spin at specified speed
        end
    end)
end)

tab2:CreateSlider("twist speed", 1, 100, function(value)
    twistSpeed = value
end)

tab:CreateCheckbox("Aimbot", function(state)
    aimbotEnabled = state
end)

tab:CreateCheckbox("Draw Circle Aimbot", function(state)
    drawCircleEnabled = state
    circle.Visible = state
end)

tab:CreateSlider("Circle Scale", 5, 30, function(value)
    circleScale = value * 10 -- Scale the circle size
    circle.Radius = circleScale
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and aimbotEnabled then
        local closestPlayer = nil
        local shortestDistance = math.huge
        local mouseLocation = UserInputService:GetMouseLocation()

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
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
    if aimbotTarget then
        camera.CFrame = CFrame.new(camera.CFrame.Position, aimbotTarget.Position)
    end

    if drawCircleEnabled then
        circle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    end
end)
