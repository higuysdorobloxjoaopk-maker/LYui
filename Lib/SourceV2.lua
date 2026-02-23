local LYui = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

function LYui:CreateWindow(titleText)
    local Window = {}
    local PlayerGui = Player:WaitForChild("PlayerGui")
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui.Name == "LYui_Interface_" .. titleText then
            gui:Destroy()
        end
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LYui_Interface_" .. titleText
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 220, 0, 140)
    MainFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 20)
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 25)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 58, 95)
    TopBar.BorderSizePixel = 0
    TopBar.Active = true
    TopBar.Parent = MainFrame
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 28, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText or "LYui Window"
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextSize = 14
    Title.Font = Enum.Font.SourceSans
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    local CollapseBtn = Instance.new("TextButton")
    CollapseBtn.Size = UDim2.new(0,25,0,25)
    CollapseBtn.BackgroundTransparency = 1
    CollapseBtn.Text = "▼"
    CollapseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    CollapseBtn.TextSize = 10
    CollapseBtn.Parent = TopBar
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,25,0,25)
    CloseBtn.Position = UDim2.new(1,-25,0,0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    CloseBtn.TextSize = 14
    CloseBtn.Parent = TopBar
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1,0,1,-25)
    ContentFrame.Position = UDim2.new(0,0,0,25)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 2
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(35,58,95)
    ContentFrame.CanvasSize = UDim2.new(0,0,0,0)
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.Parent = MainFrame
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = ContentFrame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0,10)
    UIPadding.PaddingTop = UDim.new(0,10)
    UIPadding.Parent = ContentFrame
    local ResizeHandle = Instance.new("Frame")
    ResizeHandle.Size = UDim2.new(0,16,0,16)
    ResizeHandle.Position = UDim2.new(1,-16,1,-16)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Active = true
    ResizeHandle.Parent = MainFrame
    local Triangle = Instance.new("TextLabel")
    Triangle.Size = UDim2.new(1,0,1,0)
    Triangle.BackgroundTransparency = 1
    Triangle.Text = "◢"
    Triangle.TextColor3 = Color3.fromRGB(35,58,95)
    Triangle.TextSize = 19
    Triangle.Font = Enum.Font.Arial
    Triangle.TextXAlignment = Enum.TextXAlignment.Right
    Triangle.TextYAlignment = Enum.TextYAlignment.Bottom
    Triangle.Position = UDim2.new(0,0,0,3)
    Triangle.Parent = ResizeHandle
    local function adjustLayout()
        local w = MainFrame.Size.X.Offset
        local cols = 1
        if w >= 500 then
            cols = 3
        end
        layout.FillDirection = (cols > 1) and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
        local areas = {}
        for _, child in ipairs(ContentFrame:GetChildren()) do
            if child.Name == "AreaFrame" then
                table.insert(areas, child)
            end
        end
        local contentW = ContentFrame.AbsoluteSize.X
        local leftPad = 10
        local rightPad = 10
        local availW = contentW - leftPad - rightPad
        local itemPad = layout.Padding.Offset
        if cols > 1 then
            local totalPad = (cols - 1) * itemPad
            local itemW = (availW - totalPad) / cols
            for _, area in ipairs(areas) do
                area.Size = UDim2.new(0, itemW, 0, area.Size.Y.Offset)
            end
        else
            for _, area in ipairs(areas) do
                area.Size = UDim2.new(1, -leftPad - rightPad, 0, area.Size.Y.Offset)
            end
        end
    end
    MainFrame:GetPropertyChangedSignal("Size"):Connect(adjustLayout)
    ContentFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(adjustLayout)
    local dragging = false
    local dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    local resizing = false
    local resizeStart, startSize
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = MainFrame.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newWidth = math.max(70, startSize.X.Offset + delta.X)
            local newHeight = math.max(50, startSize.Y.Offset + delta.Y)
            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            resizing = false
        end
    end)
    local isCollapsed = false
    local originalY = MainFrame.Size.Y.Offset
    CollapseBtn.MouseButton1Click:Connect(function()
        isCollapsed = not isCollapsed
        if isCollapsed then
            originalY = MainFrame.Size.Y.Offset
            MainFrame:TweenSize(UDim2.new(0, MainFrame.Size.X.Offset, 0, 25), "Out", "Quad", 0.2, true)
            ContentFrame.Visible = false
            ResizeHandle.Visible = false
            CollapseBtn.Text = "►"
        else
            MainFrame:TweenSize(UDim2.new(0, MainFrame.Size.X.Offset, 0, originalY), "Out", "Quad", 0.2, true)
            ContentFrame.Visible = true
            ResizeHandle.Visible = true
            CollapseBtn.Text = "▼"
        end
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    Window.Elements = {}
    local function registerElement(id, data)
        if id then
            Window.Elements[id] = data
        end
    end
    function Window:CreateBanner(imageId, title, description, discordCallback, id)
        local BannerFrame = Instance.new("Frame")
        BannerFrame.Size = UDim2.new(1,-20,0,110)
        BannerFrame.BackgroundColor3 = Color3.fromRGB(20,25,30)
        BannerFrame.BorderSizePixel = 0
        BannerFrame.Parent = ContentFrame
        local Image = Instance.new("ImageLabel")
        Image.Size = UDim2.new(0,80,0,80)
        Image.Position = UDim2.new(0,10,0,15)
        Image.BackgroundTransparency = 1
        Image.Image = "rbxassetid://" .. (imageId or "0")
        Image.Parent = BannerFrame
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1,-110,0,25)
        TitleLabel.Position = UDim2.new(0,100,0,15)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title or ""
        TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
        TitleLabel.TextSize = 16
        TitleLabel.Font = Enum.Font.SourceSansBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = BannerFrame
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1,-110,0,45)
        DescLabel.Position = UDim2.new(0,100,0,42)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = description or ""
        DescLabel.TextColor3 = Color3.fromRGB(200,200,200)
        DescLabel.TextSize = 13
        DescLabel.Font = Enum.Font.SourceSans
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.TextWrapped = true
        DescLabel.Parent = BannerFrame
        local DiscordBtn = Instance.new("TextButton")
        DiscordBtn.Size = UDim2.new(0,80,0,25)
        DiscordBtn.Position = UDim2.new(1,-90,1,-35)
        DiscordBtn.BackgroundColor3 = Color3.fromRGB(35,58,95)
        DiscordBtn.Text = "Discord"
        DiscordBtn.TextColor3 = Color3.fromRGB(255,255,255)
        DiscordBtn.TextSize = 14
        DiscordBtn.Font = Enum.Font.SourceSans
        DiscordBtn.Parent = BannerFrame
        DiscordBtn.MouseButton1Click:Connect(function()
            if discordCallback then
                if typeof(discordCallback) == "string" then
                    setclipboard(discordCallback)
                else
                    discordCallback()
                end
            end
        end)
        registerElement(id, {type = "banner", image = Image, titleLabel = TitleLabel, descLabel = DescLabel})
    end
    function Window:CreateArea(areaName, id)
        local Area = {}
        local AreaFrame = Instance.new("Frame")
        AreaFrame.Name = "AreaFrame"
        AreaFrame.BackgroundColor3 = Color3.fromRGB(20,25,30)
        AreaFrame.BorderSizePixel = 0
        AreaFrame.Parent = ContentFrame
        local Header = Instance.new("Frame")
        Header.Size = UDim2.new(1,0,0,20)
        Header.BackgroundColor3 = Color3.fromRGB(35,58,95)
        Header.Parent = AreaFrame
        local AreaTitle = Instance.new("TextLabel")
        AreaTitle.Size = UDim2.new(1,-25,1,0)
        AreaTitle.Position = UDim2.new(0,5,0,0)
        AreaTitle.BackgroundTransparency = 1
        AreaTitle.Text = areaName
        AreaTitle.TextColor3 = Color3.fromRGB(255,255,255)
        AreaTitle.TextSize = 14
        AreaTitle.Font = Enum.Font.SourceSans
        AreaTitle.TextXAlignment = Enum.TextXAlignment.Left
        AreaTitle.Parent = Header
        local MinBtn = Instance.new("TextButton")
        MinBtn.Size = UDim2.new(0,20,1,0)
        MinBtn.Position = UDim2.new(1,-20,0,0)
        MinBtn.BackgroundTransparency = 1
        MinBtn.Text = "▼"
        MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
        MinBtn.TextSize = 10
        MinBtn.Parent = Header
        local AreaContent = Instance.new("Frame")
        AreaContent.Size = UDim2.new(1,0,1,-20)
        AreaContent.Position = UDim2.new(0,0,0,20)
        AreaContent.BackgroundTransparency = 1
        AreaContent.Parent = AreaFrame
        local AreaList = Instance.new("UIListLayout")
        AreaList.Padding = UDim.new(0,5)
        AreaList.SortOrder = Enum.SortOrder.LayoutOrder
        AreaList.Parent = AreaContent
        local AreaPadding = Instance.new("UIPadding")
        AreaPadding.PaddingLeft = UDim.new(0,5)
        AreaPadding.PaddingTop = UDim.new(0,5)
        AreaPadding.Parent = AreaContent
        local isMin = false
        local origH = 0
        local function updateHeight()
            local contentH = AreaList.AbsoluteContentSize.Y + AreaPadding.PaddingTop.Offset + AreaPadding.PaddingBottom.Offset
            AreaContent.Size = UDim2.new(1, 0, 0, contentH)
            if not isMin then
                AreaFrame.Size = UDim2.new(AreaFrame.Size.X.Scale, AreaFrame.Size.X.Offset, 0, 20 + contentH)
            end
            adjustLayout()
        end
        AreaList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateHeight)
        updateHeight()
        MinBtn.MouseButton1Click:Connect(function()
            isMin = not isMin
            if isMin then
                origH = AreaFrame.Size.Y.Offset
                AreaFrame:TweenSize(UDim2.new(AreaFrame.Size.X.Scale, AreaFrame.Size.X.Offset, 0, 20), "Out", "Quad", 0.2, true)
                AreaContent.Visible = false
                MinBtn.Text = "►"
            else
                AreaFrame:TweenSize(UDim2.new(AreaFrame.Size.X.Scale, AreaFrame.Size.X.Offset, 0, origH), "Out", "Quad", 0.2, true)
                AreaContent.Visible = true
                MinBtn.Text = "▼"
            end
        end)
        function Area:CreateLabel(text, id)
            local InfoLabel = Instance.new("TextLabel")
            InfoLabel.Size = UDim2.new(1,-10,0,15)
            InfoLabel.BackgroundTransparency = 1
            InfoLabel.Text = text
            InfoLabel.TextColor3 = Color3.fromRGB(200,200,200)
            InfoLabel.TextSize = 14
            InfoLabel.Font = Enum.Font.Code
            InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
            InfoLabel.Parent = AreaContent
            registerElement(id, {type = "label", label = InfoLabel})
            return InfoLabel
        end
        function Area:CreateToggle(toggleText, callback, id)
            local ToggleContainer = Instance.new("Frame")
            ToggleContainer.Size = UDim2.new(1,-10,0,20)
            ToggleContainer.BackgroundTransparency = 1
            ToggleContainer.Parent = AreaContent
            local ToggleBox = Instance.new("Frame")
            ToggleBox.Size = UDim2.new(0,18,0,18)
            ToggleBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
            ToggleBox.BorderColor3 = Color3.fromRGB(40,50,70)
            ToggleBox.BorderSizePixel = 2
            ToggleBox.Parent = ToggleContainer
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1,0)
            UICorner.Parent = ToggleBox
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(1,0,1,0)
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleBox
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1,-25,1,0)
            ToggleLabel.Position = UDim2.new(0,25,0,0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = Color3.fromRGB(200,200,200)
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Code
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleContainer
            local toggled = false
            registerElement(id, {type = "toggle", toggled = toggled, callback = callback, toggleBox = ToggleBox, label = ToggleLabel})
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                local elem = Window.Elements[id]
                if elem then elem.toggled = toggled end
                if toggled then
                    ToggleBox.BackgroundColor3 = Color3.fromRGB(120,190,255)
                    ToggleBox.BorderColor3 = Color3.fromRGB(35,58,95)
                else
                    ToggleBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
                    ToggleBox.BorderColor3 = Color3.fromRGB(40,50,70)
                end
                if callback then callback(toggled) end
            end)
        end
        function Area:CreateButton(text, callback, id)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1,-10,0,30)
            Btn.BackgroundColor3 = Color3.fromRGB(35,58,95)
            Btn.BorderSizePixel = 0
            Btn.Text = text or "Button"
            Btn.TextColor3 = Color3.fromRGB(255,255,255)
            Btn.TextSize = 14
            Btn.Font = Enum.Font.SourceSans
            Btn.Parent = AreaContent
            registerElement(id, {type = "button", button = Btn, callback = callback})
            Btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end
        function Area:CreateSlider(min, max, default, callback, id)
            local minV = min or 0
            local maxV = max or 100
            local value = math.clamp(default or minV, minV, maxV)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1,-10,0,40)
            Container.BackgroundTransparency = 1
            Container.Parent = AreaContent
            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(1,0,0,8)
            Bar.Position = UDim2.new(0,0,0,22)
            Bar.BackgroundColor3 = Color3.fromRGB(40,50,70)
            Bar.Parent = Container
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1,0)
            BarCorner.Parent = Bar
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((value - minV) / (maxV - minV), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(35,58,95)
            Fill.Parent = Bar
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1,0)
            FillCorner.Parent = Fill
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0,16,0,16)
            Knob.Position = UDim2.new((value - minV) / (maxV - minV), -8, 0.5, -8)
            Knob.BackgroundColor3 = Color3.fromRGB(120,190,255)
            Knob.Parent = Bar
            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1,0)
            KnobCorner.Parent = Knob
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0,50,0,15)
            ValueLabel.Position = UDim2.new(1,-50,0,0)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(math.floor(value))
            ValueLabel.TextColor3 = Color3.fromRGB(200,200,200)
            ValueLabel.TextSize = 13
            ValueLabel.Font = Enum.Font.Code
            ValueLabel.Parent = Container
            local dragging = false
            local function updateSlider(x)
                local rel = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                value = minV + (maxV - minV) * rel
                Fill.Size = UDim2.new(rel, 0, 1, 0)
                Knob.Position = UDim2.new(rel, -8, 0.5, -8)
                ValueLabel.Text = tostring(math.floor(value + 0.5))
                if callback then callback(value) end
            end
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            registerElement(id, {type = "slider", min = minV, max = maxV, value = value, callback = callback, fill = Fill, knob = Knob, valueLabel = ValueLabel})
        end
        function Area:CreateDropdown(title, options, callback, multi, id)
            local isMulti = multi == true
            local isPlayers = options == "Players"
            local opts = isPlayers and {} or (options or {})
            if isPlayers then
                for _, plr in ipairs(Players:GetPlayers()) do
                    table.insert(opts, plr.Name)
                end
            end
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1,-10,0,30)
            Container.BackgroundTransparency = 1
            Container.Parent = AreaContent
            local SelectedLabel = Instance.new("TextButton")
            SelectedLabel.Size = UDim2.new(1,0,1,0)
            SelectedLabel.BackgroundColor3 = Color3.fromRGB(25,35,50)
            SelectedLabel.Text = title .. ": " .. (isMulti and "..." or (opts[1] or ""))
            SelectedLabel.TextColor3 = Color3.fromRGB(200,200,200)
            SelectedLabel.TextSize = 14
            SelectedLabel.Font = Enum.Font.Code
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
            SelectedLabel.Parent = Container
            local ListFrame = Instance.new("Frame")
            ListFrame.Size = UDim2.new(1,0,0,0)
            ListFrame.Position = UDim2.new(0,0,1,5)
            ListFrame.BackgroundColor3 = Color3.fromRGB(20,25,30)
            ListFrame.BorderSizePixel = 1
            ListFrame.BorderColor3 = Color3.fromRGB(60,60,60)
            ListFrame.Visible = false
            ListFrame.Parent = Container
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = ListFrame
            local selected = isMulti and {} or (opts[1] or "")
            local function rebuildList()
                for _, c in ipairs(ListFrame:GetChildren()) do
                    if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
                end
                for _, opt in ipairs(opts) do
                    if isMulti then
                        local Item = Instance.new("Frame")
                        Item.Size = UDim2.new(1,0,0,25)
                        Item.BackgroundTransparency = 1
                        Item.Parent = ListFrame
                        local Check = Instance.new("TextButton")
                        Check.Size = UDim2.new(0,18,0,18)
                        Check.Position = UDim2.new(0,5,0.5,-9)
                        Check.BackgroundColor3 = Color3.fromRGB(25,35,50)
                        Check.Text = ""
                        Check.Parent = Item
                        local UIC = Instance.new("UICorner")
                        UIC.CornerRadius = UDim.new(0,4)
                        UIC.Parent = Check
                        local OptLabel = Instance.new("TextLabel")
                        OptLabel.Size = UDim2.new(1,-30,1,0)
                        OptLabel.Position = UDim2.new(0,30,0,0)
                        OptLabel.BackgroundTransparency = 1
                        OptLabel.Text = opt
                        OptLabel.TextColor3 = Color3.fromRGB(200,200,200)
                        OptLabel.TextXAlignment = Enum.TextXAlignment.Left
                        OptLabel.Parent = Item
                        local checked = table.find(selected, opt) \~= nil
                        if checked then Check.BackgroundColor3 = Color3.fromRGB(120,190,255) end
                        Check.MouseButton1Click:Connect(function()
                            if checked then
                                table.remove(selected, table.find(selected, opt))
                                Check.BackgroundColor3 = Color3.fromRGB(25,35,50)
                            else
                                table.insert(selected, opt)
                                Check.BackgroundColor3 = Color3.fromRGB(120,190,255)
                            end
                            checked = not checked
                            SelectedLabel.Text = title .. ": " .. #selected .. " selected"
                            if callback then callback(selected) end
                        end)
                    else
                        local Btn = Instance.new("TextButton")
                        Btn.Size = UDim2.new(1,0,0,25)
                        Btn.BackgroundColor3 = Color3.fromRGB(25,35,50)
                        Btn.Text = opt
                        Btn.TextColor3 = Color3.fromRGB(200,200,200)
                        Btn.TextSize = 14
                        Btn.Font = Enum.Font.Code
                        Btn.TextXAlignment = Enum.TextXAlignment.Left
                        Btn.Parent = ListFrame
                        Btn.MouseButton1Click:Connect(function()
                            selected = opt
                            SelectedLabel.Text = title .. ": " .. opt
                            ListFrame.Visible = false
                            if callback then callback(opt) end
                        end)
                    end
                end
            end
            rebuildList()
            SelectedLabel.MouseButton1Click:Connect(function()
                ListFrame.Visible = not ListFrame.Visible
                ListFrame.Size = UDim2.new(1,0,0, math.min(#opts * 25, 150))
            end)
            registerElement(id, {type = "dropdown", selectedLabel = SelectedLabel, listFrame = ListFrame, options = opts, selected = selected, callback = callback, multi = isMulti})
        end
        function Area:CreateColorPicker(defaultColor, callback, id)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1,-10,0,30)
            Container.BackgroundTransparency = 1
            Container.Parent = AreaContent
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Size = UDim2.new(0,80,0,25)
            ColorFrame.BackgroundColor3 = defaultColor or Color3.fromRGB(255,0,0)
            ColorFrame.Parent = Container
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0,4)
            Corner.Parent = ColorFrame
            local PickerBtn = Instance.new("TextButton")
            PickerBtn.Size = UDim2.new(1,0,1,0)
            PickerBtn.BackgroundTransparency = 1
            PickerBtn.Text = ""
            PickerBtn.Parent = ColorFrame
            local currentColor = defaultColor or Color3.fromRGB(255,0,0)
            registerElement(id, {type = "colorpicker", colorFrame = ColorFrame, callback = callback, color = currentColor})
            PickerBtn.MouseButton1Click:Connect(function()
                currentColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
                ColorFrame.BackgroundColor3 = currentColor
                if callback then callback(currentColor) end
            end)
        end
        registerElement(id, {type = "area", frame = AreaFrame})
        return Area
    end
    function Window:Update(id, props)
        local elem = Window.Elements[id]
        if not elem then return end
        if elem.type == "label" and props.text then
            elem.label.Text = props.text
        elseif elem.type == "toggle" then
            if props.toggled \~= nil then
                elem.toggled = props.toggled
                if elem.toggled then
                    elem.toggleBox.BackgroundColor3 = Color3.fromRGB(120,190,255)
                    elem.toggleBox.BorderColor3 = Color3.fromRGB(35,58,95)
                else
                    elem.toggleBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
                    elem.toggleBox.BorderColor3 = Color3.fromRGB(40,50,70)
                end
                if elem.callback then elem.callback(elem.toggled) end
            end
            if props.text then elem.label.Text = props.text end
        elseif elem.type == "button" and props.text then
            elem.button.Text = props.text
        elseif elem.type == "slider" and props.value \~= nil then
            local v = math.clamp(props.value, elem.min, elem.max)
            elem.value = v
            local p = (v - elem.min) / (elem.max - elem.min)
            elem.fill.Size = UDim2.new(p, 0, 1, 0)
            elem.knob.Position = UDim2.new(p, -8, 0.5, -8)
            elem.valueLabel.Text = tostring(math.floor(v + 0.5))
            if elem.callback then elem.callback(v) end
        elseif elem.type == "dropdown" then
            if props.options then
                elem.options = props.options
                for _, c in ipairs(elem.listFrame:GetChildren()) do
                    if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
                end
                local function rebuild() end
                rebuild = function()
                    for _, opt in ipairs(elem.options) do
                        if elem.multi then
                            -- rebuild logic same as creation (omitted for brevity, same as CreateDropdown)
                        else
                            local b = Instance.new("TextButton")
                            b.Size = UDim2.new(1,0,0,25)
                            b.BackgroundColor3 = Color3.fromRGB(25,35,50)
                            b.Text = opt
                            b.Parent = elem.listFrame
                            b.MouseButton1Click:Connect(function()
                                elem.selected = opt
                                elem.selectedLabel.Text = "Dropdown: " .. opt
                                elem.listFrame.Visible = false
                                if elem.callback then elem.callback(opt) end
                            end)
                        end
                    end
                end
                rebuild()
            end
            if props.selected \~= nil then
                elem.selected = props.selected
                elem.selectedLabel.Text = "Dropdown: " .. tostring(props.selected)
                if elem.callback then elem.callback(props.selected) end
            end
        elseif elem.type == "colorpicker" and props.color then
            elem.color = props.color
            elem.colorFrame.BackgroundColor3 = props.color
            if elem.callback then elem.callback(props.color) end
        elseif elem.type == "banner" then
            if props.imageId then elem.image.Image = "rbxassetid://" .. tostring(props.imageId) end
            if props.title then elem.titleLabel.Text = props.title end
            if props.description then elem.descLabel.Text = props.description end
        end
    end
    return Window
end

return LYui
