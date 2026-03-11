-- LYui Library (modified) -- Adiciona IDs para cada elemento e API para manipulação por script

local LYui = {}

local UserInputService = game:GetService("UserInputService") local TweenService = game:GetService("TweenService") local Players = game:GetService("Players") local Player = Players.LocalPlayer

function LYui:CreateWindow(titleText) local Window = {} Window.Elements = {} -- registry: id -> {instance = <Instance>, type = "toggle"/"label"/... , meta = {...}}

local PlayerGui = Player:WaitForChild("PlayerGui")

for _, gui in ipairs(PlayerGui:GetChildren()) do
    if gui.Name == "LYui_Interface_" .. titleText then
        gui:Destroy()
    end
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LYui_Interface_" .. titleText
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- MainFrame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 140)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 20)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- TopBar
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

-- Content
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

-- Resize Handle
local ResizeHandle = Instance.new("Frame")
ResizeHandle.Size = UDim2.new(0,16,0,16)
ResizeHandle.Position = UDim2.new(1,-16,1,-16)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Active = true
ResizeHandle.Parent = MainFrame

local Triangle = Instance.new("TextLabel")
Triangle.Size = UDim2.new(1,0,1,0)
Triangle.Position = UDim2.new(0,0,0,2) -- abaixado 2px para encostar melhor na parte de baixo
Triangle.BackgroundTransparency = 1
Triangle.Text = "◢"
Triangle.TextColor3 = Color3.fromRGB(35,58,95)
Triangle.TextSize = 18
Triangle.Font = Enum.Font.Arial
Triangle.TextXAlignment = Enum.TextXAlignment.Right
Triangle.TextYAlignment = Enum.TextYAlignment.Bottom
Triangle.Parent = ResizeHandle

-- Internal helper: register element by id
local function registerElement(id, inst, typ, meta)
    if not id or type(id) ~= "string" then
        warn("LYui: registerElement requires string id")
        return
    end
    if Window.Elements[id] then
        warn("LYui: id already in use: "..id)
        return
    end
    Window.Elements[id] = {instance = inst, type = typ, meta = meta}
end

-- API to get / remove / manipulate elements by id
function Window:GetElement(id)
    return (Window.Elements[id] and Window.Elements[id].instance) or nil
end

function Window:RemoveElement(id)
    local rec = Window.Elements[id]
    if not rec then return false end
    if rec.instance and rec.instance.Destroy then
        rec.instance:Destroy()
    end
    Window.Elements[id] = nil
    return true
end

function Window:SetVisible(id, visible)
    local inst = Window:GetElement(id)
    if inst and inst.SetPrimaryPartCFrame == nil then
        inst.Visible = visible
        return true
    end
    return false
end

function Window:SetText(id, text)
    local inst = Window:GetElement(id)
    if inst and inst:IsA("TextLabel") or inst and inst:IsA("TextBox") or inst and inst:IsA("TextButton") then
        inst.Text = text
        return true
    end
    return false
end

function Window:SetSize(id, udim)
    local inst = Window:GetElement(id)
    if inst and inst.Size then
        inst.Size = udim
        return true
    end
    return false
end

function Window:SetPosition(id, udim)
    local inst = Window:GetElement(id)
    if inst and inst.Position then
        inst.Position = udim
        return true
    end
    return false
end

function Window:SetToggle(id, state)
    local rec = Window.Elements[id]
    if rec and rec.type == "toggle" then
        local meta = rec.meta
        rec.instance.BackgroundColor3 = state and Color3.fromRGB(120,190,255) or Color3.fromRGB(25,35,50)
        rec.instance.BorderColor3 = state and Color3.fromRGB(35,58,95) or Color3.fromRGB(40,50,70)
        meta.toggled = state
        if meta.callback then
            pcall(meta.callback, state)
        end
        return true
    end
    return false
end

-- Logic: Layout Adjustment
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

-- Logic: Dragging
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
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Logic: Resizing
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

-- Logic: Collapse
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

