local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local MonarchUI = {}
MonarchUI.__index = MonarchUI

local COLORS = {
    Orange = Color3.fromRGB(255, 87, 34),
    OrangeHover = Color3.fromRGB(230, 74, 25),
    Black = Color3.fromRGB(15, 15, 15),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(107, 114, 128),
    GrayLight = Color3.fromRGB(243, 244, 246),
    GrayBorder = Color3.fromRGB(229, 231, 235),
    WarmBg = Color3.fromRGB(254, 247, 244),
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68),
    Background = Color3.fromRGB(255, 255, 255),
}

local TAB_ICONS = {
    ["Aimbot"] = "\u{2316}",
    ["ESP"] = "\u{229E}",
    ["Movement"] = "\u{2197}",
    ["Gun Mods"] = "\u{2726}",
    ["Misc"] = "\u{2630}",
    ["Settings"] = "\u{2699}",
}

local function CreateElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

local function Tween(object, properties, duration, style, direction)
    if typeof(object) ~= "Instance" or not object.Parent then return nil end
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local ok, tween = pcall(TweenService.Create, TweenService, object, tweenInfo, properties)
    if ok and tween then
        tween:Play()
        return tween
    end
    return nil
end

function MonarchUI:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Visible = true
    
    local ScreenGui = CreateElement("ScreenGui", {
        Name = "MonarchHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game:GetService("CoreGui") or game.Players.LocalPlayer.PlayerGui
    })
    Window.ScreenGui = ScreenGui
    
    local MainFrame = CreateElement("Frame", {
        Name = "Main",
        Size = config.Size or UDim2.fromOffset(620, 500),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.Background,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    Window.MainFrame = MainFrame
    
    local Shadow = CreateElement("Frame", {
        Name = "Shadow",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundColor3 = COLORS.Black,
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = MainFrame
    })
    
    CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = Shadow
    })
    
    CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = MainFrame
    })
    
    local Scale = CreateElement("UIScale", {
        Scale = 0.95,
        Parent = MainFrame
    })
    
    Tween(MainFrame, {BackgroundTransparency = 0}, 0.3)
    Tween(Scale, {Scale = 1}, 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local TopBar = CreateElement("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = TopBar
    })
    
    local TopBarBorder = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = COLORS.GrayBorder,
        BorderSizePixel = 0,
        Parent = TopBar
    })
    
    local AccentBar = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = COLORS.Orange,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 3),
        Parent = AccentBar
    })
    
    local TitleBadge = CreateElement("Frame", {
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.fromOffset(18, 11),
        BackgroundColor3 = COLORS.Orange,
        BorderSizePixel = 0,
        Parent = TopBar
    })
    
    CreateElement("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = TitleBadge
    })
    
    local TitleBadgeLabel = CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "M",
        TextColor3 = COLORS.White,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = TitleBadge
    })
    
    local Title = CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.fromOffset(54, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "MonarchHub",
        TextColor3 = COLORS.Black,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    local CloseButton = CreateElement("TextButton", {
        Name = "Close",
        Size = UDim2.fromOffset(36, 36),
        Position = UDim2.new(1, -48, 0.5, -18),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = COLORS.Gray,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        Parent = TopBar
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        Window:Toggle()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {TextColor3 = COLORS.Error}, 0.15)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {TextColor3 = COLORS.Gray}, 0.15)
    end)
    
    local TabBar = CreateElement("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, 180, 1, -50),
        Position = UDim2.fromOffset(0, 50),
        BackgroundColor3 = COLORS.WarmBg,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local TabList = CreateElement("ScrollingFrame", {
        Name = "List",
        Size = UDim2.new(1, -10, 1, -20),
        Position = UDim2.fromOffset(5, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = COLORS.Orange,
        ScrollBarImageTransparency = 0.6,
        CanvasSize = UDim2.fromOffset(0, 0),
        Parent = TabBar
    })
    
    local TabListLayout = CreateElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = TabList
    })
    
    CreateElement("UIPadding", {
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = TabList
    })
    
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local ContentFrame = CreateElement("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -190, 1, -60),
        Position = UDim2.fromOffset(185, 55),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    function Window:Tab(config)
        local Tab = {}
        Tab.Elements = {}
        Tab.Sections = {}
        
        local TabButton = CreateElement("TextButton", {
            Name = config.Title,
            Size = UDim2.new(1, 0, 0, 44),
            BackgroundColor3 = COLORS.White,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = TabList
        })
        
        CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = TabButton
        })
        
        local ActiveIndicator = CreateElement("Frame", {
            Size = UDim2.new(0, 3, 0, 18),
            Position = UDim2.new(0, 0, 0.5, -9),
            BackgroundColor3 = COLORS.Orange,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Parent = TabButton
        })
        
        CreateElement("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = ActiveIndicator
        })
        
        local TabIconCircle = CreateElement("Frame", {
            Size = UDim2.fromOffset(28, 28),
            Position = UDim2.fromOffset(12, 8),
            BackgroundColor3 = COLORS.GrayLight,
            BorderSizePixel = 0,
            Parent = TabButton
        })
        
        CreateElement("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = TabIconCircle
        })
        
        local iconSymbol = TAB_ICONS[config.Title] or config.Title:sub(1, 1):upper()
        
        local TabIconLabel = CreateElement("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = iconSymbol,
            TextColor3 = COLORS.Gray,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = TabIconCircle
        })
        
        local TabLabel = CreateElement("TextLabel", {
            Size = UDim2.new(1, -52, 1, 0),
            Position = UDim2.fromOffset(48, 0),
            BackgroundTransparency = 1,
            Text = config.Title,
            TextColor3 = COLORS.Gray,
            TextSize = 14,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        local TabContent = CreateElement("ScrollingFrame", {
            Name = config.Title .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = COLORS.Orange,
            ScrollBarImageTransparency = 0.5,
            CanvasSize = UDim2.fromOffset(0, 0),
            Visible = false,
            Parent = ContentFrame
        })
        
        local ContentLayout = CreateElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12),
            Parent = TabContent
        })
        
        CreateElement("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 10),
            Parent = TabContent
        })
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local function ActivateTab()
            for _, tab in pairs(Window.Tabs) do
                if tab.Content and typeof(tab.Content) == "Instance" then
                    tab.Content.Visible = false
                end
                if tab.Button and typeof(tab.Button) == "Instance" then
                    Tween(tab.Button, {BackgroundColor3 = COLORS.White}, 0.2)
                end
                if tab.Label and typeof(tab.Label) == "Instance" then
                    Tween(tab.Label, {TextColor3 = COLORS.Gray}, 0.2)
                end
                if tab.IconCircle and typeof(tab.IconCircle) == "Instance" then
                    Tween(tab.IconCircle, {BackgroundColor3 = COLORS.GrayLight}, 0.2)
                end
                if tab.IconLabel and typeof(tab.IconLabel) == "Instance" then
                    Tween(tab.IconLabel, {TextColor3 = COLORS.Gray}, 0.2)
                end
                if tab.ActiveIndicator and typeof(tab.ActiveIndicator) == "Instance" then
                    Tween(tab.ActiveIndicator, {BackgroundTransparency = 1}, 0.15)
                end
            end
            if TabContent and typeof(TabContent) == "Instance" then
                TabContent.Visible = true
                TabContent.CanvasPosition = Vector2.new(0, 0)
                TabContent.Position = UDim2.new(0, 0, 0, 6)
                Tween(TabContent, {Position = UDim2.new(0, 0, 0, 0)}, 0.25)
            end
            Tween(TabButton, {BackgroundColor3 = COLORS.Orange}, 0.2)
            Tween(TabLabel, {TextColor3 = COLORS.White}, 0.2)
            Tween(TabIconCircle, {BackgroundColor3 = COLORS.Orange}, 0.2)
            Tween(TabIconLabel, {TextColor3 = COLORS.White}, 0.2)
            ActiveIndicator.BackgroundTransparency = 0
            Tween(ActiveIndicator, {BackgroundTransparency = 0}, 0.15)
            Window.CurrentTab = Tab
        end

        TabButton.MouseButton1Click:Connect(ActivateTab)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = COLORS.GrayLight}, 0.15)
                Tween(TabLabel, {TextColor3 = COLORS.Black}, 0.15)
                Tween(TabIconLabel, {TextColor3 = COLORS.Black}, 0.15)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = COLORS.White}, 0.15)
                Tween(TabLabel, {TextColor3 = COLORS.Gray}, 0.15)
                Tween(TabIconLabel, {TextColor3 = COLORS.Gray}, 0.15)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Label = TabLabel
        Tab.IconCircle = TabIconCircle
        Tab.IconLabel = TabIconLabel
        Tab.ActiveIndicator = ActiveIndicator
        Tab.Content = TabContent
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            ActivateTab()
        end
        
        function Tab:Section(config)
            local Section = CreateElement("Frame", {
                Name = "Section",
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = COLORS.WarmBg,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Section
            })
            
            local SectionAccent = CreateElement("Frame", {
                Size = UDim2.new(0, 4, 0.5, 0),
                Position = UDim2.fromOffset(0, 10),
                BackgroundColor3 = COLORS.Orange,
                BorderSizePixel = 0,
                Parent = Section
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SectionAccent
            })
            
            local SectionLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.fromOffset(14, 0),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = COLORS.Black,
                TextSize = 15,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section
            })
            
            return Section
        end
        
        function Tab:Toggle(config)
            local Toggle = CreateElement("Frame", {
                Name = "Toggle",
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Toggle
            })
            
            CreateElement("UIStroke", {
                Color = COLORS.GrayBorder,
                Thickness = 1,
                Parent = Toggle
            })
            
            local ToggleLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.fromOffset(15, 8),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = COLORS.Black,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Toggle
            })
            
            if config.Desc then
                local ToggleDesc = CreateElement("TextLabel", {
                    Size = UDim2.new(1, -70, 0, 15),
                    Position = UDim2.fromOffset(15, 25),
                    BackgroundTransparency = 1,
                    Text = config.Desc,
                    TextColor3 = COLORS.Gray,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Toggle
                })
            end
            
            local ToggleButton = CreateElement("TextButton", {
                Size = UDim2.fromOffset(45, 25),
                Position = UDim2.new(1, -55, 0.5, -12.5),
                BackgroundColor3 = config.Value and COLORS.Orange or COLORS.GrayLight,
                BorderSizePixel = 0,
                Text = "",
                Parent = Toggle
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleButton
            })
            
            local ToggleCircle = CreateElement("Frame", {
                Size = UDim2.fromOffset(19, 19),
                Position = config.Value and UDim2.new(1, -22, 0.5, -9.5) or UDim2.fromOffset(3, 3),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
                Parent = ToggleButton
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleCircle
            })
            
            local ToggleCheck = CreateElement("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "\u{2713}",
                TextColor3 = COLORS.Orange,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                Parent = ToggleCircle
            })
            ToggleCheck.TextTransparency = config.Value and 0 or 1
            
            local toggled = config.Value or false
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = COLORS.Orange}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -22, 0.5, -9.5)}, 0.2)
                    Tween(ToggleCheck, {TextTransparency = 0}, 0.15)
                else
                    Tween(ToggleButton, {BackgroundColor3 = COLORS.GrayLight}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.fromOffset(3, 3)}, 0.2)
                    Tween(ToggleCheck, {TextTransparency = 1}, 0.15)
                end
                
                if config.Callback then
                    config.Callback(toggled)
                end
            end)
            
            ToggleButton.MouseEnter:Connect(function()
                Tween(ToggleButton, {BackgroundColor3 = toggled and COLORS.OrangeHover or COLORS.GrayBorder}, 0.2)
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                Tween(ToggleButton, {BackgroundColor3 = toggled and COLORS.Orange or COLORS.GrayLight}, 0.2)
            end)
            
            return Toggle
        end
        
        function Tab:Slider(config)
            local Slider = CreateElement("Frame", {
                Name = "Slider",
                Size = UDim2.new(1, 0, 0, config.Desc and 65 or 55),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Slider
            })
            
            CreateElement("UIStroke", {
                Color = COLORS.GrayBorder,
                Thickness = 1,
                Parent = Slider
            })
            
            local SliderLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -90, 0, 20),
                Position = UDim2.fromOffset(15, 8),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = COLORS.Black,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = Slider
            })
            
            local min = config.Value.Min or 0
            local max = config.Value.Max or 100
            local default = config.Value.Default or min
            local step = config.Step or 1
            
            local SliderValue = CreateElement("TextLabel", {
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -15, 0, 8),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = tostring(default),
                TextColor3 = COLORS.Orange,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = Slider
            })
            
            if config.Desc then
                local SliderDesc = CreateElement("TextLabel", {
                    Size = UDim2.new(1, -30, 0, 15),
                    Position = UDim2.fromOffset(15, 25),
                    BackgroundTransparency = 1,
                    Text = config.Desc,
                    TextColor3 = COLORS.Gray,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Slider
                })
            end
            
            local SliderTrack = CreateElement("Frame", {
                Size = UDim2.new(1, -30, 0, 6),
                Position = UDim2.new(0, 15, 1, -18),
                BackgroundColor3 = COLORS.GrayLight,
                BorderSizePixel = 0,
                Parent = Slider
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderTrack
            })
            
            local SliderFill = CreateElement("Frame", {
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = COLORS.Orange,
                BorderSizePixel = 0,
                Parent = SliderTrack
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderFill
            })
            
            local SliderButton = CreateElement("TextButton", {
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
                BackgroundColor3 = COLORS.Orange,
                BorderSizePixel = 0,
                Text = "",
                Parent = SliderTrack
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderButton
            })
            
            CreateElement("UIStroke", {
                Color = COLORS.White,
                Thickness = 3,
                Parent = SliderButton
            })
            
            local dragging = false
            
            local function updateSlider(input)
                local pos = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                if pos < 0 then pos = 0 elseif pos > 1 then pos = 1 end
                local value = math.floor((min + (max - min) * pos) / step + 0.5) * step
                if value < min then value = min elseif value > max then value = max end
                
                SliderValue.Text = tostring(value)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                SliderButton.Position = UDim2.new(pos, -8, 0.5, -8)
                
                if config.Callback then
                    config.Callback(value)
                end
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    updateSlider(input)
                end
            end)
            
            return Slider
        end
        
        function Tab:Dropdown(config)
            local DropdownFrame = CreateElement("Frame", {
                Name = "Dropdown",
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = DropdownFrame
            })
            
            CreateElement("UIStroke", {
                Color = COLORS.GrayBorder,
                Thickness = 1,
                Parent = DropdownFrame
            })
            
            local DropdownLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -30, 0, 20),
                Position = UDim2.fromOffset(15, 8),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = COLORS.Black,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownFrame
            })
            
            local DropdownValue = CreateElement("TextLabel", {
                Size = UDim2.new(1, -30, 0, 15),
                Position = UDim2.fromOffset(15, 25),
                BackgroundTransparency = 1,
                Text = config.Value or "Select...",
                TextColor3 = COLORS.Gray,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownFrame
            })
            
            local DropdownButton = CreateElement("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = DropdownFrame
            })
            
            local DropdownIcon = CreateElement("TextLabel", {
                Size = UDim2.fromOffset(20, 20),
                Position = UDim2.new(1, -30, 0.5, -10),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = COLORS.Gray,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                Parent = DropdownFrame
            })
            
            local DropdownList = CreateElement("Frame", {
                Size = UDim2.fromOffset(0, 0),
                Position = UDim2.fromOffset(0, 0),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 100,
                Parent = Window.ScreenGui
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = DropdownList
            })
            
            CreateElement("UIStroke", {
                Color = COLORS.GrayBorder,
                Thickness = 1,
                Parent = DropdownList
            })
            
            local DropdownScroll = CreateElement("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = COLORS.Orange,
                ScrollBarImageTransparency = 0.6,
                CanvasSize = UDim2.fromOffset(0, 0),
                Parent = DropdownList
            })
            
            local ScrollLayout = CreateElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                Parent = DropdownScroll
            })
            
            CreateElement("UIPadding", {
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5),
                PaddingLeft = UDim.new(0, 5),
                PaddingRight = UDim.new(0, 5),
                Parent = DropdownScroll
            })
            
            ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 10)
            end)
            
            local opened = false
            local dropdownCloseConn = nil
            
            local function closeDropdown()
                if not opened then return end
                opened = false
                local absSize = DropdownFrame.AbsoluteSize
                Tween(DropdownList, {Size = UDim2.fromOffset(absSize.X, 0)}, 0.2)
                Tween(DropdownIcon, {Rotation = 0}, 0.2)
                task.wait(0.2)
                DropdownList.Visible = false
                if dropdownCloseConn then
                    dropdownCloseConn:Disconnect()
                    dropdownCloseConn = nil
                end
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                opened = not opened
                
                if opened then
                    local itemCount = math.min(#config.Values, 5)
                    local listHeight = itemCount * 32 + 10
                    local absPos = DropdownFrame.AbsolutePosition
                    local absSize = DropdownFrame.AbsoluteSize
                    local listWidth = absSize.X
                    local listPosY = absPos.Y + absSize.Y + 5
                    local cam = workspace.CurrentCamera
                    local screenHeight = cam and cam.ViewportSize.Y or 1080
                    local opensUp = listPosY + listHeight > screenHeight
                    
                    if opensUp then
                        listPosY = absPos.Y - listHeight - 5
                    end
                    if listPosY < 0 then listPosY = 5 end
                    
                    DropdownList.Position = UDim2.fromOffset(absPos.X, listPosY)
                    DropdownList.Size = UDim2.fromOffset(listWidth, 0)
                    DropdownList.Visible = true
                    Tween(DropdownList, {Size = UDim2.fromOffset(listWidth, listHeight)}, 0.2)
                    Tween(DropdownIcon, {Rotation = opensUp and -180 or 180}, 0.2)
                    
                    dropdownCloseConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if not opened then return end
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            local mousePos = UserInputService:GetMouseLocation()
                            local listPos = DropdownList.AbsolutePosition
                            local listSize = DropdownList.AbsoluteSize
                            local inList = mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X
                                and mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y
                            local dropPos = DropdownFrame.AbsolutePosition
                            local dropSize = DropdownFrame.AbsoluteSize
                            local inDropdown = mousePos.X >= dropPos.X and mousePos.X <= dropPos.X + dropSize.X
                                and mousePos.Y >= dropPos.Y and mousePos.Y <= dropPos.Y + dropSize.Y
                            if not inList and not inDropdown then
                                closeDropdown()
                            end
                        end
                    end)
                else
                    closeDropdown()
                end
            end)
            
            local function AddItem(value)
                local Item = CreateElement("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = COLORS.White,
                    BorderSizePixel = 0,
                    Text = value,
                    TextColor3 = COLORS.Black,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    Parent = DropdownScroll
                })
                
                CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = Item
                })
                
                Item.MouseButton1Click:Connect(function()
                    DropdownValue.Text = value
                    if config.Callback then
                        config.Callback(value)
                    end
                    closeDropdown()
                end)
                
                Item.MouseEnter:Connect(function()
                    Tween(Item, {BackgroundColor3 = COLORS.WarmBg}, 0.1)
                end)
                
                Item.MouseLeave:Connect(function()
                    Tween(Item, {BackgroundColor3 = COLORS.White}, 0.1)
                end)
            end
            
            for _, value in ipairs(config.Values) do
                AddItem(value)
            end
            
            local DropdownObj = {}
            
            function DropdownObj:Refresh(values)
                for _, child in ipairs(DropdownScroll:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                for _, value in ipairs(values) do
                    AddItem(value)
                end
            end
            
            return DropdownObj
        end
        
        function Tab:Button(config)
            local ButtonContainer = CreateElement("Frame", {
                Name = "Button",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Parent = TabContent
            })
            
            local Button = CreateElement("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = COLORS.Orange,
                BorderSizePixel = 0,
                Text = config.Title,
                TextColor3 = COLORS.White,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                Parent = ButtonContainer
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Button
            })
            
            local ButtonScale = CreateElement("UIScale", {
                Scale = 1,
                Parent = Button
            })
            
            Button.MouseButton1Down:Connect(function()
                Tween(ButtonScale, {Scale = 0.97}, 0.1)
            end)
            
            Button.MouseButton1Up:Connect(function()
                Tween(ButtonScale, {Scale = 1}, 0.15)
            end)
            
            Button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = COLORS.OrangeHover}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = COLORS.Orange}, 0.2)
                Tween(ButtonScale, {Scale = 1}, 0.15)
            end)
            
            return ButtonContainer
        end
        
        function Tab:Input(config)
            local Input = CreateElement("Frame", {
                Name = "Input",
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Input
            })
            
            local InputStroke = CreateElement("UIStroke", {
                Color = COLORS.GrayBorder,
                Thickness = 1,
                Parent = Input
            })
            
            local InputLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -30, 0, 20),
                Position = UDim2.fromOffset(15, 5),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = COLORS.Black,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Input
            })
            
            local InputBox = CreateElement("TextBox", {
                Size = UDim2.new(1, -30, 0, 20),
                Position = UDim2.fromOffset(15, 22),
                BackgroundTransparency = 1,
                Text = "",
                PlaceholderText = config.Placeholder or "Enter text...",
                TextColor3 = COLORS.Black,
                PlaceholderColor3 = COLORS.Gray,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = Input
            })
            
            InputBox.Focused:Connect(function()
                InputStroke.Color = COLORS.Orange
            end)
            
            InputBox.FocusLost:Connect(function(enterPressed)
                InputStroke.Color = COLORS.GrayBorder
                if enterPressed and config.Callback then
                    config.Callback(InputBox.Text)
                    InputBox.Text = ""
                end
            end)
            
            return Input
        end
        
        function Tab:Colorpicker(config)
            local Colorpicker = CreateElement("Frame", {
                Name = "Colorpicker",
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Colorpicker
            })
            
            CreateElement("UIStroke", {
                Color = COLORS.GrayBorder,
                Thickness = 1,
                Parent = Colorpicker
            })
            
            local ColorLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.fromOffset(15, 0),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = COLORS.Black,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Colorpicker
            })
            
            local currentColor = config.Value or COLORS.Orange
            
            local ColorPreview = CreateElement("TextButton", {
                Size = UDim2.fromOffset(35, 25),
                Position = UDim2.new(1, -45, 0.5, -12.5),
                BackgroundColor3 = currentColor,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = Colorpicker
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = ColorPreview
            })
            
            CreateElement("UIStroke", {
                Color = COLORS.GrayBorder,
                Thickness = 2,
                Parent = ColorPreview
            })
            
            local PaletteOpen = false
            local PaletteFrame
            
            local paletteColors = {
                COLORS.Orange,
                Color3.fromRGB(255, 0, 0),
                Color3.fromRGB(0, 255, 0),
                Color3.fromRGB(0, 0, 255),
                Color3.fromRGB(255, 255, 0),
                Color3.fromRGB(255, 0, 255),
                Color3.fromRGB(0, 255, 255),
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(0, 0, 0),
                Color3.fromRGB(128, 128, 128),
                Color3.fromRGB(255, 165, 0),
                Color3.fromRGB(128, 0, 128),
                Color3.fromRGB(255, 192, 203),
                Color3.fromRGB(165, 42, 42),
                Color3.fromRGB(0, 128, 0),
                Color3.fromRGB(0, 0, 128),
                Color3.fromRGB(255, 215, 0),
                Color3.fromRGB(64, 224, 208),
            }
            
            local paletteCloseConn = nil
            
            local function closePalette()
                if PaletteFrame then
                    PaletteFrame:Destroy()
                    PaletteFrame = nil
                end
                PaletteOpen = false
                if paletteCloseConn then
                    paletteCloseConn:Disconnect()
                    paletteCloseConn = nil
                end
            end
            
            ColorPreview.MouseButton1Click:Connect(function()
                if PaletteOpen and PaletteFrame then
                    closePalette()
                    return
                end
                
                local absPos = Colorpicker.AbsolutePosition
                local absSize = Colorpicker.AbsoluteSize
                local paletteW = 200
                local paletteH = 110
                local paletteX = absPos.X + absSize.X - paletteW
                local paletteY = absPos.Y + absSize.Y + 5
                local cam = workspace.CurrentCamera
                local vpSize = cam and cam.ViewportSize or Vector2.new(1920, 1080)
                
                if paletteX < 5 then paletteX = 5 end
                if paletteX + paletteW > vpSize.X - 5 then paletteX = vpSize.X - paletteW - 5 end
                if paletteY + paletteH > vpSize.Y - 5 then paletteY = absPos.Y - paletteH - 5 end
                if paletteY < 5 then paletteY = 5 end
                
                PaletteFrame = CreateElement("Frame", {
                    Size = UDim2.fromOffset(paletteW, paletteH),
                    Position = UDim2.fromOffset(paletteX, paletteY),
                    BackgroundColor3 = COLORS.White,
                    BorderSizePixel = 0,
                    ZIndex = 100,
                    Parent = Window.ScreenGui
                })
                
                CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = PaletteFrame
                })
                
                CreateElement("UIStroke", {
                    Color = COLORS.GrayBorder,
                    Thickness = 1,
                    Parent = PaletteFrame
                })
                
                local Grid = CreateElement("Frame", {
                    Size = UDim2.new(1, -10, 1, -10),
                    Position = UDim2.fromOffset(5, 5),
                    BackgroundTransparency = 1,
                    ZIndex = 50,
                    Parent = PaletteFrame
                })
                
                CreateElement("UIGridLayout", {
                    CellSize = UDim2.fromOffset(28, 28),
                    CellPadding = UDim2.fromOffset(4, 4),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Parent = Grid
                })
                
                for _, color in ipairs(paletteColors) do
                    local Swatch = CreateElement("TextButton", {
                        Size = UDim2.fromOffset(28, 28),
                        BackgroundColor3 = color,
                        BorderSizePixel = 0,
                        Text = "",
                        ZIndex = 50,
                        Parent = Grid
                    })
                    
                    CreateElement("UICorner", {
                        CornerRadius = UDim.new(0, 4),
                        Parent = Swatch
                    })
                    
                    Swatch.MouseButton1Click:Connect(function()
                        currentColor = color
                        ColorPreview.BackgroundColor3 = currentColor
                        if config.Callback then
                            config.Callback(currentColor)
                        end
                        closePalette()
                    end)
                end
                
                paletteCloseConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not PaletteOpen then return end
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        local mousePos = UserInputService:GetMouseLocation()
                        local palPos = PaletteFrame.AbsolutePosition
                        local palSize = PaletteFrame.AbsoluteSize
                        local inPalette = mousePos.X >= palPos.X and mousePos.X <= palPos.X + palSize.X
                            and mousePos.Y >= palPos.Y and mousePos.Y <= palPos.Y + palSize.Y
                        local cpPos = Colorpicker.AbsolutePosition
                        local cpSize = Colorpicker.AbsoluteSize
                        local inPreview = mousePos.X >= cpPos.X and mousePos.X <= cpPos.X + cpSize.X
                            and mousePos.Y >= cpPos.Y and mousePos.Y <= cpPos.Y + cpSize.Y
                        if not inPalette and not inPreview then
                            closePalette()
                        end
                    end
                end)
                
                PaletteOpen = true
            end)
            
            return Colorpicker
        end
        
        function Tab:Keybind(config)
            local Keybind = CreateElement("Frame", {
                Name = "Keybind",
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Keybind
            })
            
            CreateElement("UIStroke", {
                Color = COLORS.GrayBorder,
                Thickness = 1,
                Parent = Keybind
            })
            
            local KeybindLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, -120, 1, 0),
                Position = UDim2.fromOffset(15, 0),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = COLORS.Black,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Keybind
            })
            
            local KeybindButton = CreateElement("TextButton", {
                Size = UDim2.fromOffset(90, 30),
                Position = UDim2.new(1, -100, 0.5, -15),
                BackgroundColor3 = COLORS.GrayLight,
                BorderSizePixel = 0,
                Text = config.Value or "None",
                TextColor3 = COLORS.Black,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                Parent = Keybind
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = KeybindButton
            })
            
            local binding = false
            local bindConnection
            
            local function getKeyDisplay(value)
                if typeof(value) == "EnumItem" then
                    return value.Name
                elseif typeof(value) == "string" then
                    return value
                end
                return "None"
            end
            
            KeybindButton.MouseButton1Click:Connect(function()
                if binding then
                    binding = false
                    KeybindButton.Text = getKeyDisplay(config.Value)
                    Tween(KeybindButton, {BackgroundColor3 = COLORS.GrayLight}, 0.2)
                    if bindConnection then
                        bindConnection:Disconnect()
                        bindConnection = nil
                    end
                    return
                end
                
                binding = true
                KeybindButton.Text = "..."
                Tween(KeybindButton, {BackgroundColor3 = COLORS.Orange}, 0.2)
                
                bindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not binding then return end
                    if gameProcessed then return end
                    
                    if input.KeyCode == Enum.KeyCode.Escape then
                        binding = false
                        KeybindButton.Text = getKeyDisplay(config.Value)
                        Tween(KeybindButton, {BackgroundColor3 = COLORS.GrayLight}, 0.2)
                        if bindConnection then
                            bindConnection:Disconnect()
                            bindConnection = nil
                        end
                        return
                    end
                    
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        local keyName = input.KeyCode.Name
                        config.Value = input.KeyCode
                        KeybindButton.Text = keyName
                        binding = false
                        Tween(KeybindButton, {BackgroundColor3 = COLORS.GrayLight}, 0.2)
                        if bindConnection then
                            bindConnection:Disconnect()
                            bindConnection = nil
                        end
                        
                        if config.Callback then
                            config.Callback(input.KeyCode)
                        end
                    end
                end)
            end)
            
            return Keybind
        end
        
        return Tab
    end
    
    function Window:Toggle()
        Window.Visible = not Window.Visible
        if Window.Visible then
            MainFrame.Visible = true
            MainFrame.BackgroundTransparency = 1
            Scale.Scale = 0.95
            Tween(MainFrame, {BackgroundTransparency = 0}, 0.2)
            Tween(Scale, {Scale = 1}, 0.25)
        else
            Tween(MainFrame, {BackgroundTransparency = 1}, 0.2)
            Tween(Scale, {Scale = 0.95}, 0.2)
            task.delay(0.25, function()
                if not Window.Visible then
                    MainFrame.Visible = false
                end
            end)
        end
    end
    
    local toggleKeyConnection = nil
    
    function Window:SetToggleKey(key)
        if toggleKeyConnection then
            toggleKeyConnection:Disconnect()
            toggleKeyConnection = nil
        end
        toggleKeyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == key then
                Window:Toggle()
            end
        end)
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    function Window:Notify(config)
        Window.NotifQueue = Window.NotifQueue or {}
        
        local Notification = CreateElement("Frame", {
            Size = UDim2.fromOffset(300, 0),
            Position = UDim2.new(1, -320, 1, 120),
            BackgroundColor3 = COLORS.White,
            BorderSizePixel = 0,
            Parent = ScreenGui
        })
        
        CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = Notification
        })
        
        CreateElement("UIStroke", {
            Color = COLORS.Orange,
            Thickness = 2,
            Parent = Notification
        })
        
        local NotifTitle = CreateElement("TextLabel", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.fromOffset(10, 10),
            BackgroundTransparency = 1,
            Text = config.Title or "Notification",
            TextColor3 = COLORS.Black,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Notification
        })
        
        local NotifContent = CreateElement("TextLabel", {
            Size = UDim2.new(1, -20, 0, 0),
            Position = UDim2.fromOffset(10, 32),
            BackgroundTransparency = 1,
            Text = config.Content or "",
            TextColor3 = COLORS.Gray,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = Notification
        })
        
        local textBounds = game:GetService("TextService"):GetTextSize(
            config.Content or "",
            12,
            Enum.Font.Gotham,
            Vector2.new(280, math.huge)
        )
        
        local notifHeight = 50 + textBounds.Y
        NotifContent.Size = UDim2.new(1, -20, 0, textBounds.Y)
        Notification.Size = UDim2.fromOffset(300, notifHeight)
        
        local function updatePositions()
            local offset = 0
            for _, notif in ipairs(Window.NotifQueue) do
                if notif.Frame and notif.Frame.Parent then
                    Tween(notif.Frame, {Position = UDim2.new(1, -320, 1, -notif.Height - 20 - offset)}, 0.25)
                    offset = offset + notif.Height + 12
                end
            end
        end
        
        local notifObj = {Frame = Notification, Height = notifHeight}
        table.insert(Window.NotifQueue, 1, notifObj)
        updatePositions()
        
        task.delay(config.Duration or 3, function()
            if Notification and Notification.Parent then
                Tween(Notification, {Position = UDim2.new(1, -320, 1, 20)}, 0.3)
                task.wait(0.35)
                if Notification and Notification.Parent then
                    Notification:Destroy()
                end
            end
            for i, v in ipairs(Window.NotifQueue) do
                if v == notifObj then
                    table.remove(Window.NotifQueue, i)
                    break
                end
            end
            updatePositions()
        end)
    end
    
    Window:SetToggleKey(Enum.KeyCode.RightShift)
    
    return Window
end

return MonarchUI
