local Theme = {
    -- Backgrounds
    WindowBg      = Color3.fromRGB(15, 15, 20),
    TitleBg       = Color3.fromRGB(20, 20, 28),
    TabBg         = Color3.fromRGB(20, 20, 28),
    TabActiveBg   = Color3.fromRGB(30, 30, 42),
    SectionBg     = Color3.fromRGB(22, 22, 30),
    ItemBg        = Color3.fromRGB(28, 28, 38),

    -- Accent
    Accent        = Color3.fromRGB(108, 87, 230),
    AccentHover   = Color3.fromRGB(128, 107, 250),
    AccentDark    = Color3.fromRGB(60, 48, 140),

    -- Text
    TextPrimary   = Color3.fromRGB(235, 235, 255),
    TextSecondary = Color3.fromRGB(150, 150, 180),
    TextDisabled  = Color3.fromRGB(80, 80, 100),

    -- Border
    Border        = Color3.fromRGB(40, 40, 58),
    BorderHover   = Color3.fromRGB(70, 70, 100),

    -- Toggle
    ToggleOn      = Color3.fromRGB(108, 87, 230),
    ToggleOff     = Color3.fromRGB(45, 45, 62),
    ToggleKnob    = Color3.fromRGB(235, 235, 255),

    -- Slider
    SliderBg      = Color3.fromRGB(35, 35, 50),
    SliderFill    = Color3.fromRGB(108, 87, 230),
    SliderKnob    = Color3.fromRGB(235, 235, 255),

    -- Button
    ButtonBg      = Color3.fromRGB(35, 35, 50),
    ButtonHover   = Color3.fromRGB(50, 50, 70),
    ButtonActive  = Color3.fromRGB(108, 87, 230),

    -- Sizing
    WindowW       = 460,
    WindowH       = 500,
    TitleH        = 36,
    TabH          = 30,
    ItemH         = 30,
    Padding       = 10,
    Radius        = 6,
    ScrollbarW    = 4,

    -- Font
    Font          = Drawing.Fonts.System,
    FontBold      = Drawing.Fonts.SystemBold,
    FontSize      = 13,
    TitleSize     = 14,
}

local _allDrawings = {}

local function newDrawing(typeName, props)
    local d = Drawing.new(typeName)
    for k, v in pairs(props or {}) do d[k] = v end
    table.insert(_allDrawings, d)
    return d
end

local function removeDrawing(d)
    pcall(function() d:Remove() end)
    for i, v in ipairs(_allDrawings) do
        if v == d then table.remove(_allDrawings, i) break end
    end
end

