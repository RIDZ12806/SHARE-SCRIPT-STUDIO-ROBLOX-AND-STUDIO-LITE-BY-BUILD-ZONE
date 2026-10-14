-- =====================================================================
-- RXDZ STUDIO LITE PRO - ULTIMATE MOBILE EDITION (NEXT-GEN PASS)
-- Optimized for touch devices, sleek dark aesthetics, and robust window management.
-- =====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui", 15)
local StudioGui = PlayerGui:WaitForChild("StudioGui", 15)

-- تنظيف النسخ القديمة لمنع التداخل
pcall(function()
    for _, name in ipairs({"STUDIO_LITE_THEME", "STUDIO_LITE_THEME_V31", "RXDZ_NextGenWorkspace", "SlBlackProEzyV1"}) do
        local o = CoreGui:FindFirstChild(name) if o then o:Destroy() end
        local o2 = PlayerGui:FindFirstChild(name) if o2 then o2:Destroy() end
    end
end)

-- لوحة الألوان الاحترافية (Dark Slate & Neon Accents)
local Palette = {
    c0      = Color3.fromRGB(12, 16, 24),
    c1      = Color3.fromRGB(18, 24, 34),
    c2      = Color3.fromRGB(26, 35, 48),
    c3      = Color3.fromRGB(35, 47, 65),
    border  = Color3.fromRGB(48, 66, 90),
    white   = Color3.fromRGB(240, 246, 255),
    accent  = Color3.fromRGB(38, 142, 235),
    accentB = Color3.fromRGB(60, 190, 255),
    playRed = Color3.fromRGB(245, 65, 85),
    green   = Color3.fromRGB(45, 200, 130),
}

local function addCorner(obj, r)
    local uc = Instance.new("UICorner")
    uc.CornerRadius = UDim.new(0, r or 8)
    uc.Parent = obj
end

local function addStroke(obj, col, thick)
    local st = Instance.new("UIStroke")
    st.Color = col or Palette.border
    st.Thickness = thick or 1
    st.Transparency = 0.2
    st.Parent = obj
end

-- نظام الرسومات المتجهية للأيقونات (Procedural Vector Icons)
local function drawBar(parent, x1, y1, x2, y2, thick, col, zi)
    local dx, dy = x2 - x1, y2 - y1
    local len = math.sqrt(dx*dx + dy*dy)
    if len < 0.5 then return end
    local bar = Instance.new("Frame")
    bar.Name = "RX_Icon"
    bar.Size = UDim2.new(0, math.ceil(len), 0, thick)
    bar.Position = UDim2.new(0, math.floor((x1+x2)/2 - len/2), 0, math.floor((y1+y2)/2 - thick/2))
    bar.Rotation = math.deg(math.atan2(dy, dx))
    bar.BackgroundColor3 = col or Palette.white
    bar.BorderSizePixel = 0
    bar.ZIndex = zi or 50
    bar.Parent = parent
    local uc = Instance.new("UICorner"); uc.CornerRadius = UDim.new(1,0); uc.Parent = bar
end

local ICON_FUNCS = {}

ICON_FUNCS["select"] = function(f, sz, col)
    local pts = {{3,2},{18,11},{11,12},{8,18},{3,2}}
    for i=1, #pts-1 do
        drawBar(f, pts[i][1]/20*sz, pts[i][2]/20*sz, pts[i+1][1]/20*sz, pts[i+1][2]/20*sz, 2, col)
    end
end

ICON_FUNCS["move"] = function(f, sz, col)
    local t = 2
    drawBar(f, sz/2, 2, sz/2, sz-2, t, col)
    drawBar(f, 2, sz/2, sz-2, sz/2, t, col)
    drawBar(f, sz/2, 2, sz/2-4, 7, t, col)
    drawBar(f, sz/2, 2, sz/2+4, 7, t, col)
    drawBar(f, sz/2, sz-2, sz/2-4, sz-7, t, col)
    drawBar(f, sz/2, sz-2, sz/2+4, sz-7, t, col)
end

