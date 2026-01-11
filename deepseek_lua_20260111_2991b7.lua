-- NeonUI Library v1.0
-- Современная библиотека интерфейсов для Roblox Executors
-- Автоматическая защита от повторной загрузки

if _G.NeonUILoaded then
    return _G.NeonUILibrary
end

_G.NeonUILoaded = true

-- Основные сервисы
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Константы
local LUCIDE_ICONS = {
    home = "rbxassetid://10723359606",
    gamepad = "rbxassetid://10723349054",
    user = "rbxassetid://10723372158",
    settings = "rbxassetid://10723365998",
    sword = "rbxassetid://10723368686",
    search = "rbxassetid://10723363070",
    lock = "rbxassetid://10723352334",
    unlock = "rbxassetid://10723370846",
    check = "rbxassetid://10723345022",
    x = "rbxassetid://10723373726",
    chevron_right = "rbxassetid://10723346398",
    sun = "rbxassetid://10723367454",
    moon = "rbxassetid://10723354606"
}

local EASING_STYLES = {
    Linear = Enum.EasingStyle.Linear,
    Sine = Enum.EasingStyle.Sine,
    Quad = Enum.EasingStyle.Quad,
    Quart = Enum.EasingStyle.Quart,
    Expo = Enum.EasingStyle.Exponential
}

-- Вспомогательные функции
local function create(class, props)
    local obj = Instance.new(class)
    for prop, value in pairs(props) do
        if prop ~= "Parent" then
            obj[prop] = value
        end
    end
    if props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function tween(obj, props, duration, easing)
    local tweenInfo = TweenInfo.new(duration, easing or EASING_STYLES.Quart)
    local tweenObj = TweenService:Create(obj, tweenInfo, props)
    tweenObj:Play()
    return tweenObj
end

-- Класс Element (базовый для всех элементов)
local Element = {}
Element.__index = Element

function Element.new(config)
    local self = setmetatable({
        _locked = config.Locked or false,
        _visible = true,
        _container = nil,
        _callback = config.Callback or function() end
    }, Element)
    return self
end

function Element:SetLocked(state)
    self._locked = state
    if self._container then
        self._container.Active = not state
        self._container.BackgroundTransparency = state and 0.7 or 0
    end
end

function Element:SetVisible(state)
    self._visible = state
    if self._container then
        self._container.Visible = state
    end
end

-- Класс Button
local Button = setmetatable({}, {__index = Element})
Button.__index = Button

function Button.new(config, parent)
    local self = Element.new(config)
    setmetatable(self, Button)
    
    self._container = create("Frame", {
        Name = "Button_" .. config.Title,
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 0)
    })
    
    local corner = create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = self._container
    })
    
    local stroke = create("UIStroke", {
        Parent = self._container,
        Color = Color3.fromRGB(80, 80, 80),
        Thickness = 1
    })
    
    local titleLabel = create("TextLabel", {
        Parent = self._container,
        Text = config.Title,
        Font = Enum.Font.GothamSemibold,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 14,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 45, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    if config.Desc and config.Desc ~= "" then
        titleLabel.Text = config.Title .. "\n" .. create("TextLabel", {
            Text = config.Desc,
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(180, 180, 180),
            TextSize = 12,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0.5, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    
    if config.Icon then
        local iconId = config.Icon:gsub("lucide:", "")
        if LUCIDE_ICONS[iconId] then
            create("ImageLabel", {
                Parent = self._container,
                Image = LUCIDE_ICONS[iconId],
                ImageColor3 = Color3.fromRGB(180, 180, 180),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 15, 0.5, -10)
            })
        end
    end
    
    -- Анимации при наведении
    local isHovering = false
    
    self._container.MouseEnter:Connect(function()
        if not self._locked then
            isHovering = true
            tween(self._container, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}, 0.2)
        end
    end)
    
    self._container.MouseLeave:Connect(function()
        if not self._locked then
            isHovering = false
            tween(self._container, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
        end
    end)
    
    self._container.InputBegan:Connect(function(input)
        if not self._locked and input.UserInputType == Enum.UserInputType.MouseButton1 then
            tween(self._container, {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}, 0.1)
        end
    end)
    
    self._container.InputEnded:Connect(function(input)
        if not self._locked and input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isHovering then
                tween(self._container, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}, 0.1)
            else
                tween(self._container, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.1)
            end
            coroutine.wrap(self._callback)()
        end
    end)
    
    self:SetLocked(config.Locked or false)
    return self
end

-- Класс Toggle
local Toggle = setmetatable({}, {__index = Element})
Toggle.__index = Toggle

function Toggle.new(config, parent)
    local self = Element.new(config)
    setmetatable(self, Toggle)
    
    self._value = config.Value or false
    
    self._container = create("Frame", {
        Name = "Toggle_" .. config.Title,
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 0)
    })
    
    local corner = create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = self._container
    })
    
    local titleLabel = create("TextLabel", {
        Parent = self._container,
        Text = config.Title,
        Font = Enum.Font.GothamSemibold,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 14,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 45, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    if config.Desc then
        create("TextLabel", {
            Parent = self._container,
            Text = config.Desc,
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(180, 180, 180),
            TextSize = 12,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -80, 0.5, 0),
            Position = UDim2.new(0, 45, 0.5, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    
    -- Визуальный переключатель
    local toggleFrame = create("Frame", {
        Parent = self._container,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = toggleFrame
    })
    
    local toggleCircle = create("Frame", {
        Parent = toggleFrame,
        BackgroundColor3 = Color3.fromRGB(120, 120, 120),
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0, 2),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = toggleCircle
    })
    
    -- Иконка
    if config.Icon then
        local iconId = config.Icon:gsub("lucide:", "")
        if LUCIDE_ICONS[iconId] then
            create("ImageLabel", {
                Parent = self._container,
                Image = LUCIDE_ICONS[iconId],
                ImageColor3 = Color3.fromRGB(180, 180, 180),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 15, 0.5, -10)
            })
        end
    end
    
    -- Функция обновления визуала
    local function updateVisual()
        if self._value then
            tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}, 0.2)
            tween(toggleCircle, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(1, -18, 0, 2)
            }, 0.2)
        else
            tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
            tween(toggleCircle, {
                BackgroundColor3 = Color3.fromRGB(120, 120, 120),
                Position = UDim2.new(0, 2, 0, 2)
            }, 0.2)
        end
    end
    
    -- Обработчик клика
    self._container.InputBegan:Connect(function(input)
        if not self._locked and input.UserInputType == Enum.UserInputType.MouseButton1 then
            self._value = not self._value
            updateVisual()
            coroutine.wrap(self._callback)(self._value)
        end
    end)
    
    updateVisual()
    self:SetLocked(config.Locked or false)
    return self
