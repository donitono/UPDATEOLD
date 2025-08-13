--[[
    XSAN's Fish It Pro - Ultimate Edition v1.0 WORKING VERSION
    
    Premium Fish It script with ULTIMATE features:
    • Quick Start Presets & Advanced Analytics
    • Smart Inventory Management & AI Features  
    • Enhanced Fishing & Quality of Life
    • Smart Notifications & Safety Systems
    • Advanced Automation & Much More
    • Ultimate Teleportation System (NEW!)
    
    Developer: XSAN
    Instagram: @_bangicoo
    GitHub: github.com/codeico
    
    Premium Quality • Trusted by Thousands • Ultimate Edition
--]]

print("XSAN: Starting Fish It Pro Ultimate v1.0...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

-- UI configuration (edit here to change Floating Button icon)
local UIConfig = {
    floatingButton = {
        -- Set to true to use a custom image icon instead of emoji text
        useImage = false,

        -- Emoji icons (used when useImage = false)
        emojiVisible = "🍀", -- when UI is visible
        emojiHidden = "🍀", -- when UI is hidden

        -- Image icons (used when useImage = true). Replace with your asset IDs
        imageVisible = "rbxassetid://88814246774578",
        imageHidden = "rbxassetid://88814246774578"
    }
}

-- Notification system
local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "XSAN Fish It Pro",
            Text = text or "Notification", 
            Duration = duration,
            Icon = "rbxassetid://88814246774578"
        })
    end)
    print("XSAN:", title, "-", text)
end

-- Additional Notification Functions
local function NotifySuccess(title, message)
	Notify("XSAN - " .. title, message, 3)
end

local function NotifyError(title, message)
	Notify("XSAN ERROR - " .. title, message, 4)
end

local function NotifyInfo(title, message)
	Notify("XSAN INFO - " .. title, message, 3)
end

-- Check basic requirements
if not LocalPlayer then
    warn("XSAN ERROR: LocalPlayer not found")
    return
end

if not ReplicatedStorage then
    warn("XSAN ERROR: ReplicatedStorage not found")
    return
end

print("XSAN: Basic services OK")

-- XSAN Anti Ghost Touch System
local ButtonCooldowns = {}
local BUTTON_COOLDOWN = 0.5

local function CreateSafeCallback(originalCallback, buttonId)
    return function(...)
        local currentTime = tick()
        if ButtonCooldowns[buttonId] and currentTime - ButtonCooldowns[buttonId] < BUTTON_COOLDOWN then
            return
        end
        ButtonCooldowns[buttonId] = currentTime
        
        local success, result = pcall(originalCallback, ...)
        if not success then
            warn("XSAN Error:", result)
        end
    end
end

-- Load Rayfield with error handling
print("XSAN: Loading UI Library...")

local Rayfield
local success, error = pcall(function()
    print("XSAN: Attempting to load UI...")
    
    -- Try ui_fixed.lua first (more stable)
    local uiContent = game:HttpGet("https://raw.githubusercontent.com/MELLISAEFFENDY/UPDATEOLD/refs/heads/main/Versi1/ui_fixed.lua")
    if uiContent and #uiContent > 0 then
        print("XSAN: Loading stable UI library...")
        print("XSAN: UI content length:", #uiContent)
        local uiFunc, loadError = loadstring(uiContent)
        if uiFunc then
            Rayfield = uiFunc()
            if not Rayfield then
                error("UI function returned nil")
            end
            print("XSAN: Stable UI loaded successfully!")
        else
            error("Failed to compile UI: " .. tostring(loadError))
        end
    else
        error("Failed to fetch UI content")
    end
end)

if not success then
    warn("XSAN Error: Failed to load Rayfield UI Library - " .. tostring(error))
    return
end

if not Rayfield then
    warn("XSAN Error: Rayfield is nil after loading")
    return
end

print("XSAN: UI Library loaded successfully!")

-- Mobile/Android detection and UI scaling
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local screenSize = workspace.CurrentCamera.ViewportSize

print("XSAN: Platform Detection - Mobile:", isMobile, "Screen Size:", screenSize.X .. "x" .. screenSize.Y)

-- Create Window with mobile-optimized settings
print("XSAN: Creating main window...")
local windowConfig = {
    Name = isMobile and "XSAN Fish It Pro Mobile" or "XSAN Fish It Pro v1.0",
    LoadingTitle = "XSAN Fish It Pro Ultimate",
    LoadingSubtitle = "by XSAN - Mobile Optimized",
    Theme = "Default", -- Changed to Default for better compatibility
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "XSAN",
        FileName = "FishItProUltimate"
    },
    KeySystem = false,
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false
}

-- Mobile specific adjustments
if isMobile then
    -- Detect orientation
    local isLandscape = screenSize.X > screenSize.Y
    
    if isLandscape then
        -- Landscape mode - Much wider UI untuk nama fitur tidak terpotong
        windowConfig.Size = UDim2.new(0, math.min(screenSize.X * 0.60, 500), 0, math.min(screenSize.Y * 0.75, 300))
        print("XSAN: Landscape mode detected - using wider UI for feature names")
    else
        -- Portrait mode - lebih lebar untuk readability
        windowConfig.Size = UDim2.new(0, math.min(screenSize.X * 0.85, 350), 0, math.min(screenSize.Y * 0.70, 420))
        print("XSAN: Portrait mode detected - using wider UI")
    end
end

local Window = Rayfield:CreateWindow(windowConfig)

print("XSAN: Window created successfully!")

-- Fix scrolling issues and mobile scaling for Rayfield UI
print("XSAN: Applying mobile fixes and scrolling fixes...")
task.spawn(function()
    task.wait(1) -- Wait for UI to fully load
    
    local function fixUIForMobile()
        local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
        if rayfieldGui then
            local main = rayfieldGui:FindFirstChild("Main")
            if main and isMobile then
                -- Mobile scaling adjustments - Much wider untuk feature names
                local isLandscape = screenSize.X > screenSize.Y
                
                if isLandscape then
                    -- Landscape mode - Much wider untuk nama fitur tidak terpotong
                    main.Size = UDim2.new(0, math.min(screenSize.X * 0.60, 500), 0, math.min(screenSize.Y * 0.75, 300))
                else
                    -- Portrait mode - lebih lebar untuk readability
                    main.Size = UDim2.new(0, math.min(screenSize.X * 0.85, 350), 0, math.min(screenSize.Y * 0.70, 420))
                end
                
                main.Position = UDim2.new(0.5, -main.Size.X.Offset/2, 0.5, -main.Size.Y.Offset/2)
                
                -- Adjust text scaling for mobile
                for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                        if descendant.TextScaled == false then
                            descendant.TextScaled = true
                        end
                        -- Ensure minimum readable text size on mobile
                        if descendant.TextSize < 14 and isMobile then
                            descendant.TextSize = 16
                        end
                    end
                end
                
                print("XSAN: Applied mobile UI scaling for", isLandscape and "landscape" or "portrait", "mode")
            end
            
            -- Fix scrolling for all platforms with enhanced touch support
            for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                if descendant:IsA("ScrollingFrame") then
                    -- Enable proper scrolling
                    descendant.ScrollingEnabled = true
                    descendant.ScrollBarThickness = isMobile and 15 or 8
                    descendant.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
                    descendant.ScrollBarImageTransparency = 0.2
                    
                    -- Auto canvas size if supported
                    if descendant:FindFirstChild("UIListLayout") then
                        descendant.AutomaticCanvasSize = Enum.AutomaticSize.Y
                        descendant.CanvasSize = UDim2.new(0, 0, 0, 0)
                    end
                    
                    -- Enable touch scrolling for mobile
                    descendant.Active = true
                    descendant.Selectable = true
                    
                    -- Mobile-specific touch improvements
                    if isMobile then
                        descendant.ScrollingDirection = Enum.ScrollingDirection.Y
                        descendant.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
                        descendant.ScrollBarImageTransparency = 0.1 -- More visible on mobile
                        
                        -- Force enable touch scrolling
                        local UserInputService = game:GetService("UserInputService")
                        if UserInputService.TouchEnabled then
                            -- Create touch scroll detection
                            local touchStartPos = nil
                            local scrollStartPos = nil
                            
                            descendant.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch then
                                    touchStartPos = input.Position
                                    scrollStartPos = descendant.CanvasPosition
                                end
                            end)
                            
                            descendant.InputChanged:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch and touchStartPos then
                                    local delta = input.Position - touchStartPos
                                    local newScrollPos = scrollStartPos - Vector2.new(0, delta.Y * 2) -- 2x scroll speed
                                    descendant.CanvasPosition = newScrollPos
                                end
                            end)
                            
                            descendant.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch then
                                    touchStartPos = nil
                                    scrollStartPos = nil
                                end
                            end)
                        end
                    end
                    
                    print("XSAN: Fixed scrolling for", descendant.Name, "with touch support")
                end
            end
        end
    end
    
    -- Apply fixes multiple times to ensure they stick
    fixUIForMobile()
    task.wait(2)
    fixUIForMobile()
    
    -- Force refresh UI content
    task.wait(1)
    if Window and Window.Refresh then
        Window:Refresh()
    end
end)

-- Ultimate tabs with all features
print("XSAN: Creating tabs...")
local InfoTab = Window:CreateTab("INFO", 4483362458) -- Use icon ID instead of name
print("XSAN: InfoTab created")
local PresetsTab = Window:CreateTab("PRESETS", 4483362458) -- Use icon ID instead of name
print("XSAN: PresetsTab created")
local MainTab = Window:CreateTab("AUTO FISH", 4483362458) -- Use icon ID instead of name
print("XSAN: MainTab created")
local TeleportTab = Window:CreateTab("TELEPORT", 4483362458) -- Use icon ID instead of name
print("XSAN: TeleportTab created")
local AnalyticsTab = Window:CreateTab("ANALYTICS", 4483362458) -- Use icon ID instead of name
print("XSAN: AnalyticsTab created")
local InventoryTab = Window:CreateTab("INVENTORY", 4483362458) -- Use icon ID instead of name
print("XSAN: InventoryTab created")
local UtilityTab = Window:CreateTab("UTILITY", 4483362458) -- Use icon ID instead of name
print("XSAN: UtilityTab created")

print("XSAN: All tabs created successfully!")

