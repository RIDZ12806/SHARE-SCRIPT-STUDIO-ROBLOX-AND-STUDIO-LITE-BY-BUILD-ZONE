-- TERRAIN TOOLS BY WYZ VERSE | VERSI STUDIO LITE
-- Cara pakai: taruh script ini sebagai LocalScript (client) di Studio Lite lalu Run.
print("[Terrain Tools] by Wyz Verse (Studio Lite)")

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local GuiService=game:GetService("GuiService")
local player=Players.LocalPlayer
if not player then
	warn("[Terrain Tools] Script ini harus berupa LocalScript (client), bukan Script biasa.")
	return
end
local mouse=player:GetMouse()
local Terrain=workspace.Terrain
local C=Color3.fromRGB

-- ===== WHITELIST (hanya username owner) =====
local ENABLE_WHITELIST=true
local AUTHORIZED={"wyzforyou"}
if ENABLE_WHITELIST then
	local allowed=false
	for _,n in ipairs(AUTHORIZED) do
		if n:lower()==player.Name:lower() then allowed=true end
	end
	if not allowed then warn("[Terrain Tools] Kamu tidak punya akses.") return end
end

-- ===== SETTINGS =====
local MAX_BRUSH=100
local OVERLAP=5
local CYL_RATIO=0.35
local PEN_SPACING=0.5
local PEN_MIN=1.5
local PEN_MAX_DABS=6
local DPAD_SPEED=70

-- ===== SHAPE OPS =====
local function layers(h) return math.clamp(math.ceil(h/4),1,60) end
local function layerR(mtn,r,t)
	if mtn then return math.max(r*2.8*math.max(0,1-t)^.75,2) end
	return math.max(r*(1-t),2)
end
local function doLayers(pos,h,r,mat,mtn)
	local n=layers(h)
	local step=h/n
	for i=0,n-1 do
		local t=(i+.5)/n
		Terrain:FillCylinder(CFrame.new(pos.X,pos.Y-h/2+(i+.5)*step,pos.Z),step+OVERLAP,layerR(mtn,r,t),mat)
	end
end
local function doShape(shape,pos,size,r,h,mat)
	if shape=="Ball" then Terrain:FillBall(pos,r,mat)
	elseif shape=="Cylinder" then Terrain:FillCylinder(CFrame.new(pos),h,r,mat)
	elseif shape=="Wedge" then Terrain:FillWedge(CFrame.new(pos),size,mat)
	elseif shape=="Cone" then doLayers(pos,h,r,mat,false)
	elseif shape=="Mountain" then doLayers(pos,h,r,mat,true)
	else Terrain:FillBlock(CFrame.new(pos),size,mat) end
end
local function applyColor(mat,color)
	if not(mat and color) then return end
	if mat==Enum.Material.Water then Terrain.WaterColor=color
	else pcall(function() Terrain:SetMaterialColor(mat,color) end) end
end

-- ===== SNAPSHOT / UNDO =====
local function takeSnapshot(pos,h)
	local ok,snap=pcall(function()
		local region=Region3.new(pos-h,pos+h):ExpandToGrid(4)
		local m,o=Terrain:ReadVoxels(region,4)
		return {region=region,materials=m,occupancy=o}
	end)
	return ok and snap or nil
end
local function restore(s)
	return pcall(function() Terrain:WriteVoxels(s.region,4,s.materials,s.occupancy) end)
end
local function undoAction(a)
	if a.type=="pen" then
		for i=#a.snapshots,1,-1 do restore(a.snapshots[i]) end
		return
	end
	if a.snapshot and restore(a.snapshot) then return end
	doShape(a.shape,a.position,a.size,a.radius,a.height,Enum.Material.Air)
end

-- ===== PEN: REPLACE MATERIAL (tanpa menambah terrain) =====
local function penReplace(center,radius,material)
	local h=Vector3.new(radius+4,radius+4,radius+4)
	local ok,snap=pcall(function()
		local region=Region3.new(center-h,center+h):ExpandToGrid(4)
		local oM,oO=Terrain:ReadVoxels(region,4)
		local mats,occ=Terrain:ReadVoxels(region,4)
		local origin=region.CFrame.Position-region.Size/2
		local s=mats.Size
		local changed=false
		for i=1,s.X do for j=1,s.Y do for k=1,s.Z do
			local cur=mats[i][j][k]
			if occ[i][j][k]>0 and cur~=Enum.Material.Air and cur~=material then
				local vp=origin+Vector3.new((i-.5)*4,(j-.5)*4,(k-.5)*4)
				if (vp-center).Magnitude<=radius+2 then
					mats[i][j][k]=material
					changed=true
				end
			end
		end end end
		if not changed then return nil end
		Terrain:WriteVoxels(region,4,mats,occ)
		return {region=region,materials=oM,occupancy=oO}
	end)
	return ok and snap or nil
end

