-- RX STUDIO LITE PRO - VISUAL REDESIGN PASS 2
-- ===================== PART 1 of 4 : BEGIN (start of script) =====================
local CoreGui = game:GetService("CoreGui")
local Players  = game:GetService("Players")

pcall(function()
    local o = CoreGui:FindFirstChild("STUDIO_LITE_THEME")
    if o then o:Destroy() end
    local o2 = CoreGui:FindFirstChild("STUDIO_LITE_THEME_V31")
    if o2 then o2:Destroy() end
end)

pcall(function()
    local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local old = pg:FindFirstChild("EzyBrushUI")
        if old then old:Destroy() end
    end
end)

local root = Instance.new("Folder")
root.Name   = "STUDIO_LITE_THEME"
root.Parent = CoreGui

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui", 15)
local StudioGui = PlayerGui and PlayerGui:WaitForChild("StudioGui", 15)
if not StudioGui then warn("[SL Theme] StudioGui tidak ditemukan!"); return end

local RS = game:GetService("RunService")

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
        local uc=Instance.new("UICorner"); uc.CornerRadius=UDim.new(0,7); uc.Parent=obj
    end
    local st=obj:FindFirstChildOfClass("UIStroke")
    if not st then st=Instance.new("UIStroke"); st.Parent=obj end
    st.Color=C.border; st.Thickness=1
end

local SKIP = {
    SL_TerrainBtn=true, TerrainIconDraw=true,
    TerrainLabel=true, TerrainClickBtn=true, TerrainBar=true,
    SL_IconOverlay=true, SL_IconLabel=true,
    SL_OutputPanel=true, SL_OutputScroll=true, SL_OutputRow=true,
    SL_OutputHeader=true, SL_OutputBtn=true, SL_OutputMenuBtn=true,

    SL_PluginMenuBtn=true, SL_PluginRibbon=true,
    SL_PluginBtn=true, SL_PluginPanel=true,

    File=true, FileMenu=true,
    New=true, Save=true, Open=true, Samples=true, Restore=true,
    OpenSamplesMenu=true, SaveDetailsFrame=true, PublishFrame=true,
    SaveButton=true, CancelButton=true, GameNameTextBox=true,
    DescriptionTextBox=true, PublishCheckboxImageButton=true,

    ColorPalette=true, SelectedColor=true, ColorPaletteCrosshairs=true,
    Darkness=true, DarknessPointer=true, OkTextButton=true,
}

local ICON_DRAW = {}

local function drawBar(parent, x1,y1,x2,y2, thick, col, zi)
    local dx=x2-x1; local dy=y2-y1
    local len=math.sqrt(dx*dx+dy*dy)
    if len<0.5 then return end
    local bar=Instance.new("Frame")
    bar.Name="SL_IconOverlay"
    bar.Size=UDim2.new(0,math.ceil(len),0,thick)
    bar.Position=UDim2.new(0,math.floor((x1+x2)/2-len/2),0,math.floor((y1+y2)/2-thick/2))
    bar.Rotation=math.deg(math.atan2(dy,dx))
    bar.BackgroundColor3=col
    bar.BorderSizePixel=0
    bar.ZIndex=zi or 50
    bar.Parent=parent
    local cap=Instance.new("UICorner")
    cap.CornerRadius=UDim.new(1,0)
    cap.Parent=bar
end

local function drawDot(parent, cx,cy, r, col, zi)
    local dot=Instance.new("Frame")
    dot.Name="SL_IconOverlay"
    dot.Size=UDim2.new(0,r*2,0,r*2)
    dot.Position=UDim2.new(0,cx-r,0,cy-r)
    dot.BackgroundColor3=col
    dot.BorderSizePixel=0
    dot.ZIndex=zi or 50
    dot.Parent=parent
    local uc=Instance.new("UICorner")
    uc.CornerRadius=UDim.new(1,0)
    uc.Parent=dot
end


ICON_DRAW["select"] = function(parent, S, col)
    local pts = {{5,3},{19,12},{12,13},{9,20},{5,3}}
    for i=1,#pts-1 do
        drawBar(parent, pts[i][1]/24*S,pts[i][2]/24*S, pts[i+1][1]/24*S,pts[i+1][2]/24*S, 2, col)
    end
end


ICON_DRAW["move"] = function(parent, S, col)
    local T=2

    drawBar(parent, S/2,1, S/2,S-1, T,col)

    drawBar(parent, 1,S/2, S-1,S/2, T,col)

    drawBar(parent, S/2,1, S/2-4,7, T,col)
    drawBar(parent, S/2,1, S/2+4,7, T,col)

    drawBar(parent, S/2,S-1, S/2-4,S-7, T,col)
    drawBar(parent, S/2,S-1, S/2+4,S-7, T,col)

    drawBar(parent, 1,S/2, 7,S/2-4, T,col)
    drawBar(parent, 1,S/2, 7,S/2+4, T,col)

    drawBar(parent, S-1,S/2, S-7,S/2-4, T,col)
    drawBar(parent, S-1,S/2, S-7,S/2+4, T,col)
end


ICON_DRAW["scale"] = function(parent, S, col)
    local T=2; local m=3

    drawBar(parent, m,m, S-m,m, T,col)
    drawBar(parent, S-m,m, S-m,S-m, T,col)
    drawBar(parent, S-m,S-m, m,S-m, T,col)
    drawBar(parent, m,S-m, m,m, T,col)

    local i=S/2-4; local i2=S/2+4
    drawBar(parent, i,i, i2,i, T,col)
    drawBar(parent, i2,i, i2,i2, T,col)
    drawBar(parent, i2,i2, i,i2, T,col)
    drawBar(parent, i,i2, i,i, T,col)
end


ICON_DRAW["rotate"] = function(parent, S, col)
    local T = 2
    local cx = S/2; local cy = S/2
    local r  = S/2 - 5


    local segs = 10
    for i = 0, segs-1 do
        local a  = math.rad(300 - 10) + (i/segs) * math.rad(160)
        local an = math.rad(300 - 10) + ((i+1)/segs) * math.rad(160)
        drawBar(parent,
            cx + math.cos(a)*r,  cy + math.sin(a)*r,
            cx + math.cos(an)*r, cy + math.sin(an)*r,
            T, col)
    end

    local xe = cx + math.cos(math.rad(90))*r
    local ye = cy + math.sin(math.rad(90))*r
    drawBar(parent, xe, ye, xe + 5, ye + 3, T, col)
    drawBar(parent, xe, ye, xe - 5, ye + 3, T, col)


    for i = 0, segs-1 do
        local a  = math.rad(120) + (i/segs) * math.rad(150)
        local an = math.rad(120) + ((i+1)/segs) * math.rad(150)
        drawBar(parent,
            cx + math.cos(a)*r,  cy + math.sin(a)*r,
            cx + math.cos(an)*r, cy + math.sin(an)*r,
            T, col)
    end

    local xs = cx + math.cos(math.rad(270))*r
    local ys = cy + math.sin(math.rad(270))*r
    drawBar(parent, xs, ys, xs + 5, ys - 3, T, col)
    drawBar(parent, xs, ys, xs - 5, ys - 3, T, col)
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

    local segs=14
    for i=0,segs-1 do
        local a1=(i/segs)*math.pi*2
        local a2=((i+1)/segs)*math.pi*2
        drawBar(parent,
            cx+math.cos(a1)*r, cy+math.sin(a1)*r,
            cx+math.cos(a2)*r, cy+math.sin(a2)*r,
            T, col)
    end

    local segs2=10
    for i=0,segs2-1 do
        local a1=(i/segs2)*math.pi*2
        local a2=((i+1)/segs2)*math.pi*2
        drawBar(parent,
            cx+math.cos(a1)*r, cy+math.sin(a1)*(r*0.32),
            cx+math.cos(a2)*r, cy+math.sin(a2)*(r*0.32),
            T, col)
    end
end


ICON_DRAW["wedge"] = function(parent, S, col)
    local T=2
    drawBar(parent, 3,S-3, S-3,S-3, T,col)
    drawBar(parent, 3,S-3, S/2,3, T,col)
    drawBar(parent, S-3,S-3, S/2,3, T,col)
end


ICON_DRAW["cylinder"] = function(parent, S, col)
    local T=2; local cx=S/2; local ry=S*0.12; local rx=S/2-4
    local ty=5; local by=S-5

    local segs=12
    for i=0,segs-1 do
        local a1=(i/segs)*math.pi*2; local a2=((i+1)/segs)*math.pi*2
        drawBar(parent, cx+math.cos(a1)*rx,ty+math.sin(a1)*ry, cx+math.cos(a2)*rx,ty+math.sin(a2)*ry, T,col)
    end

    for i=0,segs-1 do
        local a1=(i/segs)*math.pi*2; local a2=((i+1)/segs)*math.pi*2
        drawBar(parent, cx+math.cos(a1)*rx,by+math.sin(a1)*ry, cx+math.cos(a2)*rx,by+math.sin(a2)*ry, T,col)
    end

    drawBar(parent, cx-rx,ty, cx-rx,by, T,col)
    drawBar(parent, cx+rx,ty, cx+rx,by, T,col)
end


ICON_DRAW["model"] = function(parent, S, col)
    local T=2

    local cx=S/2; local top=4; local mid=S/2; local bot=S-4
    local lx=4; local rx=S-4; local mlx=cx-5; local mrx=cx+5
    drawBar(parent, cx,top, rx,mid-4, T,col)
    drawBar(parent, rx,mid-4, cx,mid+2, T,col)
    drawBar(parent, cx,mid+2, lx,mid-4, T,col)
    drawBar(parent, lx,mid-4, cx,top, T,col)

    drawBar(parent, lx,mid-4, lx,bot-4, T,col)
    drawBar(parent, lx,bot-4, cx,bot+2, T,col)
    drawBar(parent, cx,bot+2, cx,mid+2, T,col)

    drawBar(parent, rx,mid-4, rx,bot-4, T,col)
    drawBar(parent, rx,bot-4, cx,bot+2, T,col)
end


local function injectIconIntoBtn(btn, iconKey, col)

    for _, ch in ipairs(btn:GetChildren()) do
        if ch.Name == "SL_IconOverlay" or ch.Name == "SL_IconFrame" then
            ch:Destroy()
        end
    end

    local drawFn = ICON_DRAW[iconKey]
    if not drawFn then return end


    for _, ch in ipairs(btn:GetChildren()) do
        if ch:IsA("ImageLabel") then
            pcall(function() ch.ImageTransparency = 1; ch.BackgroundTransparency = 1 end)
        elseif ch:IsA("ImageButton") then
            pcall(function() ch.ImageTransparency = 1; ch.BackgroundTransparency = 1 end)

        end
    end


    local iconF = Instance.new("Frame")
    iconF.Name = "SL_IconFrame"
    iconF.BackgroundTransparency = 1
    iconF.BorderSizePixel = 0
    iconF.ZIndex = 2
    iconF.ClipsDescendants = false


    local btnH = btn.AbsoluteSize.Y
    if btnH < 10 then btnH = 32 end
    local iconSize = math.floor(btnH * 0.52)
    if iconSize < 16 then iconSize = 16 end
    if iconSize > 28 then iconSize = 28 end

    iconF.Size = UDim2.new(0, iconSize, 0, iconSize)
    iconF.Position = UDim2.new(0.5, -iconSize/2, 0, 4)
    iconF.Parent = btn

    pcall(function() drawFn(iconF, iconSize, col) end)


    for _, ch in ipairs(btn:GetChildren()) do
        if (ch:IsA("ImageButton") or ch:IsA("TextButton")) and not ch.Name:find("SL_") then
            pcall(function()
                if ch.ZIndex < 5 then ch.ZIndex = 5 end
            end)
        end
    end
end


local ICON_MAP = {
    select   = "select",
    move     = "move",
    scale    = "scale",
    rotate   = "rotate",
    part     = "part",
    partinsert = "part",
    sphere   = "sphere",
    ball     = "sphere",
    wedge    = "wedge",
    cylinder = "cylinder",
    model    = "model",
    models   = "model",
    modelinsert = "model",
    insertmodel = "model",
    groupmodel  = "model",
    union    = "model",
    negate   = "model",
}

local function tryInjectIcons()
    for _, obj in ipairs(StudioGui:GetDescendants()) do
        if SKIP[obj.Name] then continue end
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            local n = obj.Name:lower()
            local key = ICON_MAP[n]
            if key then
                local col = isPlayObj(obj) and C.playRed or C.white
                pcall(function() injectIconIntoBtn(obj, key, col) end)
            end
        end
    end
end


-- [P1] guard table: prevents duplicate MouseEnter/MouseLeave connections
local clickFxDone = setmetatable({}, {__mode = "k"})
local function applyClickEffect(obj)

    if not (obj:IsA("TextButton") or obj:IsA("ImageButton")) then return end


    local function doApply()
        local sz = obj.AbsoluteSize
        if sz.X > 200 or sz.Y > 100 then return end
        if clickFxDone[obj] then return end
        clickFxDone[obj] = true
        obj.MouseEnter:Connect(function()
            pcall(function()
                obj.BackgroundTransparency = 0.85
                obj.BackgroundColor3 = C.white
                local st = obj:FindFirstChildOfClass("UIStroke")
                if not st then st = Instance.new("UIStroke"); st.Parent = obj end
                st.Color = Color3.fromRGB(255,255,255)
                st.Transparency = 0.5
                st.Thickness = 1
            end)
        end)
        obj.MouseLeave:Connect(function()
            pcall(function()
                obj.BackgroundTransparency = 1
                local st = obj:FindFirstChildOfClass("UIStroke")
                if st then st:Destroy() end
            end)
        end)
    end

    if obj.AbsoluteSize.X > 0 then
        doApply()
    else
        local conn; conn = obj:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            conn:Disconnect()
            doApply()
        end)
    end
end

local function setIconColor(obj, col)
    pcall(function() obj.ImageColor3 = col end)
    for _, child in ipairs(obj:GetChildren()) do
        if child:IsA("ImageLabel") or child:IsA("ImageButton") then
            if not SKIP[child.Name] then
                pcall(function() child.ImageColor3 = col end)
            end
        end
    end
end


local SL_OWNED_NAMES = {
    SL_OutputPanel=true, SL_PluginRibbon=true, SL_PluginPanel=true,
}


local THEME_ROOTS = {
    TopBar=true, MainBar=true,

    SL_OutputPanel=true, SL_PluginRibbon=true, SL_PluginPanel=true,
}


local FULLY_PROTECTED = {
    ColorPalette   = true,
    FileMenu       = true,
    SaveDetailsFrame = true,
    OpenSamplesMenu  = true,
    PublishFrame     = true,
}

local foreignRoots = {}


local ALWAYS_FOREIGN = {
    ColorPalette=true,
}


local TOOLBAR_NAMES = {
    TopBar=true, MainBar=true,
}

local function markForeignRoot(child)
    if not child or not child:IsA("GuiObject") then return end
    local n = child.Name

    if ALWAYS_FOREIGN[n] then foreignRoots[child] = true; return end

    if THEME_ROOTS[n] then return end
    if SL_OWNED_NAMES[n] then return end
    if n:sub(1,3) == "SL_" then return end

    if TOOLBAR_NAMES[n] then return end

    local isToolbar = false
    pcall(function()
        for _, ch in ipairs(child:GetDescendants()) do
            if ch:IsA("TextButton") or ch:IsA("ImageButton") then
                local cn = ch.Name:lower()
                if cn:find("play") or cn:find("select") or cn:find("move") or cn:find("toolbox") then
                    isToolbar = true; break
                end
            end
        end
    end)
    if isToolbar then return end

    foreignRoots[child] = true
end

local function isForeign(obj)

    local cur2 = obj
    while cur2 and cur2 ~= StudioGui do
        if THEME_ROOTS[cur2.Name] then return false end
        if FULLY_PROTECTED[cur2.Name] then return true end
        cur2 = cur2.Parent
    end
    if FULLY_PROTECTED[obj.Name] then return true end

    local cur = obj
    while cur do
        local p = cur.Parent
        if p == StudioGui then

            if THEME_ROOTS[cur.Name] then return false end
            if foreignRoots[cur] then return true end
            local n = cur.Name
            if SL_OWNED_NAMES[n] then return false end
            if n:sub(1,3) == "SL_" then return false end
            local isToolbar = false
            pcall(function()
                for _,ch in ipairs(cur:GetDescendants()) do
                    if ch:IsA("TextButton") or ch:IsA("ImageButton") then
                        local cn = ch.Name:lower()
                        if cn:find("play") or cn:find("select") or cn:find("move") or cn:find("toolbox") then
                            isToolbar = true; break
                        end
                    end
                end
            end)
            if isToolbar then return false end
            foreignRoots[cur] = true
            return true
        end
        if p == nil or p == game then return false end
        cur = p
    end
    return false
end

local function isOurPanel(obj)
    if SKIP[obj.Name] then return true end
    if isForeign(obj) then return true end
    local p = obj.Parent
    while p and p ~= StudioGui do
        local pn = p.Name
        if pn == "SL_OutputPanel" or pn == "SL_PluginRibbon"
        or pn == "SL_PluginPanel"
        or pn == "ExplorerPanel" or pn == "PropertiesPanel" then
            return true
        end
        p = p.Parent
    end

    local on = obj.Name
    if on == "ExplorerPanel" or on == "PropertiesPanel" then return true end
    return false
end


task.defer(function()
    task.wait(0.5)
    pcall(function()
        for _,child in ipairs(StudioGui:GetChildren()) do
            markForeignRoot(child)
        end
    end)
end)


StudioGui.ChildAdded:Connect(function(child)
    task.wait(0.02)
    pcall(function() markForeignRoot(child) end)
end)
StudioGui.ChildRemoved:Connect(function(child)
    foreignRoots[child] = nil
end)

local function isInFileOrColorPicker(obj)
    local cur = obj.Parent
    while cur and cur ~= StudioGui do
        local n = cur.Name
        if n == "File" or n == "FileMenu" or n == "ColorPalette"
        or n == "OpenSamplesMenu" or n == "SaveDetailsFrame"
        or n == "PublishFrame" then
            return true
        end
        cur = cur.Parent
    end
    return false
end

local function fixAll()
    for _, obj in ipairs(StudioGui:GetDescendants()) do
        if SKIP[obj.Name] then continue end
        if isOurPanel(obj) then continue end
        if isInFileOrColorPicker(obj) then continue end
        pcall(function()

            if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                if obj.BackgroundTransparency >= 0.95 then return end
                local c = obj.BackgroundColor3; local b = br(c)
                if isBlue(c) and b > 0.15 then
                    obj.BackgroundColor3 = C.expSel; addRounded(obj); return
                end
                if     b > 0.85 then obj.BackgroundColor3 = C.c0
                elseif b > 0.65 then obj.BackgroundColor3 = C.c1
                elseif b > 0.45 then obj.BackgroundColor3 = C.c2
                else                 obj.BackgroundColor3 = C.c3 end

            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if obj.BackgroundTransparency < 0.95 then
                    local c = obj.BackgroundColor3; local b = br(c)
                    if isBlue(c) and b > 0.15 then
                        obj.BackgroundColor3 = C.expSel; addRounded(obj)
                    elseif b > 0.5 then obj.BackgroundColor3 = C.c2 end
                end

                if obj.TextTransparency < 0.99 then
                    obj.TextColor3 = isPlayObj(obj) and C.playRed or C.white
                end
                if obj:IsA("TextButton") then
                    local col = isPlayObj(obj) and C.playRed or C.white
                    setIconColor(obj, col)
                    if obj.BackgroundTransparency < 0.95 then
                        obj.BackgroundTransparency = 1
                        obj.BorderSizePixel = 0
                    end
                    applyClickEffect(obj)
                end

            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                if obj.BackgroundTransparency < 0.95 then
                    local c = obj.BackgroundColor3; local b = br(c)
                    if isBlue(c) and b > 0.15 then obj.BackgroundColor3 = C.expSel
                    elseif b > 0.5 then obj.BackgroundColor3 = C.c2 end
                end
                local col = isPlayObj(obj) and C.playRed or C.white
                setIconColor(obj, col)
                if obj:IsA("ImageButton") then
                    applyClickEffect(obj)
                end

            elseif obj:IsA("UIStroke") then
                if not isBlue(obj.Color) then obj.Color = C.border end
            end
        end)
    end
