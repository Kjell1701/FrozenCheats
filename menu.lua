-- GUI Library laden
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dein-repo/gui-library/main/library.lua"))()
local Window = Library:CreateWindow("Mod Menü") -- Titel des Mod-Menüs

-- ESP Funktion
local function createESP(object)
    local highlight = Instance.new("Highlight")
    highlight.Parent = object
    highlight.FillColor = Color3.new(1, 0, 0) -- Rote Markierung
    highlight.FillTransparency = 0.5
end

-- Button für ESP
Window:AddButton("ESP Aktivieren", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            createESP(player.Character)
        end
    end
end)

-- Speed Hack
Window:AddButton("Speed Hack", function()
    local player = game.Players.LocalPlayer
    player.Character.Humanoid.WalkSpeed = 100 -- Geschwindigkeit auf 100 erhöhen
end)

-- Fly Hack (Beispiel)
Window:AddButton("Fly Hack", function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    local flying = true
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.X then -- Beenden mit der Taste X
            flying = false
        end
    end)
    
    while flying do
        root.Velocity = Vector3.new(0, 50, 0) -- Schwebt nach oben
        wait(0.1)
    end
end)

