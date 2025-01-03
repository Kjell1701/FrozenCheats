-- Mod-Menü GUI erstellen
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local CategoriesFrame = Instance.new("Frame")
local EspButton = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local CurrentCategory = "ESP"

-- Eigenschaften für das GUI setzen
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Rahmen für das Menü
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.Size = UDim2.new(0, 400, 0, 200)
Frame.Position = UDim2.new(0.5, -200, 0.5, -100)

-- Titel "Frozen"
Title.Parent = Frame
Title.Text = "Frozen"
Title.TextColor3 = Color3.new(0, 0, 1) -- Blau
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24
Title.Size = UDim2.new(0, 100, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)

-- Schließen-Button "X"
CloseButton.Parent = Frame
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 0, 0) -- Rot
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 5)

-- Kategoriebereich links
CategoriesFrame.Parent = Frame
CategoriesFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
CategoriesFrame.Size = UDim2.new(0, 100, 0, 200)
CategoriesFrame.Position = UDim2.new(0, 0, 0, 0)

-- ESP-Button in der Kategorie
EspButton.Parent = CategoriesFrame
EspButton.Text = "ESP"
EspButton.TextColor3 = Color3.new(1, 1, 1) -- Weiß
EspButton.Font = Enum.Font.SourceSansBold
EspButton.TextSize = 18
EspButton.Size = UDim2.new(0, 100, 0, 50)
EspButton.Position = UDim2.new(0, 0, 0, 50)

-- Hauptframe für Inhalte (ESP, etc.)
MainFrame.Parent = Frame
MainFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0, 100, 0, 0)

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
    print("ESP aktiviert!")
end

-- ESP-Button-Funktion
EspButton.MouseButton1Click:Connect(function()
    if CurrentCategory == "ESP" then
        activateESP()
    end
end)

-- Schließen-Button-Funktion
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    print("Mod-Menü geschlossen.")
end)

-- Hinweis: Für das Skript muss Allow HTTP Requests in den Game Settings aktiviert sein.


