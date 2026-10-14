-- =====================================================================
-- RXDZ STUDIO LITE PRO - ULTIMATE COMPLETE MOBILE EDITION (NEXT-GEN PASS)
-- Includes: Theme, Vector Icons, Part/Terrain Tools, Output, Explorer/Properties Fix, & Next-Gen Workspace UI
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

-- تنظيف النسخ القديمة بالكامل لمنع التداخل
pcall(function()
    for _, name in ipairs({"STUDIO_LITE_THEME", "STUDIO_LITE_THEME_V31", "RXDZ_NextGenWorkspace", "SlBlackProEzyV1"}) do
        local o = CoreGui:FindFirstChild(name) if o then o:Destroy() end
        local o2 = PlayerGui:FindFirstChild(name) if o2 then o2:Destroy() end
    end
end)

pcall(function()
    local pg = Player:FindFirstChild("PlayerGui")
    if pg then
        local old = pg:FindFirstChild("EzyBrushUI")
        if old then old:Destroy() end
    end
end)

local root = Instance.new("Folder")
root.Name = "STUDIO_LITE_THEME"
root.Parent = CoreGui

-- لوحة الألوان الاحترافية (Dark Slate & Neon Accents)
local C = {
    c0      = Color3.fromRGB(15, 19, 27),
    c1      = Color3.fromRGB(22, 29, 40),
    c2      = Color3.fromRGB(30, 40, 54),
    c3      = Color3.fromRGB(39, 51, 68),
    border  = Color3.fromRGB(54, 72, 94),
    white   = Color3.fromRGB(235, 244, 255),
    expSel  = Color3.fromRGB(25, 94, 157),
    expSelB = Color3.fromRGB(48, 190, 235),
    playRed = Color3.fromRGB(244, 76, 96),
}

local function br(c) return (c.R+c.G+c.B)/3 end
local function isBlue(c) return c.B>0.30 and c.B>(c.R+0.10) and c.B>(c.G+0.10) end