end


StudioGui.DescendantAdded:Connect(function(desc)
    task.wait(0.05)
    if not desc or not desc.Parent then return end
    if SKIP[desc.Name] then return end
    if isForeign(desc) then return end
    if isOurPanel(desc) then return end
    if isInFileOrColorPicker(desc) then return end

    if not desc:IsA("GuiObject") then return end
    pcall(function()
        local col = isPlayObj(desc) and C.playRed or C.white

        if desc:IsA("ImageLabel") or desc:IsA("ImageButton") then
            setIconColor(desc, col)
            if desc:IsA("ImageButton") then applyClickEffect(desc) end

        elseif desc:IsA("TextButton") then
            desc.TextColor3 = col
            setIconColor(desc, col)
            if desc.BackgroundTransparency < 0.95 then
                desc.BackgroundTransparency = 1
                desc.BorderSizePixel = 0
            end
            applyClickEffect(desc)

        elseif desc:IsA("TextLabel") or desc:IsA("TextBox") then

            pcall(function() lockTextWhite(desc) end)

        elseif desc:IsA("Frame") or desc:IsA("ScrollingFrame") then
            if desc.BackgroundTransparency >= 0.95 then return end
            local c = desc.BackgroundColor3; local b = br(c)
            if isBlue(c) and b > 0.15 then
                desc.BackgroundColor3 = C.expSel; addRounded(desc); return
            end
            if     b > 0.85 then desc.BackgroundColor3 = C.c0
            elseif b > 0.65 then desc.BackgroundColor3 = C.c1
            elseif b > 0.45 then desc.BackgroundColor3 = C.c2
            else                  desc.BackgroundColor3 = C.c3 end
        end
    end)
end)


local function drawLine(parent, x1,y1, x2,y2, thick, col, zi, name)
    local dx=x2-x1; local dy=y2-y1
    local len=math.sqrt(dx*dx+dy*dy)
    if len<1 then return end
    local bar=Instance.new("Frame")
    bar.Name = name or "TerrainBar"
    bar.Size=UDim2.new(0,math.ceil(len),0,thick)
    bar.Position=UDim2.new(0,math.floor((x1+x2)/2-len/2),0,math.floor((y1+y2)/2-thick/2))
    bar.Rotation=math.deg(math.atan2(dy,dx))
    bar.BackgroundColor3 = col or C.white
    bar.BorderSizePixel=0
    bar.ZIndex = zi or 50
    bar.Parent=parent
    local cap=Instance.new("UICorner")
    cap.CornerRadius=UDim.new(1,0)
    cap.Parent=bar
end


local cachedToolbar = nil

local function findToolbar()
    if cachedToolbar and cachedToolbar.Parent then return cachedToolbar end
    for _,obj in ipairs(StudioGui:GetDescendants()) do
        if obj:IsA("ImageButton") or obj:IsA("TextButton") then
            local n=obj.Name:lower()
            if n:find("toolbox") or n:find("play") then
                local p=obj.Parent
                if p and (p:IsA("Frame") or p:IsA("ScrollingFrame")) then
                    cachedToolbar=p; return p
                end
            end
        end
    end
    return nil
end


local function getToolbarMaxX(toolbar)
    local maxX=0
    for _,ch in ipairs(toolbar:GetChildren()) do
        if ch:IsA("GuiObject") and not ch:IsA("UIListLayout") and not ch:IsA("UICorner") then
            pcall(function()
                local x=(ch.AbsolutePosition.X-toolbar.AbsolutePosition.X)+ch.AbsoluteSize.X
                if x>maxX then maxX=x end
            end)
        end
    end
    return maxX
end


local function makeToolbarBtn(toolbar, offsetX, label, drawFn, onClickFn)
    local SIZE=24; local THICK=2
    local H=toolbar.AbsoluteSize.Y
    local padY=math.max(2,math.floor((H-SIZE-14)/2))
    local W=SIZE+20

    local cont=Instance.new("Frame")
    cont.Name="SL_CustomBtn_"..label
    cont.Size=UDim2.new(0,W,1,0)
    cont.Position=UDim2.new(0,offsetX,0,0)
    cont.BackgroundColor3=C.c1
    cont.BackgroundTransparency=0.18
    cont.BorderSizePixel=0
    cont.ClipsDescendants=false
    cont.ZIndex=40
    cont.Parent=toolbar
    local tileCorner=Instance.new("UICorner")
    tileCorner.CornerRadius=UDim.new(0,7)
    tileCorner.Parent=cont
    local tileStroke=Instance.new("UIStroke")
    tileStroke.Color=C.border
    tileStroke.Thickness=1
    tileStroke.Transparency=0.22
    tileStroke.Parent=cont


    local iconF=Instance.new("Frame")
    iconF.Name="SL_IconDraw_"..label
    iconF.Size=UDim2.new(0,SIZE,0,SIZE)
    iconF.Position=UDim2.new(0,W/2-SIZE/2,0,padY)
    iconF.BackgroundTransparency=1
    iconF.ClipsDescendants=false
    iconF.ZIndex=45
    iconF.Parent=cont


    pcall(function() drawFn(iconF, SIZE, THICK) end)


    local lbl=Instance.new("TextLabel")
    lbl.Name="SL_LblDraw_"..label
    lbl.Size=UDim2.new(0,W,0,13)
    lbl.Position=UDim2.new(0,0,0,padY+SIZE+2)
    lbl.BackgroundTransparency=1
    lbl.Text=label
    lbl.TextColor3=C.white
    lbl.TextSize=8
    lbl.Font=Enum.Font.GothamSemibold
    lbl.TextXAlignment=Enum.TextXAlignment.Center
    lbl.ZIndex=40
    lbl.Parent=cont


    local btn=Instance.new("TextButton")
    btn.Name="SL_ClickBtn_"..label
    btn.Size=UDim2.new(1,0,1,0)
    btn.BackgroundTransparency=1
    btn.Text=""
    btn.ZIndex=60
    btn.Parent=cont


    btn.Activated:Connect(function()
        pcall(onClickFn)
    end)
    btn.MouseEnter:Connect(function()
        cont.BackgroundColor3=C.c2
        local st=cont:FindFirstChildOfClass("UIStroke")
        if st then st.Color=C.expSelB; st.Transparency=0 end
    end)
    btn.MouseLeave:Connect(function()
        cont.BackgroundColor3=C.c1
        local st=cont:FindFirstChildOfClass("UIStroke")
        if st then st.Color=C.border; st.Transparency=0.22 end
    end)

    return cont, W
end


local function drawBlock(iconF, S, T)

    local cx=S/2

    drawLine(iconF, cx,3,    S-3,S/2-3, T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, S-3,S/2-3, cx,S/2+2, T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, cx,S/2+2, 3,S/2-3,  T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, 3,S/2-3,  cx,3,     T,C.white,46,"SL_IconOverlay")

    drawLine(iconF, 3,S/2-3,  3,S-5,    T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, 3,S-5,    cx,S-2,   T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, cx,S-2,   cx,S/2+2, T,C.white,46,"SL_IconOverlay")

    drawLine(iconF, S-3,S/2-3, S-3,S-5, T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, S-3,S-5,   cx,S-2,  T,C.white,46,"SL_IconOverlay")
end

local function drawBall(iconF, S, T)

    local cx=S/2; local cy=S/2; local r=S/2-3
    local segs=14
    for i=0,segs-1 do
        local a1=(i/segs)*math.pi*2
        local a2=((i+1)/segs)*math.pi*2
        drawLine(iconF,
            cx+math.cos(a1)*r, cy+math.sin(a1)*r,
            cx+math.cos(a2)*r, cy+math.sin(a2)*r,
            T,C.white,46,"SL_IconOverlay")
    end

    for i=0,9 do
        local a1=(i/10)*math.pi*2; local a2=((i+1)/10)*math.pi*2
        drawLine(iconF,
            cx+math.cos(a1)*r, cy+math.sin(a1)*(r*0.3),
            cx+math.cos(a2)*r, cy+math.sin(a2)*(r*0.3),
            T,C.white,46,"SL_IconOverlay")
    end
end

local function drawCylinder(iconF, S, T)
    local cx=S/2; local ry=S*0.14; local rx=S/2-3
    local ty=4; local by=S-4
    local segs=12

    for i=0,segs-1 do
        local a1=(i/segs)*math.pi*2; local a2=((i+1)/segs)*math.pi*2
        drawLine(iconF, cx+math.cos(a1)*rx,ty+math.sin(a1)*ry,
                        cx+math.cos(a2)*rx,ty+math.sin(a2)*ry, T,C.white,46,"SL_IconOverlay")
    end

    for i=0,segs-1 do
        local a1=(i/segs)*math.pi*2; local a2=((i+1)/segs)*math.pi*2
        drawLine(iconF, cx+math.cos(a1)*rx,by+math.sin(a1)*ry,
                        cx+math.cos(a2)*rx,by+math.sin(a2)*ry, T,C.white,46,"SL_IconOverlay")
    end

    drawLine(iconF, cx-rx,ty, cx-rx,by, T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, cx+rx,ty, cx+rx,by, T,C.white,46,"SL_IconOverlay")
end

local function drawWedge(iconF, S, T)

    drawLine(iconF, 3,S-3,   S-3,S-3, T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, 3,S-3,   S/2,3,   T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, S-3,S-3, S/2,3,   T,C.white,46,"SL_IconOverlay")
end

local function drawCornerWedge(iconF, S, T)

    drawLine(iconF, 3,S-3,   S-3,S-3, T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, 3,S-3,   3,3,     T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, 3,3,     S-3,S-3, T,C.white,46,"SL_IconOverlay")

    drawLine(iconF, 3,3,     S-3,3,   T,C.white,46,"SL_IconOverlay")
    drawLine(iconF, S-3,3,   S-3,S-3, T,C.white,46,"SL_IconOverlay")
end

local function drawTerrainIcon(iconF, S, T)
    local sc=S/24
    local pts={{3,20},{9,8},{13,16},{16,11},{21,20},{3,20}}
    for i=1,#pts-1 do
        drawLine(iconF,pts[i][1]*sc,pts[i][2]*sc,pts[i+1][1]*sc,pts[i+1][2]*sc,T,C.white,46,"TerrainBar")
    end
end


local partsDone = false


local function triggerPartInsert(partName)
    pcall(function()
        local workspace = game:GetService("Workspace")
        local camera = workspace.CurrentCamera

        local spawnCFrame = CFrame.new(0, 5, 0)
        if camera then
            local cf      = camera.CFrame
            local forward = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z).Unit
            if forward.Magnitude < 0.01 then forward = Vector3.new(0,0,-1) end
            local pos = cf.Position + forward * 18

            spawnCFrame = CFrame.new(pos.X, math.max(pos.Y, 3), pos.Z)
        end

        local newPart
        if partName == "Block" then
            newPart = Instance.new("Part")
            newPart.Shape = Enum.PartType.Block
        elseif partName == "Ball" then
            newPart = Instance.new("Part")
            newPart.Shape = Enum.PartType.Ball
        elseif partName == "Cylinder" then
            newPart = Instance.new("Part")
            newPart.Shape = Enum.PartType.Cylinder
        elseif partName == "Wedge" then
            newPart = Instance.new("WedgePart")
        elseif partName == "CornerWedge" then
            newPart = Instance.new("CornerWedgePart")
        else
            newPart = Instance.new("Part")
        end

        newPart.Size      = Vector3.new(4, 1.2, 2)
        newPart.CFrame    = spawnCFrame
        newPart.Anchored  = true
        newPart.CanCollide = true
        newPart.Material  = Enum.Material.SmoothPlastic
        newPart.BrickColor = BrickColor.new("Medium stone grey")


        newPart.Parent = workspace

        pcall(function()
            local sel = game:GetService("Selection")
            if sel then sel:Set({newPart}) end
        end)
        print("[SL Theme] Inserted: " .. partName)
    end)
end

local function injectPartButtons()
    if partsDone then return end
    local toolbar = findToolbar()
    if not toolbar then return end
    if toolbar:FindFirstChild("SL_CustomBtn_Block") then partsDone=true; return end


    for _, obj in ipairs(toolbar:GetChildren()) do
        local n = obj.Name:lower()
        if n:find("part") or n:find("insert") then
            pcall(function()
                obj.Visible = false
                obj.BackgroundTransparency = 1
                for _, ch in ipairs(obj:GetDescendants()) do
                    pcall(function()
                        if ch:IsA("GuiObject") then ch.Visible = false end
                    end)
                end
            end)
        end
    end


    local maxX = getToolbarMaxX(toolbar)

    local SIZE=24; local THICK=2
    local H=toolbar.AbsoluteSize.Y
    local padY=math.max(2,math.floor((H-SIZE-14)/2))


    local parts = {
        {"Block",       drawBlock,       "Block"},
        {"Ball",        drawBall,        "Ball"},
        {"Cylinder",    drawCylinder,    "Cylinder"},
        {"Wedge",       drawWedge,       "Wedge"},
        {"Corner",      drawCornerWedge, "CornerWedge"},
    }

    local GAP = 3
    local curX = maxX + GAP


    local sep = Instance.new("Frame")
    sep.Name = "SL_Separator_Parts"
    sep.Size = UDim2.new(0, 1, 0, math.floor(H * 0.55))
    sep.Position = UDim2.new(0, curX + 2, 0, math.floor(H * 0.225))
    sep.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    sep.BorderSizePixel = 0
    sep.ZIndex = 200
    sep.Parent = toolbar
    curX = curX + 8

    for _, def in ipairs(parts) do
        local label, drawFn, partType = def[1], def[2], def[3]
        local W = SIZE + 20

        local cont = Instance.new("Frame")
        cont.Name = "SL_CustomBtn_"..label
        cont.Size = UDim2.new(0, W, 1, 0)
        cont.Position = UDim2.new(0, curX, 0, 0)
        cont.BackgroundColor3 = C.c1
        cont.BackgroundTransparency = 0.18
        cont.BorderSizePixel = 0
        cont.ClipsDescendants = false
        cont.ZIndex = 200
        cont.Parent = toolbar
        local tileCorner = Instance.new("UICorner")
        tileCorner.CornerRadius = UDim.new(0, 7)
        tileCorner.Parent = cont
        local tileStroke = Instance.new("UIStroke")
        tileStroke.Color = C.border
        tileStroke.Thickness = 1
        tileStroke.Transparency = 0.22
        tileStroke.Parent = cont


        local iconF = Instance.new("Frame")
        iconF.Name = "SL_IconDraw_"..label
        iconF.Size = UDim2.new(0, SIZE, 0, SIZE)
        iconF.Position = UDim2.new(0, W/2-SIZE/2, 0, padY)
        iconF.BackgroundTransparency = 1
        iconF.ClipsDescendants = false
        iconF.ZIndex = 210
        iconF.Parent = cont
        pcall(function() drawFn(iconF, SIZE, THICK) end)


        local lbl = Instance.new("TextLabel")
        lbl.Name = "SL_LblDraw_"..label
        lbl.Size = UDim2.new(0, W, 0, 13)
        lbl.Position = UDim2.new(0, 0, 0, padY+SIZE+2)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C.white
        lbl.TextSize = 8
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.ZIndex = 205
        lbl.Parent = cont


        local btn = Instance.new("TextButton")
        btn.Name = "SL_ClickBtn_"..label
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 220
        btn.Parent = cont


        local capturedType = partType
        btn.Activated:Connect(function()
            pcall(function() triggerPartInsert(capturedType) end)
        end)
        btn.MouseEnter:Connect(function()
            cont.BackgroundColor3 = C.c2
            local st = cont:FindFirstChildOfClass("UIStroke")
            if st then st.Color = C.expSelB; st.Transparency = 0 end
        end)
        btn.MouseLeave:Connect(function()
            cont.BackgroundColor3 = C.c1
            local st = cont:FindFirstChildOfClass("UIStroke")
            if st then st.Color = C.border; st.Transparency = 0.22 end
        end)

        curX = curX + W + GAP
    end

    partsDone = true
    print("[SL Theme] Part buttons injected!")
end


-- [P7] weak-key table: prevents memory leak for destroyed objects
local lockedWhite = setmetatable({}, {__mode = "k"})

local function lockTextWhite(obj)
    if lockedWhite[obj] then return end
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end

    if isForeign(obj) then return end

    if isOurPanel(obj) then return end

    local p = obj.Parent
    while p and p ~= StudioGui do
        local pn = p.Name
        if pn == "File" or pn == "FileMenu"
        or pn == "ColorPalette"
        or pn == "OpenSamplesMenu" or pn == "SaveDetailsFrame"
        or pn == "PublishFrame" then
            return
        end
        p = p.Parent
    end
    lockedWhite[obj] = true
    local targetCol = isPlayObj(obj) and C.playRed or C.white
    pcall(function() obj.TextColor3 = targetCol end)
    obj:GetPropertyChangedSignal("TextColor3"):Connect(function()
        pcall(function()
            if obj.TextColor3 ~= targetCol then
                obj.TextColor3 = targetCol
            end
        end)
    end)
end

local function forceWhiteText()
    for _, obj in ipairs(StudioGui:GetDescendants()) do
        if SKIP[obj.Name] then continue end
        if isOurPanel(obj) then continue end
        pcall(function() lockTextWhite(obj) end)
    end
end


local function startPersistentWhiteText()

end


local function disableMultiSelect()
    pcall(function()
        local sel = game:GetService("Selection")
        if not sel then return end
        local enforcing = false
        sel.SelectionChanged:Connect(function()
            if enforcing then return end
            if _G.SL_PluginSelectActive then return end
            task.defer(function()
                if enforcing then return end
                if _G.SL_PluginSelectActive then return end
                enforcing = true
                pcall(function()
                    local items = sel:Get()
                    if #items > 1 then


                        sel:Set({items[1]})
                    end
                end)
                enforcing = false
            end)
        end)
    end)
end


local terrainDone = false

local function injectTerrain()
    if terrainDone then return end
    local toolbar = findToolbar()
    if not toolbar then warn("[SL Theme] Toolbar tidak ketemu"); return end
    if toolbar:FindFirstChild("SL_TerrainBtn") then terrainDone=true; return end

    local maxX = getToolbarMaxX(toolbar)
    local SIZE=26; local THICK=2
    local H=toolbar.AbsoluteSize.Y
    local padY=math.max(2,math.floor((H-SIZE-14)/2))
    local W=SIZE+14


    local sepT = Instance.new("Frame")
    sepT.Name = "SL_Separator_Terrain"
    sepT.Size = UDim2.new(0, 1, 0, math.floor(H * 0.55))
    sepT.Position = UDim2.new(0, maxX + 6, 0, math.floor(H * 0.225))
    sepT.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    sepT.BorderSizePixel = 0
    sepT.ZIndex = 200
    sepT.Parent = toolbar

    local cont=Instance.new("Frame")
    cont.Name="SL_TerrainBtn"
    cont.Size=UDim2.new(0,W,1,0)
    cont.Position=UDim2.new(0,maxX+14,0,0)
    cont.BackgroundTransparency=1
    cont.ClipsDescendants=false
    cont.ZIndex=200
    cont.Parent=toolbar

    local iconF=Instance.new("Frame")
    iconF.Name="TerrainIconDraw"
    iconF.Size=UDim2.new(0,SIZE,0,SIZE)
    iconF.Position=UDim2.new(0,W/2-SIZE/2,0,padY)
    iconF.BackgroundTransparency=1
    iconF.ClipsDescendants=false
    iconF.ZIndex=210
    iconF.Parent=cont

    drawTerrainIcon(iconF, SIZE, THICK)

    local lbl=Instance.new("TextLabel")
    lbl.Name="TerrainLabel"
    lbl.Size=UDim2.new(0,W,0,13)
    lbl.Position=UDim2.new(0,0,0,padY+SIZE+2)
    lbl.BackgroundTransparency=1
    lbl.Text="Terrain"
    lbl.TextColor3=C.white
    lbl.TextSize=9
    lbl.Font=Enum.Font.GothamBold
    lbl.TextXAlignment=Enum.TextXAlignment.Center
    lbl.ZIndex=205
    lbl.Parent=cont

    local btn=Instance.new("TextButton")
    btn.Name="TerrainClickBtn"
    btn.Size=UDim2.new(1,0,1,0)
    btn.BackgroundTransparency=1
    btn.Text=""
    btn.ZIndex=220
    btn.Parent=cont

    btn.MouseEnter:Connect(function()
        pcall(function()
            btn.BackgroundTransparency=0.85; btn.BackgroundColor3=C.white
            local st=btn:FindFirstChildOfClass("UIStroke")
            if not st then st=Instance.new("UIStroke"); st.Parent=btn end
            st.Color=Color3.fromRGB(255,255,255); st.Transparency=0.5; st.Thickness=1
        end)
    end)
    btn.MouseLeave:Connect(function()
        pcall(function()
            btn.BackgroundTransparency=1
            local st=btn:FindFirstChildOfClass("UIStroke"); if st then st:Destroy() end
        end)
    end)

    btn.MouseButton1Click:Connect(function()

        if _G.SL_OpenTerrain then
            _G.SL_OpenTerrain()
        end
    end)

    terrainDone=true
    print("[STUDIO LITE BY EZY] Terrain button injected!")