local function makeRoundedRect(color, zindex, filled)
    filled = filled ~= false
    local obj = {}
    obj.s1 = newDrawing("Square", { Color=color, Filled=true,   ZIndex=zindex, Visible=false })
    obj.s2 = newDrawing("Square", { Color=color, Filled=true,   ZIndex=zindex, Visible=false })
    obj.c1 = newDrawing("Circle", { Color=color, Filled=filled, ZIndex=zindex, Visible=false })
    obj.c2 = newDrawing("Circle", { Color=color, Filled=filled, ZIndex=zindex, Visible=false })
    obj.c3 = newDrawing("Circle", { Color=color, Filled=filled, ZIndex=zindex, Visible=false })
    obj.c4 = newDrawing("Circle", { Color=color, Filled=filled, ZIndex=zindex, Visible=false })
    if not filled then
        obj.l1 = newDrawing("Line", { Color=color, Thickness=1, ZIndex=zindex, Visible=false })
        obj.l2 = newDrawing("Line", { Color=color, Thickness=1, ZIndex=zindex, Visible=false })
        obj.l3 = newDrawing("Line", { Color=color, Thickness=1, ZIndex=zindex, Visible=false })
        obj.l4 = newDrawing("Line", { Color=color, Thickness=1, ZIndex=zindex, Visible=false })
    end

    function obj:Layout(x, y, w, h, radius)
        radius = math.min(radius or Theme.Radius, math.floor(math.min(w,h)/2))
        self.s1.Position = Vector2.new(x+radius, y);        self.s1.Size = Vector2.new(w-radius*2, h)
        self.s2.Position = Vector2.new(x, y+radius);        self.s2.Size = Vector2.new(w, h-radius*2)
        self.c1.Position = Vector2.new(x+radius,   y+radius)
        self.c2.Position = Vector2.new(x+w-radius, y+radius)
        self.c3.Position = Vector2.new(x+radius,   y+h-radius)
        self.c4.Position = Vector2.new(x+w-radius, y+h-radius)
        self.c1.Radius = radius; self.c2.Radius = radius
        self.c3.Radius = radius; self.c4.Radius = radius
        if self.l1 then
            self.l1.From=Vector2.new(x+radius,y);     self.l1.To=Vector2.new(x+w-radius,y)
            self.l2.From=Vector2.new(x+radius,y+h);   self.l2.To=Vector2.new(x+w-radius,y+h)
            self.l3.From=Vector2.new(x,y+radius);     self.l3.To=Vector2.new(x,y+h-radius)
            self.l4.From=Vector2.new(x+w,y+radius);   self.l4.To=Vector2.new(x+w,y+h-radius)
        end
        local parts = {self.s1,self.s2,self.c1,self.c2,self.c3,self.c4}
        if self.l1 then parts[#parts+1]=self.l1; parts[#parts+1]=self.l2; parts[#parts+1]=self.l3; parts[#parts+1]=self.l4 end
        for _,p in ipairs(parts) do p.Visible = true end
    end

    function obj:SetColor(c)
        for _,p in ipairs({self.s1,self.s2,self.c1,self.c2,self.c3,self.c4}) do p.Color=c end
        if self.l1 then for _,p in ipairs({self.l1,self.l2,self.l3,self.l4}) do p.Color=c end end
    end

    function obj:SetVisible(v)
        local parts = {self.s1,self.s2,self.c1,self.c2,self.c3,self.c4}
        if self.l1 then parts[#parts+1]=self.l1; parts[#parts+1]=self.l2; parts[#parts+1]=self.l3; parts[#parts+1]=self.l4 end
        for _,p in ipairs(parts) do p.Visible=v end
    end

    function obj:Remove()
        local parts = {self.s1,self.s2,self.c1,self.c2,self.c3,self.c4}
        if self.l1 then parts[#parts+1]=self.l1; parts[#parts+1]=self.l2; parts[#parts+1]=self.l3; parts[#parts+1]=self.l4 end
        for _,p in ipairs(parts) do pcall(function() p:Remove() end) end
    end

    return obj
end

local _mouse       = game:GetService("Players").LocalPlayer:GetMouse()
local _m1Last      = false
local _m1Clicked   = false
local _mx, _my     = 0, 0

local function updateInput()
    _mx = _mouse.X
    _my = _mouse.Y
    local m1Now = ismouse1pressed()
    _m1Clicked = m1Now and not _m1Last
    _m1Last    = m1Now
end

local function inRect(x, y, w, h)
    return _mx >= x and _mx <= x+w and _my >= y and _my <= y+h
end

local function lerp(a, b, t) return a + (b-a)*t end
local function lerpColor(c1, c2, t)
    return Color3.new(
        lerp(c1.R, c2.R, t),
        lerp(c1.G, c2.G, t),
        lerp(c1.B, c2.B, t)
    )
end
local function easeOut(t) return 1-(1-t)^3 end

local function saveConfig(id, data)
    local path = "C:/matcha/workspace/UILib_" .. id .. ".json"
    local ok = pcall(writefile, path, game:GetService("HttpService"):JSONEncode(data))
    return ok
end

local function loadConfig(id)
    local path = "C:/matcha/workspace/UILib_" .. id .. ".json"
    if not isfile(path) then return nil end
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(path))
    end)
    return ok and data or nil
end

local function makeToggle(x, y, w, label, default, callback, zindex)
    local self   = {}
    self.value   = default or false
    self.label   = label
    self.hovered = false

    local trackW, trackH = 36, 18
    local trackX = x + w - trackW - Theme.Padding
    local trackY = y + (Theme.ItemH - trackH) / 2

    -- Track background
    self.track   = makeRoundedRect(Theme.ToggleOff, zindex, true)
    self.track:Layout(trackX, trackY, trackW, trackH, trackH/2)

    -- Knob
    local knobR  = (trackH/2) - 2
    self.knob    = newDrawing("Circle", {
        Radius  = knobR,
        Filled  = true,
        Color   = Theme.ToggleKnob,
        ZIndex  = zindex+1,
        Visible = true,
    })

    -- Label
    self.txt = newDrawing("Text", {
        Font    = Theme.Font,
        Size    = Theme.FontSize,
        Color   = Theme.TextPrimary,
        Text    = label,
        Outline = false,
        ZIndex  = zindex+1,
        Visible = true,
        Position = Vector2.new(x + Theme.Padding, y + (Theme.ItemH - Theme.FontSize) / 2),
    })

    self._knobT  = self.value and 1 or 0

    function self:SetVisible(v)
        self.track:SetVisible(v)
        self.knob.Visible = v
        self.txt.Visible  = v
    end

    function self:Update(mx, my, m1click, px, py)
        -- Reposition based on parent scroll
        local ax = x
        local ay = py or y
        local atX = ax + w - trackW - Theme.Padding
        local atY = ay + (Theme.ItemH - trackH) / 2

        self.hovered = inRect(atX, atY, trackW, trackH)

        if m1click and self.hovered then
            self.value = not self.value
            if callback then pcall(callback, self.value) end
        end

        local targetT = self.value and 1 or 0
        self._knobT   = self._knobT + (targetT - self._knobT) * 0.2

        local trackColor = lerpColor(Theme.ToggleOff, Theme.ToggleOn, self._knobT)
        self.track:SetColor(trackColor)
        self.track:Layout(atX, atY, trackW, trackH, trackH/2)

        local knobX = atX + knobR + 2 + (trackW - trackH) * self._knobT
        self.knob.Position = Vector2.new(math.floor(knobX), math.floor(atY + trackH/2))

        self.txt.Position = Vector2.new(ax + Theme.Padding, ay + (Theme.ItemH - Theme.FontSize)/2)
    end

    function self:Remove()
        self.track:Remove()
        pcall(function() self.knob:Remove() end)
        pcall(function() self.txt:Remove() end)
    end

    function self:GetValue() return self.value end
    function self:SetValue(v)
        self.value = v
        if callback then pcall(callback, v) end
    end

    return self
end

local function makeSlider(x, y, w, label, min, max, default, callback, zindex)
    local self     = {}
    self.value     = default or min
    self.min       = min
    self.max       = max
    self.dragging  = false

    local sliderH  = 6
    local sliderY  = y + Theme.ItemH - sliderH - 6
    local sliderX  = x + Theme.Padding
    local sliderW  = w - Theme.Padding * 2

    self.bg = makeRoundedRect(Theme.SliderBg, zindex, true)
    self.bg:Layout(sliderX, sliderY, sliderW, sliderH, sliderH/2)

    self.fill = makeRoundedRect(Theme.SliderFill, zindex+1, true)

    local knobR = 7
    self.knob = newDrawing("Circle", {
        Radius  = knobR,
        Filled  = true,
        Color   = Theme.SliderKnob,
        ZIndex  = zindex+2,
        Visible = true,
    })

    self.txt = newDrawing("Text", {
        Font     = Theme.Font,
        Size     = Theme.FontSize,
        Color    = Theme.TextPrimary,
        Text     = label,
        Outline  = false,
        ZIndex   = zindex+1,
        Visible  = true,
        Position = Vector2.new(sliderX, y + 4),
    })
    self.valTxt = newDrawing("Text", {
        Font     = Theme.Font,
        Size     = Theme.FontSize,
        Color    = Theme.TextSecondary,
        Text     = tostring(math.floor(default)),
        Outline  = false,
        ZIndex   = zindex+1,
        Visible  = true,
        Position = Vector2.new(sliderX + sliderW - 30, y + 4),
    })

    local function getFillW()
        local t = (self.value - min) / (max - min)
        return math.max(sliderH, math.floor(sliderW * t))
    end

    function self:SetVisible(v)
        self.bg:SetVisible(v)
        self.fill:SetVisible(v)
        self.knob.Visible  = v
        self.txt.Visible   = v
        self.valTxt.Visible= v
    end

    function self:Update(mx, my, m1down, m1click, ay)
        local aSliderY = (ay or y) + Theme.ItemH - sliderH - 6
        local aSliderX = x + Theme.Padding

        -- Start drag
        if m1click and inRect(aSliderX - knobR, aSliderY - knobR, sliderW + knobR*2, sliderH + knobR*2) then
            self.dragging = true
        end
        if not m1down then self.dragging = false end

        if self.dragging then
            local t = math.max(0, math.min(1, (mx - aSliderX) / sliderW))
            local newVal = min + (max - min) * t
            -- round to integer if range is integer-like
            if (max - min) >= 1 then newVal = math.floor(newVal + 0.5) end
            if newVal ~= self.value then
                self.value = newVal
                if callback then pcall(callback, self.value) end
            end
        end

        local t  = (self.value - min) / (max - min)
        local fw = math.max(sliderH, math.floor(sliderW * t))
        local kx = aSliderX + fw

        self.bg:Layout(aSliderX, aSliderY, sliderW, sliderH, sliderH/2)
        self.fill:Layout(aSliderX, aSliderY, fw, sliderH, sliderH/2)
        self.knob.Position = Vector2.new(kx, math.floor(aSliderY + sliderH/2))

        self.txt.Position    = Vector2.new(aSliderX, (ay or y) + 4)
        self.valTxt.Position = Vector2.new(aSliderX + sliderW - 30, (ay or y) + 4)
        self.valTxt.Text     = tostring(math.floor(self.value))
    end

    function self:Remove()
        self.bg:Remove(); self.fill:Remove()
        pcall(function() self.knob:Remove() end)
        pcall(function() self.txt:Remove() end)
        pcall(function() self.valTxt:Remove() end)
    end

    function self:GetValue() return self.value end
    function self:SetValue(v)
        self.value = math.max(min, math.min(max, v))
        if callback then pcall(callback, self.value) end
    end

    return self
end

local function makeButton(x, y, w, label, callback, zindex)
    local self    = {}
    self.hovered  = false
    self.pressing = false
    self._scale   = 1.0

    local bh = Theme.ItemH - 6
    local bx = x + Theme.Padding
    local by = y + 3
    local bw = w - Theme.Padding * 2

    self.bg  = makeRoundedRect(Theme.ButtonBg, zindex, true)
    self.bg:Layout(bx, by, bw, bh, 4)

    self.txt = newDrawing("Text", {
        Font     = Theme.FontBold,
        Size     = Theme.FontSize,
        Color    = Theme.TextPrimary,
        Text     = label,
        Outline  = false,
        Center   = true,
        ZIndex   = zindex+1,
        Visible  = true,
        Position = Vector2.new(math.floor(bx + bw/2), math.floor(by + (bh - Theme.FontSize)/2)),
    })

    function self:SetVisible(v)
        self.bg:SetVisible(v)
        self.txt.Visible = v
    end

    function self:Update(mx, my, m1click, m1down, ay)
        local abx = bx
        local aby = (ay or y) + 3

        self.hovered  = inRect(abx, aby, bw, bh)
        self.pressing = self.hovered and m1down

        if m1click and self.hovered then
            if callback then pcall(callback) end
        end

        local bgColor = Theme.ButtonBg
        if self.pressing then bgColor = Theme.ButtonActive
        elseif self.hovered then bgColor = Theme.ButtonHover end
        self.bg:SetColor(bgColor)
        self.bg:Layout(abx, aby, bw, bh, 4)
        self.txt.Position = Vector2.new(math.floor(abx + bw/2), math.floor(aby + (bh - Theme.FontSize)/2))
    end

    function self:Remove()
        self.bg:Remove()
        pcall(function() self.txt:Remove() end)
    end

    return self
end

local function makeLabel(x, y, w, text, color, zindex)
    local self = {}
    self.txt = newDrawing("Text", {
        Font     = Theme.Font,
        Size     = Theme.FontSize,
        Color    = color or Theme.TextSecondary,
        Text     = text,
        Outline  = false,
        ZIndex   = zindex+1,
        Visible  = true,
        Position = Vector2.new(x + Theme.Padding, y + (Theme.ItemH - Theme.FontSize)/2),
    })

    function self:SetVisible(v) self.txt.Visible = v end
    function self:SetText(t)    self.txt.Text = t end

    function self:Update(mx, my, m1, m1d, ay)
        self.txt.Position = Vector2.new(x + Theme.Padding, (ay or y) + (Theme.ItemH - Theme.FontSize)/2)
    end

    function self:Remove()
        pcall(function() self.txt:Remove() end)
    end

    return self
end

local function makeSeparator(x, y, w, zindex)
    local self = {}
    self.line = newDrawing("Line", {
        Color     = Theme.Border,
        Thickness = 1,
        ZIndex    = zindex,
        Visible   = true,
        From      = Vector2.new(x + Theme.Padding, y + Theme.ItemH/2),
        To        = Vector2.new(x + w - Theme.Padding, y + Theme.ItemH/2),
    })

    function self:SetVisible(v) self.line.Visible = v end

    function self:Update(mx, my, m1, m1d, ay)
        local ay2 = ay or y
        self.line.From = Vector2.new(x + Theme.Padding,     ay2 + Theme.ItemH/2)
        self.line.To   = Vector2.new(x + w - Theme.Padding, ay2 + Theme.ItemH/2)
    end

    function self:Remove()
        pcall(function() self.line:Remove() end)
    end

    return self
end

local function makeTabContent(wx, wy, ww, wh, titleH, tabH, zindex)
    local self      = {}
    self.items      = {}
    self.scrollY    = 0
    self._visible   = false

    local contentX  = wx + 1
    local contentY  = wy + titleH + tabH
    local contentW  = ww - 2
    local contentH  = wh - titleH - tabH - 1

    self.clipBg = newDrawing("Square", {
        Color   = Theme.WindowBg,
        Filled  = true,
        ZIndex  = zindex - 1,
        Visible = false,
        Position= Vector2.new(contentX, contentY),
        Size    = Vector2.new(contentW, contentH),
    })

    self.scrollbar = newDrawing("Square", {
        Color   = Theme.Accent,
        Filled  = true,
        ZIndex  = zindex + 5,
        Visible = false,
    })

    function self:TotalHeight()
        local h = Theme.Padding
        for _,item in ipairs(self.items) do
            h = h + (item.height or Theme.ItemH) + 4
        end
        return h
    end

    function self:AddItem(item, height)
        item.height = height or Theme.ItemH
        table.insert(self.items, item)
    end

    function self:SetVisible(v)
        self._visible = v
        self.clipBg.Visible = v
        for _, item in ipairs(self.items) do
            if item.SetVisible then item:SetVisible(v) end
        end
        if not v then self.scrollbar.Visible = false end
    end

    function self:Update(mx, my, m1click, m1down, scrollDelta)
        if not self._visible then return end

        -- Scroll
        local totalH = self:TotalHeight()
        local maxScroll = math.max(0, totalH - contentH + Theme.Padding)
        if scrollDelta ~= 0 then
            self.scrollY = math.max(0, math.min(maxScroll, self.scrollY - scrollDelta * 20))
        end

        if maxScroll > 0 then
            local ratio    = contentH / totalH
            local barH     = math.max(20, math.floor(contentH * ratio))
            local barY     = contentY + math.floor((self.scrollY / maxScroll) * (contentH - barH))
            self.scrollbar.Position = Vector2.new(contentX + contentW - Theme.ScrollbarW - 2, barY)
            self.scrollbar.Size     = Vector2.new(Theme.ScrollbarW, barH)
            self.scrollbar.Visible  = true
        else
            self.scrollbar.Visible = false
        end

        -- Layout items
        local curY = contentY + Theme.Padding - self.scrollY
        for _, item in ipairs(self.items) do
            local ih    = item.height or Theme.ItemH
            local inView = curY + ih > contentY and curY < contentY + contentH

            if item.SetVisible then item:SetVisible(inView and self._visible) end

            if inView and item.Update then
                -- Pass adjusted y so items know where they are on screen
                item:Update(mx, my, m1click, m1down, curY)
            end

            curY = curY + ih + 4
        end
    end

    function self:Remove()
        pcall(function() self.clipBg:Remove() end)
        pcall(function() self.scrollbar:Remove() end)
        for _, item in ipairs(self.items) do
            if item.Remove then item:Remove() end
        end
        self.items = {}
    end

    return self
end

local function makeWindow(title, configId)
    local self         = {}
    self.tabs          = {}
    self.activeTab     = 1
    self.visible       = true
    self._dragging     = false
    self._dragOX       = 0
    self._dragOY       = 0
    self._scrollDelta  = 0

    -- Position
    local vp = game:GetService("Workspace").CurrentCamera
    local vpSize = vp and vp.ViewportSize or Vector2.new(1920, 1080)
    self.x = math.floor((vpSize.X - Theme.WindowW) / 2)
    self.y = math.floor((vpSize.Y - Theme.WindowH) / 2)

    local W = Theme.WindowW
    local H = Theme.WindowH
    local Z = 10

    -- Window background
    self.bg     = makeRoundedRect(Theme.WindowBg, Z, true)
    self.bg:Layout(self.x, self.y, W, H, Theme.Radius)

    -- Window border
    self.border = makeRoundedRect(Theme.Border, Z+1, false)
    self.border:Layout(self.x, self.y, W, H, Theme.Radius)

    -- Title bar background
    self.titleBg = makeRoundedRect(Theme.TitleBg, Z+1, true)
    self.titleBg:Layout(self.x, self.y, W, Theme.TitleH, Theme.Radius)
    -- Cover bottom corners of title bar
    self.titleBgFix = newDrawing("Square", {
        Color   = Theme.TitleBg,
        Filled  = true,
        ZIndex  = Z+1,
        Visible = true,
        Position= Vector2.new(self.x, self.y + Theme.TitleH/2),
        Size    = Vector2.new(W, Theme.TitleH/2),
    })

    -- Title text
    self.titleTxt = newDrawing("Text", {
        Font     = Theme.FontBold,
        Size     = Theme.TitleSize,
        Color    = Theme.TextPrimary,
        Text     = title,
        Outline  = false,
        Center   = false,
        ZIndex   = Z+2,
        Visible  = true,
        Position = Vector2.new(self.x + Theme.Padding, self.y + (Theme.TitleH - Theme.TitleSize)/2),
    })

    -- Close button
    self.closeBtn = newDrawing("Text", {
        Font     = Theme.FontBold,
        Size     = Theme.TitleSize,
        Color    = Theme.TextSecondary,
        Text     = "x",
        Outline  = false,
        Center   = true,
        ZIndex   = Z+2,
        Visible  = true,
        Position = Vector2.new(self.x + W - 18, self.y + (Theme.TitleH - Theme.TitleSize)/2),
    })

    self.tabBarBg = newDrawing("Square", {
        Color   = Theme.TabBg,
        Filled  = true,
        ZIndex  = Z+1,
        Visible = true,
        Position= Vector2.new(self.x, self.y + Theme.TitleH),
        Size    = Vector2.new(W, Theme.TabH),
    })

    -- Tab divider line
    self.tabDivider = newDrawing("Line", {
        Color     = Theme.Border,
        Thickness = 1,
        ZIndex    = Z+2,
        Visible   = true,
        From      = Vector2.new(self.x, self.y + Theme.TitleH + Theme.TabH),
        To        = Vector2.new(self.x + W, self.y + Theme.TitleH + Theme.TabH),
    })

    self._tabBtns = {}

    self._configId = configId

    self._lastScrollY = 0

    function self:AddTab(name)
        local tabIdx = #self.tabs + 1
        local tab    = {}
        tab.name     = name
        tab.content  = makeTabContent(self.x, self.y, W, H, Theme.TitleH, Theme.TabH, Z+3)
        tab.content:SetVisible(tabIdx == 1)

        -- Tab button drawing
        local btn = {
            bg  = newDrawing("Square", { Color=Theme.TabBg, Filled=true, ZIndex=Z+2, Visible=true }),
            txt = newDrawing("Text",   { Font=Theme.Font, Size=Theme.FontSize, Color=Theme.TextSecondary, Outline=false, Center=true, ZIndex=Z+3, Visible=true }),
            indicator = newDrawing("Square", { Color=Theme.Accent, Filled=true, ZIndex=Z+4, Visible=false }),
        }
        table.insert(self._tabBtns, btn)
        table.insert(self.tabs, tab)

        -- ---- Tab item helpers ----

        function tab:AddToggle(label, default, callback)
            local item = makeToggle(self.content.contentX or 0, 0, W-2, label, default, callback, Z+4)
            self.content:AddItem(item, Theme.ItemH)
            return item
        end

        function tab:AddSlider(label, min, max, default, callback)
            local item = makeSlider(self.content.contentX or 0, 0, W-2, label, min, max, default, callback, Z+4)
            self.content:AddItem(item, Theme.ItemH + 10)
            return item
        end

        function tab:AddButton(label, callback)
            local item = makeButton(self.content.contentX or 0, 0, W-2, label, callback, Z+4)
            self.content:AddItem(item, Theme.ItemH)
            return item
        end

        function tab:AddLabel(text, color)
            local item = makeLabel(self.content.contentX or 0, 0, W-2, text, color, Z+4)
            self.content:AddItem(item, Theme.ItemH)
            return item
        end

        function tab:AddSeparator()
            local item = makeSeparator(self.content.contentX or 0, 0, W-2, Z+4)
            self.content:AddItem(item, Theme.ItemH)
            return item
        end

        return tab
    end

    function self:SaveConfig()
        if not self._configId then return end
        local data = {}
        for ti, tab in ipairs(self.tabs) do
            for ii, item in ipairs(tab.content.items) do
                if item.GetValue then
                    data[ti .. "_" .. ii] = item:GetValue()
                end
            end
        end
        saveConfig(self._configId, data)
    end

    function self:LoadConfig()
        if not self._configId then return end
        local data = loadConfig(self._configId)
        if not data then return end
        for ti, tab in ipairs(self.tabs) do
            for ii, item in ipairs(tab.content.items) do
                local key = ti .. "_" .. ii
                if data[key] ~= nil and item.SetValue then
                    item:SetValue(data[key])
                end
            end
        end
    end

    function self:_layoutTabs()
        local count = #self.tabs
        if count == 0 then return end
        local btnW = math.floor(W / count)
        for i, btn in ipairs(self._tabBtns) do
            local bx = self.x + (i-1) * btnW
            local by = self.y + Theme.TitleH
            local isActive = (i == self.activeTab)

            btn.bg.Position  = Vector2.new(bx, by)
            btn.bg.Size      = Vector2.new(btnW, Theme.TabH)
            btn.bg.Color     = isActive and Theme.TabActiveBg or Theme.TabBg
            btn.bg.Visible   = self.visible

            btn.txt.Text     = self.tabs[i].name
            btn.txt.Color    = isActive and Theme.TextPrimary or Theme.TextSecondary
            btn.txt.Position = Vector2.new(math.floor(bx + btnW/2), math.floor(by + (Theme.TabH - Theme.FontSize)/2))
            btn.txt.Visible  = self.visible

            btn.indicator.Position = Vector2.new(bx + 4, by + Theme.TabH - 2)
            btn.indicator.Size     = Vector2.new(btnW - 8, 2)
            btn.indicator.Visible  = self.visible and isActive
        end
    end

    function self:_layoutChrome()
        self.bg:Layout(self.x, self.y, W, H, Theme.Radius)
        self.border:Layout(self.x, self.y, W, H, Theme.Radius)
        self.titleBg:Layout(self.x, self.y, W, Theme.TitleH, Theme.Radius)
        self.titleBgFix.Position = Vector2.new(self.x, self.y + Theme.TitleH/2)
        self.titleBgFix.Size     = Vector2.new(W, Theme.TitleH/2)
        self.titleTxt.Position   = Vector2.new(self.x + Theme.Padding, self.y + (Theme.TitleH - Theme.TitleSize)/2)
        self.closeBtn.Position   = Vector2.new(self.x + W - 18, self.y + (Theme.TitleH - Theme.TitleSize)/2)
        self.tabBarBg.Position   = Vector2.new(self.x, self.y + Theme.TitleH)
        self.tabBarBg.Size       = Vector2.new(W, Theme.TabH)
        self.tabDivider.From     = Vector2.new(self.x, self.y + Theme.TitleH + Theme.TabH)
        self.tabDivider.To       = Vector2.new(self.x + W, self.y + Theme.TitleH + Theme.TabH)

        -- Update content area origin for each tab
        for _, tab in ipairs(self.tabs) do
            tab.content.contentX = self.x + 1
            tab.content.contentY = self.y + Theme.TitleH + Theme.TabH
            tab.content.clipBg.Position = Vector2.new(self.x+1, self.y + Theme.TitleH + Theme.TabH)
        end
    end

    function self:Update(scrollDelta)
        local mx, my     = _mx, _my
        local m1click    = _m1Clicked
        local m1down     = _m1Last

        if not self.visible then return end

        -- Dragging
        local onTitle = inRect(self.x, self.y, W, Theme.TitleH)
        if m1click and onTitle then
            -- Check close button
            if inRect(self.x + W - 24, self.y, 24, Theme.TitleH) then
                self.visible = false
                self:_setAllVisible(false)
                return
            end
            self._dragging = true
            self._dragOX   = mx - self.x
            self._dragOY   = my - self.y
        end
        if not m1down then self._dragging = false end
        if self._dragging then
            self.x = mx - self._dragOX
            self.y = my - self._dragOY
        end

        -- Tab switching
        local count = #self.tabs
        if count > 0 then
            local btnW = math.floor(W / count)
            for i = 1, count do
                local bx = self.x + (i-1) * btnW
                local by = self.y + Theme.TitleH
                if m1click and inRect(bx, by, btnW, Theme.TabH) then
                    if i ~= self.activeTab then
                        self.tabs[self.activeTab].content:SetVisible(false)
                        self.activeTab = i
                        self.tabs[self.activeTab].content:SetVisible(true)
                    end
                end
            end
        end

        self:_layoutChrome()
        self:_layoutTabs()

        -- Update active tab content
        local onWindow = inRect(self.x, self.y, W, H)
        local sd = onWindow and scrollDelta or 0
        for i, tab in ipairs(self.tabs) do
            if i == self.activeTab then
                tab.content:Update(mx, my, m1click, m1down, sd)
            end
        end
    end

    function self:_setAllVisible(v)
        self.bg:SetVisible(v)
        self.border:SetVisible(v)
        self.titleBg:SetVisible(v)
        self.titleBgFix.Visible  = v
        self.titleTxt.Visible    = v
        self.closeBtn.Visible    = v
        self.tabBarBg.Visible    = v
        self.tabDivider.Visible  = v
        for _, btn in ipairs(self._tabBtns) do
            btn.bg.Visible        = v
            btn.txt.Visible       = v
            btn.indicator.Visible = v
        end
        for _, tab in ipairs(self.tabs) do
            tab.content:SetVisible(v and self.tabs[self.activeTab] == tab)
        end
    end

    function self:Toggle()
        self.visible = not self.visible
        self:_setAllVisible(self.visible)
    end

    function self:Remove()
        self.bg:Remove(); self.border:Remove()
        self.titleBg:Remove()
        pcall(function() self.titleBgFix:Remove() end)
        pcall(function() self.titleTxt:Remove() end)
        pcall(function() self.closeBtn:Remove() end)
        pcall(function() self.tabBarBg:Remove() end)
        pcall(function() self.tabDivider:Remove() end)
        for _, btn in ipairs(self._tabBtns) do
            pcall(function() btn.bg:Remove() end)
            pcall(function() btn.txt:Remove() end)
            pcall(function() btn.indicator:Remove() end)
        end
        for _, tab in ipairs(self.tabs) do
            tab.content:Remove()
        end
    end

    return self
end

local Lib = {}
Lib._windows     = {}
Lib._running     = true
Lib._scrollDelta = 0
Lib._toggleKey   = 0x2D  

function Lib:CreateWindow(title, configId)
    local win = makeWindow(title, configId)
    table.insert(self._windows, win)
    return win
end

function Lib:SetToggleKey(vk)
    self._toggleKey = vk
end

function Lib:SetTheme(overrides)
    for k, v in pairs(overrides) do
        Theme[k] = v
    end
end

function Lib:Destroy()
    self._running = false
    for _, win in ipairs(self._windows) do
        win:Remove()
    end
    self._windows = {}
end

local RS = game:GetService("RunService")

local _togglePressed = false

RS.RenderStepped:Connect(function()
    if not Lib._running then return end

    updateInput()

    local tkDown = iskeypressed(Lib._toggleKey)
    if tkDown and not _togglePressed then
        for _, win in ipairs(Lib._windows) do
            win:Toggle()
        end
    end
    _togglePressed = tkDown

    for _, win in ipairs(Lib._windows) do
        win:Update(Lib._scrollDelta)
    end

    Lib._scrollDelta = 0
end)

return Lib