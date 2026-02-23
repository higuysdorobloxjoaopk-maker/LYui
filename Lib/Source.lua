-- // LYui Library
local LYui = {}
LYui.__index = LYui

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

function LYui:CreateWindow(titleText)

    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")

    local Window = {}
    Window.__index = Window

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LYui_Interface"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false

    -- MainFrame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,220,0,140)
    MainFrame.Position = UDim2.new(0.5,-110,0.5,-70)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15,17,20)
    MainFrame.BorderColor3 = Color3.fromRGB(60,60,60)
    MainFrame.BorderSizePixel = 1
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1,0,0,25)
    TopBar.BackgroundColor3 = Color3.fromRGB(35,58,95)
    TopBar.Parent = MainFrame
    TopBar.Active = true

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-50,1,0)
    Title.Position = UDim2.new(0,28,0,0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText or "LYui"
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextSize = 14
    Title.Font = Enum.Font.SourceSans
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local CollapseBtn = Instance.new("TextButton")
    CollapseBtn.Size = UDim2.new(0,25,0,25)
    CollapseBtn.Text = "▼"
    CollapseBtn.BackgroundTransparency = 1
    CollapseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    CollapseBtn.TextSize = 12
    CollapseBtn.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,25,0,25)
    CloseBtn.Position = UDim2.new(1,-25,0,0)
    CloseBtn.Text = "X"
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    CloseBtn.Parent = TopBar

    -- Content
    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1,0,1,-25)
    Content.Position = UDim2.new(0,0,0,25)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 2
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.CanvasSize = UDim2.new(0,0,0,0)
    Content.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0,8)
    Layout.Parent = Content

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0,10)
    Padding.PaddingTop = UDim.new(0,10)
    Padding.Parent = Content

    --------------------------------------------------
    -- grid
    --------------------------------------------------

    local function adjustLayout()
        local w = MainFrame.Size.X.Offset
        Layout.FillDirection = (w >= 500)
            and Enum.FillDirection.Horizontal
            or Enum.FillDirection.Vertical
    end

    MainFrame:GetPropertyChangedSignal("Size"):Connect(adjustLayout)
    adjustLayout()

    --------------------------------------------------
    -- CREATE AREA
    --------------------------------------------------

    function Window:CreateArea(name)

        local Area = {}

        local AreaFrame = Instance.new("Frame")
        AreaFrame.BackgroundColor3 = Color3.fromRGB(20,25,30)
        AreaFrame.BorderSizePixel = 0
        AreaFrame.Parent = Content

        local Header = Instance.new("Frame")
        Header.Size = UDim2.new(1,0,0,20)
        Header.BackgroundColor3 = Color3.fromRGB(35,58,95)
        Header.Parent = AreaFrame

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-25,1,0)
        Title.Position = UDim2.new(0,5,0,0)
        Title.BackgroundTransparency = 1
        Title.Text = name
        Title.TextColor3 = Color3.fromRGB(255,255,255)
        Title.Font = Enum.Font.SourceSans
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Header

        local MinBtn = Instance.new("TextButton")
        MinBtn.Size = UDim2.new(0,20,1,0)
        MinBtn.Position = UDim2.new(1,-20,0,0)
        MinBtn.BackgroundTransparency = 1
        MinBtn.Text = "▼"
        MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
        MinBtn.Parent = Header

        local AreaContent = Instance.new("Frame")
        AreaContent.Position = UDim2.new(0,0,0,20)
        AreaContent.BackgroundTransparency = 1
        AreaContent.Parent = AreaFrame

        local List = Instance.new("UIListLayout")
        List.Padding = UDim.new(0,5)
        List.Parent = AreaContent

        local Pad = Instance.new("UIPadding")
        Pad.PaddingLeft = UDim.new(0,5)
        Pad.PaddingTop = UDim.new(0,5)
        Pad.Parent = AreaContent

        List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            AreaContent.Size = UDim2.new(1,0,0,List.AbsoluteContentSize.Y + 5)
            AreaFrame.Size = UDim2.new(1,-10,0,20 + AreaContent.Size.Y.Offset)
        end)

        local collapsed = false
        MinBtn.MouseButton1Click:Connect(function()
            collapsed = not collapsed
            AreaContent.Visible = not collapsed
            MinBtn.Text = collapsed and "►" or "▼"
        end)

        --------------------------------------------------
        -- TOGGLE
        --------------------------------------------------

        function Area:AddToggle(text, callback)

            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1,-10,0,20)
            Container.BackgroundTransparency = 1
            Container.Parent = AreaContent

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0,18,0,18)
            Box.BackgroundColor3 = Color3.fromRGB(25,35,50)
            Box.BorderColor3 = Color3.fromRGB(40,50,70)
            Box.BorderSizePixel = 2
            Box.Parent = Container

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(1,0)
            Corner.Parent = Box

            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1,0,1,0)
            Button.BackgroundTransparency = 1
            Button.Text = ""
            Button.Parent = Box

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1,-25,1,0)
            Label.Position = UDim2.new(0,25,0,0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(200,200,200)
            Label.Font = Enum.Font.Code
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Container

            local state = false

            Button.MouseButton1Click:Connect(function()
                state = not state

                TweenService:Create(Box,TweenInfo.new(0.15),{
                    BackgroundColor3 = state and Color3.fromRGB(120,190,255)
                        or Color3.fromRGB(25,35,50)
                }):Play()

                if callback then
                    callback(state)
                end
            end)

        end

        return Area
    end

    --------------------------------------------------
    -- DRAG
    --------------------------------------------------

    local dragging = false
    local dragStart, startPos

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then

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
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    --------------------------------------------------
    -- MINIMIZAR
    --------------------------------------------------

    local collapsed = false
    local originalY = MainFrame.Size.Y.Offset

    CollapseBtn.MouseButton1Click:Connect(function()
        collapsed = not collapsed

        if collapsed then
            originalY = MainFrame.Size.Y.Offset
            MainFrame:TweenSize(UDim2.new(0,MainFrame.Size.X.Offset,0,25),"Out","Quad",0.2,true)
            Content.Visible = false
            CollapseBtn.Text = "►"
        else
            MainFrame:TweenSize(UDim2.new(0,MainFrame.Size.X.Offset,0,originalY),"Out","Quad",0.2,true)
            Content.Visible = true
            CollapseBtn.Text = "▼"
        end
    end)

    --------------------------------------------------
    -- CLOSE
    --------------------------------------------------

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    return setmetatable(Window,LYui)
end

return LYui
