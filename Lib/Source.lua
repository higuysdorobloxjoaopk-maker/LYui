-- LYui Library (Atualizado com IDs obrigatórios + Manipulação por ID + Novos elementos completos)

local LYui = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

function LYui:CreateWindow(titleText)
	local Window = {}
	Window.Elements = {}  -- Armazena todos os elementos por ID para manipulação externa

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

	-- Resize Handle (TRIÂNGULO AJUSTADO - agora encosta perfeitamente no canto inferior direito)
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
	Triangle.TextSize = 24  
	Triangle.Font = Enum.Font.Arial  
	Triangle.TextXAlignment = Enum.TextXAlignment.Right  
	Triangle.TextYAlignment = Enum.TextYAlignment.Bottom  
	Triangle.AnchorPoint = Vector2.new(1,1)  
	Triangle.Position = UDim2.new(1,-2,1,-2)  
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

	-- ==================== CREATE AREA ====================
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

		-- ==================== REGISTRO DE ELEMENTOS POR ID ====================
		local function registerElement(id, data)
			if not id or typeof(id) \~= "string" then
				error("❌ Element ID deve ser uma string!")
			end
			if Window.Elements[id] then
				error("❌ ID já em uso: " .. id)
			end
			Window.Elements[id] = data
		end

		-- ==================== ELEMENTOS EXISTENTES (AGORA COM ID OBRIGATÓRIO) ====================
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

			local elementData = {
				Type = "Label",
				Frame = InfoLabel,
				SetText = function(newText) InfoLabel.Text = newText end,
				GetText = function() return InfoLabel.Text end,
				Destroy = function() InfoLabel:Destroy() Window.Elements[id] = nil end
			}
			registerElement(id, elementData)
			updateHeight()
			return InfoLabel
		end  

		function Area:CreateToggle(id, toggleText, callback)
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
				if callback then callback(toggled) end  
			end)  

			local elementData = {
				Type = "Toggle",
				Frame = ToggleContainer,
				ToggleBox = ToggleBox,
				GetState = function() return toggled end,
				SetState = function(state)
					toggled = state
					if toggled then
						ToggleBox.BackgroundColor3 = Color3.fromRGB(120,190,255)
						ToggleBox.BorderColor3 = Color3.fromRGB(35,58,95)
					else
						ToggleBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
						ToggleBox.BorderColor3 = Color3.fromRGB(40,50,70)
					end
					if callback then callback(toggled) end
				end,
				Toggle = function()
					elementData.SetState(not toggled)
				end,
				Destroy = function()
					ToggleContainer:Destroy()
					Window.Elements[id] = nil
				end
			}
			registerElement(id, elementData)
			updateHeight()
			return ToggleContainer
		end  

		-- ==================== NOVOS ELEMENTOS COMPLETOS ====================

		-- Button
		function Area:CreateButton(id, buttonText, callback)
			local ButtonContainer = Instance.new("Frame")
			ButtonContainer.Size = UDim2.new(1,-10,0,25)
			ButtonContainer.BackgroundTransparency = 1
			ButtonContainer.Parent = AreaContent

			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1,0,1,0)
			Btn.BackgroundColor3 = Color3.fromRGB(35,58,95)
			Btn.Text = buttonText or "Button"
			Btn.TextColor3 = Color3.fromRGB(255,255,255)
			Btn.TextSize = 14
			Btn.Font = Enum.Font.SourceSans
			Btn.Parent = ButtonContainer
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0,4)
			corner.Parent = Btn

			Btn.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)

			local elementData = {
				Type = "Button",
				Frame = ButtonContainer,
				Button = Btn,
				SetText = function(txt) Btn.Text = txt end,
				Destroy = function() ButtonContainer:Destroy() Window.Elements[id] = nil end
			}
			registerElement(id, elementData)
			updateHeight()
			return Btn
		end

		-- TextBox (Caixa de Texto)
		function Area:CreateTextBox(id, placeholder, callback)
			local TextContainer = Instance.new("Frame")
			TextContainer.Size = UDim2.new(1,-10,0,25)
			TextContainer.BackgroundTransparency = 1
			TextContainer.Parent = AreaContent

			local TextBox = Instance.new("TextBox")
			TextBox.Size = UDim2.new(1,0,1,0)
			TextBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
			TextBox.PlaceholderText = placeholder or "Digite aqui..."
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(200,200,200)
			TextBox.PlaceholderColor3 = Color3.fromRGB(100,100,100)
			TextBox.TextSize = 14
			TextBox.Font = Enum.Font.Code
			TextBox.ClearTextOnFocus = false
			TextBox.Parent = TextContainer
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0,4)
			corner.Parent = TextBox

			TextBox.FocusLost:Connect(function()
				if callback then callback(TextBox.Text) end
			end)

			local elementData = {
				Type = "TextBox",
				Frame = TextContainer,
				TextBox = TextBox,
				SetText = function(txt) TextBox.Text = txt end,
				GetText = function() return TextBox.Text end,
				Destroy = function() TextContainer:Destroy() Window.Elements[id] = nil end
			}
			registerElement(id, elementData)
			updateHeight()
			return TextBox
		end

		-- Checkbox
		function Area:CreateCheckbox(id, checkboxText, callback)
			local CheckContainer = Instance.new("Frame")
			CheckContainer.Size = UDim2.new(1,-10,0,20)
			CheckContainer.BackgroundTransparency = 1
			CheckContainer.Parent = AreaContent

			local CheckBox = Instance.new("Frame")
			CheckBox.Size = UDim2.new(0,18,0,18)
			CheckBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
			CheckBox.BorderColor3 = Color3.fromRGB(40,50,70)
			CheckBox.BorderSizePixel = 2
			CheckBox.Parent = CheckContainer
			local UICorner2 = Instance.new("UICorner")
			UICorner2.CornerRadius = UDim.new(0,3)
			UICorner2.Parent = CheckBox

			local CheckMark = Instance.new("TextLabel")
			CheckMark.Size = UDim2.new(1,0,1,0)
			CheckMark.BackgroundTransparency = 1
			CheckMark.Text = "✓"
			CheckMark.TextColor3 = Color3.fromRGB(255,255,255)
			CheckMark.TextSize = 16
			CheckMark.Visible = false
			CheckMark.Parent = CheckBox

			local CheckLabel = Instance.new("TextLabel")
			CheckLabel.Size = UDim2.new(1,-25,1,0)
			CheckLabel.Position = UDim2.new(0,25,0,0)
			CheckLabel.BackgroundTransparency = 1
			CheckLabel.Text = checkboxText
			CheckLabel.TextColor3 = Color3.fromRGB(200,200,200)
			CheckLabel.TextSize = 14
			CheckLabel.Font = Enum.Font.Code
			CheckLabel.TextXAlignment = Enum.TextXAlignment.Left
			CheckLabel.Parent = CheckContainer

			local checkButton = Instance.new("TextButton")
			checkButton.Size = UDim2.new(1,0,1,0)
			checkButton.BackgroundTransparency = 1
			checkButton.Parent = CheckBox

			local checked = false
			checkButton.MouseButton1Click:Connect(function()
				checked = not checked
				CheckMark.Visible = checked
				if checked then
					CheckBox.BackgroundColor3 = Color3.fromRGB(120,190,255)
				else
					CheckBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
				end
				if callback then callback(checked) end
			end)

			local elementData = {
				Type = "Checkbox",
				Frame = CheckContainer,
				GetState = function() return checked end,
				SetState = function(state)
					checked = state
					CheckMark.Visible = state
					if state then
						CheckBox.BackgroundColor3 = Color3.fromRGB(120,190,255)
					else
						CheckBox.BackgroundColor3 = Color3.fromRGB(25,35,50)
					end
					if callback then callback(checked) end
				end,
				Toggle = function()
					elementData.SetState(not checked)
				end,
				Destroy = function()
					CheckContainer:Destroy()
					Window.Elements[id] = nil
				end
			}
			registerElement(id, elementData)
			updateHeight()
			return CheckContainer
		end

		-- Dropdown
		function Area:CreateDropdown(id, defaultOption, options, callback)
			if typeof(options) \~= "table" then options = {} end
			local selected = defaultOption or (options[1] or "Selecionar...")

			local DropContainer = Instance.new("Frame")
			DropContainer.Size = UDim2.new(1,-10,0,25)
			DropContainer.BackgroundTransparency = 1
			DropContainer.Parent = AreaContent

			local DropButton = Instance.new("TextButton")
			DropButton.Size = UDim2.new(1,0,1,0)
			DropButton.BackgroundColor3 = Color3.fromRGB(25,35,50)
			DropButton.Text = selected
			DropButton.TextColor3 = Color3.fromRGB(200,200,200)
			DropButton.TextSize = 14
			DropButton.Font = Enum.Font.Code
			DropButton.TextXAlignment = Enum.TextXAlignment.Left
			DropButton.Parent = DropContainer
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0,4)
			corner.Parent = DropButton

			local arrow = Instance.new("TextLabel")
			arrow.Size = UDim2.new(0,20,1,0)
			arrow.Position = UDim2.new(1,-20,0,0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "▼"
			arrow.TextColor3 = Color3.fromRGB(255,255,255)
			arrow.Parent = DropButton

			local dropdownList = nil
			local function closeDropdown()
				if dropdownList then dropdownList:Destroy() dropdownList = nil end
			end

			local function openDropdown()
				closeDropdown()
				dropdownList = Instance.new("Frame")
				dropdownList.BackgroundColor3 = Color3.fromRGB(20,25,30)
				dropdownList.BorderSizePixel = 1
				dropdownList.BorderColor3 = Color3.fromRGB(60,60,60)
				dropdownList.Size = UDim2.new(0, DropButton.AbsoluteSize.X, 0, #options * 25 + 10)
				dropdownList.Position = UDim2.new(0, DropButton.AbsolutePosition.X, 0, DropButton.AbsolutePosition.Y + DropButton.AbsoluteSize.Y)
				dropdownList.Parent = ScreenGui

				local listLayout = Instance.new("UIListLayout")
				listLayout.Padding = UDim.new(0,2)
				listLayout.Parent = dropdownList

				for _, opt in ipairs(options) do
					local optBtn = Instance.new("TextButton")
					optBtn.Size = UDim2.new(1,0,0,22)
					optBtn.BackgroundColor3 = Color3.fromRGB(25,35,50)
					optBtn.Text = opt
					optBtn.TextColor3 = Color3.fromRGB(200,200,200)
					optBtn.TextSize = 14
					optBtn.Parent = dropdownList
					local c = Instance.new("UICorner")
					c.CornerRadius = UDim.new(0,3)
					c.Parent = optBtn

					optBtn.MouseButton1Click:Connect(function()
						selected = opt
						DropButton.Text = selected
						closeDropdown()
						if callback then callback(selected) end
					end)
				end
			end

			DropButton.MouseButton1Click:Connect(function()
				if dropdownList then closeDropdown() else openDropdown() end
			end)

			local elementData = {
				Type = "Dropdown",
				Frame = DropContainer,
				GetSelected = function() return selected end,
				SetSelected = function(newOpt)
					selected = newOpt
					DropButton.Text = newOpt
					if callback then callback(newOpt) end
				end,
				Destroy = function()
					closeDropdown()
					DropContainer:Destroy()
					Window.Elements[id] = nil
				end
			}
			registerElement(id, elementData)
			updateHeight()
			return DropButton
		end

		-- PlayersListDropdown
		function Area:CreatePlayerDropdown(id, callback)
			local selectedPlayer = nil

			local DropContainer = Instance.new("Frame")
			DropContainer.Size = UDim2.new(1,-10,0,25)
			DropContainer.BackgroundTransparency = 1
			DropContainer.Parent = AreaContent

			local DropButton = Instance.new("TextButton")
			DropButton.Size = UDim2.new(1,0,1,0)
			DropButton.BackgroundColor3 = Color3.fromRGB(25,35,50)
			DropButton.Text = "Selecionar Jogador"
			DropButton.TextColor3 = Color3.fromRGB(200,200,200)
			DropButton.TextSize = 14
			DropButton.Font = Enum.Font.Code
			DropButton.TextXAlignment = Enum.TextXAlignment.Left
			DropButton.Parent = DropContainer
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0,4)
			corner.Parent = DropButton

			local arrow = Instance.new("TextLabel")
			arrow.Size = UDim2.new(0,20,1,0)
			arrow.Position = UDim2.new(1,-20,0,0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "▼"
			arrow.TextColor3 = Color3.fromRGB(255,255,255)
			arrow.Parent = DropButton

			local dropdownList = nil
			local function closeDropdown()
				if dropdownList then dropdownList:Destroy() dropdownList = nil end
			end

			local function openDropdown()
				closeDropdown()
				local playerList = {}
				for _, plr in ipairs(Players:GetPlayers()) do
					table.insert(playerList, plr.Name)
				end

				dropdownList = Instance.new("Frame")
				dropdownList.BackgroundColor3 = Color3.fromRGB(20,25,30)
				dropdownList.BorderSizePixel = 1
				dropdownList.BorderColor3 = Color3.fromRGB(60,60,60)
				dropdownList.Size = UDim2.new(0, DropButton.AbsoluteSize.X, 0, #playerList * 25 + 10)
				dropdownList.Position = UDim2.new(0, DropButton.AbsolutePosition.X, 0, DropButton.AbsolutePosition.Y + DropButton.AbsoluteSize.Y)
				dropdownList.Parent = ScreenGui

				local listLayout = Instance.new("UIListLayout")
				listLayout.Padding = UDim.new(0,2)
				listLayout.Parent = dropdownList

				for _, name in ipairs(playerList) do
					local optBtn = Instance.new("TextButton")
					optBtn.Size = UDim2.new(1,0,0,22)
					optBtn.BackgroundColor3 = Color3.fromRGB(25,35,50)
					optBtn.Text = name
					optBtn.TextColor3 = Color3.fromRGB(200,200,200)
					optBtn.TextSize = 14
					optBtn.Parent = dropdownList
					local c = Instance.new("UICorner")
					c.CornerRadius = UDim.new(0,3)
					c.Parent = optBtn

					optBtn.MouseButton1Click:Connect(function()
						selectedPlayer = Players:FindFirstChild(name)
						DropButton.Text = name
						closeDropdown()
						if callback and selectedPlayer then callback(selectedPlayer) end
					end)
				end
			end

			DropButton.MouseButton1Click:Connect(function()
				if dropdownList then closeDropdown() else openDropdown() end
			end)

			local elementData = {
				Type = "PlayerDropdown",
				Frame = DropContainer,
				GetSelected = function() return selectedPlayer end,
				Destroy = function()
					closeDropdown()
					DropContainer:Destroy()
					Window.Elements[id] = nil
				end
			}
			registerElement(id, elementData)
			updateHeight()
			return DropButton
		end

		-- ImageLabel
		function Area:CreateImageLabel(id, imageId, height)
			local ImgContainer = Instance.new("Frame")
			ImgContainer.Size = UDim2.new(1,-10,0, height or 100)
			ImgContainer.BackgroundTransparency = 1
			ImgContainer.Parent = AreaContent

			local Img = Instance.new("ImageLabel")
			Img.Size = UDim2.new(1,0,1,0)
			Img.BackgroundTransparency = 1
			Img.Image = imageId
			Img.Parent = ImgContainer

			local elementData = {
				Type = "ImageLabel",
				Frame = ImgContainer,
				ImageLabel = Img,
				SetImage = function(newId) Img.Image = newId end,
				Destroy = function() ImgContainer:Destroy() Window.Elements[id] = nil end
			}
			registerElement(id, elementData)
			updateHeight()
			return Img
		end

		-- Banner
		function Area:CreateBanner(id, bannerText, color)
			local BannerFrame = Instance.new("Frame")
			BannerFrame.Size = UDim2.new(1,-10,0,30)
			BannerFrame.BackgroundColor3 = color or Color3.fromRGB(35,58,95)
			BannerFrame.Parent = AreaContent

			local BannerLabel = Instance.new("TextLabel")
			BannerLabel.Size = UDim2.new(1,0,1,0)
			BannerLabel.BackgroundTransparency = 1
			BannerLabel.Text = bannerText or "Banner"
			BannerLabel.TextColor3 = Color3.fromRGB(255,255,255)
			BannerLabel.TextSize = 16
			BannerLabel.Font = Enum.Font.SourceSansBold
			BannerLabel.Parent = BannerFrame

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0,4)
			corner.Parent = BannerFrame

			local elementData = {
				Type = "Banner",
				Frame = BannerFrame,
				SetText = function(txt) BannerLabel.Text = txt end,
				SetColor = function(col) BannerFrame.BackgroundColor3 = col end,
				Destroy = function() BannerFrame:Destroy() Window.Elements[id] = nil end
			}
			registerElement(id, elementData)
			updateHeight()
			return BannerFrame
		end

		-- Color Picker (RGB completo + preview)
		function Area:CreateColorPicker(id, defaultColor, callback)
			defaultColor = defaultColor or Color3.fromRGB(255,255,255)
			local current = {R = math.floor(defaultColor.R*255), G = math.floor(defaultColor.G*255), B = math.floor(defaultColor.B*255)}

			local CPContainer = Instance.new("Frame")
			CPContainer.Size = UDim2.new(1,-10,0,130)
			CPContainer.BackgroundTransparency = 1
			CPContainer.Parent = AreaContent

			-- Preview
			local Preview = Instance.new("Frame")
			Preview.Size = UDim2.new(0,60,0,60)
			Preview.BackgroundColor3 = defaultColor
			Preview.Parent = CPContainer
			local pcorner = Instance.new("UICorner")
			pcorner.CornerRadius = UDim.new(0,8)
			pcorner.Parent = Preview

			local function updatePreview()
				local col = Color3.fromRGB(current.R, current.G, current.B)
				Preview.BackgroundColor3 = col
				if callback then callback(col) end
			end

			local function createInput(channel, posY)
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(0,15,0,20)
				lbl.Position = UDim2.new(0,0,0,posY)
				lbl.BackgroundTransparency = 1
				lbl.Text = channel
				lbl.TextColor3 = Color3.fromRGB(255,255,255)
				lbl.Parent = CPContainer

				local tb = Instance.new("TextBox")
				tb.Size = UDim2.new(0,45,0,20)
				tb.Position = UDim2.new(0,20,0,posY)
				tb.BackgroundColor3 = Color3.fromRGB(25,35,50)
				tb.Text = tostring(current[channel])
				tb.TextColor3 = Color3.fromRGB(200,200,200)
				tb.Parent = CPContainer
				local c = Instance.new("UICorner")
				c.CornerRadius = UDim.new(0,4)
				c.Parent = tb

				tb.FocusLost:Connect(function()
					local v = tonumber(tb.Text) or 0
					v = math.clamp(v, 0, 255)
					tb.Text = tostring(v)
					current[channel] = v
					updatePreview()
				end)
				return tb
			end

			local rBox = createInput("R", 70)
			local gBox = createInput("G", 95)
			local bBox = createInput("B", 120)

			local elementData = {
				Type = "ColorPicker",
				Frame = CPContainer,
				GetColor = function() return Preview.BackgroundColor3 end,
				SetColor = function(col)
					current.R = math.floor(col.R * 255)
					current.G = math.floor(col.G * 255)
					current.B = math.floor(col.B * 255)
					rBox.Text = tostring(current.R)
					gBox.Text = tostring(current.G)
					bBox.Text = tostring(current.B)
					Preview.BackgroundColor3 = col
					if callback then callback(col) end
				end,
				Destroy = function()
					CPContainer:Destroy()
					Window.Elements[id] = nil
				end
			}
			registerElement(id, elementData)
			updatePreview()
			updateHeight()
			return CPContainer
		end

		-- ==================== MANIPULAÇÃO GLOBAL POR ID (disponível no Window) ====================
		function Window:SetToggle(id, state)
			local elem = Window.Elements[id]
			if elem and (elem.Type == "Toggle" or elem.Type == "Checkbox") and elem.SetState then
				elem.SetState(state)
			end
		end

		function Window:Toggle(id)
			local elem = Window.Elements[id]
			if elem and (elem.Type == "Toggle" or elem.Type == "Checkbox") and elem.Toggle then
				elem.Toggle()
			end
		end

		function Window:DeleteElement(id)
			local elem = Window.Elements[id]
			if elem and elem.Destroy then
				elem.Destroy()
			end
		end

		function Window:GetElement(id)
			return Window.Elements[id]
		end

		return Area
	end

	return Window
end

return LYui