-- ===== DATA =====
local MATERIALS={
	{name="Grass",material=Enum.Material.Grass,shades={C(86,171,47),C(120,190,33),C(60,140,60),C(155,200,60),C(34,120,60),C(150,180,90),C(45,100,45),C(100,160,80),C(180,210,100),C(70,130,50)}},
	{name="Rock",material=Enum.Material.Rock,shades={C(120,113,108),C(90,90,92),C(160,160,160),C(70,70,74),C(140,130,120),C(110,100,95),C(180,175,170),C(60,60,65),C(150,140,130),C(100,105,110)}},
	{name="Ground",material=Enum.Material.Ground,shades={C(101,67,33),C(139,90,43),C(160,120,80),C(87,58,30),C(120,80,50),C(180,140,100),C(70,45,25),C(150,100,60),C(110,70,40),C(200,160,120)}},
	{name="Pavement",material=Enum.Material.Pavement,shades={C(160,160,160),C(190,190,190),C(130,130,130),C(210,210,210),C(100,100,105),C(170,165,160),C(80,80,85),C(150,150,155),C(220,220,215),C(115,115,118)}},
	{name="Sand",material=Enum.Material.Sand,shades={C(237,201,175),C(222,184,135),C(244,217,165),C(210,170,120),C(250,230,190),C(195,155,105),C(230,195,150),C(180,140,90),C(245,225,200),C(200,180,140)}},
	{name="Water",material=Enum.Material.Water,shades={C(59,130,246),C(14,116,144),C(56,189,248),C(30,64,175),C(6,182,212),C(37,99,235),C(103,232,249),C(29,78,216),C(125,211,252),C(8,47,73)}},
	{name="Ice",material=Enum.Material.Ice,shades={C(200,240,245),C(224,247,250),C(178,235,242),C(165,220,230),C(210,245,250),C(140,210,220),C(235,250,252),C(120,195,210),C(190,230,235),C(150,200,215)}},
	{name="Lava",material=Enum.Material.CrackedLava,shades={C(255,80,20),C(220,40,10),C(255,140,30),C(180,20,10),C(255,170,60),C(150,15,10),C(255,100,40),C(255,200,80),C(200,30,15),C(120,10,5)}},
}
local SHAPES={"Block","Ball","Cylinder","Wedge","Cone","Mountain","Rect"}
local SHAPE_LABELS={Block="Block",Ball="Ball",Cylinder="Cylinder",Wedge="Segitiga",Cone="Kerucut",Mountain="Gunung",Rect="Persegi Panjang"}

local state={materialIndex=1,colorIndex=1,shape="Block",brushSize=6,eraseMode=false,toolActive=false,penMode=false,actions={}}
local function curMat() return MATERIALS[state.materialIndex] end
local function curColor() return curMat().shades[state.colorIndex] end

-- ===== CODE GENERATOR =====
local function mname(m) return "Enum.Material."..m.Name end
local function ccode(c) return string.format("Color3.fromRGB(%d,%d,%d)",math.round(c.R*255),math.round(c.G*255),math.round(c.B*255)) end
local function vec(v) return string.format("%.1f,%.1f,%.1f",v.X,v.Y,v.Z) end

local function shapeLine(a,m)
	local p=a.position
	if a.shape=="Ball" then
		return string.format("Terrain:FillBall(Vector3.new(%s),%.1f,%s)",vec(p),a.radius,m)
	elseif a.shape=="Cylinder" then
		return string.format("Terrain:FillCylinder(CFrame.new(%s),%.1f,%.1f,%s)",vec(p),a.height,a.radius,m)
	elseif a.shape=="Wedge" then
		return string.format("Terrain:FillWedge(CFrame.new(%s),Vector3.new(%s),%s)",vec(p),vec(a.size),m)
	elseif a.shape=="Cone" or a.shape=="Mountain" then
		local rr=a.shape=="Mountain" and "math.max(r*2.8*math.max(0,1-t)^.75,2)" or "math.max(r*(1-t),2)"
		return string.format("do local h,n,r=%.1f,%d,%.1f;local step=h/n;local lh=step+5;for i=0,n-1 do local t=(i+.5)/n;Terrain:FillCylinder(CFrame.new(%.1f,%.1f+(i+.5)*step,%.1f),lh,%s,%s) end end",a.height,layers(a.height),a.radius,p.X,p.Y-a.height/2,p.Z,rr,m)
	end
	return string.format("Terrain:FillBlock(CFrame.new(%s),Vector3.new(%s),%s)",vec(p),vec(a.size),m)
end

