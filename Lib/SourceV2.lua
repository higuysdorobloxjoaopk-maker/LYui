-- lib
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local LYui = {}
LYui.Elements = {}

function LYui:Update(id, value)
if LYui.Elements[id] and LYui.Elements[id].Update then
LYui.Elements[id].Update(value)
end
end

function LYui:CreateWindow(config)
local window = {}
local titleText = config.Title or "LYui"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LYui_Interface"
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
Title.Text = titleText
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSans
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0, 25, 0, 25)
CollapseBtn.BackgroundTransparency = 1
CollapseBtn.Text = "▼"
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.TextSize = 10
CollapseBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -25, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, 0, 1, -25)
ContentFrame.Position = UDim2.new(0, 0, 0, 25)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 2
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(35, 58, 95)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = ContentFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.Parent = ContentFrame

local ResizeHandle = Instance.new("Frame")
ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Active = true
ResizeHandle.Parent = MainFrame

local Triangle = Instance.new("TextLabel")
Triangle.Size = UDim2.new(1, 0, 1, 0)
Triangle.Position = UDim2.new(0, 0, 0, 4)
Triangle.BackgroundTransparency = 1
Triangle.Text = "◢"
Triangle.TextColor3 = Color3.fromRGB(35, 58, 95)
Triangle.TextSize = 16
Triangle.Font = Enum.Font.Arial
Triangle.TextXAlignment = Enum.TextXAlignment.Right
Triangle.TextYAlignment = Enum.TextYAlignment.Bottom
Triangle.Parent = ResizeHandle

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

function window:CreateBanner(bConfig)
local BannerFrame = Instance.new("Frame")
BannerFrame.Size = UDim2.new(1, -10, 0, 100)
BannerFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
BannerFrame.BorderSizePixel = 0
BannerFrame.Parent = ContentFrame

local BannerImage = Instance.new("ImageLabel")
BannerImage.Size = UDim2.new(0, 40, 0, 40)
BannerImage.Position = UDim2.new(0, 10, 0, 10)
BannerImage.BackgroundTransparency = 1
BannerImage.Image = bConfig.ImageId or ""
BannerImage.Parent = BannerFrame

local BannerTitle = Instance.new("TextLabel")
BannerTitle.Size = UDim2.new(1, -60, 0, 20)
BannerTitle.Position = UDim2.new(0, 60, 0, 10)
BannerTitle.BackgroundTransparency = 1
BannerTitle.Text = bConfig.Title or ""
BannerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BannerTitle.TextSize = 16
BannerTitle.Font = Enum.Font.SourceSansBold
BannerTitle.TextXAlignment = Enum.TextXAlignment.Left
BannerTitle.Parent = BannerFrame

local BannerDesc = Instance.new("TextLabel")
BannerDesc.Size = UDim2.new(1, -60, 0, 20)
BannerDesc.Position = UDim2.new(0, 60, 0, 30)
BannerDesc.BackgroundTransparency = 1
BannerDesc.Text = bConfig.Description or ""
BannerDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
BannerDesc.TextSize = 12
BannerDesc.Font = Enum.Font.SourceSans
BannerDesc.TextXAlignment = Enum.TextXAlignment.Left
BannerDesc.Parent = BannerFrame

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(1, -20, 0, 25)
DiscordBtn.Position = UDim2.new(0, 10, 0, 65)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.BorderSizePixel = 0
DiscordBtn.Text = "Discord"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.Font = Enum.Font.SourceSansBold
DiscordBtn.TextSize = 14
DiscordBtn.Parent = BannerFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = DiscordBtn

if bConfig.Callback then
DiscordBtn.MouseButton1Click:Connect(bConfig.Callback)
end

if bConfig.Id then
LYui.Elements[bConfig.Id] = {
Type = "Banner",
Update = function(newConfig)
if newConfig.Title then BannerTitle.Text = newConfig.Title end
if newConfig.Description then BannerDesc.Text = newConfig.Description end
if newConfig.ImageId then BannerImage.Image = newConfig.ImageId end
end
}
end
end

function window:CreateArea(areaName)
local area = {}
local AreaFrame = Instance.new("Frame")
AreaFrame.Name = "AreaFrame"
AreaFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
AreaFrame.BorderSizePixel = 0
AreaFrame.Parent = ContentFrame
AreaFrame.Size = UDim2.new(1, -10, 0, 20)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 20)
Header.BackgroundColor3 = Color3.fromRGB(35, 58, 95)
Header.Parent = AreaFrame

