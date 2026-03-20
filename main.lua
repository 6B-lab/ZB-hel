-- [[ ZB PREMIUM V14 - THE REAL FIX (SLIDER & SCANNER) ]] --
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- ลบ UI เก่า
if CoreGui:FindFirstChild("ZB_Ultimate_V14") then
    CoreGui.ZB_Ultimate_V14:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ZB_Ultimate_V14"
ScreenGui.ResetOnSpawn = false

-- ค่าเริ่มต้น (Settings)
_G.AutoGreen = false
_G.AutoKill = false
_G.Distance = 50 -- ระยะเริ่มต้น
_G.Speed = 16
_G.Jump = 50

-- [[ UI Main Menu ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 380)
Main.Position = UDim2.new(0.1, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 2

-- Header & Minimize Logic
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "ZB HUB V14 (PRO)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

-- Minimize Icon
local CircleIcon = Instance.new("TextButton", ScreenGui)
CircleIcon.Size = UDim2.new(0, 45, 0, 45)
CircleIcon.Position = UDim2.new(0, 20, 0, 20)
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

-- [[ ส่วนของ Slider ปรับระยะ ]] --
local function AddSlider(text, min, max, default, callback)
    local Label = Instance.new("TextLabel", Main)
    Label.Size = UDim2.new(0.9, 0, 0, 20)
    Label.Position = UDim2.new(0.05, 0, 0, 50 + (#Main:GetChildren() * 25))
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham

    local SliderFrame = Instance.new("TextButton", Main)
    SliderFrame.Size = UDim2.new(0.9, 0, 0, 5)
    SliderFrame.Position = UDim2.new(0.05, 0, 0, Label.Position.Y.Offset + 22)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderFrame.Text = ""

    local SliderBar = Instance.new("Frame", SliderFrame)
    SliderBar.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    SliderBar.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

    SliderFrame.MouseButton1Down:Connect(function()
        local moveConn
        moveConn = game:GetService("RunService").RenderStepped:Connect(function()
            local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
            local framePos = SliderFrame.AbsolutePosition.X
            local frameSize = SliderFrame.AbsoluteSize.X
            local percent = math.clamp((mousePos - framePos) / frameSize, 0, 1)
            SliderBar.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(min + (max - min) * percent)
            Label.Text = text .. ": " .. val
            callback(val)
        end)
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then moveConn:Disconnect() end
        end)
    end)
end

-- [[ ใส่ปุ่ม Toggle ]] --
local function AddToggle(text, callback)
    local state = false
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, 120 + (#Main:GetChildren() * 10))
    btn.Text = text .. " : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " : ON ✅" or " : OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(30, 30, 30)
        callback(state)
    end)
end

-- 1. Slider ปรับระยะการทำงาน
AddSlider("SCAN DISTANCE", 10, 500, 50, function(v) _G.Distance = v end)

-- 2. Auto Green (The Real Fix)
AddToggle("AUTO ACCEPT (EVERYWHERE)", function(s)
    _G.AutoGreen = s
    task.spawn(function()
        while _G.AutoGreen do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ClickDetector") then
                        local p = v.Parent
                        if p:IsA("BasePart") then
                            local dist = (player.Character.HumanoidRootPart.Position - p.Position).Magnitude
                            if dist < _G.Distance then
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

-- 3. Zombie Kill (The Real Fix)
AddToggle("AUTO KILL ZOMBIE", function(s)
    _G.AutoKill = s
    task.spawn(function()
        while _G.AutoKill do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then
                        local root = v:FindFirstChild("HumanoidRootPart")
                        if root then
                            local dist = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                            if dist < _G.Distance then
                                v.Humanoid.Health = 0 -- ฆ่าทันที
                            end
                        end
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end)

-- 4. Speed & Jump (Fixed)
AddToggle("BUFF SPEED & JUMP", function(s)
    _G.Buffs = s
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if _G.Buffs and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 60
        player.Character.Humanoid.JumpPower = 100
    end
end)

print("ZB V14 Loaded - Adjust Slider to use Auto Functions!")
