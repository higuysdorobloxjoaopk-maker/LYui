-- LYui Library

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
    Triangle.BackgroundTransparency = 1
    Triangle.Text = "◢"
    Triangle.TextColor3 = Color3.fromRGB(35,58,95)
    Triangle.TextSize = 19
    Triangle.Font = Enum.Font.Arial
    Triangle.TextXAlignment = Enum.TextXAlignment.Right
    Triangle.TextYAlignment = Enum.TextYAlignment.Bottom
    Triangle.Parent = ResizeHandle

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

        -- label
        function Area:CreateLabel(text)
            local InfoLabel = Instance.new("TextLabel")
            InfoLabel.Size = UDim2.new(1,-10,0,15)
            InfoLabel.BackgroundTransparency = 1
            InfoLabel.Text = text
            InfoLabel.TextColor3 = Color3.fromRGB(200,200,200)
            InfoLabel.TextSize = 14
            InfoLabel.Font = Enum.Font.Code
            InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
            InfoLabel.Parent = AreaContent
            return InfoLabel
        end

        -- Toggle
        function Area:CreateToggle(toggleText, callback)
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

            local toggled = false
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                if toggled then
                    ToggleBox.BackgroundColor3 = Color3.fromRGB(120,190,255)
                    ToggleBox.BorderColor3 = Color3.fromRGB(35,58,95)
                else
                    ToggleBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
                    ToggleBox.BorderColor3 = Color3.fromRGB(40,50,70)
                end
                if callback then
                    callback(toggled)
                end
            end)
        end

        return Area
    end

    return Window
end

return LYui

-- ==========================================
-- EXEMPLE
-- ==========================================
--[[
local LYui = loadstring(game:HttpGet(""))()
local janela = LYui:CreateWindow("raknet desync")

-- Área 1
local areaMain = janela:CreateArea("Main")
areaMain:CreateLabel("must have raknet library")
areaMain:CreateToggle("desync meow", function(state)
    print("Desync status for desync meow:", state)
end)

-- Área 2
local areaAdv = janela:CreateArea("Advanced")
areaAdv:CreateToggle("desync purr", function(state)
    print("Desync status for desync purr:", state)
end)

-- Área 3
local areaSet = janela:CreateArea("Settings")
areaSet:CreateToggle("desync hiss", function(state)
    print("Desync status for desync hiss:", state)
end)
]]
