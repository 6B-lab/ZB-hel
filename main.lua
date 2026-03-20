-- [[ ZB ULTIMATE V8 - 100% MAP COMPATIBLE ]] --
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

-- ลบ UI เก่าป้องกันการค้าง
if game.CoreGui:FindFirstChild("ZB_100Percent") then
    game.CoreGui.ZB_100Percent:Destroy()
end

-- สร้างหน้าต่าง Mini Menu สไตล์ Delta X
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ZB_100Percent"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 240)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "ZB ULTIMATE V8"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- [[ ฟังก์ชันสร้างปุ่ม Toggle ]] --
local function MakeToggle(text, y, callback)
    local state = false
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON ✅" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end

-- 1. [FIX 100%] ระบบ Auto Green (Scan ทุกอย่างที่เป็นปุ่มเขียวในด่าน)
_G.AutoGreen = false
MakeToggle("AUTO ACCEPT", 45, function(s)
    _G.AutoGreen = s
end)

task.spawn(function()
    while true do
        if _G.AutoGreen then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    -- ค้นหา ClickDetector
                    if v:IsA("ClickDetector") then
                        local p = v.Parent
                        -- ตรวจสอบชื่อปุ่ม หรือ สีของปุ่มที่เป็นสีเขียวสด (0, 255, 0)
                        if p.Name:lower():find("green") or p.Name:lower():find("accept") or p.Name:lower():find("allow") or 
                           (p:IsA("Part") and (p.Color == Color3.fromRGB(0, 255, 0) or p.BrickColor.Name == "Lime green")) then
                            
                            -- กดปุ่ม (Fire Click)
                            fireclickdetector(v)
                        end
                    end
                end
            end)
        end
        task.wait(0.2) -- ความเร็วสูงมากในการสแกน
    end
end)

-- 2. [FIX 100%] ระบบ ESP (มองเห็นคนและซอมบี้)
_G.ESP = false
MakeToggle("PLAYER ESP", 90, function(s)
    _G.ESP = s
    if not s then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ZB_High") then
                p.Character.ZB_High:Destroy()
            end
        end
    end
end)

task.spawn(function()
    while true do
        if _G.ESP then
            pcall(function()
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= player and p.Character and not p.Character:FindFirstChild("ZB_High") then
                        local h = Instance.new("Highlight", p.Character)
                        h.Name = "ZB_High"
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                        h.OutlineColor = Color3.new(1, 1, 1)
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

-- 3. ระบบ WalkSpeed (วิ่งเร็ว)
MakeToggle("SPEED HACK", 135, function(s)
    _G.SpeedOn = s
end)

-- 4. ระบบ Infinite Jump (กระโดดไม่จำกัด)
MakeToggle("INF JUMP", 180, function(s)
    _G.InfJump = s
end)

-- Loop สำหรับระบบตัวละคร
task.spawn(function()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.InfJump and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState("Jumping")
        end
    end)
    
    runService.Heartbeat:Connect(function()
        if _G.SpeedOn and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 60
        elseif not _G.SpeedOn and player.Character and player.Character:FindFirstChild("Humanoid") then
            -- ไม่ปรับกลับอัตโนมัติเพื่อป้องกันบัค ให้ปรับเป็น 16
        end
    end)
end)

-- ปุ่มปิด
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0.9, 0, 0, 25)
Close.Position = UDim2.new(0.05, 0, 0, 220)
Close.Text = "CLOSE"
Close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
