-- NotificationLib
local Notify = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

Notify.Enabled = true
Notify.Notifications = {}

local screen = Instance.new("ScreenGui")
screen.Name = "NotifyLib"
screen.ResetOnSpawn = false
screen.Parent = guiParent

local holder = Instance.new("Frame")
holder.AnchorPoint = Vector2.new(1,1)
holder.Position = UDim2.new(1,-10,1,-120)
holder.Size = UDim2.new(0,420,1,0)
holder.BackgroundTransparency = 1
holder.Parent = screen

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
layout.Parent = holder

function Notify:SetEnabled(bool)
    Notify.Enabled = bool
end

function Notify:Close(frame)

    TweenService:Create(
        frame,
        TweenInfo.new(0.25),
        {Size = UDim2.new(0,420,0,0)}
    ):Play()

    task.wait(0.25)

    frame:Destroy()
end

function Notify:Create(data)

    if not Notify.Enabled then return end

    data = data or {}

    local name = data.Name or "Name"
    local title = data.Title or "Title"
    local desc = data.Description or "Description"

    local image = data.Image
    local buttons = data.Buttons or {}

    local life = data.LifeTime or 6

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,420,0,0)
    frame.BackgroundColor3 = Color3.fromRGB(8,12,18)
    frame.BorderSizePixel = 0
    frame.Parent = holder

    TweenService:Create(
        frame,
        TweenInfo.new(0.25),
        {Size = UDim2.new(0,420,0,150)}
    ):Play()

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1,0,0,35)
    top.BackgroundColor3 = Color3.fromRGB(40,65,100)
    top.BorderSizePixel = 0
    top.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0,40,1,0)
    close.Text = "▶"
    close.TextScaled = true
    close.BackgroundTransparency = 1
    close.Parent = top

    close.MouseButton1Click:Connect(function()
        Notify:Close(frame)
    end)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = name
    nameLabel.Size = UDim2.new(1,-40,1,0)
    nameLabel.Position = UDim2.new(0,40,0,0)
    nameLabel.TextColor3 = Color3.new(1,1,1)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextScaled = true
    nameLabel.Parent = top

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1,0,1,-35)
    content.Position = UDim2.new(0,0,0,35)
    content.BackgroundTransparency = 1
    content.Parent = frame

    local offset = 10

    if image then

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0,90,0,90)
        icon.Position = UDim2.new(0,10,0,10)
        icon.BackgroundTransparency = 1
        icon.Image = image
        icon.Parent = content

        offset = 110

    end

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1,-offset-10,0,40)
    titleLabel.Position = UDim2.new(0,offset,0,5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = content

    local descLabel = Instance.new("TextLabel")
    descLabel.Text = desc
    descLabel.Size = UDim2.new(1,-offset-10,0,30)
    descLabel.Position = UDim2.new(0,offset,0,45)
    descLabel.BackgroundTransparency = 1
    descLabel.TextColor3 = Color3.fromRGB(200,200,200)
    descLabel.TextScaled = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = content

    local buttonHolder = Instance.new("Frame")
    buttonHolder.Size = UDim2.new(1,-offset-10,0,35)
    buttonHolder.Position = UDim2.new(0,offset,1,-40)
    buttonHolder.BackgroundTransparency = 1
    buttonHolder.Parent = content

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.Padding = UDim.new(0,10)
    btnLayout.Parent = buttonHolder

    for _,b in pairs(buttons) do

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,120,1,0)
        btn.Text = b.Text or "Button"
        btn.BackgroundColor3 = Color3.fromRGB(40,65,100)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Parent = buttonHolder

        btn.MouseButton1Click:Connect(function()

            if b.Callback then
                pcall(b.Callback)
            end

            Notify:Close(frame)

        end)

    end

    if life then
        task.delay(life,function()
            if frame.Parent then
                Notify:Close(frame)
            end
        end)
    end

end

return Notify
