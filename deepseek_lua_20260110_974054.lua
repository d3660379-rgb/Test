-- Turbo B.Y Hub - WindUI Version (COMPLETE)

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Create main window
local Window = WindUI:CreateWindow({
    Title = "Lori Nightmare - Turbo B.Y Hub",
    Icon = "gamepad-2",
    Author = "by Testmy_roblox123",
})

-- NOTIFICATION SYSTEM
local function ShowNotification(title, text, duration)
    duration = duration or 5
    WindUI:Notify({
        Title = title,
        Content = text,
        Duration = duration,
        Icon = "info"
    })
    print("[NOTIFY] " .. title .. ": " .. text)
end

-- Create all tabs
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "gamepad-2",
    Locked = false,
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
    Locked = false,
})

local TVTab = Window:Tab({
    Title = "TV ESP",
    Icon = "tv",
    Locked = false,
})

local ExtraTab = Window:Tab({
    Title = "Extras",
    Icon = "settings",
    Locked = false,
})

local BetaTab = Window:Tab({
    Title = "Beta testing",
    Icon = "flask-conical",
    Locked = false,
})

Window:Tag({
    Title = "error fixes",
    Icon = "github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 0,
})

-- Wait and show notification
task.wait(2)
ShowNotification("Hub Loaded", "Turbo B.Y Hub v6 ultra started!", 5)

-- ===========================================
-- MAIN TAB
-- ===========================================
MainTab:Section("Teleportation")

-- Teleport to TV (FULL SCRIPT)
MainTab:Button({
    Title = "Teleport to TV",
    Callback = function()
        ShowNotification("Teleport", "Teleporting to TV...", 3)
        
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
                    Title = "teleport to TV",
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
            print("--- НАЧАЛО ПОИСКА ЛОКАЦИЙ (location1...) ---") 
            local locations = {}
            local descendants = Workspace:GetDescendants()
            
            for i = 1, MAX_LOCATIONS do
                local targetName = "location" .. i 
                local found = false
                
                for _, obj in ipairs(descendants) do
                    if string.lower(obj.Name) == targetName and obj:IsA("BasePart") then
                        table.insert(locations, obj)
                        found = true
                        break
                    end
                end
                
                if not found then
                    print("I don't think so: " .. targetName)
                end
            end
            
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
                notify("character")
                return
            end

            local locations = findAllLocations()
            
            if #locations == 0 then
                notify("The map has been removed. We are waiting.")
                warn("loading map location1...location12")
                return
            end
            
            local randomIndex = math.random(1, #locations)
            local target = locations[randomIndex]

            local targetCFrame = getTargetCFrame(target)
            if targetCFrame then
                hrp.CFrame = targetCFrame
                notify("ТП к: " .. target.Name)
            end
        end

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

        local title = Instance.new("TextLabel", panel)
        title.Size = UDim2.new(1,0,0.25,0); title.Text = "TV"; title.TextColor3 = Color3.fromRGB(0,255,255); title.Font = Enum.Font.FredokaOne; title.TextScaled = true; title.BackgroundTransparency = 1
        local button = Instance.new("TextButton", panel)
        button.Size = UDim2.new(0.8,0,0.25,0); button.Position = UDim2.new(0.1,0,0.3,0); button.BackgroundColor3 = Color3.fromRGB(0,180,0); button.Text = "teleport to TV"; button.TextColor3 = Color3.fromRGB(255,255,255); button.Font = Enum.Font.FredokaOne; button.TextScaled = true
        button.MouseButton1Click:Connect(teleportToRandomLocation)

        local destroyBtn = Instance.new("TextButton", panel)
        destroyBtn.Size = UDim2.new(0.8,0,0.2,0); destroyBtn.Position = UDim2.new(0.1,0,0.82,0); destroyBtn.BackgroundColor3 = Color3.fromRGB(80,80,80); destroyBtn.Text = "delete GUI"; destroyBtn.TextColor3 = Color3.fromRGB(255,80,80); destroyBtn.Font = Enum.Font.FredokaOne; destroyBtn.TextScaled = true

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

-- Teleport to Exit (FULL SCRIPT)
MainTab:Button({
    Title = "Teleport to Exit",
    Callback = function()
        ShowNotification("Teleport", "Teleporting to exit...", 3)
        
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local StarterGui = game:GetService("StarterGui")

        local LocalPlayer = Players.LocalPlayer
        local NOTIFY_DURATION = 3
        local TARGET_PATH = "Misc.ExitPortal.Telepad"

        local function notify(text)
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Телепорт",
                    Text = text,
                    Duration = NOTIFY_DURATION
                })
            end)
        end

        local function teleportToTarget(targetPart)
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if not hrp then
                notify("character not found")
                return
            end

            local targetCFrame = targetPart.CFrame + Vector3.new(0, targetPart.Size.Y / 2 + 3, 0)
            
            hrp.CFrame = targetCFrame
            notify("successful TP: " .. targetPart.Name)
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
            print("✅ Target 'Telepad' найден. Ожидание персонажа...")
            
            if LocalPlayer.Character then
                teleportToTarget(targetContainer)
            else
                LocalPlayer.CharacterAdded:Once(function()
                    teleportToTarget(targetContainer)
                end)
            end
        else
            notify("waiting for map to load")
            warn(": Парт по пути ReplicatedStorage." .. TARGET_PATH .. " не найден.")
        end
    end
})

MainTab:Section("Money")

