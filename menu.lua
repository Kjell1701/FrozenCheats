-- Mod-Menü GUI erstellen
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local EspButton = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local Dragging, DragStart, StartPos

-- Eigenschaften für das GUI setzen
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Rahmen für das Menü
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.Size = UDim2.new(0, 400, 0, 200)
Frame.Position = UDim2.new(0.5, -200, 0.5, -100)

-- Titel "Frozen Cheats"
Title.Parent = Frame
Title.Text = "Frozen Cheats"
Title.TextColor3 = Color3.new(0, 0, 1) -- Blau
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24
Title.Size = UDim2.new(0, 150, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)

-- Schließen-Button "X"
CloseButton.Parent = Frame
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 0, 0) -- Rot
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 5)

-- ESP-Button
EspButton.Parent = Frame
EspButton.Text = "ESP"
EspButton.TextColor3 = Color3.new(1, 1, 1) -- Weiß
EspButton.Font = Enum.Font.SourceSansBold
EspButton.TextSize = 18
EspButton.Size = UDim2.new(0, 100, 0, 50)
EspButton.Position = UDim2.new(0, 10, 0, 50)

-- Hauptframe für Inhalte (ESP, etc.)
MainFrame.Parent = Frame
MainFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0, 100, 0, 50)

-- ESP Status (aktiviert oder deaktiviert)
local espActive = false

-- Funktion zum Erstellen von ESP
local function createESP(object)
    local highlight = Instance.new("Highlight")
    highlight.Parent = object
    highlight.FillColor = Color3.new(1, 0, 0) -- Rot
    highlight.FillTransparency = 0.5
end

-- Funktion um das ESP auch im Auto zu aktivieren
local function createESPInVehicle(vehicle)
    if vehicle and vehicle:IsA("Model") then
        for _, part in pairs(vehicle:GetDescendants()) do
            if part:IsA("BasePart") then
                createESP(part)
            end
        end
    end
end

-- Funktion um ESP für alle Spieler und Fahrzeuge zu aktivieren
local function activateESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            createESP(player.Character)
        end
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local vehicle = player.Character:FindFirstChild("VehicleSeat") and player.Character.Parent
            if vehicle then
                createESPInVehicle(vehicle)
            end
        end
    end
end

-- Funktion zum Deaktivieren von ESP
local function deactivateESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            -- Entferne die Highlights
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local highlight = part:FindFirstChild("Highlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end
end

-- ESP-Button-Funktion
EspButton.MouseButton1Click:Connect(function()
    if espActive then
        deactivateESP()
        EspButton.BackgroundColor3 = Color3.new(1, 1, 1) -- Normal
        espActive = false
    else
        activateESP()
        EspButton.BackgroundColor3 = Color3.new(0, 1, 0) -- Grün
        espActive = true
    end
end)

-- Schließen-Button-Funktion
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    print("Mod-Menü geschlossen.")
end)

-- Funktion zum Verschieben des Menüs
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - DragStart
        Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

-- Hinweis: Für das Skript muss Allow HTTP Requests in den Game Settings aktiviert sein.

