--[[
TURBO B.Y HUB - WIND UI ENGLISH EDITION
All functions included + English interface
--]]

-- Load Wind UI
local Wind = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Create main window
local Window = Wind:CreateWindow({
    Title = "TURBO B.Y HUB v6 Ultra",
    SubTitle = "Lori Nightmare | Wind UI Edition",
    Size = UDim2.new(0, 500, 0, 400),
    Position = UDim2.new(0.5, -250, 0.5, -200),
    Theme = "Dark"
})

-- Notification function
local function ShowNotification(title, text, duration)
    duration = duration or 5
    
    -- Method 1: Try using Wind UI if available
    if Wind.Notify then
        pcall(function()
            Wind.Notify({
                Title = title,
                Content = text,
                Duration = duration
            })
        end)
    end
    
    -- Method 2: Use Roblox CoreGui
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration,
            Icon = "rbxassetid://4483362458"
        })
    end)
    
    -- Method 3: Print to console
    print("[TURBO HUB] " .. title .. ": " .. text)
end

-- Wait for initialization
task.wait(2)
ShowNotification("Hub Loaded", "Turbo B.Y Hub v6 ultra started!", 5)

-- Create tabs
local MainTab = Window:AddTab("🎮 Main")
local PlayerTab = Window:AddTab("👤 Player")
local TVTab = Window:AddTab("📺 TV ESP")
local ExtraTab = Window:AddTab("⚙️ Extras")
local BetaTab = Window:AddTab("🚧 Beta")

-- Store walk/jump values
local WalkSpeedValue = 16
local JumpPowerValue = 50

-- ==================== MAIN TAB ====================
MainTab:AddSection("Teleportation")

MainTab:AddButton({
    Title = "📍 Teleport to TV",
    Description = "Teleport to random TV location",
    Callback = function()
        ShowNotification("Teleport", "Teleporting to TV...", 3)
        
        -- TV Teleport Script
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        local StarterGui = game:GetService("StarterGui")
        local UserInputService = game:GetService("UserInputService")

        local LocalPlayer = Players.LocalPlayer
        local TELEPORT_KEY = Enum.KeyCode.C
        local NOTIFY_DURATION = 2
        local MAX_LOCATIONS = 12

        local connections = {}

        local function notify(text)
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Teleport to TV",
                    Text = text,
                    Duration = NOTIFY_DURATION
                })
            end)
        end

        local function getTargetCFrame(obj)
            if obj:IsA("BasePart") then
                return obj.CFrame + Vector3.new(0, obj.Size.Y / 2 + 3, 0)
            end
            return nil
        end

        local function findAllLocations()
            print("--- STARTING LOCATION SEARCH (location1...) ---")
            local locations = {}
            local descendants = Workspace:GetDescendants()
            
            for i = 1, MAX_LOCATIONS do
                local targetName = "location" .. i
                local found = false
                
                for _, obj in ipairs(descendants) do
                    if string.lower(obj.Name) == targetName and obj:IsA("BasePart") then
                        table.insert(locations, obj)
                        print("✅ Found: " .. obj.Name .. " (match)")
                        found = true
                        break
                    end
                end
                
                if not found then
                    print("❌ NOT FOUND: " .. targetName)
                end
            end
            
            print("--- SEARCH COMPLETE. Found: " .. #locations .. " ---")
            return locations
        end

        local function getHRP()
            local char = LocalPlayer.Character
            if not char then return nil end
            return char:FindFirstChild("HumanoidRootPart")
        end

        local function teleportToRandomLocation()
            local hrp = getHRP()
            if not hrp then
                notify("Character not found")
                return
            end

            local locations = findAllLocations()
            
            if #locations == 0 then
                notify("The map has been removed. We are waiting.")
                warn("Loading map location1...location12")
                return
            end
            
            local randomIndex = math.random(1, #locations)
            local target = locations[randomIndex]

            local targetCFrame = getTargetCFrame(target)
            if targetCFrame then
                hrp.CFrame = targetCFrame
                notify("TP to: " .. target.Name)
            end
        end

        -- GUI
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local oldGui = playerGui:FindFirstChild("TeleportPanel")
        if oldGui then oldGui:Destroy() end

        local screenGui = Instance.new("ScreenGui", playerGui)
        screenGui.Name = "TeleportPanel"
        screenGui.ResetOnSpawn = false

        local panel = Instance.new("Frame", screenGui)
        panel.Size = UDim2.new(0, 260, 0, 150)
        panel.Position = UDim2.new(0.5, -130, 0.5, -75)
        panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        panel.BorderSizePixel = 2
        panel.Active = true

        -- Dragging
        local dragging, dragInput, dragStart, startPos
        local function update(input)
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        
        panel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = panel.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        
        panel.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                dragInput = input
            end
        end)
        
        table.insert(connections, UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then update(input) end
        end))

        -- UI Elements
        local title = Instance.new("TextLabel", panel)
        title.Size = UDim2.new(1,0,0.25,0); title.Text = "TV"; title.TextColor3 = Color3.fromRGB(0,255,255); 
        title.Font = Enum.Font.FredokaOne; title.TextScaled = true; title.BackgroundTransparency = 1
        
        local button = Instance.new("TextButton", panel)
        button.Size = UDim2.new(0.8,0,0.25,0); button.Position = UDim2.new(0.1,0,0.3,0); 
        button.BackgroundColor3 = Color3.fromRGB(0,180,0); button.Text = "Teleport to TV"; 
        button.TextColor3 = Color3.fromRGB(255,255,255); button.Font = Enum.Font.FredokaOne; button.TextScaled = true
        button.MouseButton1Click:Connect(teleportToRandomLocation)

        local destroyBtn = Instance.new("TextButton", panel)
        destroyBtn.Size = UDim2.new(0.8,0,0.2,0); destroyBtn.Position = UDim2.new(0.1,0,0.82,0); 
        destroyBtn.BackgroundColor3 = Color3.fromRGB(80,80,80); destroyBtn.Text = "Delete GUI"; 
        destroyBtn.TextColor3 = Color3.fromRGB(255,80,80); destroyBtn.Font = Enum.Font.FredokaOne; destroyBtn.TextScaled = true

        table.insert(connections, UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == TELEPORT_KEY then teleportToRandomLocation() end
        end))

        destroyBtn.MouseButton1Click:Connect(function()
            for _, c in ipairs(connections) do c:Disconnect() end
            screenGui:Destroy()
        end)
    end
})

