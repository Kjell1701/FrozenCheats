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
local skeletons = {} -- Table für Skeleton ESP Linien

-- Liste der Gelenke im Charakter
local joints = {
    "Head",
    "Torso",
    "LeftLeg",
    "RightLeg",
    "LeftArm",
    "RightArm",
    "HumanoidRootPart"
}

-- Funktion zum Erstellen von Skeleton ESP
local function createSkeletonESP(character)
    -- Entfernen bestehender Skeletons
    if skeletons[character] then
        for _, part in pairs(skeletons[character]) do
            if part.Parent then
                part:Destroy()
            end
        end
    end
    
    skeletons[character] = {}

    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        local humanoidRoot = character:FindFirstChild("HumanoidRootPart")
        local parts = {}
        
        -- Alle relevanten Körperteile finden
        for _, joint in pairs(joints) do
            local part = character:FindFirstChild(joint)
            if part then
                table.insert(parts, part)
            end
        end
        
        -- Linien zwischen den Gelenken erstellen
        for i = 1, #parts - 1 do
            local part1 = parts[i]
            local part2 = parts[i + 1]
            
            local line = Instance.new("LineHandleAdornment")
            line.Parent = workspace
            line.Color3 = Color3.new(1, 0, 0) -- Rot
            line.Transparency = 0.5
            line.Adornee = part1
            line.CFrame = CFrame.new(part1.Position, part2.Position)
            line.Length = (part2.Position - part1.Position).Magnitude
            line.Parent = workspace
            
            table.insert(skeletons[character], line) -- Linie zum Skeleton hinzufügen
        end
    end
end

-- Funktion zum Entfernen von Skeleton ESP
local function removeSkeletonESP(character)
    if skeletons[character] then
        for _, part in pairs(skeletons[character]) do
            if part.Parent then
                part:Destroy() -- Entferne jede Linie
            end
        end
        skeletons[character] = {} -- Reset der Skeleton-Daten
    end
end

-- Funktion um ESP für alle Spieler zu aktivieren
local function activateESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            createSkeletonESP(player.Character) -- Erstelle Skeleton ESP für den Spieler
        end
    end
end

-- Funktion zum Deaktivieren von ESP
local function deactivateESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            removeSkeletonESP(player.Character) -- Entferne Skeleton ESP
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

-- Event-Listener, um Skeleton ESP für neue Spieler zu aktivieren
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espActive then
            createSkeletonESP(character) -- Aktivieren von Skeleton ESP für den neuen Spieler
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