local function isPlayObj(obj)
    local n = obj.Name:lower()
    return n=="play" or n=="playbtn" or n=="playbutton" or (n:sub(1,4)=="play" and #n<=10)
end

local function addRounded(obj)
    if not obj:FindFirstChildOfClass("UICorner") then
        local uc = Instance.new("UICorner"); uc.CornerRadius = UDim.new(0, 7); uc.Parent = obj
    end
    local st = obj:FindFirstChildOfClass("UIStroke")
    if not st then st = Instance.new("UIStroke"); st.Parent = obj end
    st.Color = C.border; st.Thickness = 1
end

local SKIP = {
    SL_TerrainBtn=true, TerrainIconDraw=true,
    TerrainLabel=true, TerrainClickBtn=true, TerrainBar=true,
    SL_IconOverlay=true, SL_IconLabel=true,
    SL_OutputPanel=true, SL_OutputScroll=true, SL_OutputRow=true,
    SL_OutputHeader=true, SL_OutputBtn=true, SL_OutputMenuBtn=true,
    SL_PluginMenuBtn=true, SL_PluginRibbon=true, SL_PluginBtn=true, SL_PluginPanel=true,
    File=true, FileMenu=true, New=true, Save=true, Open=true, Samples=true, Restore=true,
    OpenSamplesMenu=true, SaveDetailsFrame=true, PublishFrame=true,
    ColorPalette=true, SelectedColor=true, ColorPaletteCrosshairs=true,
    Darkness=true, DarknessPointer=true, OkTextButton=true,
}

local ICON_DRAW = {}

local function drawBar(parent, x1, y1, x2, y2, thick, col, zi)
    local dx = x2 - x1; local dy = y2 - y1
    local len = math.sqrt(dx*dx + dy*dy)
    if len < 0.5 then return end
    local bar = Instance.new("Frame")
    bar.Name = "SL_IconOverlay"
    bar.Size = UDim2.new(0, math.ceil(len), 0, thick)
    bar.Position = UDim2.new(0, math.floor((x1+x2)/2 - len/2), 0, math.floor((y1+y2)/2 - thick/2))
    bar.Rotation = math.deg(math.atan2(dy, dx))
    bar.BackgroundColor3 = col
    bar.BorderSizePixel = 0
    bar.ZIndex = zi or 50
    bar.Parent = parent
    local cap = Instance.new("UICorner"); cap.CornerRadius = UDim.new(1,0); cap.Parent = bar
end

ICON_DRAW["select"] = function(parent, S, col)
    local pts = {{5,3},{19,12},{12,13},{9,20},{5,3}}
    for i=1,#pts-1 do
        drawBar(parent, pts[i][1]/24*S, pts[i][2]/24*S, pts[i+1][1]/24*S, pts[i+1][2]/24*S, 2, col)
    end
end

ICON_DRAW["move"] = function(parent, S, col)
    local T = 2
    drawBar(parent, S/2, 1, S/2, S-1, T, col)
    drawBar(parent, 1, S/2, S-1, S/2, T, col)
    drawBar(parent, S/2, 1, S/2-4, 7, T, col)
    drawBar(parent, S/2, 1, S/2+4, 7, T, col)
    drawBar(parent, S/2, S-1, S/2-4, S-7, T, col)
    drawBar(parent, S/2, S-1, S/2+4, S-7, T, col)
    drawBar(parent, 1, S/2, 7, S/2-4, T, col)
    drawBar(parent, 1, S/2, 7, S/2+4, T, col)
    drawBar(parent, S-1, S/2, S-7, S/2-4, T, col)
    drawBar(parent, S-1, S/2, S-7, S/2+4, T, col)
end

ICON_DRAW["scale"] = function(parent, S, col)
    local T=2; local m=3
    drawBar(parent, m,m, S-m,m, T,col)
    drawBar(parent, S-m,m, S-m,S-m, T,col)
    drawBar(parent, S-m,S-m, m,S-m, T,col)
    drawBar(parent, m,S-m, m,m, T,col)
end

ICON_DRAW["rotate"] = function(parent, S, col)
    local T = 2; local cx = S/2; local cy = S/2; local r = S/2 - 5
    local segs = 10
    for i = 0, segs-1 do
        local a = math.rad(300 - 10) + (i/segs) * math.rad(160)
        local an = math.rad(300 - 10) + ((i+1)/segs) * math.rad(160)
        drawBar(parent, cx + math.cos(a)*r, cy + math.sin(a)*r, cx + math.cos(an)*r, cy + math.sin(an)*r, T, col)
    end
end

ICON_DRAW["part"] = function(parent, S, col)
    local T=2; local m=4
    drawBar(parent, m,m, S-m,m, T,col)
    drawBar(parent, S-m,m, S-m,S-m, T,col)
    drawBar(parent, S-m,S-m, m,S-m, T,col)
    drawBar(parent, m,S-m, m,m, T,col)
end

ICON_DRAW["sphere"] = function(parent, S, col)
    local T=2; local cx=S/2; local cy=S/2; local r=S/2-4
    for i=0,13 do
        local a1=(i/14)*math.pi*2; local a2=((i+1)/14)*math.pi*2
        drawBar(parent, cx+math.cos(a1)*r, cy+math.sin(a1)*r, cx+math.cos(a2)*r, cy+math.sin(a2)*r, T, col)
    end
end

ICON_DRAW["wedge"] = function(parent, S, col)
    local T=2
    drawBar(parent, 3,S-3, S-3,S-3, T,col)
    drawBar(parent, 3,S-3, S/2,3, T,col)
    drawBar(parent, S-3,S-3, S/2,3, T,col)
end

ICON_DRAW["cylinder"] = function(parent, S, col)
    local T=2; local cx=S/2; local ry=S*0.12; local rx=S/2-4; local ty=5; local by=S-5
    for i=0,11 do
        local a1=(i/12)*math.pi*2; local a2=((i+1)/12)*math.pi*2
        drawBar(parent, cx+math.cos(a1)*rx, ty+math.sin(a1)*ry, cx+math.cos(a2)*rx, ty+math.sin(a2)*ry, T, col)
    end
    drawBar(parent, cx-rx, ty, cx-rx, by, T, col)
    drawBar(parent, cx+rx, ty, cx+rx, by, T, col)
end

ICON_DRAW["model"] = function(parent, S, col)
    local T=2; local cx=S/2; local top=4; local mid=S/2; local lx=4; local rx=S-4
    drawBar(parent, cx,top, rx,mid-4, T,col)
    drawBar(parent, rx,mid-4, cx,mid+2, T,col)
    drawBar(parent, cx,mid+2, lx,mid-4, T,col)
    drawBar(parent, lx,mid-4, cx,top, T,col)
end

local ICON_MAP = {
    select="select", move="move", scale="scale", rotate="rotate",
    part="part", partinsert="part", sphere="sphere", ball="sphere",
    wedge="wedge", cylinder="cylinder", model="model", union="model"
}

local function injectIconIntoBtn(btn, iconKey, col)
    for _, ch in ipairs(btn:GetChildren()) do
        if ch.Name == "SL_IconOverlay" or ch.Name == "SL_IconFrame" then ch:Destroy() end
    end
    local drawFn = ICON_DRAW[iconKey]
    if not drawFn then return end

    for _, ch in ipairs(btn:GetChildren()) do
        if ch:IsA("ImageLabel") or ch:IsA("ImageButton") then
            pcall(function() ch.ImageTransparency = 1 end)
        end
    end

    local iconF = Instance.new("Frame")
    iconF.Name = "SL_IconFrame"
    iconF.BackgroundTransparency = 1
    iconF.Size = UDim2.new(0, 20, 0, 20)
    iconF.Position = UDim2.new(0.5, -10, 0, 4)
    iconF.Parent = btn
    pcall(function() drawFn(iconF, 20, col) end)
end

-- تصحيح الأزرار والعناصر تلقائياً
local function fixAll()
    for _, obj in ipairs(StudioGui:GetDescendants()) do
        if SKIP[obj.Name] then continue end
        pcall(function()
            if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                if obj.BackgroundTransparency >= 0.95 then return end
                local c = obj.BackgroundColor3; local b = br(c)
                if isBlue(c) and b > 0.15 then
                    obj.BackgroundColor3 = C.expSel; addRounded(obj); return
                end
                if b > 0.85 then obj.BackgroundColor3 = C.c0
                elseif b > 0.65 then obj.BackgroundColor3 = C.c1
                elseif b > 0.45 then obj.BackgroundColor3 = C.c2
                else obj.BackgroundColor3 = C.c3 end
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if obj.TextColor3 then obj.TextColor3 = isPlayObj(obj) and C.playRed or C.white end
            end
        end)
    end
end

-- تفعيل لوحة Output المخصصة
local SL_OUTPUT_LINES = {}
local outputVisible = false
local outputPanel, outputScroll

local function outputAddLine(msgType, text)
    table.insert(SL_OUTPUT_LINES, {t=msgType, s=tostring(text), time=os.date("%H:%M:%S")})
    if #SL_OUTPUT_LINES > 150 then table.remove(SL_OUTPUT_LINES, 1) end
    if not outputScroll or not outputVisible then return end
    
    pcall(function()
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -8, 0, 18)
        row.BackgroundTransparency = 1
        row.Parent = outputScroll
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "["..os.date("%H:%M:%S").."] " .. tostring(text)
        lbl.TextColor3 = msgType=="error" and Color3.fromRGB(255,80,80) or (msgType=="warn" and Color3.fromRGB(255,200,60) or C.white)
        lbl.TextSize = 11
        lbl.Font = Enum.Font.Code
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row
        outputScroll.CanvasSize = UDim2.new(0, 0, 0, #outputScroll:GetChildren() * 19)
    end)
end

local function buildOutputPanel()
    if outputPanel then return end
    local panel = Instance.new("Frame")
    panel.Name = "SL_OutputPanel"
    panel.Size = UDim2.new(0, 320, 0, 180)
    panel.Position = UDim2.new(0, 10, 1, -190)
    panel.BackgroundColor3 = C.c0
    panel.Visible = false
    panel.ZIndex = 300
    panel.Parent = StudioGui
    addRounded(panel, 10)
    addStroke(panel, C.border)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundColor3 = C.c1
    header.Parent = panel
    addRounded(header, 10)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Output Console"
    title.TextColor3 = C.white
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 20)
    closeBtn.Position = UDim2.new(1, -28, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = C.white
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    addRounded(closeBtn, 4)
    closeBtn.MouseButton1Click:Connect(function()
        outputVisible = false
        panel.Visible = false
    end)

    outputScroll = Instance.new("ScrollingFrame")
    outputScroll.Name = "SL_OutputScroll"
    outputScroll.Size = UDim2.new(1, 0, 1, -28)
    outputScroll.Position = UDim2.new(0, 0, 0, 28)
    outputScroll.BackgroundTransparency = 1
    outputScroll.ScrollBarThickness = 4
    outputScroll.Parent = panel

    local list = Instance.new("UIListLayout")
    list.Parent = outputScroll

    outputPanel = panel
end

local function toggleOutput()
    outputVisible = not outputVisible
    if outputPanel then outputPanel.Visible = outputVisible end
end

-- تعديل طبقات المستكشف والخصائص (Explorer & Properties Fix)
local function fixExplorerAndProperties()
    for _, obj in ipairs(StudioGui:GetDescendants()) do
        if obj.Name == "ExplorerPanel" or obj.Name == "PropertiesPanel" then
            obj.BackgroundColor3 = C.c0
            for _, ch in ipairs(obj:GetDescendants()) do
                if ch:IsA("GuiObject") and ch.BackgroundTransparency < 0.95 then
                    ch.BackgroundColor3 = C.c1
                end
                if ch:IsA("TextLabel") or ch:IsA("TextButton") or ch:IsA("TextBox") then
                    ch.TextColor3 = C.white
                end
            end
        end
    end
end

-- =====================================================================
-- RXDZ NEXT-GEN WORKSPACE LAYER (Mobile Navigation & Window Controls)
-- =====================================================================
task.defer(function()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "RXDZ_NextGenWorkspace"
    mainGui.ResetOnSpawn = false
    mainGui.IgnoreGuiInset = true
    mainGui.DisplayOrder = 999
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.Parent = StudioGui

    -- زر التشغيل السريع العائم للشاشات المحمولة
    local launcher = Instance.new("TextButton")
    launcher.Size = UDim2.new(0, 50, 0, 50)
    launcher.Position = UDim2.new(0, 10, 0.45, 0)
    launcher.BackgroundColor3 = C.c1
    launcher.Text = "RX\nDZ"
    launcher.TextColor3 = C.expSelB
    launcher.TextSize = 11
    launcher.Font = Enum.Font.GothamBlack
    launcher.AutoButtonColor = false
    launcher.Parent = mainGui
    addRounded(launcher, 14)
    addStroke(launcher, C.expSelB, 1.5)

    -- لوحة التحكم والوصول السريع الشاملة
    local board = Instance.new("Frame")
    board.Size = UDim2.new(0, 280, 0, 340)
    board.Position = UDim2.new(0, 70, 0.4, -100)
    board.BackgroundColor3 = C.c0
    board.Visible = false
    board.ClipsDescendants = true
    board.Parent = mainGui
    addRounded(board, 12)
    addStroke(board, C.border, 1.2)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = C.c1
    header.Parent = board
    addRounded(header, 12)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -50, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "RXDZ STUDIO LITE PRO"
    titleLbl.TextColor3 = C.white
    titleLbl.TextSize = 11
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -32, 0, 7)
    closeBtn.BackgroundColor3 = C.playRed
    closeBtn.Text = "×"
    closeBtn.TextColor3 = C.white
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    addRounded(closeBtn, 6)

    closeBtn.Activated:Connect(function() board.Visible = false end)
    launcher.Activated:Connect(function() board.Visible = not board.Visible end)

    -- سحب اللوحة باللمس
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = board.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            board.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- أزرار القائمة السريعة داخل اللوحة
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -16, 1, -50)
    content.Position = UDim2.new(0, 8, 0, 44)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 3
    content.Parent = board

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 125, 0, 42)
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    gridLayout.Parent = content

    local function addMenuButton(name, callback)
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = C.c2
        btn.Text = name
        btn.TextColor3 = C.white
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = content
        addRounded(btn, 6)
        addStroke(btn, C.border)
        btn.Activated:Connect(callback)
    end

    addMenuButton("Explorer", function()
        for _, o in ipairs(StudioGui:GetDescendants()) do
            if o.Name == "ExplorerPanel" or o.Name == "Explorer" then o.Visible = not o.Visible end
        end
    end)

    addMenuButton("Properties", function()
        for _, o in ipairs(StudioGui:GetDescendants()) do
            if o.Name == "PropertiesPanel" or o.Name == "Properties" then o.Visible = not o.Visible end
        end
    end)

    addMenuButton("Output Console", function()
        toggleOutput()
    end)

    addMenuButton("Refresh UI", function()
        fixAll()
        fixExplorerAndProperties()
    end)

    print("[RXDZ Workspace] ✓ Complete mobile touch UI loaded successfully.")
end)

-- تشغيل المهام التلقائية للتنسيق
task.spawn(function()
    task.wait(0.5)
    fixAll()
    buildOutputPanel()
    fixExplorerAndProperties()
    print("[STUDIO LITE BY EZY] ✓ Loaded Successfully | Complete File Edition!")
end)