MainTab:AddButton({
    Title = "🚪 Teleport to Exit",
    Description = "Teleport to exit portal",
    Callback = function()
        ShowNotification("Teleport", "Teleporting to exit...", 3)
        
        -- Exit Teleport Script
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local StarterGui = game:GetService("StarterGui")

        local LocalPlayer = Players.LocalPlayer
        local NOTIFY_DURATION = 3
        local TARGET_PATH = "Misc.ExitPortal.Telepad"

        local function notify(text)
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Teleport",
                    Text = text,
                    Duration = NOTIFY_DURATION
                })
            end)
        end

        local function teleportToTarget(targetPart)
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if not hrp then
                notify("Character not found")
                return
            end

            local targetCFrame = targetPart.CFrame + Vector3.new(0, targetPart.Size.Y / 2 + 3, 0)
            hrp.CFrame = targetCFrame
            notify("Successful TP: " .. targetPart.Name)
        end

        local targetContainer = ReplicatedStorage
        local found = true
        local pathSegments = string.split(TARGET_PATH, ".")

        for _, segment in ipairs(pathSegments) do
            targetContainer = targetContainer:WaitForChild(segment, 10)
            if not targetContainer then
                found = false
                break
            end
        end

        if found and targetContainer:IsA("BasePart") then
            print("✅ Target 'Telepad' found. Waiting for character...")
            
            if LocalPlayer.Character then
                teleportToTarget(targetContainer)
            else
                LocalPlayer.CharacterAdded:Once(function()
                    teleportToTarget(targetContainer)
                end)
            end
        else
            notify("Waiting for map to load")
            warn("Part not found at path: ReplicatedStorage." .. TARGET_PATH)
        end
    end
})

MainTab:AddSection("Money")

