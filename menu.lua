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
local playersESP = {} -- Table für Player ESP

-- Funktion zum Erstellen von ESP
local function createESP(character)
    if character and character:FindFirstChild("Head") then
        local head = character.Head
        local espPart = Instance.new("BillboardGui")
        espPart.Parent = head
        espPart.Adornee = head
        espPart.Size = UDim2.new(0, 100, 0, 100)
        espPart.StudsOffset = Vector3.new(0, 1.5, 0)
        
        local frame = Instance.new("Frame")
        frame.Parent = espPart
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(1, 0, 0) -- Rot
        table.insert(playersESP, espPart) -- Füge dem ESP-Array hinzu
    end
end

-- Funktion zum Entfernen von ESP
local function removeESP(character)
    if character and character:FindFirstChild("Head") then
        for _, espPart in pairs(playersESP) do
            if espPart.Parent then
                espPart:Destroy()
            end
        end
        playersESP = {} -- Reset des ESP-Arrays
    end
end

-- Funktion um ESP für alle Spieler zu aktivieren
local function activateESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            createESP(player.Character) -- Erstelle ESP für den Spieler
        end
    end
end

-- Funktion zum Deaktivieren von ESP
local function deactivateESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            removeESP(player.Character) -- Entferne ESP für den Spieler
        end
    end
end

-- ESP-Button-Funktion
EspButton.MouseButton1Click:Connect(function()
    if espActive then
        deactivateESP() -- ESP deaktivieren
        EspButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5) -- Grau
        EspButton.Text = "ESP" -- Text zurück zu "ESP"
        espActive = false
    else
        activateESP() -- ESP aktivieren
        EspButton.BackgroundColor3 = Color3.new(0, 1, 0) -- Grün
        EspButton.Text = "Deaktivieren" -- Text ändern zu "Deaktivieren"
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

-- Event-Listener, um ESP für neue Spieler zu aktivieren
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espActive then
            createESP(character) -- Aktivieren von ESP für den neuen Spieler
        end
    end)
end)

-- Tastenkürzel "O" zum Aktivieren/Deaktivieren von ESP
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.O then
        if espActive then
            deactivateESP() -- ESP deaktivieren
            EspButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5) -- Grau
            EspButton.Text = "ESP" -- Text zurück zu "ESP"
            espActive = false
        else
            activateESP() -- ESP aktivieren
            EspButton.BackgroundColor3 = Color3.new(0, 1, 0) -- Grün
            EspButton.Text = "Deaktivieren" -- Text ändern zu "Deaktivieren"
            espActive = true
        end
    end
end)

-- Hinweis: Für das Skript muss Allow HTTP Requests in den Game Settings aktiviert sein.