-- Debug tab creation
task.spawn(function()
    task.wait(3)
    pcall(function()
        local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
        if rayfieldGui then
            print("XSAN: Rayfield GUI found, checking tabs...")
            local tabCount = 0
            for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                if descendant:IsA("TextButton") and descendant.Text and (
                    descendant.Text == "INFO" or 
                    descendant.Text == "PRESETS" or 
                    descendant.Text == "AUTO FISH" or 
                    descendant.Text == "TELEPORT" or 
                    descendant.Text == "ANALYTICS" or 
                    descendant.Text == "INVENTORY" or 
                    descendant.Text == "UTILITY"
                ) then
                    tabCount = tabCount + 1
                    print("XSAN: Found tab:", descendant.Text, "Visible:", descendant.Visible, "Transparency:", descendant.BackgroundTransparency)
                end
            end
            
            if tabCount == 0 then
                print("XSAN: WARNING - No tabs found! This might cause black tab issue.")
                if NotifyError then
                    NotifyError("Tab Debug", "⚠️ Tabs not detected!\n\n🔧 Use 'Fix Black Tabs' button in INFO tab\n💡 Or try reloading the script")
                end
            else
                print("XSAN: Found", tabCount, "tabs successfully")
                if NotifySuccess then
                    NotifySuccess("Tab Debug", "✅ Found " .. tabCount .. " tabs!\n\n🎯 If tabs appear black, use fix buttons in INFO tab")
                end
            end
        else
            print("XSAN: ERROR - Rayfield GUI not found!")
            if NotifyError then
                NotifyError("Tab Debug", "❌ Rayfield GUI not found!\n\nThis may cause display issues.")
            end
        end
    end)
end)

-- Fix tab visibility issues
task.spawn(function()
    task.wait(2)
    local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
    if rayfieldGui then
        -- Fix tab container visibility
        for _, descendant in pairs(rayfieldGui:GetDescendants()) do
            if descendant:IsA("Frame") and descendant.Name == "TabContainer" then
                descendant.BackgroundTransparency = 0
                descendant.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                descendant.Visible = true
                print("XSAN: Fixed TabContainer visibility")
            elseif descendant:IsA("TextButton") and descendant.Parent and descendant.Parent.Name == "TabContainer" then
                descendant.BackgroundTransparency = 0.1
                descendant.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                descendant.TextColor3 = Color3.fromRGB(255, 255, 255)
                descendant.Visible = true
                print("XSAN: Fixed tab button:", descendant.Text or descendant.Name)
            elseif descendant:IsA("Frame") and (descendant.Name:find("Tab") or descendant.Name:find("tab")) then
                descendant.Visible = true
                descendant.BackgroundTransparency = 0
                print("XSAN: Fixed tab frame:", descendant.Name)
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- FLOATING TOGGLE BUTTON - Hide/Show UI
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating floating toggle button...")
task.spawn(function()
    task.wait(1) -- Wait for UI to fully load
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Create floating button ScreenGui
    local FloatingButtonGui = Instance.new("ScreenGui")
    FloatingButtonGui.Name = "XSAN_FloatingButton"
    FloatingButtonGui.ResetOnSpawn = false
    FloatingButtonGui.IgnoreGuiInset = true
    FloatingButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui first, then fallback to PlayerGui
    local success = pcall(function()
        FloatingButtonGui.Parent = game.CoreGui
    end)
    if not success then
        FloatingButtonGui.Parent = PlayerGui
    end
    
    -- Create floating button
    local FloatingButton = Instance.new("TextButton")
    FloatingButton.Name = "ToggleButton"
    FloatingButton.Size = UDim2.new(0, isMobile and 70 or 60, 0, isMobile and 70 or 60)
    FloatingButton.Position = UDim2.new(0, 20, 0.5, -35)
    FloatingButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    FloatingButton.BorderSizePixel = 0
    -- Text will be controlled by setFloatingIcon()
    FloatingButton.Text = ""
    FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FloatingButton.TextScaled = true
    FloatingButton.Font = Enum.Font.SourceSansBold
    FloatingButton.Parent = FloatingButtonGui
    
    -- Add UICorner for rounded button
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0.5, 0) -- Perfect circle
    ButtonCorner.Parent = FloatingButton
    
    -- Add UIStroke for better visibility
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
    ButtonStroke.Thickness = 2
    ButtonStroke.Transparency = 0.3
    ButtonStroke.Parent = FloatingButton
    
    -- Add shadow effect
    local ButtonShadow = Instance.new("Frame")
    ButtonShadow.Name = "Shadow"
    ButtonShadow.Size = UDim2.new(1, 4, 1, 4)
    ButtonShadow.Position = UDim2.new(0, 2, 0, 2)
    ButtonShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ButtonShadow.BackgroundTransparency = 0.7
    ButtonShadow.BorderSizePixel = 0
    ButtonShadow.ZIndex = FloatingButton.ZIndex - 1
    ButtonShadow.Parent = FloatingButton
    
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0.5, 0)
    ShadowCorner.Parent = ButtonShadow

    -- Optional icon image (used when UIConfig.floatingButton.useImage = true)
    local IconImage = Instance.new("ImageLabel")
    IconImage.Name = "Icon"
    IconImage.BackgroundTransparency = 1
    IconImage.AnchorPoint = Vector2.new(0.5, 0.5)
    IconImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    IconImage.Size = UDim2.new(0.6, 0, 0.6, 0) -- 60% of button for padding
    IconImage.ScaleType = Enum.ScaleType.Fit
    IconImage.Visible = false
    IconImage.ZIndex = FloatingButton.ZIndex + 1
    IconImage.Parent = FloatingButton

    -- Helper to switch icon based on visibility and configuration
    local function setFloatingIcon(visibleState)
        local cfg = UIConfig.floatingButton
        if cfg.useImage then
            FloatingButton.Text = ""
            IconImage.Visible = true
            IconImage.Image = visibleState and cfg.imageVisible or cfg.imageHidden
        else
            IconImage.Visible = false
            FloatingButton.Text = visibleState and cfg.emojiVisible or cfg.emojiHidden
        end
    end
    
    -- Initialize icon state
    setFloatingIcon(true)

    -- Variables
    local isUIVisible = true
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    -- Get Rayfield GUI reference
    local function getRayfieldGui()
        return LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
    end
    
    -- Toggle UI visibility function
    local function toggleUI()
        pcall(function()
            local rayfieldGui = getRayfieldGui()
            if rayfieldGui then
                isUIVisible = not isUIVisible
                
                -- Update button appearance
                if isUIVisible then
                    setFloatingIcon(true)
                    FloatingButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
                    rayfieldGui.Enabled = true
                    
                    -- Animate show
                    rayfieldGui.Main.BackgroundTransparency = 1
                    TweenService:Create(rayfieldGui.Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0
                    }):Play()
                    
                    if NotifySuccess then
                        NotifySuccess("UI Toggle", "XSAN Fish It Pro UI shown!")
                    end
                else
                    setFloatingIcon(false)
                    FloatingButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
                    
                    -- Animate hide
                    TweenService:Create(rayfieldGui.Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                        BackgroundTransparency = 1
                    }):Play()
                    
                    task.wait(0.3)
                    rayfieldGui.Enabled = false
                    if NotifyInfo then
                        NotifyInfo("UI Toggle", "UI hidden! Use floating button to show.")
                    end
                end
                
                -- Button feedback animation
                TweenService:Create(FloatingButton, TweenInfo.new(0.1, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, (isMobile and 70 or 60) * 1.1, 0, (isMobile and 70 or 60) * 1.1)
                }):Play()
                
                task.wait(0.1)
                TweenService:Create(FloatingButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, isMobile and 70 or 60, 0, isMobile and 70 or 60)
                }):Play()
            end
        end)
    end
    
    -- Make button draggable
    local function updateDrag(input)
        local delta = input.Position - dragStart
        FloatingButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    FloatingButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = FloatingButton.Position
            
            -- Visual feedback for drag start
            TweenService:Create(FloatingButton, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(100, 160, 230)
            }):Play()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    -- Reset color
                    TweenService:Create(FloatingButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = isUIVisible and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(200, 100, 100)
                    }):Play()
                end
            end)
        end
    end)
    
    FloatingButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- Click to toggle (only if not dragging significantly)
    FloatingButton.MouseButton1Click:Connect(function()
        if not dragging then
            toggleUI()
        end
    end)
    
    -- Right click or long press to access menu
    FloatingButton.MouseButton2Click:Connect(function()
        if not dragging then
            -- Create mini context menu
            local ContextMenu = Instance.new("Frame")
            ContextMenu.Name = "ContextMenu"
            ContextMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ContextMenu.BorderSizePixel = 0
            ContextMenu.Position = UDim2.new(0, FloatingButton.AbsolutePosition.X + 80, 0, FloatingButton.AbsolutePosition.Y)
            ContextMenu.Size = UDim2.new(0, 120, 0, 0)
            ContextMenu.AutomaticSize = Enum.AutomaticSize.Y
            ContextMenu.ZIndex = 20
            ContextMenu.Parent = FloatingButtonGui
            
            -- Add UICorner
            local MenuCorner = Instance.new("UICorner")
            MenuCorner.CornerRadius = UDim.new(0, 8)
            MenuCorner.Parent = ContextMenu
            
            -- Add UIListLayout
            local MenuLayout = Instance.new("UIListLayout")
            MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
            MenuLayout.Padding = UDim.new(0, 2)
            MenuLayout.Parent = ContextMenu
            
            -- Add UIPadding
            local MenuPadding = Instance.new("UIPadding")
            MenuPadding.PaddingTop = UDim.new(0, 5)
            MenuPadding.PaddingBottom = UDim.new(0, 5)
            MenuPadding.PaddingLeft = UDim.new(0, 8)
            MenuPadding.PaddingRight = UDim.new(0, 8)
            MenuPadding.Parent = ContextMenu
            
            -- Close Button
            local CloseButton = Instance.new("TextButton")
            CloseButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
            CloseButton.BorderSizePixel = 0
            CloseButton.Size = UDim2.new(1, 0, 0, 30)
            CloseButton.Font = Enum.Font.SourceSansBold
            CloseButton.Text = "❌ Close Script"
            CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            CloseButton.TextScaled = true
            CloseButton.LayoutOrder = 1
            CloseButton.Parent = ContextMenu
            
            local CloseCorner = Instance.new("UICorner")
            CloseCorner.CornerRadius = UDim.new(0, 5)
            CloseCorner.Parent = CloseButton
            
            CloseButton.MouseButton1Click:Connect(function()
                -- Destroy all XSAN GUIs
                if getRayfieldGui() then
                    getRayfieldGui():Destroy()
                end
                FloatingButtonGui:Destroy()
                NotifyInfo("XSAN", "Script closed. Thanks for using XSAN Fish It Pro!")
            end)
            
            -- Minimize Button
            local MinimizeButton = Instance.new("TextButton")
            MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
            MinimizeButton.BorderSizePixel = 0
            MinimizeButton.Size = UDim2.new(1, 0, 0, 30)
            MinimizeButton.Font = Enum.Font.SourceSans
            MinimizeButton.Text = "➖ Minimize"
            MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            MinimizeButton.TextScaled = true
            MinimizeButton.LayoutOrder = 2
            MinimizeButton.Parent = ContextMenu
            
            local MinimizeCorner = Instance.new("UICorner")
            MinimizeCorner.CornerRadius = UDim.new(0, 5)
            MinimizeCorner.Parent = MinimizeButton
            
            MinimizeButton.MouseButton1Click:Connect(function()
                if isUIVisible then
                    toggleUI()
                end
                ContextMenu:Destroy()
            end)
            
            -- Auto-close menu after 3 seconds
            task.spawn(function()
                task.wait(3)
                if ContextMenu.Parent then
                    ContextMenu:Destroy()
                end
            end)
            
            -- Close menu when clicking outside
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mousePos = UserInputService:GetMouseLocation()
                    local menuPos = ContextMenu.AbsolutePosition
                    local menuSize = ContextMenu.AbsoluteSize
                    
                    if mousePos.X < menuPos.X or mousePos.X > menuPos.X + menuSize.X or
                       mousePos.Y < menuPos.Y or mousePos.Y > menuPos.Y + menuSize.Y then
                        if ContextMenu.Parent then
                            ContextMenu:Destroy()
                        end
                    end
                end
            end)
        end
    end)
    
    -- Hover effects for desktop
    if not isMobile then
        FloatingButton.MouseEnter:Connect(function()
            if not dragging then
                TweenService:Create(FloatingButton, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 65, 0, 65),
                    BackgroundColor3 = isUIVisible and Color3.fromRGB(90, 150, 220) or Color3.fromRGB(220, 120, 120)
                }):Play()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {
                    Transparency = 0.1
                }):Play()
            end
        end)
        
        FloatingButton.MouseLeave:Connect(function()
            if not dragging then
                TweenService:Create(FloatingButton, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 60, 0, 60),
                    BackgroundColor3 = isUIVisible and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(200, 100, 100)
                }):Play()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {
                    Transparency = 0.3
                }):Play()
            end
        end)
    end
    
    -- Keyboard shortcut for toggle (H key)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.H then
            toggleUI()
        end
    end)
    
    print("XSAN: Floating toggle button created successfully!")
    print("XSAN: - Click button to hide/show UI")
    print("XSAN: - Drag button to move position")
    print("XSAN: - Press 'H' key to toggle UI")