local PEN_HELPER=[==[
local function P(x,y,z,r,m)
local c=Vector3.new(x,y,z)
local h=Vector3.new(r+4,r+4,r+4)
local rg=Region3.new(c-h,c+h):ExpandToGrid(4)
local mt,oc=Terrain:ReadVoxels(rg,4)
local o=rg.CFrame.Position-rg.Size/2
local s=mt.Size
for i=1,s.X do for j=1,s.Y do for k=1,s.Z do
if oc[i][j][k]>0 and mt[i][j][k]~=Enum.Material.Air then
if (o+Vector3.new((i-.5)*4,(j-.5)*4,(k-.5)*4)-c).Magnitude<=r+2 then mt[i][j][k]=m end
end
end end end
Terrain:WriteVoxels(rg,4,mt,oc)
end]==]

local function regenerateCode()
	local L={"-- TERRAIN SCRIPT BY WYZ VERSE","-- Generated by Terrain Tools","local Terrain=workspace.Terrain",""}
	local last,helper={},false
	for _,a in ipairs(state.actions) do
		if a.type=="erase" then
			table.insert(L,shapeLine(a,"Enum.Material.Air"))
		elseif a.type=="fill" or (a.type=="pen" and #a.dabs>0) then
			local m=mname(a.material)
			if last[a.material]~=a.color then
				if a.material==Enum.Material.Water then
					table.insert(L,"Terrain.WaterColor="..ccode(a.color))
				else
					table.insert(L,"Terrain:SetMaterialColor("..m..","..ccode(a.color)..")")
				end
				last[a.material]=a.color
			end
			if a.type=="fill" then
				table.insert(L,shapeLine(a,m))
			else
				if not helper then table.insert(L,PEN_HELPER) helper=true end
				local chunk={}
				for i,d in ipairs(a.dabs) do
					table.insert(chunk,string.format("{%.1f,%.1f,%.1f}",d.X,d.Y,d.Z))
					if #chunk>=10 or i==#a.dabs then
						table.insert(L,string.format("for _,d in ipairs({%s}) do P(d[1],d[2],d[3],%.1f,%s) end",table.concat(chunk,","),a.radius,m))
						chunk={}
					end
				end
			end
		end
	end
	return table.concat(L,"\n")
end

-- ===== GUI HELPERS =====
local function make(class,props,parent)
	local o=Instance.new(class)
	for k,v in pairs(props) do o[k]=v end
	o.Parent=parent
	return o
end
local function corner(o,r) make("UICorner",{CornerRadius=UDim.new(0,r or 6)},o) end
local function button(parent,text,pos,size,bg,ts,extra)
	local p={Text=text,Position=pos,Size=size,BackgroundColor3=bg,BorderSizePixel=0,TextColor3=Color3.new(1,1,1),TextSize=ts or 14,Font=Enum.Font.GothamBold}
	local cr
	for k,v in pairs(extra or {}) do
		if k=="cr" then cr=v else p[k]=v end
	end
	local b=make("TextButton",p,parent)
	corner(b,cr)
	return b
end
local GOLD=C(212,175,55)
local U=UDim2.new

local screenGui=make("ScreenGui",{Name="TerrainToolsGui",ResetOnSpawn=false,IgnoreGuiInset=true},player:WaitForChild("PlayerGui"))
local camera=workspace.CurrentCamera
local uiScale=make("UIScale",{Scale=1},screenGui)
local function updateScale()
	local vp=camera and camera.ViewportSize or Vector2.new(1600,720)
	uiScale.Scale=math.clamp(vp.Y/900,.55,1)
end
updateScale()
if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale) end

-- neon
local neon={}
local function neonStroke(parent,th)
	local s=make("UIStroke",{Thickness=th,Color=Color3.new(1,1,1)},parent)
	local cols={C(0,255,255),C(180,70,255),C(255,40,160),C(255,200,40),C(0,255,255)}
	local kp={}
	for i,c in ipairs(cols) do table.insert(kp,ColorSequenceKeypoint.new((i-1)/4,c)) end
	table.insert(neon,make("UIGradient",{Color=ColorSequence.new(kp)},s))
end
RunService.Heartbeat:Connect(function()
	local r=(os.clock()*50)%360
	for _,g in ipairs(neon) do g.Rotation=r end
end)

-- toggle button
local toggleBg=make("Frame",{Size=U(0,90,0,90),Position=U(0,10,0,130),BackgroundColor3=C(19,20,25),BorderSizePixel=0},screenGui)
corner(toggleBg,14) neonStroke(toggleBg,2)
make("TextLabel",{Size=U(1,0,0,42),Position=U(0,0,0,8),BackgroundTransparency=1,Text="👑",TextSize=28,Font=Enum.Font.GothamBold},toggleBg)
make("TextLabel",{Size=U(1,0,0,16),Position=U(0,0,1,-24),BackgroundTransparency=1,Text="TERRAIN",TextColor3=GOLD,TextSize=9,Font=Enum.Font.GothamBold},toggleBg)
local toggleBtn=make("TextButton",{Size=U(1,0,1,0),BackgroundTransparency=1,Text=""},toggleBg)