end

function Toggle:GetValue()
    return self._value
end

function Toggle:SetValue(value)
    self._value = value
    updateVisual()
end

-- Класс Section
local Section = {}
Section.__index = Section

function Section.new(config, parent)
    local self = setmetatable({
        _parent = parent,
        _title = config.Title,
        _side = config.Side or "Left",
        _elements = {},
        _container = nil
    }, Section)
    
    self._container = create("Frame", {
        Name = "Section_" .. config.Title,
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, -5, 0, 0),
        Position = self._side == "Left" and UDim2.new(0, 0, 0, 0) or UDim2.new(0.5, 5, 0, 0)
    })
    
    if config.Title and config.Title ~= "" then
        create("TextLabel", {
            Parent = self._container,
            Text = config.Title:upper(),
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 12,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    
    self._content = create("Frame", {
        Parent = self._container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -20),
        Position = UDim2.new(0, 0, 0, 20)
    })
    
    create("UIListLayout", {
        Parent = self._content,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    return self
end

function Section:Button(config)
    local button = Button.new(config, self._content)
    table.insert(self._elements, button)
    self:updateSize()
    return button
end

function Section:Toggle(config)
    local toggle = Toggle.new(config, self._content)
    table.insert(self._elements, toggle)
    self:updateSize()
    return toggle
end

function Section:updateSize()
    local elementCount = #self._elements
    local height = elementCount * 55 + (elementCount - 1) * 5
    self._container.Size = UDim2.new(self._container.Size.X.Scale, self._container.Size.X.Offset, 0, height + 20)
end

-- Класс Tab
local Tab = {}
Tab.__index = Tab

function Tab.new(config, parent)
    local self = setmetatable({
        _parent = parent,
        _title = config.Title,
        _icon = config.Icon,
        _sections = {},
        _container = nil,
        _active = false
    }, Tab)
    
    self._container = create("Frame", {
        Name = "Tab_" .. config.Title,
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        Visible = false
    })
    
    return self
end

function Tab:Section(config)
    local section = Section.new(config, self._container)
    table.insert(self._sections, section)
    return section
end

function Tab:SetVisible(state)
    self._container.Visible = state
    self._active = state
end

-- Главный класс Window
local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({
        _title = config.Title,
        _icon = config.Icon,
        _tabs = {},
        _currentTab = nil,
        _container = nil
    }, Window)
    
    -- Создание основного GUI
    local screenGui = create("ScreenGui", {
        Name = "NeonUI",
        Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    })
    
    self._container = create("Frame", {
        Parent = screenGui,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        Active = true,
        Draggable = true
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = self._container
    })
    
    create("UIStroke", {
        Parent = self._container,
        Color = Color3.fromRGB(60, 60, 60),
        Thickness = 2
    })
    
    -- Заголовок
    local titleBar = create("Frame", {
        Parent = self._container,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0)
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 12, 0, 0),
        Parent = titleBar
    })
    
    -- Иконка и заголовок
    if self._icon then
        local iconId = self._icon:gsub("lucide:", "")
        if LUCIDE_ICONS[iconId] then
            create("ImageLabel", {
                Parent = titleBar,
                Image = LUCIDE_ICONS[iconId],
                ImageColor3 = Color3.fromRGB(0, 170, 255),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 15, 0.5, -10)
            })
        end
    end
    
    create("TextLabel", {
        Parent = titleBar,
        Text = self._title,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 18,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 45, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Панель вкладок
    self._tabsContainer = create("Frame", {
        Parent = self._container,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 40)
    })
    
    self._tabsList = create("Frame", {
        Parent = self._tabsContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    })
    
    local tabsLayout = create("UIListLayout", {
        Parent = self._tabsList,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Контент
    self._content = create("Frame", {
        Parent = self._container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -90),
        Position = UDim2.new(0, 0, 0, 90)
    })
    
    -- Drag функционал
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        self._container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self._container.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Анимация появления
    self._container.Size = UDim2.new(0, 0, 0, 0)
    self._container.Position = UDim2.new(0.5, 0, 0.5, 0)
    tween(self._container, {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200)
    }, 0.5, EASING_STYLES.Quart)
    
    return self
end

function Window:Tab(config)
    local tab = Tab.new(config, self._content)
    table.insert(self._tabs, tab)
    
    -- Создание кнопки вкладки
    local tabButton = create("TextButton", {
        Parent = self._tabsList,
        Text = config.Title,
        Font = Enum.Font.GothamSemibold,
        TextColor3 = Color3.fromRGB(180, 180, 180),
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 100, 1, 0),
        AutoButtonColor = false
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = tabButton
    })
    
    -- Иконка вкладки
    if config.Icon then
        local iconId = config.Icon:gsub("lucide:", "")
        if LUCIDE_ICONS[iconId] then
            create("ImageLabel", {
                Parent = tabButton,
                Image = LUCIDE_ICONS[iconId],
                ImageColor3 = Color3.fromRGB(180, 180, 180),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0.5, -25, 0.5, -9)
            })
        end
    end
    
    -- Обработчик переключения вкладок
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(tab)
        -- Анимация активной вкладки
        for _, t in ipairs(self._tabs) do
            if t == tab then
                tween(tabButton, {
                    BackgroundColor3 = Color3.fromRGB(0, 120, 215),
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }, 0.2)
            else
                -- Найти соответствующую кнопку и вернуть обычный стиль
                tween(tabButton, {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    TextColor3 = Color3.fromRGB(180, 180, 180)
                }, 0.2)
            end
        end
    end)
    
    -- Активируем первую вкладку
    if #self._tabs == 1 then
        self:SwitchTab(tab)
        tween(tabButton, {
            BackgroundColor3 = Color3.fromRGB(0, 120, 215),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, 0.2)
    end
    
    return tab
end

function Window:SwitchTab(tab)
    if self._currentTab then
        self._currentTab:SetVisible(false)
    end
    self._currentTab = tab
    tab:SetVisible(true)
end

-- Главная библиотека
local NeonUI = {}

function NeonUI:Window(config)
    return Window.new(config)
end

-- Пример использования (демонстрация)
local example = [[
--[[
    ПРИМЕР ИСПОЛЬЗОВАНИЯ NEONUI
--]]

local NeptuneLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/.../NeonUI.lua"))()

local Window = NeptuneLib:Window({
    Title = "Turbo b.y Hub v2.0",
    Icon = "lucide:gamepad-2"
})

local MainTab = Window:Tab({
    Title = "Основное",
    Icon = "lucide:home"
})

local CombatSection = MainTab:Section({
    Title = "Комбат",
    Side = "Left"
})

local MyToggle = CombatSection:Toggle({
    Title = "Авто-атака",
    Desc = "Автоматически атакует ближайших врагов",
    Icon = "lucide:sword",
    Value = false,
    Callback = function(state)
        print("Авто-атака:", state)
    end
})

local MyButton = CombatSection:Button({
    Title = "Убить всех",
    Desc = "Мгновенно убивает всех врагов в радиусе",
    Icon = "lucide:skull",
    Locked = false,
    Callback = function()
        print("Активировано убийство всех!")
    end
})

-- Заблокировать кнопку через 5 секунд
task.wait(5)
MyButton:SetLocked(true)
print("Кнопка заблокирована!")

local PlayerSection = MainTab:Section({
    Title = "Игрок",
    Side = "Right"
})

local SpeedToggle = PlayerSection:Toggle({
    Title = "Скорость x2",
    Icon = "lucide:zap",
    Value = true,
    Callback = function(state)
        print("Скорость x2:", state)
    end
})

local HealButton = PlayerSection:Button({
    Title = "Вылечиться",
    Icon = "lucide:heart",
    Callback = function()
        print("Игрок вылечен!")
    end
})

local TeleportTab = Window:Tab({
    Title = "Телепорты",
    Icon = "lucide:map"
})

local LocationsSection = TeleportTab:Section({
    Title = "Локации",
    Side = "Left"
})

local TeleportButtons = {
    {Name = "База", Icon = "lucide:home"},
    {Name = "Арена", Icon = "lucide:swords"},
    {Name = "Сокровища", Icon = "lucide:gem"},
    {Name = "Секретная зона", Icon = "lucide:lock"}
}

for _, loc in ipairs(TeleportButtons) do
    LocationsSection:Button({
        Title = "Телепорт: " .. loc.Name,
        Icon = loc.Icon,
        Callback = function()
            print("Телепорт в:", loc.Name)
        end
    })
end
]]

_G.NeonUILibrary = NeonUI
return NeonUI