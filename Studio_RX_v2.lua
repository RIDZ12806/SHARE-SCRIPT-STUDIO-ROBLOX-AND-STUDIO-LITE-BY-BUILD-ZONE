-- ===================== PART 1 of 5 : BEGIN (start of script) =====================
-- RX Studio Lite - Stage 1 upgrade: unified dark theme (cyan/blue accents),
-- minimum readable text size 9 for mobile, consistent corner radius. No features removed.
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
    c0      = Color3.fromRGB(22,23,25),
    c1      = Color3.fromRGB(30,31,34),
    c2      = Color3.fromRGB(38,40,43),
    c3      = Color3.fromRGB(50,52,56),
    border  = Color3.fromRGB(58,61,66),
    white   = Color3.fromRGB(245,245,245),
    expSel  = Color3.fromRGB(0,95,160),
    expSelB = Color3.fromRGB(0,140,215),
    playRed = Color3.fromRGB(220,55,55),
    accent  = Color3.fromRGB(0,190,255),   -- RX cyan (active)
    accent2 = Color3.fromRGB(0,140,215),   -- RX blue (selected)
    textDim = Color3.fromRGB(165,170,178), -- secondary text
    disabled= Color3.fromRGB(95,98,104),   -- disabled text
}

local function br(c) return (c.R+c.G+c.B)/3 end
local function isBlue(c) return c.B>0.30 and c.B>(c.R+0.10) and c.B>(c.G+0.10) end

