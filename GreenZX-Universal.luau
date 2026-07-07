-- ╔══════════════════════════════════════════════════════════════╗
-- ║                    GreenZx Hub | Universal Script            ║
-- ║                        Made with WindUI                      ║
-- ╚══════════════════════════════════════════════════════════════╝

local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Avatar URL pengguna
local UserAvatarUrl = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

-- ═══════════════════════════════════════════════════════════════
-- CONFIG & VARIABLES
-- ═══════════════════════════════════════════════════════════════

local GreenZxConfig = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    Noclip = false,
    Fly = false,
    InfiniteJump = false,
    FullBright = false,
    ESP = false,
    Crosshair = false,
    AntiAFK = false,
    ClickTeleport = false,
    SavedPosition = nil,
}

-- Colors
local Green = Color3.fromHex("#10C550")
local Blue = Color3.fromHex("#257AF7")
local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Red = Color3.fromHex("#EF4F1D")
local Grey = Color3.fromHex("#83889E")

-- Fly Variables
local FlyBodyGyro, FlyBodyVelocity
local FlyConnection

-- Noclip Variables
local NoclipConnection

-- ESP Variables
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "GreenZxESP"
ESPFolder.Parent = Workspace

-- Crosshair Variables
local CrosshairGui

-- ═══════════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ═══════════════════════════════════════════════════════════════

local Window = WindUI:CreateWindow({
    Title = "GreenZx Hub | Universal Script",
    Author = "GreenZx Team",
    Folder = "GreenZxHub",
    Icon = "leaf",
    IconSize = 22,
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "Open GreenZx Hub",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(
            Color3.fromHex("#10C550"),
            Color3.fromHex("#30FF6A")
        ),
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },
})

-- Tag Version
Window:Tag({
    Title = "v1.0.0",
    Icon = "github",
    Color = Color3.fromHex("#1c1c1c"),
})

-- ═══════════════════════════════════════════════════════════════
-- TABS
-- ═══════════════════════════════════════════════════════════════

local WelcomeTab = Window:Tab({ Title = "Welcome", Icon = "hand" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local VisualTab = Window:Tab({ Title = "Visual", Icon = "eye" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings" })
local ConsoleTab = Window:Tab({ Title = "Console", Icon = "terminal" })

-- ═══════════════════════════════════════════════════════════════
-- WELCOME TAB
-- ═══════════════════════════════════════════════════════════════

WelcomeTab:Section({
    Title = "Greetings",
})

-- Paragraf Sambutan dengan Foto Avatar User
WelcomeTab:Paragraph({
    Title = "Hello, " .. LocalPlayer.Name .. "!",
    Desc = "Welcome to GreenZx Hub! This universal script hub is designed to enhance your Roblox experience with powerful features, modern UI, and smooth performance. Enjoy your stay and explore all the tools we provide!",
    Image = UserAvatarUrl,
    ImageSize = 100,
})

-- Paragraf Informasi Script Lengkap
WelcomeTab:Paragraph({
    Title = "Script Information",
    Desc = [[
📛 Hub Name: GreenZx Hub | Universal Script
📦 UI Library: WindUI (Modern & Open Source)
🔢 Version: 1.0.0
👨‍💻 Developer: GreenZx Team
🌍 Type: Universal (Compatible with most Roblox games)
⚡ Executor: Supported on Synapse X, KRNL, Fluxus, Codex, Delta, & more

✨ Features Overview:
  • Player Mods — WalkSpeed, JumpPower, Fly, Noclip, Infinite Jump
  • Visuals — Player ESP, Full Bright, Custom Crosshair
  • Teleport — Click TP, TP to Player, Save/Load Position
  • Utilities — Anti-AFK, Rejoin Server, Server Hop, Low Graphics
  • Console — Open/Close DevConsole directly from UI

⌨️  Keybind: Press [RightShift] to Toggle the UI
💡 Tip: Use the Console tab to open Roblox Developer Console instantly!

Status: Loaded Successfully ✅
    ]],
    ImageSize = 0,
})

WelcomeTab:Space()

WelcomeTab:Button({
    Title = "Copy Discord Invite",
    Desc = "Join our community for updates & support!",
    Color = Green,
    Icon = "link",
    Callback = function()
        local DiscordLink = "discord.gg/greenzx"
        setclipboard(DiscordLink)
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "Discord link copied to clipboard!",
            Duration = 3,
        })
    end,
})

WelcomeTab:Space()

WelcomeTab:Button({
    Title = "Destroy UI",
    Desc = "Close the hub completely",
    Color = Red,
    Icon = "trash",
    Callback = function()
        Window:Destroy()
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- PLAYER TAB
-- ═══════════════════════════════════════════════════════════════

PlayerTab:Section({ Title = "Character Mods" })

PlayerTab:Slider({
    Title = "WalkSpeed",
    Desc = "Adjust your walking speed",
    Step = 1,
    Value = {
        Min = 1,
        Max = 500,
        Default = 16,
    },
    Callback = function(value)
        GreenZxConfig.WalkSpeed = value
        if Humanoid then
            Humanoid.WalkSpeed = value
        end
    end,
})

PlayerTab:Space()

PlayerTab:Slider({
    Title = "JumpPower",
    Desc = "Adjust your jump power",
    Step = 1,
    Value = {
        Min = 1,
        Max = 500,
        Default = 50,
    },
    Callback = function(value)
        GreenZxConfig.JumpPower = value
        if Humanoid then
            Humanoid.JumpPower = value
        end
    end,
})

PlayerTab:Space()

PlayerTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump forever without touching ground",
    Callback = function(state)
        GreenZxConfig.InfiniteJump = state
    end,
})

PlayerTab:Space()

PlayerTab:Toggle({
    Title = "Fly",
    Desc = "Enable flying mode (WASD + Space/Shift)",
    Callback = function(state)
        GreenZxConfig.Fly = state
        if state then
            StartFly()
        else
            StopFly()
        end
    end,
})

PlayerTab:Space()

PlayerTab:Slider({
    Title = "Fly Speed",
    Desc = "Speed while flying",
    Step = 1,
    Value = {
        Min = 1,
        Max = 300,
        Default = 50,
    },
    Callback = function(value)
        GreenZxConfig.FlySpeed = value
    end,
})

PlayerTab:Space()

PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Callback = function(state)
        GreenZxConfig.Noclip = state
        if state then
            StartNoclip()
        else
            StopNoclip()
        end
    end,
})