-- panel
local PS_NORMAL,PS_MIN,PS_MAX=1.25,.5,1.8
local panel=make("Frame",{Size=U(0,350,0,600),Position=U(0,115,.5,0),AnchorPoint=Vector2.new(0,.5),BackgroundColor3=C(18,18,22),BackgroundTransparency=.35,BorderSizePixel=0,Visible=false},screenGui)
corner(panel,16) neonStroke(panel,3)
local panelScale=make("UIScale",{Scale=PS_NORMAL},panel)

local header=make("Frame",{Size=U(1,0,0,64),BackgroundColor3=C(30,30,38),BackgroundTransparency=.4,BorderSizePixel=0},panel)
corner(header,16)
make("TextLabel",{Size=U(1,-110,1,0),Position=U(0,55,0,0),BackgroundTransparency=1,Text="Terrain Tools by Wyz Verse",TextColor3=GOLD,TextSize=15,Font=Enum.Font.GothamBold,TextTruncate=Enum.TextTruncate.AtEnd},header)
local resizeBtn=button(header,"⤡",U(0,8,0,12),U(0,40,0,40),C(45,45,52),22,{TextColor3=GOLD,AutoButtonColor=false,cr=10})
local dragHandle=button(header,"✥",U(1,-48,0,12),U(0,40,0,40),C(45,45,52),22,{TextColor3=GOLD,AutoButtonColor=false,cr=10})

local content=make("ScrollingFrame",{Size=U(1,-16,1,-72),Position=U(0,8,0,68),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=6,ScrollBarImageColor3=GOLD,CanvasSize=U(0,0,0,700)},panel)
local function label(text,y)
	return make("TextLabel",{Size=U(1,0,0,20),Position=U(0,0,0,y),BackgroundTransparency=1,Text=text,TextColor3=C(200,180,130),TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},content)
end
local SEL,UNSEL=C(150,120,40),C(45,45,50)

-- material
label("Material",0)
local materialGrid=make("Frame",{Size=U(1,0,0,108),Position=U(0,0,0,24),BackgroundTransparency=1},content)
local materialButtons={}
local refreshColorSwatches
local function refreshMaterialButtons()
	for i,b in ipairs(materialButtons) do b.BackgroundColor3=i==state.materialIndex and SEL or UNSEL end
end
for i,m in ipairs(MATERIALS) do
	local b=button(materialGrid,m.name,U(0,((i-1)%4)*82,0,math.floor((i-1)/4)*54),U(0,78,0,48),UNSEL,12,{Font=Enum.Font.GothamMedium,TextWrapped=true})
	materialButtons[i]=b
	b.Activated:Connect(function()
		state.materialIndex=i state.colorIndex=1
		refreshMaterialButtons()
		if refreshColorSwatches then refreshColorSwatches() end
	end)
end
refreshMaterialButtons()

-- color
label("Warna",138)
local colorRow=make("Frame",{Size=U(1,0,0,52),Position=U(0,0,0,162),BackgroundTransparency=1},content)
local swatches,strokes={},{}
refreshColorSwatches=function()
	for i,sw in ipairs(swatches) do
		sw.BackgroundColor3=curMat().shades[i]
		strokes[i].Enabled=i==state.colorIndex
	end
end
for i=1,10 do
	local sw=make("TextButton",{Size=U(0,56,0,24),Position=U(0,((i-1)%5)*60,0,math.floor((i-1)/5)*26),Text="",BorderSizePixel=0},colorRow)
	corner(sw,4)
	strokes[i]=make("UIStroke",{Color=Color3.new(1,1,1),Thickness=2,Enabled=false},sw)
	swatches[i]=sw
	sw.Activated:Connect(function() state.colorIndex=i refreshColorSwatches() end)
end
refreshColorSwatches()

-- shapes
label("Bentuk",222)
local shapeRow=make("Frame",{Size=U(1,0,0,126),Position=U(0,0,0,246),BackgroundTransparency=1},content)
local shapeButtons={}
local function refreshShapeButtons()
	for n,b in pairs(shapeButtons) do b.BackgroundColor3=n==state.shape and SEL or UNSEL end
end
for i,n in ipairs(SHAPES) do
	local b=button(shapeRow,SHAPE_LABELS[n],U(0,((i-1)%3)*113,0,math.floor((i-1)/3)*44),U(0,108,0,38),UNSEL,12,{TextWrapped=true})
	shapeButtons[n]=b
	b.Activated:Connect(function() state.shape=n refreshShapeButtons() end)
end
refreshShapeButtons()

