-- [[ ZB PREMIUM V12 - MINIMIZE SYSTEM & FIXED SCAN ]] --
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- ลบ UI เก่า
if CoreGui:FindFirstChild("ZB_Minimized_Hub") then
    CoreGui.ZB_Minimized_Hub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ZB_Minimized_Hub"

-- ตัวแปรสถานะ
local isMinimized = false

-- สร้างหน้าต่างหลัก
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 310)
Main.Position = UDim2.new(0.05, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true -- สำคัญสำหรับการพับ
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 150)
MainStroke.Thickness = 2

-- ส่วนหัว (Header)
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local HeaderCorner = Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "ZB HUB V12"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มพับหน้าต่าง (Minimize Button)
local MiniBtn = Instance.new("TextButton", Header)
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -65, 0, 5)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.new(1, 1, 1)
MiniBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MiniBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)

-- ปุ่มปิด (Close Button)
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- พื้นที่เก็บปุ่ม (Content)
local ContentFrame = Instance.new("Frame", Main)
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", ContentFrame)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [[ ระบบการพับหน้าต่าง ]] --
MiniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Main:TweenSize(UDim2.new(0, 200, 0, 40), "Out", "Quart", 0.3, true)
        MiniBtn.Text = "+"
    else
        Main:TweenSize(UDim2.new(0, 200, 0, 310), "Out", "Quart", 0.3, true)
        MiniBtn.Text = "-"
    end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ฟังก์ชันปุ่ม Toggle
local function AddToggle(text, callback)
    local state = false
    local btn = Instance.new("TextButton", ContentFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Text = text .. " : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " : ON ✅" or " : OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 120, 70) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

--- [[ ฟังก์ชันการทำงานต่างๆ ]] ---

-- 1. Auto Green Fixed
_G.AutoGreen = false
AddToggle("AUTO ACCEPT GREEN", function(s)
    _G.AutoGreen = s
    task.spawn(function()
        while _G.AutoGreen do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ClickDetector") then
                        local p = v.Parent
                        if (p.Color.g > p.Color.r and p.Color.g > 0.4) or p.Name:lower():find("green") then
                            if (player.Character.HumanoidRootPart.Position - p.Position).Magnitude < 25 then
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

-- 2. Zombie Scanner (Fixed)
_G.AutoKill = false
AddToggle("AUTO KILL ZOMBIE", function(s)
    _G.AutoKill = s
    task.spawn(function()
        while _G.AutoKill do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then
                        local root = v:FindFirstChild("HumanoidRootPart")
                        if root and (player.Character.HumanoidRootPart.Position - root.Position).Magnitude < 40 then
                            v.Humanoid.Health = 0
                        end
                    end
                end
            end)
            task.wait(0.4)
        end
    end)
end)

-- 3. ESP
AddToggle("PLAYER ESP", function(s)
    _G.ESP = s
    if not s then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HighV12") then p.Character.HighV12:Destroy() end
        end
    end
end)

task.spawn(function()
    while true do
        if _G.ESP then
            pcall(function()
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= player and p.Character and not p.Character:FindFirstChild("HighV12") then
                        local h = Instance.new("Highlight", p.Character)
                        h.Name = "HighV12"
                        h.FillColor = Color3.fromRGB(0, 255, 150)
                    end
                end
            end)
        end
        task.wait(2)
    end
end)

-- 4. Speed & Inf Jump
AddToggle("SPEED & INF JUMP", function(s)
    _G.Buffs = s
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if _G.Buffs and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 60
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.Buffs and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState("Jumping")
    end
end)

print("ZB V12 Minimize UI Loaded!")