end)

-- Load Remotes
print("XSAN: Loading remotes...")
local net, rodRemote, miniGameRemote, finishRemote, equipRemote

local function initializeRemotes()
    local success, error = pcall(function()
        net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
        print("XSAN: Net found")
        rodRemote = net:WaitForChild("RF/ChargeFishingRod")
        print("XSAN: Rod remote found")
        miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted") 
        print("XSAN: MiniGame remote found")
        finishRemote = net:WaitForChild("RE/FishingCompleted")
        print("XSAN: Finish remote found")
        equipRemote = net:WaitForChild("RE/EquipToolFromHotbar")
        print("XSAN: Equip remote found")
    end)
    
    if not success then
        warn("XSAN: Error loading remotes:", error)
        Notify("XSAN Error", "Failed to load game remotes. Some features may not work.", 5)
        return false
    end
    
    return true
end

local remotesLoaded = initializeRemotes()
print("XSAN: Remotes loading completed! Status:", remotesLoaded)

-- State Variables
print("XSAN: Initializing variables...")
local autofish = false
local perfectCast = false
local safeMode = false  -- Safe Mode for random perfect cast
local safeModeChance = 70  -- 70% chance for perfect cast in safe mode
local hybridMode = false  -- Hybrid Mode for ultimate security
local hybridPerfectChance = 70  -- Hybrid mode perfect cast chance
local hybridMinDelay = 1.0  -- Hybrid mode minimum delay
local hybridMaxDelay = 2.5  -- Hybrid mode maximum delay
local hybridAutoFish = nil  -- Hybrid auto fish instance
local autoRecastDelay = 0.5
local fishCaught = 0
local itemsSold = 0
local autoSellThreshold = 10
local autoSellOnThreshold = false
local sessionStartTime = tick()
local perfectCasts = 0
local normalCasts = 0  -- Track normal casts for analytics
local currentPreset = "None"
local globalAutoSellEnabled = true  -- Global auto sell control

-- Feature states
local featureState = {
    AutoSell = false,
    SmartInventory = false,
    Analytics = true,
    Safety = true,
}

print("XSAN: Variables initialized successfully!")

-- ═══════════════════════════════════════════════════════════════
-- WALKSPEED SYSTEM
-- ═══════════════════════════════════════════════════════════════
local walkspeedEnabled = false
local currentWalkspeed = 16
local defaultWalkspeed = 16

local function setWalkSpeed(speed)
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            currentWalkspeed = speed
            NotifySuccess("Walk Speed", "Walk speed set to " .. speed)
        else
            NotifyError("Walk Speed", "Character or Humanoid not found")
        end
    end)
    
    if not success then
        NotifyError("Walk Speed", "Failed to set walk speed: " .. tostring(error))
    end
end

local function resetWalkSpeed()
    setWalkSpeed(defaultWalkspeed)
    walkspeedEnabled = false
end

-- Auto-restore walkspeed when character spawns
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1) -- Wait for character to fully load
    if walkspeedEnabled and currentWalkspeed ~= defaultWalkspeed then
        setWalkSpeed(currentWalkspeed)
    end
end)

print("XSAN: Walkspeed system initialized!")

-- ═══════════════════════════════════════════════════════════════
-- UNLIMITED JUMP SYSTEM
-- ═══════════════════════════════════════════════════════════════
local unlimitedJumpEnabled = false
local currentJumpHeight = 7.2 -- Default Roblox jump height
local defaultJumpHeight = 7.2
local unlimitedJumpConnection = nil

local function setJumpHeight(height)
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpHeight = height
            currentJumpHeight = height
            NotifySuccess("Jump Height", "Jump height set to " .. height)
        else
            NotifyError("Jump Height", "Character or Humanoid not found")
        end
    end)
    
    if not success then
        NotifyError("Jump Height", "Failed to set jump height: " .. tostring(error))
    end
end

local function enableUnlimitedJump()
    if unlimitedJumpEnabled then return end
    
    unlimitedJumpEnabled = true
    
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            -- Method 1: Set very high jump height
            humanoid.JumpHeight = 50
            currentJumpHeight = 50
            
            -- Method 2: Enable infinite jumps via UserInputService
            if UserInputService then
                unlimitedJumpConnection = UserInputService.JumpRequest:Connect(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
            
            NotifySuccess("Unlimited Jump", "✅ Unlimited Jump ENABLED!\n\n🚀 Jump height: 50\n⚡ Infinite jumps: Active\n🎯 Press space repeatedly to fly!")
        else
            NotifyError("Unlimited Jump", "Character or Humanoid not found!")
        end
    end)
    
    if not success then
        NotifyError("Unlimited Jump", "Failed to enable unlimited jump: " .. tostring(error))
        unlimitedJumpEnabled = false
    end
end

local function disableUnlimitedJump()
    if not unlimitedJumpEnabled then return end
    
    unlimitedJumpEnabled = false
    
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpHeight = defaultJumpHeight
            currentJumpHeight = defaultJumpHeight
        end
        
        -- Disconnect infinite jump connection
        if unlimitedJumpConnection then
            unlimitedJumpConnection:Disconnect()
            unlimitedJumpConnection = nil
        end
        
        NotifyInfo("Unlimited Jump", "❌ Unlimited Jump DISABLED\n\n📉 Jump height: Normal (7.2)\n🚫 Infinite jumps: Disabled")
    end)
    
    if not success then
        NotifyError("Unlimited Jump", "Failed to disable unlimited jump: " .. tostring(error))
    end
end

local function toggleUnlimitedJump()
    if unlimitedJumpEnabled then
        disableUnlimitedJump()
    else
        enableUnlimitedJump()
    end
end

-- Auto-restore unlimited jump when character spawns
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1) -- Wait for character to fully load
    if unlimitedJumpEnabled then
        -- Re-enable unlimited jump for new character
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpHeight = 50
            NotifyInfo("Character Spawn", "🔄 Unlimited Jump restored for new character!")
        end
    elseif currentJumpHeight ~= defaultJumpHeight then
        -- Restore custom jump height
        setJumpHeight(currentJumpHeight)
    end
end)

print("XSAN: Unlimited Jump system initialized!")

-- XSAN Ultimate Teleportation System
print("XSAN: Initializing teleportation system...")

-- Dynamic Teleportation Data (like old.lua)
local TeleportLocations = {
    Islands = {},
    NPCs = {},
    Events = {}
}

-- Get island locations dynamically from workspace (same as old.lua)
local tpFolder = workspace:FindFirstChild("!!!! ISLAND LOCATIONS !!!!")
if tpFolder then
    for _, island in ipairs(tpFolder:GetChildren()) do
        if island:IsA("BasePart") then
            TeleportLocations.Islands[island.Name] = island.CFrame
            print("XSAN: Found island - " .. island.Name)
        end
    end
else
    -- Fallback to hardcoded coordinates if workspace folder not found
    print("XSAN: Island folder not found, using updated fallback coordinates")
    TeleportLocations.Islands = {
        -- Updated island coordinates from detector (Latest 2025)
        ["Kohana Volcano"] = CFrame.new(-594.98, 40.86, 149.11),
        ["Crater Island"] = CFrame.new(955.66, 4.01, 5133.32),
        ["Kohana"] = CFrame.new(-678.12, 3.04, 718.07),
        ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801),
        ["Stingray Shores"] = CFrame.new(45.2788086, 252.562927, 2987.10913),
        ["Esoteric Depths"] = CFrame.new(2102.20, -27.69, 1356.11),
        ["Weather Machine"] = CFrame.new(-1488.52, 29.58, 1876.30),
        ["Tropical Grove"] = CFrame.new(-2095.34, 6.26, 3718.08),
        ["Coral Reefs"] = CFrame.new(-3023.97119, 337.812927, 2195.60913),
        -- Legacy coordinates (backup)
        ["Moosewood"] = CFrame.new(389, 137, 264),
        ["Ocean"] = CFrame.new(1082, 124, -924),
        ["Snowcap Island"] = CFrame.new(2648, 140, 2522),
        ["Mushgrove Swamp"] = CFrame.new(-1817, 138, 1808),
        ["Roslit Bay"] = CFrame.new(-1442, 135, 1006),
        ["Sunstone Island"] = CFrame.new(-934, 135, -1122),
        ["Statue Of Sovereignty"] = CFrame.new(1, 140, -918),
        ["Moonstone Island"] = CFrame.new(-3004, 135, -1157),
        ["Forsaken Shores"] = CFrame.new(-2853, 135, 1627),
        ["Ancient Isle"] = CFrame.new(5896, 137, 4516),
        ["Keepers Altar"] = CFrame.new(1296, 135, -808),
        ["Brine Pool"] = CFrame.new(-1804, 135, 3265),
        ["The Depths"] = CFrame.new(994, -715, 1226),
        ["Vertigo"] = CFrame.new(-111, -515, 1049),
        ["Volcano"] = CFrame.new(-1888, 164, 330)
    }
end