PlayerTab:Space()

PlayerTab:Button({
    Title = "Reset Character",
    Desc = "Kill and respawn your character",
    Color = Red,
    Icon = "skull",
    Callback = function()
        if Humanoid then
            Humanoid.Health = 0
        end
    end,
})

PlayerTab:Space()

PlayerTab:Button({
    Title = "Full Heal",
    Desc = "Restore health to max",
    Color = Green,
    Icon = "heart",
    Callback = function()
        if Humanoid then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- VISUAL TAB
-- ═══════════════════════════════════════════════════════════════

VisualTab:Section({ Title = "ESP & Visuals" })

VisualTab:Toggle({
    Title = "Player ESP",
    Desc = "See players through walls (Green Theme)",
    Callback = function(state)
        GreenZxConfig.ESP = state
        if state then
            StartESP()
        else
            StopESP()
        end
    end,
})

VisualTab:Space()

VisualTab:Toggle({
    Title = "Full Bright",
    Desc = "Remove darkness from the game",
    Callback = function(state)
        GreenZxConfig.FullBright = state
        if state then
            Lighting.Brightness = 10
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            for i, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                end
            end
        else
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
        end
    end,
})

VisualTab:Space()

VisualTab:Toggle({
    Title = "Crosshair",
    Desc = "Show a custom green crosshair in center",
    Callback = function(state)
        GreenZxConfig.Crosshair = state
        if state then
            CreateCrosshair()
        else
            RemoveCrosshair()
        end
    end,
})

VisualTab:Space()

VisualTab:Button({
    Title = "Remove All Effects",
    Desc = "Clear all visual effects (Bloom, Blur, etc)",
    Color = Purple,
    Icon = "eraser",
    Callback = function()
        for i, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("PostEffect") then
                v:Destroy()
            end
        end
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "All effects removed!",
            Duration = 3,
        })
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- TELEPORT TAB
-- ═══════════════════════════════════════════════════════════════

TeleportTab:Section({ Title = "Teleport Options" })

TeleportTab:Toggle({
    Title = "Click Teleport",
    Desc = "Ctrl + Click to teleport to mouse position",
    Callback = function(state)
        GreenZxConfig.ClickTeleport = state
    end,
})

TeleportTab:Space()

TeleportTab:Button({
    Title = "Teleport to Random Player",
    Desc = "TP to a random player in server",
    Color = Blue,
    Icon = "shuffle",
    Callback = function()
        local AllPlayers = Players:GetPlayers()
        if #AllPlayers > 1 then
            local RandomPlayer = AllPlayers[math.random(1, #AllPlayers)]
            if RandomPlayer ~= LocalPlayer and RandomPlayer.Character and RandomPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Character:PivotTo(RandomPlayer.Character.HumanoidRootPart.CFrame)
                WindUI:Notify({
                    Title = "GreenZx Hub",
                    Content = "Teleported to " .. RandomPlayer.Name,
                    Duration = 3,
                })
            end
        end
    end,
})

TeleportTab:Space()

TeleportTab:Input({
    Title = "Teleport to Player",
    Desc = "Enter exact username",
    Placeholder = "Username...",
    Callback = function(text)
        local Target = Players:FindFirstChild(text)
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            Character:PivotTo(Target.Character.HumanoidRootPart.CFrame)
            WindUI:Notify({
                Title = "GreenZx Hub",
                Content = "Teleported to " .. Target.Name,
                Duration = 3,
            })
        else
            WindUI:Notify({
                Title = "GreenZx Hub",
                Content = "Player not found!",
                Duration = 3,
            })
        end
    end,
})

TeleportTab:Space()

TeleportTab:Button({
    Title = "Save Current Position",
    Desc = "Save your current location",
    Color = Green,
    Icon = "save",
    Callback = function()
        if HumanoidRootPart then
            GreenZxConfig.SavedPosition = HumanoidRootPart.CFrame
            WindUI:Notify({
                Title = "GreenZx Hub",
                Content = "Position saved!",
                Duration = 3,
            })
        end
    end,
})

TeleportTab:Space()

TeleportTab:Button({
    Title = "Load Saved Position",
    Desc = "Teleport back to saved location",
    Color = Blue,
    Icon = "map-pin",
    Callback = function()
        if GreenZxConfig.SavedPosition then
            Character:PivotTo(GreenZxConfig.SavedPosition)
            WindUI:Notify({
                Title = "GreenZx Hub",
                Content = "Teleported to saved position!",
                Duration = 3,
            })
        else
            WindUI:Notify({
                Title = "GreenZx Hub",
                Content = "No saved position!",
                Duration = 3,
            })
        end
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- MISC TAB
-- ═══════════════════════════════════════════════════════════════

MiscTab:Section({ Title = "Utility" })

MiscTab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevent getting kicked for idle",
    Callback = function(state)
        GreenZxConfig.AntiAFK = state
        if state then
            local AntiAFKConnection
            AntiAFKConnection = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            GreenZxConfig.AntiAFKConnection = AntiAFKConnection
        else
            if GreenZxConfig.AntiAFKConnection then
                GreenZxConfig.AntiAFKConnection:Disconnect()
            end
        end
    end,
})

MiscTab:Space()

MiscTab:Button({
    Title = "Rejoin Server",
    Desc = "Rejoin the same server",
    Color = Blue,
    Icon = "refresh-cw",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

MiscTab:Space()

MiscTab:Button({
    Title = "Server Hop",
    Desc = "Join a different server",
    Color = Purple,
    Icon = "shuffle",
    Callback = function()
        local Servers = HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
        
        for _, server in pairs(Servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end,
})

MiscTab:Space()

MiscTab:Button({
    Title = "Low Graphics Mode",
    Desc = "Reduce lag by lowering graphics",
    Color = Yellow,
    Icon = "zap",
    Callback = function()
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "Low graphics mode enabled!",
            Duration = 3,
        })
    end,
})

MiscTab:Space()

MiscTab:Keybind({
    Title = "UI Toggle Key",
    Desc = "Key to show/hide the UI",
    Value = "RightShift",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- CONSOLE TAB
-- ═══════════════════════════════════════════════════════════════

ConsoleTab:Section({ Title = "Developer Console" })

ConsoleTab:Paragraph({
    Title = "Console Controls",
    Desc = "Open/Close the Roblox Developer Console using the buttons below. You can also use F9 as shortcut.",
})

ConsoleTab:Space()

ConsoleTab:Button({
    Title = "Open Console",
    Desc = "Open the Developer Console (F9)",
    Color = Green,
    Icon = "terminal",
    Callback = function()
        pcall(function()
            StarterGui:SetCore("DevConsoleVisible", true)
        end)
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "Console opened! (F9)",
            Duration = 3,
        })
    end,
})

ConsoleTab:Space()

ConsoleTab:Button({
    Title = "Close Console",
    Desc = "Close the Developer Console",
    Color = Red,
    Icon = "x",
    Callback = function()
        pcall(function()
            StarterGui:SetCore("DevConsoleVisible", false)
        end)
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "Console closed!",
            Duration = 3,
        })
    end,
})

ConsoleTab:Space()

ConsoleTab:Button({
    Title = "Clear Console",
    Desc = "Clear console output (Executor dependent)",
    Color = Purple,
    Icon = "eraser",
    Callback = function()
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "Console clear attempted!",
            Duration = 3,
        })
    end,
})

ConsoleTab:Space()

ConsoleTab:Toggle({
    Title = "Auto-Open Console",
    Desc = "Open console when script loads",
    Callback = function(state)
        if state then
            pcall(function()
                StarterGui:SetCore("DevConsoleVisible", true)
            end)
        end
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

-- FLY FUNCTION
function StartFly()
    if not Character or not HumanoidRootPart then return end
    
    local BV = Instance.new("BodyVelocity")
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Parent = HumanoidRootPart
    FlyBodyVelocity = BV
    
    local BG = Instance.new("BodyGyro")
    BG.P = 9e4
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.CFrame = HumanoidRootPart.CFrame
    BG.Parent = HumanoidRootPart
    FlyBodyGyro = BG
    
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not GreenZxConfig.Fly then return end
        if not HumanoidRootPart then return end
        
        local Camera = Workspace.CurrentCamera
        local Direction = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            Direction = Direction + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            Direction = Direction - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            Direction = Direction - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            Direction = Direction + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            Direction = Direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            Direction = Direction - Vector3.new(0, 1, 0)
        end
        
        if Direction.Magnitude > 0 then
            Direction = Direction.Unit * GreenZxConfig.FlySpeed
        end
        
        if FlyBodyVelocity then
            FlyBodyVelocity.Velocity = Direction
        end
        if FlyBodyGyro then
            FlyBodyGyro.CFrame = Camera.CFrame
        end
    end)
end

function StopFly()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
    if FlyBodyGyro then
        FlyBodyGyro:Destroy()
        FlyBodyGyro = nil
    end
end

-- NOCLIP FUNCTION
function StartNoclip()
    NoclipConnection = RunService.Stepped:Connect(function()
        if not GreenZxConfig.Noclip then return end
        if not Character then return end
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end)
end

function StopNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    if Character then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end

-- ESP FUNCTION
function StartESP()
    local function CreateESP(player)
        if player == LocalPlayer then return end
        if not player.Character then return end
        
        local Head = player.Character:FindFirstChild("Head")
        if not Head then return end
        
        local Highlight = Instance.new("Highlight")
        Highlight.Name = player.Name .. "_ESP"
        Highlight.FillColor = Color3.fromRGB(0, 255, 100)
        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        Highlight.FillTransparency = 0.5
        Highlight.OutlineTransparency = 0
        Highlight.Adornee = player.Character
        Highlight.Parent = ESPFolder
        
        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = player.Name .. "_Billboard"
        Billboard.Size = UDim2.new(0, 200, 0, 50)
        Billboard.StudsOffset = Vector3.new(0, 3, 0)
        Billboard.AlwaysOnTop = true
        Billboard.Adornee = Head
        Billboard.Parent = ESPFolder
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        TextLabel.TextStrokeTransparency = 0.5
        TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextSize = 14
        TextLabel.Text = player.Name .. " | " .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - Head.Position).Magnitude) .. "m"
        TextLabel.Parent = Billboard
        
        local UpdateConnection
        UpdateConnection = RunService.RenderStepped:Connect(function()
            if not GreenZxConfig.ESP then
                UpdateConnection:Disconnect()
                return
            end
            if player.Character and player.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.Head.Position).Magnitude
                TextLabel.Text = player.Name .. " | " .. math.floor(Distance) .. "m"
            else
                UpdateConnection:Disconnect()
            end
        end)
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        CreateESP(player)
    end
    
    GreenZxConfig.ESPConnection = Players.PlayerAdded:Connect(CreateESP)
    
    GreenZxConfig.ESPLeaveConnection = Players.PlayerRemoving:Connect(function(player)
        for _, v in pairs(ESPFolder:GetChildren()) do
            if v.Name:find(player.Name) then
                v:Destroy()
            end
        end
    end)
