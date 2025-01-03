local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 300, 0, 400)
menu.Position = UDim2.new(0.5, -150, 0.5, -200)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.BorderSizePixel = 0
menu.Visible = true
menu.Active = true
menu.Draggable = true
menu.Parent = game.CoreGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Frozen Cheats"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.BackgroundTransparency = 1
title.TextSize = 20
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = menu

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Parent = menu

closeButton.MouseButton1Click:Connect(function()
    menu:Destroy()
end)

-- ESP-Button
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 100, 0, 30)
espButton.Position = UDim2.new(0, 10, 0, 50)
espButton.Text = "ESP"
espButton.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
espButton.Parent = menu

local isESPActive = false
espButton.MouseButton1Click:Connect(function()
    isESPActive = not isESPActive
    espButton.Text = isESPActive and "ESP" or "ESP"
    espButton.BackgroundColor3 = isESPActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(170, 170, 170)

    if isESPActive then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player then
                local highlight = v.Character:FindFirstChild("ESP") or Instance.new("Highlight")
                highlight.Name = "ESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.Parent = v.Character
            end
        end
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            local highlight = v.Character:FindFirstChild("ESP")
            if highlight then
                highlight:Destroy()
            end
        end
    end
end)

-- Speedhack-Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 100, 0, 30)
speedButton.Position = UDim2.new(0, 10, 0, 90)
speedButton.Text = "Speedhack"
speedButton.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
speedButton.Parent = menu

local isSpeedActive = false
speedButton.MouseButton1Click:Connect(function()
    isSpeedActive = not isSpeedActive
    if isSpeedActive then
        humanoid.WalkSpeed = 100
        speedButton.Text = "Normal Speed"
        speedButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        humanoid.WalkSpeed = 16
        speedButton.Text = "Speedhack"
        speedButton.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
    end
end)

-- Version anzeigen
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 100, 0, 30)
versionLabel.Position = UDim2.new(1, -110, 1, -40)
versionLabel.Text = "V 1.1.6"
versionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 10
versionLabel.Parent = menu