MainTab:AddButton({
    Title = "💰 Auto Collect Coins",
    Description = "Automatically collect coins",
    Callback = function()
        ShowNotification("Money", "Auto coin collection started!", 3)
        
        -- Coin Collection Script
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        local StarterGui = game:GetService("StarterGui")
        local UserInputService = game:GetService("UserInputService")

        local LocalPlayer = Players.LocalPlayer
        local TELEPORT_KEY = Enum.KeyCode.C
        local NOTIFY_DURATION = 2

        local connections = {}

        local function notify(text)
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Teleport",
                    Text = text,
                    Duration = NOTIFY_DURATION
                })
            end)
        end

        local function getTargetCFrame(obj)
            if obj:IsA("BasePart") then
                return obj.CFrame
            elseif obj:IsA("Model") then
                if obj.PrimaryPart then
                    return obj.PrimaryPart.CFrame
                else
                    local parts = {}
                    for _, d in ipairs(obj:GetDescendants()) do
                        if d:IsA("BasePart") then
                            table.insert(parts, d)
                        end
                    end
                    if #parts == 0 then return nil end
                    local sum = Vector3.new(0, 0, 0)
                    for _, p in ipairs(parts) do
                        sum += p.Position
                    end
                    return CFrame.new(sum / #parts)
                end
            end
            return nil
        end

        local function findCoins1()
            for _, inst in ipairs(Workspace:GetDescendants()) do
                if inst.Name == "Coins1" then
                    if inst:IsA("BasePart") or inst:IsA("Model") then
                        return inst
                    end
                    local parent = inst.Parent
                    if parent and (parent:IsA("BasePart") or parent:IsA("Model")) then
                        return parent
                    end
                end
            end
            return nil
        end

        local function getHRP()
            local char = LocalPlayer.Character
            if not char then return nil end
            return char:FindFirstChild("HumanoidRootPart")
        end

        local function teleportToCoins1Exact()
            local hrp = getHRP()
            if not hrp then
                notify("HumanoidRootPart not detected")
                return
            end

            local target = findCoins1()
            if not target then
                notify("Coins1 not found in Workspace")
                return
            end

            local targetCFrame = getTargetCFrame(target)
            if not targetCFrame then
                notify("Could not get Coins1 position")
                return
            end

            hrp.CFrame = targetCFrame
            notify("Teleported to Coins1 (exact position)")
        end

        -- Floating GUI
        local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
        screenGui.Name = "TeleportPanel"
        screenGui.ResetOnSpawn = false

        local panel = Instance.new("Frame", screenGui)
        panel.Size = UDim2.new(0, 260, 0, 150)
        panel.Position = UDim2.new(0.5, -130, 0.5, -75)
        panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        panel.BorderSizePixel = 2
        panel.Active = true

        -- Touch and mouse support for moving
        local dragging = false
        local dragInput, dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        panel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = panel.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        panel.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                             input.UserInputType == Enum.UserInputType.Touch) then
                dragInput = input
            end
        end)

        table.insert(connections, UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end))

        -- Title
        local title = Instance.new("TextLabel", panel)
        title.Size = UDim2.new(1, 0, 0.25, 0)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "COLLECT COINS"
        title.TextColor3 = Color3.fromRGB(255, 255, 0)
        title.Font = Enum.Font.FredokaOne
        title.TextScaled = true

        -- Red button
        local button = Instance.new("TextButton", panel)
        button.Size = UDim2.new(0.8, 0, 0.25, 0)
        button.Position = UDim2.new(0.1, 0, 0.3, 0)
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        button.Text = "Teleport to coin"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.FredokaOne
        button.TextScaled = true

        button.MouseButton1Click:Connect(teleportToCoins1Exact)

        -- Blue text
        local info = Instance.new("TextLabel", panel)
        info.Size = UDim2.new(1, 0, 0.2, 0)
        info.Position = UDim2.new(0, 0, 0.6, 0)
        info.BackgroundTransparency = 1
        info.Text = "or press key C to teleport to a coin"
        info.TextColor3 = Color3.fromRGB(0, 170, 255)
        info.Font = Enum.Font.FredokaOne
        info.TextScaled = true

        -- Destroy button
        local destroyBtn = Instance.new("TextButton", panel)
        destroyBtn.Size = UDim2.new(0.8, 0, 0.2, 0)
        destroyBtn.Position = UDim2.new(0.1, 0, 0.82, 0)
        destroyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        destroyBtn.Text = "Destroy script"
        destroyBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        destroyBtn.Font = Enum.Font.FredokaOne
        destroyBtn.TextScaled = true

        -- C key
        table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == TELEPORT_KEY then
                teleportToCoins1Exact()
            end
        end))

        -- Destroy everything
        destroyBtn.MouseButton1Click:Connect(function()
            for _, conn in ipairs(connections) do
                if conn and conn.Disconnect then
                    conn:Disconnect()
                end
            end
            screenGui:Destroy()
            notify("Script destroyed. No longer active.")
        end)
    end
})