end

function StopESP()
    if GreenZxConfig.ESPConnection then
        GreenZxConfig.ESPConnection:Disconnect()
    end
    if GreenZxConfig.ESPLeaveConnection then
        GreenZxConfig.ESPLeaveConnection:Disconnect()
    end
    for _, v in pairs(ESPFolder:GetChildren()) do
        v:Destroy()
    end
end

-- CROSSHAIR FUNCTION
function CreateCrosshair()
    CrosshairGui = Instance.new("ScreenGui")
    CrosshairGui.Name = "GreenZxCrosshair"
    CrosshairGui.ResetOnSpawn = false
    CrosshairGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CrosshairGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 20, 0, 2)
    Frame.Position = UDim2.new(0.5, -10, 0.5, -1)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    Frame.BorderSizePixel = 0
    Frame.Parent = CrosshairGui
    
    local Frame2 = Instance.new("Frame")
    Frame2.Size = UDim2.new(0, 2, 0, 20)
    Frame2.Position = UDim2.new(0.5, -1, 0.5, -10)
    Frame2.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    Frame2.BorderSizePixel = 0
    Frame2.Parent = CrosshairGui
end

function RemoveCrosshair()
    if CrosshairGui then
        CrosshairGui:Destroy()
        CrosshairGui = nil
    end