-- NPCs Detection System - Real-time accurate locations
local function DetectNPCLocations()
    local detectedNPCs = {}
    
    -- Method 1: Check ReplicatedStorage NPCs (Most Accurate)
    local npcContainer = ReplicatedStorage:FindFirstChild("NPC")
    if npcContainer then
        print("XSAN: Scanning ReplicatedStorage NPCs...")
        for _, npc in pairs(npcContainer:GetChildren()) do
            if npc:FindFirstChild("WorldPivot") then
                local pos = npc.WorldPivot.Position
                local emoji = "👤"
                
                -- Add specific emojis based on NPC names
                if string.find(npc.Name:lower(), "alex") or string.find(npc.Name:lower(), "shop") then
                    emoji = "🛒"
                elseif string.find(npc.Name:lower(), "marc") or string.find(npc.Name:lower(), "rod") then
                    emoji = "🎣"
                elseif string.find(npc.Name:lower(), "henry") or string.find(npc.Name:lower(), "storage") then
                    emoji = "📦"
                elseif string.find(npc.Name:lower(), "scientist") then
                    emoji = "🔬"
                elseif string.find(npc.Name:lower(), "boat") then
                    emoji = "⚓"
                elseif string.find(npc.Name:lower(), "angler") then
                    emoji = "🏆"
                elseif string.find(npc.Name:lower(), "scott") then
                    emoji = "🐧"
                elseif string.find(npc.Name:lower(), "billy") or string.find(npc.Name:lower(), "bob") then
                    emoji = "🐟"
                elseif string.find(npc.Name:lower(), "fish") then
                    emoji = "🎣"
                end
                
                detectedNPCs[emoji .. " " .. npc.Name] = CFrame.new(pos)
                print("XSAN: Found NPC -", npc.Name, "at", pos)
            end
        end
    end
    
    -- Method 2: Check Workspace NPCs (Backup method)
    print("XSAN: Scanning Workspace NPCs...")
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= LocalPlayer.Name then
            -- Skip player characters
            local isPlayerCharacter = false
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character == obj then
                    isPlayerCharacter = true
                    break
                end
            end
            
            if not isPlayerCharacter then
                local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                if rootPart then
                    local emoji = "👤"
                    
                    -- Check if this NPC is important (not already detected)
                    local isImportant = false
                    local npcName = obj.Name
                    
                    if string.find(npcName:lower(), "alex") or string.find(npcName:lower(), "shop") then
                        emoji = "🛒"
                        isImportant = true
                    elseif string.find(npcName:lower(), "marc") or string.find(npcName:lower(), "rod") then
                        emoji = "🎣"
                        isImportant = true
                    elseif string.find(npcName:lower(), "henry") or string.find(npcName:lower(), "storage") then
                        emoji = "📦"
                        isImportant = true
                    elseif string.find(npcName:lower(), "scientist") then
                        emoji = "🔬"
                        isImportant = true
                    elseif string.find(npcName:lower(), "boat") then
                        emoji = "⚓"
                        isImportant = true
                    elseif string.find(npcName:lower(), "angler") then
                        emoji = "🏆"
                        isImportant = true
                    end
                    
                    if isImportant then
                        local key = emoji .. " " .. npcName
                        if not detectedNPCs[key] then -- Only add if not already detected
                            detectedNPCs[key] = rootPart.CFrame
                            print("XSAN: Found Workspace NPC -", npcName, "at", rootPart.Position)
                        end
                    end
                end
            end
        end
    end
    
    return detectedNPCs
end

-- Initialize NPCs with real-time detection
print("XSAN: Detecting NPC locations in real-time...")
local detectedNPCs = DetectNPCLocations()

-- Updated fallback NPCs (Latest 2025 coordinates - Only used if detection fails)
local fallbackNPCs = {
    -- Primary NPCs (Most frequently used)
    ["🛒 Shop (Alex)"] = CFrame.new(-31.10, 4.84, 2899.03),
    ["🎣 Rod Shop (Marc)"] = CFrame.new(454, 150, 229),
    ["📦 Storage (Henry)"] = CFrame.new(491, 150, 272),
    ["🏆 Angler"] = CFrame.new(484, 150, 331),
    
    -- Secondary NPCs (Backup only)
    ["🛒 Shop (Joe)"] = CFrame.new(114.39, 4.75, 2882.38),
    ["🛒 Shop (Seth)"] = CFrame.new(70.96, 4.84, 2895.36),
    ["⚓ Boat Expert"] = CFrame.new(23.39, 4.70, 2804.16),
    ["🔬 Scientist"] = CFrame.new(-8.64, 4.50, 2849.57),
    ["🐟 Billy Bob"] = CFrame.new(72.05, 29.00, 2950.63),
    ["🎣 Silly Fisherman"] = CFrame.new(93.53, 27.24, 3009.08),
    ["🐧 Scott"] = CFrame.new(-81.94, 4.80, 2866.59)
}

-- Smart NPC Selection: Use detected NPCs first, fallback if needed
if next(detectedNPCs) then
    local detectedCount = 0
    for _ in pairs(detectedNPCs) do detectedCount = detectedCount + 1 end
    
    TeleportLocations.NPCs = detectedNPCs
    print("XSAN: ✅ Using REAL-TIME detected NPC locations! Found", detectedCount, "NPCs")
    NotifySuccess("NPC Detection", "✅ Real-time NPC locations detected!\n📍 " .. detectedCount .. " NPCs found with accurate positions.\n🔄 Auto-refresh: Active")
    
    -- Merge important fallback NPCs if not detected
    for fallbackName, fallbackCFrame in pairs(fallbackNPCs) do
        if not detectedNPCs[fallbackName] then
            TeleportLocations.NPCs[fallbackName .. " (Fallback)"] = fallbackCFrame
            print("XSAN: Added fallback NPC:", fallbackName)
        end
    end
else
    TeleportLocations.NPCs = fallbackNPCs
    print("XSAN: ⚠️ Real-time detection failed - Using fallback NPC locations")
    NotifyInfo("NPC Detection", "⚠️ Using fallback NPC locations.\n🔄 Real-time detection will retry automatically.\n📍 11 NPCs loaded from backup database")
end

TeleportLocations.Events = {
    ["🌟 Ice Island"] = CFrame.new(2167.70, 6.55, 3269.64),
    ["🦈 Stone Ocean"] = CFrame.new(-2712.71, 77.29, 23.05),
    ["❄️ Whale Event"] = CFrame.new(2167.70, 6.55, 3269.64),
    ["🔥 Volcano Event"] = CFrame.new(-1888, 164, 330),
  	["⚜️ Sisypus Statue"] = CFrame.new(-3746.41, -135.08, -1044.32),
    ["⚜ Treasure Hall"] = CFrame.new(-3599.37, -271.69, -1530.96),
    ["🌑 Enchant Stone"] = CFrame.new(3237.61, -1302.33, 1398.04)
}

-- Safe Teleportation Function
local function SafeTeleport(targetCFrame, locationName)
    pcall(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            NotifyError("Teleport", "Character not found! Cannot teleport.")
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        
        -- Smooth teleportation with fade effect
        local originalCFrame = humanoidRootPart.CFrame
        
        -- Teleport with slight offset to avoid collision
        local safePosition = targetCFrame.Position + Vector3.new(0, 5, 0)
        humanoidRootPart.CFrame = CFrame.new(safePosition) * CFrame.Angles(0, math.rad(math.random(-180, 180)), 0)
        
        wait(0.1)
        
        -- Lower to ground
        humanoidRootPart.CFrame = targetCFrame
        
        NotifySuccess("Teleport", "Successfully teleported to: " .. locationName)
        
        -- Log teleportation for analytics
        print("XSAN Teleport: " .. LocalPlayer.Name .. " -> " .. locationName)
    end)
end

-- Player Teleportation Function (improved like old.lua)
local function TeleportToPlayer(targetPlayerName)
    pcall(function()
        -- Try to find in workspace Characters folder first (like old.lua)
        local charFolder = workspace:FindFirstChild("Characters")
        local targetCharacter = nil
        
        if charFolder then
            targetCharacter = charFolder:FindFirstChild(targetPlayerName)
        end
        
        -- Fallback to Players service
        if not targetCharacter then
            local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
            if targetPlayer then
                targetCharacter = targetPlayer.Character
            end
        end
        
        if not targetCharacter then
            NotifyError("Player TP", "Player '" .. targetPlayerName .. "' not found!")
            return
        end
        
        local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetHRP then
            NotifyError("Player TP", "Target player's character not found!")
            return
        end
        
        SafeTeleport(targetHRP.CFrame, targetPlayerName .. "'s location")
    end)
end

print("XSAN: Teleportation system initialized successfully!")

-- Auto-refresh NPC locations system (Background task)
task.spawn(function()
    while true do
        task.wait(30) -- Check every 30 seconds
        pcall(function()
            local updatedNPCs = DetectNPCLocations()
            if next(updatedNPCs) then
                local oldCount = 0
                local newCount = 0
                
                for _ in pairs(TeleportLocations.NPCs) do oldCount = oldCount + 1 end
                for _ in pairs(updatedNPCs) do newCount = newCount + 1 end
                
                -- Update if we found more NPCs or different locations
                if newCount > oldCount then
                    TeleportLocations.NPCs = updatedNPCs
                    print("XSAN Auto-Refresh: Updated NPC locations -", newCount, "NPCs detected")
                end
            end
        end)
    end
end)

-- Count islands and print debug info
local islandCount = 0
for _ in pairs(TeleportLocations.Islands) do
    islandCount = islandCount + 1
end

print("XSAN: Found " .. islandCount .. " islands for teleportation")
print("XSAN: Using dynamic location system like old.lua for accuracy")

-- Analytics Functions
local function CalculateFishPerHour()
    local timeElapsed = (tick() - sessionStartTime) / 3600
    if timeElapsed > 0 then
        return math.floor(fishCaught / timeElapsed)
    end
    return 0
end

local function CalculateProfit()
    local avgFishValue = 50
    return fishCaught * avgFishValue
end

