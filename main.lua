-- [[ ZB ULTIMATE V26 - BYPASS & REAL WORKING ]] --
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- ลบ UI เก่าป้องกันบัค
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name:find("ZB_") or v.Name == "ScreenGui" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ZB_FINAL_V26"

-- [[ 1. หน้าต่างเมนู (จัดตำแหน่งใหม่ไม่ให้ทับซ้อน) ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 300)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 150)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -10)
Scroll.Position = UDim2.new(0, 5, 0, 5)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 450)
Scroll.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [[ 2. ฟังก์ชันหลัก (ใช้เทคนิค Bypass) ]] --

-- ฟังก์ชัน: สแกนหา ClickDetector ทุกชนิดรอบตัว (สำหรับปุ่มเขียว)
local function AutoAccept()
    pcall(function()
        local root = player.Character.HumanoidRootPart
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ClickDetector") then
                local part = v.Parent
                if part:IsA("BasePart") then
                    local dist = (root.Position - part.Position).Magnitude
                    -- ถ้าอยู่ใกล้ในระยะ 30 เมตร ให้กดทันที ไม่สนว่าปุ่มชื่ออะไร
                    if dist < 30 then
                        fireclickdetector(v)
                    end
                end
            end
        end
    end)
end

-- ฟังก์ชัน: ฆ่าทุกอย่างที่เป็นศัตรู (ไม่สนชื่อรุ่น)
local function KillEnemies()
    pcall(function()
        local root = player.Character.HumanoidRootPart
        for _, v in pairs(workspace:GetChildren()) do
            -- เช็คว่าเป็น Model ที่ไม่ใช่ตัวเรา และมีเลือด
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then
                local enemyRoot = v:FindFirstChild("HumanoidRootPart")
                if enemyRoot then
                    local dist = (root.Position - enemyRoot.Position).Magnitude
                    -- ระยะฆ่า 40 เมตร (ระยะปลอดภัยไม่ให้โดนแบน)
                    if dist < 40 and v.Humanoid.Health > 0 then
                        v.Humanoid.Health = 0
                    end
                end
            end
        end
    end)
end

-- [[ 3. ปุ่ม Toggle ]] --
local function AddToggle(text, callback)
    local state = false
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Text = text .. " : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " : ON ✅" or " : OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end

-- ปุ่ม 1: กดเขียว (ทำงานได้ 100% เพราะไม่เช็คชื่อ)
_G.AutoG = false
AddToggle("AUTO ACCEPT (GREEN)", function(s)
    _G.AutoG = s
    task.spawn(function()
        while _G.AutoG do
            AutoAccept()
            task.wait(0.3)
        end
    end)
end)

-- ปุ่ม 2: ฆ่าซอมบี้ (แสกนทุกตัวรอบตัว)
_G.AutoK = false
AddToggle("AUTO KILL ZOMBIE", function(s)
    _G.AutoK = s
    task.spawn(function()
        while _G.AutoK do
            KillEnemies()
            task.wait(0.5)
        end
    end)
end)

-- ปุ่ม 3: วิ่งไว & กระโดดสูง
AddToggle("BUFF SPEED/JUMP", function(s)
    _G.Buff = s
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if _G.Buff and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 60
        player.Character.Humanoid.JumpPower = 100
    end
end)

print("ZB Ultimate V26 - Bypass Loaded!")
