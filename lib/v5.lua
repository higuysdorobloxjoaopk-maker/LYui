-- LYui Library v2.0 (Enhanced with IDs and New Components)
local LYui = {
    Elements = {}, -- Armazena referências para manipulação via ID
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Funções Utilitárias para Manipulação Externa
function LYui:Get(id) return self.Elements[id] end

function LYui:SetToggle(id, state)
    local element = self:Get(id)
    if element and element.UpdateState then element.UpdateState(state) end
end

function LYui:Remove(id)
    local element = self:Get(id)
    if element and element.Instance then 
        element.Instance:Destroy() 
        self.Elements[id] = nil
    end
end

function LYui:CreateWindow(titleText, options)
    options = options or {}
    local Window = {}
    local PlayerGui = Player:WaitForChild("PlayerGui")  
    
    local existing = PlayerGui:FindFirstChild("LYui_" .. titleText)
    if existing then existing:Destroy() end

    -- ScreenGui  
    local ScreenGui = Instance.new("ScreenGui")  
    ScreenGui.Name = "LYui_" .. titleText  
    ScreenGui.Parent = PlayerGui  
    ScreenGui.ResetOnSpawn = false  

    -- MainFrame  
    local MainFrame = Instance.new("Frame")  
    MainFrame.Size = options.Size or UDim2.new(0, 250, 0, 300)  
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)  
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 20)  
    MainFrame.BorderSizePixel = 1  
    MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)  
    MainFrame.Active = true  
    MainFrame.ClipsDescendants = true  
    MainFrame.Parent = ScreenGui  

    -- TopBar  
    local TopBar = Instance.new("Frame")  
    TopBar.Size = UDim2.new(1, 0, 0, 30)  
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 58, 95)  
    TopBar.BorderSizePixel = 0  
    TopBar.Parent = MainFrame  

    local Title = Instance.new("TextLabel")  
    Title.Size = UDim2.new(1, -60, 1, 0)  
    Title.Position = UDim2.new(0, 10, 0, 0)  
    Title.BackgroundTransparency = 1  
    Title.Text = titleText or "LYui Window"  
    Title.TextColor3 = Color3.fromRGB(255,255,255)  
    Title.TextSize = 14  
    Title.Font = Enum.Font.SourceSansBold  
    Title.TextXAlignment = Enum.TextXAlignment.Left  
    Title.Parent = TopBar  

    local CollapseBtn = Instance.new("TextButton")  
    CollapseBtn.Size = UDim2.new(0,30,0,30)  
    CollapseBtn.Position = UDim2.new(1,-60,0,0)
    CollapseBtn.BackgroundTransparency = 1  
    CollapseBtn.Text = "▼"  
    CollapseBtn.TextColor3 = Color3.fromRGB(255,255,255)  
    CollapseBtn.Parent = TopBar  

    local CloseBtn = Instance.new("TextButton")  
    CloseBtn.Size = UDim2.new(0,30,0,30)  
    CloseBtn.Position = UDim2.new(1,-30,0,0)  
    CloseBtn.BackgroundTransparency = 1  
    CloseBtn.Text = "✕"  
    CloseBtn.TextColor3 = Color3.fromRGB(255,100,100)  
    CloseBtn.Parent = TopBar  

    -- Content  
    local ContentFrame = Instance.new("ScrollingFrame")  
    ContentFrame.Size = UDim2.new(1,0,1,-30)  
    ContentFrame.Position = UDim2.new(0,0,0,30)  
    ContentFrame.BackgroundTransparency = 1  
    ContentFrame.BorderSizePixel = 0  
    ContentFrame.ScrollBarThickness = 2  
    ContentFrame.CanvasSize = UDim2.new(0,0,0,0)  
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y  
    ContentFrame.Parent = MainFrame  

    local layout = Instance.new("UIListLayout")  
    layout.Padding = UDim.new(0,10)  
    layout.SortOrder = Enum.SortOrder.LayoutOrder  
    layout.Parent = ContentFrame  

    local UIPadding = Instance.new("UIPadding")  
    UIPadding.PaddingLeft = UDim.new(0,10)  
    UIPadding.PaddingRight = UDim.new(0,10)
    UIPadding.PaddingTop = UDim.new(0,10)  
    UIPadding.PaddingBottom = UDim.new(0,10)
    UIPadding.Parent = ContentFrame  

    -- Resize Handle (FIXED POSITION)
    local ResizeHandle = Instance.new("Frame")  
    ResizeHandle.Size = UDim2.new(0,18,0,18)  
    ResizeHandle.Position = UDim2.new(1,-18,1,-18) -- Exatamente no canto
    ResizeHandle.BackgroundTransparency = 1  
    ResizeHandle.Active = true  
    ResizeHandle.ZIndex = 5
    ResizeHandle.Parent = MainFrame  

    local Triangle = Instance.new("TextLabel")  
    Triangle.Size = UDim2.new(1,0,1,0)  
    Triangle.BackgroundTransparency = 1  
    Triangle.Text = "◢"  
    Triangle.TextColor3 = Color3.fromRGB(35, 58, 95)  
    Triangle.TextSize = 18  
    Triangle.Font = Enum.Font.SourceSans
    Triangle.TextXAlignment = Enum.TextXAlignment.Right  
    Triangle.TextYAlignment = Enum.TextYAlignment.Bottom  
    Triangle.Parent = ResizeHandle  

    -- Dragging Logic
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = MainFrame.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    -- Resize Logic
    local resizing, resStart, resSize
    ResizeHandle.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then resizing = true resStart = i.Position resSize = MainFrame.Size end end)
    UserInputService.InputChanged:Connect(function(i) if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - resStart
        MainFrame.Size = UDim2.new(0, math.max(150, resSize.X.Offset + delta.X), 0, math.max(100, resSize.Y.Offset + delta.Y))
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end end)

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    function Window:CreateArea(areaName)
        local Area = {}
        local AreaFrame = Instance.new("Frame")
        AreaFrame.Size = UDim2.new(1,0,0,30)
        AreaFrame.BackgroundColor3 = Color3.fromRGB(20,25,30)
        AreaFrame.BorderSizePixel = 0
        AreaFrame.Parent = ContentFrame
        
        local AreaTitle = Instance.new("TextLabel")
        AreaTitle.Size = UDim2.new(1,0,0,25)
        AreaTitle.Text = "  " .. areaName:upper()
        AreaTitle.TextColor3 = Color3.fromRGB(100,150,255)
        AreaTitle.BackgroundTransparency = 1
        AreaTitle.TextXAlignment = Enum.TextXAlignment.Left
        AreaTitle.Font = Enum.Font.SourceSansBold
        AreaTitle.Parent = AreaFrame

        local AreaLayout = Instance.new("UIListLayout")
        AreaLayout.Padding = UDim.new(0,5)
        AreaLayout.Parent = AreaFrame
        
        AreaLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            AreaFrame.Size = UDim2.new(1,0,0, AreaLayout.AbsoluteContentSize.Y + 5)
        end)

        -- COMPONENTE: Toggle
        function Area:CreateToggle(id, text, default, callback)
            local ToggleObj = {Instance = nil}
            local Frame = Instance.new("TextButton")
            Frame.Size = UDim2.new(1, 0, 0, 25)
            Frame.BackgroundColor3 = Color3.fromRGB(30,35,40)
            Frame.Text = ""
            Frame.Parent = AreaFrame
            ToggleObj.Instance = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1,-30,1,0)
            Label.Position = UDim2.new(0,5,0,0)
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(200,200,200)
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0,16,0,16)
            Box.Position = UDim2.new(1,-21,0.5,-8)
            Box.BackgroundColor3 = default and Color3.fromRGB(50,150,255) or Color3.fromRGB(50,50,50)
            Box.Parent = Frame

            local state = default
            ToggleObj.UpdateState = function(newState)
                state = newState
                Box.BackgroundColor3 = state and Color3.fromRGB(50,150,255) or Color3.fromRGB(50,50,50)
                if callback then callback(state) end
            end

            Frame.MouseButton1Click:Connect(function() ToggleObj.UpdateState(not state) end)
            LYui.Elements[id] = ToggleObj
            return ToggleObj
        end

        -- COMPONENTE: Button
        function Area:CreateButton(id, text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 28)
            Btn.BackgroundColor3 = Color3.fromRGB(40,60,100)
            Btn.Text = text
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.Font = Enum.Font.SourceSansBold
            Btn.Parent = AreaFrame
            
            Btn.MouseButton1Click:Connect(callback)
            LYui.Elements[id] = {Instance = Btn}
            return Btn
        end

        -- COMPONENTE: TextBox
        function Area:CreateTextBox(id, placeholder, callback)
            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(1,0,0,25)
            Box.BackgroundColor3 = Color3.fromRGB(10,10,10)
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.TextColor3 = Color3.new(1,1,1)
            Box.Parent = AreaFrame
            
            Box.FocusLost:Connect(function() if callback then callback(Box.Text) end end)
            LYui.Elements[id] = {Instance = Box}
            return Box
        end

        -- COMPONENTE: Banner / Image
        function Area:CreateImage(id, assetId, sizeY)
            local Img = Instance.new("ImageLabel")
            Img.Size = UDim2.new(1, 0, 0, sizeY or 100)
            Img.Image = assetId
            Img.BackgroundColor3 = Color3.fromRGB(20,20,20)
            Img.BorderSizePixel = 0
            Img.ScaleType = Enum.ScaleType.Fit
            Img.Parent = AreaFrame
            
            LYui.Elements[id] = {Instance = Img}
            return Img
        end

        -- COMPONENTE: Dropdown (Simples)
        function Area:CreateDropdown(id, text, list, callback)
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1,0,0,25)
            DropFrame.BackgroundColor3 = Color3.fromRGB(30,35,40)
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = AreaFrame

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1,0,0,25)
            Btn.Text = text .. " v"
            Btn.BackgroundColor3 = Color3.fromRGB(40,45,50)
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.Parent = DropFrame

            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1,0,0, #list * 20)
            Container.Position = UDim2.new(0,0,0,25)
            Container.BackgroundTransparency = 1
            Container.Parent = DropFrame

            local layout = Instance.new("UIListLayout")
            layout.Parent = Container

            local open = false
            Btn.MouseButton1Click:Connect(function()
                open = not open
                DropFrame.Size = UDim2.new(1,0,0, open and (25 + #list * 20) or 25)
            end)

            for _, val in ipairs(list) do
                local vBtn = Instance.new("TextButton")
                vBtn.Size = UDim2.new(1,0,0,20)
                vBtn.Text = tostring(val)
                vBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
                vBtn.TextColor3 = Color3.fromRGB(200,200,200)
                vBtn.Parent = Container
                vBtn.MouseButton1Click:Connect(function()
                    Btn.Text = text .. ": " .. tostring(val)
                    open = false
                    DropFrame.Size = UDim2.new(1,0,0,25)
                    callback(val)
                end)
            end

            LYui.Elements[id] = {Instance = DropFrame}
            return DropFrame
        end

        return Area
    end

    return Window
end

return LYui