local function isPlayObj(obj)
    local n = obj.Name:lower()
    return n=="play" or n=="playbtn" or n=="playbutton" or (n:sub(1,4)=="play" and #n<=10)
end

local function addRounded(obj)
    if not obj:FindFirstChildOfClass("UICorner") then
        local uc=Instance.new("UICorner"); uc.CornerRadius=UDim.new(0,6); uc.Parent=obj
    end
    local st=obj:FindFirstChildOfClass("UIStroke")
    if not st then st=Instance.new("UIStroke"); st.Parent=obj end
    st.Color=C.expSelB; st.Thickness=1
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
end

local function drawDot(parent, cx,cy, r, col, zi)
    local dot=Instance.new("Frame")
    dot.Name="SL_IconOverlay"
    dot.Size=UDim2.new(0,r*2,0,r*2)
    dot.Position=UDim2.new(0,cx-r,0,cy-r)
    dot.BackgroundColor3=col
    dot.BorderSizePixel=0
    dot.ZIndex=zi or 50
    dot.Parent=dot.Parent or parent
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
    local SIZE=26; local THICK=2
    local H=toolbar.AbsoluteSize.Y
    local padY=math.max(2,math.floor((H-SIZE-14)/2))
    local W=SIZE+14

    local cont=Instance.new("Frame")
    cont.Name="SL_CustomBtn_"..label
    cont.Size=UDim2.new(0,W,1,0)
    cont.Position=UDim2.new(0,offsetX,0,0)
    cont.BackgroundTransparency=1
    cont.ClipsDescendants=false
    cont.ZIndex=40
    cont.Parent=toolbar


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
    lbl.TextSize=9
    lbl.Font=Enum.Font.GothamBold
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


    btn.MouseEnter:Connect(function()
        pcall(function()
            btn.BackgroundTransparency=0.85
            btn.BackgroundColor3=C.white
            local st=btn:FindFirstChildOfClass("UIStroke")
            if not st then st=Instance.new("UIStroke"); st.Parent=btn end
            st.Color=Color3.fromRGB(255,255,255)
            st.Transparency=0.5
            st.Thickness=1
        end)
    end)
    btn.MouseLeave:Connect(function()
        pcall(function()
            btn.BackgroundTransparency=1
            local st=btn:FindFirstChildOfClass("UIStroke")
            if st then st:Destroy() end
        end)
    end)

    btn.MouseButton1Click:Connect(function()
        pcall(onClickFn)
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

    local SIZE=26; local THICK=2
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
        local W = SIZE + 14

        local cont = Instance.new("Frame")
        cont.Name = "SL_CustomBtn_"..label
        cont.Size = UDim2.new(0, W, 1, 0)
        cont.Position = UDim2.new(0, curX, 0, 0)
        cont.BackgroundTransparency = 1
        cont.ClipsDescendants = false
        cont.ZIndex = 200
        cont.Parent = toolbar


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
        lbl.TextSize = 9
        lbl.Font = Enum.Font.GothamBold
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


        btn.MouseEnter:Connect(function()
            pcall(function()
                btn.BackgroundTransparency = 0.85
                btn.BackgroundColor3 = C.white
                local st = btn:FindFirstChildOfClass("UIStroke")
                if not st then st = Instance.new("UIStroke"); st.Parent = btn end
                st.Color = Color3.fromRGB(255,255,255)
                st.Transparency = 0.5
                st.Thickness = 1
            end)
        end)
        btn.MouseLeave:Connect(function()
            pcall(function()
                btn.BackgroundTransparency = 1
                local st = btn:FindFirstChildOfClass("UIStroke")
                if st then st:Destroy() end
            end)
        end)


        local capturedType = partType
        btn.MouseButton1Click:Connect(function()
            pcall(function() triggerPartInsert(capturedType) end)
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
-- ===================== PART 1 of 5 : END (last line: end of injectTerrain) =====================
-- ===================== PART 2 of 5 : BEGIN (paste directly after Part 1) =====================
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
    print   = Color3.fromRGB(220, 220, 220),
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


        local prefix = { print="", warn="âڑ  ", error="âœ– ", info="â„¹ " }
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

            local prefix = { print="", warn="âڑ  ", error="âœ– ", info="â„¹ " }
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
        return math.floor(w * 0.72)
    end


    local panel = Instance.new("Frame")
    panel.Name = "SL_OutputPanel"
    local ow = getOutputWidth()
    -- [P6] responsive width (72% of StudioGui, same as the original calculation)
    panel.Size = UDim2.new(0.72, 0, 0, 180)

    panel.Position = UDim2.new(0, 0, 1, -185)
    panel.BackgroundColor3 = Color3.fromRGB(22,23,25)
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.ZIndex = 300
    panel.ClipsDescendants = true
    panel.Parent = StudioGui


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
    header.Size = UDim2.new(1, 0, 0, 26)
    header.Position = UDim2.new(0, 0, 0, 2)
    header.BackgroundColor3 = Color3.fromRGB(30,31,34)
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
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 306
    title.Parent = header


    local clearBtn = Instance.new("TextButton")
    clearBtn.Name = "SL_OutputBtn"
    clearBtn.Size = UDim2.new(0, 50, 0, 18)
    clearBtn.Position = UDim2.new(1, -110, 0, 4)
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
    closeBtn.Size = UDim2.new(0, 26, 0, 18)
    closeBtn.Position = UDim2.new(1, -30, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    closeBtn.BackgroundTransparency = 0
    closeBtn.Text = "âœ•"
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
    scroll.Size = UDim2.new(1, 0, 1, -30)
    scroll.Position = UDim2.new(0, 0, 0, 30)
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

    end

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
        local holeCol = bg and bg.BackgroundColor3 or Color3.fromRGB(30,31,34)
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

    local h1=Instance.new("Frame"); h1.BackgroundColor3=Color3.fromRGB(30,31,34); h1.BorderSizePixel=0
    h1.Size=UDim2.new(0,math.floor(4*s),0,math.floor(4*s))
    h1.Position=UDim2.new(0,math.floor(2.5*s),0,math.floor(6*s))
    h1.ZIndex=13; h1.Parent=parent
    local uhc1=Instance.new("UICorner"); uhc1.CornerRadius=UDim.new(1,0); uhc1.Parent=h1

    local r2=Instance.new("Frame"); r2.BackgroundColor3=col; r2.BorderSizePixel=0
    r2.Size=UDim2.new(0,math.floor(7*s),0,math.floor(7*s))
    r2.Position=UDim2.new(0,math.floor(8*s),0,math.floor(4.5*s))
    r2.ZIndex=12; r2.Parent=parent
    local uc2=Instance.new("UICorner"); uc2.CornerRadius=UDim.new(1,0); uc2.Parent=r2
    local h2=Instance.new("Frame"); h2.BackgroundColor3=Color3.fromRGB(30,31,34); h2.BorderSizePixel=0
    h2.Size=UDim2.new(0,math.floor(4*s),0,math.floor(4*s))
    h2.Position=UDim2.new(0,math.floor(9.5*s),0,math.floor(6*s))
    h2.ZIndex=13; h2.Parent=parent
    local uhc2=Instance.new("UICorner"); uhc2.CornerRadius=UDim.new(1,0); uhc2.Parent=h2

    px(math.floor(5*s),math.floor(6*s), math.floor(6*s),math.floor(4*s))

    local cov=Instance.new("Frame"); cov.BackgroundColor3=Color3.fromRGB(30,31,34); cov.BorderSizePixel=0
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

    local notch=Instance.new("Frame"); notch.BackgroundColor3=Color3.fromRGB(30,31,34); notch.BorderSizePixel=0
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
    local ICON_SIZE = 28
    local BTN_W    = 56
    local BTN_H    = btnH or 52

    local cont = Instance.new("Frame")
    cont.Name = "SL_PluginBtn"
    cont.Size = UDim2.new(0, BTN_W, 0, BTN_H)
    cont.Position = UDim2.new(0, xOffset, 0.5, -BTN_H/2)
    cont.BackgroundColor3 = Color3.fromRGB(45,45,46)
    cont.BackgroundTransparency = 1
    cont.BorderSizePixel = 0
    cont.ZIndex = 302
    cont.Parent = parent

    local uc = Instance.new("UICorner"); uc.CornerRadius=UDim.new(0,4); uc.Parent=cont


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
    indicator.BackgroundColor3 = Color3.fromRGB(0,140,215)
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
            cont.BackgroundTransparency = 0.5
        end
    end)
    clickBtn.MouseLeave:Connect(function()
        if not active then
            cont.BackgroundTransparency = 1
        end
    end)
    clickBtn.MouseButton1Click:Connect(function()
        active = not active
        cont.BackgroundColor3 = active and Color3.fromRGB(0,140,215) or Color3.fromRGB(45,45,46)
        cont.BackgroundTransparency = active and 0.3 or 1
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
    frame.BackgroundColor3 = Color3.fromRGB(30,31,34)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = 300
    frame.Parent = StudioGui


    local borderB = Instance.new("Frame")
    borderB.Name = "SL_PluginRibbon"
    borderB.Size = UDim2.new(1,0,0,1)
    borderB.Position = UDim2.new(0,0,1,-1)
    borderB.BackgroundColor3 = Color3.fromRGB(0,140,215)
    borderB.BorderSizePixel=0; borderB.ZIndex=301; borderB.Parent=frame


    local tabLbl = Instance.new("TextLabel")
    tabLbl.Name = "SL_PluginRibbon"
    tabLbl.Size = UDim2.new(0,60,1,0)
    tabLbl.Position = UDim2.new(0,8,0,0)
    tabLbl.BackgroundTransparency=1
    tabLbl.Text = "PLUGINS"
    tabLbl.TextColor3 = Color3.fromRGB(0,140,215)
    tabLbl.TextSize = 10
    tabLbl.Font = Enum.Font.GothamBold
    tabLbl.ZIndex = 302
    tabLbl.Parent = frame


    local sep = Instance.new("Frame")
    sep.Name="SL_PluginRibbon"; sep.Size=UDim2.new(0,1,0,tbSz.Y-16)
    sep.Position=UDim2.new(0,68,0,8)
    sep.BackgroundColor3=Color3.fromRGB(58,61,66)
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
                            pluginMenuBtn.BackgroundColor3 = Color3.fromRGB(0,140,215)
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
            and Color3.fromRGB(0,140,215) or C.c1
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

    print("[STUDIO LITE BY EZY] âœ… Done!")
end)
-- ===================== PART 2 of 5 : END (last line: end of the init task.spawn block) =====================
-- ===================== PART 3 of 5 : BEGIN (paste directly after Part 2) =====================
local function loadMusicPlayer()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    if PlayerGui:FindFirstChild("MusicPlayerGUI") then
        PlayerGui:FindFirstChild("MusicPlayerGUI"):Destroy()
    end

    local cam = workspace.CurrentCamera
    local screenSize = cam.ViewportSize
    local refShort = math.min(screenSize.X, screenSize.Y)
    local scale = math.max(0.7, math.min(refShort / 390, 2.5))
    local function s(n) return math.round(n * scale) end

    local T = {
        bg      = Color3.fromRGB(12,12,20),
        panel   = Color3.fromRGB(22,22,35),
        card    = Color3.fromRGB(32,32,48),
        border  = Color3.fromRGB(50,50,75),
        accent  = Color3.fromRGB(0,150,230),
        green   = Color3.fromRGB(34,197,94),
        greenDk = Color3.fromRGB(20,140,60),
        red     = Color3.fromRGB(220,60,60),
        yellow  = Color3.fromRGB(220,180,30),
        white   = Color3.fromRGB(255,255,255),
        text    = Color3.fromRGB(240,240,250),
        sub     = Color3.fromRGB(130,130,170),
        dim     = Color3.fromRGB(62,66,72),
        console = Color3.fromRGB(8,12,8),
        ctext   = Color3.fromRGB(34,220,100),
    }

    local function create(className, props)
        local inst = Instance.new(className)
        for k, v in pairs(props) do inst[k] = v end
        return inst
    end

    local function corner(obj, r)
        local c = Instance.new("UICorner", obj)
        c.CornerRadius = UDim.new(0, r or s(8))
        return c
    end

    local function stroke(obj, col, thick)
        local st = Instance.new("UIStroke", obj)
        st.Color = col or T.border
        st.Thickness = thick or 1
        return st
    end

    local function gradient(obj, colors, rotation)
        local g = Instance.new("UIGradient", obj)
        local keys = {}
        for i, c in ipairs(colors) do
            keys[i] = ColorSequenceKeypoint.new((i-1)/(#colors-1), c)
        end
        g.Color = ColorSequence.new(keys)
        g.Rotation = rotation or 0
        return g
    end

    local function mkLabel(parent, text, y, h, size, col, align)
        local l = Instance.new("TextLabel", parent)
        l.Text = text
        l.Size = UDim2.new(1, 0, 0, h or s(14))
        l.Position = UDim2.new(0, 0, 0, y or 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = col or T.sub
        l.TextSize = size or s(10)
        l.Font = Enum.Font.GothamBold
        l.TextXAlignment = align or Enum.TextXAlignment.Left
        return l
    end

    local function makeDraggable(frame, handle)
        handle = handle or frame
        local dragging, dragInput, dragStart, startPos
        handle.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = inp.Position
                startPos = frame.Position
                inp.Changed:Connect(function()
                    if inp.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        handle.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                dragInput = inp
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if dragging and inp == dragInput then
                local d = inp.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end
        end)
    end

    local ScreenGui = create("ScreenGui", {
        Name = "MusicPlayerGUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui
    })

    local guiInset = game:GetService("GuiService"):GetGuiInset()
    local TOP_OFFSET = guiInset.Y


    local ToggleMusic = create("TextButton", {
        Size = UDim2.new(0, s(42), 0, s(42)),
        Position = UDim2.new(0, s(8), 0, TOP_OFFSET + s(6)),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        Text = "ًںژµ",
        TextSize = s(18),
        TextColor3 = Color3.fromRGB(0,190,255),
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 20,
        Parent = ScreenGui
    })
    corner(ToggleMusic, s(10))
    local strokeMusic = stroke(ToggleMusic, Color3.fromRGB(0,190,255), 2)

    local panelX = s(58)
    local panelW = math.min(s(350), screenSize.X - panelX - s(10))
    local panelH = math.min(s(460), screenSize.Y - TOP_OFFSET - s(20))
    local panelY = TOP_OFFSET + s(6)


    local PanelMusic = create("Frame", {
        Size = UDim2.new(0, panelW, 0, panelH),
        Position = UDim2.new(0, panelX, 0, panelY),
        BackgroundColor3 = T.panel,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
        Parent = ScreenGui
    })
    corner(PanelMusic, s(12))
    stroke(PanelMusic, T.border, 1)
    local TitleMusic = create("Frame", {Size = UDim2.new(1,0,0,s(32)), BackgroundColor3 = Color3.fromRGB(28,30,33), BorderSizePixel = 0, ZIndex = 11, Parent = PanelMusic})
    corner(TitleMusic, s(12))
    create("Frame", {Size = UDim2.new(1,0,0,s(14)), Position = UDim2.new(0,0,1,-s(14)), BackgroundColor3 = Color3.fromRGB(28,30,33), BorderSizePixel = 0, Parent = TitleMusic})
    create("TextLabel", {Size = UDim2.new(1,-s(16),1,0), Position = UDim2.new(0,s(10),0,0), BackgroundTransparency = 1, Text = "ًںژµ Music Player", TextColor3 = T.white, TextSize = s(12), Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = TitleMusic})
    makeDraggable(PanelMusic, TitleMusic)


    local ResizeMusic = create("TextButton", {Size = UDim2.new(0,s(18),0,s(18)), Position = UDim2.new(1,-s(18),1,-s(18)), BackgroundColor3 = T.dim, Text = "â¤،", TextColor3 = T.sub, TextSize = s(9), Font = Enum.Font.GothamBold, BorderSizePixel = 0, ZIndex = 20, Parent = PanelMusic})
    corner(ResizeMusic, s(4))

    local ScrollMusic = create("ScrollingFrame", {Size = UDim2.new(1,0,1,-s(32)), Position = UDim2.new(0,0,0,s(32)), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = s(2), ScrollBarImageColor3 = T.dim, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = PanelMusic})
    local containerMusic = create("Frame", {Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Parent = ScrollMusic})
    local layoutMusic = create("UIListLayout", {Padding = UDim.new(0,s(6)), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = containerMusic})
    create("UIPadding", {PaddingTop = UDim.new(0,s(6)), PaddingBottom = UDim.new(0,s(6)), PaddingLeft = UDim.new(0,s(8)), PaddingRight = UDim.new(0,s(8)), Parent = containerMusic})
    layoutMusic:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollMusic.CanvasSize = UDim2.new(0,0,0, layoutMusic.AbsoluteContentSize.Y + s(16))
        containerMusic.Size = UDim2.new(1,0,0, layoutMusic.AbsoluteContentSize.Y + s(16))
    end)

    local function setupResize(handle, panel)
        local resizing = false
        local startMouse, startSize
        handle.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                startMouse = inp.Position
                startSize = Vector2.new(panel.Size.X.Offset, panel.Size.Y.Offset)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if resizing and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local delta = inp.Position - startMouse
                local newW = math.clamp(startSize.X + delta.X, s(250), screenSize.X - panelX - s(10))
                local newH = math.clamp(startSize.Y + delta.Y, s(200), screenSize.Y - TOP_OFFSET - s(20))
                panel.Size = UDim2.new(0, newW, 0, newH)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                resizing = false
            end
        end)
    end
    setupResize(ResizeMusic, PanelMusic)

    local musicOpen = false
    ToggleMusic.MouseButton1Click:Connect(function()
        musicOpen = not musicOpen
        PanelMusic.Visible = musicOpen
        strokeMusic.Color = musicOpen and Color3.fromRGB(160,170,255) or Color3.fromRGB(0,190,255)
        strokeMusic.Thickness = musicOpen and 3 or 2
    end)


    local musicDatabase = {
        {name = "DJ Stay Kane", artist = "DJ Remix", id = 137657207613132},
        {name = "Sesi Potret", artist = "Sad", id = 121385807951625},
        {name = "Ego Wong Tuo", artist = "Sad", id = 129040190071578},
        {name = "Ropang", artist = "DJ Remix", id = 72522945629185},
        {name = "Ketaton Cerita", artist = "DJ", id = 115246961145260},
        {name = "Negoro Angin", artist = "Remix", id = 120505902797654},
        {name = "DJ Bintang 5", artist = "DJ Remix", id = 134435445558993},
        {name = "DJ JJ World", artist = "DJ Remix", id = 90145710334449},
        {name = "DJ Tor Monitor", artist = "DJ Remix", id = 70633665224310},
        {name = "DJ Party", artist = "DJ Remix", id = 118390472006859},
        {name = "Aku Suka Jedag Jedug", artist = "DJ Remix", id = 100787734732008},
        {name = "Jamilah Itu Bukan Anunya", artist = "DJ Remix", id = 116255319981650},
        {name = "DJ Raja Mexico", artist = "DJ Remix", id = 101608805472261},
        {name = "DJ Ee Ee Kenceng", artist = "DJ Remix", id = 101419525809543},
        {name = "Remix Tung Tung", artist = "DJ Remix", id = 70860648654984},
        {name = "Funkot Stecu Stecu", artist = "Funkot", id = 105935548669522},
        {name = "Nana Memissu", artist = "Funkot", id = 136842585273816},
        {name = "DJ Bahagiamu", artist = "DJ Remix", id = 110691393637838},
        {name = "Dustep Dame Un Grr", artist = "Dustep", id = 101362929989754},
        {name = "Joget Lalala", artist = "Joget", id = 79073283903510},
        {name = "Pargoy Gerah", artist = "Pargoy", id = 78859797813378},
        {name = "DJ Suka Suka", artist = "DJ Remix", id = 91089804280618},
        {name = "DJ Yami Yami", artist = "DJ Remix", id = 84570363516667},
        {name = "DJ Jangan Calling", artist = "DJ Remix", id = 101244701122281},
        {name = "DJ Baby Don't Go", artist = "DJ Remix", id = 135407156540365},
        {name = "Dugem Always Loving", artist = "Dugem", id = 138240226435856},
        {name = "Dugem Miracles", artist = "Dugem", id = 70436344944799},
        {name = "Dugem We Wanna", artist = "Dugem", id = 130712039189796},
        {name = "Dugem Brand New Day", artist = "Dugem", id = 116323172827525},
        {name = "Dugem Arabic v1", artist = "Dugem", id = 139871657187137},
        {name = "Dugem Rumble", artist = "Dugem", id = 110173941862827},
        {name = "Dugem New Heart", artist = "Dugem", id = 96966974660960},
        {name = "Dugem Miksue", artist = "Dugem", id = 112753938971674},
        {name = "Dugem Tarik Napas", artist = "Dugem", id = 127203386942116},
        {name = "Dugem Gaji Tipis", artist = "Dugem", id = 129177050015198},
        {name = "Dugem Janji Koplo", artist = "Koplo", id = 107302164689882},
        {name = "Koplo Persatuan", artist = "Koplo", id = 87585997282125},
        {name = "Dangdut Oh Dangdut", artist = "Dangdut", id = 126628849431036},
        {name = "KADA Koplo", artist = "Koplo", id = 77588662168259},
        {name = "Koplo Remix Tusi Toi", artist = "Koplo", id = 74683957361284},
        {name = "DJ Remix Malam Minggu", artist = "Dangdut", id = 134461125875140},
        {name = "Melayu Segara", artist = "Melayu", id = 77922858212710},
        {name = "Remix Aku Suka Kamu", artist = "Remix", id = 84324476801159},
        {name = "Remix Slowly Fades", artist = "Remix", id = 82190007220024},
        {name = "Remix Grow Up", artist = "Remix", id = 113248280551100},
        {name = "Remix Indomie Seleraku", artist = "Remix", id = 104999170809147},
        {name = "Pop Sad Terakhir Kali", artist = "Pop Sad", id = 90136528978860},
        {name = "Pop Sad Hujan", artist = "Pop Sad", id = 86469198575504},
        {name = "Pop Sad Malam", artist = "Pop Sad", id = 111879260290951},
        {name = "Pop Sad Nada", artist = "Pop Sad", id = 136095989985074},
        {name = "Remix Tulisan Terakhir", artist = "Remix", id = 116861766856253},
        {name = "Pop Sad Mentari Pagi", artist = "Pop Sad", id = 107198551105205},
        {name = "Pop Sad Sebuah Lagu", artist = "Pop Sad", id = 86058413291033},
        {name = "Pop Sad Bisikan Angin", artist = "Pop Sad", id = 75156127215458},
        {name = "Pop Sad Janji Bintang", artist = "Pop Sad", id = 111862546703577},
        {name = "Pop Sad Hujan Cinta", artist = "Pop Sad", id = 81211527812792},
        {name = "Pop Sad Pelukan Hangat", artist = "Pop Sad", id = 115131247077030},
        {name = "Pop Sad Matamu Berbicara", artist = "Pop Sad", id = 81973481116917},
        {name = "Pop Sad Rumah Hati", artist = "Pop Sad", id = 83250836631471},
        {name = "Pop Sad Cahaya Hati", artist = "Pop Sad", id = 134972205706867},
        {name = "Pop Sad Janji Hati", artist = "Pop Sad", id = 83235710267654},
        {name = "Pop Sad Bangkit", artist = "Pop Sad", id = 135825408597541},
        {name = "Pop Sad Jatuh Cinta Lagi", artist = "Pop Sad", id = 89836791839135},
        {name = "Pop Sad Hati Yang Sama", artist = "Pop Sad", id = 87326774693324},
        {name = "Pop Semua Bisa", artist = "Pop", id = 125120061503990},
        {name = "Pop Sad Janji Selalu", artist = "Pop Sad", id = 102243069137065},
        {name = "Pop Kasih Ibu", artist = "Pop", id = 125808212598994},
        {name = "Pop Hanya Dirimu", artist = "Pop", id = 104791543659700},
        {name = "Pop Cinta Ini", artist = "Pop", id = 123540764745648},
        {name = "Pop Coffe", artist = "Pop", id = 135403121041184},
        {name = "Pop Senyap", artist = "Pop", id = 134080487231612},
        {name = "Pop Sad Kekasih Ku", artist = "Pop Sad", id = 92379564604718},
        {name = "Pop Sad Cinta Disurga", artist = "Pop Sad", id = 117404600281388},
        {name = "Pop Sad Naungan Cinta", artist = "Pop Sad", id = 92867250191660},
        {name = "Pop Hanya Diriku", artist = "Pop", id = 111642341850105},
        {name = "Pop Selalu Disisi", artist = "Pop", id = 140521260325790},
        {name = "Pop Terbang Bersamamu", artist = "Pop", id = 118057288321617},
        {name = "Pop Sad Percaya Diri", artist = "Pop Sad", id = 92547183733961},
        {name = "Pop Sad Cinta Sejati", artist = "Pop Sad", id = 98598403587682},
        {name = "Pop Bisa Lebih Baik", artist = "Pop", id = 121674280117395},
        {name = "Pop Rahasia Cinta", artist = "Pop", id = 111396932287659},
        {name = "Pop Sepenuh Cinta", artist = "Pop", id = 112132081577489},
        {name = "Pop Cosmic Heart", artist = "Pop", id = 89976281188173},
        {name = "Pop Sad Setiap Titik", artist = "Pop Sad", id = 78172976850121},
        {name = "Pop Sad Jarak Dan Waktu", artist = "Pop Sad", id = 76206714905360},
        {name = "Pop Sad Peluk Aku", artist = "Pop Sad", id = 103448049104154},
        {name = "Pop Counting Stars", artist = "Pop", id = 105289452043939},
        {name = "Pop Sad Kau Adalah Takdir", artist = "Pop Sad", id = 116869902280767},
        {name = "Pop Sad Harmoni", artist = "Pop Sad", id = 113726934561484},
        {name = "Pop Sad Berdiri Teguh", artist = "Pop Sad", id = 78269829173371},
        {name = "Pop Sad Diam Diam Cinta", artist = "Pop Sad", id = 101684839547561},
        {name = "Pop Cantik Pertama", artist = "Pop", id = 114474350535772},
        {name = "Pop Sad Dekatmu", artist = "Pop Sad", id = 103447236688741},
        {name = "Pop Sad Langkah Kecil", artist = "Pop Sad", id = 98248851822793},
        {name = "Pop Punk Cinta Palsu", artist = "Pop Punk", id = 136529849093600},
        {name = "Pop Sad Tentang Kita", artist = "Pop Sad", id = 78991697338288},
        {name = "Pop The Lost Key", artist = "Pop", id = 77953938546935},
        {name = "Pop Sad Harus Bangkit", artist = "Pop Sad", id = 117102086902489},
        {name = "Pop Cahaya Dalam Gelap", artist = "Pop", id = 95017594064574},
        {name = "Pop Sad Ingin Kembali", artist = "Pop Sad", id = 138694582441714},
        {name = "Pop Sad Luka Lama", artist = "Pop Sad", id = 135528938875440},
        {name = "Pop Ayah Ibu", artist = "Pop", id = 74624575098018},
        {name = "Pop Pahlawan", artist = "Pop", id = 107483499219016},
        {name = "Pop Sad Berharap", artist = "Pop Sad", id = 122432336651563},
        {name = "Pop Sad Tempat Pulang", artist = "Pop Sad", id = 125654265518740},
        {name = "Pop Cinta Kedua", artist = "Pop", id = 106830694449649},
        {name = "DJ Kamnh Velocity", artist = "DJ Remix", id = 130721206402716},
        {name = "DJ Tantaeeee", artist = "DJ Remix", id = 116647235474599},
        {name = "DJ ABG Tua", artist = "DJ Remix", id = 139825186779265},
        {name = "DJ Ade Su Nika", artist = "DJ Remix", id = 132497938577328},
        {name = "DJ Sayang Culik Aku Dong", artist = "DJ Remix", id = 119254319180287},
        {name = "Dugem Mancing Mania", artist = "Dugem", id = 129477546529041},
        {name = "Dugem Sigma Boy", artist = "Dugem", id = 109420952262721},
        {name = "DJ Rasa Yang Tertinggal", artist = "DJ Remix", id = 91195881581393},
        {name = "DJ Remix Bagaikan Langit", artist = "DJ Remix", id = 115658981016860},
        {name = "DJ Jangan Pernah Berubah", artist = "DJ Remix", id = 126398962163813},
        {name = "DJ Orang Yang Salah", artist = "DJ Remix", id = 77545154026611},
        {name = "DJ Aku Tetap Cinta", artist = "DJ Remix", id = 138399521757966},
        {name = "Baon Cikadap Versi Lite", artist = "Tradisional", id = 4004629054},
        {name = "DJ Aku Mohon", artist = "DJ Remix", id = 93671745663611},
        {name = "DJ Demi Aku", artist = "DJ Remix", id = 132867463657917},
        {name = "Gamelan Sunda Hajatan", artist = "Tradisional", id = 1845919739},
        {name = "Dugem Arak Bali", artist = "Dugem", id = 103444531930539},
        {name = "Dugem Buruh Tani", artist = "Dugem", id = 104928443006967},
        {name = "Dugem Ajeb Ajeb", artist = "Dugem", id = 72730594342556},
        {name = "Dugem Nol Kilometer", artist = "Dugem", id = 130241449478422},
        {name = "Dugem Wong Galo", artist = "Dugem", id = 94330041376891},
        {name = "Dugem Ular Tangga", artist = "Dugem", id = 99670528571562},
        {name = "Dugem Lampung Pride", artist = "Dugem", id = 92989585645255},
        {name = "Dugem Cak Cak", artist = "Dugem", id = 79661167680535},
        {name = "Dugem Terbang Angkasa", artist = "Dugem", id = 124645116118100},
        {name = "DJ Kugadaikan Cintaku", artist = "DJ Remix", id = 134090638788064},
        {name = "Dugem Picek Matamu", artist = "Dugem", id = 105551572195724},
        {name = "Dugem Kuda", artist = "Dugem", id = 120446796681370},
        {name = "DJ Bukit Berbunga", artist = "DJ Remix", id = 70965504859488},
    }


    local eqContainer = create("Frame", {Size = UDim2.new(1,0,0,s(70)), BackgroundColor3 = Color3.fromRGB(15,15,25), BorderSizePixel = 0, Parent = containerMusic})
    corner(eqContainer, s(8)); stroke(eqContainer, T.border, 1)
    local barsContainer = create("Frame", {Size = UDim2.new(1,-s(14),1,-s(14)), Position = UDim2.new(0,s(7),0,s(7)), BackgroundTransparency = 1, ClipsDescendants = true, Parent = eqContainer})
    local barLayout = create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0,s(2)), Parent = barsContainer})
    local bars = {}
    for i = 1, 16 do
        local bar = create("Frame", {Size = UDim2.new(0,s(8),0,s(6)), BackgroundColor3 = T.accent, BorderSizePixel = 0, Parent = barsContainer})
        corner(bar, s(2))
        gradient(bar, {
            Color3.fromRGB(255,80,80),
            Color3.fromRGB(255,200,80),
            Color3.fromRGB(80,255,120)
        }, -90)
        bars[i] = bar
    end


    local npFrame = create("Frame", {Size = UDim2.new(1,0,0,s(44)), BackgroundColor3 = T.card, BorderSizePixel = 0, Parent = containerMusic})
    corner(npFrame, s(8)); stroke(npFrame, T.border, 1)
    local albumArt = create("Frame", {Size = UDim2.new(0,s(32),0,s(32)), Position = UDim2.new(0,s(8),0.5,-s(16)), BackgroundColor3 = T.accent, BorderSizePixel = 0, Parent = npFrame})
    corner(albumArt, s(6))
    local albumIcon = create("TextLabel", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "ًںژµ", TextSize = s(16), Parent = albumArt})
    local songNameLabel = create("TextLabel", {Size = UDim2.new(1,-s(50),0,s(16)), Position = UDim2.new(0,s(46),0,s(6)), BackgroundTransparency = 1, Text = "No song playing", TextColor3 = T.white, TextSize = s(11), Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = npFrame})
    local artistLabel = create("TextLabel", {Size = UDim2.new(1,-s(50),0,s(14)), Position = UDim2.new(0,s(46),0,s(24)), BackgroundTransparency = 1, Text = "Select a song", TextColor3 = T.sub, TextSize = s(9), Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = npFrame})
    local loadingLabel = create("TextLabel", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "âڈ³ Loading...", TextColor3 = T.yellow, TextSize = s(12), Font = Enum.Font.GothamBold, Visible = false, Parent = npFrame})


    local ctrlFrame = create("Frame", {Size = UDim2.new(1,0,0,s(32)), BackgroundTransparency = 1, Parent = containerMusic})
    local ctrlLayout = create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0,s(6)), Parent = ctrlFrame})
    local controlBtns = {}
    for _, bd in ipairs({{name="Previous",icon="âڈ®ï¸ڈ",size=32},{name="PlayPause",icon="â–¶ï¸ڈ",size=38},{name="Stop",icon="âڈ¹ï¸ڈ",size=32},{name="Next",icon="âڈ­ï¸ڈ",size=32}}) do
        local btn = create("TextButton", {Size = UDim2.new(0,s(bd.size),0,s(28)), BackgroundColor3 = Color3.fromRGB(55,58,63), Text = bd.icon, TextSize = bd.size == 38 and s(18) or s(14), Font = Enum.Font.GothamBold, TextColor3 = T.white, Parent = ctrlFrame})
        corner(btn, s(8))
        controlBtns[bd.name] = btn
    end


    local playlistFrame = create("ScrollingFrame", {Size = UDim2.new(1,0,0,s(140)), BackgroundColor3 = Color3.fromRGB(16,17,19), BorderSizePixel = 0, ScrollBarThickness = s(2), ScrollBarImageColor3 = T.dim, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = containerMusic})
    corner(playlistFrame, s(8)); stroke(playlistFrame, T.border, 1)
    local playLayout = create("UIListLayout", {Padding = UDim.new(0,s(4)), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = playlistFrame})
    create("UIPadding", {PaddingTop = UDim.new(0,s(4)), PaddingBottom = UDim.new(0,s(4)), PaddingLeft = UDim.new(0,s(4)), PaddingRight = UDim.new(0,s(4)), Parent = playlistFrame})


    local vsFrame = create("Frame", {Size = UDim2.new(1,0,0,s(80)), BackgroundTransparency = 1, Parent = containerMusic})
    local vsLayout = create("UIListLayout", {Padding = UDim.new(0,s(4)), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = vsFrame})
    local volRow = create("Frame", {Size = UDim2.new(1,0,0,s(32)), BackgroundTransparency = 1, Parent = vsFrame})
    create("TextLabel", {Size = UDim2.new(0,s(30),1,0), BackgroundTransparency = 1, Text = "ًں”ٹ", TextSize = s(14), Parent = volRow})
    local volSliderBg = create("Frame", {Size = UDim2.new(1,-s(70),1,-s(8)), Position = UDim2.new(0,s(34),0,s(4)), BackgroundColor3 = Color3.fromRGB(46,48,53), BorderSizePixel = 0, Parent = volRow})
    corner(volSliderBg, s(4))
    local volFill = create("Frame", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(80,255,170), BorderSizePixel = 0, Parent = volSliderBg})
    corner(volFill, s(4))
    local volSliderBtn = create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = volRow})
    local volVal = create("TextLabel", {Size = UDim2.new(0,s(32),1,0), Position = UDim2.new(1,-s(32),0,0), BackgroundTransparency = 1, Text = "100%", TextColor3 = Color3.fromRGB(80,255,170), TextSize = s(9), Font = Enum.Font.GothamBold, Parent = volRow})
    local speedRow = create("Frame", {Size = UDim2.new(1,0,0,s(32)), BackgroundTransparency = 1, Parent = vsFrame})
    create("TextLabel", {Size = UDim2.new(0,s(30),1,0), BackgroundTransparency = 1, Text = "âڑ،", TextSize = s(14), Parent = speedRow})
    local speedSliderBg = create("Frame", {Size = UDim2.new(1,-s(70),1,-s(8)), Position = UDim2.new(0,s(34),0,s(4)), BackgroundColor3 = Color3.fromRGB(46,48,53), BorderSizePixel = 0, Parent = speedRow})
    corner(speedSliderBg, s(4))
    local speedFill = create("Frame", {Size = UDim2.new(0.43,0,1,0), BackgroundColor3 = Color3.fromRGB(255,200,80), BorderSizePixel = 0, Parent = speedSliderBg})
    corner(speedFill, s(4))
    local speedSliderBtn = create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = speedRow})
    local speedVal = create("TextLabel", {Size = UDim2.new(0,s(32),1,0), Position = UDim2.new(1,-s(32),0,0), BackgroundTransparency = 1, Text = "1.00x", TextColor3 = Color3.fromRGB(255,200,80), TextSize = s(9), Font = Enum.Font.GothamBold, Parent = speedRow})

    -- [P3] state variables declared BEFORE createSongButton so the button closures capture them
    local currentSongIndex, currentVolume, currentSpeed, isMuted, isLoading = 0, 1, 1, false, false
    local sound = create("Sound", {Name = "MusicSound", Volume = 1, Parent = PanelMusic})
    local songButtons = {}
    local function createSongButton(songData, index)
        local btn = create("TextButton", {Size = UDim2.new(1,0,0,s(34)), BackgroundColor3 = Color3.fromRGB(38,40,44), Text = "", AutoButtonColor = false, Parent = playlistFrame})
        corner(btn, s(6))
        create("TextLabel", {Size = UDim2.new(0,s(20),1,0), Position = UDim2.new(0,s(4),0,0), BackgroundTransparency = 1, Text = tostring(index), TextColor3 = T.dim, TextSize = s(8), Font = Enum.Font.GothamBold, Parent = btn})
        create("TextLabel", {Size = UDim2.new(1,-s(40),0,s(14)), Position = UDim2.new(0,s(26),0,s(4)), BackgroundTransparency = 1, Text = songData.name, TextColor3 = T.white, TextSize = s(9), Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = btn})
        create("TextLabel", {Size = UDim2.new(1,-s(40),0,s(12)), Position = UDim2.new(0,s(26),0,s(19)), BackgroundTransparency = 1, Text = songData.artist, TextColor3 = T.sub, TextSize = s(7), Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = btn})
        local playingInd = create("TextLabel", {Name = "Playing", Size = UDim2.new(0,s(14),1,0), Position = UDim2.new(1,-s(18),0,0), BackgroundTransparency = 1, Text = "â–¶ï¸ڈ", TextSize = s(8), Visible = false, Parent = btn})
        btn.MouseEnter:Connect(function() if currentSongIndex ~= index then TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55,58,63)}):Play() end end)
        btn.MouseLeave:Connect(function() if currentSongIndex ~= index then TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(38,40,44)}):Play() end end)
        btn.MouseButton1Click:Connect(function() if not isLoading then playSong(index) end end)
        return btn
    end
    for i, song in ipairs(musicDatabase) do
        songButtons[i] = createSongButton(song, i)
    end

    function playSong(index)
        if index < 1 or index > #musicDatabase or isLoading then return end
        isLoading = true
        loadingLabel.Visible = true
        songNameLabel.Visible = false
        artistLabel.Visible = false
        albumIcon.Text = "âڈ³"
        if currentSongIndex > 0 and songButtons[currentSongIndex] then
            TweenService:Create(songButtons[currentSongIndex], TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(38,40,44)}):Play()
            local prev = songButtons[currentSongIndex]:FindFirstChild("Playing")
            if prev then prev.Visible = false end
        end
        currentSongIndex = index
        local songData = musicDatabase[index]
        TweenService:Create(songButtons[index], TweenInfo.new(0.15), {BackgroundColor3 = T.accent}):Play()
        local ind = songButtons[index]:FindFirstChild("Playing")
        if ind then ind.Visible = true end
        sound:Stop()
        sound.SoundId = ""
        task.wait(0.05)
        sound.SoundId = "rbxassetid://" .. songData.id
        sound.Volume = isMuted and 0 or currentVolume
        sound.PlaybackSpeed = currentSpeed
        sound.Looped = false
        task.spawn(function()
            local start = tick()
            while not sound.IsLoaded and (tick() - start) < 10 do task.wait(0.1) end
            if currentSongIndex == index then
                isLoading = false
                loadingLabel.Visible = false
                songNameLabel.Visible = true
                artistLabel.Visible = true
                songNameLabel.Text = songData.name
                artistLabel.Text = songData.artist
                albumIcon.Text = "ًںژµ"
                TweenService:Create(albumArt, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Rotation = 360, BackgroundColor3 = T.accent}):Play()
                task.delay(0.3, function() albumArt.Rotation = 0 end)
                if sound.IsLoaded then
                    sound:Play()
                    controlBtns.PlayPause.Text = "âڈ¸ï¸ڈ"
                else
                    songNameLabel.Text = "Failed to load"
                    artistLabel.Text = "Try another song"
                    albumIcon.Text = "â‌Œ"
                end
            end
        end)
    end

    function stopSong()
        sound:Stop()
        if currentSongIndex > 0 and songButtons[currentSongIndex] then
            TweenService:Create(songButtons[currentSongIndex], TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(38,40,44)}):Play()
            local ind = songButtons[currentSongIndex]:FindFirstChild("Playing")
            if ind then ind.Visible = false end
        end
        currentSongIndex = 0
        isLoading = false
        loadingLabel.Visible = false
        songNameLabel.Visible = true
        artistLabel.Visible = true
        songNameLabel.Text = "No song playing"
        artistLabel.Text = "Select a song"
        albumIcon.Text = "ًںژµ"
        controlBtns.PlayPause.Text = "â–¶ï¸ڈ"
    end

    function togglePlayPause()
        if isLoading then return end
        if sound.IsPlaying then
            sound:Pause()
            controlBtns.PlayPause.Text = "â–¶ï¸ڈ"
        elseif currentSongIndex > 0 and sound.IsLoaded then
            sound:Resume()
            controlBtns.PlayPause.Text = "âڈ¸ï¸ڈ"
        elseif #musicDatabase > 0 then
            playSong(1)
        end
    end

    function nextSong()
        if isLoading then return end
        local next = currentSongIndex + 1
        if next > #musicDatabase then next = 1 end
        playSong(next)
    end

    function previousSong()
        if isLoading then return end
        local prev = currentSongIndex - 1
        if prev < 1 then prev = #musicDatabase end
        playSong(prev)
    end

    controlBtns.PlayPause.MouseButton1Click:Connect(togglePlayPause)
    controlBtns.Stop.MouseButton1Click:Connect(stopSong)
    controlBtns.Next.MouseButton1Click:Connect(nextSong)
    controlBtns.Previous.MouseButton1Click:Connect(previousSong)

    sound.Ended:Connect(function()
        if currentSongIndex > 0 and not isLoading then
            task.wait(0.3)
            nextSong()
        end
    end)

    local function setVolume(vol)
        currentVolume = math.clamp(vol, 0, 1)
        if not isMuted then sound.Volume = currentVolume end
        volVal.Text = math.floor(currentVolume * 100) .. "%"
        TweenService:Create(volFill, TweenInfo.new(0.15), {Size = UDim2.new(currentVolume, 0, 1, 0)}):Play()
    end

    local function setSpeed(spd)
        currentSpeed = math.clamp(spd, 0.25, 2)
        sound.PlaybackSpeed = currentSpeed
        speedVal.Text = string.format("%.2fx", currentSpeed)
        local fill = (currentSpeed - 0.25) / 1.75
        TweenService:Create(speedFill, TweenInfo.new(0.15), {Size = UDim2.new(fill, 0, 1, 0)}):Play()
    end

    local volDrag, speedDrag = false, false
    volSliderBtn.MouseButton1Down:Connect(function() volDrag = true end)
    speedSliderBtn.MouseButton1Down:Connect(function() speedDrag = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            volDrag = false; speedDrag = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if volDrag then
            local pos = UserInputService:GetMouseLocation()
            local rel = math.clamp((pos.X - volSliderBg.AbsolutePosition.X) / volSliderBg.AbsoluteSize.X, 0, 1)
            setVolume(rel)
        end
        if speedDrag then
            local pos = UserInputService:GetMouseLocation()
            local rel = math.clamp((pos.X - speedSliderBg.AbsolutePosition.X) / speedSliderBg.AbsoluteSize.X, 0, 1)
            setSpeed(0.25 + rel * 1.75)
        end
    end)

    setVolume(1)
    setSpeed(1)

    local barHeights, targetHeights, velocities = {}, {}, {}
    for i = 1, #bars do
        barHeights[i] = s(6)
        targetHeights[i] = s(6)
        velocities[i] = 0
    end
    local lastLoudness, beatCooldown = 0, 0
    RunService.RenderStepped:Connect(function(dt)
        -- [P5] skip the equalizer animation while the player panel is hidden
        if not PanelMusic.Visible then return end
        local loudness = sound.PlaybackLoudness
        local isPlaying = sound.IsPlaying
        local vol = sound.Volume
        local speed = sound.PlaybackSpeed
        local loudnessDiff = loudness - lastLoudness
        beatCooldown = math.max(0, beatCooldown - dt)
        if loudnessDiff > 80 and beatCooldown <= 0 then beatCooldown = 0.1 end
        lastLoudness = loudness
        for i, bar in ipairs(bars) do
            if isPlaying and loudness > 0 then
                local norm = (i - 1) / (#bars - 1)
                local bass = math.max(0, 1 - norm * 2.5) ^ 1.5
                local mid = (1 - math.abs(norm - 0.5) * 2) ^ 1.2
                local treble = math.max(0, (norm - 0.5) * 2) ^ 1.3
                local base = (loudness / 800) * s(55)
                local h = (base * bass * 1.4 + base * mid * 1.1 + base * treble * 0.9) * (math.random(85, 115) / 100)
                if loudnessDiff > 80 then h = h * 1.3 end
                h = h * vol * (0.8 + speed * 0.2)
                targetHeights[i] = math.clamp(h + s(6), s(6), s(55))
            else
                targetHeights[i] = s(6)
            end
            local diff = targetHeights[i] - barHeights[i]
            velocities[i] = velocities[i] + diff * 0.4
            velocities[i] = velocities[i] * 0.65
            barHeights[i] = barHeights[i] + velocities[i]
            bar.Size = UDim2.new(0, s(8), 0, math.floor(barHeights[i]))
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if not musicOpen then return end
        if input.KeyCode == Enum.KeyCode.Space then togglePlayPause()
        elseif input.KeyCode == Enum.KeyCode.Right then nextSong()
        elseif input.KeyCode == Enum.KeyCode.Left then previousSong()
        elseif input.KeyCode == Enum.KeyCode.Up then setVolume(currentVolume + 0.1)
        elseif input.KeyCode == Enum.KeyCode.Down then setVolume(currentVolume - 0.1)
        end
    end)

    print("âœ… MUSIC PLAYER LOADED")
end

task.spawn(loadMusicPlayer)
-- ===================== PART 3 of 5 : END (last line: task.spawn(loadMusicPlayer)) =====================
-- ===================== PART 4 of 5 : BEGIN (paste directly after Part 3) =====================
local function loadToolboxTerrain()

    local openTbPanel, closeTbPanel, tbPanelOpen
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
        BG      = Color3.fromRGB(10, 10, 14),
        SURFACE = Color3.fromRGB(18, 18, 24),
        CARD    = Color3.fromRGB(24, 24, 32),
        CARD2   = Color3.fromRGB(30,32,35),
        BORDER  = Color3.fromRGB(48, 48, 66),
        BORDBRT = Color3.fromRGB(62,66,72),
        TEXT    = Color3.fromRGB(228, 228, 238),
        SUBTEXT = Color3.fromRGB(100, 100, 128),
        WHITE   = Color3.fromRGB(255, 255, 255),
        BLUE    = Color3.fromRGB(60, 120, 255),
        RED     = Color3.fromRGB(205, 42, 55),
        GREEN   = Color3.fromRGB(30, 160, 80),
        YELLOW  = Color3.fromRGB(210, 165, 25),
        ORANGE  = Color3.fromRGB(210, 100, 20),
        CYAN    = Color3.fromRGB(40, 200, 220),
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

    local function iconToolbox2(f,S)
        local m=3
        drawLine2(f,m,m+5,S-m,m+5,1.5,C2.BLUE); drawLine2(f,S-m,m+5,S-m,S-m,1.5,C2.BLUE)
        drawLine2(f,S-m,S-m,m,S-m,1.5,C2.BLUE); drawLine2(f,m,S-m,m,m+5,1.5,C2.BLUE)
        drawLine2(f,S/2-4,m+5,S/2-4,m,1.5,C2.WHITE); drawLine2(f,S/2+4,m+5,S/2+4,m,1.5,C2.WHITE)
        drawLine2(f,S/2-4,m,S/2+4,m,1.5,C2.WHITE)
        drawLine2(f,m,(m+5+S-m)/2,S-m,(m+5+S-m)/2,1,C2.SUBTEXT)
        drawLine2(f,S/2,m+5,S/2,S-m,1,C2.SUBTEXT)
        drawDot2(f,S/2-3,(m+5+(m+5+S-m)/2)/2,1.5,C2.CYAN); drawDot2(f,S/2+3,(m+5+(m+5+S-m)/2)/2,1.5,C2.CYAN)
        drawDot2(f,S/2-3,((m+5+S-m)/2+S-m)/2,1.5,C2.PURPLE); drawDot2(f,S/2+3,((m+5+S-m)/2+S-m)/2,1.5,C2.PURPLE)
    end
    local function iconTerrain2(f,S)
        local bot=S-3
        drawLine2(f,3,bot,S-3,bot,1.5,C2.GREEN)
        drawLine2(f,3,bot,S/2-1,S/2-2,1.5,C2.BLUE); drawLine2(f,S/2-1,S/2-2,S/2+4,bot-4,1.5,C2.BLUE)
        drawLine2(f,S/2+2,bot-5,S-3,4,1.5,C2.CYAN); drawLine2(f,S-3,4,S-3,bot,1.5,C2.CYAN)
        drawLine2(f,S-3,4,S-6,7,1,C2.WHITE); drawLine2(f,S-3,4,S-1,7,1,C2.WHITE)
        drawDot2(f,6,5,2,C2.YELLOW); drawLine2(f,6,2,6,3,1,C2.YELLOW); drawLine2(f,9,5,10,5,1,C2.YELLOW)
    end


    local FILE_NAME    = "ezy_toolbox_v87.json"
    local FILE_DELETED = "ezy_deleted_v87.json"
    local FILE_GRASS   = "ezy_grass_color_v87.json"
    local toolboxItems = {}

    local DEFAULT_ITEMS = {
        {id="4926139544",          name="Part Trampoline",       category="Model"},
        {id="11324928349",         name="Lamp",                  category="Model"},
        {id="120813293048698",     name="Podium",                category="Model"},
        {id="94304441802173",      name="Village Low Poly",      category="Model"},
        {id="131232802624216",     name="Text",                  category="Model"},
        {id="5526968660",          name="Pilar Bunga",           category="Model"},
        {id="574502744",           name="Jembatan",              category="Model"},
        {id="136224194594300",     name="Part Bulet Biru",       category="Model"},
        {id="91824881894906",      name="Pilar Biru",            category="Model"},
        {id="18385401040",         name="Jamur 1",               category="Model"},
        {id="5465044187",          name="Jamur 2",               category="Model"},
        {id="5465008653",          name="Jamur 3",               category="Model"},
        {id="14405338498",         name="Pohon Biru",            category="Model"},
        {id="101093196873917",     name="Pilar Putih",           category="Model"},
        {id="13717277279",         name="Pagar",                 category="Model"},
        {id="108969178728061",     name="Coil Mount Luna",       category="Model"},
        {id="71816321170147",      name="Fitur P Balap",         category="Model"},
        {id="94599287071471",      name="Ayunan Pink",           category="Model"},
        {id="99774552211130",      name="Lampion",               category="Model"},
        {id="103932300220382",     name="Efek Angin",            category="Model"},
        {id="130556119417198",     name="Efek Hujan",            category="Model"},
        {id="107568096083006",     name="Pulau Terapung",        category="Model"},
        {id="78758196076694",      name="Kerambit Coil",         category="Model"},
        {id="16491763998",         name="Text 3D",               category="Model"},
        {id="5539708469",          name="Pohon Hijau",           category="Model"},
        {id="4987585723",          name="Pagar Kayu",            category="Model"},
        {id="83282010441336",      name="Pohon Estetik",         category="Model"},
        {id="10936331751",         name="Kursi Raja",            category="Model"},
        {id="117717806718562",     name="Pohon Ungu",            category="Model"},
        {id="16444908253",         name="Waterfall",             category="Model"},
        {id="18849541324",         name="Logo Mount Neon",       category="Model"},
        {id="77237492468310",      name="Rintangan Nexora Full", category="Obstacle"},
        {id="104719917463159",     name="Tangga Mesh",           category="Obstacle"},
        {id="134505370549170",     name="Rintangan Donat",       category="Obstacle"},
    }

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


    local function loadDeleted()
        local raw = fsRead(FILE_DELETED)
        if raw then
            local ok, result = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok and type(result)=="table" then return result end
        end
        return {}
    end
    local function saveDeleted(tbl) fsWrite(FILE_DELETED, HttpService:JSONEncode(tbl)) end
    local deletedIds = loadDeleted()
    local function isDeletedDefault(id) return deletedIds[tostring(id)] == true end
    local function markDeletedDefault(id) deletedIds[tostring(id)] = true; saveDeleted(deletedIds) end


    local function saveItems()
        local data = {}
        for _, item in ipairs(toolboxItems) do
            if not item.isDefault then
                table.insert(data, { name=item.name, id=item.id, category=item.category })
            end
        end
        fsWrite(FILE_NAME, HttpService:JSONEncode(data))
    end
    local function loadItems()
        local FALLBACK_FILES = {
            FILE_NAME,
            "ezy_toolbox_v72.json","ezy_toolbox_v71.json","ezy_toolbox_v70.json",
            "ezy_toolbox_v69.json","ezy_toolbox_v68.json","ezy_toolbox_v67.json",
            "ezy_toolbox_v66.json","ezy_toolbox_v65.json","ezy_toolbox_v64.json",
            "ezy_toolbox_v63.json","ezy_toolbox_v62.json","ezy_toolbox_v61.json",
            "ezy_toolbox_v60.json","ezy_toolbox_v59.json","ezy_toolbox_v58.json",
            "ezy_toolbox_v57.json","ezy_toolbox_v56.json","ezy_toolbox_v54.json",
        }
        for _, fname in ipairs(FALLBACK_FILES) do
            local raw = fsRead(fname)
            if raw then
                local ok, result = pcall(function() return HttpService:JSONDecode(raw) end)
                if ok and type(result)=="table" and #result > 0 then
                    for _, v in ipairs(result) do if not v.category then v.category="Obstacle" end end
                    if fname ~= FILE_NAME then fsWrite(FILE_NAME, HttpService:JSONEncode(result)) end
                    return result
                end
            end
        end
        return {}
    end


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


    local function _toolbox()
        local tbPanel = Instance.new("Frame")
        tbPanel.Size = UDim2.new(0,380,0,480); tbPanel.Position = UDim2.new(0.5,-190,0,TOPBAR_H+4)
        tbPanel.BackgroundColor3 = C2.BG; tbPanel.BorderSizePixel=0; tbPanel.Visible=false; tbPanel.ZIndex=600
        tbPanel.Parent=mainGui; mkCorner(12,tbPanel); mkStroke(1.5,C2.BORDBRT,tbPanel)

        tbPanelOpen = false
        openTbPanel = function()
            tbPanelOpen=true; tbPanel.Visible=true; tbPanel.Size=UDim2.new(0,0,0,0)
            -- [P9] panel size is clamped to the screen so it never overflows small phones
            local sw = mainGui.AbsoluteSize.X; local sh = mainGui.AbsoluteSize.Y
            local pw = (sw > 0) and math.min(380, sw-16) or 380
            local ph = (sh > 0) and math.min(480, sh-TOPBAR_H-16) or 480
            tbPanel.Position=UDim2.new(0.5,-pw/2,0,TOPBAR_H+4)
            TweenService:Create(tbPanel,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,pw,0,ph)}):Play()
        end
        closeTbPanel = function()
            tbPanelOpen=false
            local t=TweenService:Create(tbPanel,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)})
            t:Play(); t.Completed:Connect(function() tbPanel.Visible=false end)
        end

        local tbHeader = Instance.new("Frame")
        tbHeader.Size=UDim2.new(1,0,0,38); tbHeader.BackgroundColor3=C2.SURFACE; tbHeader.BorderSizePixel=0
        tbHeader.ZIndex=601; tbHeader.Parent=tbPanel; mkCorner(12,tbHeader); makeDraggable2(tbHeader,tbPanel)
        do
            local tbHeaderFill = Instance.new("Frame")
            tbHeaderFill.Size=UDim2.new(1,0,0,14); tbHeaderFill.Position=UDim2.new(0,0,1,-14)
            tbHeaderFill.BackgroundColor3=C2.SURFACE; tbHeaderFill.BorderSizePixel=0; tbHeaderFill.ZIndex=601; tbHeaderFill.Parent=tbHeader
        end
        do
            local tbHIconF = Instance.new("Frame")
            tbHIconF.Size=UDim2.new(0,18,0,18); tbHIconF.Position=UDim2.new(0,10,0.5,-9)
            tbHIconF.BackgroundTransparency=1; tbHIconF.ClipsDescendants=false; tbHIconF.ZIndex=610; tbHIconF.Parent=tbHeader
            iconToolbox2(tbHIconF,18)
        end
        do
            local tbTitle = Instance.new("TextLabel")
            tbTitle.Size=UDim2.new(1,-50,1,0); tbTitle.Position=UDim2.new(0,34,0,0)
            tbTitle.BackgroundTransparency=1; tbTitle.Text="TOOLBOX  â€” by Ezy V1"
            tbTitle.TextColor3=C2.TEXT; tbTitle.TextSize=11; tbTitle.Font=Enum.Font.GothamBold
            tbTitle.TextXAlignment=Enum.TextXAlignment.Left; tbTitle.ZIndex=602; tbTitle.Parent=tbHeader
        end
        do
            local closeTbBtn = Instance.new("TextButton")
            closeTbBtn.Size=UDim2.new(0,24,0,24); closeTbBtn.Position=UDim2.new(1,-30,0.5,-12)
            closeTbBtn.BackgroundColor3=C2.RED; closeTbBtn.BorderSizePixel=0; closeTbBtn.Text="âœ•"
            closeTbBtn.TextColor3=C2.WHITE; closeTbBtn.TextSize=11; closeTbBtn.Font=Enum.Font.GothamBold
            closeTbBtn.ZIndex=602; closeTbBtn.Parent=tbHeader; mkCorner(6,closeTbBtn)
            closeTbBtn.MouseButton1Click:Connect(closeTbPanel)
        end

        local tbContent = Instance.new("Frame")
        tbContent.Size=UDim2.new(1,0,1,-38); tbContent.Position=UDim2.new(0,0,0,38)
        tbContent.BackgroundTransparency=1; tbContent.ZIndex=601; tbContent.Parent=tbPanel

        local tabBar = Instance.new("Frame")
        tabBar.Size=UDim2.new(1,0,0,28); tabBar.Position=UDim2.new(0,0,0,0)
        tabBar.BackgroundColor3=C2.SURFACE; tabBar.BorderSizePixel=0; tabBar.ZIndex=602; tabBar.Parent=tbContent
        mkPad(3,3,4,4,tabBar)

        local tabSaved = Instance.new("TextLabel")
        tabSaved.Size=UDim2.new(1,0,1,0); tabSaved.BackgroundColor3=C2.BLUE; tabSaved.BorderSizePixel=0
        tabSaved.Text="ًں“¦ Tersimpan"; tabSaved.TextColor3=C2.WHITE; tabSaved.TextSize=10; tabSaved.Font=Enum.Font.GothamBold
        tabSaved.TextXAlignment=Enum.TextXAlignment.Center
        tabSaved.ZIndex=603; tabSaved.Parent=tabBar; mkCorner(6,tabSaved)

        local savedArea = Instance.new("Frame")
        savedArea.Size=UDim2.new(1,0,1,-28); savedArea.Position=UDim2.new(0,0,0,28)
        savedArea.BackgroundTransparency=1; savedArea.ZIndex=601; savedArea.Parent=tbContent

        local tbSide = Instance.new("Frame")
        tbSide.Size=UDim2.new(0,70,1,-88); tbSide.BackgroundColor3=C2.SURFACE; tbSide.BorderSizePixel=0
        tbSide.ZIndex=602; tbSide.Parent=savedArea

        local tbListArea = Instance.new("Frame")
        tbListArea.Size=UDim2.new(1,-75,1,-88); tbListArea.Position=UDim2.new(0,75,0,0)
        tbListArea.BackgroundTransparency=1; tbListArea.ZIndex=602; tbListArea.Parent=savedArea

        local categories = {"Model", "SummitKit", "Obstacle", "Sky"}
        local activeCategory = "Model"
        local categoryButtons = {}
        local lastY = 6
        for _, cat in ipairs(categories) do
            local btn = Instance.new("TextButton")
            btn.Size=UDim2.new(1,-8,0,28); btn.Position=UDim2.new(0,4,0,lastY)
            btn.BackgroundColor3=(cat=="Model") and C2.BLUE or C2.CARD2
            btn.BorderSizePixel=0; btn.Text=cat; btn.TextColor3=C2.TEXT; btn.TextSize=9
            btn.Font=Enum.Font.GothamBold; btn.ZIndex=603; btn.Parent=tbSide; mkCorner(6,btn)
            categoryButtons[cat]=btn; lastY=lastY+32
        end

        local itemScroll = Instance.new("ScrollingFrame")
        itemScroll.Size=UDim2.new(1,0,1,0); itemScroll.BackgroundTransparency=1; itemScroll.BorderSizePixel=0
        itemScroll.ScrollBarThickness=3; itemScroll.ScrollBarImageColor3=C2.BORDER
        itemScroll.ScrollingDirection=Enum.ScrollingDirection.Y; itemScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
        itemScroll.CanvasSize=UDim2.new(0,0,0,0); itemScroll.ElasticBehavior=Enum.ElasticBehavior.Never
        itemScroll.ZIndex=601; itemScroll.Parent=tbListArea
        do
            local itemLayout = Instance.new("UIListLayout"); itemLayout.Padding=UDim.new(0,3); itemLayout.SortOrder=Enum.SortOrder.LayoutOrder; itemLayout.Parent=itemScroll
        end

        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size=UDim2.new(1,0,0,40); emptyLabel.BackgroundTransparency=1
        emptyLabel.Text="Belum ada item.\nKlik + Tambah untuk mulai!"; emptyLabel.TextColor3=C2.SUBTEXT
        emptyLabel.TextSize=11; emptyLabel.Font=Enum.Font.Gotham; emptyLabel.TextWrapped=true
        emptyLabel.ZIndex=602; emptyLabel.Parent=itemScroll

        local function refreshList()
            for _, child in ipairs(itemScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
            local filtered = {}
            for _, item in ipairs(toolboxItems) do
                if item.category == activeCategory then table.insert(filtered, item) end
            end
            emptyLabel.Visible = (#filtered == 0)
            for _, item in ipairs(filtered) do
                local row = Instance.new("Frame")
                row.Size=UDim2.new(1,0,0,64); row.BackgroundColor3=C2.CARD; row.BorderSizePixel=0
                row.ZIndex=602; row.Parent=itemScroll; mkCorner(6,row); mkStroke(1,C2.BORDER,row)

                local icon = Instance.new("ImageLabel")
                icon.Size=UDim2.new(0,58,0,58); icon.Position=UDim2.new(0,4,0.5,-29)
                icon.BackgroundColor3=C2.CARD2; icon.BorderSizePixel=0
                icon.Image="rbxthumb://type=Asset&id="..tostring(item.id).."&w=150&h=150"
                icon.ScaleType=Enum.ScaleType.Fit; icon.ZIndex=603; icon.Parent=row; mkCorner(8,icon)
                local spinLbl = Instance.new("TextLabel")
                spinLbl.Size=UDim2.new(1,0,1,0); spinLbl.BackgroundTransparency=1
                spinLbl.Text="..."; spinLbl.TextColor3=C2.SUBTEXT; spinLbl.TextSize=9
                spinLbl.Font=Enum.Font.Gotham; spinLbl.ZIndex=604; spinLbl.Parent=icon
                icon:GetPropertyChangedSignal("IsLoaded"):Connect(function()
                    if icon.IsLoaded then spinLbl.Visible=false end
                end)
                if icon.IsLoaded then spinLbl.Visible=false end

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size=UDim2.new(1,-100,0,18); nameLbl.Position=UDim2.new(0,68,0,10)
                nameLbl.BackgroundTransparency=1; nameLbl.Text=item.name; nameLbl.TextColor3=C2.TEXT
                nameLbl.TextSize=11; nameLbl.Font=Enum.Font.GothamBold; nameLbl.TextXAlignment=Enum.TextXAlignment.Left
                nameLbl.TextTruncate=Enum.TextTruncate.AtEnd; nameLbl.ZIndex=603; nameLbl.Parent=row

                local idLbl = Instance.new("TextLabel")
                idLbl.Size=UDim2.new(1,-100,0,14); idLbl.Position=UDim2.new(0,68,0,32)
                idLbl.BackgroundTransparency=1; idLbl.Text="ID: "..tostring(item.id); idLbl.TextColor3=C2.SUBTEXT
                idLbl.TextSize=9; idLbl.Font=Enum.Font.Gotham; idLbl.TextXAlignment=Enum.TextXAlignment.Left
                idLbl.ZIndex=603; idLbl.Parent=row

                local copyBtn2 = Instance.new("TextButton")
                copyBtn2.Size=UDim2.new(0,46,0,28); copyBtn2.Position=UDim2.new(1,-80,0.5,-14)
                copyBtn2.BackgroundColor3=C2.BLUE; copyBtn2.BorderSizePixel=0
                copyBtn2.Text=(activeCategory=="Sky") and "Apply" or "Insert"
                copyBtn2.TextColor3=C2.WHITE; copyBtn2.TextSize=9; copyBtn2.Font=Enum.Font.GothamBold
                copyBtn2.ZIndex=604; copyBtn2.Parent=row; mkCorner(5,copyBtn2)

                local delBtn = Instance.new("TextButton")
                delBtn.Size=UDim2.new(0,26,0,28); delBtn.Position=UDim2.new(1,-30,0.5,-14)
                delBtn.BackgroundColor3=C2.RED; delBtn.BorderSizePixel=0; delBtn.Text="âœ•"
                delBtn.TextColor3=C2.WHITE; delBtn.TextSize=9; delBtn.Font=Enum.Font.GothamBold
                delBtn.ZIndex=604; delBtn.Parent=row; mkCorner(5,delBtn)

                local inserting=false
                copyBtn2.MouseButton1Click:Connect(function()
                    if inserting then return end; inserting=true
                    local assetId = tonumber(tostring(item.id):match("%d+"))
                    if not assetId then
                        nameLbl.Text="ID tidak valid!"; nameLbl.TextColor3=C2.RED
                        task.wait(1.5); nameLbl.Text=item.name; nameLbl.TextColor3=C2.TEXT; inserting=false; return
                    end
                    copyBtn2.Text="..."; copyBtn2.BackgroundColor3=C2.YELLOW

                    if activeCategory == "Sky" then
                        local ok = pcall(function()
                            local Lighting = game:GetService("Lighting")
                            local existing = Lighting:FindFirstChildOfClass("Sky")
                            if existing then existing:Destroy() end
                            local sky = Instance.new("Sky")
                            local faces = {"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp"}
                            for _,f in ipairs(faces) do sky[f]="rbxassetid://"..tostring(assetId) end
                            sky.Parent = Lighting
                        end)
                        if ok then
                            nameLbl.Text="Sky Applied!"; nameLbl.TextColor3=C2.GREEN
                            copyBtn2.Text="âœ“"; copyBtn2.BackgroundColor3=C2.GREEN
                            task.spawn(function() showToast("âکپ Sky "..tostring(assetId).." diapply!", Color3.fromRGB(20,80,160)) end)
                        else
                            nameLbl.Text="Gagal apply!"; nameLbl.TextColor3=C2.RED
                            copyBtn2.Text="âœ—"; copyBtn2.BackgroundColor3=C2.RED
                            task.spawn(function() showToast("âœ— Gagal apply sky", Color3.fromRGB(130,20,20)) end)
                        end
                        task.wait(1.5); nameLbl.Text=item.name; nameLbl.TextColor3=C2.TEXT
                        copyBtn2.Text="Apply"; copyBtn2.BackgroundColor3=C2.BLUE; inserting=false; return
                    end

                    local MPS = game:GetService("MarketplaceService")
                    local aType2 = 0
                    pcall(function()
                        local inf2 = MPS:GetProductInfo(assetId, Enum.InfoType.Asset)
                        aType2 = inf2 and inf2.AssetTypeId or 0
                    end)
                    local BLOCKED_TYPES = {[21]=true, [9]=true, [3]=true}
                    if aType2 ~= 0 and BLOCKED_TYPES[aType2] then
                        nameLbl.Text="Tipe tidak support!"; nameLbl.TextColor3=C2.RED
                        copyBtn2.Text="âœ—"; copyBtn2.BackgroundColor3=C2.RED
                        task.spawn(function() showToast("âœ— Tipe asset tidak bisa diinsert (type "..aType2..")", Color3.fromRGB(130,20,20)) end)
                        task.wait(2); nameLbl.Text=item.name; nameLbl.TextColor3=C2.TEXT
                        copyBtn2.Text="Insert"; copyBtn2.BackgroundColor3=C2.BLUE; inserting=false; return
                    end

                    copyBtn2.Text="Memuat..."; copyBtn2.BackgroundColor3=C2.YELLOW

                    local spawnCF = CFrame.new(0, 5, 0)
                    local cam = workspace.CurrentCamera
                    if cam then
                        local cf  = cam.CFrame
                        local fwd = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
                        if fwd.Magnitude > 0.01 then fwd = fwd.Unit else fwd = Vector3.new(0,0,-1) end
                        local pos = cf.Position + fwd * 20
                        spawnCF = CFrame.new(pos.X, math.max(pos.Y, 3), pos.Z)
                    end

                    local function placeSavedObjs(objs)
                        local scriptCount = 0
                        local function countSc(obj)
                            if obj:IsA("LuaSourceContainer") then scriptCount = scriptCount + 1 end
                            for _, ch in ipairs(obj:GetChildren()) do countSc(ch) end
                        end
                        for _, obj in ipairs(objs) do
                            countSc(obj); obj.Parent = workspace
                            if obj:IsA("Model") then
                                if obj.PrimaryPart then obj:SetPrimaryPartCFrame(spawnCF)
                                else local firstPart = obj:FindFirstChildOfClass("BasePart"); if firstPart then firstPart.CFrame = spawnCF end end
                            elseif obj:IsA("BasePart") then obj.CFrame = spawnCF end
                        end
                        return {scripts=scriptCount, fetchOk=true}
                    end

                    local ok, result = false, nil
                    local ok_a, res_a = pcall(function()
                        local IS = game:GetService("InsertService")
                        local container = IS:LoadAsset(assetId)
                        if not container then error("nil") end
                        local r = placeSavedObjs(container:GetChildren())
                        container:Destroy(); return r
                    end)
                    if ok_a then ok, result = true, res_a
                    else
                        local ok_b, res_b = pcall(function()
                            local objs = game:GetObjects("rbxassetid://"..tostring(assetId))
                            if not objs or #objs == 0 then error("empty") end
                            return placeSavedObjs(objs)
                        end)
                        if ok_b then ok, result = true, res_b
                        else ok, result = false, res_b end
                    end

                    if ok and type(result)=="table" then
                        nameLbl.Text="Inserted!"; nameLbl.TextColor3=C2.GREEN
                        copyBtn2.Text="âœ“"; copyBtn2.BackgroundColor3=C2.GREEN
                        local info = result.scripts > 0 and (" ("..result.scripts.." script)") or ""
                        task.spawn(function() showToast("âœ“ Asset "..tostring(assetId).." inserted"..info, Color3.fromRGB(20,100,40)) end)
                    else
                        nameLbl.Text="Gagal insert!"; nameLbl.TextColor3=C2.RED
                        copyBtn2.Text="âœ—"; copyBtn2.BackgroundColor3=C2.RED
                        local errMsg = tostring(result):match(":%s*(.+)$") or tostring(result)
                        task.spawn(function() showToast("âœ— Gagal: "..errMsg:sub(1,40), Color3.fromRGB(130,20,20)) end)
                    end
                    task.wait(1.5); nameLbl.Text=item.name; nameLbl.TextColor3=C2.TEXT
                    copyBtn2.Text=(activeCategory=="Sky") and "Apply" or "Insert"
                    copyBtn2.BackgroundColor3=C2.BLUE; inserting=false
                end)
                row.MouseEnter:Connect(function() row.BackgroundColor3=C2.CARD2 end)
                row.MouseLeave:Connect(function() row.BackgroundColor3=C2.CARD end)
                delBtn.MouseButton1Click:Connect(function()
                    for j,v in ipairs(toolboxItems) do
                        if v.name==item.name and v.id==item.id and v.category==item.category then
                            if v.isDefault then markDeletedDefault(v.id) end
                            table.remove(toolboxItems,j); break
                        end
                    end
                    saveItems(); refreshList()
                end)
            end
        end

        local function updateCategoryUI(active)
            for cat,btn in pairs(categoryButtons) do
                btn.BackgroundColor3 = (cat==active) and C2.BLUE or C2.CARD2
                btn.TextColor3 = C2.TEXT
            end
        end

        local loaded=loadItems()
        for _, v in ipairs(DEFAULT_ITEMS) do
            if not isDeletedDefault(v.id) then
                table.insert(toolboxItems, {name=v.name, id=v.id, category=v.category, isDefault=true})
            end
        end
        for _,v in ipairs(loaded) do
            if v.category ~= "Script" then table.insert(toolboxItems, v) end
        end
        refreshList(); updateCategoryUI(activeCategory)

        for cat,btn in pairs(categoryButtons) do
            btn.MouseButton1Click:Connect(function()
                activeCategory=cat; updateCategoryUI(activeCategory); refreshList()
            end)
        end

        local tbBot = Instance.new("Frame")
        tbBot.Size=UDim2.new(1,-10,0,84); tbBot.Position=UDim2.new(0,5,1,-88)
        tbBot.BackgroundColor3=C2.SURFACE; tbBot.BorderSizePixel=0; tbBot.ZIndex=601; tbBot.Parent=savedArea
        mkCorner(8,tbBot); mkStroke(1,C2.BORDER,tbBot)

        local addNameBox = Instance.new("TextBox")
        addNameBox.Size=UDim2.new(1,-8,0,24); addNameBox.Position=UDim2.new(0,4,0,6)
        addNameBox.BackgroundColor3=C2.CARD; addNameBox.BorderSizePixel=0; addNameBox.Text=""
        addNameBox.PlaceholderText="Nama item..."; addNameBox.TextColor3=C2.TEXT
        addNameBox.PlaceholderColor3=C2.SUBTEXT; addNameBox.TextSize=11; addNameBox.Font=Enum.Font.Arial
        addNameBox.ClearTextOnFocus=false; addNameBox.ZIndex=602; addNameBox.Parent=tbBot; mkCorner(5,addNameBox)

        local addIdBox = Instance.new("TextBox")
        addIdBox.Size=UDim2.new(1,-8,0,24); addIdBox.Position=UDim2.new(0,4,0,34)
        addIdBox.BackgroundColor3=C2.CARD; addIdBox.BorderSizePixel=0; addIdBox.Text=""
        addIdBox.PlaceholderText="Asset ID (contoh: 123456789)..."; addIdBox.TextColor3=C2.TEXT
        addIdBox.PlaceholderColor3=C2.SUBTEXT; addIdBox.TextSize=11; addIdBox.Font=Enum.Font.Arial
        addIdBox.ClearTextOnFocus=false; addIdBox.ZIndex=602; addIdBox.Parent=tbBot; mkCorner(5,addIdBox)

        local addBtn = Instance.new("TextButton")
        addBtn.Size=UDim2.new(0.48,0,0,22); addBtn.Position=UDim2.new(0,4,1,-26)
        addBtn.BackgroundColor3=C2.BLUE; addBtn.BorderSizePixel=0; addBtn.Text="+ Tambah"
        addBtn.TextColor3=C2.WHITE; addBtn.TextSize=10; addBtn.Font=Enum.Font.GothamBold
        addBtn.ZIndex=602; addBtn.Parent=tbBot; mkCorner(5,addBtn)

        local saveBtn = Instance.new("TextButton")
        saveBtn.Size=UDim2.new(0.48,0,0,22); saveBtn.Position=UDim2.new(0.52,-4,1,-26)
        saveBtn.BackgroundColor3=C2.GREEN; saveBtn.BorderSizePixel=0; saveBtn.Text="Simpan"
        saveBtn.TextColor3=C2.WHITE; saveBtn.TextSize=10; saveBtn.Font=Enum.Font.GothamBold
        saveBtn.ZIndex=602; saveBtn.Parent=tbBot; mkCorner(5,saveBtn)

        addBtn.MouseButton1Click:Connect(function()
            local name=addNameBox.Text:match("^%s*(.-)%s*$")
            local id=addIdBox.Text:match("^%s*(.-)%s*$")
            if name=="" or id=="" then
                addBtn.Text="Isi nama & ID!"; addBtn.BackgroundColor3=C2.ORANGE
                task.wait(1.5); addBtn.Text="+ Tambah"; addBtn.BackgroundColor3=C2.BLUE; return
            end
            table.insert(toolboxItems,{name=name,id=id,category=activeCategory})
            addNameBox.Text=""; addIdBox.Text=""; saveItems(); refreshList()
            addBtn.Text="Ditambah!"; addBtn.BackgroundColor3=C2.GREEN
            task.wait(1.5); addBtn.Text="+ Tambah"; addBtn.BackgroundColor3=C2.BLUE
        end)
        saveBtn.MouseButton1Click:Connect(function()
            saveItems(); saveBtn.Text="Tersimpan!"; saveBtn.BackgroundColor3=Color3.fromRGB(20,120,60)
            task.wait(1.5); saveBtn.Text="Simpan"; saveBtn.BackgroundColor3=C2.GREEN
        end)
    end
    _toolbox()


    local function _terrain()
        local PANEL_W  = 248
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
            {name="Pavemt", color=Color3.fromRGB(74,76,80),    mat=Enum.Material.Pavement},
        }

        local tPanel = Instance.new("Frame")
        tPanel.Name="TerrainPanel"; tPanel.Size=UDim2.new(0,0,0,0)
        tPanel.Position=UDim2.new(0.5,-180,0,TOPBAR_H+4)
        tPanel.BackgroundColor3=C2.BG; tPanel.BorderSizePixel=0; tPanel.ClipsDescendants=true
        tPanel.Visible=false; tPanel.ZIndex=700; tPanel.Parent=mainGui
        mkCorner(12,tPanel); mkStroke(1.5,C2.BORDBRT,tPanel)

        tPanelOpen=false
        openTPanel = function()
            tPanelOpen=true; tPanel.Visible=true
            tPanel.Position=UDim2.new(0.5,-180,0,TOPBAR_H+4)
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
            closeTBtn.BackgroundColor3=Color3.fromRGB(50,20,20); closeTBtn.BorderSizePixel=0; closeTBtn.Text="âœ•"
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
            tn.BackgroundTransparency=1; tn.Text=td.name; tn.TextColor3=C2.TEXT; tn.TextSize=9
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
                mb.Text=mode; mb.TextColor3=C2.TEXT; mb.TextSize=9; mb.Font=Enum.Font.GothamBold; mb.ZIndex=702; mb.Parent=modeFrame; mkCorner(5,mb); modeBtns[mode]=mb
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
            sizeMinBtn.BackgroundColor3=C2.CARD2; sizeMinBtn.BorderSizePixel=0; sizeMinBtn.Text="âˆ’"
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
            ssMinBtn.BackgroundColor3=C2.CARD2; ssMinBtn.BorderSizePixel=0; ssMinBtn.Text="âˆ’"
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
            local screenH=mainGui.AbsoluteSize.Y
            local ph=math.min(screenH-60,600)
            TweenService:Create(viewerPanel,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,380,0,ph)}):Play()
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
                vCopy.Text="âœ“ OK"; vCopy.BackgroundColor3=C2.GREEN
                task.wait(1.5); vCopy.Text="Copy"; vCopy.BackgroundColor3=C2.BLUE
            end)
            local vClose=Instance.new("TextButton"); vClose.Size=UDim2.new(0,32,0,26); vClose.Position=UDim2.new(1,-36,0.5,-13)
            vClose.BackgroundColor3=Color3.fromRGB(50,20,20); vClose.BorderSizePixel=0; vClose.Text="âœ•"
            vClose.TextColor3=C2.WHITE; vClose.TextSize=11; vClose.Font=Enum.Font.GothamBold; vClose.ZIndex=802; vClose.Parent=vh; mkCorner(6,vClose)
            vClose.MouseButton1Click:Connect(function()
                viewerOpen=false
                local t=TweenService:Create(viewerPanel,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)})
                t:Play(); t.Completed:Once(function() viewerPanel.Visible=false end)
            end)
            local infoLbl=Instance.new("TextLabel"); infoLbl.Size=UDim2.new(1,-16,0,18); infoLbl.Position=UDim2.new(0,8,0,42)
            infoLbl.BackgroundTransparency=1; infoLbl.Text=string.format("%d baris  â€¢  %d karakter",#code:split("\n"),#code)
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
            TweenService:Create(listPanel,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,260,0,320)}):Play()
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
            closeLBtn.BackgroundColor3=Color3.fromRGB(50,20,20); closeLBtn.BorderSizePixel=0; closeLBtn.Text="âœ•"
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
            rInfo.BackgroundTransparency=1; rInfo.Text=#code:split("\n").." baris  â€¢  "..#code.." karakter"
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
                copyBtn3.Text="âœ“"; copyBtn3.BackgroundColor3=C2.GREEN
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
                    showToast("âڑ  Pilih dulu Part di workspace sebagai tumbal!", C2.ORANGE); return
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
                inPartBtn.Text="âœ“ Done!"; inPartBtn.BackgroundColor3=C2.GREEN
                showToast("âœ… Script di Part: "..tumbalPart2.Name.." (arah: rotasi part)", C2.GREEN)
                task.wait(2); inPartBtn.Text="ًں“¦ In Part"; inPartBtn.BackgroundColor3=C2.ORANGE
            end)
            row.MouseEnter:Connect(function() row.BackgroundColor3=C2.CARD2 end)
            row.MouseLeave:Connect(function() row.BackgroundColor3=C2.CARD end)
        end

        secLabel("SCRIPTS",15)
        local listTrigger=Instance.new("TextButton"); listTrigger.Size=UDim2.new(1,0,0,28); listTrigger.BackgroundColor3=C2.CARD2
        listTrigger.BorderSizePixel=0; listTrigger.Text="â–¾ Lihat Generated Scripts (0)"; listTrigger.TextColor3=C2.TEXT
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
            listTrigger.Text="â–¾ Lihat Generated Scripts (0)"
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
            listTrigger.Text="â–¾ Lihat Generated Scripts ("..#scriptList..")"
            generateBtn.Text="DONE âœ“"; generateBtn.BackgroundColor3=C2.GREEN
            if not listOpen then openList() end
            task.wait(2); generateBtn.Text="GENERATE"; generateBtn.BackgroundColor3=C2.BLUE
        end)

        local toPartBtn=Instance.new("TextButton")
        toPartBtn.Size=UDim2.new(0,64,0,28); toPartBtn.BackgroundColor3=C2.ORANGE
        toPartBtn.BorderSizePixel=0; toPartBtn.Text="â†’ Part"
        toPartBtn.TextColor3=C2.WHITE; toPartBtn.TextSize=9; toPartBtn.Font=Enum.Font.GothamBold
        toPartBtn.ZIndex=702; toPartBtn.Parent=actFrame; mkCorner(6,toPartBtn)
        toPartBtn.MouseButton1Click:Connect(function()
            if #terrainData==0 and #paintData==0 and #convertData==0 then
                toPartBtn.Text="NO DATA!"; toPartBtn.BackgroundColor3=C2.RED
                task.wait(1.5); toPartBtn.Text="â†’ Part"; toPartBtn.BackgroundColor3=C2.ORANGE; return
            end
            toPartBtn.Text="âڈ³ ..."; toPartBtn.BackgroundColor3=C2.YELLOW; task.wait(0.2)
            local ok, err = pcall(function()
                local code = generateScript()
                local sName = "Terrain_Part_"..os.date("%H%M%S")
                addScriptToList(sName, code)
                listTrigger.Text="â–¾ Lihat Generated Scripts ("..#scriptList..")"
                if not listOpen then openList() end
                showToast("âœ… Script siap! Copy dari viewer â†’ paste ke Script di Part.", C2.GREEN)
            end)
            if ok then
                toPartBtn.Text="âœ“ Done!"; toPartBtn.BackgroundColor3=C2.GREEN
            else
                showToast("Gagal: "..tostring(err), C2.RED)
                toPartBtn.Text="âœ— Gagal"; toPartBtn.BackgroundColor3=C2.RED
            end
            task.wait(2); toPartBtn.Text="â†’ Part"; toPartBtn.BackgroundColor3=C2.ORANGE
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
            msCancelBtn.BackgroundColor3=C2.RED; msCancelBtn.BorderSizePixel=0; msCancelBtn.Text="âœ•"
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
            TweenService:Create(grassPopup,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,240,0,310)}):Play()
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
            gpClose.BackgroundColor3=C2.RED; gpClose.BorderSizePixel=0; gpClose.Text="âœ•"
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
        gpPreviewLbl.Text="RGB  106, 127, 63"; gpPreviewLbl.TextColor3=C2.TEXT; gpPreviewLbl.TextSize=9; gpPreviewLbl.Font=Enum.Font.Gotham
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
        gpApply.Text="Terapkan"; gpApply.TextColor3=C2.WHITE; gpApply.TextSize=9; gpApply.Font=Enum.Font.GothamBold; gpApply.ZIndex=853; gpApply.Parent=gpRgbRow; mkCorner(5,gpApply)
        gpApply.MouseButton1Click:Connect(function()
            local r=math.clamp(tonumber(gpR.Text) or 106,0,255); local g=math.clamp(tonumber(gpG.Text) or 127,0,255); local b=math.clamp(tonumber(gpB.Text) or 63,0,255)
            applyGrassColor2(r,g,b); gpApply.Text="âœ“"; gpApply.BackgroundColor3=C2.CYAN
            task.wait(1); gpApply.Text="Terapkan"; gpApply.BackgroundColor3=C2.GREEN
        end)
        local gpReset=Instance.new("TextButton"); gpReset.Size=UDim2.new(1,-16,0,20); gpReset.Position=UDim2.new(0,8,0,gpRgbY+30)
        gpReset.BackgroundColor3=C2.CARD2; gpReset.BorderSizePixel=0; gpReset.Text="â†؛  Reset Default (106,127,63)"; gpReset.TextColor3=C2.SUBTEXT
        gpReset.TextSize=9; gpReset.Font=Enum.Font.GothamBold; gpReset.ZIndex=853; gpReset.Parent=grassPopup; mkCorner(5,gpReset)
        gpReset.MouseButton1Click:Connect(function()
            applyGrassColor2(106,127,63); gpReset.Text="âœ“ Reset!"; gpReset.BackgroundColor3=C2.ORANGE
            task.wait(1.2); gpReset.Text="â†؛  Reset Default (106,127,63)"; gpReset.BackgroundColor3=C2.CARD2
        end)
        grassColorOpenBtn.MouseButton1Click:Connect(function()
            if grassPopupOpen then closeGrassPopup() else openGrassPopup() end
        end)
    end
    _grass()


    _G.SL_OpenTerrain  = function() if tPanelOpen then closeTPanel() else openTPanel() end end

    print("[STUDIO LITE BY EZY] âœ… Ezy Toolbox + Terrain siap!")