MainTab:AddSection("ESP")

MainTab:AddToggle({
    Title = "👥 Player ESP",
    Description = "Show players through walls",
    Default = false,
    Callback = function(Value)
        if Value then
            ShowNotification("ESP", "Player ESP ON", 3)
            
            -- ESP Activation
            local RunService = game:GetService("RunService")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer

            local function getCharacterHeight(character)
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    return humanoid.HipHeight + humanoid.BodyHeightScale.Value * 2
                end
                return 0
            end

            local function createESP(character)
                local head = character:FindFirstChild("Head")
                if not head then return end

                if character:FindFirstChild("RainbowESP") then
                    character.RainbowESP:Destroy()
                end

                local billboard = Instance.new("BillboardGui")
                billboard.Name = "RainbowESP"
                billboard.Size = UDim2.new(4, 0, 4, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = head
                billboard.Parent = character

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundTransparency = 1
                frame.BorderSizePixel = 0
                frame.Parent = billboard

                local stroke = Instance.new("UIStroke")
                stroke.Thickness = 5
                stroke.Parent = frame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1,0,0.3,0)
                label.Position = UDim2.new(0,0,-0.35,0)
                label.BackgroundTransparency = 1
                label.Text = ""
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                label.TextColor3 = Color3.new(1,0,0)
                label.Parent = billboard

                task.wait(0.2)

                local myChar = LocalPlayer.Character
                if not myChar then return end

                local myHum = myChar:FindFirstChildOfClass("Humanoid")
                local hum = character:FindFirstChildOfClass("Humanoid")

                if not myHum or not hum then return end

                if hum.HipHeight > myHum.HipHeight then
                    stroke.Color = Color3.new(1,0,0)
                    label.Text = "KILLER"
                else
                    local hue = 0
                    RunService.RenderStepped:Connect(function()
                        hue = hue + 0.005
                        if hue > 1 then hue = 0 end
                        stroke.Color = Color3.fromHSV(hue, 1, 1)
                    end)
                end
            end

            local function onPlayer(player)
                if player == LocalPlayer then return end

                player.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    createESP(char)
                end)

                if player.Character then
                    createESP(player.Character)
                end
            end

            for _, plr in pairs(Players:GetPlayers()) do
                onPlayer(plr)
            end

            Players.PlayerAdded:Connect(onPlayer)
        else
            ShowNotification("ESP", "Player ESP OFF", 3)
            
            -- ESP Deactivation
            local Players = game:GetService("Players")

            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("RainbowESP") then
                    player.Character.RainbowESP:Destroy()
                end
                
                player.CharacterAdded:Connect(function(char)
                    if char:FindFirstChild("RainbowESP") then
                        char.RainbowESP:Destroy()
                    end
                end)
            end

            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(char)
                    if char:FindFirstChild("RainbowESP") then
                        char.RainbowESP:Destroy()
                    end
                end)
            end)
        end
    end
})

MainTab:AddSection("Defense")

