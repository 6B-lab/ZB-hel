-- [[ ZB HELPER V5.5 - FOR DELTA X MOBILE ]] --
local player = game.Players.LocalPlayer

-- ลบ UI เก่าป้องกันค้าง
if game.CoreGui:FindFirstChild("DeltaZB") then
    game.CoreGui.DeltaZB:Destroy()
end

-- สร้างหน้าจอเมนู
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaZB"
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 160, 0, 200)
Main.Position = UDim2.new(0.05, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Parent = ScreenGui
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "ZB HELPER V5.5"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- ฟังก์ชันปุ่ม
local function MakeBtn(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. Auto Green
_G.AutoG = false
local gBtn = MakeBtn("Auto Green: OFF", 40, Color3.fromRGB(60, 60, 60), function()
    _G.AutoG = not _G.AutoG
end)

task.spawn(function()
    while true do
        if _G.AutoG then
            gBtn.Text = "Auto Green: ON ✅"
            gBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ClickDetector") then
                    local name = v.Parent.Name:lower()
                    if name:find("green") or name:find("accept") then
                        fireclickdetector(v)
                    end
                end
            end
        else
            gBtn.Text = "Auto Green: OFF"
            gBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        task.wait(0.3)
    end
end)

-- 2. ESP
local espOn = false
MakeBtn("ESP (มองทะลุ)", 80, Color3.fromRGB(100, 0, 150), function()
    espOn = not espOn
    if espOn then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.Name = "ZBESP"
            end
        end
    else
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ZBESP") then
                p.Character.ZBESP:Destroy()
            end
        end
    end
end)

-- 3. Speed
MakeBtn("Speed (60)", 120, Color3.fromRGB(0, 100, 200), function()
    player.Character.Humanoid.WalkSpeed = 60
end)

-- 4. Close
MakeBtn("ปิดเมนู", 160, Color3.fromRGB(150, 0, 0), function() ScreenGui:Destroy() end)