end

task.spawn(loadToolboxTerrain)
-- ===================== PART 4 of 5 : END (last line: task.spawn(loadToolboxTerrain)) =====================
-- ===================== PART 5 of 5 : BEGIN (paste directly after Part 4) =====================
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

        exp.BackgroundColor3 = Color3.fromRGB(22,23,25)

        local function process(p)
            for _, ch in ipairs(p:GetChildren()) do
                pcall(function()
                    local name = ch.Name
                    if name:lower():find("add") or name:lower():find("create") or name:lower():find("plus") then
                        return
                    end
                    if ch:IsA("TextLabel") or ch:IsA("TextButton") or ch:IsA("TextBox") then
                        ch.TextColor3 = Color3.fromRGB(240, 240, 240)
                        if ch.BackgroundTransparency < 0.95 then
                            ch.BackgroundColor3 = Color3.fromRGB(30,31,34)
                        end
                        ch:GetPropertyChangedSignal("TextColor3"):Connect(function()
                            if ch.TextColor3 ~= Color3.fromRGB(240, 240, 240) then
                                ch.TextColor3 = Color3.fromRGB(240, 240, 240)
                            end
                        end)
                    end
                    if ch:IsA("Frame") or ch:IsA("ScrollingFrame") then
                        if ch.BackgroundTransparency < 0.95 then
                            ch.BackgroundColor3 = Color3.fromRGB(30,31,34)
                        end
                        if ch:IsA("ScrollingFrame") then
                            ch.ScrollBarImageColor3 = Color3.fromRGB(58,61,66)
                            ch.ScrollBarThickness = 4
                            ch.ScrollBarImageTransparency = 0.3
                        end
                    end
                    if ch:IsA("ImageLabel") or ch:IsA("ImageButton") then
                        if not ch.Name:find("SL_") then
                            pcall(function() ch.ImageColor3 = Color3.fromRGB(220, 220, 220) end)
                        end
                    end
                    if ch:IsA("UIStroke") then
                        ch.Color = Color3.fromRGB(58,61,66)
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

    RunService.RenderStepped:Connect(function()
        if not prop or not prop.Parent then
            cari()
            if not prop then return end
        end

        prop.BackgroundColor3 = Color3.fromRGB(22,23,25)

        for _, ch in ipairs(prop:GetDescendants()) do
            pcall(function()
                if ch:IsA("TextLabel") or ch:IsA("TextButton") or ch:IsA("TextBox") then
                    ch.TextColor3 = Color3.fromRGB(255, 255, 255)
                    if ch.BackgroundTransparency < 0.95 then
                        ch.BackgroundColor3 = Color3.fromRGB(30,31,34)
                    end
                end
                if ch:IsA("Frame") or ch:IsA("ScrollingFrame") then
                    if ch.BackgroundTransparency < 0.95 then
                        ch.BackgroundColor3 = Color3.fromRGB(30,31,34)
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
                        pcall(function() ch.ImageColor3 = Color3.fromRGB(220, 220, 220) end)
                    end
                end
                if ch:IsA("UIStroke") then
                    ch.Color = Color3.fromRGB(58,61,66)
                end
            end)
        end
    end)

    print("[PROPERTIES] âœ… RenderStepped aktif - teks putih permanen")
end)