-- brush slider
local brushLabel=label("Ukuran Brush: "..state.brushSize,382)
local sliderTrack=make("Frame",{Size=U(1,0,0,28),Position=U(0,0,0,406),BackgroundColor3=UNSEL,BorderSizePixel=0},content)
corner(sliderTrack)
local sliderKnob=make("Frame",{Size=U(0,20,0,20),Position=U((state.brushSize-1)/(MAX_BRUSH-1),-10,.5,-10),BackgroundColor3=GOLD,BorderSizePixel=0},sliderTrack)
corner(sliderKnob,10)
local draggingSlider=false
local sliderInput=make("TextButton",{BackgroundTransparency=1,Size=U(1,0,1,0),Text=""},sliderTrack)
sliderInput.MouseButton1Down:Connect(function() draggingSlider=true end)
sliderInput.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch then draggingSlider=true end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then draggingSlider=false end
end)
RunService.RenderStepped:Connect(function()
	if not draggingSlider then return end
	local rel=math.clamp((UIS:GetMouseLocation().X-sliderTrack.AbsolutePosition.X)/sliderTrack.AbsoluteSize.X,0,1)
	state.brushSize=math.floor(rel*(MAX_BRUSH-1))+1
	sliderKnob.Position=U(rel,-10,.5,-10)
	brushLabel.Text="Ukuran Brush: "..state.brushSize
end)

-- main buttons (TERRAIN di atas PEN)
local TERRAIN_OFF,TERRAIN_ON=C(35,100,55),C(40,160,80)
local PEN_OFF,PEN_ON=C(90,60,130),C(150,70,210)
local ERASE_OFF,ERASE_ON=C(120,50,50),C(150,30,30)
local terrainBtn=button(content,"TERRAIN: OFF",U(0,0,0,448),U(1,0,0,44),TERRAIN_OFF)
local penBtn=button(content,"PEN: OFF",U(0,0,0,498),U(1,0,0,44),PEN_OFF)
local eraseBtn=button(content,"ERASE: OFF",U(0,0,0,548),U(1,0,0,44),ERASE_OFF)
local undoBtn=button(content,"UNDO",U(0,0,0,598),U(1,0,0,44),C(120,95,30))
local viewBtn=button(content,"LIHAT & COPY SCRIPT",U(0,0,0,648),U(1,0,0,44),C(40,60,120))