-- Quick Start Presets
local function ApplyPreset(presetName)
    currentPreset = presetName
    
    if presetName == "Beginner" then
        autoRecastDelay = 2.0
        perfectCast = false
        safeMode = false
        autoSellThreshold = 10000
        autoSellOnThreshold = globalAutoSellEnabled  -- Use global setting
        NotifySuccess("Preset Applied", "Beginner mode activated - Safe and easy settings" .. (globalAutoSellEnabled and " (Auto Sell: ON)" or " (Auto Sell: OFF)"))
        
    elseif presetName == "Speed" then
        autoRecastDelay = 0.5
        perfectCast = true
        safeMode = false
        autoSellThreshold = 10000
        autoSellOnThreshold = globalAutoSellEnabled  -- Use global setting
        NotifySuccess("Preset Applied", "Speed mode activated - Maximum fishing speed" .. (globalAutoSellEnabled and " (Auto Sell: ON)" or " (Auto Sell: OFF)"))
        
    elseif presetName == "Profit" then
        autoRecastDelay = 1.0
        perfectCast = true
        safeMode = false
        autoSellThreshold = 10000
        autoSellOnThreshold = globalAutoSellEnabled  -- Use global setting
        NotifySuccess("Preset Applied", "Profit mode activated - Optimized for maximum earnings" .. (globalAutoSellEnabled and " (Auto Sell: ON)" or " (Auto Sell: OFF)"))
        
    elseif presetName == "AFK" then
        autoRecastDelay = 1.5
        perfectCast = true
        safeMode = false
        autoSellThreshold = 10000
        autoSellOnThreshold = globalAutoSellEnabled  -- Use global setting
        NotifySuccess("Preset Applied", "AFK mode activated - Safe for long sessions" .. (globalAutoSellEnabled and " (Auto Sell: ON)" or " (Auto Sell: OFF)"))
        
    elseif presetName == "Safe" then
        autoRecastDelay = 1.2
        perfectCast = false
        safeMode = true
        safeModeChance = 70
        autoSellThreshold = 10000
        autoSellOnThreshold = globalAutoSellEnabled
        NotifySuccess("Preset Applied", "Safe mode activated - Smart random casting (70% perfect, 30% normal)" .. (globalAutoSellEnabled and " (Auto Sell: ON)" or " (Auto Sell: OFF)"))
        
    elseif presetName == "Hybrid" then
        autoRecastDelay = 1.5
        perfectCast = false
        safeMode = false
        hybridMode = true
        hybridPerfectChance = 75
        hybridMinDelay = 1.0
        hybridMaxDelay = 2.8
        autoSellThreshold = 10000
        autoSellOnThreshold = globalAutoSellEnabled
        NotifySuccess("Preset Applied", "🔒 HYBRID ULTIMATE MODE ACTIVATED!\n✅ Server Time Sync\n✅ Human-like AI Patterns\n✅ Anti-Detection Technology\n✅ Maximum Security" .. (globalAutoSellEnabled and "\n💰 Auto Sell: ON" or "\n💰 Auto Sell: OFF"))
        
    elseif presetName == "AutoSellOn" then
        globalAutoSellEnabled = true
        autoSellOnThreshold = true
        NotifySuccess("Auto Sell", "Global Auto Sell activated - Will apply to all future presets at " .. autoSellThreshold .. " fish")
        
    elseif presetName == "AutoSellOff" then
        globalAutoSellEnabled = false
        autoSellOnThreshold = false
        NotifySuccess("Auto Sell", "Global Auto Sell deactivated - Manual selling only for all presets")
    end
end

-- Auto Sell Function
local function CheckAndAutoSell()
    if autoSellOnThreshold and fishCaught >= autoSellThreshold then
        pcall(function()
            if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end

            local npcContainer = ReplicatedStorage:FindFirstChild("NPC")
            local alexNpc = npcContainer and npcContainer:FindFirstChild("Alex")

            if not alexNpc then
                NotifyError("Auto Sell", "NPC 'Alex' not found! Cannot auto sell.")
                return
            end

            local originalCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            local npcPosition = alexNpc.WorldPivot.Position

            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(npcPosition)
            wait(1)

            ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]:InvokeServer()
            wait(1)

            LocalPlayer.Character.HumanoidRootPart.CFrame = originalCFrame
            itemsSold = itemsSold + 1
            fishCaught = 0
            
            NotifySuccess("Auto Sell", "Automatically sold items! Fish count: " .. autoSellThreshold .. " reached.")
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- INFO TAB - XSAN Branding Section
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating INFO tab content...")
InfoTab:CreateParagraph({
    Title = "XSAN Fish It Pro Ultimate v1.0",
    Content = "The most advanced Fish It script New Full Featurs "
})

InfoTab:CreateParagraph({
    Title = "Ultimate Features",
    Content = "Auto Fish,Teleport,Best Spot Fishing And More"
})

InfoTab:CreateParagraph({
    Title = "Follow XSAN",
    Content = "Stay updated with the latest scripts and features Telegram Groub t.me/Spinner_xxx"
})

InfoTab:CreateButton({ 
    Name = "Groub Telegram Link", 
    Callback = CreateSafeCallback(function() 
        if setclipboard then
            setclipboard("https://t.me/spinner_xxx") 
            NotifySuccess("Social Media", "Telegram link copied! Follow for updates and support!")
        else
            NotifyInfo("Social Media", "Telegram: @Spinnerxxx")
        end
    end, "instagram")
})

InfoTab:CreateButton({ 
    Name = "Link Telegram", 
    Callback = CreateSafeCallback(function() 
        if setclipboard then
            setclipboard("https://t.me/Spinner_xxx") 
            NotifySuccess("Social Media", "Telegram Check out more premium scripts!")
        else
            NotifyInfo("Social Media", "Telegram: t.me/spinner_xxx")
        end
    end, "github")
})

InfoTab:CreateButton({ 
    Name = "Fix UI Scrolling", 
    Callback = CreateSafeCallback(function() 
        local function fixScrollingFrames()
            local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
            if rayfieldGui then
                local fixed = 0
                for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                    if descendant:IsA("ScrollingFrame") then
                        -- Enable proper scrolling
                        descendant.ScrollingEnabled = true
                        descendant.ScrollBarThickness = 8
                        descendant.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
                        descendant.ScrollBarImageTransparency = 0.3
                        
                        -- Auto canvas size if supported
                        if descendant:FindFirstChild("UIListLayout") then
                            descendant.AutomaticCanvasSize = Enum.AutomaticSize.Y
                            descendant.CanvasSize = UDim2.new(0, 0, 0, 0)
                        end
                        
                        -- Enable mouse wheel scrolling
                        descendant.Active = true
                        descendant.Selectable = true
                        
                        fixed = fixed + 1
                    end
                end
                NotifySuccess("UI Fix", "Fixed scrolling for " .. fixed .. " elements. You can now scroll through tabs!")
            else
                NotifyError("UI Fix", "Rayfield GUI not found")
            end
        end
        
        fixScrollingFrames()
    end, "fix_scrolling")
})

InfoTab:CreateButton({ 
    Name = "🔧 Fix Black Tabs", 
    Callback = CreateSafeCallback(function() 
        local function fixTabVisibility()
            local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
            if rayfieldGui then
                local fixedTabs = 0
                
                for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                    -- Fix tab containers
                    if descendant:IsA("Frame") and (descendant.Name == "TabContainer" or descendant.Name:find("Tab")) then
                        descendant.BackgroundTransparency = 0
                        descendant.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        descendant.Visible = true
                        fixedTabs = fixedTabs + 1
                    end
                    
                    -- Fix tab buttons
                    if descendant:IsA("TextButton") and descendant.Parent and descendant.Parent.Name == "TabContainer" then
                        descendant.BackgroundTransparency = 0.1
                        descendant.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        descendant.TextColor3 = Color3.fromRGB(255, 255, 255)
                        descendant.BorderSizePixel = 1
                        descendant.BorderColor3 = Color3.fromRGB(100, 100, 100)
                        descendant.Visible = true
                        fixedTabs = fixedTabs + 1
                    end
                    
                    -- Fix tab content frames
                    if descendant:IsA("Frame") and descendant.Name:find("Content") then
                        descendant.BackgroundTransparency = 0
                        descendant.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        descendant.Visible = true
                    end
                    
                    -- Fix any transparent elements
                    if descendant:IsA("GuiObject") and descendant.BackgroundTransparency >= 1 then
                        descendant.BackgroundTransparency = 0.1
                        descendant.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    end
                end
                
                NotifySuccess("Tab Fix", "✅ Fixed " .. fixedTabs .. " tab elements!\n\n🎯 Tabs should now be visible\n🔄 If still black, try switching themes")
            else
                NotifyError("Tab Fix", "❌ Rayfield GUI not found!")
            end
        end
        
        fixTabVisibility()
    end, "fix_tabs")
})

InfoTab:CreateButton({ 
    Name = "🎨 Change Theme", 
    Callback = CreateSafeCallback(function() 
        NotifyInfo("Theme Change", "🎨 Available Themes:\n• Ocean (Current)\n• Default\n• Amethyst\n• DarkBlue\n\n⚠️ Reload script to change theme\n💡 Try different themes if tabs appear black")
    end, "change_theme")
})

print("XSAN: INFO tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- PRESETS TAB - Quick Start Configurations
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating PRESETS tab content...")
PresetsTab:CreateParagraph({
    Title = "XSAN Quick Start Presets",
    Content = "Instantly configure the script with optimal settings for different use cases. Perfect for beginners or quick setup!"
})

PresetsTab:CreateButton({
    Name = "Beginner Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Beginner")
    end, "preset_beginner")
})

PresetsTab:CreateButton({
    Name = "Speed Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Speed")
    end, "preset_speed")
})

PresetsTab:CreateButton({
    Name = "Profit Mode", 
    Callback = CreateSafeCallback(function()
        ApplyPreset("Profit")
    end, "preset_profit")
})

PresetsTab:CreateButton({
    Name = "AFK Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("AFK") 
    end, "preset_afk")
})

PresetsTab:CreateButton({
    Name = "🛡️ Safe Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Safe") 
    end, "preset_safe")
})

PresetsTab:CreateButton({
    Name = "🔒 HYBRID MODE (Ultimate)",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Hybrid") 
    end, "preset_hybrid")
})

PresetsTab:CreateParagraph({
    Title = "Auto Sell Global Controls",
    Content = "Global auto sell control - When you set Auto Sell ON/OFF, it will apply to ALL preset modes. This gives you master control over auto selling."
})

PresetsTab:CreateButton({
    Name = "🟢 Global Auto Sell ON",
    Callback = CreateSafeCallback(function()
        ApplyPreset("AutoSellOn")
    end, "preset_autosell_on")
})

PresetsTab:CreateButton({
    Name = "🔴 Global Auto Sell OFF",
    Callback = CreateSafeCallback(function()
        ApplyPreset("AutoSellOff")
    end, "preset_autosell_off")
})