end

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if GreenZxConfig.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- CLICK TELEPORT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if GreenZxConfig.ClickTeleport and HumanoidRootPart then
            local Mouse = LocalPlayer:GetMouse()
            local Target = Mouse.Hit
            if Target then
                Character:PivotTo(CFrame.new(Target.Position + Vector3.new(0, 3, 0)))
            end
        end
    end
end)

-- CHARACTER REFRESH
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    if GreenZxConfig.WalkSpeed ~= 16 then
        Humanoid.WalkSpeed = GreenZxConfig.WalkSpeed
    end
    if GreenZxConfig.JumpPower ~= 50 then
        Humanoid.JumpPower = GreenZxConfig.JumpPower
    end
    if GreenZxConfig.Fly then
        StopFly()
        task.wait(0.5)
        StartFly()
    end
    if GreenZxConfig.Noclip then
        StopNoclip()
        task.wait()
        StartNoclip()
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATION ON LOAD
-- ═══════════════════════════════════════════════════════════════

WindUI:Notify({
    Title = "GreenZx Hub Loaded!",
    Content = "Welcome, " .. LocalPlayer.Name .. "! Press RightShift to toggle UI",
    Duration = 5,
    Icon = "check-circle",
})

print("╔══════════════════════════════════════════════════════════════╗")
print("║              GreenZx Hub | Universal Script                  ║")
print("║              Welcome, " .. LocalPlayer.Name .. string.rep(" ", 44 - #LocalPlayer.Name - 15) .. "║")
print("║                    Loaded Successfully!                      ║")
print("╚══════════════════════════════════════════════════════════════╝")

-- Paragraf Informasi Script Lengkap
WelcomeTab:Paragraph({
    Title = "Script Information",
    Desc = [[
📛 Hub Name: GreenZx Hub | Universal Script
📦 UI Library: WindUI (Modern & Open Source)
🔢 Version: 1.0.0
👨‍💻 Developer: GreenZx Team
🌍 Type: Universal (Compatible with most Roblox games)
⚡ Executor: Supported on Synapse X, KRNL, Fluxus, Codex, Delta, & more

✨ Features Overview:
  • Player Mods — WalkSpeed, JumpPower, Fly, Noclip, Infinite Jump
  • Visuals — Player ESP, Full Bright, Custom Crosshair
  • Teleport — Click TP, TP to Player, Save/Load Position
  • Utilities — Anti-AFK, Rejoin Server, Server Hop, Low Graphics
  • Console — Open/Close DevConsole directly from UI

⌨️  Keybind: Press [RightShift] to Toggle the UI
💡 Tip: Use the Console tab to open Roblox Developer Console instantly!

Status: Loaded Successfully ✅
    ]],
    Image = "rbxassetid://0",
    ImageSize = Vector2.new(0, 0),
})

WelcomeTab:Button({
    Title = "Copy Discord Invite",
    Desc = "Join our community for updates & support!",
    Callback = function()
        local DiscordLink = "discord.gg/greenzx"
        setclipboard(DiscordLink)
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "Discord link copied to clipboard!",
            Duration = 3,
        })
    end,
})