-- script popup
local scriptOverlay=make("Frame",{Size=U(1,0,1,0),BackgroundColor3=C(0,0,0),BackgroundTransparency=.4,Visible=false,ZIndex=20},screenGui)
local scriptBox=make("Frame",{Size=U(.9,0,.8,0),Position=U(.05,0,.1,0),BackgroundColor3=C(18,18,22),BorderSizePixel=0,ZIndex=21},scriptOverlay)
corner(scriptBox,14)
make("UIStroke",{Thickness=2,Color=GOLD},scriptBox)
local scriptHeader=make("Frame",{Size=U(1,0,0,48),BackgroundColor3=C(30,30,38),BorderSizePixel=0,ZIndex=21},scriptBox)
corner(scriptHeader,14)
make("TextLabel",{Size=U(1,-50,1,0),Position=U(0,12,0,0),BackgroundTransparency=1,Text="Script Terrain — Select All lalu Copy",TextColor3=Color3.new(1,1,1),TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=21},scriptHeader)
local closeBtn=button(scriptHeader,"X",U(1,-44,0,7),U(0,38,0,34),C(239,68,68),18,{ZIndex=22,cr=8})
local EMPTY_TEXT="-- Tap di dunia game untuk mulai generate script..."
local codeBox=make("TextBox",{Size=U(1,-20,1,-110),Position=U(0,10,0,56),BackgroundColor3=C(10,10,12),TextColor3=C(180,255,200),Font=Enum.Font.Code,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,ClearTextOnFocus=false,MultiLine=true,TextWrapped=true,Text=EMPTY_TEXT,ZIndex=21},scriptBox)
corner(codeBox,10)
make("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingTop=UDim.new(0,6),PaddingRight=UDim.new(0,8)},codeBox)
local selectAllBtn=button(scriptBox,"SELECT ALL & COPY",U(0,10,1,-54),U(.62,-15,0,44),C(16,200,150),15,{ZIndex=21,cr=10})
local deleteAllBtn=button(scriptBox,"HAPUS SEMUA",U(.62,5,1,-54),U(.38,-15,0,44),C(200,40,40),14,{ZIndex=21,cr=10})

selectAllBtn.Activated:Connect(function()
	codeBox:CaptureFocus()
	codeBox.SelectionStart=1
	codeBox.CursorPosition=#codeBox.Text+1
end)
local deleting=false
deleteAllBtn.Activated:Connect(function()
	if deleting then return end
	deleting=true
	local list=state.actions
	state.actions={}
	codeBox.Text=EMPTY_TEXT
	deleteAllBtn.Text="MENGHAPUS..."
	task.spawn(function()
		for i=#list,1,-1 do
			undoAction(list[i])
			if i%10==0 then task.wait() end
		end
		deleteAllBtn.Text="HAPUS SEMUA"
		deleting=false
	end)
end)
viewBtn.Activated:Connect(function() codeBox.Text=regenerateCode() scriptOverlay.Visible=true end)
closeBtn.Activated:Connect(function() scriptOverlay.Visible=false end)

-- ===== D-PAD (kamera tetap bisa digeser saat TERRAIN/PEN ON) =====
local dpad=make("Frame",{Size=U(0,235,0,224),AnchorPoint=Vector2.new(0,1),Position=U(0,25,1,-20),BackgroundTransparency=1,Visible=false},screenGui)
local DIRS={
	Up={Vector3.new(0,1,0),"▲",82,0},Down={Vector3.new(0,-1,0),"▼",82,154},
	Left={Vector3.new(-1,0,0),"◀",0,77},Right={Vector3.new(1,0,0),"▶",165,77},
	Fwd={Vector3.new(0,0,-1)},Back={Vector3.new(0,0,1)},
}
local held,heldInput={},{}
for name,d in pairs(DIRS) do
	if d[2] then
		local b=button(dpad,d[2],U(0,d[3],0,d[4]),U(0,70,0,70),C(30,30,38),30,{TextColor3=GOLD,AutoButtonColor=false,BackgroundTransparency=.3,cr=12})
		b.InputBegan:Connect(function(i)
			local t=i.UserInputType
			if t==Enum.UserInputType.MouseButton1 or t==Enum.UserInputType.Touch then
				held[name]=true heldInput[name]=i
			end
		end)
	end
end
-- rotasi kamera < >
local ROT_SPEED=1.3
local ROTS={RotU={"↑",82,0},RotD={"↓",82,154},RotL={"<",0,77},RotR={">",165,77},Back={"−",0,0},Fwd={"+",165,0}}
local rotPad=make("Frame",{Size=U(0,235,0,224),AnchorPoint=Vector2.new(1,1),Position=U(1,-290,1,-20),BackgroundTransparency=1,Visible=false},screenGui)
for name,r in pairs(ROTS) do
	local b=button(rotPad,r[1],U(0,r[2],0,r[3]),U(0,70,0,70),C(30,30,38),30,{TextColor3=GOLD,AutoButtonColor=false,BackgroundTransparency=.3,cr=14})
	b.InputBegan:Connect(function(i)
		local t=i.UserInputType
		if t==Enum.UserInputType.MouseButton1 or t==Enum.UserInputType.Touch then
			held[name]=true heldInput[name]=i
		end
	end)
end

UIS.InputEnded:Connect(function(i)
	for name,hi in pairs(heldInput) do
		if hi==i or (i.UserInputType==Enum.UserInputType.MouseButton1 and hi.UserInputType==Enum.UserInputType.MouseButton1) then
			held[name]=nil heldInput[name]=nil
		end
	end
end)

-- ===== DRAG & RESIZE PANEL =====
do
	local dragging,dragStart,startPos
	dragHandle.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging=true dragStart=i.Position startPos=panel.Position
			i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
		end
	end)
	local W,H=350,600
	local resizing,rStart,rScale,rPos
	resizeBtn.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			resizing=true rStart=i.Position rScale=panelScale.Scale rPos=panel.Position
			i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then resizing=false end end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		local t=i.UserInputType
		if not(t==Enum.UserInputType.MouseMovement or t==Enum.UserInputType.Touch) then return end
		if dragging then
			local d=(i.Position-dragStart)/uiScale.Scale
			panel.Position=U(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
		end
		if resizing then
			local d=(i.Position-rStart)/uiScale.Scale
			local ds=-(d.X*W+d.Y*H)/(W*W+H*H)
			local ns=math.clamp(rScale+ds,PS_MIN,PS_MAX)
			local diff=rScale-ns
			panel.Position=U(rPos.X.Scale,rPos.X.Offset+W*diff,rPos.Y.Scale,rPos.Y.Offset+(H/2)*diff)
			panelScale.Scale=ns
		end
	end)
end
toggleBtn.Activated:Connect(function() panel.Visible=not panel.Visible end)

-- ===== BRUSH SIZE / GUI HIT TEST =====
local function getBrushSize()
	local b=state.brushSize
	if state.shape=="Rect" then return Vector3.new(b*3,math.max(b*.25,2),b) end
	if state.shape=="Mountain" then return Vector3.new(b*2.8,b*2,b*2.8) end
	return Vector3.new(b,b,b)
end
local function isOverGuiAt(p)
	if scriptOverlay.Visible then return true end
	for _,f in ipairs({panel,toggleBg,dpad,rotPad}) do
		if f.Visible then
			local a,s=f.AbsolutePosition,f.AbsoluteSize
			if p.X>=a.X and p.X<=a.X+s.X and p.Y>=a.Y and p.Y<=a.Y+s.Y then return true end
		end
	end
	return false
end
local function isOverGui() return isOverGuiAt(UIS:GetMouseLocation()) end