local function loadEzyToolbox()
    if _G.__EzyToolboxLoaded then return end
    _G.__EzyToolboxLoaded = true

    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer

    local GuiParent
    pcall(function() GuiParent = game:GetService("CoreGui") end)
    if not GuiParent then GuiParent = LocalPlayer:WaitForChild("PlayerGui") end
    if GuiParent:FindFirstChild("EzyToolboxBetaGUI") then
        GuiParent:FindFirstChild("EzyToolboxBetaGUI"):Destroy()
    end

    local ACCENT = Color3.fromRGB(0,150,230)
    local ACCENT_HOV = Color3.fromRGB(52, 115, 220)
    local ACCENT_DIM = Color3.fromRGB(20, 60, 140)

    local T = {
        bg        = Color3.fromRGB(6, 6, 10),
        panel     = Color3.fromRGB(12, 12, 18),
        topbar    = Color3.fromRGB(15, 15, 24),
        card      = Color3.fromRGB(16,17,19),
        cardHov   = Color3.fromRGB(24, 24, 36),
        input     = Color3.fromRGB(14, 14, 22),
        inputHov  = Color3.fromRGB(20, 20, 32),
        border    = Color3.fromRGB(30, 30, 46),
        borderHi  = ACCENT,
        accent    = ACCENT,
        accentHov = ACCENT_HOV,
        accentDim = ACCENT_DIM,
        green     = Color3.fromRGB(52, 200, 125),
        greenDark = Color3.fromRGB(10, 38, 24),
        red       = Color3.fromRGB(210, 55, 70),
        yellow    = Color3.fromRGB(238, 178, 38),
        white     = Color3.fromRGB(228, 226, 255),
        sub       = Color3.fromRGB(70,74,80),
        dim       = Color3.fromRGB(42, 40, 62),
        pill      = Color3.fromRGB(16,17,19),
        pillBrd   = Color3.fromRGB(32, 30, 50),
        orange    = Color3.fromRGB(228, 118, 38),
        sky       = Color3.fromRGB(36, 146, 238),
        sumkit    = Color3.fromRGB(192, 46, 86),
    }


    local SAVE_FILE = "EzyToolbox_Data.json"
    local function saveToFile(data)
        local ok, err = pcall(function()
            local encoded = HttpService:JSONEncode(data)
            writefile(SAVE_FILE, encoded)
        end)
        if not ok then warn("[TOOLBOX] Gagal save:", err) end
    end
    local function loadFromFile()
        local ok, result = pcall(function()
            if isfile(SAVE_FILE) then
                local raw = readfile(SAVE_FILE)
                return HttpService:JSONDecode(raw)
            end
            return nil
        end)
        if ok and result then return result end
        return nil
    end

    if not _G.EzyToolbox_Data then _G.EzyToolbox_Data = {} end
    if not _G.EzyToolbox_Del  then _G.EzyToolbox_Del  = {} end

    local catOrder  = {"Model","Sound","Decal","Sky","SumMitKit"}
    local catLabels = {Model="Model",Sound="Audio",Decal="Decal",Sky="Sky",SumMitKit="SumMit"}
    local catColors = {Model=T.accent,Sound=T.orange,Decal=T.green,Sky=T.sky,SumMitKit=T.sumkit}

    local loadedData = loadFromFile()
    if loadedData then
        for _, cat in ipairs(catOrder) do
            if loadedData[cat] then _G.EzyToolbox_Data[cat] = loadedData[cat] end
        end
    end
    for _, cat in ipairs(catOrder) do
        if not _G.EzyToolbox_Data[cat] then _G.EzyToolbox_Data[cat] = {} end
    end
    local SavedAssets = _G.EzyToolbox_Data
    local Deleted     = _G.EzyToolbox_Del

    local function persistSave() saveToFile(SavedAssets) end


    local function httpReq(opts)
        local fn
        if syn and syn.request then fn = syn.request
        elseif fluxus and fluxus.request then fn = fluxus.request
        elseif krnl_request then fn = krnl_request
        elseif http and http.request then fn = http.request
        elseif http_request then fn = http_request
        elseif request then fn = request
        end
        if fn then
            local ok, res = pcall(fn, opts)
            if ok and res then return res end
            return nil
        end
        if (opts.Method or "GET"):upper() == "GET" then
            local ok, body = pcall(function() return game:HttpGet(opts.Url) end)
            if ok then return {StatusCode = 200, Body = body} end
        end
        return nil
    end
    local function httpGet(url, headers)
        local r = httpReq({Url=url, Method="GET", Headers=headers or {}})
        if r and r.Body then return r.Body, r.StatusCode end
        return nil, 0
    end
    local function decodeJson(s)
        local ok, t = pcall(function() return HttpService:JSONDecode(s) end)
        if ok then return t end
        return nil
    end
    local function normalizeItem(raw)
        if not raw then return nil end
        local id, name, creator
        if raw.Asset then
            id = raw.Asset.Id or raw.Asset.id
            name = raw.Asset.Name or raw.Asset.name
        elseif raw.asset then
            id = raw.asset.id or raw.asset.Id
            name = raw.asset.name or raw.asset.Name
        else
            id = raw.id or raw.Id or raw.assetId or raw.AssetId
            name = raw.name or raw.Name
        end
        if raw.Creator then creator = raw.Creator.Name or raw.Creator.name
        elseif raw.creator then creator = raw.creator.name or raw.creator.Name end
        if not id then return nil end
        return { id = tonumber(id) or id, name = name or ("Asset "..tostring(id)), creator = creator or "?" }
    end


    local CATEGORY_MAP = { Model = 10, Decal = 13, Sound = 9, Sky = 10, SumMitKit = 10 }
    local function searchAssets(category, keyword)
        local catId = CATEGORY_MAP[category] or 10
        keyword = keyword or ""
        local results = {}
        local url1 = string.format("https://apis.roblox.com/toolbox-service/v1/marketplace/%d?category=%d&keyword=%s&limit=30&sortType=0&page=1", catId, catId, HttpService:UrlEncode(keyword))
        local body = httpGet(url1)
        if body then
            local data = decodeJson(body)
            if data and data.data then
                for _, raw in ipairs(data.data) do
                    local n = normalizeItem(raw)
                    if n then table.insert(results, n) end
                end
            end
        end
        if #results == 0 then
            local catName = (category == "Model" and "Models") or (category == "Decal" and "Decals") or (category == "Sound" and "Audio") or "Models"
            local url2 = string.format("https://catalog.roblox.com/v1/search/items/details?Category=%s&Keyword=%s&Limit=30", catName, HttpService:UrlEncode(keyword))
            local body2 = httpGet(url2)
            if body2 then
                local data = decodeJson(body2)
                if data and data.data then
                    for _, raw in ipairs(data.data) do
                        table.insert(results, { id = raw.id or raw.Id, name = raw.name or raw.Name or "?", creator = (raw.creatorName or "?") })
                    end
                end
            end
        end
        return results
    end


    local function safeTween(obj, info, props)
        if not obj or not obj.Parent then return end
        pcall(function() TweenService:Create(obj, info, props):Play() end)
    end


    local function corner(obj, r)
        if not obj then return end
        Instance.new("UICorner", obj).CornerRadius = UDim.new(0, r or 12)
    end
    local function stroke(obj, col, thick)
        if not obj then return end
        local s = Instance.new("UIStroke", obj)
        s.Color = col or T.border; s.Thickness = thick or 1; return s
    end
    local function stylePrimary(b)
        if not b or not b.Parent then return end
        b.BackgroundColor3 = T.accent; b.TextColor3 = T.white; b.BorderSizePixel = 0; corner(b, 8)
        b.MouseEnter:Connect(function() if b and b.Parent then safeTween(b, TweenInfo.new(0.12), {BackgroundColor3=T.accentHov}) end end)
        b.MouseLeave:Connect(function() if b and b.Parent then safeTween(b, TweenInfo.new(0.12), {BackgroundColor3=T.accent}) end end)
    end
    local function styleSecondary(b)
        if not b or not b.Parent then return end
        b.BackgroundColor3 = T.pill; b.TextColor3 = T.sub; b.BorderSizePixel = 0; corner(b, 6); stroke(b, T.pillBrd, 1)
        b.MouseEnter:Connect(function() if b and b.Parent then safeTween(b, TweenInfo.new(0.12), {TextColor3=T.white}) end end)
        b.MouseLeave:Connect(function() if b and b.Parent then safeTween(b, TweenInfo.new(0.12), {TextColor3=T.sub}) end end)
    end
    local function mkInput(parent, hint, h)
        h = h or 30
        local wrap = Instance.new("Frame", parent)
        wrap.Size = UDim2.new(1, 0, 0, h)
        wrap.BackgroundColor3 = T.input; wrap.BorderSizePixel = 0; wrap.ZIndex = 7
        corner(wrap, 8)
        local ws = stroke(wrap, T.border, 1)
        local box = Instance.new("TextBox", wrap)
        box.PlaceholderText = hint; box.Text = ""
        box.Size = UDim2.new(1, -16, 1, 0); box.Position = UDim2.new(0, 8, 0, 0)
        box.BackgroundTransparency = 1; box.TextColor3 = T.white
        box.PlaceholderColor3 = T.dim; box.TextSize = 11
        box.Font = Enum.Font.Gotham; box.BorderSizePixel = 0
        box.ClearTextOnFocus = false; box.ZIndex = 8
        box.Focused:Connect(function()
            if ws and ws.Parent then
                safeTween(ws, TweenInfo.new(0.18), {Color=T.borderHi, Thickness=1.5})
                safeTween(wrap, TweenInfo.new(0.18), {BackgroundColor3=T.inputHov})
            end
        end)
        box.FocusLost:Connect(function()
            if ws and ws.Parent then
                safeTween(ws, TweenInfo.new(0.18), {Color=T.border, Thickness=1})
                safeTween(wrap, TweenInfo.new(0.18), {BackgroundColor3=T.input})
            end
        end)
        return box, wrap
    end
    local function buildPillBar(parent, initialCat, onSelect)
        if not parent or not parent.Parent then return end
        local scroll = Instance.new("ScrollingFrame", parent)
        scroll.Size = UDim2.new(1, 0, 0, 26)
        scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 0; scroll.CanvasSize = UDim2.new(0, 500, 0, 0)
        scroll.ScrollingDirection = Enum.ScrollingDirection.X; scroll.ZIndex = 7
        local layout = Instance.new("UIListLayout", scroll)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 5)
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        local pad = Instance.new("UIPadding", scroll)
        pad.PaddingLeft = UDim.new(0, 1); pad.PaddingTop = UDim.new(0, 1); pad.PaddingBottom = UDim.new(0, 1)
        local btns = {}
        local selected = initialCat
        local function refreshStyles()
            for cat, b in pairs(btns) do
                if b and b.Parent then
                    local on = cat == selected
                    safeTween(b, TweenInfo.new(0.14), { BackgroundColor3 = on and catColors[cat] or T.pill, TextColor3 = on and T.white or T.sub })
                    b.Font = on and Enum.Font.GothamBold or Enum.Font.Gotham
                end
            end
        end
        for i, cat in ipairs(catOrder) do
            local b = Instance.new("TextButton", scroll)
            b.Text = catLabels[cat]; b.AutomaticSize = Enum.AutomaticSize.X; b.Size = UDim2.new(0, 0, 0, 22)
            b.BackgroundColor3 = i == 1 and catColors[cat] or T.pill
            b.TextColor3 = i == 1 and T.white or T.sub
            b.TextSize = 9; b.Font = i == 1 and Enum.Font.GothamBold or Enum.Font.Gotham
            b.BorderSizePixel = 0; b.ZIndex = 9; corner(b, 11)
            local pp = Instance.new("UIPadding", b)
            pp.PaddingLeft = UDim.new(0, 10); pp.PaddingRight = UDim.new(0, 10)
            stroke(b, T.pillBrd, 1); btns[cat] = b
            local cap = cat
            b.MouseButton1Click:Connect(function() selected = cap; refreshStyles(); onSelect(cap) end)
        end
        local function setSelected(cat) selected = cat; refreshStyles() end
        return scroll, btns, setSelected
    end


    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EzyToolboxBetaGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = GuiParent

    local PANEL_W = 320
    local PANEL_H = 480
    local TITLE_H = 44
    local TAB_H = 46
    local BODY_H = 266
    local STATUS_H = 24
    local MIN_W = 260
    local MIN_H = 300

    local panelOpen = false
    local minimized = false
    local MinBtn

    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "MainPanel"
    Main.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    Main.Position = UDim2.new(0.5, -PANEL_W/2, 0.5, -PANEL_H/2)
    Main.BackgroundColor3 = T.panel
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.ClipsDescendants = true
    Main.Visible = false
    Main.ZIndex = 5
    corner(Main, 16)


    local resizeHandle = Instance.new("Frame", Main)
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.new(0, 18, 0, 18)
    resizeHandle.Position = UDim2.new(1, -18, 1, -18)
    resizeHandle.BackgroundColor3 = T.dim
    resizeHandle.BorderSizePixel = 0
    resizeHandle.ZIndex = 50
    corner(resizeHandle, 6)
    resizeHandle.BackgroundTransparency = 0.6
    local resizeIcon = Instance.new("TextLabel", resizeHandle)
    resizeIcon.Size = UDim2.new(1,0,1,0)
    resizeIcon.BackgroundTransparency = 1
    resizeIcon.Text = "â¤،"
    resizeIcon.TextColor3 = T.sub
    resizeIcon.TextSize = 14
    resizeIcon.Font = Enum.Font.GothamBold
    resizeIcon.ZIndex = 51


    local resizing = false
    local resizeStart, startSize
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = Vector2.new(Main.Size.X.Offset, Main.Size.Y.Offset)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newW = math.clamp(startSize.X + delta.X, MIN_W, 600)
            local newH = math.clamp(startSize.Y + delta.Y, MIN_H, 600)
            Main.Size = UDim2.new(0, newW, 0, newH)
            pcall(function()
                local absPos = Main.AbsolutePosition
                local screenSize = game:GetService("Workspace").CurrentCamera.ViewportSize
                if absPos.X + newW > screenSize.X then
                    Main.Position = UDim2.new(0, screenSize.X - newW - 10, Main.Position.Y.Scale, Main.Position.Y.Offset)
                end
                if absPos.Y + newH > screenSize.Y then
                    Main.Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset, 0, screenSize.Y - newH - 10)
                end
            end)
        end
    end)

    local function resetPanelPosition()
        local screenSize = game:GetService("Workspace").CurrentCamera.ViewportSize
        local posX = Main.Position.X.Offset
        local posY = Main.Position.Y.Offset
        local w = Main.Size.X.Offset
        local h = Main.Size.Y.Offset
        if posX + w > screenSize.X or posX < 0 then
            Main.Position = UDim2.new(0.5, -w/2, Main.Position.Y.Scale, Main.Position.Y.Offset)
        end
        if posY + h > screenSize.Y or posY < 0 then
            Main.Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset, 0.5, -h/2)
        end
    end

    local function openPanel()
        if panelOpen then return end
        panelOpen = true
        if Main.Size.X.Offset < MIN_W then Main.Size = UDim2.new(0, PANEL_W, 0, PANEL_H) end
        if Main.Size.Y.Offset < MIN_H then Main.Size = UDim2.new(0, Main.Size.X.Offset, 0, PANEL_H) end
        resetPanelPosition()
        Main.Visible = true
        Main.BackgroundTransparency = 0
        if MinBtn then MinBtn.Text = minimized and "â–،" or "â€”" end
    end

    local function closePanel()
        if not panelOpen then return end
        panelOpen = false
        Main.Visible = false
        Main.BackgroundTransparency = 1
        if Main.Size.X.Offset < MIN_W then Main.Size = UDim2.new(0, PANEL_W, 0, PANEL_H) end
        if Main.Size.Y.Offset < MIN_H then Main.Size = UDim2.new(0, Main.Size.X.Offset, 0, PANEL_H) end
    end

    _G.__EzyToolboxToggle = function()
        if panelOpen then closePanel() else openPanel() end
    end


    local TitleBar = Instance.new("Frame", Main)
    TitleBar.Size = UDim2.new(1, 0, 0, TITLE_H); TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = T.topbar; TitleBar.BorderSizePixel = 0; TitleBar.ZIndex = 6
    corner(TitleBar, 16)

    local topLine = Instance.new("Frame", TitleBar)
    topLine.Size = UDim2.new(1, 0, 0, 2); topLine.BackgroundColor3 = T.accent
    topLine.BorderSizePixel = 0; topLine.ZIndex = 9

    local iconBox = Instance.new("Frame", TitleBar)
    iconBox.Size = UDim2.new(0, 28, 0, 28); iconBox.Position = UDim2.new(0, 10, 0.5, -14)
    iconBox.BackgroundColor3 = T.accent; iconBox.BorderSizePixel = 0; iconBox.ZIndex = 7
    corner(iconBox, 8)
    local iconLbl = Instance.new("TextLabel", iconBox)
    iconLbl.Text = "T"; iconLbl.Size = UDim2.new(1, 0, 1, 0); iconLbl.BackgroundTransparency = 1
    iconLbl.TextColor3 = T.white; iconLbl.TextSize = 14; iconLbl.Font = Enum.Font.GothamBold; iconLbl.ZIndex = 8

    local titleTxt = Instance.new("TextLabel", TitleBar)
    titleTxt.Text = "TOOLBOX"; titleTxt.Size = UDim2.new(0, 90, 0, 16); titleTxt.Position = UDim2.new(0, 46, 0, 6)
    titleTxt.BackgroundTransparency = 1; titleTxt.TextColor3 = T.white; titleTxt.TextSize = 12
    titleTxt.Font = Enum.Font.GothamBold; titleTxt.TextXAlignment = Enum.TextXAlignment.Left; titleTxt.ZIndex = 7

    local betaBadge = Instance.new("Frame", TitleBar)
    betaBadge.Size = UDim2.new(0, 33, 0, 14); betaBadge.Position = UDim2.new(0, 140, 0, 6)
    betaBadge.BackgroundColor3 = T.accentDim; betaBadge.BorderSizePixel = 0; betaBadge.ZIndex = 7
    corner(betaBadge, 6)
    local betaTxt = Instance.new("TextLabel", betaBadge)
    betaTxt.Text = "BETA"; betaTxt.Size = UDim2.new(1, 0, 1, 0); betaTxt.BackgroundTransparency = 1
    betaTxt.TextColor3 = T.accent; betaTxt.TextSize = 9; betaTxt.Font = Enum.Font.GothamBold; betaTxt.ZIndex = 8

    local subTxt = Instance.new("TextLabel", TitleBar)
    subTxt.Text = "by Ezy"; subTxt.Size = UDim2.new(0, 60, 0, 12); subTxt.Position = UDim2.new(0, 46, 0, 24)
    subTxt.BackgroundTransparency = 1; subTxt.TextColor3 = T.sub; subTxt.TextSize = 9
    subTxt.Font = Enum.Font.Gotham; subTxt.TextXAlignment = Enum.TextXAlignment.Left; subTxt.ZIndex = 7


    MinBtn = Instance.new("TextButton", TitleBar)
    MinBtn.Text = "â€”"; MinBtn.Size = UDim2.new(0, 28, 0, 28); MinBtn.Position = UDim2.new(1, -36, 0.5, -14)
    MinBtn.BackgroundColor3 = T.pill; MinBtn.TextColor3 = T.sub; MinBtn.TextSize = 12
    MinBtn.Font = Enum.Font.GothamBold; MinBtn.BorderSizePixel = 0; MinBtn.ZIndex = 8
    corner(MinBtn, 8); stroke(MinBtn, T.pillBrd, 1)
    MinBtn.MouseEnter:Connect(function() safeTween(MinBtn, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(38,36,56), TextColor3=T.white}) end)
    MinBtn.MouseLeave:Connect(function() safeTween(MinBtn, TweenInfo.new(0.12), {BackgroundColor3=T.pill, TextColor3=T.sub}) end)
    MinBtn.MouseButton1Click:Connect(function()
        if not panelOpen then return end
        if minimized then
            minimized = false
            safeTween(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size=UDim2.new(0, Main.Size.X.Offset, 0, Main.Size.Y.Offset) })
            MinBtn.Text = "â€”"
        else
            minimized = true
            safeTween(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size=UDim2.new(0, Main.Size.X.Offset, 0, TITLE_H) })
            MinBtn.Text = "â–،"
        end
    end)


    for _, child in ipairs(TitleBar:GetChildren()) do
        if child:IsA("TextButton") and (child.Text == "X" or child.Text == "âœ•" or child.Name:lower():find("close")) then
            child:Destroy()
        end
    end

    local titleDiv = Instance.new("Frame", TitleBar)
    titleDiv.Size = UDim2.new(1, 0, 0, 1); titleDiv.Position = UDim2.new(0, 0, 1, -1)
    titleDiv.BackgroundColor3 = T.border; titleDiv.BorderSizePixel = 0; titleDiv.ZIndex = 7

    local lastTap = 0
    TitleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            local now = tick()
            if now - lastTap < 0.35 then
                if not panelOpen then return end
                if minimized then
                    minimized = false
                    safeTween(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size=UDim2.new(0, Main.Size.X.Offset, 0, Main.Size.Y.Offset) })
                    MinBtn.Text = "â€”"
                else
                    minimized = true
                    safeTween(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size=UDim2.new(0, Main.Size.X.Offset, 0, TITLE_H) })
                    MinBtn.Text = "â–،"
                end
            end
            lastTap = now
        end
    end)


    local STATUS_Y = TITLE_H + TAB_H + BODY_H
    local StatusBar = Instance.new("Frame", Main)
    StatusBar.Size = UDim2.new(1, 0, 0, STATUS_H); StatusBar.Position = UDim2.new(0, 0, 0, STATUS_Y)
    StatusBar.BackgroundColor3 = T.bg; StatusBar.BorderSizePixel = 0; StatusBar.ZIndex = 6
    corner(StatusBar, 12)

    local stLine = Instance.new("Frame", StatusBar)
    stLine.Size = UDim2.new(1, 0, 0, 1); stLine.BackgroundColor3 = T.border
    stLine.BorderSizePixel = 0; stLine.ZIndex = 7

    local stDot = Instance.new("Frame", StatusBar)
    stDot.Size = UDim2.new(0, 5, 0, 5); stDot.Position = UDim2.new(0, 10, 0.5, -2)
    stDot.BackgroundColor3 = T.green; stDot.BorderSizePixel = 0; stDot.ZIndex = 8; corner(stDot, 3)

    local StatusTxt = Instance.new("TextLabel", StatusBar)
    StatusTxt.Size = UDim2.new(1, -26, 1, 0); StatusTxt.Position = UDim2.new(0, 22, 0, 0)
    StatusTxt.BackgroundTransparency = 1; StatusTxt.TextColor3 = T.sub; StatusTxt.TextSize = 9
    StatusTxt.Font = Enum.Font.Gotham; StatusTxt.TextXAlignment = Enum.TextXAlignment.Left
    StatusTxt.Text = "ًں”چ Ready  â€”  Toolbox by Ezy BETA"
    StatusTxt.ZIndex = 7

    local function setStatus(txt, col)
        StatusTxt.Text = txt; stDot.BackgroundColor3 = col or T.green
    end


    local TabRegion = Instance.new("Frame", Main)
    TabRegion.Size = UDim2.new(1, 0, 0, TAB_H); TabRegion.Position = UDim2.new(0, 0, 0, TITLE_H)
    TabRegion.BackgroundColor3 = T.topbar; TabRegion.BorderSizePixel = 0; TabRegion.ZIndex = 6
    corner(TabRegion, 12)

    local tabDiv = Instance.new("Frame", TabRegion)
    tabDiv.Size = UDim2.new(1, 0, 0, 1); tabDiv.Position = UDim2.new(0, 0, 1, -1)
    tabDiv.BackgroundColor3 = T.border; tabDiv.BorderSizePixel = 0; tabDiv.ZIndex = 7

    local TabWrap = Instance.new("Frame", TabRegion)
    TabWrap.Size = UDim2.new(1, -16, 0, 30); TabWrap.Position = UDim2.new(0, 8, 0, 8)
    TabWrap.BackgroundColor3 = T.bg; TabWrap.BorderSizePixel = 0; TabWrap.ZIndex = 7
    corner(TabWrap, 10); stroke(TabWrap, T.border, 1)
    do
        local tl = Instance.new("UIListLayout", TabWrap)
        tl.FillDirection = Enum.FillDirection.Horizontal; tl.Padding = UDim.new(0, 2)
        local tp = Instance.new("UIPadding", TabWrap)
        tp.PaddingLeft = UDim.new(0, 3); tp.PaddingRight = UDim.new(0, 3)
        tp.PaddingTop = UDim.new(0, 3); tp.PaddingBottom = UDim.new(0, 3)
    end

    local function makeTab(label, active)
        local b = Instance.new("TextButton", TabWrap)
        b.Text = label; b.Size = UDim2.new(0.333, -2, 1, 0)
        b.BackgroundColor3 = active and T.accent or Color3.fromRGB(0, 0, 0)
        b.BackgroundTransparency = active and 0 or 1
        b.TextColor3 = active and T.white or T.sub
        b.TextSize = 10; b.Font = active and Enum.Font.GothamBold or Enum.Font.Gotham
        b.BorderSizePixel = 0; b.ZIndex = 9; corner(b, 8)
        return b
    end
    local TabToolbox = makeTab("Toolbox", true)
    local TabSearch  = makeTab("Search", false)
    local TabInsert  = makeTab("+ ID", false)

    local CONTENT_Y = TITLE_H + TAB_H
    local ContentArea = Instance.new("Frame", Main)
    ContentArea.Size = UDim2.new(1, 0, 0, BODY_H); ContentArea.Position = UDim2.new(0, 0, 0, CONTENT_Y)
    ContentArea.BackgroundTransparency = 1; ContentArea.BorderSizePixel = 0
    ContentArea.ZIndex = 6; ContentArea.ClipsDescendants = true

    local function makePage()
        local f = Instance.new("Frame", ContentArea)
        f.Size = UDim2.new(1, 0, 1, 0); f.Position = UDim2.new(0, 0, 0, 0)
        f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.ZIndex = 6; f.Visible = false
        return f
    end
    local PageToolbox = makePage()
    local PageSearch  = makePage()
    local PageInsert  = makePage()
    PageToolbox.Visible = true

    local currentTab = "toolbox"
    local function switchTab(tab)
        currentTab = tab
        PageToolbox.Visible = tab == "toolbox"
        PageSearch.Visible  = tab == "search"
        PageInsert.Visible  = tab == "insert"
        local map = {toolbox=TabToolbox, search=TabSearch, insert=TabInsert}
        for k, b in pairs(map) do
            local on = k == tab
            b.BackgroundTransparency = on and 0 or 1
            safeTween(b, TweenInfo.new(0.15), { BackgroundColor3 = on and T.accent or Color3.fromRGB(0, 0, 0), TextColor3 = on and T.white or T.sub })
            b.Font = on and Enum.Font.GothamBold or Enum.Font.Gotham
        end
    end
    TabToolbox.MouseButton1Click:Connect(function() switchTab("toolbox") end)
    TabSearch.MouseButton1Click:Connect(function() switchTab("search") end)
    TabInsert.MouseButton1Click:Connect(function() switchTab("insert") end)


    local function doInsert(assetId, assetType)
        local raw = tostring(assetId)
        if assetType == "Sound" then
            return pcall(function()
                local s = Instance.new("Sound"); s.Name = "Sound_"..raw
                s.SoundId = "rbxassetid://"..raw; s.Volume = 0.5; s.Parent = workspace
            end)
        elseif assetType == "Decal" then
            return pcall(function()
                local d = Instance.new("Decal"); d.Name = "Decal_"..raw
                d.Texture = "rbxassetid://"..raw; d.Parent = workspace
            end)
        elseif assetType == "Sky" then
            return pcall(function()
                local l = game:GetService("Lighting")
                for _, c in ipairs(l:GetChildren()) do if c:IsA("Sky") then c:Destroy() end end
                local s = Instance.new("Sky"); s.Name = "Sky_"..raw
                for _, face in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp"}) do
                    s[face] = "rbxassetid://"..raw
                end
                s.Parent = l
            end)
        else
            local ok = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("StudioLiteFolder", 5):WaitForChild("LoadAssetModelToPlayerGuiServerFunction", 5):InvokeServer(assetId)
            end)
            if not ok then return false end
            task.wait(1.5)
            local pgui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
            local folder = pgui:FindFirstChild(raw)
            if folder then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                for _, model in ipairs(folder:GetChildren()) do
                    model.Parent = workspace
                    if hrp then
                        local pp = model.PrimaryPart
                        if not pp then
                            for _, v in ipairs(model:GetDescendants()) do
                                if v:IsA("BasePart") then model.PrimaryPart = v; pp = v; break end
                            end
                        end
                        pcall(function()
                            if pp then model:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, -10))
                            else model:PivotTo(hrp.CFrame * CFrame.new(0, 0, -10)) end
                        end)
                    end
                end
                folder:Destroy(); return true
            end
            return false
        end
    end


    local tbPad = Instance.new("UIPadding", PageToolbox)
    tbPad.PaddingLeft = UDim.new(0, 8); tbPad.PaddingRight = UDim.new(0, 8)
    tbPad.PaddingTop = UDim.new(0, 8); tbPad.PaddingBottom = UDim.new(0, 8)

    local tbSrWrap = Instance.new("Frame", PageToolbox)
    tbSrWrap.Size = UDim2.new(1, 0, 0, 30)
    tbSrWrap.BackgroundColor3 = T.input; tbSrWrap.BorderSizePixel = 0; tbSrWrap.ZIndex = 7
    corner(tbSrWrap, 8); stroke(tbSrWrap, T.border, 1)

    local tbSrHint = Instance.new("TextLabel", tbSrWrap)
    tbSrHint.Text = "ًں”چ Search toolbox..."; tbSrHint.Size = UDim2.new(1, -52, 1, 0); tbSrHint.Position = UDim2.new(0, 10, 0, 0)
    tbSrHint.BackgroundTransparency = 1; tbSrHint.TextColor3 = T.dim; tbSrHint.TextSize = 11
    tbSrHint.Font = Enum.Font.Gotham; tbSrHint.TextXAlignment = Enum.TextXAlignment.Left; tbSrHint.ZIndex = 8

    local tbAddBtn = Instance.new("TextButton", tbSrWrap)
    tbAddBtn.Text = "+ ID"; tbAddBtn.Size = UDim2.new(0, 40, 0, 22); tbAddBtn.Position = UDim2.new(1, -44, 0.5, -11)
    tbAddBtn.TextSize = 9; tbAddBtn.Font = Enum.Font.GothamBold; tbAddBtn.ZIndex = 9
    stylePrimary(tbAddBtn)
    tbAddBtn.MouseButton1Click:Connect(function() switchTab("insert") end)
    for _, obj in ipairs({tbSrWrap, tbSrHint}) do
        obj.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                switchTab("search")
            end
        end)
    end

    local currentCat = "Model"
    local tbCatScroll, tbCatBtns, tbSetCat = buildPillBar(PageToolbox, currentCat, function(cat) currentCat = cat end)
    tbCatScroll.Position = UDim2.new(0, 0, 0, 38)

    local catHint = Instance.new("TextLabel", PageToolbox)
    catHint.Size = UDim2.new(1, 0, 0, 12); catHint.Position = UDim2.new(0, 0, 0, 68)
    catHint.BackgroundTransparency = 1; catHint.TextColor3 = T.sub; catHint.TextSize = 9
    catHint.Font = Enum.Font.Gotham; catHint.TextXAlignment = Enum.TextXAlignment.Left; catHint.ZIndex = 7

    local EmptyLbl = Instance.new("TextLabel", PageToolbox)
    EmptyLbl.Size = UDim2.new(1, 0, 0, 40); EmptyLbl.Position = UDim2.new(0, 0, 0.4, 0)
    EmptyLbl.BackgroundTransparency = 1; EmptyLbl.TextColor3 = T.dim; EmptyLbl.TextSize = 10
    EmptyLbl.Font = Enum.Font.Gotham; EmptyLbl.Text = "Belum ada asset.\nTambah via Search atau + ID"
    EmptyLbl.TextWrapped = true; EmptyLbl.Visible = false; EmptyLbl.ZIndex = 7

    local SCROLL_TOP = 82
    local SCROLL_H = BODY_H - SCROLL_TOP - 8

    local ToolboxScroll = Instance.new("ScrollingFrame", PageToolbox)
    ToolboxScroll.Size = UDim2.new(1, 0, 0, SCROLL_H); ToolboxScroll.Position = UDim2.new(0, 0, 0, SCROLL_TOP)
    ToolboxScroll.BackgroundTransparency = 1; ToolboxScroll.BorderSizePixel = 0
    ToolboxScroll.ScrollBarThickness = 2; ToolboxScroll.ScrollBarImageColor3 = T.accent
    ToolboxScroll.CanvasSize = UDim2.new(0, 0, 0, 0); ToolboxScroll.ZIndex = 7
    corner(ToolboxScroll, 8)
    do
        local ll = Instance.new("UIListLayout", ToolboxScroll); ll.Padding = UDim.new(0, 4)
        local lp = Instance.new("UIPadding", ToolboxScroll); lp.PaddingBottom = UDim.new(0, 4)
    end

    local function rebuildToolbox()
        for _, c in ipairs(ToolboxScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        local list = SavedAssets[currentCat] or {}
        catHint.Text = catLabels[currentCat].."  آ·  "..#list.." item"
        EmptyLbl.Visible = #list == 0
        for i, asset in ipairs(list) do
            local card = Instance.new("Frame", ToolboxScroll)
            card.Size = UDim2.new(1, -2, 0, 62)
            card.BackgroundColor3 = T.card
            card.BorderSizePixel = 0
            card.LayoutOrder = i
            card.ZIndex = 8
            corner(card, 10)
            stroke(card, T.border, 1)

            local strip = Instance.new("Frame", card)
            strip.Size = UDim2.new(0, 3, 0, 34); strip.Position = UDim2.new(0, 0, 0.5, -17)
            strip.BackgroundColor3 = catColors[currentCat] or T.accent; strip.BorderSizePixel = 0; strip.ZIndex = 9; corner(strip, 4)

            local thumbBg = Instance.new("Frame", card)
            thumbBg.Size = UDim2.new(0, 48, 0, 48); thumbBg.Position = UDim2.new(0, 10, 0.5, -24)
            thumbBg.BackgroundColor3 = T.bg; thumbBg.BorderSizePixel = 0; thumbBg.ZIndex = 9
            corner(thumbBg, 8); stroke(thumbBg, T.border, 1)
            local thumb = Instance.new("ImageLabel", thumbBg)
            thumb.Size = UDim2.new(1, 0, 1, 0); thumb.BackgroundTransparency = 1
            thumb.Image = "rbxthumb://type=Asset&id="..asset.id.."&w=150&h=150"
            thumb.ScaleType = Enum.ScaleType.Fit; thumb.ZIndex = 10

            local nameLbl = Instance.new("TextLabel", card)
            nameLbl.Size = UDim2.new(1, -152, 0, 14); nameLbl.Position = UDim2.new(0, 65, 0, 10)
            nameLbl.BackgroundTransparency = 1; nameLbl.TextColor3 = T.white; nameLbl.TextSize = 11
            nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd; nameLbl.Text = asset.name; nameLbl.ZIndex = 9

            local idLbl = Instance.new("TextLabel", card)
            idLbl.Size = UDim2.new(1, -152, 0, 11); idLbl.Position = UDim2.new(0, 65, 0, 26)
            idLbl.BackgroundTransparency = 1; idLbl.TextColor3 = T.dim; idLbl.TextSize = 9
            idLbl.Font = Enum.Font.Gotham; idLbl.TextXAlignment = Enum.TextXAlignment.Left
            idLbl.Text = "ID آ· "..asset.id; idLbl.ZIndex = 9

            local cpBtn = Instance.new("TextButton", card)
            cpBtn.Text = "COPY"; cpBtn.Size = UDim2.new(0, 44, 0, 18); cpBtn.Position = UDim2.new(1, -98, 0, 8)
            cpBtn.TextSize = 9; cpBtn.Font = Enum.Font.GothamBold; cpBtn.ZIndex = 9; styleSecondary(cpBtn)

            local iBtn = Instance.new("TextButton", card)
            iBtn.Text = "Insert"; iBtn.Size = UDim2.new(0, 56, 0, 22); iBtn.Position = UDim2.new(1, -62, 0, 30)
            iBtn.TextSize = 10; iBtn.Font = Enum.Font.GothamBold; iBtn.ZIndex = 9; stylePrimary(iBtn)

            local dBtn = Instance.new("TextButton", card)
            dBtn.Text = "أ—"; dBtn.Size = UDim2.new(0, 16, 0, 16); dBtn.Position = UDim2.new(1, -20, 0, 4)
            dBtn.BackgroundTransparency = 1; dBtn.TextColor3 = T.dim; dBtn.TextSize = 14
            dBtn.Font = Enum.Font.GothamBold; dBtn.BorderSizePixel = 0; dBtn.ZIndex = 10
            corner(dBtn, 4)
            dBtn.MouseEnter:Connect(function() if dBtn and dBtn.Parent then safeTween(dBtn, TweenInfo.new(0.1), {TextColor3=T.red}) end end)
            dBtn.MouseLeave:Connect(function() if dBtn and dBtn.Parent then safeTween(dBtn, TweenInfo.new(0.1), {TextColor3=T.dim}) end end)

            card.MouseEnter:Connect(function() if card and card.Parent then safeTween(card, TweenInfo.new(0.12), {BackgroundColor3=T.cardHov}) end end)
            card.MouseLeave:Connect(function() if card and card.Parent then safeTween(card, TweenInfo.new(0.12), {BackgroundColor3=T.card}) end end)

            local capId = asset.id; local capCat = currentCat
            cpBtn.MouseButton1Click:Connect(function()
                pcall(function() setclipboard(tostring(asset.id)) end)
                cpBtn.Text = "âœ“ OK"; cpBtn.TextColor3 = T.green
                task.wait(1.2); cpBtn.Text = "COPY"; cpBtn.TextColor3 = T.sub
            end)
            iBtn.MouseButton1Click:Connect(function()
                iBtn.Text = "..."; iBtn.Active = false
                setStatus("Inserting "..asset.name.."...", T.yellow)
                task.spawn(function()
                    local t2 = capCat == "SumMitKit" and "Model" or capCat
                    local ok = doInsert(capId, t2)
                    iBtn.Text = ok and "Done!" or "Gagal"
                    setStatus(ok and "Insert berhasil!" or "Gagal insert", ok and T.green or T.red)
                    task.wait(1.5); iBtn.Text = "Insert"; iBtn.Active = true
                    setStatus("ًں”چ Ready  â€”  Toolbox by Ezy BETA", T.green)
                end)
            end)
            dBtn.MouseButton1Click:Connect(function()
                Deleted[capCat.."_"..tostring(capId)] = true
                for idx, a in ipairs(SavedAssets[capCat]) do
                    if a.id == capId then table.remove(SavedAssets[capCat], idx); break end
                end
                persistSave()
                rebuildToolbox()
            end)
        end
        ToolboxScroll.CanvasSize = UDim2.new(0, 0, 0, #list * 66)
    end

    local function selectCat(cat)
        currentCat = cat; tbSetCat(cat); rebuildToolbox()
    end
    for _, cat in ipairs(catOrder) do
        local cap = cat
        tbCatBtns[cap].MouseButton1Click:Connect(function() selectCat(cap) end)
    end


    local srPad = Instance.new("UIPadding", PageSearch)
    srPad.PaddingLeft = UDim.new(0, 8); srPad.PaddingRight = UDim.new(0, 8)
    srPad.PaddingTop = UDim.new(0, 8); srPad.PaddingBottom = UDim.new(0, 8)

    local srWrap = Instance.new("Frame", PageSearch)
    srWrap.Size = UDim2.new(1, 0, 0, 30); srWrap.Position = UDim2.new(0, 0, 0, 0)
    srWrap.BackgroundColor3 = T.input; srWrap.BorderSizePixel = 0; srWrap.ZIndex = 7
    -- [P10] srStroke is now defined (it was referenced below but never declared)
    corner(srWrap, 8); local srStroke = stroke(srWrap, T.border, 1)

    local SearchBox = Instance.new("TextBox", srWrap)
    SearchBox.PlaceholderText = "ًں”چ Search Roblox catalog..."; SearchBox.Text = ""
    SearchBox.Size = UDim2.new(1, -76, 1, 0); SearchBox.Position = UDim2.new(0, 10, 0, 0)
    SearchBox.BackgroundTransparency = 1; SearchBox.TextColor3 = T.white
    SearchBox.PlaceholderColor3 = T.dim; SearchBox.TextSize = 11
    SearchBox.Font = Enum.Font.Gotham; SearchBox.BorderSizePixel = 0
    SearchBox.ClearTextOnFocus = false; SearchBox.ZIndex = 8
    SearchBox.Focused:Connect(function()
        if srStroke and srStroke.Parent then
            safeTween(srStroke, TweenInfo.new(0.18), {Color=T.borderHi, Thickness=1.5})
            safeTween(srWrap, TweenInfo.new(0.18), {BackgroundColor3=T.inputHov})
        end
    end)
    SearchBox.FocusLost:Connect(function()
        if srStroke and srStroke.Parent then
            safeTween(srStroke, TweenInfo.new(0.18), {Color=T.border, Thickness=1})
            safeTween(srWrap, TweenInfo.new(0.18), {BackgroundColor3=T.input})
        end
    end)

    local SearchBtn = Instance.new("TextButton", srWrap)
    SearchBtn.Text = "ًں”چ Search"; SearchBtn.Size = UDim2.new(0, 58, 0, 22); SearchBtn.Position = UDim2.new(1, -62, 0.5, -11)
    SearchBtn.TextSize = 9; SearchBtn.Font = Enum.Font.GothamBold; SearchBtn.ZIndex = 9
    stylePrimary(SearchBtn)

    local selectedSaveCat = "Model"
    local srCatScroll, srCatBtns, srSetCat = buildPillBar(PageSearch, selectedSaveCat, function(cat) selectedSaveCat = cat end)
    srCatScroll.Position = UDim2.new(0, 0, 0, 36)

    local SearchStatus = Instance.new("TextLabel", PageSearch)
    SearchStatus.Size = UDim2.new(1, 0, 0, 12); SearchStatus.Position = UDim2.new(0, 0, 0, 66)
    SearchStatus.BackgroundTransparency = 1; SearchStatus.TextColor3 = T.sub; SearchStatus.TextSize = 9
    SearchStatus.Font = Enum.Font.Gotham; SearchStatus.TextXAlignment = Enum.TextXAlignment.Left
    SearchStatus.Text = "?? Pilih kategori, lalu ketik dan search"; SearchStatus.ZIndex = 7

    local SR_SCROLL_H = BODY_H - 80 - 8
    local ResultScroll = Instance.new("ScrollingFrame", PageSearch)
    ResultScroll.Size = UDim2.new(1, 0, 0, SR_SCROLL_H); ResultScroll.Position = UDim2.new(0, 0, 0, 80)
    ResultScroll.BackgroundTransparency = 1; ResultScroll.BorderSizePixel = 0
    ResultScroll.ScrollBarThickness = 2; ResultScroll.ScrollBarImageColor3 = T.accent
    ResultScroll.CanvasSize = UDim2.new(0, 0, 0, 0); ResultScroll.ZIndex = 7
    corner(ResultScroll, 8)
    do Instance.new("UIListLayout", ResultScroll).Padding = UDim.new(0, 4) end

    local function buildResultCard(item)
        local card = Instance.new("Frame", ResultScroll)
        card.Size = UDim2.new(1, -2, 0, 62)
        card.BackgroundColor3 = T.card
        card.BorderSizePixel = 0
        card.ZIndex = 8
        corner(card, 10)
        stroke(card, T.border, 1)

        local strip = Instance.new("Frame", card)
        strip.Size = UDim2.new(0, 3, 0, 34); strip.Position = UDim2.new(0, 0, 0.5, -17)
        strip.BackgroundColor3 = catColors[selectedSaveCat] or T.accent; strip.BorderSizePixel = 0; strip.ZIndex = 9; corner(strip, 4)

        local thumbBg = Instance.new("Frame", card)
        thumbBg.Size = UDim2.new(0, 48, 0, 48); thumbBg.Position = UDim2.new(0, 10, 0.5, -24)
        thumbBg.BackgroundColor3 = T.bg; thumbBg.BorderSizePixel = 0; thumbBg.ZIndex = 9
        corner(thumbBg, 8); stroke(thumbBg, T.border, 1)
        local thumb = Instance.new("ImageLabel", thumbBg)
        thumb.Size = UDim2.new(1, 0, 1, 0); thumb.BackgroundTransparency = 1
        thumb.Image = "rbxthumb://type=Asset&id="..item.id.."&w=150&h=150"
        thumb.ScaleType = Enum.ScaleType.Fit; thumb.ZIndex = 10

        local nLbl = Instance.new("TextLabel", card)
        nLbl.Size = UDim2.new(1, -160, 0, 14); nLbl.Position = UDim2.new(0, 65, 0, 10)
        nLbl.BackgroundTransparency = 1; nLbl.TextColor3 = T.white; nLbl.TextSize = 11
        nLbl.Font = Enum.Font.GothamBold; nLbl.TextXAlignment = Enum.TextXAlignment.Left
        nLbl.TextTruncate = Enum.TextTruncate.AtEnd; nLbl.Text = item.name; nLbl.ZIndex = 9

        local iLbl = Instance.new("TextLabel", card)
        iLbl.Size = UDim2.new(1, -160, 0, 11); iLbl.Position = UDim2.new(0, 65, 0, 26)
        iLbl.BackgroundTransparency = 1; iLbl.TextColor3 = T.dim; iLbl.TextSize = 9
        iLbl.Font = Enum.Font.Gotham; iLbl.TextXAlignment = Enum.TextXAlignment.Left
        iLbl.Text = "ًں”چ ID آ· "..item.id; iLbl.ZIndex = 9

        local cpBtn = Instance.new("TextButton", card)
        cpBtn.Text = "COPY"; cpBtn.Size = UDim2.new(0, 44, 0, 18); cpBtn.Position = UDim2.new(1, -98, 0, 8)
        cpBtn.TextSize = 9; cpBtn.Font = Enum.Font.GothamBold; cpBtn.ZIndex = 9; styleSecondary(cpBtn)

        local sBtn = Instance.new("TextButton", card)
        sBtn.Text = "ًں’¾ Save"; sBtn.Size = UDim2.new(0, 44, 0, 18); sBtn.Position = UDim2.new(1, -98, 0, 30)
        sBtn.BackgroundColor3 = T.greenDark; sBtn.TextColor3 = T.green; sBtn.TextSize = 9
        sBtn.Font = Enum.Font.GothamBold; sBtn.BorderSizePixel = 0; sBtn.ZIndex = 9
        corner(sBtn, 6)

        local iBtn = Instance.new("TextButton", card)
        iBtn.Text = "ًں“¥ Insert"; iBtn.Size = UDim2.new(0, 50, 0, 40); iBtn.Position = UDim2.new(1, -56, 0.5, -20)
        iBtn.TextSize = 10; iBtn.Font = Enum.Font.GothamBold; iBtn.ZIndex = 9
        stylePrimary(iBtn); corner(iBtn, 8)

        card.MouseEnter:Connect(function() if card and card.Parent then safeTween(card, TweenInfo.new(0.12), {BackgroundColor3=T.cardHov}) end end)
        card.MouseLeave:Connect(function() if card and card.Parent then safeTween(card, TweenInfo.new(0.12), {BackgroundColor3=T.card}) end end)

        local capId = item.id; local capName = item.name
        cpBtn.MouseButton1Click:Connect(function()
            pcall(function() setclipboard(tostring(item.id)) end)
            cpBtn.Text = "âœ“ OK"; cpBtn.TextColor3 = T.green
            task.wait(1.2); cpBtn.Text = "COPY"; cpBtn.TextColor3 = T.sub
        end)
        iBtn.MouseButton1Click:Connect(function()
            iBtn.Text = "..."; iBtn.Active = false
            task.spawn(function()
                local t2 = selectedSaveCat == "SumMitKit" and "Model" or selectedSaveCat
                local ok = doInsert(capId, t2)
                iBtn.Text = ok and "âœ… Done!" or "â‌Œ Gagal"; task.wait(1.5); iBtn.Text = "ًں“¥ Insert"; iBtn.Active = true
            end)
        end)
        sBtn.MouseButton1Click:Connect(function()
            if not SavedAssets[selectedSaveCat] then SavedAssets[selectedSaveCat] = {} end
            for _, a in ipairs(SavedAssets[selectedSaveCat]) do
                if a.id == capId then
                    SearchStatus.Text = "ًں”چ Sudah ada di "..catLabels[selectedSaveCat]; SearchStatus.TextColor3 = T.yellow; return
                end
            end
            Deleted[selectedSaveCat.."_"..tostring(capId)] = nil
            table.insert(SavedAssets[selectedSaveCat], {id=capId, name=capName})
            persistSave()
            SearchStatus.Text = "ًں’¾ Disimpan ke "..catLabels[selectedSaveCat]; SearchStatus.TextColor3 = T.green
            if card and card.Parent then
                safeTween(card, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(12,42,28)})
                task.wait(0.35)
                safeTween(card, TweenInfo.new(0.2), {BackgroundColor3=T.card})
            end
        end)
    end

    local isSearching = false
    local function doSearch(keyword)
        if isSearching or keyword == "" then return end
        isSearching = true; SearchBtn.Text = "âڈ³..."; SearchBtn.Active = false
        SearchStatus.Text = "ًں”چ Mencari '"..keyword.."'..."; SearchStatus.TextColor3 = T.sub
        for _, c in ipairs(ResultScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        ResultScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

        task.spawn(function()
            local results = searchAssets(selectedSaveCat, keyword)
            if #results == 0 then
                SearchStatus.Text = "ًں”چ Tidak ada hasil."
                SearchStatus.TextColor3 = T.dim
            else
                SearchStatus.Text = "ًں”چ "..#results.." hasil  آ·  klik Save untuk simpan"
                SearchStatus.TextColor3 = T.sub
                for _, item in ipairs(results) do
                    buildResultCard(item)
                end
                ResultScroll.CanvasSize = UDim2.new(0, 0, 0, #results * 66)
            end
            SearchBtn.Text = "ًں”چ Search"; SearchBtn.Active = true; isSearching = false
        end)
    end

    SearchBtn.MouseButton1Click:Connect(function() doSearch(SearchBox.Text) end)
    SearchBox.FocusLost:Connect(function(enter) if enter then doSearch(SearchBox.Text) end end)


    local insPad = Instance.new("UIPadding", PageInsert)
    insPad.PaddingLeft = UDim.new(0, 8); insPad.PaddingRight = UDim.new(0, 8)
    insPad.PaddingTop = UDim.new(0, 8); insPad.PaddingBottom = UDim.new(0, 8)

    local insCatLbl = Instance.new("TextLabel", PageInsert)
    insCatLbl.Text = "ًں“‚ KATEGORI"; insCatLbl.Size = UDim2.new(1, 0, 0, 10); insCatLbl.Position = UDim2.new(0, 0, 0, 0)
    insCatLbl.BackgroundTransparency = 1; insCatLbl.TextColor3 = T.sub; insCatLbl.TextSize = 9
    insCatLbl.Font = Enum.Font.GothamBold; insCatLbl.TextXAlignment = Enum.TextXAlignment.Left; insCatLbl.ZIndex = 7

    local selectedInsCat = "Model"
    local insCatScroll, insCatBtns, insSetCat = buildPillBar(PageInsert, selectedInsCat, function(cat) selectedInsCat = cat end)
    insCatScroll.Position = UDim2.new(0, 0, 0, 12)

    local insIdLbl = Instance.new("TextLabel", PageInsert)
    insIdLbl.Text = "ًں†” ASSET ID"; insIdLbl.Size = UDim2.new(1, 0, 0, 10); insIdLbl.Position = UDim2.new(0, 0, 0, 44)
    insIdLbl.BackgroundTransparency = 1; insIdLbl.TextColor3 = T.sub; insIdLbl.TextSize = 9
    insIdLbl.Font = Enum.Font.GothamBold; insIdLbl.TextXAlignment = Enum.TextXAlignment.Left; insIdLbl.ZIndex = 7

    local IdInput, idWrap = mkInput(PageInsert, "ًں”¢ Masukkan Asset ID", 30)
    idWrap.Position = UDim2.new(0, 0, 0, 56)

    local previewRow = Instance.new("Frame", PageInsert)
    previewRow.Size = UDim2.new(1, 0, 0, 70); previewRow.Position = UDim2.new(0, 0, 0, 94)
    previewRow.BackgroundTransparency = 1; previewRow.BorderSizePixel = 0; previewRow.ZIndex = 7

    local thumbWrap = Instance.new("Frame", previewRow)
    thumbWrap.Size = UDim2.new(0, 68, 0, 68); thumbWrap.Position = UDim2.new(0, 0, 0, 0)
    thumbWrap.BackgroundColor3 = T.bg; thumbWrap.BorderSizePixel = 0; thumbWrap.ZIndex = 8
    corner(thumbWrap, 10); stroke(thumbWrap, T.border, 1)

    local thumbImg = Instance.new("ImageLabel", thumbWrap)
    thumbImg.Size = UDim2.new(1, -8, 1, -8); thumbImg.Position = UDim2.new(0, 4, 0, 4)
    thumbImg.BackgroundTransparency = 1; thumbImg.Image = ""; thumbImg.ScaleType = Enum.ScaleType.Fit; thumbImg.ZIndex = 9
    local thumbHint = Instance.new("TextLabel", thumbWrap)
    thumbHint.Size = UDim2.new(1, 0, 1, 0); thumbHint.BackgroundTransparency = 1
    thumbHint.Text = "â‌“"; thumbHint.TextColor3 = T.dim
    thumbHint.TextSize = 22; thumbHint.Font = Enum.Font.GothamBold; thumbHint.ZIndex = 9

    local nameBox = Instance.new("Frame", previewRow)
    nameBox.Size = UDim2.new(1, -76, 0, 68); nameBox.Position = UDim2.new(0, 76, 0, 0)
    nameBox.BackgroundColor3 = T.input; nameBox.BorderSizePixel = 0; nameBox.ZIndex = 8
    corner(nameBox, 8); stroke(nameBox, T.border, 1)

    local nameBoxLbl = Instance.new("TextLabel", nameBox)
    nameBoxLbl.Text = "ًں“› NAMA ASSET"; nameBoxLbl.Size = UDim2.new(1, -10, 0, 12); nameBoxLbl.Position = UDim2.new(0, 8, 0, 6)
    nameBoxLbl.BackgroundTransparency = 1; nameBoxLbl.TextColor3 = T.sub; nameBoxLbl.TextSize = 9
    nameBoxLbl.Font = Enum.Font.GothamBold; nameBoxLbl.TextXAlignment = Enum.TextXAlignment.Left; nameBoxLbl.ZIndex = 9

    local NameLbl = Instance.new("TextLabel", nameBox)
    NameLbl.Size = UDim2.new(1, -10, 0, 30); NameLbl.Position = UDim2.new(0, 8, 0, 22)
    NameLbl.BackgroundTransparency = 1; NameLbl.TextColor3 = T.sub; NameLbl.TextSize = 10
    NameLbl.Font = Enum.Font.Gotham; NameLbl.TextXAlignment = Enum.TextXAlignment.Left
    NameLbl.TextWrapped = true; NameLbl.Text = "â€”"; NameLbl.ZIndex = 9

    local insInfoLbl = Instance.new("TextLabel", nameBox)
    insInfoLbl.Size = UDim2.new(1, -10, 0, 10); insInfoLbl.Position = UDim2.new(0, 8, 1, -14)
    insInfoLbl.BackgroundTransparency = 1; insInfoLbl.TextColor3 = T.dim; insInfoLbl.TextSize = 9
    insInfoLbl.Font = Enum.Font.Gotham; insInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
    insInfoLbl.Text = "ًں”چ Isi ID untuk preview"; insInfoLbl.ZIndex = 9

    local lastId = ""
    local function fetchName(id)
        local ok, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(tonumber(id)) end)
        return (ok and info and info.Name) and info.Name or ("Asset "..id)
    end

    IdInput:GetPropertyChangedSignal("Text"):Connect(function()
        local id = IdInput.Text:match("%d+")
        if id and #id > 3 then
            thumbImg.Image = "rbxthumb://type=Asset&id="..id.."&w=150&h=150"; thumbHint.Visible = false
            if id ~= lastId then
                lastId = id; NameLbl.Text = "âڈ³ Loading..."; NameLbl.TextColor3 = T.sub; insInfoLbl.Text = "ًں†” ID: "..id
                task.spawn(function()
                    local n = fetchName(id)
                    if lastId == id then
                        NameLbl.Text = n; NameLbl.TextColor3 = T.white
                        insInfoLbl.Text = "âœ… Siap diinsert atau disimpan"; insInfoLbl.TextColor3 = T.green
                    end
                end)
            end
        else
            thumbImg.Image = ""; thumbHint.Visible = true
            NameLbl.Text = "â€”"; NameLbl.TextColor3 = T.sub
            insInfoLbl.Text = "ًں”چ Isi ID untuk preview"; insInfoLbl.TextColor3 = T.dim; lastId = ""
        end
    end)

    local InsStatusLbl = Instance.new("TextLabel", PageInsert)
    InsStatusLbl.Size = UDim2.new(1, 0, 0, 13); InsStatusLbl.Position = UDim2.new(0, 0, 0, 170)
    InsStatusLbl.BackgroundTransparency = 1; InsStatusLbl.TextColor3 = T.sub; InsStatusLbl.TextSize = 9
    InsStatusLbl.Font = Enum.Font.Gotham; InsStatusLbl.TextWrapped = true
    InsStatusLbl.TextXAlignment = Enum.TextXAlignment.Left; InsStatusLbl.ZIndex = 7
    InsStatusLbl.Text = "ًں”¢ Masukkan ID lalu pilih Insert atau Save"

    local function setInsStatus(txt, col) InsStatusLbl.Text = txt; InsStatusLbl.TextColor3 = col or T.sub end

    local InsertBtn = Instance.new("TextButton", PageInsert)
    InsertBtn.Text = "ًں“¥ Insert ke Workspace"; InsertBtn.Size = UDim2.new(1, 0, 0, 32); InsertBtn.Position = UDim2.new(0, 0, 0, 188)
    InsertBtn.TextSize = 11; InsertBtn.Font = Enum.Font.GothamBold; InsertBtn.ZIndex = 7
    stylePrimary(InsertBtn); corner(InsertBtn, 8)

    local SaveBtn = Instance.new("TextButton", PageInsert)
    SaveBtn.Text = "ًں’¾ Simpan ke Toolbox"; SaveBtn.Size = UDim2.new(1, 0, 0, 28); SaveBtn.Position = UDim2.new(0, 0, 0, 226)
    SaveBtn.BackgroundColor3 = T.greenDark; SaveBtn.TextColor3 = T.green; SaveBtn.TextSize = 11
    SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.BorderSizePixel = 0; SaveBtn.ZIndex = 7
    corner(SaveBtn, 8); stroke(SaveBtn, Color3.fromRGB(22, 68, 44), 1)
    SaveBtn.MouseEnter:Connect(function()
        if SaveBtn and SaveBtn.Parent then safeTween(SaveBtn, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(18,62,40), TextColor3=Color3.fromRGB(78,218,138)}) end
    end)
    SaveBtn.MouseLeave:Connect(function()
        if SaveBtn and SaveBtn.Parent then safeTween(SaveBtn, TweenInfo.new(0.12), {BackgroundColor3=T.greenDark, TextColor3=T.green}) end
    end)

    local persistNote = Instance.new("Frame", PageInsert)
    persistNote.Size = UDim2.new(1, 0, 0, 22); persistNote.Position = UDim2.new(0, 0, 0, 260)
    persistNote.BackgroundColor3 = Color3.fromRGB(10, 20, 14); persistNote.BorderSizePixel = 0; persistNote.ZIndex = 7
    corner(persistNote, 8); stroke(persistNote, Color3.fromRGB(20, 46, 30), 1)
    local persistTxt = Instance.new("TextLabel", persistNote)
    persistTxt.Size = UDim2.new(1, -12, 1, 0); persistTxt.Position = UDim2.new(0, 7, 0, 0)
    persistTxt.BackgroundTransparency = 1; persistTxt.TextColor3 = Color3.fromRGB(60, 140, 88)
    persistTxt.TextSize = 9.5; persistTxt.Font = Enum.Font.Gotham
    persistTxt.Text = "ًں“‚ Data tersimpan permanen di EzyToolbox_Data.json"
    persistTxt.TextWrapped = true; persistTxt.TextXAlignment = Enum.TextXAlignment.Left; persistTxt.ZIndex = 8

    InsertBtn.MouseButton1Click:Connect(function()
        local raw = IdInput.Text:match("%d+")
        if not raw then setInsStatus("â‌Œ ID tidak valid!", T.yellow); return end
        InsertBtn.Text = "âڈ³ Loading..."; InsertBtn.Active = false
        setInsStatus("ًں“¥ Inserting "..raw.."...", T.sub); setStatus("ًں“¥ Inserting "..raw.."...", T.yellow)
        task.spawn(function()
            local t2 = selectedInsCat == "SumMitKit" and "Model" or selectedInsCat
            local ok = doInsert(tonumber(raw), t2)
            setInsStatus(ok and "âœ… Berhasil insert!" or "â‌Œ Gagal insert", ok and T.green or T.red)
            setStatus(ok and "âœ… Insert berhasil!" or "â‌Œ Gagal insert", ok and T.green or T.red)
            InsertBtn.Text = "ًں“¥ Insert ke Workspace"; InsertBtn.Active = true
            task.wait(2); setStatus("ًں”چ Ready  â€”  Toolbox by Ezy BETA", T.green)
        end)
    end)

    SaveBtn.MouseButton1Click:Connect(function()
        local raw = IdInput.Text:match("%d+")
        if not raw then setInsStatus("â‌Œ ID tidak valid!", T.yellow); return end
        if not SavedAssets[selectedInsCat] then SavedAssets[selectedInsCat] = {} end
        for _, a in ipairs(SavedAssets[selectedInsCat]) do
            if tostring(a.id) == raw then setInsStatus("âڑ ï¸ڈ Sudah ada di "..catLabels[selectedInsCat].."!", T.yellow); return end
        end
        Deleted[selectedInsCat.."_"..raw] = nil
        local name = NameLbl.Text
        if name == "â€”" or name:find("Loading") then name = "Asset "..raw end
        table.insert(SavedAssets[selectedInsCat], {id=tonumber(raw), name=name})
        persistSave()
        setInsStatus("ًں’¾ Disimpan ke "..catLabels[selectedInsCat].."!", T.green)
        switchTab("toolbox"); selectCat(selectedInsCat)
    end)

    rebuildToolbox()
    print("[TOOLBOX BY EZY] Loaded.")
end


task.spawn(function()
    local function findMusicToggle()
        local function search(parent)
            if not parent then return nil end
            for _, child in ipairs(parent:GetDescendants()) do
                if child:IsA("TextButton") and child.Text == "ًںژµ" then
                    return child
                end
            end
            return nil
        end
        local core = game:GetService("CoreGui")
        local btn = search(core)
        if btn then return btn end
        local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            btn = search(pg)
            if btn then return btn end
        end
        return nil
    end

    local function createStyledToggle()
        if _G.__EzyToggleBtnFixed then return end
        local target = findMusicToggle()
        if not target then
            task.wait(0.5)
            createStyledToggle()
            return
        end

        local parent = target.Parent
        if not parent then return end
        local old = parent:FindFirstChild("EzyToolboxToggleBtn")
        if old then old:Destroy() end

        local newBtn = Instance.new("TextButton")
        newBtn.Name = "EzyToolboxToggleBtn"
        newBtn.Size = target.Size
        newBtn.Position = UDim2.new(
            target.Position.X.Scale, target.Position.X.Offset,
            target.Position.Y.Scale, target.Position.Y.Offset - target.Size.Y.Offset - 4
        )
        newBtn.BackgroundColor3 = target.BackgroundColor3
        newBtn.TextColor3 = target.TextColor3
        newBtn.Text = "ًں“¤"
        newBtn.TextSize = target.TextSize
        newBtn.Font = target.Font
        newBtn.BorderSizePixel = target.BorderSizePixel
        newBtn.ZIndex = target.ZIndex + 1
        newBtn.Parent = parent
        newBtn.AutoButtonColor = target.AutoButtonColor

        local corner = target:FindFirstChildOfClass("UICorner")
        if corner then
            local newCorner = Instance.new("UICorner", newBtn)
            newCorner.CornerRadius = corner.CornerRadius
        else
            local c = Instance.new("UICorner", newBtn)
            c.CornerRadius = UDim.new(0, 10)
        end

        local stroke = target:FindFirstChildOfClass("UIStroke")
        if stroke then
            local newStroke = Instance.new("UIStroke", newBtn)
            newStroke.Color = stroke.Color
            newStroke.Thickness = stroke.Thickness
            newStroke.Transparency = stroke.Transparency
        else
            local s = Instance.new("UIStroke", newBtn)
            s.Color = Color3.fromRGB(0,150,230)
            s.Thickness = 1.5
        end

        newBtn.MouseEnter:Connect(function()
            newBtn.BackgroundColor3 = Color3.fromRGB(30,32,35)
        end)
        newBtn.MouseLeave:Connect(function()
            newBtn.BackgroundColor3 = target.BackgroundColor3
        end)

        newBtn.MouseButton1Click:Connect(function()
            if _G.__EzyToolboxToggle then
                _G.__EzyToolboxToggle()
            else
                warn("[Ezy] Toolbox belum dimuat")
            end
        end)

        _G.__EzyToggleBtnFixed = true
        print("[Ezy] Tombol ًں“¤ siap di atas ًںژµ (Music Player).")
    end

    task.wait(2)
    createStyledToggle()
end)


task.spawn(function()
    task.wait(0.5)
    loadEzyToolbox()
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


    -- [P8] per-frame scan throttled to ~20 times/second
    local scanAcc = 0
    RunService.RenderStepped:Connect(function(dt)
        scanAcc = scanAcc + dt
        if scanAcc < 0.05 then return end
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


    task.spawn(function()
        while true do
            task.wait(0.1)
            if explorer then
                for _, obj in ipairs(explorer:GetDescendants()) do
                    if obj:IsA("GuiObject") then
                        lockHighlight(obj)
                    end
                end
            else
                findExplorer()
            end
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

    print("âœ… EXPLORER HIGHLIGHT SOLID (WARNA BAWAAN, HANYA EXPLORER)")
end)
print(" PLUGINS EZY CRACKED ITSMEELANGZZ")

print("âœ… STUDIO LITE BY EZY LOADED | by EZY |Cracked By ItsmeeLangzz ")
-- ===================== PART 5 of 5 : END (end of script) =====================