local AreaTitle = Instance.new("TextLabel")
AreaTitle.Size = UDim2.new(1, -25, 1, 0)
AreaTitle.Position = UDim2.new(0, 5, 0, 0)
AreaTitle.BackgroundTransparency = 1
AreaTitle.Text = areaName
AreaTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AreaTitle.TextSize = 14
AreaTitle.Font = Enum.Font.SourceSans
AreaTitle.TextXAlignment = Enum.TextXAlignment.Left
AreaTitle.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 20, 1, 0)
MinBtn.Position = UDim2.new(1, -20, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "▼"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 10
MinBtn.Parent = Header

local AreaContent = Instance.new("Frame")
AreaContent.Size = UDim2.new(1, 0, 1, -20)
AreaContent.Position = UDim2.new(0, 0, 0, 20)
AreaContent.BackgroundTransparency = 1
AreaContent.Parent = AreaFrame

local AreaList = Instance.new("UIListLayout")
AreaList.Padding = UDim.new(0, 5)
AreaList.SortOrder = Enum.SortOrder.LayoutOrder
AreaList.Parent = AreaContent

local AreaPadding = Instance.new("UIPadding")
AreaPadding.PaddingLeft = UDim.new(0, 5)
AreaPadding.PaddingTop = UDim.new(0, 5)
AreaPadding.Parent = AreaContent

local isMin = false
local origH = 0

local function UpdateAreaSize()
if not isMin then
local contentH = AreaList.AbsoluteContentSize.Y + AreaPadding.PaddingTop.Offset + AreaPadding.PaddingBottom.Offset
AreaContent.Size = UDim2.new(1, 0, 0, contentH)
AreaFrame.Size = UDim2.new(1, -10, 0, 20 + contentH)
end
end

AreaList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateAreaSize)

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
UpdateAreaSize()
end
end)

function area:CreateLabel(lConfig)
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -10, 0, 15)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = lConfig.Text or ""
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextSize = 14
InfoLabel.Font = Enum.Font.Code
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = AreaContent

if lConfig.Id then
LYui.Elements[lConfig.Id] = {
Type = "Label",
Update = function(newText)
InfoLabel.Text = newText
end
}
end
end

function area:CreateToggle(tConfig)
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Size = UDim2.new(1, -10, 0, 20)
ToggleContainer.BackgroundTransparency = 1
ToggleContainer.Parent = AreaContent

local ToggleBox = Instance.new("Frame")
ToggleBox.Name = "ToggleBox"
ToggleBox.Size = UDim2.new(0, 18, 0, 18)
ToggleBox.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
ToggleBox.BorderColor3 = Color3.fromRGB(40, 50, 70)
ToggleBox.BorderSizePixel = 2
ToggleBox.Parent = ToggleContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleBox

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Text = ""
ToggleButton.Parent = ToggleBox

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Name = "ToggleLabel"
ToggleLabel.Size = UDim2.new(1, -25, 1, 0)
ToggleLabel.Position = UDim2.new(0, 25, 0, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = tConfig.Name or "Toggle"
ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleLabel.TextSize = 14
ToggleLabel.Font = Enum.Font.Code
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = ToggleContainer

local toggled = false

local function setToggle(state)
toggled = state
if toggled then
ToggleBox.BackgroundColor3 = Color3.fromRGB(120, 190, 255)
ToggleBox.BorderColor3 = Color3.fromRGB(35, 58, 95)
else
ToggleBox.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
ToggleBox.BorderColor3 = Color3.fromRGB(40, 50, 70)
end
if tConfig.Callback then
tConfig.Callback(toggled)
end
end

ToggleButton.MouseButton1Click:Connect(function()
setToggle(not toggled)
end)

if tConfig.Id then
LYui.Elements[tConfig.Id] = {
Type = "Toggle",
Update = function(newState)
setToggle(newState)
end
}
end
end

function area:CreateButton(bConfig)
local BtnFrame = Instance.new("Frame")
BtnFrame.Size = UDim2.new(1, -10, 0, 25)
BtnFrame.BackgroundTransparency = 1
BtnFrame.Parent = AreaContent

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundColor3 = Color3.fromRGB(35, 58, 95)
Button.BorderSizePixel = 0
Button.Text = bConfig.Name or "Button"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 14
Button.Font = Enum.Font.SourceSans
Button.Parent = BtnFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = Button

Button.MouseButton1Click:Connect(function()
if bConfig.Callback then
bConfig.Callback()
end
end)

if bConfig.Id then
LYui.Elements[bConfig.Id] = {
Type = "Button",
Update = function(newName)
Button.Text = newName
end
}
end
end

function area:CreateSlider(sConfig)
local SliderContainer = Instance.new("Frame")
SliderContainer.Size = UDim2.new(1, -10, 0, 35)
SliderContainer.BackgroundTransparency = 1
SliderContainer.Parent = AreaContent

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 15)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = sConfig.Name or "Slider"
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.TextSize = 14
SliderLabel.Font = Enum.Font.Code
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = SliderContainer