-- ===== TERRAIN TAP =====
local function doTap(hit)
	local size=getBrushSize()
	local radius=state.brushSize/2
	local md=curMat()
	local snapshot=takeSnapshot(hit,size/2+Vector3.new(6,6,6))
	local height=state.brushSize
	if state.shape=="Mountain" then height=state.brushSize*2
	elseif state.shape=="Cylinder" then height=math.max(state.brushSize*CYL_RATIO,2) end
	local a={shape=state.shape,position=hit,size=size,radius=radius,height=height,snapshot=snapshot}
	if state.eraseMode then
		a.type="erase"
		table.insert(state.actions,a)
		doShape(a.shape,hit,size,radius,height,Enum.Material.Air)
	else
		a.type="fill" a.material=md.material a.color=curColor()
		table.insert(state.actions,a)
		applyColor(md.material,a.color)
		doShape(a.shape,hit,size,radius,height,md.material)
	end
end

-- ===== PEN =====
local penDrawing=false
local penInput,penStroke,penLast,penHover
local penParams=RaycastParams.new()
penParams.FilterType=Enum.RaycastFilterType.Include
penParams.FilterDescendantsInstances={Terrain}
penParams.IgnoreWater=false
local function penRadius() return math.max(state.brushSize/2,2) end

local function penRay()
	local cam=workspace.CurrentCamera
	if not cam then return nil end
	if penInput and penInput.UserInputType==Enum.UserInputType.Touch then
		return cam:ScreenPointToRay(penInput.Position.X,penInput.Position.Y)
	end
	local m=UIS:GetMouseLocation()
	return cam:ViewportPointToRay(m.X,m.Y)
end
local function penCast(ray)
	local r=workspace:Raycast(ray.Origin,ray.Direction*2000,penParams)
	return r and r.Position or nil
end
local function penDab(pos)
	local st=penStroke
	if not st then return end
	table.insert(st.dabs,pos)
	local snap=penReplace(pos,st.radius,st.material)
	if snap then table.insert(st.snapshots,snap) end
end
local function penBegin(input)
	local md=curMat()
	local color=curColor()
	applyColor(md.material,color)
	penStroke={type="pen",shape="Pen",material=md.material,color=color,radius=penRadius(),position=Vector3.zero,dabs={},snapshots={}}
	penInput=input penDrawing=true penLast=nil
	table.insert(state.actions,penStroke)
end
local function penEnd()
	if not penDrawing then return end
	penDrawing=false penInput=nil penLast=nil
	if penStroke then
		if #penStroke.dabs==0 then
			for i=#state.actions,1,-1 do
				if state.actions[i]==penStroke then table.remove(state.actions,i) break end
			end
		end
		penStroke=nil
	end
	if not UIS.MouseEnabled then penHover=nil end
end
local function penStep()
	if not penDrawing and not UIS.MouseEnabled then return end
	local ray=penRay()
	if not ray then return end
	local hit=penCast(ray)
	if not hit then return end
	penHover=hit
	if not penDrawing or not penStroke then return end
	local spacing=math.max(penStroke.radius*PEN_SPACING,PEN_MIN)
	if not penLast then penDab(hit) if penDrawing then penLast=hit end return end
	local n=0
	while n<PEN_MAX_DABS and penLast and penDrawing do
		local d=hit-penLast
		if d.Magnitude<spacing then break end
		local np=penLast+d.Unit*spacing
		penDab(np) if not penDrawing then break end penLast=np n=n+1
	end
end
local penBusy=false
RunService.RenderStepped:Connect(function()
	if state.penMode and not penBusy then
		penBusy=true
		local ok,err=pcall(penStep)
		penBusy=false
		if not ok then warn("[Terrain Tools] "..tostring(err)) end
	end
end)

UIS.InputBegan:Connect(function(input,processed)
	if not state.penMode or penDrawing or processed then return end
	local t=input.UserInputType
	if t~=Enum.UserInputType.MouseButton1 and t~=Enum.UserInputType.Touch then return end
	local vp
	if t==Enum.UserInputType.Touch then
		vp=Vector2.new(input.Position.X,input.Position.Y)+GuiService:GetGuiInset()
	else
		vp=UIS:GetMouseLocation()
	end
	if isOverGuiAt(vp) then return end
	penBegin(input)
end)
UIS.InputEnded:Connect(function(input)
	if not penDrawing then return end
	local t=input.UserInputType
	if (t==Enum.UserInputType.Touch and input==penInput) or t==Enum.UserInputType.MouseButton1 then penEnd() end
end)

-- ===== MODE: TERRAIN / PEN (kamera freeze + D-pad) =====
local BIND="TerrainToolsCamLock"
local camLocked,lockCF,savedType=false,nil,nil

