-- Obby game code

-- Define variables
local players = game:GetService("Players")
local checkpoints = game:GetService("Workspace").Checkpoints:GetChildren()
local startPoint = Vector3.new(0, 5, 0) -- Change this to your starting point
local respawnTime = 5 -- Change this to the respawn time in seconds

-- Function to handle player respawn
local function respawnPlayer(player)
    local character = player.Character
    if character then
        character:MoveTo(startPoint)
        wait(1) -- Wait a bit before reattaching player
        character:SetPrimaryPartCFrame(CFrame.new(startPoint))
    end
end

-- Function to handle checkpoint collision
local function onCheckpointTouch(otherPart)
    local character = otherPart.Parent
    if character and character:IsA("Model") then
        local player = players:GetPlayerFromCharacter(character)
        if player then
            -- Find the next checkpoint index
            local currentIndex = tonumber(otherPart.Name)
            local nextIndex = currentIndex + 1
            local nextCheckpoint = game.Workspace.Checkpoints:FindFirstChild(tostring(nextIndex))
            if nextCheckpoint then
                -- Move player to next checkpoint
                respawnPlayer(player)
            else
                -- Player reached the end, congratulate
                print(player.Name .. " finished the Obby!")
            end
        end
    end
end

-- Connect the checkpoint touch event
for _, checkpoint in ipairs(checkpoints) do
    checkpoint.Touched:Connect(onCheckpointTouch)
end

-- Connect player added event
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        respawnPlayer(player)
    end)
end)