-- Logic: Close
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- CreateArea
function Window:CreateArea(areaName)
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

    -- sizeArea
    local function updateHeight()
        local contentH = AreaList.AbsoluteContentSize.Y + AreaPadding.PaddingTop.Offset + (AreaPadding.PaddingBottom and AreaPadding.PaddingBottom.Offset or 0)
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

    -- label
    function Area:CreateLabel(id, text)
        local InfoLabel = Instance.new("TextLabel")
        InfoLabel.Size = UDim2.new(1,-10,0,15)
        InfoLabel.BackgroundTransparency = 1
        InfoLabel.Text = text
        InfoLabel.TextColor3 = Color3.fromRGB(200,200,200)
        InfoLabel.TextSize = 14
        InfoLabel.Font = Enum.Font.Code
        InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
        InfoLabel.Parent = AreaContent

        if id then registerElement(id, InfoLabel, "label", {parent = AreaFrame}) end
        return InfoLabel
    end

    -- Toggle
    function Area:CreateToggle(id, toggleText, callback, default)
        local ToggleContainer = Instance.new("Frame")
        ToggleContainer.Size = UDim2.new(1,-10,0,20)
        ToggleContainer.BackgroundTransparency = 1
        ToggleContainer.Parent = AreaContent

        local ToggleBox = Instance.new("Frame")
        ToggleBox.Name = "ToggleBox"
        ToggleBox.Size = UDim2.new(0,18,0,18)
        ToggleBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
        ToggleBox.BorderColor3 = Color3.fromRGB(40,50,70)
        ToggleBox.BorderSizePixel = 2
        ToggleBox.Parent = ToggleContainer

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1,0)
        UICorner.Parent = ToggleBox

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Size = UDim2.new(1,0,1,0)
        ToggleButton.BackgroundTransparency = 1
        ToggleButton.Text = ""
        ToggleButton.Parent = ToggleBox

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "ToggleLabel"
        ToggleLabel.Size = UDim2.new(1,-25,1,0)
        ToggleLabel.Position = UDim2.new(0,25,0,0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = toggleText
        ToggleLabel.TextColor3 = Color3.fromRGB(200,200,200)
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.Code
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleContainer

        local toggled = default and true or false
        if toggled then
            ToggleBox.BackgroundColor3 = Color3.fromRGB(120,190,255)
            ToggleBox.BorderColor3 = Color3.fromRGB(35,58,95)
        end

        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            if toggled then
                ToggleBox.BackgroundColor3 = Color3.fromRGB(120,190,255)
                ToggleBox.BorderColor3 = Color3.fromRGB(35,58,95)
            else
                ToggleBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
                ToggleBox.BorderColor3 = Color3.fromRGB(40,50,70)
            end
            if callback then pcall(callback, toggled) end
            -- update registry meta if exists
            if id and Window.Elements[id] then Window.Elements[id].meta.toggled = toggled end
        end)

        if id then registerElement(id, ToggleBox, "toggle", {parent = AreaFrame, callback = callback, toggled = toggled}) end
        return ToggleBox
    end

    -- TextBox
    function Area:CreateTextBox(id, placeholder, callback, default)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1,-10,0,28)
        Container.BackgroundTransparency = 1
        Container.Parent = AreaContent

        local Box = Instance.new("TextBox")
        Box.Size = UDim2.new(1,0,1,0)
        Box.PlaceholderText = placeholder or ""
        Box.Text = default or ""
        Box.BackgroundColor3 = Color3.fromRGB(25,30,35)
        Box.BorderSizePixel = 1
        Box.BorderColor3 = Color3.fromRGB(50,50,50)
        Box.TextColor3 = Color3.fromRGB(220,220,220)
        Box.Font = Enum.Font.SourceSans
        Box.TextSize = 14
        Box.ClearTextOnFocus = false
        Box.Parent = Container

        Box.FocusLost:Connect(function(enter)
            if callback then pcall(callback, Box.Text, enter) end
        end)

        if id then registerElement(id, Box, "textbox", {parent = AreaFrame}) end
        return Box
    end

    -- Checkbox (different from toggle visually)
    function Area:CreateCheckbox(id, labelText, callback, default)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1,-10,0,20)
        container.BackgroundTransparency = 1
        container.Parent = AreaContent

        local box = Instance.new("Frame")
        box.Size = UDim2.new(0,18,0,18)
        box.BackgroundColor3 = Color3.fromRGB(25,35,50)
        box.BorderColor3 = Color3.fromRGB(40,50,70)
        box.BorderSizePixel = 2
        box.Parent = container

        local check = Instance.new("ImageLabel")
        check.Size = UDim2.new(1,-4,1,-4)
        check.Position = UDim2.new(0,2,0,2)
        check.BackgroundTransparency = 1
        check.Image = "" -- set a check image if desired
        check.Parent = box
        check.Visible = default and true or false

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,-25,1,0)
        lbl.Position = UDim2.new(0,25,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(200,200,200)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 14
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = container

        local toggled = default and true or false

        box.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggled = not toggled
                check.Visible = toggled
                if callback then pcall(callback, toggled) end
                if id and Window.Elements[id] then Window.Elements[id].meta.checked = toggled end
            end
        end)

        if id then registerElement(id, box, "checkbox", {parent = AreaFrame, checked = toggled, checkInstance = check}) end
        return box
    end

    -- Dropdown (simple)
        function Area:CreateDropdown(id, title, options, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1,-10,0,24)
            container.BackgroundTransparency = 1
            container.Parent = AreaContent

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,1,0)
            btn.Text = title or "Select"
            btn.BackgroundColor3 = Color3.fromRGB(25,30,35)
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(50,50,50)
            btn.TextColor3 = Color3.fromRGB(220,220,220)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.Parent = container

            local list = Instance.new("Frame")
            list.Size = UDim2.new(1,0,0,0)
            list.Position = UDim2.new(0,0,1,2)
            list.BackgroundColor3 = Color3.fromRGB(20,25,30)
            list.BorderSizePixel = 1
            list.BorderColor3 = Color3.fromRGB(50,50,50)
            list.Visible = false
            list.Parent = container

            local listLayout = Instance.new("UIListLayout")
            listLayout.Parent = list

            local function populate()
                for i, opt in ipairs(options or {}) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1,0,0,20)
                    optBtn.Text = tostring(opt)
                    optBtn.BackgroundTransparency = 1
                    optBtn.TextColor3 = Color3.fromRGB(220,220,220)
                    optBtn.Font = Enum.Font.SourceSans
                    optBtn.TextSize = 14
                    optBtn.Parent = list
                    optBtn.MouseButton1Click:Connect(function()
                        btn.Text = optBtn.Text
                        list.Visible = false
                        if callback then pcall(callback, optBtn.Text) end
                        if id and Window.Elements[id] then Window.Elements[id].meta.selected = optBtn.Text end
                    end)
                end
                list.Size = UDim2.new(1,0,0, listLayout.AbsoluteContentSize.Y)
            end

            btn.MouseButton1Click:Connect(function()
                list.Visible = not list.Visible
                if list.Visible and #list:GetChildren() <= 2 then -- only layout and maybe padding
                    populate()
                end
            end)

            if id then registerElement(id, container, "dropdown", {parent = AreaFrame, options = options, selected = nil}) end
            return container
        end

        -- PlayersListDropdown
        function Area:CreatePlayersListDropdown(id, title, callback)
            return Area:CreateDropdown(id, title or "Players", (function()
                local t = {}
                for _, p in ipairs(Players:GetPlayers()) do table.insert(t, p.Name) end
                return t
            end)(), callback)
        end

        -- Button
        function Area:CreateButton(id, text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-10,0,24)
            btn.Text = text or "Button"
            btn.BackgroundColor3 = Color3.fromRGB(35,58,95)
            btn.BorderSizePixel = 0
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.Parent = AreaContent

            if callback then btn.MouseButton1Click:Connect(function() pcall(callback) end) end
            if id then registerElement(id, btn, "button", {parent = AreaFrame}) end
            return btn
        end

        -- ImageLabel
        function Area:CreateImageLabel(id, imageId, size)
            local img = Instance.new("ImageLabel")
            img.Size = size or UDim2.new(1,-10,0,60)
            img.BackgroundTransparency = 0
            img.BackgroundColor3 = Color3.fromRGB(20,20,20)
            img.Image = imageId or ""
            img.Parent = AreaContent

            if id then registerElement(id, img, "imagelabel", {parent = AreaFrame}) end
            return img
        end

        -- Banner (full width visual)
        function Area:CreateBanner(id, text, imageId)
            local banner = Instance.new("Frame")
            banner.Size = UDim2.new(1,0,0,60)
            banner.BackgroundColor3 = Color3.fromRGB(35,58,95)
            banner.Parent = AreaContent

            if imageId then
                local img = Instance.new("ImageLabel")
                img.Size = UDim2.new(0,60,1,0)
                img.Position = UDim2.new(0,0,0,0)
                img.BackgroundTransparency = 1
                img.Image = imageId
                img.Parent = banner
            end

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, imageId and -60 or 0, 1,0)
            lbl.Position = UDim2.new(imageId and 0, 65 or 0, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text or ""
            lbl.TextColor3 = Color3.fromRGB(255,255,255)
            lbl.Font = Enum.Font.SourceSans
            lbl.TextSize = 18
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = banner

            if id then registerElement(id, banner, "banner", {parent = AreaFrame}) end
            return banner
        end

        -- ColorPicker (simples: R,G,B boxes)
        function Area:CreateColorPicker(id, callback, default)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1,-10,0,60)
            container.BackgroundTransparency = 1
            container.Parent = AreaContent

            local preview = Instance.new("Frame")
            preview.Size = UDim2.new(0,48,0,48)
            preview.Position = UDim2.new(0,0,0,0)
            preview.BackgroundColor3 = default or Color3.fromRGB(255,255,255)
            preview.BorderSizePixel = 1
            preview.BorderColor3 = Color3.fromRGB(50,50,50)
            preview.Parent = container

            local rBox = Instance.new("TextBox")
            rBox.Size = UDim2.new(0,40,0,18)
            rBox.Position = UDim2.new(0,56,0,0)
            rBox.PlaceholderText = "R"
            rBox.Text = tostring(math.floor((default and default.R*255) or 255))
            rBox.Parent = container

            local gBox = rBox:Clone()
            gBox.Position = UDim2.new(0,56,0,20)
            gBox.PlaceholderText = "G"
            gBox.Text = tostring(math.floor((default and default.G*255) or 255))
            gBox.Parent = container

            local bBox = rBox:Clone()
            bBox.Position = UDim2.new(0,56,0,40)
            bBox.PlaceholderText = "B"
            bBox.Text = tostring(math.floor((default and default.B*255) or 255))
            bBox.Parent = container

            local function update()
                local r = math.clamp(tonumber(rBox.Text) or 255, 0, 255)
                local g = math.clamp(tonumber(gBox.Text) or 255, 0, 255)
                local b = math.clamp(tonumber(bBox.Text) or 255, 0, 255)
                local c = Color3.fromRGB(r,g,b)
                preview.BackgroundColor3 = c
                if callback then pcall(callback, c) end
                if id and Window.Elements[id] then Window.Elements[id].meta.color = c end
            end

            rBox.FocusLost:Connect(function() update() end)
            gBox.FocusLost:Connect(function() update() end)
            bBox.FocusLost:Connect(function() update() end)

            if id then registerElement(id, container, "colorpicker", {parent = AreaFrame, color = preview.BackgroundColor3}) end
            return container
        end

        return Area
    end

    -- Return window API
    Window._internal = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentFrame = ContentFrame,
    }

    return Window
end

return LYui