local panV,yawV,pitV=Vector3.zero,0,0
local function camStep(dt)
	local cam=workspace.CurrentCamera
	local cf=lockCF
	if not cam or not cf then return end
	if cam.CameraType~=Enum.CameraType.Scriptable then cam.CameraType=Enum.CameraType.Scriptable end
	local a=1-math.exp(-dt*9)
	local tv=Vector3.zero
	for name in pairs(held) do
		local d=DIRS[name]
		if d then tv=tv+d[1] end
	end
	if tv.Magnitude>1 then tv=tv.Unit end
	panV=panV:Lerp(tv,a)
	if panV.Magnitude>.001 then
		cf=cf+cf:VectorToWorldSpace(panV)*DPAD_SPEED*dt
	end
	yawV=yawV+(((held.RotL and 1 or 0)-(held.RotR and 1 or 0))-yawV)*a
	pitV=pitV+(((held.RotU and 1 or 0)-(held.RotD and 1 or 0))-pitV)*a
	if math.abs(yawV)>.001 then
		cf=CFrame.new(cf.Position)*CFrame.Angles(0,yawV*ROT_SPEED*dt,0)*cf.Rotation
	end
	if math.abs(pitV)>.001 then
		local cur=math.asin(math.clamp(cf.LookVector.Y,-1,1))
		local dp=math.clamp(cur+pitV*ROT_SPEED*dt,-1.4,1.4)-cur
		cf=cf*CFrame.Angles(dp,0,0)
	end
	if lockCF then
		lockCF=cf
		cam.CFrame=cf
	end
end
local function setLock(on)
	if on==camLocked then return end
	camLocked=on
	local cam=workspace.CurrentCamera
	if on then
		if cam then
			savedType=cam.CameraType
			if savedType==Enum.CameraType.Scriptable then savedType=Enum.CameraType.Custom end
			lockCF=cam.CFrame
			cam.CameraType=Enum.CameraType.Scriptable
		end
		RunService:BindToRenderStep(BIND,Enum.RenderPriority.Camera.Value+1,camStep)
	else
		pcall(function() RunService:UnbindFromRenderStep(BIND) end)
		table.clear(held) table.clear(heldInput)
		panV=Vector3.zero yawV=0 pitV=0
		lockCF=nil
		if cam then cam.CameraType=savedType or Enum.CameraType.Custom end
		savedType=nil
	end
end
local function refreshModes()
	local active=state.toolActive or state.penMode
	terrainBtn.Text=state.toolActive and "TERRAIN: ON" or "TERRAIN: OFF"
	terrainBtn.BackgroundColor3=state.toolActive and TERRAIN_ON or TERRAIN_OFF
	penBtn.Text=state.penMode and "PEN: ON" or "PEN: OFF"
	penBtn.BackgroundColor3=state.penMode and PEN_ON or PEN_OFF
	dpad.Visible=active rotPad.Visible=active
	if not state.penMode then penEnd() penHover=nil end
	setLock(active)
end
terrainBtn.Activated:Connect(function()
	state.toolActive=not state.toolActive
	if state.toolActive then state.penMode=false end
	refreshModes()
end)
penBtn.Activated:Connect(function()
	state.penMode=not state.penMode
	if state.penMode then state.toolActive=false end
	refreshModes()
end)

-- tap terrain
mouse.Button1Down:Connect(function()
	if state.penMode or not state.toolActive then return end
	if not mouse.Hit or isOverGui() then return end
	doTap(mouse.Hit.Position)
end)

-- erase / undo
eraseBtn.Activated:Connect(function()
	state.eraseMode=not state.eraseMode
	eraseBtn.Text=state.eraseMode and "ERASE: ON" or "ERASE: OFF"
	eraseBtn.BackgroundColor3=state.eraseMode and ERASE_ON or ERASE_OFF
end)
undoBtn.Activated:Connect(function()
	local a=table.remove(state.actions)
	if a then undoAction(a) end
end)

-- ===== BRUSH INDICATOR =====
local indicator=make("Part",{Name="TerrainBrushIndicator",Anchored=true,CanCollide=false,CanQuery=false,Material=Enum.Material.Neon,Transparency=.5,Color=C(74,222,128)},workspace)
RunService.RenderStepped:Connect(function()
	if state.penMode then
		local ph=penHover
		if ph then
			local d=penRadius()*2
			if indicator.Shape~=Enum.PartType.Ball then indicator.Shape=Enum.PartType.Ball end
			indicator.Transparency=.6
			indicator.Color=curColor()
			indicator.Size=Vector3.new(d,d,d)
			indicator.CFrame=CFrame.new(ph)
		else
			indicator.Transparency=1
		end
	elseif state.toolActive and mouse.Hit and mouse.Hit.Position then
		if indicator.Shape~=Enum.PartType.Block then indicator.Shape=Enum.PartType.Block end
		indicator.Transparency=.5
		indicator.Color=state.eraseMode and C(239,68,68) or curColor()
		local bs=getBrushSize()
		indicator.Size=Vector3.new(bs.X,1,bs.Z)
		indicator.CFrame=CFrame.new(mouse.Hit.Position)
	else
		indicator.Transparency=1
	end
end)

print("[Terrain Tools] Ready!")
