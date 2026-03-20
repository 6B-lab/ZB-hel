-- [[ ZB PREMIUM V23 - FULL AUTO EXPLORE & FARM ]] --
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- ลบ UI เก่า
if CoreGui:FindFirstChild("ZB_Ultimate_V23") then
    CoreGui.ZB_Ultimate_V23:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ZB_Ultimate_V23"
ScreenGui.ResetOnSpawn = false

-- Settings
_G.AutoFarm = false
_G.FarmDistance = 150
_G.HeightOffset = 10 -- ความสูงจากพื้นป้องกันการโดนตบ

-- จุดพิกัดสำคัญในแมพ (ตำแหน่งสมมติ ปรับเปลี่ยนตามความเหมาะสมของแมพจริง)
local MapPoints = {
    Vector3.new(100, 10, 100),   -- Gate 1
    Vector3.new(-150, 10, 200),  -- Forest
    Vector3.new(200, 10, -50),   -- Checkpoint B
    Vector3.new(0, 10, -300),    -- Hospital
    Vector3.new(-50, 10, 50)     -- Spawn Zone
}

-- [[ UI Main Menu ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 300)
Main.Position = UDim2.new(0.1, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 200, 0) -- ขอบสีทอง

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
Instance.new("UICorner", Header)
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "ZB FULL AUTO FARM V23"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

-- Scroll Area
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [[ Function: Create Toggle ]] --
local function AddToggle(text, callback)
    local state = false
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Text = text .. " : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " : ON ✅" or " : OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(35, 35, 35)
        callback(state)
    end)
end

-- [[ LOGIC: ระบบ Auto เล่นเองทั่วแมพ ]] --

AddToggle("START AUTO FARM (เล่นเอง)", function(s)
    _G.AutoFarm = s
    
    task.spawn(function()
        local currentPoint = 1
        while _G.AutoFarm do
            pcall(function()
                local char = player.Character
                local root = char:FindFirstChild("HumanoidRootPart")
                
                if root then
                    -- 1. วาร์ปไปที่จุดฟาร์มถัดไป
                    root.CFrame = CFrame.new(MapPoints[currentPoint] + Vector3.new(0, _G.HeightOffset, 0))
                    
                    -- 2. ฟาร์มในจุดนั้นสักพัก (ฆ่าและกดปุ่ม)
                    for i = 1, 20 do -- วนลูปสแกนรอบตัวในจุดนั้น 20 ครั้ง
                        if not _G.AutoFarm then break end
                        
                        -- กดปุ่มเขียวใกล้ๆ
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("ClickDetector") then
                                local p = v.Parent
                                if p:IsA("BasePart") and (root.Position - p.Position).Magnitude < 50 then
                                    fireclickdetector(v)
                                end
                            end
                        end
                        
                        -- ฆ่าซอมบี้ใกล้ๆ
                        for _, v in pairs(workspace:GetChildren()) do
                            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= char then
                                local zRoot = v:FindFirstChild("HumanoidRootPart")
                                if zRoot and (root.Position - zRoot.Position).Magnitude < _G.FarmDistance then
                                    v.Humanoid.Health = 0
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                    
                    -- 3. เปลี่ยนจุดถัดไป
                    currentPoint = currentPoint + 1
                    if currentPoint > #MapPoints then currentPoint = 1 end
                end
            end)
            task.wait(1)
        end
    end)
end)

AddToggle("GOD MODE (ลอยเหนือพื้น)", function(s)
    _G.God = s
    task.spawn(function()
        while _G.God do
            pcall(function()
                player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                -- ทำให้ตัวลอยนิ่งๆ ป้องกันซอมบี้ตบ
            end)
            task.wait(0.1)
        end
    end)
end)

-- ปุ่มพับเมนู
local CircleIcon = Instance.new("TextButton", ScreenGui)
CircleIcon.Size = UDim2.new(0, 45, 0, 45)
CircleIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
CircleIcon.Text = "AUTO"
CircleIcon.TextColor3 = Color3.fromRGB(255, 200, 0)
CircleIcon.Visible = false
CircleIcon.Draggable = true
Instance.new("UICorner", CircleIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", CircleIcon).Color = Color3.fromRGB(255, 200, 0)

local MiniBtn = Instance.new("TextButton", Header)
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -35, 0, 5)
MiniBtn.Text = "-"
MiniBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MiniBtn.TextColor3 = Color3.new(1,1,1)
MiniBtn.MouseButton1Click:Connect(function() Main.Visible = false CircleIcon.Visible = true end)
CircleIcon.MouseButton1Click:Connect(function() Main.Visible = true CircleIcon.Visible = false end)

print("ZB V23 Full Auto Farm Loaded!")