print("XSAN: PRESETS tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- TELEPORT TAB - Ultimate Teleportation System
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating TELEPORT tab content...")
TeleportTab:CreateParagraph({
    Title = "XSAN Ultimate Teleport System",
    Content = "Instant teleportation to any location with smart safety features. The most advanced teleportation system for Fish It!"
})

-- Islands Section
TeleportTab:CreateParagraph({
    Title = "🏝️ Island Teleportation",
    Content = "Quick access to all fishing locations and islands. Perfect for exploring and finding the best fishing spots!"
})

-- Create buttons for each island (dynamic like old.lua)
for locationName, cframe in pairs(TeleportLocations.Islands) do
    -- Add emoji prefix if not already present with more specific icons
    local displayName = locationName
    if not string.find(locationName, "🏝️") and not string.find(locationName, "🌊") and not string.find(locationName, "🏔️") and not string.find(locationName, "🌋") and not string.find(locationName, "❄️") and not string.find(locationName, "🏛️") then
        -- Add specific icons based on location names
        if string.find(locationName:lower(), "volcano") or string.find(locationName:lower(), "crater") then
            displayName = "🌋 " .. locationName
        elseif string.find(locationName:lower(), "snow") or string.find(locationName:lower(), "ice") then
            displayName = locationName
        elseif string.find(locationName:lower(), "depth") or string.find(locationName:lower(), "ocean") then
            displayName = locationName
        elseif string.find(locationName:lower(), "ancient") or string.find(locationName:lower(), "statue") or string.find(locationName:lower(), "altar") then
            displayName = locationName
        elseif string.find(locationName:lower(), "mountain") or string.find(locationName:lower(), "peak") then
            displayName = locationName
        elseif string.find(locationName:lower(), "swamp") or string.find(locationName:lower(), "grove") then
            displayName = locationName
        elseif string.find(locationName:lower(), "reef") or string.find(locationName:lower(), "coral") then
            displayName = locationName
        else
            displayName = "🏝️ " .. locationName
        end
    end
    
    TeleportTab:CreateButton({
        Name = displayName,
        Callback = CreateSafeCallback(function()
            SafeTeleport(cframe, locationName)
        end, "tp_island_" .. locationName)
    })
end

-- NPCs Section
TeleportTab:CreateParagraph({
    Title = "🛒 NPC Teleportation",
    Content = "Instantly teleport to important NPCs for trading, upgrades, and services. Save time with quick access!"
})

-- Refresh NPC Locations Button
TeleportTab:CreateButton({
    Name = "🔄 Refresh NPC Locations",
    Callback = CreateSafeCallback(function()
        -- Re-detect NPC locations
        local newDetectedNPCs = DetectNPCLocations()
        
        if next(newDetectedNPCs) then
            TeleportLocations.NPCs = newDetectedNPCs
            local npcCount = 0
            for _ in pairs(newDetectedNPCs) do npcCount = npcCount + 1 end
            
            NotifySuccess("NPC Refresh", "✅ NPC locations updated! Found " .. npcCount .. " NPCs with real-time positions.\n\n⚠️ Please reload the script to see updated buttons.")
            
            -- Print detected NPCs for debugging
            print("XSAN: Updated NPC Locations:")
            for name, cframe in pairs(newDetectedNPCs) do
                print("  •", name, ":", cframe.Position)
            end
        else
            NotifyError("NPC Refresh", "❌ No NPCs detected! Using fallback locations.\n\nTry moving closer to NPCs or check if you're in the right area.")
        end
    end, "refresh_npcs")
})

-- Show NPC Detection Info Button
TeleportTab:CreateButton({
    Name = "📍 Show NPC Detection Info",
    Callback = CreateSafeCallback(function()
        local npcInfo = "🔍 DETECTED NPC LOCATIONS:\n\n"
        local npcCount = 0
        
        for npcName, cframe in pairs(TeleportLocations.NPCs) do
            npcCount = npcCount + 1
            local pos = cframe.Position
            npcInfo = npcInfo .. string.format("📍 %s\n   Position: %.1f, %.1f, %.1f\n\n", npcName, pos.X, pos.Y, pos.Z)
        end
        
        npcInfo = npcInfo .. "📊 Total NPCs: " .. npcCount .. "\n"
        npcInfo = npcInfo .. "🔄 Auto-refresh: Every 30 seconds\n"
        npcInfo = npcInfo .. "✅ Real-time detection active!"
        
        NotifyInfo("NPC Detection", npcInfo)
    end, "show_npc_info")
})

-- Create buttons for each NPC
for npcName, cframe in pairs(TeleportLocations.NPCs) do
    TeleportTab:CreateButton({
        Name = npcName,
        Callback = CreateSafeCallback(function()
            SafeTeleport(cframe, npcName)
        end, "tp_npc_" .. npcName)
    })
end

-- Events Section
TeleportTab:CreateParagraph({
    Title = "🌟 Event Teleportation",
    Content = "Quick access to event locations and special fishing spots. Never miss an event again!"
})

-- Create buttons for each event location
for eventName, cframe in pairs(TeleportLocations.Events) do
    TeleportTab:CreateButton({
        Name = eventName,
        Callback = CreateSafeCallback(function()
            SafeTeleport(cframe, eventName)
        end, "tp_event_" .. eventName)
    })
end

-- Player Teleportation Section
TeleportTab:CreateParagraph({
    Title = "👥 Player Teleportation",
    Content = "Teleport to other players in the server. Great for meeting friends or following experienced fishers!"
})

TeleportTab:CreateButton({
    Name = "🔄 Refresh Player List",
    Callback = CreateSafeCallback(function()
        local playerCount = 0
        local playerList = ""
        
        -- Check Characters folder first (like old.lua)
        local charFolder = workspace:FindFirstChild("Characters")
        if charFolder then
            for _, playerModel in pairs(charFolder:GetChildren()) do
                if playerModel:IsA("Model") and playerModel.Name ~= LocalPlayer.Name and playerModel:FindFirstChild("HumanoidRootPart") then
                    playerCount = playerCount + 1
                    playerList = playerList .. "👤 " .. playerModel.Name .. " • "
                end
            end
        end
        
        -- Fallback to Players service
        if playerCount == 0 then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    playerCount = playerCount + 1
                    playerList = playerList .. "👤 " .. player.Name .. " • "
                end
            end
        end
        
        if playerCount > 0 then
            NotifyInfo("Player List", "Players in server (" .. playerCount .. "):\n\n" .. playerList:sub(1, -3) .. "\n\n✅ Player teleportation system ready!\n📝 Use manual input below to teleport to any player.")
        else
            NotifyError("Player List", "❌ No other players found in the server!\n\n🔍 Make sure you're in a multiplayer server.\n⚠️ Some players might be loading or not have characters spawned.")
        end
        
        -- Note: Due to Rayfield limitations, please reload script to see updated quick buttons
        NotifyInfo("UI Update", "💡 TIP: To see updated quick player buttons, reload the script.\n\n⚡ Quick buttons show first 5 players\n📝 Manual input works for all players")
    end, "refresh_players")
})

-- Quick Player Teleport Buttons (Top 5 Players)
TeleportTab:CreateParagraph({
    Title = "⚡ Quick Player Access",
    Content = "Quick teleport buttons for players currently in the server. Use refresh to update the list!"
})

local function CreatePlayerButtons()
    local players = {}
    
    -- Method 1: Check Characters folder first (like old.lua)
    local charFolder = workspace:FindFirstChild("Characters")
    if charFolder then
        for _, playerModel in pairs(charFolder:GetChildren()) do
            if playerModel:IsA("Model") and playerModel.Name ~= LocalPlayer.Name and playerModel:FindFirstChild("HumanoidRootPart") then
                table.insert(players, playerModel.Name)
            end
        end
    end
    
    -- Method 2: Fallback to Players service
    if #players == 0 then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(players, player.Name)
            end
        end
    end
    
    -- Create buttons for first 5 players (to avoid UI clutter)
    for i = 1, math.min(#players, 5) do
        local playerName = players[i]
        TeleportTab:CreateButton({
            Name = "👤 " .. playerName,
            Callback = CreateSafeCallback(function()
                TeleportToPlayer(playerName)
            end, "tp_player_" .. playerName)
        })
    end
    
    if #players > 5 then
        TeleportTab:CreateParagraph({
            Title = "📝 More Players Available",
            Content = "There are " .. #players .. " players total. Use manual input below for others, or refresh to see different players."
        })
    elseif #players == 0 then
        TeleportTab:CreateParagraph({
            Title = "❌ No Players Found",
            Content = "No other players detected in the server. Make sure you're in a multiplayer server!"
        })
    end
end

-- Initialize player buttons
CreatePlayerButtons()

-- Manual Player Teleport
local targetPlayerName = ""

TeleportTab:CreateInput({
    Name = "📝 Enter Player Name",
    PlaceholderText = "Type player name here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        targetPlayerName = text
    end
})

TeleportTab:CreateButton({
    Name = "🎯 Teleport to Player",
    Callback = CreateSafeCallback(function()
        if targetPlayerName and targetPlayerName ~= "" then
            TeleportToPlayer(targetPlayerName)
        else
            NotifyError("Player TP", "Please enter a player name first!")
        end
    end, "tp_to_player")
})

-- Utility Teleportation
TeleportTab:CreateParagraph({
    Title = "🔧 Teleport Utilities",
    Content = "Additional teleportation features and safety options."
})

TeleportTab:CreateButton({
    Name = "📍 Save Current Position",
    Callback = CreateSafeCallback(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            _G.XSANSavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            NotifySuccess("Position Saved", "📍 Current position saved! Use 'Return to Saved Position' to come back here.")
        else
            NotifyError("Save Position", "❌ Character not found!")
        end
    end, "save_position")
})

TeleportTab:CreateButton({
    Name = "🔙 Return to Saved Position",
    Callback = CreateSafeCallback(function()
        if _G.XSANSavedPosition then
            SafeTeleport(_G.XSANSavedPosition, "Saved Position")
        else
            NotifyError("Return Position", "❌ No saved position found! Save a position first.")
        end
    end, "return_position")
})

TeleportTab:CreateButton({
    Name = "🏠 Teleport to Spawn",
    Callback = CreateSafeCallback(function()
        -- Try to use dynamic location first
        local spawnCFrame = TeleportLocations.Islands["Moosewood"] or CFrame.new(389, 137, 264)
        SafeTeleport(spawnCFrame, "Moosewood Spawn")
    end, "tp_spawn")
})

print("XSAN: TELEPORT tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- AUTO FISH TAB - Enhanced Fishing System
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating AUTO FISH tab content...")
MainTab:CreateParagraph({
    Title = "XSAN Ultimate Auto Fish System",
    Content = "Advanced auto fishing with AI assistance, smart detection, and premium features for the ultimate fishing experience."
})

MainTab:CreateToggle({
    Name = "Enable Auto Fishing",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        autofish = val
        if val then
            if hybridMode then
                -- Initialize hybrid auto fish
                if not hybridAutoFish then
                    hybridAutoFish = Rayfield.CreateSafeAutoFish({
                        safeMode = true,
                        perfectChance = hybridPerfectChance,
                        minDelay = hybridMinDelay,
                        maxDelay = hybridMaxDelay,
                        useServerTime = true
                    })
                end
                hybridAutoFish.toggle(true)
                NotifySuccess("Hybrid Auto Fish", "HYBRID SECURITY MODE ACTIVATED!\n🔒 Maximum Safety\n⚡ Server Time Sync\n🎯 Human-like Patterns")
            else
                -- Traditional auto fishing
                NotifySuccess("Auto Fish", "XSAN Ultimate auto fishing started! AI systems activated.")
                spawn(function()
                    while autofish do
                        pcall(function()
                            if equipRemote then equipRemote:FireServer(1) end
                            wait(0.1)

                            -- Safe Mode Logic: Random between perfect and normal cast
                            local usePerfectCast = perfectCast
                            if safeMode then
                                usePerfectCast = math.random(1, 100) <= safeModeChance
                            end

                            local timestamp = usePerfectCast and 9999999999 or (tick() + math.random())
                            if rodRemote then rodRemote:InvokeServer(timestamp) end
                            wait(0.1)

                            local x = usePerfectCast and -1.238 or (math.random(-1000, 1000) / 1000)
                            local y = usePerfectCast and 0.969 or (math.random(0, 1000) / 1000)

                            if miniGameRemote then miniGameRemote:InvokeServer(x, y) end
                            wait(1.3)
                            if finishRemote then finishRemote:FireServer() end
                            
                            fishCaught = fishCaught + 1
                            
                            -- Track cast types for analytics
                            if usePerfectCast then
                                perfectCasts = perfectCasts + 1
                            else
                                normalCasts = normalCasts + 1
                            end
                            
                            CheckAndAutoSell()
                        end)
                        wait(autoRecastDelay)
                    end
                end)
            end
        else
            if hybridMode and hybridAutoFish then
                hybridAutoFish.toggle(false)
                NotifyInfo("Hybrid Auto Fish", "Hybrid auto fishing stopped by user.")
            else
                NotifyInfo("Auto Fish", "Auto fishing stopped by user.")
            end
        end
    end, "autofish")
})

MainTab:CreateToggle({
    Name = "Perfect Cast Mode",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        perfectCast = val
        if val then
            safeMode = false  -- Disable safe mode when perfect cast is manually enabled
            hybridMode = false  -- Disable hybrid mode
        end
        NotifySuccess("Perfect Cast", "Perfect cast mode " .. (val and "activated" or "deactivated") .. "!")
    end, "perfectcast")
})

MainTab:CreateToggle({
    Name = "🛡️ Safe Mode (Smart Random)",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        safeMode = val
        if val then
            perfectCast = false  -- Disable perfect cast when safe mode is enabled
            hybridMode = false   -- Disable hybrid mode
            NotifySuccess("Safe Mode", "Safe mode activated - Smart random casting for better stealth!")
        else
            NotifyInfo("Safe Mode", "Safe mode deactivated - Manual control restored")
        end
    end, "safemode")
})