-- Auto Collect Coins (FULL SCRIPT)
MainTab:Button({
    Title = "Auto Collect Coins",
    Callback = function()
        ShowNotification("Money", "Auto coin collection started!", 3)
        
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
                notify("No se detecta HumanoidRootPart")
                return
            end

            local target = findCoins1()
            if not target then
                notify("No se encontró Coins1 en Workspace")
                return
            end

            local targetCFrame = getTargetCFrame(target)
            if not targetCFrame then
                notify("No se pudo obtener posición de Coins1")
                return
            end

            hrp.CFrame = targetCFrame
            notify("Teletransportado a Coins1 (posición exacta)")
        end

        local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
        screenGui.Name = "TeleportPanel"
        screenGui.ResetOnSpawn = false

        local panel = Instance.new("Frame", screenGui)
        panel.Size = UDim2.new(0, 260, 0, 150)
        panel.Position = UDim2.new(0.5, -130, 0.5, -75)
        panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        panel.BorderSizePixel = 2
        panel.Active = true

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

        local title = Instance.new("TextLabel", panel)
        title.Size = UDim2.new(1, 0, 0.25, 0)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "COLLECT COINS"
        title.TextColor3 = Color3.fromRGB(255, 255, 0)
        title.Font = Enum.Font.FredokaOne
        title.TextScaled = true

        local button = Instance.new("TextButton", panel)
        button.Size = UDim2.new(0.8, 0, 0.25, 0)
        button.Position = UDim2.new(0.1, 0, 0.3, 0)
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        button.Text = "Teleport to coin"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.FredokaOne
        button.TextScaled = true

        button.MouseButton1Click:Connect(teleportToCoins1Exact)

        local info = Instance.new("TextLabel", panel)
        info.Size = UDim2.new(1, 0, 0.2, 0)
        info.Position = UDim2.new(0, 0, 0.6, 0)
        info.BackgroundTransparency = 1
        info.Text = "or press key C to teleport to a coin"
        info.TextColor3 = Color3.fromRGB(0, 170, 255)
        info.Font = Enum.Font.FredokaOne
        info.TextScaled = true

        local destroyBtn = Instance.new("TextButton", panel)
        destroyBtn.Size = UDim2.new(0.8, 0, 0.2, 0)
        destroyBtn.Position = UDim2.new(0.1, 0, 0.82, 0)
        destroyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        destroyBtn.Text = "Destroy script"
        destroyBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        destroyBtn.Font = Enum.Font.FredokaOne
        destroyBtn.TextScaled = true

        table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == TELEPORT_KEY then
                teleportToCoins1Exact()
            end
        end))

        destroyBtn.MouseButton1Click:Connect(function()
            for _, conn in ipairs(connections) do
                if conn and conn.Disconnect then
                    conn:Disconnect()
                end
            end
            screenGui:Destroy()
            notify("Script destruido. Ya no está activo.")
        end)
    end
})

MainTab:Section("ESP")

-- Player ESP (FULL SCRIPTS)
MainTab:Toggle({
    Title = "Player ESP",
    Value = false,
    Callback = function(state)
        if state then
            ShowNotification("ESP", "Player ESP ON", 3)
            
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

MainTab:Section("Defense")

-- Nightmare Defense (FULL SCRIPT)
MainTab:Button({
    Title = "Nightmare Defense",
    Callback = function()
        ShowNotification("Defense", "Nightmare defense activated!", 3)
        
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
            
            local corner = Instance.new("UICorner", warnLabel)
            corner.CornerRadius = UDim.new(0, 14)
            warnLabel.TextWrapped = true
            
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

-- ===========================================
-- PLAYER TAB
-- ===========================================
local WalkSpeedValue = 16
local JumpPowerValue = 50

PlayerTab:Section("Movement")

PlayerTab:Slider({
    Title = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        WalkSpeedValue = value
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = value
        end
        ShowNotification("Speed", "Walk speed: " .. value, 3)
    end
})

PlayerTab:Slider({
    Title = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(value)
        JumpPowerValue = value
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = value
        end
        ShowNotification("Jump", "Jump power: " .. value, 3)
    end
})

PlayerTab:Section("Settings")

PlayerTab:Button({
    Title = "Reset Settings",
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

PlayerTab:Toggle({
    Title = "Auto Respawn",
    Value = false,
    Callback = function(state)
        if state then
            ShowNotification("Respawn", "Auto respawn ON", 3)
        else
            ShowNotification("Respawn", "Auto respawn OFF", 3)
        end
    end
})

-- ===========================================
-- TV ESP TAB
-- ===========================================
TVTab:Button({
    Title = "Load Esp tv(fix)",
    Callback = function()
        ShowNotification("Admin", "Loading Infinite Yield...", 3)
        loadstring(game:HttpGet("https://pastebin.com/raw/Vn4vySS2"))()
    end
})

-- ===========================================
-- EXTRAS TAB
-- ===========================================
ExtraTab:Section("Admin")

ExtraTab:Button({
    Title = "Infinite Yield",
    Callback = function()
        ShowNotification("Admin", "Loading Infinite Yield...", 3)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

ExtraTab:Button({
    Title = "Anti-Kick",
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

ExtraTab:Section("UI")

ExtraTab:Keybind({
    Title = "Toggle UI",
    Default = "K",
    Callback = function()
        Window:Toggle()
    end
})

ExtraTab:Button({
    Title = "Show Stats",
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

ExtraTab:Button({
    Title = "Test Notifications",
    Callback = function()
        ShowNotification("Test 1", "Notification test", 3)
        task.wait(1)
        ShowNotification("Test 2", "Second test", 3)
    end
})

-- ===========================================
-- BETA TAB
-- ===========================================
BetaTab:Section("Beta xd")

BetaTab:Button({
    Title = "auto fix tv",
    Callback = function()
        ShowNotification("Beta xd", "replenishment for testing...", 3)
        
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

print("========================================")
print("TURBO B.Y HUB - WINDUI VERSION (COMPLETE)")
print("All scripts preserved from original")
print("========================================")