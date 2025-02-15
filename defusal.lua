local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoDollManB/gui/refs/heads/main/lib.lua"))()

local Main = library:CreateWindow("Defusal By DollManB", "Crimson")

local tab = Main:CreateTab("ESP")
local tab2 = Main:CreateTab("Aimbot")
local tab3 = Main:CreateTab("Rofls")
local tab4 = Main:CreateTab("Misc")

local boxESPEnabled = false
local boxes = {}

local function createBox(character)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.new(1, 0, 0)
    box.Thickness = 2
    box.Filled = false
    box.Parent = game.Workspace.Camera
    box.Character = character -- Store reference to character

    local function updateBox()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(character.HumanoidRootPart.Position)
            if onScreen then
                local size = 2000 / vector.Z -- Scale the box size based on distance
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

    game:GetService("RunService").RenderStepped:Connect(updateBox)
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

tab:CreateToggle("Enable Box ESP", function(state)
    boxESPEnabled = state
    if boxESPEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
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
end)

local aimbotEnabled = false
local drawCircleEnabled = false
local aimbotTarget = nil
local circle = Drawing.new("Circle")
local circleScale = 50

local speedHackEnabled = false
local hackedSpeed = 60
local normalSpeed = 20

tab2:CreateCheckbox("Enable Aimbot", function(state)
    aimbotEnabled = state
end)

local tpToMeConnection = nil

tab4:CreateCheckbox("Tp To me (local)", function(state)
    if state then
        tpToMeConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local localPlayerPosition = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            if localPlayerPosition then
                for _, targetPlayer in pairs(game.Players:GetPlayers()) do
                    if targetPlayer ~= game.Players.LocalPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
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
end)

tab2:CreateCheckbox("Enable Drawing Aimbot Circle", function(state)
    drawCircleEnabled = state
    circle.Visible = state
end)

tab2:CreateSlider("Size Aimbot Circle", 5, 40, function(value)
    circleScale = value * 10 -- Scale the circle size
    circle.Radius = circleScale
end)

local spinBotEnabled = false
local spinBotConnection = nil

tab3:CreateToggle("SpinBot", function(state)
    spinBotEnabled = state
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if spinBotEnabled then
        spinBotConnection = game:GetService("RunService").Stepped:Connect(function()
            if spinBotEnabled then
                humanoidRootPart.RotVelocity = Vector3.new(0, 10, 0) -- Spin speed
            end
        end)
    else
        if spinBotConnection then
            spinBotConnection:Disconnect()
            spinBotConnection = nil
        end
        humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
end)

tab4:CreateToggle("Speed Hack", function(state)
    speedHackEnabled = state
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    local function updateSpeed()
        if speedHackEnabled and humanoid then
            humanoid.WalkSpeed = hackedSpeed
        else
            humanoid.WalkSpeed = normalSpeed
        end
    end

    if speedHackEnabled then
        game:GetService("RunService").Heartbeat:Connect(updateSpeed)
    else
        humanoid.WalkSpeed = normalSpeed
    end
end)

circle.Visible = false
circle.Color = Color3.fromRGB(255, 0, 230) -- Color for the circle
circle.Thickness = 2
circle.Radius = circleScale
circle.Filled = false -- Make the circle hollow

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

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

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        onPlayerAdded(player)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

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

tab:Show()