MainTab:AddButton({
    Title = "🛡️ Nightmare Defense",
    Description = "Auto teleport from big players",
    Callback = function()
        ShowNotification("Defense", "Nightmare defense activated!", 3)
        
        -- Nightmare Defense Script
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        local StarterGui = game:GetService("StarterGui")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")

        local LocalPlayer = Players.LocalPlayer

        local MAX_LOCATIONS = 12
        local WARNING_DISTANCE = 35
        local DANGER_DISTANCE = 20
        local WARNING_TEXT = "The monster's hitbox may not have time to trigger."
        local TARGET_TORSO_SIZE = Vector3.new(2.4000000953674316, 2.6000001430511475, 1.7999992370605469)
        local SIZE_TOLERANCE = 0.2

        local teleportEnabled = false
        local active = true
        local connection = nil
        local warnGui = nil
        local controlGui = nil

        local function createControlGUI()
            if controlGui then controlGui:Destroy() end
            
            controlGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
            controlGui.Name = "ControlGUI"
            controlGui.ResetOnSpawn = false
            controlGui.IgnoreGuiInset = true
            
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = "ButtonFrame"
            buttonFrame.Size = UDim2.new(0, 180, 0, 90)
            buttonFrame.Position = UDim2.new(1, -190, 0, 10)
            buttonFrame.BackgroundTransparency = 1
            buttonFrame.Parent = controlGui
            
            local teleportBtn = Instance.new("TextButton")
            teleportBtn.Name = "TeleportToggle"
            teleportBtn.Size = UDim2.new(1, 0, 0, 40)
            teleportBtn.Position = UDim2.new(0, 0, 0, 0)
            teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            teleportBtn.Text = "Teleport: OFF"
            teleportBtn.Font = Enum.Font.FredokaOne
            teleportBtn.TextSize = 18
            teleportBtn.Parent = buttonFrame
            
            local corner1 = Instance.new("UICorner", teleportBtn)
            corner1.CornerRadius = UDim.new(0, 8)
            
            local deleteBtn = Instance.new("TextButton")
            deleteBtn.Name = "DeleteScript"
            deleteBtn.Size = UDim2.new(1, 0, 0, 40)
            deleteBtn.Position = UDim2.new(0, 0, 0, 50)
            deleteBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            deleteBtn.Text = "DELETE SCRIPT"
            deleteBtn.Font = Enum.Font.FredokaOne
            deleteBtn.TextSize = 18
            deleteBtn.Parent = buttonFrame
            
            local corner2 = Instance.new("UICorner", deleteBtn)
            corner2.CornerRadius = UDim.new(0, 8)
            
            teleportBtn.MouseButton1Click:Connect(function()
                teleportEnabled = not teleportEnabled
                teleportBtn.Text = "Teleport: " .. (teleportEnabled and "ON" or "OFF")
                teleportBtn.BackgroundColor3 = teleportEnabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(60, 60, 60)
                
                StarterGui:SetCore("SendNotification", {
                    Title = "Teleport",
                    Text = "Teleport " .. (teleportEnabled and "enabled" or "disabled"),
                    Duration = 2
                })
            end)
            
            deleteBtn.MouseButton1Click:Connect(function()
                active = false
                
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                
                if warnGui then
                    warnGui:Destroy()
                    warnGui = nil
                end
                
                if controlGui then
                    controlGui:Destroy()
                    controlGui = nil
                end
                
                StarterGui:SetCore("SendNotification", {
                    Title = "Script",
                    Text = "Script deleted! Restart to activate again.",
                    Duration = 4
                })
            end)
            
            local dragToggle = nil
            local dragInput = nil
            local dragStart = nil
            local startPos = nil
            
            local function updateInput(input)
                local delta = input.Position - dragStart
                buttonFrame.Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
            end
            
            teleportBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragToggle = true
                    dragStart = input.Position
                    startPos = buttonFrame.Position
                    
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragToggle = false
                        end
                    end)
                end
            end)
            
            teleportBtn.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    dragInput = input
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragToggle and input == dragInput then
                    updateInput(input)
                end
            end)
            
            return controlGui
        end

        local function createWarningGUI()
            if warnGui then warnGui:Destroy() end
            
            local playerGui = LocalPlayer:WaitForChild("PlayerGui")
            warnGui = Instance.new("ScreenGui", playerGui)
            warnGui.Name = "MonsterWarningGui"
            warnGui.ResetOnSpawn = false
            warnGui.IgnoreGuiInset = true
            
            local warnLabel = Instance.new("TextLabel", warnGui)
            warnLabel.Size = UDim2.new(0.4, 0, 0.06, 0)
            warnLabel.Position = UDim2.new(0.02, 0, 0.02, 0)
            warnLabel.BackgroundColor3 = Color3.fromRGB(140, 40, 40)
            warnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            warnLabel.TextScaled = true
            warnLabel.Font = Enum.Font.FredokaOne
            warnLabel.Text = WARNING_TEXT
            warnLabel.Visible = false
            warnLabel.BorderSizePixel = 0
            warnLabel.TextWrapped = true
            
            local corner = Instance.new("UICorner", warnLabel)
            corner.CornerRadius = UDim.new(0, 14)
            
            return warnLabel
        end

        local function notify(text)
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Warning",
                    Text = text,
                    Duration = 2
                })
            end)
        end

        local function findAllLocations()
            local locations = {}
            local descendants = Workspace:GetDescendants()
            
            for i = 1, MAX_LOCATIONS do
                local targetName = "location" .. i
                
                for _, obj in ipairs(descendants) do
                    if string.lower(obj.Name) == targetName and obj:IsA("BasePart") then
                        table.insert(locations, obj)
                        break
                    end
                end
            end
            
            return locations
        end

        local function getHRP()
            if not LocalPlayer.Character then return nil end
            return LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        end

        local function getTargetCFrame(obj)
            return obj.CFrame + Vector3.new(0, obj.Size.Y / 2 + 3, 0)
        end

        local function isBigTorso(torso)
            local s = torso.Size
            return math.abs(s.X - TARGET_TORSO_SIZE.X) <= SIZE_TOLERANCE
                and math.abs(s.Y - TARGET_TORSO_SIZE.Y) <= SIZE_TOLERANCE
                and math.abs(s.Z - TARGET_TORSO_SIZE.Z) <= SIZE_TOLERANCE
        end

        local function getAllBigPlayers()
            local list = {}
            
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local torso = plr.Character:FindFirstChild("Torso")
                        or plr.Character:FindFirstChild("UpperTorso")
                    
                    if torso and isBigTorso(torso) then
                        table.insert(list, torso)
                    end
                end
            end
            
            return list
        end

        local lastTeleport = 0

        local function teleportToRandomLocation()
            if tick() - lastTeleport < 2 then return end
            lastTeleport = tick()
            
            local hrp = getHRP()
            if not hrp then return end
            
            local locations = findAllLocations()
            if #locations == 0 then
                notify("Locations not found!")
                return
            end
            
            local randomLocation = locations[math.random(1, #locations)]
            hrp.CFrame = getTargetCFrame(randomLocation)
        end

        local function initialize()
            if not active then return end
            
            local warnLabel = createWarningGUI()
            createControlGUI()
            
            connection = RunService.Heartbeat:Connect(function()
                if not active then return end
                
                local hrp = getHRP()
                if not hrp then return end
                
                local bigPlayers = getAllBigPlayers()
                
                if #bigPlayers >= 1 then
                    local closestTorso = nil
                    local closestDist = math.huge
                    
                    for _, torso in ipairs(bigPlayers) do
                        local dist = (hrp.Position - torso.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestTorso = torso
                        end
                    end
                    
                    if closestTorso then
                        if closestDist <= WARNING_DISTANCE then
                            warnLabel.Visible = true
                        else
                            warnLabel.Visible = false
                        end
                        
                        if closestDist <= DANGER_DISTANCE and teleportEnabled then
                            teleportToRandomLocation()
                        end
                    end
                else
                    warnLabel.Visible = false
                end
            end)
            
            notify("Script loaded! Teleport is OFF by default.")
        end

        initialize()

        LocalPlayer.CharacterAdded:Connect(function()
            if active then
                task.wait(1)
                initialize()
            end
        end)
    end
})

-- ==================== PLAYER TAB ====================
PlayerTab:AddSection("Movement")

PlayerTab:AddSlider({
    Title = "🚶 Walk Speed",
    Description = "Adjust walking speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Callback = function(Value)
        WalkSpeedValue = Value
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = Value
        end
        ShowNotification("Speed", "Walk speed: " .. Value, 3)
    end
})

PlayerTab:AddSlider({
    Title = "🦘 Jump Power",
    Description = "Adjust jump power",
    Default = 50,
    Min = 50,
    Max = 200,
    Callback = function(Value)
        JumpPowerValue = Value
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = Value
        end
        ShowNotification("Jump", "Jump power: " .. Value, 3)
    end
})

PlayerTab:AddSection("Settings")

PlayerTab:AddButton({
    Title = "🔄 Reset Settings",
    Description = "Reset to default values",
    Callback = function()
        WalkSpeedValue = 16
        JumpPowerValue = 50
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
            character.Humanoid.JumpPower = 50
        end
        ShowNotification("Reset", "Settings reset to default", 3)
    end
})

PlayerTab:AddToggle({
    Title = "⚡ Auto Respawn",
    Description = "Automatically respawn when dead",
    Default = false,
    Callback = function(Value)
        if Value then
            ShowNotification("Respawn", "Auto respawn ON", 3)
        else
            ShowNotification("Respawn", "Auto respawn OFF", 3)
        end
    end
})

-- ==================== TV ESP TAB ====================
TVTab:AddButton({
    Title = "📺 Load TV ESP",
    Description = "Load ESP for television objects",
    Callback = function()
        ShowNotification("TV ESP", "Loading TV ESP...", 3)
        loadstring(game:HttpGet("https://pastebin.com/raw/Vn4vySS2"))()
    end
})

-- ==================== BETA TAB ====================
BetaTab:AddSection("Beta Features")

BetaTab:AddButton({
    Title = "👻 Auto Fix TV",
    Description = "Automatically fix TV (Beta)",
    Callback = function()
        ShowNotification("Beta", "Auto fix TV activated...", 3)
        
        -- Auto Fix TV Script
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local RunService = game:GetService("RunService")

        local ScreenGui = Instance.new("ScreenGui", PlayerGui)
        ScreenGui.Name = "GhostSystem"
        local MainBtn = Instance.new("TextButton", ScreenGui)
        MainBtn.Size = UDim2.new(0, 200, 0, 50)
        MainBtn.Position = UDim2.new(0.5, -100, 0.05, 0)
        MainBtn.Text = "ULTIMATE GHOST: OFF"
        MainBtn.BackgroundColor3 = Color3.new(0, 0, 0)
        MainBtn.TextColor3 = Color3.new(1, 1, 0)
        Instance.new("UICorner", MainBtn)

        local ACTIVE = false

        local function FastActivate(btn)
            local signals = {"Activated", "MouseButton1Click", "MouseButton1Down", "MouseButton1Up", "TouchTap"}
            
            for _, signalName in pairs(signals) do
                pcall(function()
                    if getconnections then
                        for _, connection in pairs(getconnections(btn[signalName])) do
                            if connection.Function then
                                connection:Fire()
                            end
                        end
                    else
                        btn[signalName]:Fire()
                    end
                end)
            end
        end

        RunService.RenderStepped:Connect(function()
            if not ACTIVE then return end
            
            for _, v in pairs(PlayerGui:GetDescendants()) do
                if v:IsA("GuiButton") and v.Visible then
                    local isTarget = (v.Name == "GoldNoCoin" or v.Name == "Template" or v.Name == "Empty")
                    local isID = (v:IsA("ImageButton") and v.Image:match("768336794666"))
                    
                    if isTarget or isID then
                        if v.AbsoluteSize.X > 0 then
                            FastActivate(v)
                        end
                    end
                end
            end
        end)

        MainBtn.MouseButton1Click:Connect(function()
            ACTIVE = not ACTIVE
            MainBtn.Text = ACTIVE and "GHOST: WORKING 🔥" or "ULTIMATE GHOST: OFF"
            MainBtn.TextColor3 = ACTIVE and Color3.new(0, 1, 0) or Color3.new(1, 1, 0)
        end)
    end
})

-- ==================== EXTRAS TAB ====================
ExtraTab:AddSection("Admin")

ExtraTab:AddButton({
    Title = "👑 Infinite Yield",
    Description = "Load Infinite Yield admin",
    Callback = function()
        ShowNotification("Admin", "Loading Infinite Yield...", 3)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

ExtraTab:AddButton({
    Title = "🛡️ Anti-Kick",
    Description = "Prevent getting kicked",
    Callback = function()
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if tostring(self) == "Teleport" and method == "Kick" then
                return task.wait(9e9)
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
        
        ShowNotification("Security", "Anti-kick enabled!", 3)
    end
})

ExtraTab:AddSection("UI")

ExtraTab:AddKeybind({
    Title = "Toggle UI Keybind",
    Description = "Press to change key",
    Default = "K",
    Callback = function()
        Window:Toggle()
    end
})

ExtraTab:AddButton({
    Title = "📊 Show Stats",
    Description = "Display game statistics",
    Callback = function()
        local players = #game.Players:GetPlayers()
        local nightmare = nil
        
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Team and player.Team.Name == "Nightmare" then
                nightmare = player.Name
                break
            end
        end
        
        ShowNotification("Game Stats", 
            "Players: " .. players .. " | Nightmare: " .. (nightmare or "None"), 5)
    end
})

ExtraTab:AddButton({
    Title = "🔧 Test Notifications",
    Description = "Test notification system",
    Callback = function()
        ShowNotification("Test 1", "Wind UI notification test", 3)
        task.wait(1)
        ShowNotification("Test 2", "CoreGui notification test", 3)
        task.wait(1)
        ShowNotification("Test 3", "Console print test", 3)
        print("Hello world!")
    end
})

print("========================================")
print("TURBO B.Y HUB v6 Ultra - Wind UI Edition")
print("All functions loaded | English interface")
print("========================================")
