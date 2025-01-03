-- Mod-Menü GUI erstellen
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local EspButton = Instance.new("TextButton")

-- Eigenschaften für das GUI setzen
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)

EspButton.Parent = Frame
EspButton.Size = UDim2.new(0, 200, 0, 50)
EspButton.Position = UDim2.new(0.5, -100, 0.5, -25)
EspButton.Text = "ESP Aktivieren"

-- Funktion zum Erstellen von ESP
local function createESP(object)
    local highlight = Instance.new("Highlight")
    highlight.Parent = object
    highlight.FillColor = Color3.new(1, 0, 0) -- Rot
    highlight.FillTransparency = 0.5
end

-- Button-Funktion für ESP
EspButton.MouseButton1Click:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            createESP(player.Character)
        end
    end
    print("ESP aktiviert!")
end)

-- Hinweis: Für das Skript muss Allow HTTP Requests in den Game Settings aktiviert sein.

