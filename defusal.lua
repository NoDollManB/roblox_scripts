local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("Defusal By DollManB", "RJTheme8")
local VisTab = Window:NewTab("Visual")
local VisSec = VisTab:NewSection("Visual")

local RageTab = Window:NewTab("Rage")
local RagSec = RageTab:NewSection("Rage")

local highlights = {}

VisSec:NewButton("Add highlight to all player", "", function()
    for _, highlight in pairs(highlights) do
        highlight:Destroy()
    end
    highlights = {}

    -- Add highlight to all player models
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = player.Character
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.5
            highlight.Parent = game.Workspace.Camera
            table.insert(highlights, highlight)
        end
    end
end)

VisSec:NewButton("Clear", "", function()
    for _, highlight in pairs(highlights) do
        highlight:Destroy()
    end
    highlights = {}
end)

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local infJumpConnection
local infHealthConnection
local raycastConnection

RagSec:NewToggle("Inf Jump", "", function(state)
    if state then
        infJumpConnection = runService.Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                player.Character.Humanoid.JumpPower = 150
                player.Character.Humanoid.UseJumpPower = true
            end
        end)
    else
        if infJumpConnection then
            infJumpConnection:Disconnect()
        end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 150
            player.Character.Humanoid.UseJumpPower = false
        end
    end
end)
RagSec:NewToggle("tp to me(local)", "", function(state)
    if state then
            tpToMeConnection = runService.Heartbeat:Connect(function()
                    local localPlayerPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
                    if localPlayerPosition then 
                        for _, targetPlayer in pairs(game.Players:GetPlayers()) do
                            if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then 
                                targetPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(localPlayerPosition) end
                        end            
                    end        
                end)    
        else       
            if tpToMeConnection then        
                tpToMeConnection:Disconnect()        
            end    
        end
end)
