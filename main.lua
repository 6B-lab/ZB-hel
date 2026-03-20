-- [[ ZB PREMIUM V16 - NO OVERLAP FIX ]] --
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- ลบ UI เก่า
if CoreGui:FindFirstChild("ZB_Ultimate_V16") then
    CoreGui.ZB_Ultimate_V16:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ZB_Ultimate_V16"
ScreenGui.ResetOnSpawn = false

-- ค่าเริ่มต้น
_G.AutoGreen = false
_G.AutoKill = false
_G.Distance = 100
_G.Buffs = false

-- [[ 1. หน้าต่างหลัก ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 320)
Main.Position = UDim2.new(0.1, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 150)

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "ZB HUB V16"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize System (Circle)
local CircleIcon = Instance.new("TextButton", ScreenGui)
CircleIcon.Size = UDim2.new(0, 45, 0, 45)
CircleIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
CircleIcon.Text = "ZB"
CircleIcon.TextColor3 = Color3.fromRGB(0, 255, 150)
CircleIcon.Visible = false
CircleIcon.Draggable = true
Instance.new("UICorner", CircleIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", CircleIcon).Color = Color3.fromRGB(0, 255, 150)

local MiniBtn = Instance.new("TextButton", Header)
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -35, 0, 5)
MiniBtn.Text = "-"
MiniBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MiniBtn.TextColor3 = Color3.new(1,1,1)
MiniBtn.MouseButton1Click:Connect(function() Main.Visible = false CircleIcon.Visible = true end)
CircleIcon.MouseButton1Click:Connect(function() Main.Visible = true CircleIcon.Visible = false end)

-- [[ 2. ตัวจัดระเบียบปุ่ม (Scroll & List) ]] --
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y -- ขยายขนาดอัตโนมัติตามปุ่ม

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder -- เรียงตามลำดับการสร้าง

-- [[ 3. ฟังก์ชันสร้าง Slider (แบบไม่ทับกัน) ]] --
local function AddSlider(text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", Scroll)
    SliderFrame.Size = UDim2.new(0.9, 0, 0, 50) -- กำหนดขนาดแน่นอน
    SliderFrame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham

    local Bar = Instance.new("TextButton", SliderFrame)
    Bar.Size = UDim2.new(1, 0, 0, 6)
    Bar.Position = UDim2.new(0, 0, 0, 30) -- เว้นจากตัวหนังสือ
    Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Bar.Text = ""
    Instance.new("UICorner", Bar)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    Instance.new("UICorner", Fill)

    Bar.MouseButton1Down:Connect(function()
        local moveConn
        moveConn = game:GetService("RunService").RenderStepped:Connect(function()
            local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
            local percent = math.clamp((mousePos - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(min + (max - min) * percent)
            Label.Text = text .. ": " .. val
            callback(val)
        end)
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then moveConn:Disconnect() end
        end)
    end)
end

-- [[ 4. ฟังก์ชันสร้างปุ่ม Toggle (แบบไม่ทับกัน) ]] --
local function AddToggle(text, callback)
    local state = false
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 40) -- กำหนดความสูงแน่นอน
    btn.Text = text .. " : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " : ON ✅" or " : OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(30, 30, 30)
        callback(state)
    end)
end

--- [[ ลำดับการสร้างปุ่ม (จะเรียงจากบนลงล่าง) ]] ---

AddSlider("DISTANCE (ระยะการทำงาน)", 10, 500, 100, function(v) _G.Distance = v end)

AddToggle("AUTO CLICK GREEN", function(s)
    _G.AutoGreen = s
    task.spawn(function()
        while _G.AutoGreen do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ClickDetector") then
                        local p = v.Parent
                        if (p.Color.g > p.Color.r and p.Color.g > 0.4) or p.Name:lower():find("green") then
                            if (player.Character.HumanoidRootPart.Position - p.Position).Magnitude < _G.Distance then
                                fireclickdetector(v)
                            end
                        end
                    end
                end
            end)
            task.wait(0.2)
        end
    end)
end)

AddToggle("AUTO KILL ZOMBIE", function(s)
    _G.AutoKill = s
    task.spawn(function()
        while _G.AutoKill do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then
                        local root = v:FindFirstChild("HumanoidRootPart")
                        if root and (player.Character.HumanoidRootPart.Position - root.Position).Magnitude < _G.Distance then
                            v.Humanoid.Health = 0
                        end
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end)

AddToggle("BUFF SPEED & JUMP", function(s)
    _G.Buffs = s
end)

-- Loop ระบบบัฟ
game:GetService("RunService").Heartbeat:Connect(function()
    if _G.Buffs and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 60
        player.Character.Humanoid.JumpPower = 100
    end
end)

print("ZB V16 Loaded - Overlap Issues Resolved!")