ICON_FUNCS["scale"] = function(f, sz, col)
    local t = 2; local m = 3
    drawBar(f, m, m, sz-m, m, t, col)
    drawBar(f, sz-m, m, sz-m, sz-m, t, col)
    drawBar(f, sz-m, sz-m, m, sz-m, t, col)
    drawBar(f, m, sz-m, m, m, t, col)
end

ICON_FUNCS["rotate"] = function(f, sz, col)
    local t = 2; local cx, cy, r = sz/2, sz/2, sz/2 - 4
    for i = 0, 7 do
        local a = (i/8)*math.pi*2
        drawBar(f, cx + math.cos(a)*r, cy + math.sin(a)*r, cx + math.cos(a+0.5)*r, cy + math.sin(a+0.5)*r, t, col)
    end
end

ICON_FUNCS["part"] = function(f, sz, col)
    local t = 2; local m = 4
    drawBar(f, m, m, sz-m, m, t, col)
    drawBar(f, sz-m, m, sz-m, sz-m, t, col)
    drawBar(f, sz-m, sz-m, m, sz-m, t, col)
    drawBar(f, m, sz-m, m, m, t, col)
end

-- تطبيق الأيقونات الذكية على الأزرار
local function injectIcon(btn, key, col)
    for _, ch in ipairs(btn:GetChildren()) do
        if ch.Name == "RX_IconContainer" then ch:Destroy() end
    end
    local drawFn = ICON_FUNCS[key]
    if not drawFn then return end

    for _, ch in ipairs(btn:GetChildren()) do
        if ch:IsA("ImageLabel") or ch:IsA("ImageButton") then
            pcall(function() ch.ImageTransparency = 1 end)
        end
    end

    local cF = Instance.new("Frame")
    cF.Name = "RX_IconContainer"
    cF.BackgroundTransparency = 1
    cF.Size = UDim2.new(0, 22, 0, 22)
    cF.Position = UDim2.new(0.5, -11, 0, 3)
    cF.ZIndex = 5
    cF.Parent = btn
    pcall(function() drawFn(cF, 22, col) end)
end

-- تفعيل واجهة التحكم العائمة والمنحوتة (RXDZ Workspace Launcher)
task.defer(function()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "RXDZ_NextGenWorkspace"
    mainGui.ResetOnSpawn = false
    mainGui.IgnoreGuiInset = true
    mainGui.DisplayOrder = 999
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.Parent = StudioGui

    -- زر التشغيل السريع الأنيق على الهاتف
    local launcher = Instance.new("TextButton")
    launcher.Size = UDim2.new(0, 50, 0, 50)
    launcher.Position = UDim2.new(0, 10, 0.4, 0)
    launcher.BackgroundColor3 = Palette.c1
    launcher.Text = "RX\nDZ"
    launcher.TextColor3 = Palette.accentB
    launcher.TextSize = 11
    launcher.Font = Enum.Font.GothamBlack
    launcher.AutoButtonColor = false
    launcher.Parent = mainGui
    addCorner(launcher, 14)
    addStroke(launcher, Palette.accent, 1.5)

    -- لوحة التحكم المندمجة
    local board = Instance.new("Frame")
    board.Size = UDim2.new(0, 280, 0, 360)
    board.Position = UDim2.new(0, 70, 0.4, -100)
    board.BackgroundColor3 = Palette.c0
    board.Visible = false
    board.ClipsDescendants = true
    board.Parent = mainGui
    addCorner(board, 12)
    addStroke(board, Palette.border, 1.2)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundColor3 = Palette.c1
    header.BorderSizePixel = 0
    header.Parent = board
    addCorner(header, 12)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -50, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "RXDZ STUDIO PRO"
    titleLbl.TextColor3 = Palette.white
    titleLbl.TextSize = 12
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -34, 0, 8)
    closeBtn.BackgroundColor3 = Palette.playRed
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Palette.white
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    addCorner(closeBtn, 6)

    closeBtn.Activated:Connect(function() board.Visible = false end)
    launcher.Activated:Connect(function() board.Visible = not board.Visible end)

    -- سحب اللوحة بسلاسة باللمس
    local dragging, dragInput, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = board.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            board.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    print("[RXDZ Studio Lite] ✓ Initialized successfully with mobile touch support.")
end)