local ValueLabel = Instance.new("TextLabel")
ValueLabel.Size = UDim2.new(1, 0, 0, 15)
ValueLabel.BackgroundTransparency = 1
ValueLabel.Text = tostring(sConfig.Default or sConfig.Min or 0)
ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ValueLabel.TextSize = 14
ValueLabel.Font = Enum.Font.Code
ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
ValueLabel.Parent = SliderContainer

local SliderBG = Instance.new("Frame")
SliderBG.Size = UDim2.new(1, 0, 0, 6)
SliderBG.Position = UDim2.new(0, 0, 0, 20)
SliderBG.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
SliderBG.BorderSizePixel = 0
SliderBG.Parent = SliderContainer

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(120, 190, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBG

local SliderBtn = Instance.new("TextButton")
SliderBtn.Size = UDim2.new(1, 0, 1, 0)
SliderBtn.BackgroundTransparency = 1
SliderBtn.Text = ""
SliderBtn.Parent = SliderBG

local min = sConfig.Min or 0
local max = sConfig.Max or 100
local def = sConfig.Default or min

local function setSlider(val)
val = math.clamp(val, min, max)
local pct = (val - min) / (max - min)
SliderFill.Size = UDim2.new(pct, 0, 1, 0)
ValueLabel.Text = tostring(math.floor(val))
if sConfig.Callback then
sConfig.Callback(math.floor(val))
end
end

setSlider(def)

local draggingSlider = false

SliderBtn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
draggingSlider = true
local pct = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
setSlider(min + (max - min) * pct)
end
end)

UserInputService.InputChanged:Connect(function(input)
if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local pct = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
setSlider(min + (max - min) * pct)
end
end)

UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
draggingSlider = false
end
end)

if sConfig.Id then
LYui.Elements[sConfig.Id] = {
Type = "Slider",
Update = function(newVal)
setSlider(newVal)
end
}
end
end

function area:CreateDropdown(dConfig)
local DropContainer = Instance.new("Frame")
DropContainer.Size = UDim2.new(1, -10, 0, 25)
DropContainer.BackgroundTransparency = 1
DropContainer.Parent = AreaContent

local MainBtn = Instance.new("TextButton")
MainBtn.Size = UDim2.new(1, 0, 0, 25)
MainBtn.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
MainBtn.BorderSizePixel = 0
MainBtn.Text = dConfig.Name or "Dropdown"
MainBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MainBtn.TextSize = 14
MainBtn.Font = Enum.Font.Code
MainBtn.Parent = DropContainer

local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Size = UDim2.new(1, 0, 0, 0)
ListFrame.Position = UDim2.new(0, 0, 0, 25)
ListFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
ListFrame.BorderSizePixel = 1
ListFrame.BorderColor3 = Color3.fromRGB(40, 50, 70)
ListFrame.ScrollBarThickness = 2
ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.Visible = false
ListFrame.Parent = DropContainer

local dLayout = Instance.new("UIListLayout")
dLayout.Parent = ListFrame

local open = false
local options = dConfig.Options or {}
local multi = dConfig.Multi or false
local selected = {}