MainTab:CreateToggle({
    Name = "🔒 HYBRID MODE (Ultimate Security)",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        hybridMode = val
        if val then
            perfectCast = false  -- Disable other modes
            safeMode = false
            NotifySuccess("Hybrid Mode", "HYBRID SECURITY ACTIVATED!\n✅ Server Time Sync\n✅ Human-like Patterns\n✅ Anti-Detection\n✅ Maximum Safety")
        else
            NotifyInfo("Hybrid Mode", "Hybrid mode deactivated - Back to manual control")
        end
    end, "hybridmode")
})

MainTab:CreateSlider({
    Name = "Safe Mode Perfect %",
    Range = {50, 85},
    Increment = 5,
    CurrentValue = safeModeChance,
    Callback = function(val)
        safeModeChance = val
        if safeMode then
            NotifyInfo("Safe Mode", "Perfect cast chance set to: " .. val .. "%")
        end
    end
})

MainTab:CreateSlider({
    Name = "Hybrid Perfect %",
    Range = {60, 80},
    Increment = 5,
    CurrentValue = 70,
    Callback = function(val)
        hybridPerfectChance = val
        if hybridMode and hybridAutoFish then
            hybridAutoFish.updateConfig({perfectChance = val})
            NotifyInfo("Hybrid Mode", "Perfect cast chance updated to: " .. val .. "%")
        end
    end
})

MainTab:CreateSlider({
    Name = "Hybrid Min Delay",
    Range = {1.0, 2.0},
    Increment = 0.1,
    CurrentValue = 1.0,
    Callback = function(val)
        hybridMinDelay = val
        if hybridMode and hybridAutoFish then
            hybridAutoFish.updateConfig({minDelay = val})
            NotifyInfo("Hybrid Mode", "Minimum delay updated to: " .. val .. "s")
        end
    end
})

MainTab:CreateSlider({
    Name = "Hybrid Max Delay", 
    Range = {2.0, 3.5},
    Increment = 0.1,
    CurrentValue = 2.5,
    Callback = function(val)
        hybridMaxDelay = val
        if hybridMode and hybridAutoFish then
            hybridAutoFish.updateConfig({maxDelay = val})
            NotifyInfo("Hybrid Mode", "Maximum delay updated to: " .. val .. "s")
        end
    end
})

MainTab:CreateSlider({
    Name = "Auto Recast Delay",
    Range = {0.5, 3.0},
    Increment = 0.1,
    CurrentValue = autoRecastDelay,
    Callback = function(val)
        autoRecastDelay = val
    end
})

MainTab:CreateToggle({
    Name = "Auto Sell on Fish Count",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        autoSellOnThreshold = val
        if val then
            NotifySuccess("Auto Sell Threshold", "Auto sell on threshold activated! Will sell when " .. autoSellThreshold .. " fish caught.")
        else
            NotifyInfo("Auto Sell Threshold", "Auto sell on threshold disabled.")
        end
    end, "autosell_threshold")
})

MainTab:CreateSlider({
    Name = "Fish Threshold",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = autoSellThreshold,
    Callback = function(val)
        autoSellThreshold = val
        if autoSellOnThreshold then
            NotifyInfo("Threshold Updated", "Auto sell threshold set to: " .. val .. " fish")
        end
    end
})

print("XSAN: AUTO FISH tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- ANALYTICS TAB - Advanced Statistics & Monitoring
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating ANALYTICS tab content...")
AnalyticsTab:CreateParagraph({
    Title = "XSAN Advanced Analytics",
    Content = "Real-time monitoring, performance tracking, and intelligent insights for optimal fishing performance."
})

AnalyticsTab:CreateButton({
    Name = "Show Detailed Statistics",
    Callback = CreateSafeCallback(function()
        local sessionTime = (tick() - sessionStartTime) / 60
        local fishPerHour = CalculateFishPerHour()
        local estimatedProfit = CalculateProfit()
        local totalCasts = perfectCasts + normalCasts
        local perfectEfficiency = totalCasts > 0 and (perfectCasts / totalCasts * 100) or 0
        local castingMode = safeMode and "Safe Mode" or (perfectCast and "Perfect Cast" or "Normal Cast")
        
        local stats = string.format("XSAN Ultimate Analytics:\n\nSession Time: %.1f minutes\nFish Caught: %d\nFish/Hour: %d\n\n=== CASTING STATS ===\nMode: %s\nPerfect Casts: %d (%.1f%%)\nNormal Casts: %d\nTotal Casts: %d\n\n=== EARNINGS ===\nItems Sold: %d\nEstimated Profit: %d coins\nActive Preset: %s", 
            sessionTime, fishCaught, fishPerHour, castingMode, perfectCasts, perfectEfficiency, normalCasts, totalCasts, itemsSold, estimatedProfit, currentPreset
        )
        NotifyInfo("Advanced Stats", stats)
    end, "detailed_stats")
})

AnalyticsTab:CreateButton({
    Name = "Reset Statistics",
    Callback = CreateSafeCallback(function()
        sessionStartTime = tick()
        fishCaught = 0
        itemsSold = 0
        perfectCasts = 0
        normalCasts = 0
        NotifySuccess("Analytics", "All statistics have been reset!")
    end, "reset_stats")
})

print("XSAN: ANALYTICS tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- INVENTORY TAB - Smart Inventory Management
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating INVENTORY tab content...")
InventoryTab:CreateParagraph({
    Title = "XSAN Smart Inventory Manager",
    Content = "Intelligent inventory management with auto-drop, space monitoring, and priority item protection."
})

InventoryTab:CreateButton({
    Name = "Check Inventory Status",
    Callback = CreateSafeCallback(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            local items = #backpack:GetChildren()
            local itemNames = {}
            for _, item in pairs(backpack:GetChildren()) do
                table.insert(itemNames, item.Name)
            end
            
            local status = string.format("Inventory Status:\n\nTotal Items: %d/20\nSpace Available: %d slots\n\nItems: %s", 
                items, 20 - items, table.concat(itemNames, ", "))
            NotifyInfo("Inventory", status)
        else
            NotifyError("Inventory", "Could not access backpack!")
        end
    end, "check_inventory")
})

print("XSAN: INVENTORY tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- UTILITY TAB - System Management & Advanced Features
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating UTILITY tab content...")
UtilityTab:CreateParagraph({
    Title = "XSAN Ultimate Utility System",
    Content = "Advanced system management, quality of life features, and premium utilities."
})

UtilityTab:CreateButton({
    Name = "Show Ultimate Session Stats",
    Callback = CreateSafeCallback(function()
        local sessionTime = (tick() - sessionStartTime) / 60
        local fishPerHour = CalculateFishPerHour()
        local estimatedProfit = CalculateProfit()
        local efficiency = fishCaught > 0 and (perfectCasts / fishCaught * 100) or 0
        local thresholdStatus = autoSellOnThreshold and ("Active (" .. autoSellThreshold .. " fish)") or "Inactive"
        
        local ultimateStats = string.format("XSAN ULTIMATE SESSION REPORT:\n\n=== PERFORMANCE ===\nSession Time: %.1f minutes\nFish Caught: %d\nFish/Hour Rate: %d\nPerfect Casts: %d (%.1f%%)\n\n=== EARNINGS ===\nItems Sold: %d\nEstimated Profit: %d coins\n\n=== AUTOMATION ===\nAuto Fish: %s\nThreshold Auto Sell: %s\nActive Preset: %s", 
            sessionTime, fishCaught, fishPerHour, perfectCasts, efficiency,
            itemsSold, estimatedProfit,
            autofish and "Active" or "Inactive",
            thresholdStatus, currentPreset
        )
        NotifyInfo("Ultimate Stats", ultimateStats)
    end, "ultimate_stats")
})

UtilityTab:CreateParagraph({
    Title = "🎯 Performance & Settings",
    Content = "Advanced script performance controls and system management options."
})

-- ═══════════════════════════════════════════════════════════════
-- WALKSPEED CONTROLS
-- ═══════════════════════════════════════════════════════════════

UtilityTab:CreateParagraph({
    Title = "🏃 Walk Speed System",
    Content = "Control your character's movement speed with XSAN walkspeed system."
})

UtilityTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 60},
    Increment = 1,
    CurrentValue = defaultWalkspeed,
    Flag = "WalkSpeedSlider",
    Callback = CreateSafeCallback(function(value)
        currentWalkspeed = value
        if walkspeedEnabled then
            setWalkSpeed(value)
        else
            NotifyInfo("Walk Speed", "Walk speed set to " .. value .. ". Enable to apply.")
        end
    end, "walkspeed_slider")
})