end
-- ===================== PART 1 of 4 : END (last line: end of injectTerrain) =====================
-- ===================== PART 2 of 4 : BEGIN (paste directly after Part 1) =====================
local SL_OUTPUT_LINES = {}
local SL_OUTPUT_MAX   = 200
local outputVisible   = false
local outputPanel     = nil
local outputScroll    = nil
local outputMenuBtn   = nil
-- [P4] row queue + monotonic order counter
local outputRowQueue  = {}
local outputSeq       = 0


local OUT_COL = {
    print   = C.white,
    warn    = Color3.fromRGB(255, 200, 60),
    error   = Color3.fromRGB(255, 80,  80),
    info    = Color3.fromRGB(100, 180, 255),
}


local function fmtTime()
    pcall(function()
        local t = os.date("*t")
        if t and t.hour then
            return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
        end
    end)

    local s = math.floor(tick()) % 86400
    local h = math.floor(s/3600)
    local m = math.floor((s%3600)/60)
    local sec = s % 60
    return string.format("%02d:%02d:%02d", h, m, sec)
end


local function outputAddLine(msgType, text)

    table.insert(SL_OUTPUT_LINES, { t=msgType, s=tostring(text), time=fmtTime() })
    if #SL_OUTPUT_LINES > SL_OUTPUT_MAX then
        table.remove(SL_OUTPUT_LINES, 1)
    end


    if not outputScroll then return end
    if not outputVisible then return end


    pcall(function()
        local row = Instance.new("Frame")
        row.Name = "SL_OutputRow"
        row.Size = UDim2.new(1, -8, 0, 18)
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        outputSeq = outputSeq + 1
        row.LayoutOrder = outputSeq
        row.Parent = outputScroll


        local prefix = { print="", warn="⚠  ", error="✖ ", info="ℹ " }
        local lbl = Instance.new("TextLabel")
        lbl.Name = "SL_OutputRow"
        lbl.Size = UDim2.new(1, -4, 1, 0)
        lbl.Position = UDim2.new(0, 4, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "[" .. (SL_OUTPUT_LINES[#SL_OUTPUT_LINES].time) .. "] " .. (prefix[msgType] or "") .. tostring(text)
        lbl.TextColor3 = OUT_COL[msgType] or OUT_COL.print
        lbl.TextSize = 12
        lbl.Font = Enum.Font.Code
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.ZIndex = 310
        lbl.Parent = row

        outputRowQueue[#outputRowQueue + 1] = row
        if #outputRowQueue > SL_OUTPUT_MAX then
            local oldRow = table.remove(outputRowQueue, 1)
            if oldRow then oldRow:Destroy() end
        end

        task.defer(function()
            pcall(function()
                outputScroll.CanvasSize = UDim2.new(0, 0, 0, #outputRowQueue * 19)
                outputScroll.CanvasPosition = Vector2.new(0, math.huge)
            end)
        end)
    end)
end


local function outputRebuild()
    if not outputScroll then return end
    pcall(function()
        for _, ch in ipairs(outputScroll:GetChildren()) do
            if not ch:IsA("UIListLayout") then ch:Destroy() end
        end
        outputRowQueue = {}
        for i, line in ipairs(SL_OUTPUT_LINES) do
            local row = Instance.new("Frame")
            row.Name = "SL_OutputRow"
            row.Size = UDim2.new(1, -8, 0, 18)
            row.BackgroundTransparency = (#SL_OUTPUT_LINES - i) % 2 == 0 and 1 or 0.94
            row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            row.BorderSizePixel = 0
            row.LayoutOrder = i
            row.Parent = outputScroll
            outputRowQueue[#outputRowQueue + 1] = row

            local prefix = { print="", warn="⚠  ", error="✖ ", info="ℹ " }
            local lbl = Instance.new("TextLabel")
            lbl.Name = "SL_OutputRow"
            lbl.Size = UDim2.new(1, -4, 1, 0)
            lbl.Position = UDim2.new(0, 4, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "[" .. line.time .. "] " .. (prefix[line.t] or "") .. line.s
            lbl.TextColor3 = OUT_COL[line.t] or OUT_COL.print
            lbl.TextSize = 12
            lbl.Font = Enum.Font.Code
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.ZIndex = 310
            lbl.Parent = row
        end
        outputSeq = #SL_OUTPUT_LINES
        outputScroll.CanvasSize = UDim2.new(0, 0, 0, #SL_OUTPUT_LINES * 19)
        outputScroll.CanvasPosition = Vector2.new(0, math.huge)
    end)
end


local function toggleOutput()
    outputVisible = not outputVisible
    if outputPanel then
        outputPanel.Visible = outputVisible
        if outputVisible then outputRebuild() end
    end
    if outputMenuBtn then
        outputMenuBtn.BackgroundTransparency = outputVisible and 0.7 or 1
        outputMenuBtn.BackgroundColor3 = outputVisible and C.expSel or C.c1
    end
end


local function buildOutputPanel(screenGui)
    if outputPanel then return end

    local function getOutputWidth()
        local w = StudioGui.AbsoluteSize.X
        return math.max(220, math.min(math.floor(w * 0.88), w - 16))
    end
    local function getOutputHeight()
        return math.floor(math.clamp(StudioGui.AbsoluteSize.Y * 0.34, 160, 280))
    end


    local panel = Instance.new("Frame")
    panel.Name = "SL_OutputPanel"
    local ow = getOutputWidth()
    panel.Size = UDim2.new(0, ow, 0, getOutputHeight())
    panel.Position = UDim2.new(0, 8, 1, -(getOutputHeight() + 8))
    panel.BackgroundColor3 = C.c0
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.ZIndex = 300
    panel.ClipsDescendants = true
    panel.Parent = StudioGui
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 10)
    panelCorner.Parent = panel
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = C.border
    panelStroke.Thickness = 1
    panelStroke.Transparency = 0.12
    panelStroke.Parent = panel


    local topBorder = Instance.new("Frame")
    topBorder.Name = "SL_OutputHeader"
    topBorder.Size = UDim2.new(1, 0, 0, 2)
    topBorder.Position = UDim2.new(0, 0, 0, 0)
    topBorder.BackgroundColor3 = C.expSelB
    topBorder.BorderSizePixel = 0
    topBorder.ZIndex = 305
    topBorder.Parent = panel


    local header = Instance.new("Frame")
    header.Name = "SL_OutputHeader"
    header.Size = UDim2.new(1, 0, 0, 30)
    header.Position = UDim2.new(0, 0, 0, 2)
    header.BackgroundColor3 = C.c1
    header.BorderSizePixel = 0
    header.ZIndex = 305
    header.Parent = panel


    local title = Instance.new("TextLabel")
    title.Name = "SL_OutputHeader"
    title.Size = UDim2.new(0, 80, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Output"
    title.TextColor3 = C.white
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 306
    title.Parent = header


    local clearBtn = Instance.new("TextButton")
    clearBtn.Name = "SL_OutputBtn"
    clearBtn.Size = UDim2.new(0, 54, 0, 22)
    clearBtn.Position = UDim2.new(1, -116, 0, 4)
    clearBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    clearBtn.BackgroundTransparency = 0
    clearBtn.Text = "Clear"
    clearBtn.TextColor3 = C.white
    clearBtn.TextSize = 11
    clearBtn.Font = Enum.Font.Gotham
    clearBtn.ZIndex = 310
    clearBtn.Parent = header
    local uc1 = Instance.new("UICorner"); uc1.CornerRadius = UDim.new(0,4); uc1.Parent = clearBtn
    clearBtn.MouseButton1Click:Connect(function()
        SL_OUTPUT_LINES = {}
        outputRebuild()
    end)


    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "SL_OutputBtn"
    closeBtn.Size = UDim2.new(0, 28, 0, 22)
    closeBtn.Position = UDim2.new(1, -34, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    closeBtn.BackgroundTransparency = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = C.white
    closeBtn.TextSize = 11
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 310
    closeBtn.Parent = header
    local uc2 = Instance.new("UICorner"); uc2.CornerRadius = UDim.new(0,4); uc2.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function()
        toggleOutput()
    end)


    local dragging = false
    local dragStart, startPos
    header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = panel.Position
        end
    end)
    header.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    header.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseMovement) then
            pcall(function()
                local delta = inp.Position - dragStart
                -- [P6] keep the panel on screen while dragging
                local pa = StudioGui.AbsoluteSize
                local nx = math.clamp(startPos.X.Offset + delta.X, 0, math.max(0, pa.X - panel.AbsoluteSize.X))
                local ny = math.clamp(startPos.Y.Offset + delta.Y, -pa.Y, -30)
                panel.Position = UDim2.new(0, nx, 1, ny)
            end)
        end
    end)


    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "SL_OutputScroll"
    scroll.Size = UDim2.new(1, 0, 1, -32)
    scroll.Position = UDim2.new(0, 0, 0, 32)
    scroll.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    scroll.BackgroundTransparency = 0
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 90)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ZIndex = 305
    scroll.Parent = panel

    local listL = Instance.new("UIListLayout")
    listL.SortOrder = Enum.SortOrder.LayoutOrder
    listL.Padding = UDim.new(0, 1)
    listL.Parent = scroll

    outputPanel = panel
    outputScroll = scroll


    local function syncOutputWidth()
        if not panel.Parent then return end
        local width = getOutputWidth()
        local height = getOutputHeight()
        panel.Size = UDim2.new(0, width, 0, height)
        local maxX = math.max(0, StudioGui.AbsoluteSize.X - width)
        local x = math.clamp(panel.Position.X.Offset, 0, maxX)
        panel.Position = UDim2.new(0, x, 1, -(height + 8))
    end
    StudioGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncOutputWidth)

    task.spawn(function()
        task.wait(2)
        syncOutputWidth()
        task.wait(3)
        syncOutputWidth()
    end)

    print("[SL Theme] Custom Output Panel siap!")
end


local _origPrint = print
local _origWarn  = warn


local function packMsg(...)
    local n = select("#", ...)
    local parts = {}
    for i = 1, n do
        parts[i] = tostring(select(i, ...))
    end
    return table.concat(parts, "  "), n, {...}
end


local function sl_print(...)
    local msg, n, args = packMsg(...)
    pcall(function() outputAddLine("print", msg) end)

    pcall(_origPrint, unpack(args, 1, n))
end


local function sl_warn(...)
    local msg, n, args = packMsg(...)
    pcall(function() outputAddLine("warn", msg) end)
    pcall(_origWarn, unpack(args, 1, n))
end


pcall(function() getfenv(0).print = sl_print end)
pcall(function() getfenv(0).warn  = sl_warn  end)

print = sl_print
warn  = sl_warn


pcall(function()
    game:GetService("ScriptContext").Error:Connect(function(msg, trace, script)
        local short = tostring(msg):match("([^\n]+)") or tostring(msg)
        outputAddLine("error", short)
    end)
end)


local function hideDefaultOutput()
    for _, obj in ipairs(StudioGui:GetDescendants()) do
        pcall(function()
            local n = obj.Name:lower()

            if (n == "outputpanel" or n == "output" or n == "outputframe"
                or n == "outputwindow" or n == "outputcontainer")
                and obj:IsA("GuiObject") then

                if not obj.Name:find("SL_") then
                    obj.Visible = false

                    obj:GetPropertyChangedSignal("Visible"):Connect(function()
                        if obj.Visible then
                            task.defer(function()
                                pcall(function() obj.Visible = false end)
                            end)
                        end
                    end)
                end
            end
        end)
    end

    StudioGui.DescendantAdded:Connect(function(obj)
        task.wait(0.05)
        pcall(function()
            local n = obj.Name:lower()
            if (n == "outputpanel" or n == "output" or n == "outputframe"
                or n == "outputwindow" or n == "outputcontainer")
                and obj:IsA("GuiObject") and not obj.Name:find("SL_") then
                obj.Visible = false
                obj:GetPropertyChangedSignal("Visible"):Connect(function()
                    if obj.Visible then
                        task.defer(function()
                            pcall(function() obj.Visible = false end)
                        end)
                    end
                end)
            end
        end)
    end)
end


local menuBarDone = false


local pluginRibbonActive = false
local pluginRibbonFrame  = nil
local pluginMenuBtn      = nil
local togglePluginRibbon


local function findMenuBar()

    for _, obj in ipairs(StudioGui:GetDescendants()) do
        if obj:IsA("TextButton") then
            local n = obj.Name:lower()
            if n == "file" or n == "splash" then
                local p = obj.Parent
                if p and (p:IsA("Frame") or p:IsA("ScreenGui")) then
                    return p
                end
            end
        end
    end
    return nil
end

local function fixFileMenuZIndex()

    for _, obj in ipairs(StudioGui:GetDescendants()) do
        pcall(function()
            local n = obj.Name:lower()


            if (n:find("menu") or n:find("popup") or n:find("dropdown") or n:find("filemenu"))
                and obj:IsA("GuiObject") then

                obj.ZIndex = math.max(obj.ZIndex, 500)
                for _, ch in ipairs(obj:GetDescendants()) do
                    pcall(function()
                        if ch:IsA("GuiObject") then
                            ch.ZIndex = math.max(ch.ZIndex, 500)
                        end
                    end)
                end
            end
        end)
    end

    StudioGui.DescendantAdded:Connect(function(obj)
        task.wait(0.02)
        pcall(function()
            local n = obj.Name:lower()
            if (n:find("menu") or n:find("popup") or n:find("dropdown") or n:find("filemenu"))
                and obj:IsA("GuiObject") then
                obj.ZIndex = math.max(obj.ZIndex, 500)
                for _, ch in ipairs(obj:GetDescendants()) do
                    pcall(function()
                        if ch:IsA("GuiObject") then
                            ch.ZIndex = math.max(ch.ZIndex, 500)
                        end
                    end)
                end
            end
        end)
    end)
end

local function injectOutputMenuBtn()
    if menuBarDone then return end
    local menuBar = findMenuBar()
    if not menuBar then
        warn("[SL Theme] MenuBar tidak ketemu untuk inject Output btn")
        return
    end

    if menuBar:FindFirstChild("SL_OutputMenuBtn") then
        menuBarDone = true; return
    end


    local maxX = 0
    for _, ch in ipairs(menuBar:GetChildren()) do
        pcall(function()
            if ch:IsA("GuiObject") and not ch:IsA("UIListLayout") then
                local rx = (ch.AbsolutePosition.X - menuBar.AbsolutePosition.X) + ch.AbsoluteSize.X
                if rx > maxX then maxX = rx end
            end
        end)
    end


    local refH = 20
    for _, ch in ipairs(menuBar:GetChildren()) do
        if ch:IsA("TextButton") and ch.AbsoluteSize.Y > 0 then
            refH = ch.AbsoluteSize.Y; break
        end
    end


    local sep = Instance.new("Frame")
    sep.Name = "SL_OutputMenuBtn"
    sep.Size = UDim2.new(0, 1, 0, refH - 6)
    sep.Position = UDim2.new(0, maxX + 6, 0.5, -math.floor((refH-6)/2))
    sep.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sep.BorderSizePixel = 0
    sep.ZIndex = 200
    sep.Parent = menuBar


    local btn = Instance.new("TextButton")
    btn.Name = "SL_OutputMenuBtn"
    btn.Size = UDim2.new(0, 58, 1, 0)
    btn.Position = UDim2.new(0, maxX + 14, 0, 0)
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3 = C.c1
    btn.Text = "Output"
    btn.TextColor3 = C.white
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 200
    btn.BorderSizePixel = 0
    btn.Parent = menuBar

    local uc = Instance.new("UICorner"); uc.CornerRadius = UDim.new(0, 4); uc.Parent = btn


    outputMenuBtn = btn

    btn.MouseEnter:Connect(function()
        if not outputVisible then
            btn.BackgroundTransparency = 0.8
        end
    end)
    btn.MouseLeave:Connect(function()
        if not outputVisible then
            btn.BackgroundTransparency = 1
        end
    end)
    btn.MouseButton1Click:Connect(function()
        toggleOutput()
    end)

    menuBarDone = true
    print("[SL Theme] Output button injected di menu bar!")


    local maxX2 = 0
    for _, ch in ipairs(menuBar:GetChildren()) do
        pcall(function()
            if ch:IsA("GuiObject") and not ch:IsA("UIListLayout") then
                local rx = (ch.AbsolutePosition.X - menuBar.AbsolutePosition.X) + ch.AbsoluteSize.X
                if rx > maxX2 then maxX2 = rx end
            end
        end)
    end

    local sepP = Instance.new("Frame")
    sepP.Name="SL_PluginMenuBtn"; sepP.Size=UDim2.new(0,1,0,refH-6)
    sepP.Position=UDim2.new(0,maxX2+4,0.5,-math.floor((refH-6)/2))
    sepP.BackgroundColor3=Color3.fromRGB(80,80,80)
    sepP.BorderSizePixel=0; sepP.ZIndex=200; sepP.Parent=menuBar

    local pBtn=Instance.new("TextButton")
    pBtn.Name="SL_PluginMenuBtn"; pBtn.Size=UDim2.new(0,58,1,0)
    pBtn.Position=UDim2.new(0,maxX2+10,0,0)
    pBtn.BackgroundTransparency=1; pBtn.BackgroundColor3=C.c1
    pBtn.Text="Plugins"; pBtn.TextColor3=C.white
    pBtn.TextSize=13; pBtn.Font=Enum.Font.GothamBold
    pBtn.ZIndex=200; pBtn.BorderSizePixel=0; pBtn.Parent=menuBar
    local puc=Instance.new("UICorner"); puc.CornerRadius=UDim.new(0,4); puc.Parent=pBtn
    pluginMenuBtn = pBtn

    pBtn.MouseEnter:Connect(function()
        if not pluginRibbonActive then pBtn.BackgroundTransparency=0.8 end
    end)
    pBtn.MouseLeave:Connect(function()
        if not pluginRibbonActive then pBtn.BackgroundTransparency=1 end
    end)
    pBtn.MouseButton1Click:Connect(function()
        togglePluginRibbon()
    end)


    fixFileMenuZIndex()
end


local PLUGIN_REGISTRY = {}


local function drawRopeIcon(parent, size, col)
    col = col or Color3.fromRGB(220,220,220)
    local s = size/16
    local function px(x,y,w,h)
        local f=Instance.new("Frame"); f.BackgroundColor3=col; f.BorderSizePixel=0
        f.Size=UDim2.new(0,math.max(1,w),0,math.max(1,h))
        f.Position=UDim2.new(0,x,0,y); f.ZIndex=12; f.Parent=parent
    end
    local function ring(cx,cy,ro,ri)
        local f=Instance.new("Frame"); f.BackgroundColor3=col; f.BorderSizePixel=0
        f.Size=UDim2.new(0,ro*2,0,ro*2); f.Position=UDim2.new(0,cx-ro,0,cy-ro)
        f.ZIndex=12; f.Parent=parent
        local uc=Instance.new("UICorner"); uc.CornerRadius=UDim.new(1,0); uc.Parent=f

        local bg=parent:FindFirstAncestorOfClass("Frame")
        local holeCol = bg and bg.BackgroundColor3 or Color3.fromRGB(37,37,38)
        local h2=Instance.new("Frame"); h2.BackgroundColor3=holeCol; h2.BorderSizePixel=0
        h2.Size=UDim2.new(0,ri*2,0,ri*2); h2.Position=UDim2.new(0,cx-ri,0,cy-ri)
        h2.ZIndex=13; h2.Parent=parent
        local uc2=Instance.new("UICorner"); uc2.CornerRadius=UDim.new(1,0); uc2.Parent=h2
        return f
    end

    local r1=Instance.new("Frame"); r1.BackgroundColor3=col; r1.BorderSizePixel=0
    r1.Size=UDim2.new(0,math.floor(7*s),0,math.floor(7*s))
    r1.Position=UDim2.new(0,math.floor(1*s),0,math.floor(4.5*s))
    r1.ZIndex=12; r1.Parent=parent
    local uc1=Instance.new("UICorner"); uc1.CornerRadius=UDim.new(1,0); uc1.Parent=r1

    local h1=Instance.new("Frame"); h1.BackgroundColor3=Color3.fromRGB(37,37,38); h1.BorderSizePixel=0
    h1.Size=UDim2.new(0,math.floor(4*s),0,math.floor(4*s))
    h1.Position=UDim2.new(0,math.floor(2.5*s),0,math.floor(6*s))
    h1.ZIndex=13; h1.Parent=parent
    local uhc1=Instance.new("UICorner"); uhc1.CornerRadius=UDim.new(1,0); uhc1.Parent=h1

    local r2=Instance.new("Frame"); r2.BackgroundColor3=col; r2.BorderSizePixel=0
    r2.Size=UDim2.new(0,math.floor(7*s),0,math.floor(7*s))
    r2.Position=UDim2.new(0,math.floor(8*s),0,math.floor(4.5*s))
    r2.ZIndex=12; r2.Parent=parent
    local uc2=Instance.new("UICorner"); uc2.CornerRadius=UDim.new(1,0); uc2.Parent=r2
    local h2=Instance.new("Frame"); h2.BackgroundColor3=Color3.fromRGB(37,37,38); h2.BorderSizePixel=0
    h2.Size=UDim2.new(0,math.floor(4*s),0,math.floor(4*s))
    h2.Position=UDim2.new(0,math.floor(9.5*s),0,math.floor(6*s))
    h2.ZIndex=13; h2.Parent=parent
    local uhc2=Instance.new("UICorner"); uhc2.CornerRadius=UDim.new(1,0); uhc2.Parent=h2

    px(math.floor(5*s),math.floor(6*s), math.floor(6*s),math.floor(4*s))

    local cov=Instance.new("Frame"); cov.BackgroundColor3=Color3.fromRGB(37,37,38); cov.BorderSizePixel=0
    cov.Size=UDim2.new(0,math.floor(4*s),0,math.floor(2*s))
    cov.Position=UDim2.new(0,math.floor(6*s),0,math.floor(7*s))
    cov.ZIndex=14; cov.Parent=parent
end

local function drawPluginIcon(parent, size, col)
    col = col or Color3.fromRGB(220,220,220)
    local s = size/16
    local function px(x,y,w,h)
        local f=Instance.new("Frame"); f.BackgroundColor3=col; f.BorderSizePixel=0
        f.Size=UDim2.new(0,math.max(1,w),0,math.max(1,h))
        f.Position=UDim2.new(0,x,0,y); f.ZIndex=12; f.Parent=parent
    end

    px(math.floor(2*s),math.floor(2*s), math.floor(5*s),math.floor(12*s))
    px(math.floor(2*s),math.floor(2*s), math.floor(12*s),math.floor(5*s))
    px(math.floor(9*s),math.floor(9*s), math.floor(5*s),math.floor(5*s))

    local notch=Instance.new("Frame"); notch.BackgroundColor3=Color3.fromRGB(37,37,38); notch.BorderSizePixel=0
    notch.Size=UDim2.new(0,math.floor(3*s),0,math.floor(3*s))
    notch.Position=UDim2.new(0,math.floor(5*s),0,math.floor(1*s))
    notch.ZIndex=13; notch.Parent=parent
    local nuc=Instance.new("UICorner"); nuc.CornerRadius=UDim.new(1,0); nuc.Parent=notch

    local tab=Instance.new("Frame"); tab.BackgroundColor3=col; tab.BorderSizePixel=0
    tab.Size=UDim2.new(0,math.floor(3*s),0,math.floor(3*s))
    tab.Position=UDim2.new(0,math.floor(13*s),0,math.floor(5*s))
    tab.ZIndex=12; tab.Parent=parent
    local tuc=Instance.new("UICorner"); tuc.CornerRadius=UDim.new(1,0); tuc.Parent=tab
end


local function makePluginRibbonBtn(parent, plugin, xOffset, btnH)
    local ICON_SIZE = 26
    local BTN_W    = 60
    local BTN_H    = btnH or 52

    local cont = Instance.new("Frame")
    cont.Name = "SL_PluginBtn"
    cont.Size = UDim2.new(0, BTN_W, 0, BTN_H)
    cont.Position = UDim2.new(0, xOffset, 0.5, -BTN_H/2)
    cont.BackgroundColor3 = C.c2
    cont.BackgroundTransparency = 1
    cont.BorderSizePixel = 0
    cont.ZIndex = 302
    cont.Parent = parent

    local uc = Instance.new("UICorner"); uc.CornerRadius=UDim.new(0,7); uc.Parent=cont
    local tileStroke = Instance.new("UIStroke"); tileStroke.Color=C.border; tileStroke.Thickness=1; tileStroke.Transparency=0.45; tileStroke.Parent=cont


    local iconArea = Instance.new("Frame")
    iconArea.Name = "SL_PluginBtn"
    iconArea.Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
    iconArea.Position = UDim2.new(0.5, -ICON_SIZE/2, 0, 4)
    iconArea.BackgroundTransparency = 1
    iconArea.BorderSizePixel = 0
    iconArea.ZIndex = 303
    iconArea.Parent = cont


    if plugin.drawIcon then
        pcall(function() plugin.drawIcon(iconArea, ICON_SIZE, Color3.fromRGB(210,210,210)) end)
    end


    local lbl = Instance.new("TextLabel")
    lbl.Name = "SL_PluginBtn"
    lbl.Size = UDim2.new(1, 2, 0, 14)
    lbl.Position = UDim2.new(-0.01, 0, 0, ICON_SIZE + 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = plugin.label
    lbl.TextColor3 = Color3.fromRGB(220,220,220)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.ZIndex = 303
    lbl.Parent = cont


    local indicator = Instance.new("Frame")
    indicator.Name = "SL_PluginBtn"
    indicator.Size = UDim2.new(1, 0, 0, 2)
    indicator.Position = UDim2.new(0, 0, 1, -2)
    indicator.BackgroundColor3 = Color3.fromRGB(55,105,185)
    indicator.BackgroundTransparency = 1
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 304
    indicator.Parent = cont


    local active = false
    local clickBtn = Instance.new("TextButton")
    clickBtn.Name = "SL_PluginBtn"
    clickBtn.Size = UDim2.new(1,0,1,0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 305
    clickBtn.Parent = cont

    clickBtn.MouseEnter:Connect(function()
        if not active then
            cont.BackgroundTransparency = 0.35
            tileStroke.Color = C.expSelB
            tileStroke.Transparency = 0.05
        end
    end)
    clickBtn.MouseLeave:Connect(function()
        if not active then
            cont.BackgroundTransparency = 1
            tileStroke.Color = C.border
            tileStroke.Transparency = 0.45
        end
    end)
    clickBtn.Activated:Connect(function()
        active = not active
        cont.BackgroundColor3 = active and C.expSel or C.c2
        cont.BackgroundTransparency = active and 0.18 or 1
        tileStroke.Color = active and C.expSelB or C.border
        tileStroke.Transparency = active and 0 or 0.45
        indicator.BackgroundTransparency = active and 0 or 1
        pcall(function()
            if plugin.onToggle then plugin.onToggle(active) end
        end)
    end)

    return cont
end


local function buildPluginRibbon()
    if pluginRibbonFrame then return end

    local toolbar = findToolbar()
    if not toolbar then

        for _, obj in ipairs(StudioGui:GetDescendants()) do
            pcall(function()
                if (obj:IsA("Frame") or obj:IsA("ScrollingFrame")) then
                    local sz = obj.AbsoluteSize
                    if sz.X > 200 and sz.Y > 30 and sz.Y < 120 then

                        if #obj:GetChildren() > 3 then
                            toolbar = obj
                        end
                    end
                end
            end)
            if toolbar then break end
        end
    end
    if not toolbar then
        warn("[SL Plugin] Toolbar tidak ditemukan, coba lagi saat klik Plugins")
        return
    end


    local sgPos = StudioGui.AbsolutePosition
    local tbPos = toolbar.AbsolutePosition
    local tbSz  = toolbar.AbsoluteSize

    local frame = Instance.new("Frame")
    frame.Name = "SL_PluginRibbon"
    frame.Size = UDim2.new(0, tbSz.X, 0, tbSz.Y)
    frame.Position = UDim2.new(0, tbPos.X - sgPos.X, 0, tbPos.Y - sgPos.Y)
    frame.BackgroundColor3 = Color3.fromRGB(37,37,38)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = 300
    frame.Parent = StudioGui


    local borderB = Instance.new("Frame")
    borderB.Name = "SL_PluginRibbon"
    borderB.Size = UDim2.new(1,0,0,1)
    borderB.Position = UDim2.new(0,0,1,-1)
    borderB.BackgroundColor3 = Color3.fromRGB(55,105,185)
    borderB.BorderSizePixel=0; borderB.ZIndex=301; borderB.Parent=frame


    local tabLbl = Instance.new("TextLabel")
    tabLbl.Name = "SL_PluginRibbon"
    tabLbl.Size = UDim2.new(0,60,1,0)
    tabLbl.Position = UDim2.new(0,8,0,0)
    tabLbl.BackgroundTransparency=1
    tabLbl.Text = "PLUGINS"
    tabLbl.TextColor3 = Color3.fromRGB(55,105,185)
    tabLbl.TextSize = 10
    tabLbl.Font = Enum.Font.GothamBold
    tabLbl.ZIndex = 302
    tabLbl.Parent = frame


    local sep = Instance.new("Frame")
    sep.Name="SL_PluginRibbon"; sep.Size=UDim2.new(0,1,0,tbSz.Y-16)
    sep.Position=UDim2.new(0,68,0,8)
    sep.BackgroundColor3=Color3.fromRGB(65,65,65)
    sep.BorderSizePixel=0; sep.ZIndex=301; sep.Parent=frame


    local xOff = 76
    for _, plugin in ipairs(PLUGIN_REGISTRY) do
        makePluginRibbonBtn(frame, plugin, xOff, tbSz.Y - 8)
        xOff = xOff + 64
    end


    task.spawn(function()
        while frame.Parent do
            task.wait(0.5)
            pcall(function()
                if not pluginRibbonActive then return end
                local tb = findToolbar()
                if not tb then return end
                local np = tb.AbsolutePosition; local ns = tb.AbsoluteSize
                local sg = StudioGui.AbsolutePosition
                frame.Position = UDim2.new(0, np.X-sg.X, 0, np.Y-sg.Y)
                frame.Size = UDim2.new(0, ns.X, 0, ns.Y)
            end)
        end
    end)

    pluginRibbonFrame = frame
end

togglePluginRibbon = function()

    if not pluginRibbonFrame then
        buildPluginRibbon()
        if not pluginRibbonFrame then

            task.spawn(function()
                for i = 1, 5 do
                    task.wait(1)
                    buildPluginRibbon()
                    if pluginRibbonFrame then
                        pluginRibbonActive = true
                        pluginRibbonFrame.Visible = true
                        if pluginMenuBtn then
                            pluginMenuBtn.BackgroundTransparency = 0.6
                            pluginMenuBtn.BackgroundColor3 = Color3.fromRGB(55,105,185)
                        end
                        break
                    end
                end
            end)
            return
        end
    end

    pluginRibbonActive = not pluginRibbonActive
    pluginRibbonFrame.Visible = pluginRibbonActive

    if pluginMenuBtn then
        pluginMenuBtn.BackgroundTransparency = pluginRibbonActive and 0.6 or 1
        pluginMenuBtn.BackgroundColor3 = pluginRibbonActive
            and Color3.fromRGB(55,105,185) or C.c1
    end
end


_G.SL_RegisterPlugin = function(plugin)
    if not plugin or not plugin.label then return end
    table.insert(PLUGIN_REGISTRY, plugin)

    if pluginRibbonFrame then
        local xOff = 76
        for i=1, #PLUGIN_REGISTRY-1 do xOff = xOff + 64 end
        local tb = findToolbar()
        local btnH = tb and (tb.AbsoluteSize.Y - 8) or 52
        makePluginRibbonBtn(pluginRibbonFrame, plugin, xOff, btnH)
    end
    print("[SL Plugin] Registered: " .. plugin.label)
end


local _hijauLocked = {}

local function lockHidden(btn)
    if not btn then return end
    if _hijauLocked[btn] then return end

    pcall(function() btn.Visible = false end)

    pcall(function()
        for _, ch in ipairs(btn:GetDescendants()) do
            if ch:IsA("GuiObject") then
                pcall(function() ch.Visible = false end)
            end
        end
    end)

    _hijauLocked[btn] = btn:GetPropertyChangedSignal("Visible"):Connect(function()
        task.defer(function()
            pcall(function()
                if btn.Visible then
                    btn.Visible = false
                end
            end)
        end)
    end)
end

local function hideSplashGrowingUp()
    local topBar = StudioGui:FindFirstChild("TopBar")
    if not topBar then return end


    lockHidden(topBar:FindFirstChild("TUTORIALS"))
    lockHidden(topBar:FindFirstChild("GrowingUp"))


    topBar.ChildAdded:Connect(function(ch)
        if ch.Name == "TUTORIALS" or ch.Name == "GrowingUp" then
            task.defer(function() lockHidden(ch) end)
        end
    end)


    StudioGui.ChildAdded:Connect(function(ch)
        if ch.Name == "TopBar" then
            task.wait(0.1)
            pcall(function()
                lockHidden(ch:FindFirstChild("TUTORIALS"))
                lockHidden(ch:FindFirstChild("GrowingUp"))
                ch.ChildAdded:Connect(function(btn)
                    if btn.Name == "TUTORIALS" or btn.Name == "GrowingUp" then
                        task.defer(function() lockHidden(btn) end)
                    end
                end)
            end)
        end
    end)
end


local function darkTopBar()
    local topBar = StudioGui:FindFirstChild("TopBar")
    if not topBar then return end
    pcall(function() topBar.BackgroundColor3 = C.c0 end)

    local fileBtn = topBar:FindFirstChild("File")
    if fileBtn then
        pcall(function()
            fileBtn.BackgroundTransparency = 1
            fileBtn.TextColor3 = C.white
        end)
    end
end


local function fixTopRightIcons() end


print("[STUDIO LITE BY EZY] Loading...")

task.spawn(function()


    fixAll()
    task.wait(0.5)
    forceWhiteText()

    injectPartButtons()
    injectTerrain()
    task.wait(0.5)
    fixAll()
    task.wait(0.3)
    tryInjectIcons()
    if not partsDone    then task.wait(2); injectPartButtons() end
    if not terrainDone  then task.wait(2); injectTerrain() end

    hideDefaultOutput()
    task.wait(0.2)
    buildOutputPanel(StudioGui)
    task.wait(0.3)
    injectOutputMenuBtn()
    if not menuBarDone then task.wait(2); injectOutputMenuBtn() end
    fixFileMenuZIndex()

    task.wait(0.5)
    forceWhiteText()
    disableMultiSelect()
    startPersistentWhiteText()


    -- [P2] the duplicate second call was removed
    hideSplashGrowingUp()

    print("[STUDIO LITE BY EZY] ✓ Done!")
end)
-- ===================== PART 2 of 4 : END (last line: end of the init task.spawn block) =====================
-- ===================== PART 3 of 4 : BEGIN (Terrain and Studio utilities) =====================
local function loadTerrainTools()

    local openTPanel, closeTPanel, tPanelOpen
    local grassColorOpenBtn


    local Players2 = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")

    local Player = Players2.LocalPlayer
    local PlayerGui2 = Player:WaitForChild("PlayerGui", 5)
    local mouse = Player:GetMouse()
    local Terrain = workspace.Terrain

    local C2 = {
        BG      = Color3.fromRGB(17, 20, 27),
        SURFACE = Color3.fromRGB(23, 28, 37),
        CARD    = Color3.fromRGB(29, 35, 45),
        CARD2   = Color3.fromRGB(38, 46, 59),
        BORDER  = Color3.fromRGB(52, 65, 82),
        BORDBRT = Color3.fromRGB(55, 145, 205),
        TEXT    = Color3.fromRGB(238, 244, 250),
        SUBTEXT = Color3.fromRGB(151, 165, 184),
        WHITE   = Color3.fromRGB(255, 255, 255),
        BLUE    = Color3.fromRGB(28, 115, 190),
        RED     = Color3.fromRGB(205, 42, 55),
        GREEN   = Color3.fromRGB(30, 160, 80),
        YELLOW  = Color3.fromRGB(210, 165, 25),
        ORANGE  = Color3.fromRGB(210, 100, 20),
        CYAN    = Color3.fromRGB(45, 190, 220),
        PURPLE  = Color3.fromRGB(120, 80, 220),
    }


    local function mkCorner(r, p)
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p; return c
    end
    local function mkStroke(t, col, p)
        local s = Instance.new("UIStroke"); s.Thickness = t; s.Color = col; s.Parent = p; return s
    end
    local function mkPad(top, bot, left, right, p)
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0,top); pad.PaddingBottom = UDim.new(0,bot)
        pad.PaddingLeft = UDim.new(0,left); pad.PaddingRight = UDim.new(0,right)
        pad.Parent = p; return pad
    end

    local function makeDraggable2(handle, target)
        target = target or handle
        local drag, ds, sp = false, nil, nil
        handle.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                drag=true; ds=i.Position; sp=target.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then drag=false end
                end)
            end
        end)
        handle.InputChanged:Connect(function(i)
            if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - ds
                TweenService:Create(target, TweenInfo.new(0), {
                    Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
                }):Play()
            end
        end)
    end

    local function drawLine2(parent, x1,y1,x2,y2, thick, color)
        local dx,dy = x2-x1, y2-y1
        local len = math.sqrt(dx*dx+dy*dy)
        if len < 0.5 then return end
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(0, math.ceil(len), 0, thick)
        bar.Position = UDim2.new(0, math.floor((x1+x2)/2-len/2), 0, math.floor((y1+y2)/2-thick/2))
        bar.Rotation = math.deg(math.atan2(dy,dx))
        bar.BackgroundColor3 = color or C2.BLUE
        bar.BorderSizePixel = 0; bar.ZIndex = 120; bar.Parent = parent
    end
    local function drawDot2(parent, cx,cy,r,color)
        local d = Instance.new("Frame")
        d.Size = UDim2.new(0,r*2,0,r*2); d.Position = UDim2.new(0,cx-r,0,cy-r)
        d.BackgroundColor3 = color or C2.BLUE; d.BorderSizePixel=0; d.ZIndex=120; d.Parent=parent
        mkCorner(r,d)
    end

    local function iconTerrain2(f,S)
        local bot=S-3
        drawLine2(f,3,bot,S-3,bot,1.5,C2.GREEN)
        drawLine2(f,3,bot,S/2-1,S/2-2,1.5,C2.BLUE); drawLine2(f,S/2-1,S/2-2,S/2+4,bot-4,1.5,C2.BLUE)
        drawLine2(f,S/2+2,bot-5,S-3,4,1.5,C2.CYAN); drawLine2(f,S-3,4,S-3,bot,1.5,C2.CYAN)
        drawLine2(f,S-3,4,S-6,7,1,C2.WHITE); drawLine2(f,S-3,4,S-1,7,1,C2.WHITE)
        drawDot2(f,6,5,2,C2.YELLOW); drawLine2(f,6,2,6,3,1,C2.YELLOW); drawLine2(f,9,5,10,5,1,C2.YELLOW)
    end


    local FILE_GRASS   = "ezy_grass_color_v87.json"

    local function fsWrite(path, data)
        pcall(function() if writefile then writefile(path, data) end end)
    end
    local function fsRead(path)
        local ok, result = pcall(function()
            if isfile and readfile and isfile(path) then return readfile(path) end
            return nil
        end)
        if ok and result then return result end
        return nil
    end


    local function loadGrassColor()
        local GRASS_FALLBACKS = {
            FILE_GRASS,
            "ezy_grass_color_v72.json","ezy_grass_color_v71.json","ezy_grass_color_v70.json",
            "ezy_grass_color_v69.json","ezy_grass_color_v68.json","ezy_grass_color_v64.json",
            "ezy_grass_color_v62.json","ezy_grass_color_v61.json","ezy_grass_color_v60.json",
            "ezy_grass_color_v58.json","ezy_grass_color_v57.json","ezy_grass_color_v56.json",
        }
        for _, fname in ipairs(GRASS_FALLBACKS) do
            local raw = fsRead(fname)
            if raw then
                local ok, result = pcall(function() return HttpService:JSONDecode(raw) end)
                if ok and result and type(result.r)=="number" then
                    if fname ~= FILE_GRASS then fsWrite(FILE_GRASS, HttpService:JSONEncode(result)) end
                    return result
                end
            end
        end
        return {r=106, g=127, b=63}
    end
    local function saveGrassColor(r,g,b)
        fsWrite(FILE_GRASS, HttpService:JSONEncode({r=r,g=g,b=b}))
    end
    local currentGrassColor = loadGrassColor()




    if PlayerGui2:FindFirstChild("EzyV1") then PlayerGui2.EzyV1:Destroy() end

    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "SlBlackProEzyV1"; mainGui.ResetOnSpawn = false
    mainGui.IgnoreGuiInset = true; mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.Parent = PlayerGui2

    local TOPBAR_H = 0


    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0,260,0,34); toast.Position = UDim2.new(0.5,-130,1,-56)
    toast.BackgroundColor3 = Color3.fromRGB(20,20,20); toast.BorderSizePixel=0
    toast.BackgroundTransparency=1; toast.ZIndex=800; toast.Parent=mainGui
    mkCorner(8,toast)
    local toastLbl = Instance.new("TextLabel")
    toastLbl.Size = UDim2.new(1,-12,1,0); toastLbl.Position = UDim2.new(0,6,0,0)
    toastLbl.BackgroundTransparency=1; toastLbl.Text=""; toastLbl.TextColor3=C2.WHITE
    toastLbl.TextSize=11; toastLbl.Font=Enum.Font.GothamBold; toastLbl.ZIndex=801; toastLbl.Parent=toast
    local function showToast(msg, col)
        col = col or Color3.fromRGB(20,20,20); toast.BackgroundColor3=col; toastLbl.Text=msg
        TweenService:Create(toast, TweenInfo.new(0.2), {BackgroundTransparency=0}):Play()
        task.wait(2); TweenService:Create(toast, TweenInfo.new(0.2), {BackgroundTransparency=1}):Play()
    end




    local function _terrain()
        local PANEL_W  = math.max(220, math.min(340, mainGui.AbsoluteSize.X - 20))
        local HEADER_H = 38

        local terrainData  = {}
        local paintData    = {}
        local smoothData   = {}
        local convertData  = {}
        local VOXEL_RES    = 4

        local materialToName = {
            [Enum.Material.Grass]="Grass",       [Enum.Material.Rock]="Rock",
            [Enum.Material.Water]="Water",       [Enum.Material.Ground]="Ground",
            [Enum.Material.Sand]="Sand",         [Enum.Material.Snow]="Snow",
            [Enum.Material.Ice]="Ice",           [Enum.Material.Mud]="Mud",
            [Enum.Material.Sandstone]="Sandstone",   [Enum.Material.Limestone]="Limestone",
            [Enum.Material.Cobblestone]="Cobblestone",[Enum.Material.Basalt]="Basalt",
            [Enum.Material.Concrete]="Concrete", [Enum.Material.Salt]="Salt",
            [Enum.Material.LeafyGrass]="LeafyGrass",[Enum.Material.Pavement]="Pavement",
        }
        local terrainTypes = {
            {name="Grass",  color=Color3.fromRGB(72,160,50),   mat=Enum.Material.Grass},
            {name="Rock",   color=Color3.fromRGB(110,110,110), mat=Enum.Material.Rock},
            {name="Ground", color=Color3.fromRGB(140,95,30),   mat=Enum.Material.Ground},
            {name="Sand",   color=Color3.fromRGB(200,180,120), mat=Enum.Material.Sand},
            {name="Mud",    color=Color3.fromRGB(90,60,25),    mat=Enum.Material.Mud},
            {name="Sandst", color=Color3.fromRGB(210,170,100), mat=Enum.Material.Sandstone},
            {name="Limest", color=Color3.fromRGB(200,195,175), mat=Enum.Material.Limestone},
            {name="Cobble", color=Color3.fromRGB(130,120,110), mat=Enum.Material.Cobblestone},
            {name="Basalt", color=Color3.fromRGB(50,50,55),    mat=Enum.Material.Basalt},
            {name="Water",  color=Color3.fromRGB(20,120,220),  mat=Enum.Material.Water},
            {name="Concr",  color=Color3.fromRGB(150,150,150), mat=Enum.Material.Concrete},
            {name="Salt",   color=Color3.fromRGB(240,235,230), mat=Enum.Material.Salt},
            {name="Ice",    color=Color3.fromRGB(140,190,220), mat=Enum.Material.Ice},
            {name="Snow",   color=Color3.fromRGB(210,230,255), mat=Enum.Material.Snow},
            {name="Leafy",  color=Color3.fromRGB(80,140,50),   mat=Enum.Material.LeafyGrass},
            {name="Pavemt", color=Color3.fromRGB(80,80,90),    mat=Enum.Material.Pavement},
        }

        local tPanel = Instance.new("Frame")
        tPanel.Name="TerrainPanel"; tPanel.Size=UDim2.new(0,0,0,0)
        tPanel.Position=UDim2.new(0.5,-PANEL_W/2,0,TOPBAR_H+4)
        tPanel.BackgroundColor3=C2.BG; tPanel.BorderSizePixel=0; tPanel.ClipsDescendants=true
        tPanel.Visible=false; tPanel.ZIndex=700; tPanel.Parent=mainGui
        mkCorner(12,tPanel); mkStroke(1.5,C2.BORDBRT,tPanel)

        tPanelOpen=false
        openTPanel = function()
            tPanelOpen=true; tPanel.Visible=true
            tPanel.Position=UDim2.new(0.5,-PANEL_W/2,0,TOPBAR_H+4)
            local screenH=mainGui.AbsoluteSize.Y
            local ph=math.min(screenH-TOPBAR_H-16,680)
            TweenService:Create(tPanel,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,PANEL_W,0,ph)}):Play()
        end
        closeTPanel = function()
            tPanelOpen=false
            local t=TweenService:Create(tPanel,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)})
            t:Play(); t.Completed:Once(function() tPanel.Visible=false end)
        end

        local onoffBtn
        do
            local tHeader = Instance.new("Frame")
            tHeader.Size=UDim2.new(1,0,0,HEADER_H); tHeader.BackgroundColor3=C2.SURFACE; tHeader.BorderSizePixel=0
            tHeader.ZIndex=703; tHeader.Parent=tPanel; mkCorner(12,tHeader)
            do
                local tHFill = Instance.new("Frame")
                tHFill.Size=UDim2.new(1,0,0,14); tHFill.Position=UDim2.new(0,0,1,-14)
                tHFill.BackgroundColor3=C2.SURFACE; tHFill.BorderSizePixel=0; tHFill.ZIndex=703; tHFill.Parent=tHeader
            end
            makeDraggable2(tHeader, tPanel)
            do
                local tHIconF = Instance.new("Frame")
                tHIconF.Size=UDim2.new(0,18,0,18); tHIconF.Position=UDim2.new(0,10,0.5,-9)
                tHIconF.BackgroundTransparency=1; tHIconF.ClipsDescendants=false; tHIconF.ZIndex=720; tHIconF.Parent=tHeader
                iconTerrain2(tHIconF,18)
            end
            do
                local tTitle = Instance.new("TextLabel")
                tTitle.Size=UDim2.new(0,130,1,0); tTitle.Position=UDim2.new(0,33,0,0)
                tTitle.BackgroundTransparency=1; tTitle.Text="TERRAIN (BETA)"
                tTitle.TextColor3=C2.TEXT; tTitle.TextSize=10; tTitle.Font=Enum.Font.GothamBold
                tTitle.TextXAlignment=Enum.TextXAlignment.Left; tTitle.ZIndex=704; tTitle.Parent=tHeader
            end
            onoffBtn = Instance.new("TextButton")
            onoffBtn.Size=UDim2.new(0,42,0,24); onoffBtn.Position=UDim2.new(1,-82,0.5,-12)
            onoffBtn.BackgroundColor3=C2.RED; onoffBtn.BorderSizePixel=0; onoffBtn.Text="OFF"
            onoffBtn.TextColor3=C2.TEXT; onoffBtn.TextSize=9; onoffBtn.Font=Enum.Font.GothamBold
            onoffBtn.ZIndex=704; onoffBtn.Parent=tHeader; mkCorner(6,onoffBtn)
            local closeTBtn = Instance.new("TextButton")
            closeTBtn.Size=UDim2.new(0,30,0,24); closeTBtn.Position=UDim2.new(1,-36,0.5,-12)
            closeTBtn.BackgroundColor3=Color3.fromRGB(50,20,20); closeTBtn.BorderSizePixel=0; closeTBtn.Text="×"
            closeTBtn.TextColor3=C2.WHITE; closeTBtn.TextSize=11; closeTBtn.Font=Enum.Font.GothamBold
            closeTBtn.ZIndex=704; closeTBtn.Parent=tHeader; mkCorner(6,closeTBtn)
            closeTBtn.MouseButton1Click:Connect(closeTPanel)
        end

        local body
        do
            local tScroll = Instance.new("ScrollingFrame")
            tScroll.Size=UDim2.new(1,0,1,-HEADER_H); tScroll.Position=UDim2.new(0,0,0,HEADER_H)
            tScroll.BackgroundTransparency=1; tScroll.BorderSizePixel=0
            tScroll.ScrollBarThickness=4; tScroll.ScrollBarImageColor3=C2.BORDBRT
            tScroll.ScrollingDirection=Enum.ScrollingDirection.Y; tScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
            tScroll.CanvasSize=UDim2.new(0,0,0,0); tScroll.ElasticBehavior=Enum.ElasticBehavior.Never
            tScroll.Parent=tPanel
            body = Instance.new("Frame")
            body.Size=UDim2.new(1,0,0,0); body.AutomaticSize=Enum.AutomaticSize.Y
            body.BackgroundTransparency=1; body.Parent=tScroll
        end
        do
            local bodyLayout = Instance.new("UIListLayout")
            bodyLayout.Padding=UDim.new(0,6); bodyLayout.SortOrder=Enum.SortOrder.LayoutOrder; bodyLayout.Parent=body
        end
        mkPad(6,12,8,8,body)

        local function secLabel(txt, lo)
            local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,0,0,14); wrap.BackgroundTransparency=1
            wrap.LayoutOrder=lo; wrap.Parent=body
            local line=Instance.new("Frame"); line.Size=UDim2.new(1,0,0,1); line.Position=UDim2.new(0,0,0.5,0)
            line.BackgroundColor3=C2.BORDER; line.BorderSizePixel=0; line.Parent=wrap
            local bg=Instance.new("Frame"); bg.Size=UDim2.new(0,0,1,0); bg.BackgroundColor3=C2.BG
            bg.BorderSizePixel=0; bg.AutomaticSize=Enum.AutomaticSize.X; bg.Parent=wrap; mkPad(0,0,0,8,bg)
            local l=Instance.new("TextLabel"); l.Size=UDim2.new(0,0,1,0); l.AutomaticSize=Enum.AutomaticSize.X
            l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=C2.SUBTEXT; l.TextSize=9
            l.Font=Enum.Font.GothamBold; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=bg
            return wrap
        end

        secLabel("TERRAIN TYPE",1)
        local tGrid
        do
            tGrid=Instance.new("Frame"); tGrid.Size=UDim2.new(1,0,0,0); tGrid.AutomaticSize=Enum.AutomaticSize.Y
            tGrid.BackgroundTransparency=1; tGrid.LayoutOrder=2; tGrid.Parent=body
            local tGridL=Instance.new("UIGridLayout"); tGridL.CellSize=UDim2.new(0,52,0,46)
            tGridL.CellPadding=UDim2.new(0,4,0,4); tGridL.HorizontalAlignment=Enum.HorizontalAlignment.Left; tGridL.Parent=tGrid
        end

        local selectedTerrain=Enum.Material.Grass
        local terrainBtns={}
        for _,td in ipairs(terrainTypes) do
            local tb=Instance.new("TextButton"); tb.Size=UDim2.new(0,52,0,46)
            tb.BackgroundColor3=C2.CARD; tb.BorderSizePixel=0; tb.Text=""; tb.ZIndex=702; tb.Parent=tGrid; mkCorner(6,tb); mkStroke(1,C2.BORDER,tb)
            local dot=Instance.new("Frame"); dot.Size=UDim2.new(0,16,0,16); dot.Position=UDim2.new(0.5,-8,0,7)
            dot.BackgroundColor3=td.color; dot.BorderSizePixel=0; dot.ZIndex=703; dot.Parent=tb; mkCorner(4,dot)
            local tn=Instance.new("TextLabel"); tn.Size=UDim2.new(1,-2,0,14); tn.Position=UDim2.new(0,1,0,26)
            tn.BackgroundTransparency=1; tn.Text=td.name; tn.TextColor3=C2.TEXT; tn.TextSize=8
            tn.Font=Enum.Font.GothamBold; tn.TextXAlignment=Enum.TextXAlignment.Center; tn.ZIndex=703; tn.Parent=tb
            terrainBtns[td.mat]=tb
            tb.MouseButton1Click:Connect(function()
                selectedTerrain=td.mat
                for m,b in pairs(terrainBtns) do
                    b.BackgroundColor3=(m==selectedTerrain) and C2.BLUE or C2.CARD
                    local st=b:FindFirstChildOfClass("UIStroke"); if st then st.Color=(m==selectedTerrain) and C2.BLUE or C2.BORDER; st.Thickness=(m==selectedTerrain) and 1.5 or 1 end
                end
            end)
        end

        secLabel("BRUSH MODE",3)
        local brushModes={"Draw","Erase","Paint","Smooth","Convert"}; local brushMode="Draw"; local modeBtns={}
        do
            local modeFrame=Instance.new("Frame"); modeFrame.Size=UDim2.new(1,0,0,26); modeFrame.BackgroundTransparency=1; modeFrame.LayoutOrder=4; modeFrame.Parent=body
            do local modeLayout=Instance.new("UIListLayout"); modeLayout.FillDirection=Enum.FillDirection.Horizontal; modeLayout.Padding=UDim.new(0,3); modeLayout.Parent=modeFrame end
            for _,mode in ipairs(brushModes) do
                local mb=Instance.new("TextButton"); mb.Size=UDim2.new(0,42,0,26)
                mb.BackgroundColor3=(mode=="Draw") and C2.BLUE or C2.CARD; mb.BorderSizePixel=0
                mb.Text=mode; mb.TextColor3=C2.TEXT; mb.TextSize=8; mb.Font=Enum.Font.GothamBold; mb.ZIndex=702; mb.Parent=modeFrame; mkCorner(5,mb); modeBtns[mode]=mb
                mb.MouseButton1Click:Connect(function()
                    brushMode=mode
                    for m,b in pairs(modeBtns) do b.BackgroundColor3=(m==brushMode) and C2.BLUE or C2.CARD end
                end)
            end
        end

        local function holdRepeat(btn,action)
            local holding=false
            btn.InputBegan:Connect(function(i)
                if i.UserInputType~=Enum.UserInputType.MouseButton1 then return end
                holding=true
                task.delay(0.35,function() while holding do action(); task.wait(0.06) end end)
            end)
            btn.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then holding=false end end)
        end

        secLabel("BRUSH SIZE",5)
        local currentSize=8
        do
            local sizeFrame=Instance.new("Frame"); sizeFrame.Size=UDim2.new(1,0,0,30); sizeFrame.BackgroundTransparency=1; sizeFrame.LayoutOrder=6; sizeFrame.Parent=body
            local sizeMinBtn=Instance.new("TextButton"); sizeMinBtn.Size=UDim2.new(0,30,0,30)
            sizeMinBtn.BackgroundColor3=C2.CARD2; sizeMinBtn.BorderSizePixel=0; sizeMinBtn.Text="−"
            sizeMinBtn.TextColor3=C2.TEXT; sizeMinBtn.TextSize=18; sizeMinBtn.Font=Enum.Font.GothamBold; sizeMinBtn.ZIndex=702; sizeMinBtn.Parent=sizeFrame; mkCorner(7,sizeMinBtn)
            local sizeLbl=Instance.new("TextLabel"); sizeLbl.Size=UDim2.new(1,-68,1,0); sizeLbl.Position=UDim2.new(0,34,0,0)
            sizeLbl.BackgroundColor3=C2.CARD; sizeLbl.BorderSizePixel=0; sizeLbl.Text=tostring(currentSize)
            sizeLbl.TextColor3=C2.TEXT; sizeLbl.TextSize=13; sizeLbl.Font=Enum.Font.GothamBold
            sizeLbl.TextXAlignment=Enum.TextXAlignment.Center; sizeLbl.ZIndex=702; sizeLbl.Parent=sizeFrame; mkCorner(7,sizeLbl)
            local sizePlusBtn=Instance.new("TextButton"); sizePlusBtn.Size=UDim2.new(0,30,0,30); sizePlusBtn.Position=UDim2.new(1,-30,0,0)
            sizePlusBtn.BackgroundColor3=C2.CARD2; sizePlusBtn.BorderSizePixel=0; sizePlusBtn.Text="+"
            sizePlusBtn.TextColor3=C2.TEXT; sizePlusBtn.TextSize=18; sizePlusBtn.Font=Enum.Font.GothamBold; sizePlusBtn.ZIndex=702; sizePlusBtn.Parent=sizeFrame; mkCorner(7,sizePlusBtn)
            local function updateSizeLabel() sizeLbl.Text=tostring(currentSize) end
            sizeMinBtn.MouseButton1Click:Connect(function() currentSize=math.max(1,currentSize-1); updateSizeLabel() end)
            sizePlusBtn.MouseButton1Click:Connect(function() currentSize=math.min(64,currentSize+1); updateSizeLabel() end)
            holdRepeat(sizeMinBtn,function() currentSize=math.max(1,currentSize-1); updateSizeLabel() end)
            holdRepeat(sizePlusBtn,function() currentSize=math.min(64,currentSize+1); updateSizeLabel() end)
        end

        secLabel("SHAPE",7)
        local selectedShape="Block"; local shapeBtns={}
        do
            local shapeFrame=Instance.new("Frame"); shapeFrame.Size=UDim2.new(1,0,0,26); shapeFrame.BackgroundTransparency=1; shapeFrame.LayoutOrder=8; shapeFrame.Parent=body
            do local shapeLayout=Instance.new("UIListLayout"); shapeLayout.FillDirection=Enum.FillDirection.Horizontal; shapeLayout.Padding=UDim.new(0,4); shapeLayout.Parent=shapeFrame end
            for _,sh in ipairs({"Block","Ball"}) do
                local sb=Instance.new("TextButton"); sb.Size=UDim2.new(0,52,0,26)
                sb.BackgroundColor3=(sh=="Block") and C2.BLUE or C2.CARD; sb.BorderSizePixel=0
                sb.Text=sh; sb.TextColor3=C2.TEXT; sb.TextSize=9; sb.Font=Enum.Font.GothamBold; sb.ZIndex=702; sb.Parent=shapeFrame; mkCorner(5,sb); shapeBtns[sh]=sb
                sb.MouseButton1Click:Connect(function()
                    selectedShape=sh
                    for s,b in pairs(shapeBtns) do b.BackgroundColor3=(s==selectedShape) and C2.BLUE or C2.CARD end
                end)
            end
        end

        secLabel("SMOOTH STRENGTH",9)
        local smoothStrength=0.5
        do
            local ssFrame=Instance.new("Frame"); ssFrame.Size=UDim2.new(1,0,0,30); ssFrame.BackgroundTransparency=1; ssFrame.LayoutOrder=10; ssFrame.Parent=body
            local ssMinBtn=Instance.new("TextButton"); ssMinBtn.Size=UDim2.new(0,30,0,30)
            ssMinBtn.BackgroundColor3=C2.CARD2; ssMinBtn.BorderSizePixel=0; ssMinBtn.Text="−"
            ssMinBtn.TextColor3=C2.TEXT; ssMinBtn.TextSize=18; ssMinBtn.Font=Enum.Font.GothamBold; ssMinBtn.ZIndex=702; ssMinBtn.Parent=ssFrame; mkCorner(7,ssMinBtn)
            local ssLbl=Instance.new("TextLabel"); ssLbl.Size=UDim2.new(1,-68,1,0); ssLbl.Position=UDim2.new(0,34,0,0)
            ssLbl.BackgroundColor3=C2.CARD; ssLbl.BorderSizePixel=0; ssLbl.Text=math.floor(smoothStrength*100).."%"
            ssLbl.TextColor3=C2.TEXT; ssLbl.TextSize=13; ssLbl.Font=Enum.Font.GothamBold
            ssLbl.TextXAlignment=Enum.TextXAlignment.Center; ssLbl.ZIndex=702; ssLbl.Parent=ssFrame; mkCorner(7,ssLbl)
            local ssPlusBtn=Instance.new("TextButton"); ssPlusBtn.Size=UDim2.new(0,30,0,30); ssPlusBtn.Position=UDim2.new(1,-30,0,0)
            ssPlusBtn.BackgroundColor3=C2.CARD2; ssPlusBtn.BorderSizePixel=0; ssPlusBtn.Text="+"
            ssPlusBtn.TextColor3=C2.TEXT; ssPlusBtn.TextSize=18; ssPlusBtn.Font=Enum.Font.GothamBold; ssPlusBtn.ZIndex=702; ssPlusBtn.Parent=ssFrame; mkCorner(7,ssPlusBtn)
            local function updateSsLabel() ssLbl.Text=math.floor(smoothStrength*100).."%" end
            ssMinBtn.MouseButton1Click:Connect(function() smoothStrength=math.max(0.05,smoothStrength-0.05); updateSsLabel() end)
            ssPlusBtn.MouseButton1Click:Connect(function() smoothStrength=math.min(1,smoothStrength+0.05); updateSsLabel() end)
            holdRepeat(ssMinBtn,function() smoothStrength=math.max(0.05,smoothStrength-0.05); updateSsLabel() end)
            holdRepeat(ssPlusBtn,function() smoothStrength=math.min(1,smoothStrength+0.05); updateSsLabel() end)
        end

        secLabel("STATS",11)
        local counterLbl=Instance.new("TextLabel"); counterLbl.Size=UDim2.new(1,0,0,20); counterLbl.BackgroundTransparency=1
        counterLbl.Text="Draw:0  Paint:0  Smooth:0  Convert:0"; counterLbl.TextColor3=C2.SUBTEXT
        counterLbl.TextSize=9; counterLbl.Font=Enum.Font.Gotham; counterLbl.TextXAlignment=Enum.TextXAlignment.Left
        counterLbl.LayoutOrder=12; counterLbl.Parent=body
        local function updateCounter()
            counterLbl.Text=string.format("Draw:%d  Paint:%d  Smooth:%d  Convert:%d",
                #terrainData,#paintData,#smoothData,#convertData)
        end

        secLabel("ACTIONS",13)
        local clearBtn, generateBtn
        do
            local actFrame=Instance.new("Frame"); actFrame.Size=UDim2.new(1,0,0,90); actFrame.BackgroundTransparency=1; actFrame.LayoutOrder=14; actFrame.Parent=body
            actFrame.AutomaticSize=Enum.AutomaticSize.Y
            do local actGrid=Instance.new("UIGridLayout"); actGrid.CellSize=UDim2.new(0,72,0,26); actGrid.CellPadding=UDim2.new(0,4,0,4); actGrid.HorizontalAlignment=Enum.HorizontalAlignment.Left; actGrid.Parent=actFrame end
            clearBtn=Instance.new("TextButton"); clearBtn.BackgroundColor3=C2.ORANGE; clearBtn.BorderSizePixel=0
            clearBtn.Text="CLEAR ALL"; clearBtn.TextColor3=C2.WHITE; clearBtn.TextSize=9; clearBtn.Font=Enum.Font.GothamBold; clearBtn.ZIndex=702; clearBtn.Parent=actFrame; mkCorner(6,clearBtn)
            generateBtn=Instance.new("TextButton"); generateBtn.BackgroundColor3=C2.BLUE; generateBtn.BorderSizePixel=0
            generateBtn.Text="GENERATE"; generateBtn.TextColor3=C2.WHITE; generateBtn.TextSize=9; generateBtn.Font=Enum.Font.GothamBold; generateBtn.ZIndex=702; generateBtn.Parent=actFrame; mkCorner(6,generateBtn)
            grassColorOpenBtn=Instance.new("TextButton"); grassColorOpenBtn.BackgroundColor3=Color3.fromRGB(40,120,50); grassColorOpenBtn.BorderSizePixel=0
            grassColorOpenBtn.Text="ًںژ¨ Grass"; grassColorOpenBtn.TextColor3=C2.WHITE; grassColorOpenBtn.TextSize=9; grassColorOpenBtn.Font=Enum.Font.GothamBold; grassColorOpenBtn.ZIndex=702; grassColorOpenBtn.Parent=actFrame; mkCorner(6,grassColorOpenBtn)
        end


        local function eraseNearby(pos,size)
            local margin=size*1.5
            for i=#terrainData,1,-1 do if (terrainData[i].pos-pos).Magnitude<margin then table.remove(terrainData,i) end end
        end
        local function paintTerrain(pos, size, mat)
            local half = size/2
            local reg = Region3.new(pos-Vector3.new(half,half,half),pos+Vector3.new(half,half,half)):ExpandToGrid(VOXEL_RES)
            local ok,mats,occs = pcall(function() return Terrain:ReadVoxels(reg,VOXEL_RES) end)
            if not ok then return end
            local sx,sy,sz = mats.Size.X,mats.Size.Y,mats.Size.Z
            local nm,no = {},{}
            for x=1,sx do nm[x]={}; no[x]={}; for y=1,sy do nm[x][y]={}; no[x][y]={}; for z=1,sz do
                local occ=occs[x][y][z] or 0; local m=mats[x][y][z] or Enum.Material.Air
                if m~=Enum.Material.Air and occ>0 then nm[x][y][z]=mat; no[x][y][z]=occ
                else nm[x][y][z]=Enum.Material.Air; no[x][y][z]=0 end
            end end end
            pcall(function() Terrain:WriteVoxels(reg,VOXEL_RES,nm,no) end)
        end
        local function smoothTerrain(pos,size,strength)
            local half=size/2
            local reg=Region3.new(pos-Vector3.new(half,half,half),pos+Vector3.new(half,half,half)):ExpandToGrid(VOXEL_RES)
            local ok,mats,occs=pcall(function() return Terrain:ReadVoxels(reg,VOXEL_RES) end)
            if not ok then return end
            local sx,sy,sz=mats.Size.X,mats.Size.Y,mats.Size.Z
            local nm,no={},{}
            for x=1,sx do nm[x]={}; no[x]={}; for y=1,sy do nm[x][y]={}; no[x][y]={}; for z=1,sz do
                local sum,cnt,bo,bm=0,0,-1,Enum.Material.Air
                for dx=-1,1 do for dy=-1,1 do for dz=-1,1 do
                    local nx2,ny2,nz2=x+dx,y+dy,z+dz
                    if nx2>=1 and ny2>=1 and nz2>=1 and nx2<=sx and ny2<=sy and nz2<=sz then
                        local o2=occs[nx2][ny2][nz2] or 0; sum=sum+o2; cnt=cnt+1
                        if o2>bo and mats[nx2][ny2][nz2]~=Enum.Material.Air then bo=o2; bm=mats[nx2][ny2][nz2] end
                    end
                end end end
                local avg=cnt>0 and sum/cnt or 0; local orig=occs[x][y][z] or 0
                local nw=math.clamp(orig+(avg-orig)*strength,0,1)
                if nw<0.04 then nm[x][y][z]=Enum.Material.Air; no[x][y][z]=0
                else local um=mats[x][y][z]; if um==Enum.Material.Air then um=bm end; nm[x][y][z]=um; no[x][y][z]=nw end
            end end end
            pcall(function() Terrain:WriteVoxels(reg,VOXEL_RES,nm,no) end)
        end
        local function convertPartToTerrain(part, mat)
            local s=part.Size; local cf=part.CFrame; local pos=cf.Position
            local isCyl=part:IsA("Part") and part.Shape==Enum.PartType.Cylinder
            if isCyl then
                local height=s.X; local radius=math.max(s.Y,s.Z)/2
                local up=cf.RightVector; local look=cf.LookVector
                look=(look-up*look:Dot(up))
                if look.Magnitude<0.001 then look=cf.UpVector end
                look=look.Unit; local right=up:Cross(look).Unit
                local fillCF=CFrame.fromMatrix(pos,right,up,-look)
                pcall(function() Terrain:FillCylinder(fillCF,height,radius,mat) end)
                table.insert(convertData,{pos=pos,cf=fillCF,height=height,radius=radius,material=mat,shape="Cylinder"})
            else
                pcall(function() Terrain:FillBlock(cf,s,mat) end)
                table.insert(convertData,{pos=pos,cf=cf,sizeVec=s,material=mat,shape="Block"})
            end
            part:Destroy(); updateCounter()
        end


        local function generateScript()
            local lines = {}
            local gc = currentGrassColor
            if not gc or type(gc.r)~="number" then gc={r=106,g=127,b=63} end
            table.insert(lines, "-- GENERATED BY STUDIO LITE BY EZY  |  "..os.date("%Y-%m-%d %H:%M:%S"))
            table.insert(lines, "local T = workspace.Terrain")
            table.insert(lines, "local basePart = script.Parent\n")
            table.insert(lines, "-- == GRASS COLOR ==")
            table.insert(lines, string.format("T:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(%d,%d,%d))",gc.r,gc.g,gc.b))
            table.insert(lines, string.format("T:SetMaterialColor(Enum.Material.LeafyGrass, Color3.fromRGB(%d,%d,%d))\n",gc.r,gc.g,gc.b))

            if #convertData>0 then
                local cylE,blkE={},{}
                for _,e in ipairs(convertData) do
                    if e.shape=="Cylinder" then table.insert(cylE,e) else table.insert(blkE,e) end
                end
                if #blkE>0 then
                    table.insert(lines,"-- == CONVERT BLOCK ==\nlocal convertBlocks = {")
                    for _,e in ipairs(blkE) do
                        local mn=materialToName[e.material] or "Grass"
                        table.insert(lines,string.format("  {cf=CFrame.new(%.3f,%.3f,%.3f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f),sx=%.3f,sy=%.3f,sz=%.3f,m=Enum.Material.%s},",
                            e.cf.X,e.cf.Y,e.cf.Z,
                            e.cf.RightVector.X,e.cf.RightVector.Y,e.cf.RightVector.Z,
                            e.cf.UpVector.X,e.cf.UpVector.Y,e.cf.UpVector.Z,
                            -e.cf.LookVector.X,-e.cf.LookVector.Y,-e.cf.LookVector.Z,
                            e.sizeVec.X,e.sizeVec.Y,e.sizeVec.Z,mn))
                    end
                    table.insert(lines,"}\nfor _,d in ipairs(convertBlocks) do T:FillBlock(d.cf,Vector3.new(d.sx,d.sy,d.sz),d.m) end\ntask.wait()\n")
                end
                if #cylE>0 then
                    table.insert(lines,"-- == CONVERT CYLINDER ==\nlocal convertCylinders = {")
                    for _,e in ipairs(cylE) do
                        local mn=materialToName[e.material] or "Grass"
                        table.insert(lines,string.format("  {cf=CFrame.new(%.3f,%.3f,%.3f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f),h=%.3f,r=%.3f,m=Enum.Material.%s},",
                            e.cf.X,e.cf.Y,e.cf.Z,
                            e.cf.RightVector.X,e.cf.RightVector.Y,e.cf.RightVector.Z,
                            e.cf.UpVector.X,e.cf.UpVector.Y,e.cf.UpVector.Z,
                            -e.cf.LookVector.X,-e.cf.LookVector.Y,-e.cf.LookVector.Z,
                            e.height,e.radius,mn))
                    end
                    table.insert(lines,"}\nfor _,d in ipairs(convertCylinders) do T:FillCylinder(d.cf,d.h,d.r,d.m) end\ntask.wait()\n")
                end
            end
            if #terrainData>0 then
                table.insert(lines,"-- == DRAW / ERASE ==\nlocal drawData = {")
                for _,e in ipairs(terrainData) do
                    local mn=materialToName[e.material] or "Grass"
                    table.insert(lines,string.format("  {p=Vector3.new(%.3f,%.3f,%.3f),s=%.3f,m=Enum.Material.%s,sh=%q},",e.pos.X,e.pos.Y,e.pos.Z,e.size,mn,e.shape or "Block"))
                end
                table.insert(lines,"}\nfor i,d in ipairs(drawData) do\n  if d.sh=='Ball' then T:FillBall(d.p,d.s/2,d.m) else T:FillBlock(CFrame.new(d.p),Vector3.new(d.s,d.s,d.s),d.m) end\n  if i%20==0 then task.wait() end\nend\ntask.wait()\n")
            end
            if #paintData>0 then
                table.insert(lines,"-- == PAINT ==\nlocal paintData2 = {")
                for _,e in ipairs(paintData) do
                    local mn=materialToName[e.material] or "Grass"
                    table.insert(lines,string.format("  {p=Vector3.new(%.3f,%.3f,%.3f),s=%.3f,m=Enum.Material.%s},",e.pos.X,e.pos.Y,e.pos.Z,e.size,mn))
                end
                table.insert(lines,"}\nlocal VR_P=4\nfor i,d in ipairs(paintData2) do\n  local half=d.s/2\n  local reg=Region3.new(d.p-Vector3.new(half,half,half),d.p+Vector3.new(half,half,half)):ExpandToGrid(VR_P)\n  local ok,mats,occs=pcall(function() return T:ReadVoxels(reg,VR_P) end)\n  if ok then local sx,sy,sz=mats.Size.X,mats.Size.Y,mats.Size.Z; local nm,no={},{}\n    for x=1,sx do nm[x]={}; no[x]={} for y=1,sy do nm[x][y]={}; no[x][y]={} for z=1,sz do\n      local occ=occs[x][y][z] or 0; local m=mats[x][y][z] or Enum.Material.Air\n      if m~=Enum.Material.Air and occ>0 then nm[x][y][z]=d.m; no[x][y][z]=occ\n      else nm[x][y][z]=Enum.Material.Air; no[x][y][z]=0 end\n    end end end\n    pcall(function() T:WriteVoxels(reg,VR_P,nm,no) end)\n  end\n  if i%5==0 then task.wait() end\nend\ntask.wait()\n")
            end
            return table.concat(lines,"\n")
        end

        local viewerPanel = Instance.new("Frame")
        viewerPanel.Name="ScriptViewer"; viewerPanel.Size=UDim2.new(0,0,0,0)
        viewerPanel.Position=UDim2.new(0,328,0,TOPBAR_H+4); viewerPanel.BackgroundColor3=C2.BG
        viewerPanel.BorderSizePixel=0; viewerPanel.ClipsDescendants=true; viewerPanel.Visible=false
        viewerPanel.ZIndex=800; viewerPanel.Parent=mainGui
        mkCorner(12,viewerPanel); mkStroke(1.5,C2.BORDBRT,viewerPanel)

        local viewerOpen=false
        local function openViewer(code, scriptName)
            viewerOpen=true; viewerPanel.Visible=true
            local screenW=mainGui.AbsoluteSize.X
            local screenH=mainGui.AbsoluteSize.Y
            local vw=math.max(220, math.min(380, screenW-20))
            local ph=math.max(180, math.min(screenH-60,600))
            viewerPanel.Position=UDim2.new(0.5,-vw/2,0,TOPBAR_H+4)
            TweenService:Create(viewerPanel,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,vw,0,ph)}):Play()
            for _,child in ipairs(viewerPanel:GetChildren()) do child:Destroy() end
            mkCorner(12,viewerPanel); mkStroke(1.5,C2.BORDBRT,viewerPanel)
            local vh=Instance.new("Frame"); vh.Size=UDim2.new(1,0,0,38); vh.BackgroundColor3=C2.SURFACE
            vh.BorderSizePixel=0; vh.ZIndex=801; vh.Parent=viewerPanel; mkCorner(12,vh)
            local vTitle=Instance.new("TextLabel"); vTitle.Size=UDim2.new(1,-90,1,0); vTitle.Position=UDim2.new(0,10,0,0)
            vTitle.BackgroundTransparency=1; vTitle.Text="ًں“„ "..tostring(scriptName or "Script")
            vTitle.TextColor3=C2.TEXT; vTitle.TextSize=11; vTitle.Font=Enum.Font.GothamBold
            vTitle.TextXAlignment=Enum.TextXAlignment.Left; vTitle.ZIndex=802; vTitle.Parent=vh
            local vCopy=Instance.new("TextButton"); vCopy.Size=UDim2.new(0,52,0,26); vCopy.Position=UDim2.new(1,-92,0.5,-13)
            vCopy.BackgroundColor3=C2.BLUE; vCopy.BorderSizePixel=0; vCopy.Text="Copy"
            vCopy.TextColor3=C2.WHITE; vCopy.TextSize=10; vCopy.Font=Enum.Font.GothamBold; vCopy.ZIndex=802; vCopy.Parent=vh; mkCorner(6,vCopy)
            vCopy.MouseButton1Click:Connect(function()
                pcall(function() setclipboard(code) end)
                vCopy.Text="✓ OK"; vCopy.BackgroundColor3=C2.GREEN
                task.wait(1.5); vCopy.Text="Copy"; vCopy.BackgroundColor3=C2.BLUE
            end)
            local vClose=Instance.new("TextButton"); vClose.Size=UDim2.new(0,32,0,26); vClose.Position=UDim2.new(1,-36,0.5,-13)
            vClose.BackgroundColor3=Color3.fromRGB(50,20,20); vClose.BorderSizePixel=0; vClose.Text="×"
            vClose.TextColor3=C2.WHITE; vClose.TextSize=11; vClose.Font=Enum.Font.GothamBold; vClose.ZIndex=802; vClose.Parent=vh; mkCorner(6,vClose)
            vClose.MouseButton1Click:Connect(function()
                viewerOpen=false
                local t=TweenService:Create(viewerPanel,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)})
                t:Play(); t.Completed:Once(function() viewerPanel.Visible=false end)
            end)
            local infoLbl=Instance.new("TextLabel"); infoLbl.Size=UDim2.new(1,-16,0,18); infoLbl.Position=UDim2.new(0,8,0,42)
            infoLbl.BackgroundTransparency=1; infoLbl.Text=string.format("%d baris  •  %d karakter",#code:split("\n"),#code)
            infoLbl.TextColor3=C2.SUBTEXT; infoLbl.TextSize=9; infoLbl.Font=Enum.Font.Gotham
            infoLbl.TextXAlignment=Enum.TextXAlignment.Left; infoLbl.ZIndex=801; infoLbl.Parent=viewerPanel
            local vScroll=Instance.new("ScrollingFrame")
            vScroll.Size=UDim2.new(1,-8,1,-66); vScroll.Position=UDim2.new(0,4,0,62)
            vScroll.BackgroundColor3=C2.CARD; vScroll.BorderSizePixel=0
            vScroll.ScrollBarThickness=4; vScroll.ScrollBarImageColor3=C2.BORDBRT
            vScroll.ScrollingDirection=Enum.ScrollingDirection.Y; vScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
            vScroll.CanvasSize=UDim2.new(0,0,0,0); vScroll.ElasticBehavior=Enum.ElasticBehavior.Never
            vScroll.ZIndex=801; vScroll.Parent=viewerPanel; mkCorner(8,vScroll); mkStroke(1,C2.BORDER,vScroll)
            mkPad(6,6,8,8,vScroll)
            local lineContainer=Instance.new("Frame"); lineContainer.Size=UDim2.new(1,0,0,0)
            lineContainer.AutomaticSize=Enum.AutomaticSize.Y; lineContainer.BackgroundTransparency=1; lineContainer.Parent=vScroll
            Instance.new("UIListLayout").Parent=lineContainer
            for i,line in ipairs(code:split("\n")) do
                local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,16); row.BackgroundTransparency=1; row.Parent=lineContainer
                local numLbl=Instance.new("TextLabel"); numLbl.Size=UDim2.new(0,28,1,0); numLbl.BackgroundTransparency=1
                numLbl.Text=tostring(i); numLbl.TextColor3=C2.SUBTEXT; numLbl.TextSize=9; numLbl.Font=Enum.Font.Gotham
                numLbl.TextXAlignment=Enum.TextXAlignment.Right; numLbl.ZIndex=802; numLbl.Parent=row
                local codeLbl=Instance.new("TextLabel"); codeLbl.Size=UDim2.new(1,-34,1,0); codeLbl.Position=UDim2.new(0,34,0,0)
                codeLbl.BackgroundTransparency=1; codeLbl.Text=line=="" and " " or line
                codeLbl.TextColor3=C2.TEXT; codeLbl.TextSize=9; codeLbl.Font=Enum.Font.Code
                codeLbl.TextXAlignment=Enum.TextXAlignment.Left; codeLbl.TextTruncate=Enum.TextTruncate.AtEnd
                codeLbl.ZIndex=802; codeLbl.Parent=row
            end
            makeDraggable2(vh, viewerPanel)
        end


        local scriptList={}
        local listPanel=Instance.new("Frame"); listPanel.Size=UDim2.new(0,0,0,0)
        listPanel.Position=UDim2.new(0,328,0,TOPBAR_H+4); listPanel.BackgroundColor3=C2.SURFACE
        listPanel.BorderSizePixel=0; listPanel.ClipsDescendants=true; listPanel.Visible=false
        listPanel.ZIndex=750; listPanel.Parent=mainGui; mkCorner(10,listPanel); mkStroke(1.5,C2.BORDBRT,listPanel)
        local listOpen=false
        local function openList()
            listOpen=true; listPanel.Visible=true
            local screenW=mainGui.AbsoluteSize.X
            local screenH=mainGui.AbsoluteSize.Y
            local lw=math.max(220, math.min(260, screenW-20))
            local lh=math.max(180, math.min(320, screenH-60))
            listPanel.Position=UDim2.new(0.5,-lw/2,0,TOPBAR_H+4)
            TweenService:Create(listPanel,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,lw,0,lh)}):Play()
        end
        local function closeList()
            listOpen=false
            local t=TweenService:Create(listPanel,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)})
            t:Play(); t.Completed:Once(function() listPanel.Visible=false end)
        end
        do
            local lh=Instance.new("Frame"); lh.Size=UDim2.new(1,0,0,32); lh.BackgroundColor3=C2.BG
            lh.BorderSizePixel=0; lh.ZIndex=751; lh.Parent=listPanel; mkCorner(10,lh)
            local lhTitle=Instance.new("TextLabel"); lhTitle.Size=UDim2.new(1,-40,1,0); lhTitle.Position=UDim2.new(0,8,0,0)
            lhTitle.BackgroundTransparency=1; lhTitle.Text="Generated Scripts"; lhTitle.TextColor3=C2.TEXT
            lhTitle.TextSize=11; lhTitle.Font=Enum.Font.GothamBold; lhTitle.TextXAlignment=Enum.TextXAlignment.Left
            lhTitle.ZIndex=752; lhTitle.Parent=lh
            makeDraggable2(lh, listPanel)
            local closeLBtn=Instance.new("TextButton"); closeLBtn.Size=UDim2.new(0,26,0,22); closeLBtn.Position=UDim2.new(1,-30,0.5,-11)
            closeLBtn.BackgroundColor3=Color3.fromRGB(50,20,20); closeLBtn.BorderSizePixel=0; closeLBtn.Text="×"
            closeLBtn.TextColor3=C2.WHITE; closeLBtn.TextSize=10; closeLBtn.Font=Enum.Font.GothamBold
            closeLBtn.ZIndex=752; closeLBtn.Parent=lh; mkCorner(5,closeLBtn)
            closeLBtn.MouseButton1Click:Connect(closeList)
        end
        local lScroll=Instance.new("ScrollingFrame"); lScroll.Size=UDim2.new(1,-8,1,-36); lScroll.Position=UDim2.new(0,4,0,34)
        lScroll.BackgroundTransparency=1; lScroll.BorderSizePixel=0; lScroll.ScrollBarThickness=3
        lScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; lScroll.CanvasSize=UDim2.new(0,0,0,0)
        lScroll.ZIndex=751; lScroll.Parent=listPanel
        Instance.new("UIListLayout").Parent=lScroll

        local function addScriptToList(name, code)
            table.insert(scriptList,{name=name,code=code})
            local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,72); row.BackgroundColor3=C2.CARD
            row.BorderSizePixel=0; row.ZIndex=752; row.Parent=lScroll; mkCorner(8,row); mkStroke(1,C2.BORDER,row)
            local rName=Instance.new("TextLabel"); rName.Size=UDim2.new(1,-8,0,18); rName.Position=UDim2.new(0,6,0,4)
            rName.BackgroundTransparency=1; rName.Text="ًں“„ "..name; rName.TextColor3=C2.TEXT
            rName.TextSize=10; rName.Font=Enum.Font.GothamBold; rName.TextXAlignment=Enum.TextXAlignment.Left; rName.ZIndex=753; rName.Parent=row
            local rInfo=Instance.new("TextLabel"); rInfo.Size=UDim2.new(1,-8,0,14); rInfo.Position=UDim2.new(0,6,0,22)
            rInfo.BackgroundTransparency=1; rInfo.Text=#code:split("\n").." baris  •  "..#code.." karakter"
            rInfo.TextColor3=C2.SUBTEXT; rInfo.TextSize=9; rInfo.Font=Enum.Font.Gotham
            rInfo.TextXAlignment=Enum.TextXAlignment.Left; rInfo.ZIndex=753; rInfo.Parent=row
            local viewBtn=Instance.new("TextButton"); viewBtn.Size=UDim2.new(0,52,0,24); viewBtn.Position=UDim2.new(0,6,1,-30)
            viewBtn.BackgroundColor3=C2.PURPLE; viewBtn.BorderSizePixel=0; viewBtn.Text="ًں‘پ View"
            viewBtn.TextColor3=C2.WHITE; viewBtn.TextSize=9; viewBtn.Font=Enum.Font.GothamBold; viewBtn.ZIndex=754; viewBtn.Parent=row; mkCorner(5,viewBtn)
            viewBtn.MouseButton1Click:Connect(function() openViewer(code,name) end)
            local copyBtn3=Instance.new("TextButton"); copyBtn3.Size=UDim2.new(0,52,0,24); copyBtn3.Position=UDim2.new(0,62,1,-30)
            copyBtn3.BackgroundColor3=C2.BLUE; copyBtn3.BorderSizePixel=0; copyBtn3.Text="ًں“‹ Copy"
            copyBtn3.TextColor3=C2.WHITE; copyBtn3.TextSize=9; copyBtn3.Font=Enum.Font.GothamBold; copyBtn3.ZIndex=754; copyBtn3.Parent=row; mkCorner(5,copyBtn3)
            copyBtn3.MouseButton1Click:Connect(function()
                pcall(function() setclipboard(code) end)
                copyBtn3.Text="✓"; copyBtn3.BackgroundColor3=C2.GREEN
                task.wait(1.5); copyBtn3.Text="ًں“‹ Copy"; copyBtn3.BackgroundColor3=C2.BLUE
            end)
            local inPartBtn=Instance.new("TextButton"); inPartBtn.Size=UDim2.new(0,72,0,24); inPartBtn.Position=UDim2.new(0,118,1,-30)
            inPartBtn.BackgroundColor3=C2.ORANGE; inPartBtn.BorderSizePixel=0; inPartBtn.Text="ًں“¦ In Part"
            inPartBtn.TextColor3=C2.WHITE; inPartBtn.TextSize=9; inPartBtn.Font=Enum.Font.GothamBold; inPartBtn.ZIndex=754; inPartBtn.Parent=row; mkCorner(5,inPartBtn)
            inPartBtn.MouseButton1Click:Connect(function()
                local sel2 = game:GetService("Selection"):Get()
                local tumbalPart2 = nil
                for _,obj in ipairs(sel2) do if obj:IsA("BasePart") then tumbalPart2=obj; break end end
                if not tumbalPart2 then
                    tumbalPart2 = workspace:FindFirstChild("TerrainTumbal")
                    if tumbalPart2 and not tumbalPart2:IsA("BasePart") then tumbalPart2=nil end
                end
                if not tumbalPart2 then
                    showToast("⚠  Pilih dulu Part di workspace sebagai tumbal!", C2.ORANGE); return
                end
                for _,ch in ipairs(tumbalPart2:GetChildren()) do
                    if ch:IsA("Script") and ch.Name:sub(1,11)=="TerrainCode" then ch:Destroy() end
                end
                local newCode = generateScript()
                local newScr = Instance.new("Script")
                newScr.Name = "TerrainCode_"..os.date("%H%M%S")
                newScr.Source = newCode
                newScr.Disabled = true
                newScr.Parent = tumbalPart2
                local hl2 = Instance.new("SelectionBox"); hl2.Adornee=tumbalPart2
                hl2.Color3=Color3.fromRGB(255,140,0); hl2.LineThickness=0.08
                hl2.SurfaceTransparency=0.7; hl2.SurfaceColor3=Color3.fromRGB(255,140,0)
                hl2.Parent=workspace
                game:GetService("Selection"):Set({newScr})
                task.delay(3,function() pcall(function() hl2:Destroy() end) end)
                inPartBtn.Text="✓ Done!"; inPartBtn.BackgroundColor3=C2.GREEN
                showToast("✓ Script di Part: "..tumbalPart2.Name.." (arah: rotasi part)", C2.GREEN)
                task.wait(2); inPartBtn.Text="ًں“¦ In Part"; inPartBtn.BackgroundColor3=C2.ORANGE
            end)
            row.MouseEnter:Connect(function() row.BackgroundColor3=C2.CARD2 end)
            row.MouseLeave:Connect(function() row.BackgroundColor3=C2.CARD end)
        end

        secLabel("SCRIPTS",15)
        local listTrigger=Instance.new("TextButton"); listTrigger.Size=UDim2.new(1,0,0,28); listTrigger.BackgroundColor3=C2.CARD2
        listTrigger.BorderSizePixel=0; listTrigger.Text="▾ Lihat Generated Scripts (0)"; listTrigger.TextColor3=C2.TEXT
        listTrigger.TextSize=10; listTrigger.Font=Enum.Font.GothamBold; listTrigger.ZIndex=702
        listTrigger.LayoutOrder=16; listTrigger.Parent=body; mkCorner(7,listTrigger)
        listTrigger.MouseButton1Click:Connect(function() if listOpen then closeList() else openList() end end)


        local brushEnabled=false
        onoffBtn.MouseButton1Click:Connect(function()
            brushEnabled=not brushEnabled
            onoffBtn.BackgroundColor3=brushEnabled and C2.GREEN or C2.RED
            onoffBtn.Text=brushEnabled and "ON" or "OFF"
        end)

        clearBtn.MouseButton1Click:Connect(function()
            if #terrainData==0 and #paintData==0 and #smoothData==0 and #convertData==0 then return end
            for _,e in ipairs(terrainData) do
                pcall(function()
                    if e.shape=="Ball" then Terrain:FillBall(e.pos,e.size/2,Enum.Material.Air)
                    else Terrain:FillBlock(CFrame.new(e.pos),Vector3.new(e.size,e.size,e.size),Enum.Material.Air) end
                end)
            end
            terrainData={}; paintData={}; smoothData={}; convertData={}; updateCounter()
            listTrigger.Text="▾ Lihat Generated Scripts (0)"
            clearBtn.Text="CLEARED!"; clearBtn.BackgroundColor3=Color3.fromRGB(160,50,10)
            task.wait(1.5); clearBtn.Text="CLEAR ALL"; clearBtn.BackgroundColor3=C2.ORANGE
        end)

        generateBtn.MouseButton1Click:Connect(function()
            if #terrainData==0 and #paintData==0 and #smoothData==0 and #convertData==0 then
                generateBtn.Text="NO DATA!"; generateBtn.BackgroundColor3=C2.RED
                task.wait(1.2); generateBtn.Text="GENERATE"; generateBtn.BackgroundColor3=C2.BLUE; return
            end
            generateBtn.Text="GENERATING..."; generateBtn.BackgroundColor3=C2.YELLOW; task.wait(0.3)
            local code=generateScript()
            local sName="Terrain_"..os.date("%H%M%S")
            addScriptToList(sName,code)
            listTrigger.Text="▾ Lihat Generated Scripts ("..#scriptList..")"
            generateBtn.Text="DONE ✓"; generateBtn.BackgroundColor3=C2.GREEN
            if not listOpen then openList() end
            task.wait(2); generateBtn.Text="GENERATE"; generateBtn.BackgroundColor3=C2.BLUE
        end)

        local toPartBtn=Instance.new("TextButton")
        toPartBtn.Size=UDim2.new(0,64,0,28); toPartBtn.BackgroundColor3=C2.ORANGE
        toPartBtn.BorderSizePixel=0; toPartBtn.Text="→ Part"
        toPartBtn.TextColor3=C2.WHITE; toPartBtn.TextSize=9; toPartBtn.Font=Enum.Font.GothamBold
        toPartBtn.ZIndex=702; toPartBtn.Parent=actFrame; mkCorner(6,toPartBtn)
        toPartBtn.MouseButton1Click:Connect(function()
            if #terrainData==0 and #paintData==0 and #convertData==0 then
                toPartBtn.Text="NO DATA!"; toPartBtn.BackgroundColor3=C2.RED
                task.wait(1.5); toPartBtn.Text="→ Part"; toPartBtn.BackgroundColor3=C2.ORANGE; return
            end
            toPartBtn.Text="⌛ ..."; toPartBtn.BackgroundColor3=C2.YELLOW; task.wait(0.2)
            local ok, err = pcall(function()
                local code = generateScript()
                local sName = "Terrain_Part_"..os.date("%H%M%S")
                addScriptToList(sName, code)
                listTrigger.Text="▾ Lihat Generated Scripts ("..#scriptList..")"
                if not listOpen then openList() end
                showToast("✓ Script siap! Copy dari viewer → paste ke Script di Part.", C2.GREEN)
            end)
            if ok then
                toPartBtn.Text="✓ Done!"; toPartBtn.BackgroundColor3=C2.GREEN
            else
                showToast("Gagal: "..tostring(err), C2.RED)
                toPartBtn.Text="✕ Gagal"; toPartBtn.BackgroundColor3=C2.RED
            end
            task.wait(2); toPartBtn.Text="→ Part"; toPartBtn.BackgroundColor3=C2.ORANGE
        end)

        local matSelector=nil
        local function createMaterialSelector(callback)
            if matSelector then matSelector:Destroy() end
            matSelector=Instance.new("Frame"); matSelector.Size=UDim2.new(0,200,0,230)
            matSelector.Position=UDim2.new(0.5,-100,0.5,-115); matSelector.BackgroundColor3=C2.CARD
            matSelector.BorderSizePixel=0; matSelector.ZIndex=950; matSelector.Parent=mainGui
            mkCorner(10,matSelector); mkStroke(1.5,C2.BORDBRT,matSelector)
            local msT=Instance.new("TextLabel"); msT.Size=UDim2.new(1,0,0,30); msT.BackgroundTransparency=1
            msT.Text="Pilih Material Terrain"; msT.TextColor3=C2.TEXT; msT.TextSize=11; msT.Font=Enum.Font.GothamBold; msT.ZIndex=951; msT.Parent=matSelector
            local msCancelBtn=Instance.new("TextButton"); msCancelBtn.Size=UDim2.new(0,24,0,22); msCancelBtn.Position=UDim2.new(1,-28,0,4)
            msCancelBtn.BackgroundColor3=C2.RED; msCancelBtn.BorderSizePixel=0; msCancelBtn.Text="×"
            msCancelBtn.TextColor3=C2.WHITE; msCancelBtn.TextSize=10; msCancelBtn.Font=Enum.Font.GothamBold; msCancelBtn.ZIndex=951; msCancelBtn.Parent=matSelector; mkCorner(5,msCancelBtn)
            msCancelBtn.MouseButton1Click:Connect(function() if matSelector then matSelector:Destroy(); matSelector=nil end end)
            local msScroll=Instance.new("ScrollingFrame"); msScroll.Size=UDim2.new(1,-8,1,-34); msScroll.Position=UDim2.new(0,4,0,32)
            msScroll.BackgroundTransparency=1; msScroll.BorderSizePixel=0; msScroll.ScrollBarThickness=3
            msScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; msScroll.CanvasSize=UDim2.new(0,0,0,0); msScroll.ZIndex=951; msScroll.Parent=matSelector
            local msLayout=Instance.new("UIListLayout"); msLayout.Padding=UDim.new(0,3); msLayout.Parent=msScroll
            for _,td in ipairs(terrainTypes) do
                local mb=Instance.new("TextButton"); mb.Size=UDim2.new(1,0,0,26)
                mb.BackgroundColor3=C2.CARD2; mb.BorderSizePixel=0; mb.Text=td.name
                mb.TextColor3=C2.TEXT; mb.TextSize=10; mb.Font=Enum.Font.GothamBold; mb.ZIndex=952; mb.Parent=msScroll; mkCorner(5,mb)
                local dot2=Instance.new("Frame"); dot2.Size=UDim2.new(0,12,0,12); dot2.Position=UDim2.new(1,-18,0.5,-6)
                dot2.BackgroundColor3=td.color; dot2.BorderSizePixel=0; dot2.ZIndex=953; dot2.Parent=mb; mkCorner(3,dot2)
                mb.MouseButton1Click:Connect(function()
                    if matSelector then matSelector:Destroy(); matSelector=nil end; callback(td.mat)
                end)
            end
        end


        local painting=false; local lastPaint=0; local DELAY=0.05; local pendingPart=nil
        mouse.Button1Down:Connect(function() if brushEnabled then painting=true end end)
        mouse.Button1Up:Connect(function() painting=false end)
        mouse.Button1Up:Connect(function()
            if not brushEnabled or brushMode~="Convert" then return end
            local target=mouse.Target
            if not (target and target:IsA("BasePart") and target.Parent) then return end
            if target==workspace.Terrain then return end
            pendingPart=target
            createMaterialSelector(function(selectedMaterial)
                if pendingPart and pendingPart.Parent then convertPartToTerrain(pendingPart,selectedMaterial) end
                pendingPart=nil
            end)
        end)
        RunService.Heartbeat:Connect(function()
            if not painting or not brushEnabled then return end
            if brushMode=="Convert" then return end
            if (tick()-lastPaint)<DELAY then return end
            local pos=mouse.Hit.Position; local size=math.clamp(currentSize,1,64)
            if brushMode=="Draw" then
                pcall(function()
                    if selectedShape=="Ball" then Terrain:FillBall(pos,size/2,selectedTerrain)
                    else Terrain:FillBlock(CFrame.new(pos),Vector3.new(size,size,size),selectedTerrain) end
                end)
                table.insert(terrainData,{pos=pos,size=size,material=selectedTerrain,shape=selectedShape}); updateCounter()
            elseif brushMode=="Erase" then
                pcall(function()
                    if selectedShape=="Ball" then Terrain:FillBall(pos,size/2,Enum.Material.Air)
                    else Terrain:FillBlock(CFrame.new(pos),Vector3.new(size,size,size),Enum.Material.Air) end
                end)
                eraseNearby(pos,size); updateCounter()
            elseif brushMode=="Paint" then
                pcall(function() paintTerrain(pos,size,selectedTerrain) end)
                table.insert(paintData,{pos=pos,size=size,material=selectedTerrain}); updateCounter()
            elseif brushMode=="Smooth" then
                pcall(function() smoothTerrain(pos,size,smoothStrength) end)
                table.insert(smoothData,{pos=pos,size=size,strength=smoothStrength}); updateCounter()
            end
            lastPaint=tick()
        end)
    end
    _terrain()


    local function _grass()
        local grassPopup = Instance.new("Frame")
        grassPopup.Name = "GrassColorPopup"; grassPopup.Size = UDim2.new(0,240,0,0)
        grassPopup.Position = UDim2.new(0,328,0,TOPBAR_H+4); grassPopup.BackgroundColor3 = C2.BG
        grassPopup.BorderSizePixel = 0; grassPopup.ClipsDescendants = true
        grassPopup.Visible = false; grassPopup.ZIndex = 850; grassPopup.Parent = mainGui
        mkCorner(12,grassPopup); mkStroke(1.5,C2.BORDBRT,grassPopup)

        local grassPopupOpen = false
        local function openGrassPopup()
            grassPopupOpen=true; grassPopup.Visible=true
            local screenW=mainGui.AbsoluteSize.X
            local screenH=mainGui.AbsoluteSize.Y
            local gw=math.max(220, math.min(240, screenW-20))
            local gh=math.max(220, math.min(310, screenH-40))
            grassPopup.Position=UDim2.new(0.5,-gw/2,0,TOPBAR_H+4)
            TweenService:Create(grassPopup,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,gw,0,gh)}):Play()
        end
        local function closeGrassPopup()
            grassPopupOpen=false
            local t=TweenService:Create(grassPopup,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,240,0,0)})
            t:Play(); t.Completed:Once(function() grassPopup.Visible=false end)
        end

        do
            local gpHeader=Instance.new("Frame"); gpHeader.Size=UDim2.new(1,0,0,36); gpHeader.BackgroundColor3=C2.SURFACE; gpHeader.BorderSizePixel=0
            gpHeader.ZIndex=851; gpHeader.Parent=grassPopup; mkCorner(12,gpHeader); makeDraggable2(gpHeader,grassPopup)
            local gpTitle=Instance.new("TextLabel"); gpTitle.Size=UDim2.new(1,-50,1,0); gpTitle.Position=UDim2.new(0,12,0,0)
            gpTitle.BackgroundTransparency=1; gpTitle.Text="ًںژ¨  Grass Color"; gpTitle.TextColor3=C2.TEXT; gpTitle.TextSize=11; gpTitle.Font=Enum.Font.GothamBold
            gpTitle.TextXAlignment=Enum.TextXAlignment.Left; gpTitle.ZIndex=852; gpTitle.Parent=gpHeader
            local gpClose=Instance.new("TextButton"); gpClose.Size=UDim2.new(0,26,0,22); gpClose.Position=UDim2.new(1,-30,0.5,-11)
            gpClose.BackgroundColor3=C2.RED; gpClose.BorderSizePixel=0; gpClose.Text="×"
            gpClose.TextColor3=C2.WHITE; gpClose.TextSize=10; gpClose.Font=Enum.Font.GothamBold; gpClose.ZIndex=852; gpClose.Parent=gpHeader; mkCorner(5,gpClose)
            gpClose.MouseButton1Click:Connect(closeGrassPopup)
        end

        local COLS=12; local ROWS=8; local CELL=17; local GAP=1
        local gpPickerFrame=Instance.new("Frame")
        gpPickerFrame.Size=UDim2.new(0,COLS*(CELL+GAP)-GAP,0,(ROWS+1)*(CELL+GAP)+4)
        gpPickerFrame.Position=UDim2.new(0.5,-math.floor(COLS*(CELL+GAP)/2),0,42)
        gpPickerFrame.BackgroundTransparency=1; gpPickerFrame.ZIndex=852; gpPickerFrame.Parent=grassPopup

        local function hsvToRgb(h,s,v)
            local r,g,b; local i=math.floor(h*6); local f=h*6-i; local p,q,t=v*(1-s),v*(1-f*s),v*(1-(1-f)*s); i=i%6
            if i==0 then r,g,b=v,t,p elseif i==1 then r,g,b=q,v,p elseif i==2 then r,g,b=p,v,t
            elseif i==3 then r,g,b=p,q,v elseif i==4 then r,g,b=t,p,v elseif i==5 then r,g,b=v,p,q end
            return math.floor(r*255),math.floor(g*255),math.floor(b*255)
        end

        local currentGrassColor2=currentGrassColor
        local gpDot,gpPreviewLbl,gpR,gpG,gpB

        local function applyGrassColor2(r,g,b)
            currentGrassColor2={r=r,g=g,b=b}; currentGrassColor={r=r,g=g,b=b}
            local col=Color3.fromRGB(r,g,b)
            if gpDot then gpDot.BackgroundColor3=col end
            if grassColorOpenBtn then grassColorOpenBtn.BackgroundColor3=Color3.fromRGB(math.clamp(r//2,20,80),math.clamp(g//2,60,130),math.clamp(b//2,20,60)) end
            if gpPreviewLbl then gpPreviewLbl.Text=string.format("RGB  %d, %d, %d",r,g,b) end
            if gpR then gpR.Text=tostring(r) end; if gpG then gpG.Text=tostring(g) end; if gpB then gpB.Text=tostring(b) end
            pcall(function() Terrain:SetMaterialColor(Enum.Material.Grass,col) end)
            pcall(function() Terrain:SetMaterialColor(Enum.Material.LeafyGrass,col) end)
            saveGrassColor(r,g,b)
        end

        for row=0,ROWS-1 do
            local v=1-row*(0.85/(ROWS-1)); local s=0.85+row*(0.15/(ROWS-1))
            for col=0,COLS-1 do
                local h=col/COLS; local r,g,b=hsvToRgb(h,s,v)
                local cell=Instance.new("TextButton"); cell.Size=UDim2.new(0,CELL,0,CELL)
                cell.Position=UDim2.new(0,col*(CELL+GAP),0,row*(CELL+GAP)); cell.BackgroundColor3=Color3.fromRGB(r,g,b)
                cell.BorderSizePixel=0; cell.Text=""; cell.ZIndex=853; cell.Parent=gpPickerFrame; mkCorner(2,cell)
                cell.MouseButton1Click:Connect(function() applyGrassColor2(r,g,b) end)
                cell.MouseEnter:Connect(function() cell.Size=UDim2.new(0,CELL+2,0,CELL+2); cell.Position=UDim2.new(0,col*(CELL+GAP)-1,0,row*(CELL+GAP)-1) end)
                cell.MouseLeave:Connect(function() cell.Size=UDim2.new(0,CELL,0,CELL); cell.Position=UDim2.new(0,col*(CELL+GAP),0,row*(CELL+GAP)) end)
            end
        end
        local grays={}
        for col=0,COLS-1 do local v2=math.floor(col/(COLS-1)*255); table.insert(grays,{v2,v2,v2}) end
        for col=0,COLS-1 do
            local rv,gv,bv=grays[col+1][1],grays[col+1][2],grays[col+1][3]
            local gcell=Instance.new("TextButton"); gcell.Size=UDim2.new(0,CELL,0,CELL)
            gcell.Position=UDim2.new(0,col*(CELL+GAP),0,ROWS*(CELL+GAP)+4); gcell.BackgroundColor3=Color3.fromRGB(rv,gv,bv)
            gcell.BorderSizePixel=0; gcell.Text=""; gcell.ZIndex=853; gcell.Parent=gpPickerFrame; mkCorner(2,gcell)
            gcell.MouseButton1Click:Connect(function() applyGrassColor2(rv,gv,bv) end)
            gcell.MouseEnter:Connect(function() gcell.Size=UDim2.new(0,CELL+2,0,CELL+2); gcell.Position=UDim2.new(0,col*(CELL+GAP)-1,0,ROWS*(CELL+GAP)+3) end)
            gcell.MouseLeave:Connect(function() gcell.Size=UDim2.new(0,CELL,0,CELL); gcell.Position=UDim2.new(0,col*(CELL+GAP),0,ROWS*(CELL+GAP)+4) end)
        end

        local pickerH=(ROWS+1)*(CELL+GAP)+4
        local gpPreviewRow=Instance.new("Frame"); gpPreviewRow.Size=UDim2.new(1,-16,0,26); gpPreviewRow.Position=UDim2.new(0,8,0,42+pickerH+6)
        gpPreviewRow.BackgroundColor3=C2.CARD; gpPreviewRow.BorderSizePixel=0; gpPreviewRow.ZIndex=852; gpPreviewRow.Parent=grassPopup
        mkCorner(7,gpPreviewRow); mkStroke(1,C2.BORDER,gpPreviewRow)
        do local r2=Instance.new("UIListLayout"); r2.FillDirection=Enum.FillDirection.Horizontal; r2.Padding=UDim.new(0,6); r2.VerticalAlignment=Enum.VerticalAlignment.Center; r2.Parent=gpPreviewRow end
        mkPad(0,0,6,0,gpPreviewRow)
        gpDot=Instance.new("Frame"); gpDot.Size=UDim2.new(0,18,0,18); gpDot.BackgroundColor3=Color3.fromRGB(106,127,63)
        gpDot.BorderSizePixel=0; gpDot.ZIndex=853; gpDot.Parent=gpPreviewRow; mkCorner(4,gpDot)
        gpPreviewLbl=Instance.new("TextLabel"); gpPreviewLbl.Size=UDim2.new(1,-30,1,0); gpPreviewLbl.BackgroundTransparency=1
        gpPreviewLbl.Text="RGB  106, 127, 63"; gpPreviewLbl.TextColor3=C2.TEXT; gpPreviewLbl.TextSize=8; gpPreviewLbl.Font=Enum.Font.Gotham
        gpPreviewLbl.TextXAlignment=Enum.TextXAlignment.Left; gpPreviewLbl.TextTruncate=Enum.TextTruncate.AtEnd; gpPreviewLbl.ZIndex=853; gpPreviewLbl.Parent=gpPreviewRow

        local gpRgbY=42+pickerH+6+26+6
        local gpRgbRow=Instance.new("Frame"); gpRgbRow.Size=UDim2.new(1,-16,0,26); gpRgbRow.Position=UDim2.new(0,8,0,gpRgbY)
        gpRgbRow.BackgroundTransparency=1; gpRgbRow.ZIndex=852; gpRgbRow.Parent=grassPopup
        do local rl=Instance.new("UIListLayout"); rl.FillDirection=Enum.FillDirection.Horizontal; rl.Padding=UDim.new(0,3); rl.VerticalAlignment=Enum.VerticalAlignment.Center; rl.Parent=gpRgbRow end

        local function makeGpBox(ph,def)
            local box=Instance.new("TextBox"); box.Size=UDim2.new(0,42,0,24)
            box.BackgroundColor3=C2.CARD; box.BorderSizePixel=0; box.Text=tostring(def); box.PlaceholderText=ph
            box.TextColor3=C2.TEXT; box.PlaceholderColor3=C2.SUBTEXT; box.TextSize=9; box.Font=Enum.Font.GothamBold
            box.TextXAlignment=Enum.TextXAlignment.Center; box.ClearTextOnFocus=false; box.ZIndex=853; box.Parent=gpRgbRow; mkCorner(5,box); return box
        end
        gpR=makeGpBox("R",106); gpG=makeGpBox("G",127); gpB=makeGpBox("B",63)
        local gpApply=Instance.new("TextButton"); gpApply.Size=UDim2.new(0,58,0,24); gpApply.BackgroundColor3=C2.GREEN; gpApply.BorderSizePixel=0
        gpApply.Text="Terapkan"; gpApply.TextColor3=C2.WHITE; gpApply.TextSize=8; gpApply.Font=Enum.Font.GothamBold; gpApply.ZIndex=853; gpApply.Parent=gpRgbRow; mkCorner(5,gpApply)
        gpApply.MouseButton1Click:Connect(function()
            local r=math.clamp(tonumber(gpR.Text) or 106,0,255); local g=math.clamp(tonumber(gpG.Text) or 127,0,255); local b=math.clamp(tonumber(gpB.Text) or 63,0,255)
            applyGrassColor2(r,g,b); gpApply.Text="✓"; gpApply.BackgroundColor3=C2.CYAN
            task.wait(1); gpApply.Text="Terapkan"; gpApply.BackgroundColor3=C2.GREEN
        end)
        local gpReset=Instance.new("TextButton"); gpReset.Size=UDim2.new(1,-16,0,20); gpReset.Position=UDim2.new(0,8,0,gpRgbY+30)
        gpReset.BackgroundColor3=C2.CARD2; gpReset.BorderSizePixel=0; gpReset.Text="↺  Reset Default (106,127,63)"; gpReset.TextColor3=C2.SUBTEXT
        gpReset.TextSize=8; gpReset.Font=Enum.Font.GothamBold; gpReset.ZIndex=853; gpReset.Parent=grassPopup; mkCorner(5,gpReset)
        gpReset.MouseButton1Click:Connect(function()
            applyGrassColor2(106,127,63); gpReset.Text="✓ Reset!"; gpReset.BackgroundColor3=C2.ORANGE
            task.wait(1.2); gpReset.Text="↺  Reset Default (106,127,63)"; gpReset.BackgroundColor3=C2.CARD2
        end)
        grassColorOpenBtn.MouseButton1Click:Connect(function()
            if grassPopupOpen then closeGrassPopup() else openGrassPopup() end
        end)
    end
    _grass()


    _G.SL_OpenTerrain  = function() if tPanelOpen then closeTPanel() else openTPanel() end end

    print("[RX Studio Lite] Terrain tools ready")
end

task.spawn(loadTerrainTools)
-- ===================== PART 3 of 4 : END (Terrain tools initialized) =====================
-- ===================== PART 4 of 4 : BEGIN (Explorer and Properties polish) =====================
pcall(function()
    local function fixExplorer()
        local exp = nil
        for _, obj in ipairs(StudioGui:GetDescendants()) do
            if obj.Name == "ExplorerPanel" or obj.Name == "Explorer" or obj.Name == "ExplorerWindow" then
                exp = obj
                break
            end
        end
        if not exp then return end

        exp.BackgroundColor3 = C.c0

        local function process(p)
            for _, ch in ipairs(p:GetChildren()) do
                pcall(function()
                    local name = ch.Name
                    if name:lower():find("add") or name:lower():find("create") or name:lower():find("plus") then
                        return
                    end
                    if ch:IsA("TextLabel") or ch:IsA("TextButton") or ch:IsA("TextBox") then
                        ch.TextColor3 = C.white
                        if ch.BackgroundTransparency < 0.95 then
                            ch.BackgroundColor3 = C.c1
                        end
                        ch:GetPropertyChangedSignal("TextColor3"):Connect(function()
                            if ch.TextColor3 ~= C.white then
                                ch.TextColor3 = C.white
                            end
                        end)
                    end
                    if ch:IsA("Frame") or ch:IsA("ScrollingFrame") then
                        if ch.BackgroundTransparency < 0.95 then
                            ch.BackgroundColor3 = C.c1
                        end
                        if ch:IsA("ScrollingFrame") then
                            ch.ScrollBarImageColor3 = C.border
                            ch.ScrollBarThickness = 4
                            ch.ScrollBarImageTransparency = 0.3
                        end
                    end
                    if ch:IsA("ImageLabel") or ch:IsA("ImageButton") then
                        if not ch.Name:find("SL_") then
                            pcall(function() ch.ImageColor3 = C.white end)
                        end
                    end
                    if ch:IsA("UIStroke") then
                        ch.Color = C.border
                    end
                    process(ch)
                end)
            end
        end

        process(exp)

        exp.ChildAdded:Connect(function(ch)
            task.wait(0.05)
            pcall(function() process(ch) end)
        end)

        print("[FIX] Explorer dark aman (tombol + tetap, scrollbar ada)")
    end

    task.spawn(function()
        for i = 1, 12 do
            task.wait(0.5)
            pcall(fixExplorer)
        end
    end)

    if StudioGui then
        StudioGui.ChildAdded:Connect(function(ch)
            if ch.Name == "ExplorerPanel" or ch.Name == "Explorer" or ch.Name == "ExplorerWindow" then
                task.wait(0.3)
                pcall(fixExplorer)
            end
        end)
    end
end)


pcall(function()
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    if not lp then return end

    local prop = nil
    local function cari()
        local pg = lp:FindFirstChild("PlayerGui")
        if not pg then return end
        local sg = pg:FindFirstChild("StudioGui")
        if not sg then return end
        for _, obj in ipairs(sg:GetDescendants()) do
            if obj.Name == "PropertiesPanel" or obj.Name == "Properties" or obj.Name == "PropertiesWindow" then
                prop = obj
                return
            end
        end
    end

    cari()

    local propScanAccumulator = 0
    RunService.Heartbeat:Connect(function(dt)
        propScanAccumulator = propScanAccumulator + dt
        if propScanAccumulator < 0.25 then return end
        propScanAccumulator = 0
        if not prop or not prop.Parent then
            cari()
            if not prop then return end
        end

        prop.BackgroundColor3 = C.c0

        for _, ch in ipairs(prop:GetDescendants()) do
            pcall(function()
                if ch:IsA("TextLabel") or ch:IsA("TextButton") or ch:IsA("TextBox") then
                    ch.TextColor3 = Color3.fromRGB(255, 255, 255)
                    if ch.BackgroundTransparency < 0.95 then
                        ch.BackgroundColor3 = C.c1
                    end
                end
                if ch:IsA("Frame") or ch:IsA("ScrollingFrame") then
                    if ch.BackgroundTransparency < 0.95 then
                        ch.BackgroundColor3 = C.c1
                    end
                    if ch:IsA("ScrollingFrame") then
                        ch.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
                        ch.ScrollBarThickness = 5
                        ch.ScrollBarImageTransparency = 0.1
                        ch.ElasticBehavior = Enum.ElasticBehavior.Never
                    end
                end
                if ch:IsA("ImageLabel") or ch:IsA("ImageButton") then
                    if not ch.Name:find("SL_") then
                        pcall(function() ch.ImageColor3 = C.white end)
                    end
                end
                if ch:IsA("UIStroke") then
                    ch.Color = C.border
                end
            end)
        end
    end)

    print("[PROPERTIES] ✓ Heartbeat scan - teks putih diperbarui berkala")
end)



pcall(function()
    local RunService = game:GetService("RunService")
    local explorer = nil
    -- [P7] weak-key table: avoids leaking destroyed Explorer rows
    local locked = setmetatable({}, {__mode = "k"})


    local function findExplorer()
        local sg = PlayerGui and PlayerGui:FindFirstChild("StudioGui")
        if not sg then return end
        for _, obj in ipairs(sg:GetDescendants()) do
            if obj:IsA("GuiObject") and (obj.Name == "ExplorerPanel" or obj.Name == "Explorer" or obj.Name == "ExplorerWindow") then
                explorer = obj
                return
            end
        end
    end

    findExplorer()


    local function lockHighlight(obj)
        if locked[obj] then return end
        pcall(function()
            local bg = obj.BackgroundColor3

            if bg and bg.B > 0.2 and bg.R < 0.5 and bg.G < 0.5 and obj.BackgroundTransparency < 0.95 then

                obj.BackgroundTransparency = 0.2
                locked[obj] = true

                obj:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
                    if obj.BackgroundTransparency ~= 0.2 then
                        obj.BackgroundTransparency = 0.2
                    end
                end)
            end
        end)
    end


    -- [P8] Explorer scan throttled to ~5 times/second; new descendants are handled by an event
    local scanAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        scanAcc = scanAcc + dt
        if scanAcc < 0.20 then return end
        scanAcc = 0
        if explorer then
            for _, obj in ipairs(explorer:GetDescendants()) do
                if obj:IsA("GuiObject") then
                    lockHighlight(obj)
                end
            end
        else
            findExplorer()
        end
    end)




    local sg = PlayerGui and PlayerGui:FindFirstChild("StudioGui")
    if sg then
        sg.DescendantAdded:Connect(function(obj)
            if obj:IsA("GuiObject") then
                if obj.Name == "ExplorerPanel" or obj.Name == "Explorer" or obj.Name == "ExplorerWindow" then
                    explorer = obj
                end
                task.wait(0.05)
                lockHighlight(obj)
            end
        end)
    end

    print("✓ EXPLORER HIGHLIGHT SOLID (WARNA BAWAAN, HANYA EXPLORER)")
end)
print(" PLUGINS EZY CRACKED ITSMEELANGZZ")

print("✓ STUDIO LITE BY EZY LOADED | by EZY |Cracked By ItsmeeLangzz ")
-- ===================== PART 4 of 4 : END (script) =====================
