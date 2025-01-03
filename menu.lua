local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dein-repo/gui-library/main/library.lua"))()
local Window = Library:CreateWindow("Mod Menü") -- Titel des Mod-Menüs

-- ESP Funktion
Window:AddButton("ESP Aktivieren", function()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") then
            local esp = Instance.new("Highlight", v)
            esp.FillColor = Color3.new(1, 0, 0)
            esp.FillTransparency = 0.5
        end
    end
end)

-- Speed Hack
Window:AddButton("Speed Hack", function()
    local player = game.Players.LocalPlayer
    player.Character.Humanoid.WalkSpeed = 100
end)

-- Fly Hack
Window:AddButton("Fly Hack", function()
    -- Fly-Logik hier einfügen
end)