WelcomeTab:Button({
    Title = "Destroy UI",
    Desc = "Close the hub completely",
    Callback = function()
        Window:Destroy()
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- PLAYER TAB
-- ═══════════════════════════════════════════════════════════════

PlayerTab:Section({ Title = "Character Mods" })

PlayerTab:Slider({
    Title = "WalkSpeed",
    Desc = "Adjust your walking speed",
    Value = 16,
    Min = 1,
    Max = 500,
    Callback = function(value)
        GreenZxConfig.WalkSpeed = value
        if Humanoid then
            Humanoid.WalkSpeed = value
        end
    end,
})

PlayerTab:Slider({
    Title = "JumpPower",
    Desc = "Adjust your jump power",
    Value = 50,
    Min = 1,
    Max = 500,
    Callback = function(value)
        GreenZxConfig.JumpPower = value
        if Humanoid then
            Humanoid.JumpPower = value
        end
    end,
})

PlayerTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump forever without touching ground",
    Value = false,
    Callback = function(state)
        GreenZxConfig.InfiniteJump = state
    end,
})

PlayerTab:Toggle({
    Title = "Fly",
    Desc = "Enable flying mode (WASD + Space/Shift)",
    Value = false,
    Callback = function(state)
        GreenZxConfig.Fly = state
        if state then
            StartFly()
        else
            StopFly()
        end
    end,
})

