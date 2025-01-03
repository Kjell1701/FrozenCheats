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
EspButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5) -- Grau

-- Hauptframe für Inhalte (ESP, etc.)
MainFrame.Parent = Frame
MainFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0, 100, 0, 50)

-- ESP Status (aktiviert oder deaktiviert)
local espActive = false
local highlights = {} -- Table um Highlights zu speichern
local espUpdateTimer = nil

-- Funktion zum Erstellen von ESP
local function createESP(object)
    local highlight = Instance.new("Highlight")
    highlight.Parent = object
    highlight.FillColor = Color3.new(1, 0, 0) -- Rot
    highlight.FillTransparency = 0.5
    table.insert(highlights, highlight) -- Highlight speichern
end

-- Funktion um das ESP für alle Teile eines Fahrzeugs zu erstellen
local function createESPForVehicle(vehicle)
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
            -- Überprüfen, ob der Spieler in einem Fahrzeug sitzt
            local vehicle = player.Character:FindFirstChild("VehicleSeat") and player.Character.Parent
            if vehicle then
                createESPForVehicle(vehicle) -- ESP für das Fahrzeug aktivieren
            else
                -- Spieler sehen, auch wenn sie zu Fuß sind
                createESP(player.Character)
            end
        end
    end
end

-- Funktion zum Deaktivieren von ESP
local function deactivateESP()
    for _, highlight in pairs(highlights) do
        if highlight.Parent then
            highlight:Destroy() -- Entferne jedes Highlight
        end
    end
    highlights = {} -- Reset der Highlights
end

-- Funktion zum Überprüfen, ob ESP aktiviert ist, und es regelmäßig neu laden
local function autoUpdateESP()
    if espActive then
        activateESP() -- Wenn ESP aktiv ist, das ESP alle 5 Sekunden neu laden
    end
end

-- ESP-Button-Funktion
EspButton.MouseButton1Click:Connect(function()
    if espActive then
        deactivateESP() -- ESP deaktivieren
        EspButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5) -- Grau
        EspButton.Text = "ESP" -- Text zurück zu "ESP"
        espActive = false

        -- Stoppe den Timer, wenn ESP deaktiviert wird
        if espUpdateTimer then
            espUpdateTimer:Disconnect()
            espUpdateTimer = nil
        end
    else
        activateESP() -- ESP aktivieren
        EspButton.BackgroundColor3 = Color3.new(0, 1, 0) -- Grün
        EspButton.Text = "Deaktivieren" -- Text ändern zu "Deaktivieren"
        espActive = true

        -- Starte den Timer, um das ESP alle 5 Sekunden zu aktualisieren
        espUpdateTimer = game:GetService("RunService").Heartbeat:Connect(function()
            if espActive then
                autoUpdateESP() -- ESP regelmäßig alle 5 Sekunden aktualisieren
            end
        end)
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

-- Event-Listener, um ESP für neue Spieler zu aktivieren
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espActive then
            createESP(character) -- Aktivieren von ESP für den neuen Spieler
        end
    end)
end)

-- Hinweis: Für das Skript muss Allow HTTP Requests in den Game Settings aktiviert sein.