UtilityTab:CreateToggle({
    Name = "Enable Walk Speed",
    CurrentValue = walkspeedEnabled,
    Flag = "WalkSpeedToggle",
    Callback = CreateSafeCallback(function(value)
        walkspeedEnabled = value
        if value then
            setWalkSpeed(currentWalkspeed)
            NotifySuccess("Walk Speed", "Walk speed enabled: " .. currentWalkspeed)
        else
            resetWalkSpeed()
            NotifyInfo("Walk Speed", "Walk speed disabled (reset to default)")
        end
    end, "walkspeed_toggle")
})

UtilityTab:CreateButton({
    Name = "Quick Speed: 45",
    Callback = CreateSafeCallback(function()
        currentWalkspeed = 45
        if walkspeedEnabled then
            setWalkSpeed(45)
        else
            walkspeedEnabled = true
            setWalkSpeed(45)
        end
        -- Update the slider and toggle if they exist
        if Rayfield.Flags["WalkSpeedSlider"] then
            Rayfield.Flags["WalkSpeedSlider"]:Set(45)
        end
        if Rayfield.Flags["WalkSpeedToggle"] then
            Rayfield.Flags["WalkSpeedToggle"]:Set(true)
        end
    end, "quick_speed_45")
})

UtilityTab:CreateButton({
    Name = "Reset Walk Speed",
    Callback = CreateSafeCallback(function()
        resetWalkSpeed()
        -- Update the slider and toggle if they exist
        if Rayfield.Flags["WalkSpeedSlider"] then
            Rayfield.Flags["WalkSpeedSlider"]:Set(defaultWalkspeed)
        end
        if Rayfield.Flags["WalkSpeedToggle"] then
            Rayfield.Flags["WalkSpeedToggle"]:Set(false)
        end
        NotifyInfo("Walk Speed", "Walk speed reset to default (" .. defaultWalkspeed .. ")")
    end, "reset_walkspeed")
})

-- ═══════════════════════════════════════════════════════════════
-- UNLIMITED JUMP CONTROLS
-- ═══════════════════════════════════════════════════════════════

UtilityTab:CreateParagraph({
    Title = "🚀 Unlimited Jump System",
    Content = "Enhanced jumping capabilities with infinite jumps and custom jump heights for ultimate mobility."
})

UtilityTab:CreateToggle({
    Name = "🚀 Enable Unlimited Jump",
    CurrentValue = unlimitedJumpEnabled,
    Flag = "UnlimitedJumpToggle",
    Callback = CreateSafeCallback(function(value)
        if value then
            enableUnlimitedJump()
        else
            disableUnlimitedJump()
        end
    end, "unlimited_jump_toggle")
})

UtilityTab:CreateSlider({
    Name = "Jump Height",
    Range = {7.2, 100},
    Increment = 0.5,
    CurrentValue = defaultJumpHeight,
    Flag = "JumpHeightSlider",
    Callback = CreateSafeCallback(function(value)
        if not unlimitedJumpEnabled then
            setJumpHeight(value)
            NotifyInfo("Jump Height", "Custom jump height: " .. value .. "\n💡 Enable Unlimited Jump for infinite jumps!")
        else
            currentJumpHeight = value
            setJumpHeight(value)
            NotifyInfo("Jump Height", "Jump height updated: " .. value .. " (Unlimited mode)")
        end
    end, "jump_height_slider")
})

UtilityTab:CreateButton({
    Name = "🎯 Quick Jump: Super High (75)",
    Callback = CreateSafeCallback(function()
        currentJumpHeight = 75
        setJumpHeight(75)
        -- Update the slider if it exists
        if Rayfield.Flags["JumpHeightSlider"] then
            Rayfield.Flags["JumpHeightSlider"]:Set(75)
        end
        NotifySuccess("Jump Height", "🚀 Super high jump enabled!\n\nHeight: 75\n💡 Enable Unlimited Jump for infinite jumps!")
    end, "super_jump")
})

UtilityTab:CreateButton({
    Name = "⚡ Quick: Unlimited Mode",
    Callback = CreateSafeCallback(function()
        if not unlimitedJumpEnabled then
            enableUnlimitedJump()
            -- Update toggle if it exists
            if Rayfield.Flags["UnlimitedJumpToggle"] then
                Rayfield.Flags["UnlimitedJumpToggle"]:Set(true)
            end
        else
            NotifyInfo("Unlimited Jump", "✅ Already enabled!\n\n🚀 Press space repeatedly to fly\n📏 Adjust height with slider above")
        end
    end, "quick_unlimited")
})

UtilityTab:CreateButton({
    Name = "🔄 Reset Jump Height",
    Callback = CreateSafeCallback(function()
        disableUnlimitedJump()
        setJumpHeight(defaultJumpHeight)
        -- Update controls if they exist
        if Rayfield.Flags["JumpHeightSlider"] then
            Rayfield.Flags["JumpHeightSlider"]:Set(defaultJumpHeight)
        end
        if Rayfield.Flags["UnlimitedJumpToggle"] then
            Rayfield.Flags["UnlimitedJumpToggle"]:Set(false)
        end
        NotifyInfo("Jump Height", "Jump height reset to default (" .. defaultJumpHeight .. ")")
    end, "reset_jump")
})

UtilityTab:CreateButton({ 
    Name = "Rejoin Server", 
    Callback = CreateSafeCallback(function() 
        NotifyInfo("Server", "Rejoining current server...")
        wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer) 
    end, "rejoin_server")
})

UtilityTab:CreateButton({ 
    Name = "Emergency Stop All",
    Callback = CreateSafeCallback(function()
        autofish = false
        featureState.AutoSell = false
        autoSellOnThreshold = false
        
        NotifyError("Emergency Stop", "All automation systems stopped immediately!")
    end, "emergency_stop")
})

UtilityTab:CreateButton({ 
    Name = "Unload Ultimate Script", 
    Callback = CreateSafeCallback(function()
        NotifyInfo("XSAN", "Thank you for using XSAN Fish It Pro Ultimate v1.0! The most advanced fishing script ever created.\n\nScript will unload in 3 seconds...")
        wait(3)
        if game:GetService("CoreGui"):FindFirstChild("Rayfield") then
            game:GetService("CoreGui").Rayfield:Destroy()
        end
    end, "unload_script")
})

print("XSAN: UTILITY tab completed successfully!")

-- Hotkey System
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        autofish = not autofish
        NotifyInfo("Hotkey", "Auto fishing " .. (autofish and "started" or "stopped") .. " (F1)")
    elseif input.KeyCode == Enum.KeyCode.F2 then
        perfectCast = not perfectCast
        NotifyInfo("Hotkey", "Perfect cast " .. (perfectCast and "enabled" or "disabled") .. " (F2)")
    elseif input.KeyCode == Enum.KeyCode.F3 then
        autoSellOnThreshold = not autoSellOnThreshold
        NotifyInfo("Hotkey", "Auto sell threshold " .. (autoSellOnThreshold and "enabled" or "disabled") .. " (F3)")
    elseif input.KeyCode == Enum.KeyCode.F4 then
        -- Quick teleport to spawn
        SafeTeleport(CFrame.new(389, 137, 264), "Moosewood Spawn")
        NotifyInfo("Hotkey", "Quick teleport to spawn (F4)")
    elseif input.KeyCode == Enum.KeyCode.F5 then
        -- Save current position
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            _G.XSANSavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            NotifyInfo("Hotkey", "Position saved (F5)")
        end
    elseif input.KeyCode == Enum.KeyCode.F6 then
        -- Return to saved position
        if _G.XSANSavedPosition then
            SafeTeleport(_G.XSANSavedPosition, "Saved Position")
            NotifyInfo("Hotkey", "Returned to saved position (F6)")
        end
    elseif input.KeyCode == Enum.KeyCode.F7 then
        -- Toggle walkspeed
        walkspeedEnabled = not walkspeedEnabled
        if walkspeedEnabled then
            setWalkSpeed(currentWalkspeed)
            -- Update UI if available
            if Rayfield.Flags["WalkSpeedToggle"] then
                Rayfield.Flags["WalkSpeedToggle"]:Set(true)
            end
        else
            resetWalkSpeed()
            -- Update UI if available
            if Rayfield.Flags["WalkSpeedToggle"] then
                Rayfield.Flags["WalkSpeedToggle"]:Set(false)
            end
        end
        NotifyInfo("Hotkey", "Walk speed " .. (walkspeedEnabled and "enabled" or "disabled") .. " (F7)")
    end
end)

-- Welcome Messages
spawn(function()
    wait(2)
    NotifySuccess("Welcome!", "XSAN Fish It Pro ULTIMATE v1.0 loaded successfully!\n\nULTIMATE FEATURES ACTIVATED:\nAI-Powered Analytics • Smart Automation • Advanced Safety • Premium Quality • Ultimate Teleportation • And Much More!\n\nReady to dominate Fish It like never before!")
    
    wait(4)
    NotifyInfo("Hotkeys Active!", "HOTKEYS ENABLED:\nF1 - Toggle Auto Fishing\nF2 - Toggle Perfect Cast\nF3 - Toggle Auto Sell Threshold\nF4 - Quick TP to Spawn\nF5 - Save Position\nF6 - Return to Saved Position\nF7 - Toggle Walk Speed\n\nCheck PRESETS tab for quick setup!")
    
    wait(3)
    NotifyInfo("📱 Smart UI!", "RAYFIELD UI SYSTEM:\nRayfield automatically handles UI sizing and responsiveness for all devices!\n\nUI management is now handled by the Rayfield library (css.lua)!")
    
    wait(3)
    NotifySuccess("✅ Teleportation Fixed!", "TELEPORTATION SYSTEM FIXED:\n✅ Now uses dynamic locations like old.lua\n✅ Accurate coordinates from workspace\n✅ Better player detection\n✅ More reliable teleportation\n\nCheck TELEPORT tab for perfect locations!")
    
    wait(3)
    NotifyInfo("Follow XSAN!", "Instagram: @_bangicoo\nGitHub: codeico\n\nThe most advanced Fish It script ever created! Follow us for more premium scripts and exclusive updates!")
end)

-- Console Branding
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("XSAN FISH IT PRO ULTIMATE v1.0")
print("THE MOST ADVANCED FISH IT SCRIPT EVER CREATED")
print("Premium Script with AI-Powered Features & Ultimate Automation")
print("Instagram: @_bangicoo | GitHub: codeico")
print("Professional Quality • Trusted by Thousands • Ultimate Edition")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("XSAN: Script loaded successfully! All systems operational!")

-- Performance Enhancements
pcall(function()
    local Modifiers = require(game:GetService("ReplicatedStorage").Shared.FishingRodModifiers)
    for key in pairs(Modifiers) do
        Modifiers[key] = 999999999
    end

    local bait = require(game:GetService("ReplicatedStorage").Baits["Luck Bait"])
    bait.Luck = 999999999
    
    print("XSAN: Performance enhancements applied!")
end)