local function toggleDrop()
open = not open
if open then
ListFrame.Visible = true
DropContainer.Size = UDim2.new(1, -10, 0, 25 + math.min(100, #options * 20))
ListFrame.Size = UDim2.new(1, 0, 0, math.min(100, #options * 20))
else
ListFrame.Visible = false
DropContainer.Size = UDim2.new(1, -10, 0, 25)
end
UpdateAreaSize()
end

MainBtn.MouseButton1Click:Connect(toggleDrop)

local function populate(opts)
for _, child in ipairs(ListFrame:GetChildren()) do
if child:IsA("TextButton") then child:Destroy() end
end
options = opts
for _, opt in ipairs(options) do
local optBtn = Instance.new("TextButton")
optBtn.Size = UDim2.new(1, 0, 0, 20)
optBtn.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
optBtn.BorderSizePixel = 0
optBtn.Text = opt
optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
optBtn.TextSize = 14
optBtn.Font = Enum.Font.Code
optBtn.Parent = ListFrame

optBtn.MouseButton1Click:Connect(function()
if multi then
if selected[opt] then
selected[opt] = nil
optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
else
selected[opt] = true
optBtn.TextColor3 = Color3.fromRGB(120, 190, 255)
end
if dConfig.Callback then dConfig.Callback(selected) end
else
MainBtn.Text = opt
toggleDrop()
if dConfig.Callback then dConfig.Callback(opt) end
end
end)
end
if open then
DropContainer.Size = UDim2.new(1, -10, 0, 25 + math.min(100, #options * 20))
ListFrame.Size = UDim2.new(1, 0, 0, math.min(100, #options * 20))
UpdateAreaSize()
end
end

if dConfig.Type == "Players" then
local function getPlrs()
local t = {}
for _, p in ipairs(Players:GetPlayers()) do table.insert(t, p.Name) end
return t
end
populate(getPlrs())
Players.PlayerAdded:Connect(function() populate(getPlrs()) end)
Players.PlayerRemoving:Connect(function() populate(getPlrs()) end)
else
populate(options)
end

if dConfig.Id then
LYui.Elements[dConfig.Id] = {
Type = "Dropdown",
Update = function(newOpts)
if type(newOpts) == "table" then populate(newOpts) end
end
}
end
      function area:CreateInput(iConfig)
local InputContainer = Instance.new("Frame")
InputContainer.Size = UDim2.new(1, -10, 0, 30)
InputContainer.BackgroundTransparency = 1
InputContainer.Parent = AreaContent

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(1, 0, 0, 15)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = iConfig.Name or "Input"
InputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InputLabel.TextSize = 14
InputLabel.Font = Enum.Font.Code
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = InputContainer

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, 0, 0, 15)
TextBox.Position = UDim2.new(0, 0, 0, 15)
TextBox.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
TextBox.BorderSizePixel = 0
TextBox.Text = iConfig.Default or ""
TextBox.PlaceholderText = iConfig.Placeholder or ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14
TextBox.Font = Enum.Font.Code
TextBox.ClearTextOnFocus = false
TextBox.Parent = InputContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = TextBox

TextBox.FocusLost:Connect(function(enterPressed)
if iConfig.Callback then
iConfig.Callback(TextBox.Text)
end
end)

if iConfig.Id then
LYui.Elements[iConfig.Id] = {
Type = "Input",
Update = function(newText)
TextBox.Text = tostring(newText)
end
}
end
      end
end
            
function area:CreateColorPicker(cConfig)
local CPContainer = Instance.new("Frame")
CPContainer.Size = UDim2.new(1, -10, 0, 20)
CPContainer.BackgroundTransparency = 1
CPContainer.Parent = AreaContent

local CPLabel = Instance.new("TextLabel")
CPLabel.Size = UDim2.new(1, -30, 1, 0)
CPLabel.BackgroundTransparency = 1
CPLabel.Text = cConfig.Name or "Color Picker"
CPLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CPLabel.TextSize = 14
CPLabel.Font = Enum.Font.Code
CPLabel.TextXAlignment = Enum.TextXAlignment.Left
CPLabel.Parent = CPContainer

local ColorBtn = Instance.new("TextButton")
ColorBtn.Size = UDim2.new(0, 20, 0, 20)
ColorBtn.Position = UDim2.new(1, -20, 0, 0)
ColorBtn.BackgroundColor3 = cConfig.Default or Color3.fromRGB(255, 255, 255)
ColorBtn.BorderSizePixel = 1
ColorBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
ColorBtn.Text = ""
ColorBtn.Parent = CPContainer

local r, g, b = ColorBtn.BackgroundColor3.R, ColorBtn.BackgroundColor3.G, ColorBtn.BackgroundColor3.B

local function updateColor()
local col = Color3.new(r, g, b)
ColorBtn.BackgroundColor3 = col
if cConfig.Callback then cConfig.Callback(col) end
end

ColorBtn.MouseButton1Click:Connect(function()
r, g, b = math.random(), math.random(), math.random()
updateColor()
end)

if cConfig.Id then
LYui.Elements[cConfig.Id] = {
Type = "ColorPicker",
Update = function(newColor)
r, g, b = newColor.R, newColor.G, newColor.B
updateColor()
end
}
end
end

return area
end

return window
end

return LYui
