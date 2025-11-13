local SeizureUI = {}
SeizureUI.__index = SeizureUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function getParent()
	if gethui then
		return gethui()
	elseif RunService:IsStudio() then
		return Players.LocalPlayer:WaitForChild("PlayerGui")
	else
		return CoreGui
	end
end

function SeizureUI:CreateWindow(config)
	local Window = {}
	Window.Config = config or {}
	Window.Title = Window.Config.Title or "SeizureUI"
	Window.Author = Window.Config.Author or "inspired by windui"
	Window.Tabs = {}
	Window.CurrentTab = nil
	Window.Destroyed = false
	
	local uniqueId = tostring(tick()):gsub("%.", "")
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SeizureUI_" .. uniqueId
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 999
	
	local success = pcall(function()
		ScreenGui.Parent = getParent()
	end)
	
	if not success or not ScreenGui.Parent then
		ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
	
	local Background = Instance.new("Frame")
	Background.Name = "Background"
	Background.Parent = ScreenGui
	Background.AnchorPoint = Vector2.new(0.5, 0.5)
	Background.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
	Background.BorderSizePixel = 0
	Background.Position = UDim2.new(0.5, 0, 0.5, 0)
	Background.Size = UDim2.new(0, 0, 0, 0)
	Background.ClipsDescendants = true
	Background.BackgroundTransparency = 1
	
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0.02, 0)
	UICorner.Parent = Background
	
	local horizontalTween = TweenService:Create(Background, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 652, 0, 0),
		BackgroundTransparency = 0
	})
	horizontalTween:Play()
	
	local verticalTween
	horizontalTween.Completed:Connect(function()
		if Window.Destroyed then return end
		verticalTween = TweenService:Create(Background, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 652, 0, 392)
		})
		verticalTween:Play()
	end)
	
	local icon = Instance.new("ImageLabel")
	icon.Name = "icon"
	icon.Parent = Background
	icon.BackgroundTransparency = 1
	icon.Position = UDim2.new(0.02, 0, 0.028, 0)
	icon.Size = UDim2.new(0, 35, 0, 35)
	icon.Image = "rbxassetid://156513166"
	icon.ImageTransparency = 1
	
	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0.2, 0)
	iconCorner.Parent = icon
	
	local title = Instance.new("TextLabel")
	title.Name = "title"
	title.Parent = Background
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0.094, 0, 0.028, 0)
	title.Size = UDim2.new(0, 548, 0, 21)
	title.Font = Enum.Font.GothamBold
	title.Text = Window.Title
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextTransparency = 1
	
	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "subtitle"
	subtitle.Parent = Background
	subtitle.BackgroundTransparency = 1
	subtitle.Position = UDim2.new(0.094, 0, 0.064, 0)
	subtitle.Size = UDim2.new(0, 548, 0, 21)
	subtitle.Font = Enum.Font.Gotham
	subtitle.Text = Window.Author
	subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
	subtitle.TextSize = 12
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.TextTransparency = 1
	
	task.spawn(function()
		task.wait(0.6)
		if Window.Destroyed then return end
		TweenService:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
		TweenService:Create(title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		TweenService:Create(subtitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	end)
	
	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Name = "TabContainer"
	TabContainer.Parent = Background
	TabContainer.BackgroundTransparency = 1
	TabContainer.BorderSizePixel = 0
	TabContainer.Position = UDim2.new(0.019, 0, 0.145, 0)
	TabContainer.Size = UDim2.new(0, 120, 0, 300)
	TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabContainer.ScrollBarThickness = 0
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Parent = TabContainer
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 8)
	
	TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
	end)
	
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Parent = Background
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0.22, 0, 0.143, 0)
	ContentContainer.Size = UDim2.new(0, 492, 0, 320)
	
	-- Fixed dragging system
	local dragging = false
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
		if Window.Destroyed then return end
		local delta = input.Position - dragStart
		Background.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
	
	Background.InputBegan:Connect(function(input)
		if Window.Destroyed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Background.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	Background.InputChanged:Connect(function(input)
		if Window.Destroyed then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if Window.Destroyed then return end
		if input == dragInput and dragging then
			update(input)
		end
	end)
	
	function Window:Destroy()
		if self.Destroyed then return end
		self.Destroyed = true
		
		if horizontalTween then
			horizontalTween:Cancel()
		end
		if verticalTween then
			verticalTween:Cancel()
		end
		
		local closeTween = TweenService:Create(Background, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1
		})
		closeTween:Play()
		closeTween.Completed:Connect(function()
			ScreenGui:Destroy()
		end)
	end
	
	function Window:CreateTab(tabConfig)
		if Window.Destroyed then return end
		
		local Tab = {}
		Tab.Name = tabConfig.Name or "Tab"
		Tab.Elements = {}
		
		local TabButton = Instance.new("TextButton")
		TabButton.Name = "Tab_" .. Tab.Name
		TabButton.Parent = TabContainer
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(1, 0, 0, 21)
		TabButton.Font = Enum.Font.Gotham
		TabButton.Text = Tab.Name
		TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		TabButton.TextSize = 14
		TabButton.TextXAlignment = Enum.TextXAlignment.Left
		TabButton.TextTransparency = 1
		TabButton.AutoButtonColor = false
		
		task.spawn(function()
			task.wait(0.05)
			if Window.Destroyed then return end
			TweenService:Create(TabButton, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		end)
		
		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Name = "Content_" .. Tab.Name
		TabContent.Parent = ContentContainer
		TabContent.BackgroundTransparency = 1
		TabContent.BorderSizePixel = 0
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabContent.ScrollBarThickness = 4
		TabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
		TabContent.Visible = false
		
		local ContentLayout = Instance.new("UIListLayout")
		ContentLayout.Parent = TabContent
		ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContentLayout.Padding = UDim.new(0, 8)
		
		ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
		end)
		
		TabButton.MouseButton1Click:Connect(function()
			if Window.Destroyed then return end
			
			for _, tab in pairs(Window.Tabs) do
				TweenService:Create(tab.Button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
				tab.Content.Visible = false
			end
			
			TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			TabContent.Visible = true
			
			Window.CurrentTab = Tab
		end)
		
		TabButton.MouseEnter:Connect(function()
			if Window.Destroyed then return end
			if TabButton.TextColor3 ~= Color3.fromRGB(255, 255, 255) then
				TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
			end
		end)
		
		TabButton.MouseLeave:Connect(function()
			if Window.Destroyed then return end
			if TabButton.TextColor3 ~= Color3.fromRGB(255, 255, 255) then
				TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
			end
		end)
		
		Tab.Button = TabButton
		Tab.Content = TabContent
		
		if #Window.Tabs == 0 then
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabContent.Visible = true
			Window.CurrentTab = Tab
		end
		
		table.insert(Window.Tabs, Tab)
		
		function Tab:CreateButton(buttonConfig)
			if Window.Destroyed then return end
			
			local buttonFrame = Instance.new("Frame")
			buttonFrame.Name = "Button"
			buttonFrame.Parent = TabContent
			buttonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			buttonFrame.BorderSizePixel = 0
			buttonFrame.Size = UDim2.new(1, 0, 0, 42)
			buttonFrame.BackgroundTransparency = 1
			
			TweenService:Create(buttonFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
			
			local buttonCorner = Instance.new("UICorner")
			buttonCorner.CornerRadius = UDim.new(0.1, 0)
			buttonCorner.Parent = buttonFrame
			
			local buttonLabel = Instance.new("TextLabel")
			buttonLabel.Parent = buttonFrame
			buttonLabel.BackgroundTransparency = 1
			buttonLabel.Position = UDim2.new(0.026, 0, 0, 0)
			buttonLabel.Size = UDim2.new(0.95, 0, 1, 0)
			buttonLabel.Font = Enum.Font.Gotham
			buttonLabel.Text = buttonConfig.Name or "Button"
			buttonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			buttonLabel.TextSize = 14
			buttonLabel.TextXAlignment = Enum.TextXAlignment.Left
			buttonLabel.TextYAlignment = Enum.TextYAlignment.Center
			buttonLabel.TextTransparency = 1
			
			task.spawn(function()
				task.wait(0.1)
				if Window.Destroyed then return end
				TweenService:Create(buttonLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
			end)
			
			local clickButton = Instance.new("TextButton")
			clickButton.Parent = buttonFrame
			clickButton.BackgroundTransparency = 1
			clickButton.Size = UDim2.new(1, 0, 1, 0)
			clickButton.Text = ""
			clickButton.AutoButtonColor = false
			
			clickButton.MouseButton1Click:Connect(function()
				if Window.Destroyed then return end
				
				local originalSize = buttonFrame.Size
				TweenService:Create(buttonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, -4, 0, 38)
				}):Play()
				
				task.spawn(function()
					task.wait(0.1)
					if Window.Destroyed then return end
					TweenService:Create(buttonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = originalSize
					}):Play()
				end)
				
				if buttonConfig.Callback then
					task.spawn(function()
						local success, err = pcall(buttonConfig.Callback)
						if not success then
							warn("[SeizureUI] Button callback error:", err)
						end
					end)
				end
			end)
			
			clickButton.MouseEnter:Connect(function()
				if Window.Destroyed then return end
				TweenService:Create(buttonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(30, 30, 30),
					Size = UDim2.new(1, 0, 0, 44)
				}):Play()
			end)
			
			clickButton.MouseLeave:Connect(function()
				if Window.Destroyed then return end
				TweenService:Create(buttonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(20, 20, 20),
					Size = UDim2.new(1, 0, 0, 42)
				}):Play()
			end)
			
			return buttonFrame
		end
		
		function Tab:CreateToggle(toggleConfig)
			if Window.Destroyed then return end
			
			local toggleFrame = Instance.new("Frame")
			toggleFrame.Name = "Toggle"
			toggleFrame.Parent = TabContent
			toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			toggleFrame.BorderSizePixel = 0
			toggleFrame.Size = UDim2.new(1, 0, 0, 42)
			toggleFrame.BackgroundTransparency = 1
			
			TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
			
			local toggleCorner = Instance.new("UICorner")
			toggleCorner.CornerRadius = UDim.new(0.1, 0)
			toggleCorner.Parent = toggleFrame
			
			local toggleLabel = Instance.new("TextLabel")
			toggleLabel.Parent = toggleFrame
			toggleLabel.BackgroundTransparency = 1
			toggleLabel.Position = UDim2.new(0.026, 0, 0, 0)
			toggleLabel.Size = UDim2.new(0.85, 0, 1, 0)
			toggleLabel.Font = Enum.Font.Gotham
			toggleLabel.Text = toggleConfig.Name or "Toggle"
			toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			toggleLabel.TextSize = 14
			toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			toggleLabel.TextYAlignment = Enum.TextYAlignment.Center
			toggleLabel.TextTransparency = 1
			
			task.spawn(function()
				task.wait(0.1)
				if Window.Destroyed then return end
				TweenService:Create(toggleLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
			end)
			
			local toggleState = toggleConfig.Default or false
			
			local checkBox = Instance.new("Frame")
			checkBox.Parent = toggleFrame
			checkBox.AnchorPoint = Vector2.new(1, 0.5)
			checkBox.BackgroundColor3 = toggleState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
			checkBox.BorderSizePixel = 0
			checkBox.Position = UDim2.new(0.975, 0, 0.5, 0)
			checkBox.Size = UDim2.new(0, 20, 0, 20)
			
			local checkCorner = Instance.new("UICorner")
			checkCorner.CornerRadius = UDim.new(0.2, 0)
			checkCorner.Parent = checkBox
			
			local checkMark = Instance.new("TextLabel")
			checkMark.Parent = checkBox
			checkMark.BackgroundTransparency = 1
			checkMark.Position = UDim2.new(0, 0, 0, -1)
			checkMark.Size = UDim2.new(1, 0, 1, 0)
			checkMark.Font = Enum.Font.GothamBold
			checkMark.Text = "✓"
			checkMark.TextColor3 = Color3.fromRGB(0, 0, 0)
			checkMark.TextSize = 16
			checkMark.TextTransparency = toggleState and 0 or 1
			
			local clickButton = Instance.new("TextButton")
			clickButton.Parent = toggleFrame
			clickButton.BackgroundTransparency = 1
			clickButton.Size = UDim2.new(1, 0, 1, 0)
			clickButton.Text = ""
			clickButton.AutoButtonColor = false
			
			clickButton.MouseButton1Click:Connect(function()
				if Window.Destroyed then return end
				
				toggleState = not toggleState
				
				TweenService:Create(checkBox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = toggleState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
				}):Play()
				
				TweenService:Create(checkMark, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					TextTransparency = toggleState and 0 or 1
				}):Play()
				
				if toggleConfig.Callback then
					task.spawn(function()
						local success, err = pcall(toggleConfig.Callback, toggleState)
						if not success then
							warn("[SeizureUI] Toggle callback error:", err)
						end
					end)
				end
			end)
			
			clickButton.MouseEnter:Connect(function()
				if Window.Destroyed then return end
				TweenService:Create(toggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				}):Play()
			end)
			
			clickButton.MouseLeave:Connect(function()
				if Window.Destroyed then return end
				TweenService:Create(toggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				}):Play()
			end)
			
			return toggleFrame
		end
		
		return Tab
	end
	
	return Window
end

return SeizureUI
