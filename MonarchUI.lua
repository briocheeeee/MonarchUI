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
    Shadow = Color3.fromRGB(0, 0, 0),
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
    
    local MainFrame = CreateElement("Frame", {
        Name = "Main",
        Size = config.Size or UDim2.fromOffset(620, 500),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    local Shadow = CreateElement("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.fromOffset(-20, -20),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = COLORS.Shadow,
        ImageTransparency = 0.9,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = 0,
        Parent = MainFrame
    })
    
    CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = MainFrame
    })
    
    local TopBar = CreateElement("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = COLORS.WarmBg,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = TopBar
    })
    
    local BottomCover = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = COLORS.WarmBg,
        BorderSizePixel = 0,
        Parent = TopBar
    })
    
    local Title = CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.fromOffset(20, 0),
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
        Size = UDim2.fromOffset(40, 40),
        Position = UDim2.new(1, -50, 0.5, -20),
        BackgroundColor3 = COLORS.GrayLight,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = COLORS.Gray,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = TopBar
    })
    
    CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = CloseButton
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        Window:Toggle()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = COLORS.Error}, 0.2)
        Tween(CloseButton, {TextColor3 = COLORS.White}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = COLORS.GrayLight}, 0.2)
        Tween(CloseButton, {TextColor3 = COLORS.Gray}, 0.2)
    end)
    
    local TabBar = CreateElement("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, 180, 1, -60),
        Position = UDim2.fromOffset(0, 60),
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
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = COLORS.Orange,
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
        Size = UDim2.new(1, -190, 1, -70),
        Position = UDim2.fromOffset(185, 65),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local dragging = false
    local dragInput, mousePos, framePos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(MainFrame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1, Enum.EasingStyle.Linear)
        end
    end)
    
    function Window:Tab(config)
        local Tab = {}
        Tab.Elements = {}
        Tab.Sections = {}
        
        local TabButton = CreateElement("TextButton", {
            Name = config.Title,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = COLORS.White,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = TabList
        })
        
        CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = TabButton
        })
        
        local TabIcon = CreateElement("TextLabel", {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.fromOffset(12, 10),
            BackgroundTransparency = 1,
            Text = "•",
            TextColor3 = COLORS.Gray,
            TextSize = 20,
            Font = Enum.Font.GothamBold,
            Parent = TabButton
        })
        
        local TabLabel = CreateElement("TextLabel", {
            Size = UDim2.new(1, -45, 1, 0),
            Position = UDim2.fromOffset(40, 0),
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
            ScrollBarThickness = 6,
            ScrollBarImageColor3 = COLORS.Orange,
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
                if tab.Icon and typeof(tab.Icon) == "Instance" then
                    Tween(tab.Icon, {TextColor3 = COLORS.Gray}, 0.2)
                end
            end
            if TabContent and typeof(TabContent) == "Instance" then
                TabContent.Visible = true
            end
            Tween(TabButton, {BackgroundColor3 = COLORS.Orange}, 0.2)
            Tween(TabLabel, {TextColor3 = COLORS.White}, 0.2)
            Tween(TabIcon, {TextColor3 = COLORS.White}, 0.2)
            Window.CurrentTab = Tab
        end

        TabButton.MouseButton1Click:Connect(ActivateTab)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = COLORS.GrayLight}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = COLORS.White}, 0.2)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Label = TabLabel
        Tab.Icon = TabIcon
        Tab.Content = TabContent
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            ActivateTab()
        end
        
        function Tab:Section(config)
            local Section = CreateElement("Frame", {
                Name = "Section",
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                Parent = TabContent
            })
            
            local SectionLabel = CreateElement("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = COLORS.Black,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section
            })
            
            CreateElement("UIPadding", {
                PaddingLeft = UDim.new(0, 5),
                Parent = SectionLabel
            })
            
            local Divider = CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, 2),
                Position = UDim2.new(0, 0, 1, -2),
                BackgroundColor3 = COLORS.GrayBorder,
                BorderSizePixel = 0,
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
            
            local toggled = config.Value or false
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = COLORS.Orange}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -22, 0.5, -9.5)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = COLORS.GrayLight}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.fromOffset(3, 3)}, 0.2)
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
                Size = UDim2.new(0.6, 0, 0, 20),
                Position = UDim2.fromOffset(15, 8),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = COLORS.Black,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Slider
            })
            
            local min = config.Value.Min or 0
            local max = config.Value.Max or 100
            local default = config.Value.Default or min
            local step = config.Step or 1
            
            local SliderValue = CreateElement("TextLabel", {
                Size = UDim2.new(0.3, 0, 0, 20),
                Position = UDim2.new(1, -15, 0, 8),
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
                local pos = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                local value = math.floor((min + (max - min) * pos) / step + 0.5) * step
                value = math.clamp(value, min, max)
                
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                Tween(SliderButton, {Position = UDim2.new(pos, -8, 0.5, -8)}, 0.1)
                
                if config.Callback then
                    config.Callback(value)
                end
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateSlider(input)
                end
            end)
            
            return Slider
        end
        
        function Tab:Dropdown(config)
            local Dropdown = CreateElement("Frame", {
                Name = "Dropdown",
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Dropdown
            })
            
            CreateElement("UIStroke", {
                Color = COLORS.GrayBorder,
                Thickness = 1,
                Parent = Dropdown
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
                Parent = Dropdown
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
                Parent = Dropdown
            })
            
            local DropdownButton = CreateElement("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = Dropdown
            })
            
            local DropdownIcon = CreateElement("TextLabel", {
                Size = UDim2.fromOffset(20, 20),
                Position = UDim2.new(1, -30, 0.5, -10),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = COLORS.Gray,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                Parent = Dropdown
            })
            
            local DropdownList = CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 5),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 10,
                Parent = Dropdown
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
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = COLORS.Orange,
                CanvasSize = UDim2.fromOffset(0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Parent = DropdownList
            })
            
            CreateElement("UIListLayout", {
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
            
            local opened = false
            
            DropdownButton.MouseButton1Click:Connect(function()
                opened = not opened
                
                if opened then
                    DropdownList.Visible = true
                    local itemCount = math.min(#config.Values, 5)
                    Tween(DropdownList, {Size = UDim2.new(1, 0, 0, itemCount * 32 + 10)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 180}, 0.2)
                else
                    Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 0}, 0.2)
                    task.wait(0.2)
                    DropdownList.Visible = false
                end
            end)
            
            for _, value in ipairs(config.Values) do
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
                    opened = false
                    Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 0}, 0.2)
                    task.wait(0.2)
                    DropdownList.Visible = false
                    
                    if config.Callback then
                        config.Callback(value)
                    end
                end)
                
                Item.MouseEnter:Connect(function()
                    Tween(Item, {BackgroundColor3 = COLORS.WarmBg}, 0.1)
                end)
                
                Item.MouseLeave:Connect(function()
                    Tween(Item, {BackgroundColor3 = COLORS.White}, 0.1)
                end)
            end
            
            function Dropdown:Refresh(values)
                for _, child in ipairs(DropdownScroll:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                for _, value in ipairs(values) do
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
                        opened = false
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        Tween(DropdownIcon, {Rotation = 0}, 0.2)
                        task.wait(0.2)
                        DropdownList.Visible = false
                        
                        if config.Callback then
                            config.Callback(value)
                        end
                    end)
                    
                    Item.MouseEnter:Connect(function()
                        Tween(Item, {BackgroundColor3 = COLORS.WarmBg}, 0.1)
                    end)
                    
                    Item.MouseLeave:Connect(function()
                        Tween(Item, {BackgroundColor3 = COLORS.White}, 0.1)
                    end)
                end
            end
            
            return Dropdown
        end
        
        function Tab:Button(config)
            local Button = CreateElement("TextButton", {
                Name = "Button",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = COLORS.Orange,
                BorderSizePixel = 0,
                Text = config.Title,
                TextColor3 = COLORS.White,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                Parent = TabContent
            })
            
            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Button
            })
            
            Button.MouseButton1Click:Connect(function()
                Tween(Button, {BackgroundColor3 = COLORS.OrangeHover}, 0.1)
                task.wait(0.1)
                Tween(Button, {BackgroundColor3 = COLORS.Orange}, 0.1)
                
                if config.Callback then
                    config.Callback()
                end
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = COLORS.OrangeHover}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = COLORS.Orange}, 0.2)
            end)
            
            return Button
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
            
            CreateElement("UIStroke", {
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
            
            InputBox.FocusLost:Connect(function(enterPressed)
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
            
            local ColorPreview = CreateElement("Frame", {
                Size = UDim2.fromOffset(35, 25),
                Position = UDim2.new(1, -45, 0.5, -12.5),
                BackgroundColor3 = config.Value or COLORS.Orange,
                BorderSizePixel = 0,
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
            
            KeybindButton.MouseButton1Click:Connect(function()
                binding = true
                KeybindButton.Text = "..."
                Tween(KeybindButton, {BackgroundColor3 = COLORS.Orange}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if binding and not gameProcessed then
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        local keyName = input.KeyCode.Name
                        KeybindButton.Text = keyName
                        binding = false
                        Tween(KeybindButton, {BackgroundColor3 = COLORS.GrayLight}, 0.2)
                        
                        if config.Callback then
                            config.Callback(keyName)
                        end
                    end
                end
            end)
            
            return Keybind
        end
        
        return Tab
    end
    
    function Window:Toggle()
        Window.Visible = not Window.Visible
        MainFrame.Visible = Window.Visible
    end
    
    function Window:SetToggleKey(key)
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == key then
                Window:Toggle()
            end
        end)
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    function Window:Notify(config)
        local Notification = CreateElement("Frame", {
            Size = UDim2.fromOffset(300, 0),
            Position = UDim2.new(1, -320, 1, -20),
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
        Notification.Position = UDim2.new(1, -320, 1, 20)
        
        Tween(Notification, {Position = UDim2.new(1, -320, 1, -notifHeight - 20)}, 0.3, Enum.EasingStyle.Back)
        
        task.wait(config.Duration or 3)
        
        Tween(Notification, {Position = UDim2.new(1, -320, 1, 20)}, 0.3)
        task.wait(0.3)
        Notification:Destroy()
    end
    
    Window:SetToggleKey(Enum.KeyCode.RightShift)
    
    return Window
end

return MonarchUI