PlayerTab:Slider({
    Title = "Fly Speed",
    Desc = "Speed while flying",
    Value = 50,
    Min = 1,
    Max = 300,
    Callback = function(value)
        GreenZxConfig.FlySpeed = value
    end,
})

PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Value = false,
    Callback = function(state)
        GreenZxConfig.Noclip = state
        if state then
            StartNoclip()
        else
            StopNoclip()
        end
    end,
})

PlayerTab:Button({
    Title = "Reset Character",
    Desc = "Kill and respawn your character",
    Callback = function()
        if Humanoid then
            Humanoid.Health = 0
        end
    end,
})

PlayerTab:Button({
    Title = "Full Heal",
    Desc = "Restore health to max",
    Callback = function()
        if Humanoid then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- VISUAL TAB
-- ═══════════════════════════════════════════════════════════════

VisualTab:Section({ Title = "ESP & Visuals" })

VisualTab:Toggle({
    Title = "Player ESP",
    Desc = "See all players through walls (Green Theme)",
    Value = false,
    Callback = function(state)
        GreenZxConfig.ESP = state
        if state then
            StartESP()
        else
            StopESP()
        end
    end,
})

VisualTab:Toggle({
    Title = "Full Bright",
    Desc = "Remove darkness from the game",
    Value = false,
    Callback = function(state)
        GreenZxConfig.FullBright = state
        if state then
            Lighting.Brightness = 10
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            for i, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                end
            end
        else
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
        end
    end,
})

VisualTab:Toggle({
    Title = "Crosshair",
    Desc = "Show a custom green crosshair in center",
    Value = false,
    Callback = function(state)
        GreenZxConfig.Crosshair = state
        if state then
            CreateCrosshair()
        else
            RemoveCrosshair()
        end
    end,
})

VisualTab:Button({
    Title = "Remove All Effects",
    Desc = "Clear all visual effects (Bloom, Blur, etc)",
    Callback = function()
        for i, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("PostEffect") then
                v:Destroy()
            end
        end
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "All effects removed!",
            Duration = 3,
        })
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- TELEPORT TAB
-- ═══════════════════════════════════════════════════════════════

TeleportTab:Section({ Title = "Teleport Options" })

TeleportTab:Toggle({
    Title = "Click Teleport",
    Desc = "Ctrl + Click to teleport to mouse position",
    Value = false,
    Callback = function(state)
        GreenZxConfig.ClickTeleport = state
    end,
})

TeleportTab:Button({
    Title = "Teleport to Random Player",
    Desc = "TP to a random player in server",
    Callback = function()
        local AllPlayers = Players:GetPlayers()
        if #AllPlayers > 1 then
            local RandomPlayer = AllPlayers[math.random(1, #AllPlayers)]
            if RandomPlayer ~= LocalPlayer and RandomPlayer.Character and RandomPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Character:PivotTo(RandomPlayer.Character.HumanoidRootPart.CFrame)
                WindUI:Notify({
                    Title = "GreenZx Hub",
                    Content = "Teleported to " .. RandomPlayer.Name,
                    Duration = 3,
                })
            end
        end
    end,
})

TeleportTab:Input({
    Title = "Teleport to Player",
    Desc = "Enter exact username",
    Placeholder = "Username...",
    Callback = function(text)
        local Target = Players:FindFirstChild(text)
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            Character:PivotTo(Target.Character.HumanoidRootPart.CFrame)
            WindUI:Notify({
                Title = "GreenZx Hub",
                Content = "Teleported to " .. Target.Name,
                Duration = 3,
            })
        else
            WindUI:Notify({
                Title = "GreenZx Hub",
                Content = "Player not found!",
                Duration = 3,
            })
        end
    end,
})

TeleportTab:Button({
    Title = "Save Current Position",
    Desc = "Save your current location",
    Callback = function()
        if HumanoidRootPart then
            GreenZxConfig.SavedPosition = HumanoidRootPart.CFrame
            WindUI:Notify({
                Title = "GreenZx Hub",
                Content = "Position saved!",
                Duration = 3,
            })
        end
    end,
})

TeleportTab:Button({
    Title = "Load Saved Position",
    Desc = "Teleport back to saved location",
    Callback = function()
        if GreenZxConfig.SavedPosition then
            Character:PivotTo(GreenZxConfig.SavedPosition)
            WindUI:Notify({
                Title = "GreenZx Hub",
                Content = "Teleported to saved position!",
                Duration = 3,
            })
        else
            WindUI:Notify({
                Title = "GreenZx Hub",
                Content = "No saved position!",
                Duration = 3,
            })
        end
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- MISC TAB
-- ═══════════════════════════════════════════════════════════════

MiscTab:Section({ Title = "Utility" })

MiscTab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevent getting kicked for idle",
    Value = false,
    Callback = function(state)
        GreenZxConfig.AntiAFK = state
        if state then
            local AntiAFKConnection
            AntiAFKConnection = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            GreenZxConfig.AntiAFKConnection = AntiAFKConnection
        else
            if GreenZxConfig.AntiAFKConnection then
                GreenZxConfig.AntiAFKConnection:Disconnect()
            end
        end
    end,
})

MiscTab:Button({
    Title = "Rejoin Server",
    Desc = "Rejoin the same server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

MiscTab:Button({
    Title = "Server Hop",
    Desc = "Join a different server",
    Callback = function()
        local Servers = HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
        
        for _, server in pairs(Servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end,
})

MiscTab:Button({
    Title = "Low Graphics Mode",
    Desc = "Reduce lag by lowering graphics",
    Callback = function()
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "Low graphics mode enabled!",
            Duration = 3,
        })
    end,
})

MiscTab:Keybind({
    Title = "UI Toggle Key",
    Desc = "Key to show/hide the UI",
    Value = Enum.KeyCode.RightShift,
    Callback = function(key)
        -- WindUI handles this automatically
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- CONSOLE TAB (TOMBOL CONSOLE!)
-- ═══════════════════════════════════════════════════════════════

ConsoleTab:Section({ Title = "Developer Console" })

ConsoleTab:Paragraph({
    Title = "Console Controls",
    Desc = "Open/Close the Roblox Developer Console using the buttons below. You can also use F9 as shortcut.",
})

ConsoleTab:Button({
    Title = "Open Console",
    Desc = "Open the Developer Console (F9)",
    Callback = function()
        pcall(function()
            StarterGui:SetCore("DevConsoleVisible", true)
        end)
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "Console opened! (F9)",
            Duration = 3,
        })
    end,
})

ConsoleTab:Button({
    Title = "Close Console",
    Desc = "Close the Developer Console",
    Callback = function()
        pcall(function()
            StarterGui:SetCore("DevConsoleVisible", false)
        end)
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "Console closed!",
            Duration = 3,
        })
    end,
})

ConsoleTab:Button({
    Title = "Clear Console",
    Desc = "Clear console output (Executor dependent)",
    Callback = function()
        WindUI:Notify({
            Title = "GreenZx Hub",
            Content = "Console clear attempted!",
            Duration = 3,
        })
    end,
})

ConsoleTab:Toggle({
    Title = "Auto-Open Console",
    Desc = "Open console when script loads",
    Value = false,
    Callback = function(state)
        if state then
            pcall(function()
                StarterGui:SetCore("DevConsoleVisible", true)
            end)
        end
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

-- FLY FUNCTION
function StartFly()
    if not Character or not HumanoidRootPart then return end
    
    local BV = Instance.new("BodyVelocity")
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Parent = HumanoidRootPart
    FlyBodyVelocity = BV
    
    local BG = Instance.new("BodyGyro")
    BG.P = 9e4
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.CFrame = HumanoidRootPart.CFrame
    BG.Parent = HumanoidRootPart
    FlyBodyGyro = BG
    
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not GreenZxConfig.Fly then return end
        if not HumanoidRootPart then return end
        
        local Camera = Workspace.CurrentCamera
        local Direction = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            Direction = Direction + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            Direction = Direction - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            Direction = Direction - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            Direction = Direction + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            Direction = Direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            Direction = Direction - Vector3.new(0, 1, 0)
        end
        
        if Direction.Magnitude > 0 then
            Direction = Direction.Unit * GreenZxConfig.FlySpeed
        end
        
        if FlyBodyVelocity then
            FlyBodyVelocity.Velocity = Direction
        end
        if FlyBodyGyro then
            FlyBodyGyro.CFrame = Camera.CFrame
        end
    end)
end

function StopFly()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
    if FlyBodyGyro then
        FlyBodyGyro:Destroy()
        FlyBodyGyro = nil
    end
end

-- NOCLIP FUNCTION
function StartNoclip()
    NoclipConnection = RunService.Stepped:Connect(function()
        if not GreenZxConfig.Noclip then return end
        if not Character then return end
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end)
end

function StopNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    if Character then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end

-- ESP FUNCTION
function StartESP()
    local function CreateESP(player)
        if player == LocalPlayer then return end
        if not player.Character then return end
        
        local Head = player.Character:FindFirstChild("Head")
        if not Head then return end
        
        -- Highlight
        local Highlight = Instance.new("Highlight")
        Highlight.Name = player.Name .. "_ESP"
        Highlight.FillColor = Color3.fromRGB(0, 255, 100)
        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        Highlight.FillTransparency = 0.5
        Highlight.OutlineTransparency = 0
        Highlight.Adornee = player.Character
        Highlight.Parent = ESPFolder
        
        -- Billboard
        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = player.Name .. "_Billboard"
        Billboard.Size = UDim2.new(0, 200, 0, 50)
        Billboard.StudsOffset = Vector3.new(0, 3, 0)
        Billboard.AlwaysOnTop = true
        Billboard.Adornee = Head
        Billboard.Parent = ESPFolder
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        TextLabel.TextStrokeTransparency = 0.5
        TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextSize = 14
        TextLabel.Text = player.Name .. " | " .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - Head.Position).Magnitude) .. "m"
        TextLabel.Parent = Billboard
        
        -- Update distance
        local UpdateConnection
        UpdateConnection = RunService.RenderStepped:Connect(function()
            if not GreenZxConfig.ESP then
                UpdateConnection:Disconnect()
                return
            end
            if player.Character and player.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.Head.Position).Magnitude
                TextLabel.Text = player.Name .. " | " .. math.floor(Distance) .. "m"
            else
                UpdateConnection:Disconnect()
            end
        end)
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        CreateESP(player)
    end
    
    GreenZxConfig.ESPConnection = Players.PlayerAdded:Connect(CreateESP)
    
    GreenZxConfig.ESPLeaveConnection = Players.PlayerRemoving:Connect(function(player)
        for _, v in pairs(ESPFolder:GetChildren()) do
            if v.Name:find(player.Name) then
                v:Destroy()
            end
        end
    end)
end

function StopESP()
    if GreenZxConfig.ESPConnection then
        GreenZxConfig.ESPConnection:Disconnect()
    end
    if GreenZxConfig.ESPLeaveConnection then
        GreenZxConfig.ESPLeaveConnection:Disconnect()
    end
    for _, v in pairs(ESPFolder:GetChildren()) do
        v:Destroy()
    end
end

-- CROSSHAIR FUNCTION
function CreateCrosshair()
    CrosshairGui = Instance.new("ScreenGui")
    CrosshairGui.Name = "GreenZxCrosshair"
    CrosshairGui.ResetOnSpawn = false
    CrosshairGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CrosshairGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 20, 0, 2)
    Frame.Position = UDim2.new(0.5, -10, 0.5, -1)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    Frame.BorderSizePixel = 0
    Frame.Parent = CrosshairGui
    
    local Frame2 = Instance.new("Frame")
    Frame2.Size = UDim2.new(0, 2, 0, 20)
    Frame2.Position = UDim2.new(0.5, -1, 0.5, -10)
    Frame2.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    Frame2.BorderSizePixel = 0
    Frame2.Parent = CrosshairGui
