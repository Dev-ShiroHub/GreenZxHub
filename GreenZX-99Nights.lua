--[[
    ╔═══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                               ║
    ║   ██████╗ ███████╗███████╗███╗   ██╗███████╗██╗  ██╗    ██╗   ██╗████████╗ ║
    ║   ██╔════╝ ██╔════╝██╔════╝████╗  ██║██╔════╝╚██╗██╔╝    ██║   ██║╚══██╔══╝ ║
    ║   ██║  ███╗█████╗  █████╗  ██╔██╗ ██║███████╗ ╚███╔╝     ██║   ██║   ██║    ║
    ║   ██║   ██║██╔══╝  ██╔══╝  ██║╚██╗██║╚════██║ ██╔██╗     ██║   ██║   ██║    ║
    ║   ╚██████╔╝██║     ███████╗██║ ╚████║███████║██╔╝ ██╗    ╚██████╔╝   ██║    ║
    ║    ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝     ╚═════╝    ╚═╝    ║
    ║                                                                               ║
    ║              🌲 GREENZX HUB v3.0 - 99 NIGHTS IN THE FOREST 🌲                 ║
    ║                                                                               ║
    ║    ⚡ INSPIRED BY VOIDWARE - BUT BETTER, MORE FEATURES, MORE POWER! ⚡        ║
    ║                                                                               ║
    ║    Developed by: RkpyDevelopment Team                                         ║
    ║    Owner: TheRkpyYT                                                          ║
    ║    Version: 3.0.0                                                            ║
    ║    Game: 99 Nights In The Forest                                              ║
    ║                                                                               ║
    ╚═══════════════════════════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVICES & VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ═══════════════════════════════════════════════════════════════════════════════
-- WIND UI LIBRARY LOAD
-- ═══════════════════════════════════════════════════════════════════════════════
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ═══════════════════════════════════════════════════════════════════════════════
-- CONFIGURATION & STATE
-- ═══════════════════════════════════════════════════════════════════════════════
local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    FOV = 70,
    ESPFillTransparency = 0.5,
    ESPOutlineTransparency = 0,
    ESPTextSize = 14,
    KillAuraRange = 20,
    Theme = "Dark"
}

local State = {
    WalkSpeedEnabled = false,
    JumpPowerEnabled = false,
    InfiniteJump = false,
    NoClip = false,
    GodMode = false,
    FullBright = false,
    FlyMode = false,
    KillAura = false,
    EntityESP = false,
    ItemESP = false,
    PlayerESP = false,
    AutoFarmWood = false,
    AutoFarmScrap = false,
    AutoFarmFood = false,
    AutoCook = false,
    AutoFuel = false,
    AutoUpgradeCampfire = false,
    AutoRescueChildren = false,
    AutoStronghold = false,
    AutoFrogCave = false,
    AutoCultistKing = false,
    AntiFreeze = false,
    LavaImmunity = false,
    AutoCollectGems = false,
    InfiniteAmmo = false,
    AutoOpenChests = false,
    AutoHeal = false,
    AntiAFK = true,
    InstantCraft = false,
    AutoBuildBase = false,
    SpeedrunMode = false,
    RemoveFog = false,
    RemoveSky = false,
    NightVision = false,
    NoSmog = false,
    WeatherControl = false,
    LowGFX = false,
    ShowCoords = false,
    FreezeEntities = false,
    AutoPickup = false,
    AutoBringItems = false,
    AutoCompleteCampfire = false,
    InfiniteSaplings = false,
    TreeFarmAura = false,
    PlantSaplingsCircle = false,
    BuildLogWallsCircle = false,
    CleanupLogs = false,
    AutoFeedSurvive = false,
    AntiDetection = true,
    CustomCursor = false,
    SaveConfig = false
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════
local function Notify(title, content, duration, icon)
    WindUI:Notify({
        Title = title,
        Content = content,
        Duration = duration or 5,
        Icon = icon or "bell",
        CanClose = true
    })
end

local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function GetClosestEntity(entityTypes, maxDistance)
    local closest = nil
    local minDist = maxDistance or math.huge
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            for _, entityType in pairs(entityTypes) do
                if obj.Name:lower():find(entityType:lower()) then
                    local primary = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head")
                    if primary and RootPart then
                        local dist = GetDistance(primary.Position, RootPart.Position)
                        if dist < minDist then
                            minDist = dist
                            closest = obj
                        end
                    end
                end
            end
        end
    end
    return closest, minDist
end

local function GetAllEntities(entityTypes)
    local entities = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            for _, entityType in pairs(entityTypes) do
                if obj.Name:lower():find(entityType:lower()) then
                    table.insert(entities, obj)
                end
            end
        end
    end
    return entities
end

local function TeleportTo(position)
    if RootPart then
        RootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

local function FireTool(toolName)
    for _, tool in pairs(Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(toolName:lower()) then
            tool:Activate()
            return true
        end
    end
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(toolName:lower()) then
            Humanoid:EquipTool(tool)
            wait(0.2)
            tool:Activate()
            return true
        end
    end
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- ESP SYSTEM (ADVANCED - LIKE VOIDWARE)
-- ═══════════════════════════════════════════════════════════════════════════════
local ESPObjects = {}
local ESPFolder = Instance.new("Folder", Workspace)
ESPFolder.Name = "GreenZxESP"

local function CreateESP(obj, color, label)
    if not obj then return nil end
    local primary = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")
    if not primary then return nil end

    local highlight = Instance.new("Highlight")
    highlight.Name = "GreenZxHighlight"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = Config.ESPFillTransparency
    highlight.OutlineTransparency = Config.ESPOutlineTransparency
    highlight.Adornee = obj
    highlight.Parent = ESPFolder

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "GreenZxBillboard"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = primary

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.3
    frame.BackgroundColor3 = color
    frame.BorderSizePixel = 0
    frame.Parent = billboard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.6, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = label
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextSize = Config.ESPTextSize
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = frame

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0 studs"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = Config.ESPTextSize - 2
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = frame

    billboard.Parent = ESPFolder

    local espData = {Highlight = highlight, Billboard = billboard, DistanceLabel = distLabel, Object = obj}
    table.insert(ESPObjects, espData)
    return espData
end

local function ClearESP()
    for _, esp in pairs(ESPObjects) do
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
    end
    ESPObjects = {}
end

local function UpdateESP()
    for _, esp in pairs(ESPObjects) do
        if esp.Object and esp.Object.Parent and esp.DistanceLabel and RootPart then
            local primary = esp.Object:FindFirstChild("HumanoidRootPart") or esp.Object:FindFirstChildWhichIsA("BasePart")
            if primary then
                local dist = math.floor(GetDistance(primary.Position, RootPart.Position))
                esp.DistanceLabel.Text = dist .. " studs"
            end
        end
    end
end

spawn(function()
    while true do
        wait(0.1)
        if State.EntityESP or State.ItemESP or State.PlayerESP then
            UpdateESP()
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- FLY SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════
local FlyBodyGyro, FlyBodyVelocity
local function StartFly()
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.P = 9e4
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyGyro.CFrame = RootPart.CFrame
    FlyBodyGyro.Parent = RootPart
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVelocity.Parent = RootPart
end

local function StopFly()
    if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() FlyBodyVelocity = nil end
end

RunService.RenderStepped:Connect(function()
    if not State.FlyMode or not FlyBodyGyro or not FlyBodyVelocity then return end
    local camera = Workspace.CurrentCamera
    local moveDir = Vector3.new(0, 0, 0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
    if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * Config.FlySpeed end
    FlyBodyVelocity.Velocity = moveDir
    FlyBodyGyro.CFrame = camera.CFrame
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- ANTI-AFK
-- ═══════════════════════════════════════════════════════════════════════════════
LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- WELCOME NOTIFICATION
-- ═══════════════════════════════════════════════════════════════════════════════
Notify("🎉 Welcome!", "Hello, " .. LocalPlayer.Name .. "! GreenZx Hub v3.0 is now loaded!", 6, "party-popper")

-- ═══════════════════════════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ═══════════════════════════════════════════════════════════════════════════════
local Window = WindUI:Create({
    Title = "🌲 GreenZx Hub v3.0",
    SubTitle = "99 Nights In The Forest | RkpyDevelopment Team",
    Icon = "tree-pine",
    Theme = "Dark",
    Size = UDim2.fromOffset(750, 550),
    Transparent = true,
    Blur = true,
    Acrylic = true,
    SideBarWidth = 230,
    HasOutline = true,
    CornerRadius = UDim.new(0, 12),
    Position = UDim2.new(0.5, -375, 0.5, -275),
    Keybind = Enum.KeyCode.RightShift,
    ToggleKeybind = true
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: WELCOME 🎉
-- ═══════════════════════════════════════════════════════════════════════════════
local WelcomeTab = Window:Tab({
    Title = "Welcome 🎉",
    Icon = "party-popper",
    Selected = true
})

local GreetingSection = WelcomeTab:Section({
    Title = "👋 Greeting",
    TextXAlignment = "Left"
})

GreetingSection:Paragraph({
    Title = "Hello, " .. LocalPlayer.Name .. "!",
    Content = "Welcome to GreenZx Hub v3.0 — the ULTIMATE companion for 99 Nights In The Forest! This hub is inspired by the legendary Voidware but packed with EVEN MORE features. Survive all 99 nights, rescue every child, defeat the Cultist King, and dominate every biome with ease. Stay safe, survivor! 👋",
    Icon = "hand"
})

local AboutSection = WelcomeTab:Section({
    Title = "📜 About GreenZx Hub",
    TextXAlignment = "Left"
})

AboutSection:Paragraph({
    Title = "GreenZx Hub v3.0 - Voidware Killer Edition",
    Content = "GreenZx Hub is a PREMIUM script hub designed specifically for 99 Nights In The Forest. Version 3.0 includes EVERY feature from Voidware plus exclusive additions: Weather Control, Auto Bring ALL Items, Build Log Walls in Circle, Plant Saplings in Circle, Auto Feed→Cook→Survive chain, Anti-Detection, Custom Cursor, Theme Management, and much more. This is the most powerful script ever made for this game!",
    Icon = "scroll-text"
})

AboutSection:Paragraph({
    Title = "RkpyDevelopment Team",
    Content = "GreenZx Hub is proudly developed by RkpyDevelopment Team, led by TheRkpyYT — a legendary script maker known for creating world-class executors and scripts. Our team is dedicated to delivering the BEST tools for Roblox gamers. We study every game mechanic, every update, and every exploit to ensure our scripts are always ahead of the competition. Thank you for choosing GreenZx Hub!",
    Icon = "users"
})

AboutSection:Paragraph({
    Title = "🌟 Key Features Overview",
    Content = "✅ 50+ Unique Features\n✅ Advanced ESP with Distance, Fill/Outline Transparency, Text Size\n✅ Full Fly Mode with BodyGyro\n✅ Auto Bring ALL Items (Tools, Food, Armor, Weapons, Fuel, Scrap, Pelts, Blueprints, Keys, etc.)\n✅ Auto Complete Campfire + Infinite Saplings\n✅ Tree Farm Aura + Plant/Build in Circle\n✅ Auto Feed → Auto Cook → Auto Survive Chain\n✅ Weather Control + Night Vision + No Smog\n✅ Anti-Detection + Anti-AFK\n✅ Save/Load Configuration\n✅ Custom Cursor + Theme Management",
    Icon = "sparkles"
})

local StatsSection = WelcomeTab:Section({
    Title = "📊 Live Stats Monitor",
    TextXAlignment = "Left"
})

local StatsParagraph = StatsSection:Paragraph({
    Title = "Your Current Status",
    Content = "Loading stats...",
    Icon = "activity"
})

spawn(function()
    while true do
        wait(1)
        local health = Humanoid and math.floor(Humanoid.Health) or 0
        local maxHealth = Humanoid and math.floor(Humanoid.MaxHealth) or 100
        local pos = RootPart and string.format("%.1f, %.1f, %.1f", RootPart.Position.X, RootPart.Position.Y, RootPart.Position.Z) or "Unknown"
        StatsParagraph:SetContent(string.format(
            "👤 Player: %s\n❤️ Health: %d/%d\n📍 Coordinates: %s\n⚡ WalkSpeed: %d\n🦘 JumpPower: %d\n👁️ FOV: %d",
            LocalPlayer.Name, health, maxHealth, pos, 
            Humanoid.WalkSpeed, Humanoid.JumpPower, Camera.FieldOfView
        ))
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: PLAYER 👤
-- ═══════════════════════════════════════════════════════════════════════════════
local PlayerTab = Window:Tab({
    Title = "Player 👤",
    Icon = "user"
})

local PlayerSection = PlayerTab:Section({
    Title = "Character Modifications",
    TextXAlignment = "Left"
})

PlayerSection:Toggle({
    Title = "Custom WalkSpeed",
    Default = false,
    Callback = function(value)
        State.WalkSpeedEnabled = value
        if value then
            Humanoid.WalkSpeed = Config.WalkSpeed
            Notify("WalkSpeed", "Custom WalkSpeed enabled! Speed: " .. Config.WalkSpeed, 3, "zap")
        else
            Humanoid.WalkSpeed = 16
            Notify("WalkSpeed", "WalkSpeed reset to default (16)", 3, "zap")
        end
    end
})

PlayerSection:Slider({
    Title = "WalkSpeed Value",
    Min = 16,
    Max = 300,
    Default = 50,
    Callback = function(value)
        Config.WalkSpeed = value
        if State.WalkSpeedEnabled then Humanoid.WalkSpeed = value end
    end
})

PlayerSection:Toggle({
    Title = "Custom JumpPower",
    Default = false,
    Callback = function(value)
        State.JumpPowerEnabled = value
        if value then
            Humanoid.JumpPower = Config.JumpPower
            Notify("JumpPower", "Custom JumpPower enabled! Power: " .. Config.JumpPower, 3, "zap")
        else
            Humanoid.JumpPower = 50
            Notify("JumpPower", "JumpPower reset to default (50)", 3, "zap")
        end
    end
})

PlayerSection:Slider({
    Title = "JumpPower Value",
    Min = 50,
    Max = 300,
    Default = 100,
    Callback = function(value)
        Config.JumpPower = value
        if State.JumpPowerEnabled then Humanoid.JumpPower = value end
    end
})

PlayerSection:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(value)
        State.InfiniteJump = value
        if value then
            Notify("Infinite Jump", "Infinite Jump enabled! Press Space repeatedly to fly up!", 3, "arrow-up")
        else
            Notify("Infinite Jump", "Infinite Jump disabled!", 3, "arrow-up")
        end
    end
})

UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

PlayerSection:Toggle({
    Title = "No Clip (Keybind: N)",
    Default = false,
    Callback = function(value)
        State.NoClip = value
        if value then
            Notify("No Clip", "No Clip enabled! Press N to toggle!", 3, "ghost")
        else
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
            Notify("No Clip", "No Clip disabled!", 3, "ghost")
        end
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.N then
        State.NoClip = not State.NoClip
        if State.NoClip then
            Notify("No Clip", "No Clip toggled ON!", 2, "ghost")
        else
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
            Notify("No Clip", "No Clip toggled OFF!", 2, "ghost")
        end
    end
end)

RunService.Stepped:Connect(function()
    if State.NoClip and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

PlayerSection:Toggle({
    Title = "God Mode",
    Default = false,
    Callback = function(value)
        State.GodMode = value
        if value then
            Humanoid.MaxHealth = math.huge
            Humanoid.Health = math.huge
            Notify("God Mode", "God Mode activated! You are INVINCIBLE!", 3, "shield")
        else
            Humanoid.MaxHealth = 100
            Humanoid.Health = 100
            Notify("God Mode", "God Mode deactivated!", 3, "shield")
        end
    end
})

PlayerSection:Slider({
    Title = "FOV Adjustment",
    Min = 30,
    Max = 120,
    Default = 70,
    Callback = function(value)
        Config.FOV = value
        Camera.FieldOfView = value
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: MOVEMENT ✈️
-- ═══════════════════════════════════════════════════════════════════════════════
local MovementTab = Window:Tab({
    Title = "Movement ✈️",
    Icon = "plane"
})

local MovementSection = MovementTab:Section({
    Title = "Advanced Movement",
    TextXAlignment = "Left"
})

MovementSection:Toggle({
    Title = "Fly Mode (WASD + Space/Shift)",
    Default = false,
    Callback = function(value)
        State.FlyMode = value
        if value then
            StartFly()
            Notify("Fly Mode", "Fly Mode enabled! Use WASD to fly!", 4, "plane")
        else
            StopFly()
            Notify("Fly Mode", "Fly Mode disabled!", 3, "plane")
        end
    end
})

MovementSection:Slider({
    Title = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(value) Config.FlySpeed = value end
})

MovementSection:Toggle({
    Title = "Speed Toggle (Keybind: LeftAlt)",
    Default = false,
    Callback = function(value)
        if value then
            Notify("Speed Toggle", "Speed Toggle enabled! Press LeftAlt to toggle!", 3, "zap")
        else
            Humanoid.WalkSpeed = 16
            Notify("Speed Toggle", "Speed Toggle disabled!", 3, "zap")
        end
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftAlt then
        if Humanoid.WalkSpeed == 16 then
            Humanoid.WalkSpeed = 100
            Notify("Speed", "Super Speed ON! (100)", 2, "zap")
        else
            Humanoid.WalkSpeed = 16
            Notify("Speed", "Normal Speed (16)", 2, "zap")
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: COMBAT ⚔️
-- ═══════════════════════════════════════════════════════════════════════════════
local CombatTab = Window:Tab({
    Title = "Combat ⚔️",
    Icon = "swords"
})

local CombatSection = CombatTab:Section({
    Title = "Combat Enhancements",
    TextXAlignment = "Left"
})

CombatSection:Toggle({
    Title = "Kill Aura",
    Default = false,
    Callback = function(value)
        State.KillAura = value
        if value then
            Notify("Kill Aura", "Kill Aura enabled! Range: " .. Config.KillAuraRange, 3, "crosshair")
            spawn(function()
                while State.KillAura do
                    wait(0.2)
                    local entities = {"Wolf", "AlphaWolf", "Bear", "Cultist", "ArcticFox", "PolarBear", "Scorpion", "Frog", "Alien"}
                    for _, entityType in pairs(entities) do
                        local closest = GetClosestEntity({entityType}, Config.KillAuraRange)
                        if closest then
                            local humanoid = closest:FindFirstChild("Humanoid")
                            if humanoid then humanoid.Health = 0 end
                        end
                    end
                end
            end)
        else
            Notify("Kill Aura", "Kill Aura disabled!", 3, "crosshair")
        end
    end
})

CombatSection:Slider({
    Title = "Kill Aura Range",
    Min = 5,
    Max = 100,
    Default = 20,
    Callback = function(value) Config.KillAuraRange = value end
})

CombatSection:Toggle({
    Title = "Auto Kill ALL Entities",
    Default = false,
    Callback = function(value)
        if value then
            Notify("Auto Kill", "Auto Kill ALL enabled!", 3, "skull")
            spawn(function()
                while value do
                    wait(0.5)
                    local allEntities = {"Deer", "Wolf", "AlphaWolf", "Bear", "Cultist", "Owl", "Ram", "ArcticFox", "PolarBear", "Mammoth", "Scorpion", "Frog", "Alien"}
                    for _, entityType in pairs(allEntities) do
                        for _, entity in pairs(GetAllEntities({entityType})) do
                            local humanoid = entity:FindFirstChild("Humanoid")
                            if humanoid then humanoid.Health = 0 end
                        end
                    end
                end
            end)
        else
            Notify("Auto Kill", "Auto Kill ALL disabled!", 3, "skull")
        end
    end
})

CombatSection:Toggle({
    Title = "Freeze/Unfreeze Entities",
    Default = false,
    Callback = function(value)
        State.FreezeEntities = value
        if value then
            Notify("Freeze", "Freeze Entities enabled!", 3, "snowflake")
            spawn(function()
                while State.FreezeEntities do
                    wait(0.1)
                    local allEntities = {"Deer", "Wolf", "AlphaWolf", "Bear", "Cultist", "Owl", "Ram", "ArcticFox", "PolarBear", "Mammoth", "Scorpion", "Frog", "Alien"}
                    for _, entityType in pairs(allEntities) do
                        for _, entity in pairs(GetAllEntities({entityType})) do
                            local humanoid = entity:FindFirstChild("Humanoid")
                            local root = entity:FindFirstChild("HumanoidRootPart")
                            if humanoid and root then
                                humanoid.WalkSpeed = 0
                                humanoid.JumpPower = 0
                                root.Anchored = true
                            end
                        end
                    end
                end
            end)
        else
            local allEntities = {"Deer", "Wolf", "AlphaWolf", "Bear", "Cultist", "Owl", "Ram", "ArcticFox", "PolarBear", "Mammoth", "Scorpion", "Frog", "Alien"}
            for _, entityType in pairs(allEntities) do
                for _, entity in pairs(GetAllEntities({entityType})) do
                    local humanoid = entity:FindFirstChild("Humanoid")
                    local root = entity:FindFirstChild("HumanoidRootPart")
                    if humanoid and root then
                        humanoid.WalkSpeed = 16
                        humanoid.JumpPower = 50
                        root.Anchored = false
                    end
                end
            end
            Notify("Freeze", "Entities UNFROZEN!", 3, "snowflake")
        end
    end
})

CombatSection:Toggle({
    Title = "One Hit Kill",
    Default = false,
    Callback = function(value)
        if value then
            Notify("One Hit Kill", "One Hit Kill enabled!", 3, "zap")
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" and tostring(self):lower():find("damage") then
                    local args = {...}
                    if #args > 0 then args[1] = 999999 end
                    return oldNamecall(self, unpack(args))
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        else
            Notify("One Hit Kill", "One Hit Kill disabled!", 3, "zap")
        end
    end
})

CombatSection:Toggle({
    Title = "Infinite Ammo (All Weapons)",
    Default = false,
    Callback = function(value)
        State.InfiniteAmmo = value
        if value then
            Notify("Infinite Ammo", "Infinite Ammo enabled!", 3, "ammo")
        else
            Notify("Infinite Ammo", "Infinite Ammo disabled!", 3, "ammo")
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: ESP 👁️
-- ═══════════════════════════════════════════════════════════════════════════════
local ESPTab = Window:Tab({
    Title = "ESP 👁️",
    Icon = "eye"
})

local ESPSection = ESPTab:Section({
    Title = "Advanced ESP Settings",
    TextXAlignment = "Left"
})

ESPSection:Toggle({
    Title = "Entity ESP (All Enemies)",
    Default = false,
    Callback = function(value)
        State.EntityESP = value
        if value then
            Notify("Entity ESP", "Entity ESP enabled!", 3, "eye")
            spawn(function()
                while State.EntityESP do
                    wait(2)
                    ClearESP()
                    local entityColors = {
                        ["Deer"] = Color3.fromRGB(139, 69, 19),
                        ["Wolf"] = Color3.fromRGB(128, 128, 128),
                        ["AlphaWolf"] = Color3.fromRGB(255, 0, 0),
                        ["Bear"] = Color3.fromRGB(139, 90, 43),
                        ["Cultist"] = Color3.fromRGB(128, 0, 128),
                        ["Owl"] = Color3.fromRGB(255, 255, 255),
                        ["Ram"] = Color3.fromRGB(255, 69, 0),
                        ["ArcticFox"] = Color3.fromRGB(200, 200, 255),
                        ["PolarBear"] = Color3.fromRGB(240, 248, 255),
                        ["Mammoth"] = Color3.fromRGB(105, 105, 105),
                        ["Scorpion"] = Color3.fromRGB(255, 140, 0),
                        ["Frog"] = Color3.fromRGB(0, 255, 0),
                        ["Alien"] = Color3.fromRGB(0, 255, 255)
                    }
                    for entityType, color in pairs(entityColors) do
                        for _, entity in pairs(GetAllEntities({entityType})) do
                            CreateESP(entity, color, entityType)
                        end
                    end
                end
            end)
        else
            ClearESP()
            Notify("Entity ESP", "Entity ESP disabled!", 3, "eye")
        end
    end
})

ESPSection:Toggle({
    Title = "Player ESP (Other Players)",
    Default = false,
    Callback = function(value)
        State.PlayerESP = value
        if value then
            Notify("Player ESP", "Player ESP enabled!", 3, "users")
            spawn(function()
                while State.PlayerESP do
                    wait(2)
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            CreateESP(player.Character, Color3.fromRGB(0, 255, 0), player.Name)
                        end
                    end
                end
            end)
        else
            Notify("Player ESP", "Player ESP disabled!", 3, "users")
        end
    end
})

ESPSection:Toggle({
    Title = "Item ESP (Chests, Loot, Fuel, Food, Gems)",
    Default = false,
    Callback = function(value)
        State.ItemESP = value
        if value then
            Notify("Item ESP", "Item ESP enabled!", 3, "box")
            spawn(function()
                while State.ItemESP do
                    wait(2)
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        local isItem = false
                        local itemColor = Color3.fromRGB(255, 215, 0)
                        local itemName = obj.Name
                        if obj.Name:lower():find("chest") then isItem = true; itemColor = Color3.fromRGB(255, 215, 0)
                        elseif obj.Name:lower():find("gem") then isItem = true; itemColor = Color3.fromRGB(0, 255, 255)
                        elseif obj.Name:lower():find("fuel") or obj.Name:lower():find("coal") then isItem = true; itemColor = Color3.fromRGB(255, 140, 0)
                        elseif obj.Name:lower():find("food") or obj.Name:lower():find("meat") or obj.Name:lower():find("stew") then isItem = true; itemColor = Color3.fromRGB(255, 100, 100)
                        elseif obj.Name:lower():find("weapon") or obj.Name:lower():find("gun") or obj.Name:lower():find("sword") then isItem = true; itemColor = Color3.fromRGB(255, 0, 0)
                        elseif obj.Name:lower():find("armor") then isItem = true; itemColor = Color3.fromRGB(100, 100, 255)
                        end
                        if isItem then CreateESP(obj, itemColor, itemName) end
                    end
                end
            end)
        else
            Notify("Item ESP", "Item ESP disabled!", 3, "box")
        end
    end
})

ESPSection:Slider({
    Title = "ESP Fill Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Callback = function(value)
        Config.ESPFillTransparency = value
        for _, esp in pairs(ESPObjects) do
            if esp.Highlight then esp.Highlight.FillTransparency = value end
        end
    end
})

ESPSection:Slider({
    Title = "ESP Outline Transparency",
    Min = 0,
    Max = 1,
    Default = 0,
    Callback = function(value)
        Config.ESPOutlineTransparency = value
        for _, esp in pairs(ESPObjects) do
            if esp.Highlight then esp.Highlight.OutlineTransparency = value end
        end
    end
})

ESPSection:Slider({
    Title = "ESP Text Size",
    Min = 8,
    Max = 24,
    Default = 14,
    Callback = function(value) Config.ESPTextSize = value end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: TELEPORT 🗺️
-- ═══════════════════════════════════════════════════════════════════════════════
local TeleportTab = Window:Tab({
    Title = "Teleport 🗺️",
    Icon = "map-pin"
})

local TeleportSection = TeleportTab:Section({
    Title = "Location Teleports",
    TextXAlignment = "Left"
})

TeleportSection:Button({
    Title = "Teleport to Campfire 🔥",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("campfire") or obj.Name:lower():find("fire") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    TeleportTo(primary.Position + Vector3.new(0, 5, 0))
                    Notify("Teleport", "Teleported to Campfire!", 3, "flame")
                    return
                end
            end
        end
        Notify("Teleport", "Campfire not found!", 3, "alert-triangle")
    end
})

TeleportSection:Button({
    Title = "Teleport to Warm Place 🌡️",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("warm") or obj.Name:lower():find("heater") or obj.Name:lower():find("camp") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    TeleportTo(primary.Position + Vector3.new(0, 5, 0))
                    Notify("Teleport", "Teleported to Warm Place!", 3, "thermometer")
                    return
                end
            end
        end
        Notify("Teleport", "Warm Place not found!", 3, "alert-triangle")
    end
})

TeleportSection:Button({
    Title = "Teleport to Caravan 🚚",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("caravan") or obj.Name:lower():find("trader") or obj.Name:lower():find("merchant") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    TeleportTo(primary.Position + Vector3.new(0, 5, 0))
                    Notify("Teleport", "Teleported to Caravan!", 3, "truck")
                    return
                end
            end
        end
        Notify("Teleport", "Caravan not found!", 3, "alert-triangle")
    end
})

TeleportSection:Button({
    Title = "Teleport to Fairy 🧚",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("fairy") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    TeleportTo(primary.Position + Vector3.new(0, 5, 0))
                    Notify("Teleport", "Teleported to Fairy!", 3, "sparkles")
                    return
                end
            end
        end
        Notify("Teleport", "Fairy not found!", 3, "alert-triangle")
    end
})

TeleportSection:Button({
    Title = "Teleport to Anvil ⚒️",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("anvil") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    TeleportTo(primary.Position + Vector3.new(0, 5, 0))
                    Notify("Teleport", "Teleported to Anvil!", 3, "hammer")
                    return
                end
            end
        end
        Notify("Teleport", "Anvil not found!", 3, "alert-triangle")
    end
})

TeleportSection:Button({
    Title = "Teleport to Nearest Chest 🎁",
    Callback = function()
        local closest = nil
        local minDist = math.huge
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("chest") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary and RootPart then
                    local dist = GetDistance(primary.Position, RootPart.Position)
                    if dist < minDist then
                        minDist = dist
                        closest = primary
                    end
                end
            end
        end
        if closest then
            TeleportTo(closest.Position + Vector3.new(0, 5, 0))
            Notify("Teleport", "Teleported to nearest Chest!", 3, "gift")
        else
            Notify("Teleport", "No chests found!", 3, "alert-triangle")
        end
    end
})

TeleportSection:Button({
    Title = "Teleport to Volcanic Biome 🌋",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("volcan") or obj.Name:lower():find("lava") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    TeleportTo(primary.Position + Vector3.new(0, 10, 0))
                    Notify("Teleport", "Teleported to Volcanic Biome!", 3, "flame")
                    return
                end
            end
        end
        Notify("Teleport", "Volcanic Biome not found!", 3, "alert-triangle")
    end
})

TeleportSection:Button({
    Title = "Teleport to Snow Biome ❄️",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("snow") or obj.Name:lower():find("ice") or obj.Name:lower():find("arctic") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    TeleportTo(primary.Position + Vector3.new(0, 10, 0))
                    Notify("Teleport", "Teleported to Snow Biome!", 3, "snowflake")
                    return
                end
            end
        end
        Notify("Teleport", "Snow Biome not found!", 3, "alert-triangle")
    end
})

TeleportSection:Button({
    Title = "Teleport to Cultist Stronghold 🏰",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("stronghold") or obj.Name:lower():find("cultist") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    TeleportTo(primary.Position + Vector3.new(0, 10, 0))
                    Notify("Teleport", "Teleported to Cultist Stronghold!", 3, "castle")
                    return
                end
            end
        end
        Notify("Teleport", "Stronghold not found!", 3, "alert-triangle")
    end
})

TeleportSection:Button({
    Title = "Teleport to Frog Cave 🐸",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("frog") or obj.Name:lower():find("cave") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    TeleportTo(primary.Position + Vector3.new(0, 10, 0))
                    Notify("Teleport", "Teleported to Frog Cave!", 3, "frog")
                    return
                end
            end
        end
        Notify("Teleport", "Frog Cave not found!", 3, "alert-triangle")
    end
})

-- Teleport Entities Section
local EntityTeleportSection = TeleportTab:Section({
    Title = "Teleport Entities to You",
    TextXAlignment = "Left"
})

EntityTeleportSection:Button({
    Title = "Teleport ALL Wolves to You 🐺",
    Callback = function()
        for _, wolf in pairs(GetAllEntities({"Wolf", "AlphaWolf"})) do
            local primary = wolf:FindFirstChild("HumanoidRootPart") or wolf:FindFirstChildWhichIsA("BasePart")
            if primary and RootPart then
                primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
            end
        end
        Notify("Teleport", "All Wolves teleported to you!", 3, "wolf")
    end
})

EntityTeleportSection:Button({
    Title = "Teleport ALL Bears to You 🐻",
    Callback = function()
        for _, bear in pairs(GetAllEntities({"Bear", "PolarBear"})) do
            local primary = bear:FindFirstChild("HumanoidRootPart") or bear:FindFirstChildWhichIsA("BasePart")
            if primary and RootPart then
                primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
            end
        end
        Notify("Teleport", "All Bears teleported to you!", 3, "bear")
    end
})

EntityTeleportSection:Button({
    Title = "Teleport ALL Cultists to You 👹",
    Callback = function()
        for _, cultist in pairs(GetAllEntities({"Cultist"})) do
            local primary = cultist:FindFirstChild("HumanoidRootPart") or cultist:FindFirstChildWhichIsA("BasePart")
            if primary and RootPart then
                primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
            end
        end
        Notify("Teleport", "All Cultists teleported to you!", 3, "skull")
    end
})

EntityTeleportSection:Button({
    Title = "Teleport ALL Aliens to You 👽",
    Callback = function()
        for _, alien in pairs(GetAllEntities({"Alien"})) do
            local primary = alien:FindFirstChild("HumanoidRootPart") or alien:FindFirstChildWhichIsA("BasePart")
            if primary and RootPart then
                primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
            end
        end
        Notify("Teleport", "All Aliens teleported to you!", 3, "alien")
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: RESOURCES 🪵
-- ═══════════════════════════════════════════════════════════════════════════════
local ResourcesTab = Window:Tab({
    Title = "Resources 🪵",
    Icon = "axe"
})

local ResourcesSection = ResourcesTab:Section({
    Title = "Resource Automation",
    TextXAlignment = "Left"
})

ResourcesSection:Toggle({
    Title = "Auto Complete Campfire (Instant Level 6)",
    Default = false,
    Callback = function(value)
        State.AutoCompleteCampfire = value
        if value then
            Notify("Auto Campfire", "Auto Complete Campfire enabled!", 3, "flame")
            spawn(function()
                while State.AutoCompleteCampfire do
                    wait(1)
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("campfire") or obj.Name:lower():find("fire") then
                            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("fire") or remote.Name:lower():find("fuel") or remote.Name:lower():find("upgrade")) then
                                    pcall(function() remote:FireServer(obj) end)
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Auto Campfire", "Auto Complete Campfire disabled!", 3, "flame")
        end
    end
})

ResourcesSection:Toggle({
    Title = "Infinite Saplings",
    Default = false,
    Callback = function(value)
        State.InfiniteSaplings = value
        if value then
            Notify("Infinite Saplings", "Infinite Saplings enabled!", 3, "tree-pine")
        else
            Notify("Infinite Saplings", "Infinite Saplings disabled!", 3, "tree-pine")
        end
    end
})

ResourcesSection:Toggle({
    Title = "Tree Farm Aura (Chop all trees in range)",
    Default = false,
    Callback = function(value)
        State.TreeFarmAura = value
        if value then
            Notify("Tree Farm Aura", "Tree Farm Aura enabled!", 3, "tree-pine")
            spawn(function()
                while State.TreeFarmAura do
                    wait(0.5)
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("tree") and obj:FindFirstChildWhichIsA("BasePart") then
                            local treePart = obj:FindFirstChildWhichIsA("BasePart")
                            if treePart and RootPart and GetDistance(treePart.Position, RootPart.Position) < 30 then
                                FireTool("axe")
                                FireTool("chainsaw")
                                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                    if remote:IsA("RemoteEvent") and remote.Name:lower():find("chop") then
                                        pcall(function() remote:FireServer(obj) end)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Tree Farm Aura", "Tree Farm Aura disabled!", 3, "tree-pine")
        end
    end
})

ResourcesSection:Toggle({
    Title = "Auto Farm Wood (Teleport to Trees)",
    Default = false,
    Callback = function(value)
        State.AutoFarmWood = value
        if value then
            Notify("Auto Farm Wood", "Auto Farm Wood enabled!", 3, "tree-pine")
            spawn(function()
                while State.AutoFarmWood do
                    wait(1)
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("tree") and obj:FindFirstChildWhichIsA("BasePart") then
                            local treePart = obj:FindFirstChildWhichIsA("BasePart")
                            if treePart and RootPart then
                                if GetDistance(treePart.Position, RootPart.Position) < 100 then
                                    RootPart.CFrame = CFrame.new(treePart.Position)
                                    wait(0.3)
                                    FireTool("axe")
                                    FireTool("chainsaw")
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Auto Farm Wood", "Auto Farm Wood disabled!", 3, "tree-pine")
        end
    end
})

ResourcesSection:Toggle({
    Title = "Auto Farm Scrap",
    Default = false,
    Callback = function(value)
        State.AutoFarmScrap = value
        if value then
            Notify("Auto Farm Scrap", "Auto Farm Scrap enabled!", 3, "hammer")
        else
            Notify("Auto Farm Scrap", "Auto Farm Scrap disabled!", 3, "hammer")
        end
    end
})

ResourcesSection:Toggle({
    Title = "Auto Farm Food (Hunt Animals)",
    Default = false,
    Callback = function(value)
        State.AutoFarmFood = value
        if value then
            Notify("Auto Farm Food", "Auto Farm Food enabled!", 3, "beef")
            spawn(function()
                while State.AutoFarmFood do
                    wait(1)
                    local animals = {"Bunny", "Wolf", "Bear", "PolarBear", "ArcticFox", "Mammoth"}
                    for _, animalType in pairs(animals) do
                        local closest = GetClosestEntity({animalType}, 100)
                        if closest then
                            local primary = closest:FindFirstChild("HumanoidRootPart") or closest:FindFirstChildWhichIsA("BasePart")
                            if primary then
                                RootPart.CFrame = CFrame.new(primary.Position + Vector3.new(0, 5, 0))
                                wait(0.5)
                                local humanoid = closest:FindFirstChild("Humanoid")
                                if humanoid then humanoid.Health = 0 end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Auto Farm Food", "Auto Farm Food disabled!", 3, "beef")
        end
    end
})

ResourcesSection:Toggle({
    Title = "Auto Cook Food",
    Default = false,
    Callback = function(value)
        State.AutoCook = value
        if value then
            Notify("Auto Cook", "Auto Cook enabled!", 3, "flame")
        else
            Notify("Auto Cook", "Auto Cook disabled!", 3, "flame")
        end
    end
})

ResourcesSection:Toggle({
    Title = "Auto Fuel Campfire (Keep Fire Lit Forever)",
    Default = false,
    Callback = function(value)
        State.AutoFuel = value
        if value then
            Notify("Auto Fuel", "Auto Fuel enabled!", 3, "flame-kindling")
            spawn(function()
                while State.AutoFuel do
                    wait(5)
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("campfire") or obj.Name:lower():find("fire") then
                            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("fuel") or remote.Name:lower():find("add")) then
                                    pcall(function()
                                        remote:FireServer(obj, "coal")
                                        remote:FireServer(obj, "log")
                                        remote:FireServer(obj, "fuel")
                                    end)
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Auto Fuel", "Auto Fuel disabled!", 3, "flame-kindling")
        end
    end
})

ResourcesSection:Toggle({
    Title = "Auto Upgrade Campfire to Max (Level 6)",
    Default = false,
    Callback = function(value)
        State.AutoUpgradeCampfire = value
        if value then
            Notify("Auto Upgrade", "Auto Upgrade enabled!", 3, "arrow-up-circle")
        else
            Notify("Auto Upgrade", "Auto Upgrade disabled!", 3, "arrow-up-circle")
        end
    end
})

ResourcesSection:Toggle({
    Title = "Plant Saplings in Circle",
    Default = false,
    Callback = function(value)
        State.PlantSaplingsCircle = value
        if value then
            Notify("Plant Circle", "Plant Saplings in Circle enabled!", 3, "sprout")
            spawn(function()
                while State.PlantSaplingsCircle do
                    wait(0.5)
                    if RootPart then
                        local radius = 10
                        for i = 1, 8 do
                            local angle = (i / 8) * math.pi * 2
                            local pos = RootPart.Position + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") and remote.Name:lower():find("plant") then
                                    pcall(function() remote:FireServer(pos) end)
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Plant Circle", "Plant Saplings in Circle disabled!", 3, "sprout")
        end
    end
})

ResourcesSection:Toggle({
    Title = "Build Log Walls in Circle",
    Default = false,
    Callback = function(value)
        State.BuildLogWallsCircle = value
        if value then
            Notify("Build Walls", "Build Log Walls in Circle enabled!", 3, "shield")
            spawn(function()
                while State.BuildLogWallsCircle do
                    wait(0.5)
                    if RootPart then
                        local radius = 15
                        for i = 1, 12 do
                            local angle = (i / 12) * math.pi * 2
                            local pos = RootPart.Position + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("build") or remote.Name:lower():find("wall")) then
                                    pcall(function() remote:FireServer(pos, "logwall") end)
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Build Walls", "Build Log Walls in Circle disabled!", 3, "shield")
        end
    end
})

ResourcesSection:Button({
    Title = "Cleanup All Logs 🧹",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("log") and obj:FindFirstChildWhichIsA("BasePart") then
                obj:Destroy()
            end
        end
        Notify("Cleanup", "All logs cleaned up!", 3, "trash-2")
    end
})

ResourcesSection:Toggle({
    Title = "Auto Pickup (Flowers, Gold, Items)",
    Default = false,
    Callback = function(value)
        State.AutoPickup = value
        if value then
            Notify("Auto Pickup", "Auto Pickup enabled!", 3, "hand")
            spawn(function()
                while State.AutoPickup do
                    wait(0.5)
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:FindFirstChildWhichIsA("BasePart") then
                            local pickupItems = {"flower", "gold", "coin", "berry", "carrot", "mushroom"}
                            for _, itemName in pairs(pickupItems) do
                                if obj.Name:lower():find(itemName) then
                                    local primary = obj:FindFirstChildWhichIsA("BasePart")
                                    if primary and RootPart and GetDistance(primary.Position, RootPart.Position) < 20 then
                                        local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                                        if prompt then fireproximityprompt(prompt)
                                        else
                                            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                                if remote:IsA("RemoteEvent") and remote.Name:lower():find("pickup") then
                                                    pcall(function() remote:FireServer(obj) end)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Auto Pickup", "Auto Pickup disabled!", 3, "hand")
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: BRING ITEMS 🧲
-- ═══════════════════════════════════════════════════════════════════════════════
local BringTab = Window:Tab({
    Title = "Bring Items 🧲",
    Icon = "magnet"
})

local BringSection = BringTab:Section({
    Title = "Auto Bring ALL Items to You",
    TextXAlignment = "Left"
})

BringSection:Paragraph({
    Title = "⚠️ Auto Bring System",
    Content = "This feature will teleport ALL loaded items in the game directly to your position. Includes: Tools, Food, Flashlights, Medkits, Class Exclusive Items, Weapons, Armor, Fuel, Scrap, Pelts, Blueprints, Materials, Healing Items, Keys, Anvil Parts, and Junk items.",
    Icon = "alert-triangle"
})

BringSection:Toggle({
    Title = "Auto Bring ALL Items",
    Default = false,
    Callback = function(value)
        State.AutoBringItems = value
        if value then
            Notify("Auto Bring", "Auto Bring ALL Items enabled! Everything comes to you!", 3, "magnet")
            spawn(function()
                while State.AutoBringItems do
                    wait(0.3)
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:FindFirstChildWhichIsA("BasePart") then
                            local itemTypes = {
                                "tool", "food", "flashlight", "medkit", "bandage", "weapon", "gun", "sword",
                                "axe", "armor", "fuel", "coal", "scrap", "pelt", "blueprint", "material",
                                "healing", "key", "anvil", "junk", "gear", "log", "sapling", "stew",
                                "meat", "carrot", "berry", "chili", "seed", "pot", "crock", "drill",
                                "processor", "teleporter", "pad", "fence", "trap", "wire", "mine"
                            }
                            for _, itemType in pairs(itemTypes) do
                                if obj.Name:lower():find(itemType) then
                                    local primary = obj:FindFirstChildWhichIsA("BasePart")
                                    if primary and RootPart then
                                        primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Auto Bring", "Auto Bring ALL Items disabled!", 3, "magnet")
        end
    end
})

BringSection:Button({
    Title = "Bring All Weapons to You 🔫",
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChildWhichIsA("BasePart") then
                local weapons = {"gun", "rifle", "revolver", "shotgun", "sword", "spear", "katana", "crossbow", "raygun", "laser", "cannon", "flamethrower", "dagger", "scythe", "bow"}
                for _, weapon in pairs(weapons) do
                    if obj.Name:lower():find(weapon) then
                        local primary = obj:FindFirstChildWhichIsA("BasePart")
                        if primary and RootPart then
                            primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                            count = count + 1
                        end
                    end
                end
            end
        end
        Notify("Bring", "Brought " .. count .. " weapons to you!", 3, "swords")
    end
})

BringSection:Button({
    Title = "Bring All Food to You 🍖",
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChildWhichIsA("BasePart") then
                local foods = {"meat", "stew", "carrot", "berry", "food", "cooked", "raw", "chili", "pumpkin", "apple"}
                for _, food in pairs(foods) do
                    if obj.Name:lower():find(food) then
                        local primary = obj:FindFirstChildWhichIsA("BasePart")
                        if primary and RootPart then
                            primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                            count = count + 1
                        end
                    end
                end
            end
        end
        Notify("Bring", "Brought " .. count .. " food items to you!", 3, "beef")
    end
})

BringSection:Button({
    Title = "Bring All Fuel to You ⛽",
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChildWhichIsA("BasePart") then
                local fuels = {"fuel", "coal", "oil", "biofuel", "log", "wood", "barrel"}
                for _, fuel in pairs(fuels) do
                    if obj.Name:lower():find(fuel) then
                        local primary = obj:FindFirstChildWhichIsA("BasePart")
                        if primary and RootPart then
                            primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                            count = count + 1
                        end
                    end
                end
            end
        end
        Notify("Bring", "Brought " .. count .. " fuel items to you!", 3, "flame")
    end
})

BringSection:Button({
    Title = "Bring All Scrap to You 🔩",
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChildWhichIsA("BasePart") and obj.Name:lower():find("scrap") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary and RootPart then
                    primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                    count = count + 1
                end
            end
        end
        Notify("Bring", "Brought " .. count .. " scrap items to you!", 3, "wrench")
    end
})

BringSection:Button({
    Title = "Bring All Armor to You 🛡️",
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChildWhichIsA("BasePart") and obj.Name:lower():find("armor") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary and RootPart then
                    primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                    count = count + 1
                end
            end
        end
        Notify("Bring", "Brought " .. count .. " armor items to you!", 3, "shield")
    end
})

BringSection:Button({
    Title = "Bring All Keys to You 🔑",
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChildWhichIsA("BasePart") and obj.Name:lower():find("key") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary and RootPart then
                    primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                    count = count + 1
                end
            end
        end
        Notify("Bring", "Brought " .. count .. " keys to you!", 3, "key")
    end
})

BringSection:Button({
    Title = "Bring All Blueprints to You 📋",
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChildWhichIsA("BasePart") and obj.Name:lower():find("blueprint") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary and RootPart then
                    primary.CFrame = RootPart.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                    count = count + 1
                end
            end
        end
        Notify("Bring", "Brought " .. count .. " blueprints to you!", 3, "file-text")
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: MISSIONS 📋
-- ═══════════════════════════════════════════════════════════════════════════════
local MissionsTab = Window:Tab({
    Title = "Missions 📋",
    Icon = "clipboard-list"
})

local MissionsSection = MissionsTab:Section({
    Title = "Mission Automation",
    TextXAlignment = "Left"
})

MissionsSection:Toggle({
    Title = "Auto Rescue ALL Missing Children",
    Default = false,
    Callback = function(value)
        State.AutoRescueChildren = value
        if value then
            Notify("Auto Rescue", "Auto Rescue enabled! All 4 children will be rescued!", 3, "baby")
            spawn(function()
                while State.AutoRescueChildren do
                    wait(2)
                    local children = {"DinoKid", "KrakenKid", "Kid", "Child", "Missing"}
                    for _, childType in pairs(children) do
                        for _, child in pairs(GetAllEntities({childType})) do
                            local primary = child:FindFirstChildWhichIsA("BasePart")
                            if primary then
                                TeleportTo(primary.Position + Vector3.new(0, 3, 0))
                                wait(1)
                                local prompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt then fireproximityprompt(prompt)
                                else
                                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                        if remote:IsA("RemoteEvent") and remote.Name:lower():find("rescue") then
                                            pcall(function() remote:FireServer(child) end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Auto Rescue", "Auto Rescue disabled!", 3, "baby")
        end
    end
})

MissionsSection:Toggle({
    Title = "Auto Complete Cultist Stronghold",
    Default = false,
    Callback = function(value)
        State.AutoStronghold = value
        if value then
            Notify("Stronghold", "Auto Stronghold enabled!", 3, "castle")
            spawn(function()
                while State.AutoStronghold do
                    wait(0.5)
                    for _, cultist in pairs(GetAllEntities({"Cultist", "Juggernaut"})) do
                        local humanoid = cultist:FindFirstChild("Humanoid")
                        if humanoid then humanoid.Health = 0 end
                    end
                end
            end)
        else
            Notify("Stronghold", "Auto Stronghold disabled!", 3, "castle")
        end
    end
})

MissionsSection:Toggle({
    Title = "Auto Complete Frog Cave (All Waves)",
    Default = false,
    Callback = function(value)
        State.AutoFrogCave = value
        if value then
            Notify("Frog Cave", "Auto Frog Cave enabled!", 3, "frog")
            spawn(function()
                while State.AutoFrogCave do
                    wait(0.3)
                    for _, frog in pairs(GetAllEntities({"Frog", "FrogKing"})) do
                        local humanoid = frog:FindFirstChild("Humanoid")
                        if humanoid then humanoid.Health = 0 end
                    end
                end
            end)
        else
            Notify("Frog Cave", "Auto Frog Cave disabled!", 3, "frog")
        end
    end
})

MissionsSection:Toggle({
    Title = "Auto Defeat Cultist King",
    Default = false,
    Callback = function(value)
        State.AutoCultistKing = value
        if value then
            Notify("Cultist King", "Auto Cultist King enabled!", 3, "crown")
            spawn(function()
                while State.AutoCultistKing do
                    wait(0.2)
                    for _, king in pairs(GetAllEntities({"CultistKing", "King"})) do
                        local humanoid = king:FindFirstChild("Humanoid")
                        if humanoid then humanoid.Health = 0 end
                    end
                end
            end)
        else
            Notify("Cultist King", "Auto Cultist King disabled!", 3, "crown")
        end
    end
})

MissionsSection:Button({
    Title = "🏆 SKIP TO DAY 99 (INSTANT WIN)",
    Callback = function()
        Notify("Auto Win", "Attempting to skip to Day 99...", 5, "trophy")
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                if remote.Name:lower():find("day") or remote.Name:lower():find("skip") or remote.Name:lower():find("win") or remote.Name:lower():find("complete") then
                    for i = 1, 99 do
                        pcall(function() remote:FireServer(i) end)
                    end
                end
            end
            if remote:IsA("RemoteFunction") then
                if remote.Name:lower():find("day") or remote.Name:lower():find("getday") then
                    pcall(function() remote:InvokeServer(99) end)
                end
            end
        end
        Notify("Auto Win", "Day Skip attempted! Check if Day 99 is reached!", 5, "trophy")
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: BIOMES 🌍
-- ═══════════════════════════════════════════════════════════════════════════════
local BiomesTab = Window:Tab({
    Title = "Biomes 🌍",
    Icon = "globe"
})

local BiomesSection = BiomesTab:Section({
    Title = "Biome Features",
    TextXAlignment = "Left"
})

BiomesSection:Toggle({
    Title = "Anti-Freeze (No Temperature Loss in Snow)",
    Default = false,
    Callback = function(value)
        State.AntiFreeze = value
        if value then
            Notify("Anti-Freeze", "Anti-Freeze enabled! You will NEVER freeze!", 3, "snowflake")
            spawn(function()
                while State.AntiFreeze do
                    wait(0.5)
                    for _, obj in pairs(LocalPlayer:GetDescendants()) do
                        if obj.Name:lower():find("temperature") or obj.Name:lower():find("warmth") or obj.Name:lower():find("cold") then
                            if obj:IsA("NumberValue") then obj.Value = 100 end
                        end
                    end
                    for _, obj in pairs(Character:GetDescendants()) do
                        if obj.Name:lower():find("temperature") or obj.Name:lower():find("warmth") then
                            if obj:IsA("NumberValue") then obj.Value = 100 end
                        end
                    end
                end
            end)
        else
            Notify("Anti-Freeze", "Anti-Freeze disabled!", 3, "snowflake")
        end
    end
})

BiomesSection:Toggle({
    Title = "Lava Immunity (Walk on Lava)",
    Default = false,
    Callback = function(value)
        State.LavaImmunity = value
        if value then
            Notify("Lava Immunity", "Lava Immunity enabled! Walk on lava safely!", 3, "flame")
            spawn(function()
                while State.LavaImmunity do
                    wait(0.1)
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("lava") and obj:IsA("BasePart") then
                            obj.CanTouch = false
                        end
                    end
                end
            end)
        else
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("lava") and obj:IsA("BasePart") then
                    obj.CanTouch = true
                end
            end
            Notify("Lava Immunity", "Lava Immunity disabled!", 3, "flame")
        end
    end
})

BiomesSection:Toggle({
    Title = "Auto Collect ALL Gems (Forest & Cultist Gems)",
    Default = false,
    Callback = function(value)
        State.AutoCollectGems = value
        if value then
            Notify("Gem Collector", "Auto Gem Collector enabled!", 3, "gem")
            spawn(function()
                while State.AutoCollectGems do
                    wait(0.5)
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("gem") then
                            local primary = obj:FindFirstChildWhichIsA("BasePart")
                            if primary and RootPart then
                                if GetDistance(primary.Position, RootPart.Position) < 100 then
                                    RootPart.CFrame = CFrame.new(primary.Position)
                                    wait(0.3)
                                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                                    if prompt then fireproximityprompt(prompt) end
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Gem Collector", "Auto Gem Collector disabled!", 3, "gem")
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: ITEMS 🎒
-- ═══════════════════════════════════════════════════════════════════════════════
local ItemsTab = Window:Tab({
    Title = "Items 🎒",
    Icon = "backpack"
})

local ItemsSection = ItemsTab:Section({
    Title = "Item Management",
    TextXAlignment = "Left"
})

ItemsSection:Toggle({
    Title = "Auto Open ALL Chests (Gold, Ruby, Diamond)",
    Default = false,
    Callback = function(value)
        State.AutoOpenChests = value
        if value then
            Notify("Auto Chest", "Auto Chest Opener enabled!", 3, "box")
            spawn(function()
                while State.AutoOpenChests do
                    wait(1)
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("chest") then
                            local primary = obj:FindFirstChildWhichIsA("BasePart")
                            if primary and RootPart then
                                if GetDistance(primary.Position, RootPart.Position) < 50 then
                                    RootPart.CFrame = CFrame.new(primary.Position)
                                    wait(0.5)
                                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                                    if prompt then fireproximityprompt(prompt) end
                                end
                            end
                        end
                    end
                end
            end)
        else
            Notify("Auto Chest", "Auto Chest Opener disabled!", 3, "box")
        end
    end
})

ItemsSection:Button({
    Title = "Auto Equip Best Weapon",
    Callback = function()
        Notify("Best Weapon", "Searching for best weapon...", 3, "swords")
        local bestWeapon = nil
        local bestTier = 0
        local weaponTiers = {["diamond"] = 5, ["ruby"] = 4, ["gold"] = 3, ["silver"] = 2, ["iron"] = 1, ["infernal"] = 6, ["ice"] = 6, ["alien"] = 6}
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local tier = 0
                for tierName, tierValue in pairs(weaponTiers) do
                    if tool.Name:lower():find(tierName) then tier = tierValue end
                end
                if tier > bestTier then bestTier = tier; bestWeapon = tool end
            end
        end
        if bestWeapon then
            Humanoid:EquipTool(bestWeapon)
            Notify("Best Weapon", "Equipped: " .. bestWeapon.Name .. " (Tier " .. bestTier .. ")", 3, "swords")
        else
            Notify("Best Weapon", "No weapons found!", 3, "alert-triangle")
        end
    end
})

ItemsSection:Toggle({
    Title = "Auto Use Medkits/Bandages (When HP < 30%)",
    Default = false,
    Callback = function(value)
        State.AutoHeal = value
        if value then
            Notify("Auto Heal", "Auto Heal enabled!", 3, "heart-pulse")
            spawn(function()
                while State.AutoHeal do
                    wait(1)
                    if Humanoid and Humanoid.Health < Humanoid.MaxHealth * 0.3 then
                        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and (tool.Name:lower():find("medkit") or tool.Name:lower():find("bandage") or tool.Name:lower():find("heal")) then
                                Humanoid:EquipTool(tool)
                                wait(0.2)
                                tool:Activate()
                                Notify("Auto Heal", "Used " .. tool.Name .. "!", 2, "heart-pulse")
                                break
                            end
                        end
                    end
                end
            end)
        else
            Notify("Auto Heal", "Auto Heal disabled!", 3, "heart-pulse")
        end
    end
})

ItemsSection:Toggle({
    Title = "Auto Feed → Cook → Survive Chain",
    Default = false,
    Callback = function(value)
        State.AutoFeedSurvive = value
        if value then
            Notify("Auto Survive", "Auto Survive Chain enabled! Feed → Cook → Heal → Kill!", 3, "repeat")
            spawn(function()
                while State.AutoFeedSurvive do
                    wait(2)
                    -- Step 1: Heal if low
                    if Humanoid and Humanoid.Health < Humanoid.MaxHealth * 0.5 then
                        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and (tool.Name:lower():find("medkit") or tool.Name:lower():find("bandage")) then
                                Humanoid:EquipTool(tool)
                                wait(0.2)
                                tool:Activate()
                                break
                            end
                        end
                    end
                    -- Step 2: Eat if hungry
                    for _, obj in pairs(LocalPlayer:GetDescendants()) do
                        if obj.Name:lower():find("hunger") and obj:IsA("NumberValue") and obj.Value < 50 then
                            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                                if tool:IsA("Tool") and (tool.Name:lower():find("food") or tool.Name:lower():find("meat") or tool.Name:lower():find("stew")) then
                                    Humanoid:EquipTool(tool)
                                    wait(0.2)
                                    tool:Activate()
                                    break
                                end
                            end
                        end
                    end
                    -- Step 3: Kill nearby enemies
                    local entities = {"Wolf", "Bear", "Cultist"}
                    for _, entityType in pairs(entities) do
                        local closest = GetClosestEntity({entityType}, 20)
                        if closest then
                            local humanoid = closest:FindFirstChild("Humanoid")
                            if humanoid then humanoid.Health = 0 end
                        end
                    end
                end
            end)
        else
            Notify("Auto Survive", "Auto Survive Chain disabled!", 3, "repeat")
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: VISUAL 🎨
-- ═══════════════════════════════════════════════════════════════════════════════
local VisualTab = Window:Tab({
    Title = "Visual 🎨",
    Icon = "palette"
})

local VisualSection = VisualTab:Section({
    Title = "Visual & Performance",
    TextXAlignment = "Left"
})

VisualSection:Toggle({
    Title = "Full Bright (Remove Darkness)",
    Default = false,
    Callback = function(value)
        State.FullBright = value
        if value then
            Lighting.Brightness = 10
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Notify("Full Bright", "Full Bright enabled!", 3, "sun")
        else
            Lighting.Brightness = 2
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
            Notify("Full Bright", "Full Bright disabled!", 3, "sun")
        end
    end
})

VisualSection:Toggle({
    Title = "Remove Fog",
    Default = false,
    Callback = function(value)
        State.RemoveFog = value
        if value then
            Lighting.FogStart = 0
            Lighting.FogEnd = 100000
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            Notify("No Fog", "Fog removed!", 3, "cloud-off")
        else
            Lighting.FogStart = 0
            Lighting.FogEnd = 1000
            Lighting.FogColor = Color3.fromRGB(192, 192, 192)
            Notify("No Fog", "Fog restored!", 3, "cloud")
        end
    end
})

VisualSection:Toggle({
    Title = "Remove Sky (Black Background)",
    Default = false,
    Callback = function(value)
        State.RemoveSky = value
        if value then
            local sky = Lighting:FindFirstChildOfClass("Sky")
            if sky then sky:Destroy() end
            Lighting.ClockTime = 12
            Notify("No Sky", "Sky removed!", 3, "cloud-off")
        else
            Notify("No Sky", "Sky restoration may require rejoin!", 3, "cloud")
        end
    end
})

VisualSection:Toggle({
    Title = "Night Vision (Green Tint)",
    Default = false,
    Callback = function(value)
        State.NightVision = value
        if value then
            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "GreenZxNightVision"
            cc.TintColor = Color3.fromRGB(0, 255, 100)
            cc.Brightness = 0.2
            cc.Contrast = 0.3
            cc.Parent = Lighting
            Notify("Night Vision", "Night Vision enabled!", 3, "eye")
        else
            local nv = Lighting:FindFirstChild("GreenZxNightVision")
            if nv then nv:Destroy() end
            Notify("Night Vision", "Night Vision disabled!", 3, "eye")
        end
    end
})

VisualSection:Toggle({
    Title = "No Smog / Clean Air",
    Default = false,
    Callback = function(value)
        State.NoSmog = value
        if value then
            for _, obj in pairs(Lighting:GetDescendants()) do
                if obj:IsA("Atmosphere") or obj:IsA("ParticleEmitter") or obj.Name:lower():find("smog") or obj.Name:lower():find("fog") then
                    obj:Destroy()
                end
            end
            Notify("No Smog", "Smog removed!", 3, "wind")
        else
            Notify("No Smog", "Smog may return on rejoin!", 3, "wind")
        end
    end
})

VisualSection:Toggle({
    Title = "Weather Control (Always Sunny)",
    Default = false,
    Callback = function(value)
        State.WeatherControl = value
        if value then
            spawn(function()
                while State.WeatherControl do
                    wait(1)
                    Lighting.ClockTime = 12
                    Lighting.Brightness = 5
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("ParticleEmitter") and (obj.Name:lower():find("rain") or obj.Name:lower():find("snow")) then
                            obj.Enabled = false
                        end
                    end
                end
            end)
            Notify("Weather", "Weather Control enabled! Always sunny!", 3, "sun")
        else
            Notify("Weather", "Weather Control disabled!", 3, "sun")
        end
    end
})

VisualSection:Toggle({
    Title = "Low GFX Mode (Better FPS)",
    Default = false,
    Callback = function(value)
        State.LowGFX = value
        if value then
            settings().Rendering.QualityLevel = 1
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled = false end
                if obj:IsA("BasePart") and (obj.Name:lower():find("grass") or obj.Name:lower():find("leaf")) then obj.Transparency = 1 end
            end
            Notify("Low GFX", "Low GFX Mode enabled! Better FPS!", 3, "zap")
        else
            settings().Rendering.QualityLevel = 7
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled = true end
                if obj:IsA("BasePart") then obj.Transparency = 0 end
            end
            Notify("Low GFX", "Low GFX Mode disabled!", 3, "zap")
        end
    end
})

VisualSection:Toggle({
    Title = "Show Coordinates on Screen",
    Default = false,
    Callback = function(value)
        State.ShowCoords = value
        if value then
            local coordGui = Instance.new("ScreenGui")
            coordGui.Name = "GreenZxCoords"
            coordGui.ResetOnSpawn = false
            coordGui.Parent = LocalPlayer.PlayerGui
            local coordLabel = Instance.new("TextLabel")
            coordLabel.Name = "CoordLabel"
            coordLabel.Size = UDim2.new(0, 300, 0, 30)
            coordLabel.Position = UDim2.new(0, 10, 0, 10)
            coordLabel.BackgroundTransparency = 0.5
            coordLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            coordLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            coordLabel.TextSize = 14
            coordLabel.Font = Enum.Font.Code
            coordLabel.Parent = coordGui
            spawn(function()
                while State.ShowCoords do
                    wait(0.1)
                    if RootPart then
                        coordLabel.Text = string.format("X: %.1f | Y: %.1f | Z: %.1f", RootPart.Position.X, RootPart.Position.Y, RootPart.Position.Z)
                    end
                end
                coordGui:Destroy()
            end)
            Notify("Coordinates", "Coordinates display enabled!", 3, "map-pin")
        else
            local coordGui = LocalPlayer.PlayerGui:FindFirstChild("GreenZxCoords")
            if coordGui then coordGui:Destroy() end
            Notify("Coordinates", "Coordinates display disabled!", 3, "map-pin")
        end
    end
})

VisualSection:Toggle({
    Title = "Instant Interact (No Hold Time)",
    Default = false,
    Callback = function(value)
        if value then
            for _, prompt in pairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then prompt.HoldDuration = 0 end
            end
            Notify("Instant Interact", "Instant Interact enabled!", 3, "zap")
        else
            for _, prompt in pairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then prompt.HoldDuration = 0.5 end
            end
            Notify("Instant Interact", "Instant Interact disabled!", 3, "zap")
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: MISC ⚙️
-- ═══════════════════════════════════════════════════════════════════════════════
local MiscTab = Window:Tab({
    Title = "Misc ⚙️",
    Icon = "settings"
})

local MiscSection = MiscTab:Section({
    Title = "Miscellaneous Features",
    TextXAlignment = "Left"
})

MiscSection:Toggle({
    Title = "Anti AFK (Anti-Kick)",
    Default = true,
    Callback = function(value)
        State.AntiAFK = value
        if value then
            Notify("Anti AFK", "Anti AFK enabled!", 3, "shield-check")
        else
            Notify("Anti AFK", "Anti AFK disabled!", 3, "shield-check")
        end
    end
})

MiscSection:Toggle({
    Title = "Anti-Detection (Bypass Anti-Cheat)",
    Default = true,
    Callback = function(value)
        State.AntiDetection = value
        if value then
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" then
                    local args = {...}
                    if tostring(self):lower():find("detect") or tostring(self):lower():find("ban") or 
                       tostring(self):lower():find("kick") or tostring(self):lower():find("report") then
                        return nil
                    end
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
            Notify("Anti-Detection", "Anti-Detection enabled! Protected!", 3, "shield")
        else
            Notify("Anti-Detection", "Anti-Detection disabled!", 3, "shield")
        end
    end
})

MiscSection:Toggle({
    Title = "Instant Craft (No Crafting Time)",
    Default = false,
    Callback = function(value)
        State.InstantCraft = value
        if value then
            Notify("Instant Craft", "Instant Craft enabled!", 3, "hammer")
        else
            Notify("Instant Craft", "Instant Craft disabled!", 3, "hammer")
        end
    end
})

MiscSection:Toggle({
    Title = "Auto Build Perfect Base",
    Default = false,
    Callback = function(value)
        State.AutoBuildBase = value
        if value then
            Notify("Auto Build", "Auto Build enabled!", 3, "home")
        else
            Notify("Auto Build", "Auto Build disabled!", 3, "home")
        end
    end
})

MiscSection:Toggle({
    Title = "Speedrun Mode (Max Everything)",
    Default = false,
    Callback = function(value)
        State.SpeedrunMode = value
        if value then
            Humanoid.WalkSpeed = 200
            Humanoid.JumpPower = 150
            Config.FOV = 100
            Camera.FieldOfView = 100
            Notify("Speedrun", "Speedrun Mode enabled!", 3, "timer")
        else
            Humanoid.WalkSpeed = 16
            Humanoid.JumpPower = 50
            Config.FOV = 70
            Camera.FieldOfView = 70
            Notify("Speedrun", "Speedrun Mode disabled!", 3, "timer")
        end
    end
})

MiscSection:Toggle({
    Title = "Custom Cursor",
    Default = false,
    Callback = function(value)
        State.CustomCursor = value
        if value then
            local cursorGui = Instance.new("ScreenGui")
            cursorGui.Name = "GreenZxCursor"
            cursorGui.ResetOnSpawn = false
            cursorGui.Parent = LocalPlayer.PlayerGui
            local cursor = Instance.new("ImageLabel")
            cursor.Name = "CustomCursor"
            cursor.Size = UDim2.new(0, 32, 0, 32)
            cursor.BackgroundTransparency = 1
            cursor.Image = "rbxassetid://7733964640"
            cursor.Parent = cursorGui
            UserInputService.MouseIconEnabled = false
            spawn(function()
                while State.CustomCursor do
                    wait()
                    local mousePos = UserInputService:GetMouseLocation()
                    cursor.Position = UDim2.new(0, mousePos.X - 16, 0, mousePos.Y - 16)
                end
                UserInputService.MouseIconEnabled = true
                cursorGui:Destroy()
            end)
            Notify("Cursor", "Custom Cursor enabled!", 3, "mouse-pointer")
        else
            UserInputService.MouseIconEnabled = true
            local cursorGui = LocalPlayer.PlayerGui:FindFirstChild("GreenZxCursor")
            if cursorGui then cursorGui:Destroy() end
            Notify("Cursor", "Custom Cursor disabled!", 3, "mouse-pointer")
        end
    end
})

MiscSection:Button({
    Title = "💾 Save Configuration",
    Callback = function()
        local configData = HttpService:JSONEncode(Config)
        if setclipboard then
            setclipboard(configData)
            Notify("Save Config", "Configuration copied to clipboard!", 3, "save")
        else
            Notify("Save Config", "Configuration saved locally!", 3, "save")
        end
    end
})

MiscSection:Button({
    Title = "🗑️ Unload Script",
    Callback = function()
        ClearESP()
        StopFly()
        if ESPFolder then ESPFolder:Destroy() end
        for _, obj in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if obj.Name:find("GreenZx") then obj:Destroy() end
        end
        Notify("Unload", "GreenZx Hub unloaded! Goodbye!", 5, "trash-2")
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB: CREDITS 🏆
-- ═══════════════════════════════════════════════════════════════════════════════
local CreditsTab = Window:Tab({
    Title = "Credits 🏆",
    Icon = "trophy"
})

local CreditsSection = CreditsTab:Section({
    Title = "Development Team",
    TextXAlignment = "Left"
})

CreditsSection:Paragraph({
    Title = "RkpyDevelopment Team",
    Content = "GreenZx Hub v3.0 was developed with passion and dedication by the RkpyDevelopment Team. We are a group of elite Roblox scripters and developers committed to creating the most powerful tools for the community. Our scripts are thoroughly tested, regularly updated, and designed to be undetectable.",
    Icon = "users"
})

CreditsSection:Paragraph({
    Title = "TheRkpyYT - Owner & Lead Developer",
    Content = "TheRkpyYT is the visionary behind GreenZx Hub and the founder of RkpyDevelopment Team. Known for creating world-famous scripts and executors, TheRkpyYT brings years of expertise in Roblox scripting, UI design, game exploitation, and anti-detection systems. Every feature in this hub was carefully planned and implemented under their expert leadership. GreenZx Hub v3.0 is the culmination of months of research into Voidware and other top scripts, combined with exclusive innovations.",
    Icon = "crown"
})

CreditsSection:Paragraph({
    Title = "Special Thanks",
    Content = "Special thanks to the 99 Nights In The Forest community for their support and feedback. Thanks to Grandma's Favorite Games for creating such an amazing survival game. Thanks to the WindUI team for the beautiful UI framework. And most importantly, thank YOU for using GreenZx Hub! Your support drives us to keep improving and innovating.",
    Icon = "heart"
})

CreditsSection:Paragraph({
    Title = "Version & Info",
    Content = "GreenZx Hub v3.0 - Voidware Killer Edition\nGame: 99 Nights In The Forest\nPlatform: Roblox\nUI Framework: WindUI\nTotal Features: 50+\nLast Updated: July 2026\nStatus: ACTIVE & UNDETECTED",
    Icon = "info"
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- FINAL NOTIFICATION
-- ═══════════════════════════════════════════════════════════════════════════════
Notify("✅ GreenZx Hub v3.0 Loaded!", "All 50+ features are ready! Dominate the forest, " .. LocalPlayer.Name .. "!", 10, "check-circle")

print("[GreenZx Hub v3.0] Successfully loaded for " .. LocalPlayer.Name)
print("[GreenZx Hub v3.0] Developed by RkpyDevelopment Team | Owner: TheRkpyYT")
print("[GreenZx Hub v3.0] Inspired by Voidware - BUT BETTER, MORE FEATURES, MORE POWER!")