end

function RemoveCrosshair()
    if CrosshairGui then
        CrosshairGui:Destroy()
        CrosshairGui = nil
    end
end

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if GreenZxConfig.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- CLICK TELEPORT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if GreenZxConfig.ClickTeleport and HumanoidRootPart then
            local Mouse = LocalPlayer:GetMouse()
            local Target = Mouse.Hit
            if Target then
                Character:PivotTo(CFrame.new(Target.Position + Vector3.new(0, 3, 0)))
            end
        end
    end
end)

-- CHARACTER REFRESH
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    if GreenZxConfig.WalkSpeed ~= 16 then
        Humanoid.WalkSpeed = GreenZxConfig.WalkSpeed
    end
    if GreenZxConfig.JumpPower ~= 50 then
        Humanoid.JumpPower = GreenZxConfig.JumpPower
    end
    if GreenZxConfig.Fly then
        StopFly()
        task.wait(0.5)
        StartFly()
    end
    if GreenZxConfig.Noclip then
        StopNoclip()
        task.wait()
        StartNoclip()
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATION ON LOAD
-- ═══════════════════════════════════════════════════════════════

WindUI:Notify({
    Title = "GreenZx Hub Loaded!",
    Content = "Welcome, " .. LocalPlayer.Name .. "! Press RightShift to toggle UI",
    Duration = 5,
    Icon = "check-circle",
})

print("╔══════════════════════════════════════════════════════════════╗")
print("║              GreenZx Hub | Universal Script                  ║")
print("║              Welcome, " .. LocalPlayer.Name .. string.rep(" ", 44 - #LocalPlayer.Name - 15) .. "║")
print("║                    Loaded Successfully!                      ║")
print("╚══════════════════════════════════════════════════════════════╝")

