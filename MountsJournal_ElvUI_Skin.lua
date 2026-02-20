local E = ElvUI[1]
if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.collections) then return end
local S = E:GetModule("Skins")
local TT = E:GetModule('Tooltip')


local function setBorderButton(btn, func)
	btn:SetTemplate("Transparent", nil, nil, true)
	btn.LeftEdge:Point("TOPLEFT", 1, -1)
	btn.LeftEdge:Point("BOTTOMLEFT", 1, 1)
	btn.RightEdge:Point("TOPRIGHT", -1, -1)
	btn.RightEdge:Point("BOTTOMRIGHT", -1, 1)
	btn.TopEdge:Point("TOPLEFT", 1, -1)
	btn.TopEdge:Point("TOPRIGHT", -1, -1)
	btn.BottomEdge:Point("BOTTOMLEFT", 1, 1)
	btn.BottomEdge:Point("BOTTOMRIGHT", -1, 1)
	btn.Center:Point("TOPLEFT", 1, -1)
	btn.Center:Point("BOTTOMRIGHT", -1, 1)
	btn.TopLeftCorner:Point("TOPLEFT", 1, -1)
	btn.TopRightCorner:Point("TOPRIGHT", -1, -1)
	btn.BottomLeftCorner:Point("BOTTOMLEFT", 1, 1)
	btn.BottomRightCorner:Point("BOTTOMRIGHT", -1, 1)
	btn.dSetBackdropBorderColor = btn.SetBackdropBorderColor
	btn.SetBackdropBorderColor = func
end


-- PET LIST
local function setQuality(texture, ...)
	texture:GetParent().icon.backdrop:SetBackdropBorderColor(...)
end


local function selectedTextureSetShown(texture, shown)
	local btn = texture:GetParent()
	if btn.hovered then return end
	if shown then
		btn.backdrop:SetBackdropBorderColor(1, .8, .1)
	else
		local r, g, b = unpack(E.media.bordercolor)
		btn.backdrop:SetBackdropBorderColor(r, g, b)
	end
end


local function petBtnOnEnter()
	if not MJTooltipModel:IsShown() then return end
	local point, rFrame, rPoint, x, y = GameTooltip:GetPoint(1)
	GameTooltip:Point(point, rFrame, rPoint, x, -y)
	point, rFrame, rPoint, x, y = MJTooltipModel:GetPoint(1)
	if point == "LEFT" then
		point, rFrame, rPoint, x, y = MJTooltipModel:GetPoint(2)
	end
	MJTooltipModel:Point(point, rFrame, rPoint, 2, 1)
end


local function btnOnEnter(btn)
	local r, g, b = unpack(E.media.rgbvaluecolor)
	btn.backdrop:SetBackdropBorderColor(r, g, b)
	btn.hovered = true
	petBtnOnEnter()
end


local function btnOnLeave(btn)
	local icon = btn.icon or btn.Icon
	if btn.selectedTexture:IsShown() then
		btn.backdrop:SetBackdropBorderColor(1, .8, .1)
	else
		local r, g, b = unpack(E.media.bordercolor)
		btn.backdrop:SetBackdropBorderColor(r, g, b)
	end
	btn.hovered = nil
end


local function gModelBtnBorder(btn, r, ...)
	if r > .3 then
		btn:dSetBackdropBorderColor(r, ...)
	else
		btn:dSetBackdropBorderColor(unpack(E.media.bordercolor))
	end
end


local function petButtonSkin(btn, rightPadding)
	if btn.background then
		btn.background:SetTexture()
		btn:GetHighlightTexture():SetTexture()
		btn:CreateBackdrop('Transparent', nil, nil, true)
		btn.backdrop:ClearAllPoints()
		btn.backdrop:Point("TOPLEFT", btn, 38, -1)
		btn.backdrop:Point("BOTTOMRIGHT", btn, rightPadding, 1)
		btn.selectedTexture:SetTexture()
		btn.petTypeIcon:Point("BOTTOMRIGHT", -3, 1)

		local infoFrame = btn.infoFrame
		infoFrame.icon:SetTexCoord(unpack(E.TexCoords))
		infoFrame.icon:CreateBackdrop(nil, nil, nil, true)
		infoFrame.levelBG:StripTextures()
		infoFrame.level:ClearAllPoints()
		infoFrame.level:Point("BOTTOMRIGHT", -1, 1)

		btn:HookScript("OnEnter", btnOnEnter)
		btn:HookScript("OnLeave", btnOnLeave)
		hooksecurefunc(btn.selectedTexture, "SetShown", selectedTextureSetShown)

		if infoFrame.qualityBorder then -- retail
			infoFrame.qualityBorder:SetTexture()
			hooksecurefunc(infoFrame.qualityBorder, "SetVertexColor", setQuality)
		end
	else
		setBorderButton(btn, gModelBtnBorder)
		btn.levelBG:StripTextures()
		btn.level:ClearAllPoints()
		btn.level:Point("BOTTOMLEFT", 4, 4)
		btn:HookScript("OnEnter", petBtnOnEnter)
	end
end


local function scrollPetButtons(frame)
	if not frame then return end

	for i, btn in ipairs({frame.ScrollTarget:GetChildren()}) do
		if not btn.isSkinned then
			petButtonSkin(btn, -2)
			btn.isSkinned = true
		end
	end
end


local function petListSkin(journal, petList)
	local bgFrame = journal.bgFrame

	petList:StripTextures()
	petList:CreateBackdrop("Transparent")
	petList:Point("TOPLEFT", bgFrame, "TOPRIGHT", 2, -1)
	petList:Point("BOTTOMLEFT", bgFrame, "BOTTOMRIGHT", 2, 1)

	petList.controlPanel:StripTextures()
	S:HandleButton(petList.viewToggle)
	petList.viewToggle:SetSize(22, 22)
	S:HandleEditBox(petList.searchBox)
	petList.searchBox:ClearAllPoints()
	petList.searchBox:Point("TOPLEFT", petList.viewToggle, "TOPRIGHT", 5, -1)
	petList.searchBox:Point("RIGHT", petList.closeButton, "LEFT", -2, 0)
	petList.searchBox:SetHeight(20)
	S:HandleCloseButton(petList.closeButton)
	petList.closeButton:Point("TOPRIGHT", 4, 4)

	petList.filtersPanel:StripTextures()
	petList.filtersPanel:SetHeight(26)

	for i, btn in ipairs(petList.filtersPanel.buttons) do
		S:HandleButton(btn)
		local checkedTexture = btn:GetCheckedTexture()
		checkedTexture:SetTexture(E.Media.Textures.White8x8)
		checkedTexture:SetVertexColor(0.9, 0.8, 0.1, 0.1)
		btn.icon:SetTexCoord(unpack(E.TexCoords))
	end

	petList.petListFrame:Point("TOPLEFT", petList.filtersPanel, "BOTTOMLEFT", 0, -1)
	petList.petListFrame:Point("BOTTOMRIGHT", petList.controlButtons, "TOPRIGHT", 0, 1)
	petList.petListFrame:StripTextures()

	petList.controlButtons:StripTextures()
	petButtonSkin(petList.randomFavoritePet, 0)
	petButtonSkin(petList.randomPet, 0)
	petButtonSkin(petList.noPet, 0)

	S:HandleTrimScrollBar(petList.petListFrame.scrollBar)
	hooksecurefunc(petList.scrollBox, "Update", scrollPetButtons)

	petList.companionOptionsMenu:ddSetDisplayMode("ElvUI")
end


-- PET SELECTION BTN
local petSelectionBtnSkin do
	local function setVertexColor(self, ...)
		local parent = self:GetParent()
		if parent.hovered then return end
		parent.icon.backdrop:SetBackdropBorderColor(...)
	end

	local function hide(self)
		local parent = self:GetParent()
		if parent.hovered then return end
		local r, g, b = unpack(E.media.bordercolor)
		parent.icon.backdrop:SetBackdropBorderColor(r, g, b)
	end

	local function onEnter(self)
		local infoFrame = self.infoFrame
		infoFrame.icon.backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		infoFrame.hovered = true
		petBtnOnEnter()
	end

	local function onLeave(self)
		local infoFrame = self.infoFrame
		if infoFrame.qualityBorder and infoFrame.qualityBorder:IsShown() then -- retail
			infoFrame.icon.backdrop:SetBackdropBorderColor(infoFrame.qualityBorder:GetVertexColor())
		else
			infoFrame.icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		infoFrame.hovered = nil
	end

	function petSelectionBtnSkin(btn)
		btn.bg:SetTexCoord(unpack(E.TexCoords))
		btn.border:SetTexture()
		btn.highlight:SetTexture()
		S:HandleButton(btn)

		local infoFrame = btn.infoFrame
		infoFrame.icon:SetTexCoord(unpack(E.TexCoords))
		infoFrame.icon:CreateBackdrop(nil, nil, nil, true)
		infoFrame.levelBG:StripTextures()
		infoFrame.level:ClearAllPoints()
		infoFrame.level:Point("BOTTOMRIGHT", -2, 2)

		infoFrame.qualityBorder:SetTexture()
		hooksecurefunc(infoFrame.qualityBorder, "SetVertexColor", setVertexColor)
		setVertexColor(infoFrame.qualityBorder, infoFrame.qualityBorder:GetVertexColor())
		hooksecurefunc(infoFrame.qualityBorder, "Hide", hide)

		btn:HookScript("OnEnter", onEnter)
		btn:HookScript("OnLeave", onLeave)
	end
end


-- MOUNT SCROLL BUTTONS
local function dSetQuality(texture, ...)
	texture:GetParent().icon.backdrop:SetBackdropBorderColor(...)
end


local function dSelectedTextureSetShown(texture, shown)
	local btn = texture:GetParent()
	if btn.hovered then return end
	if shown then
		btn.backdrop:SetBackdropBorderColor(1, .8, .1)
	else
		local r, g, b = unpack(E.media.bordercolor)
		btn.backdrop:SetBackdropBorderColor(r, g, b)
	end
end


local function dBtnDragOnEnter(btn)
	local point, rFrame, rPoint, x, y = GameTooltip:GetPoint()
	if rFrame == MJTooltipModel then
		GameTooltip:Point(point, rFrame, rPoint, -x, y)
	end
end


local function dBtnOnEnter(btn)
	local r, g, b = unpack(E.media.rgbvaluecolor)
	btn.backdrop:SetBackdropBorderColor(r, g, b)
	btn.hovered = true
end


local function dBtnOnLeave(btn)
	if btn.selectedTexture:IsShown() then
		btn.backdrop:SetBackdropBorderColor(1, .8, .1)
	else
		local r, g, b = unpack(E.media.bordercolor)
		btn.backdrop:SetBackdropBorderColor(r, g, b)
	end
	btn.hovered = nil
end


local function gSetQuality(texture, ...)
	local btn = texture:GetParent()
	if not (btn.hovered or btn.selectedTexture:IsShown()) then
		btn.icon.backdrop:SetBackdropBorderColor(...)
	end
end


local function gSelectedTextureSetShown(texture, shown)
	local btn = texture:GetParent()
	if btn.hovered then return end
	if shown then
		btn.icon.backdrop:SetBackdropBorderColor(1, .8, .1)
	elseif btn.qualityBorder then -- retail
		btn.icon.backdrop:SetBackdropBorderColor(btn.qualityBorder:GetVertexColor())
	else -- classic
		btn.icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end
end


local function gBtnOnEnter(btn)
	local r, g, b = unpack(E.media.rgbvaluecolor)
	btn.icon.backdrop:SetBackdropBorderColor(r, g, b)
	btn.hovered = true
	dBtnDragOnEnter(btn)
end


local function gBtnOnLeave(btn)
	if btn.selectedTexture:IsShown() then
		btn.icon.backdrop:SetBackdropBorderColor(1, .8, .1)
	elseif btn.qualityBorder then -- retail
		btn.icon.backdrop:SetBackdropBorderColor(btn.qualityBorder:GetVertexColor())
	else -- classic
		btn.icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end
	btn.hovered = nil
end


local function scrollMountButtons(frame)
	if not frame then return end

	for i, btn in ipairs({frame.ScrollTarget:GetChildren()}) do
		if not btn.isSkinned then
			if btn.modelScene then
				setBorderButton(btn, gModelBtnBorder)

				local drag = btn.dragButton
				drag.icon:ClearAllPoints()
				drag.icon:Point("TOPLEFT", drag, 1, -1)
				drag.icon:Point("BOTTOMRIGHT", drag, -1, 1)
				drag.icon:SetTexCoord(unpack(E.TexCoords))
				drag.icon:CreateBackdrop(nil, nil, nil, true)
				drag.highlight:SetTexture()
				drag.selectedTexture:SetTexture(E.Media.Textures.White8x8)
				drag.selectedTexture:SetVertexColor(0.9, 0.8, 0.1, 0.3)

				drag:HookScript("OnEnter", gBtnOnEnter)
				drag:HookScript("OnLeave", gBtnOnLeave)

				if drag.qualityBorder then -- retail
					drag.qualityBorder:SetTexture()
					hooksecurefunc(drag.qualityBorder, "SetVertexColor", gSetQuality)
				end

				petSelectionBtnSkin(btn.petSelectionBtn)
			elseif btn.dragButton then
				btn.background:SetTexture()
				btn.selectedTexture:SetTexture()
				btn.highlight:SetTexture()

				btn:CreateBackdrop("Transparent", nil, nil, true)
				btn.backdrop:ClearAllPoints()
				btn.backdrop:Point('TOPLEFT', btn, 1, -1)
				btn.backdrop:Point('BOTTOMRIGHT', btn, -1, 1)

				btn.factionIcon:Size(36)
				btn.factionIcon:Point("BOTTOMRIGHT", -2, 2)

				btn.dragButton.highlight:SetTexture()
				btn.dragButton.icon:Size(36)
				btn.dragButton.icon:SetTexCoord(unpack(E.TexCoords))
				btn.dragButton.icon:CreateBackdrop(nil, nil, nil, true)
				btn.dragButton.activeTexture:SetTexture(E.Media.Textures.White8x8)
				btn.dragButton.activeTexture:SetVertexColor(0.9, 0.8, 0.1, 0.3)
				btn.dragButton:HookScript("OnEnter", dBtnDragOnEnter)

				btn:HookScript("OnEnter", dBtnOnEnter)
				btn:HookScript("OnLeave", dBtnOnLeave)
				hooksecurefunc(btn.selectedTexture, "SetShown", dSelectedTextureSetShown)
				dSelectedTextureSetShown(btn.selectedTexture, btn.selectedTexture:IsShown())

				if btn.dragButton.qualityBorder then -- retail
					btn.dragButton.qualityBorder:SetTexture()
					hooksecurefunc(btn.dragButton.qualityBorder, "SetVertexColor", dSetQuality)
					dSetQuality(btn.dragButton.qualityBorder, btn.dragButton.qualityBorder:GetVertexColor())
				end
			else
				btn.icon:ClearAllPoints()
				btn.icon:Point("TOPLEFT", btn, 1, -1)
				btn.icon:Point("BOTTOMRIGHT", btn, -1, 1)
				btn.icon:SetTexCoord(unpack(E.TexCoords))
				btn.icon:CreateBackdrop(nil, nil, nil, true)
				btn.highlight:SetTexture()
				btn.selectedTexture:SetTexture()

				btn:HookScript("OnEnter", gBtnOnEnter)
				btn:HookScript("OnLeave", gBtnOnLeave)
				hooksecurefunc(btn.selectedTexture, "SetShown", gSelectedTextureSetShown)
				gSelectedTextureSetShown(btn.selectedTexture, btn.selectedTexture:IsShown())

				if btn.qualityBorder then -- retail
					btn.qualityBorder:SetTexture()
					hooksecurefunc(btn.qualityBorder, "SetVertexColor", gSetQuality)
				end
			end

			btn.isSkinned = true
		end
	end
end


local function ddButton(btn)
	btn:ddSetDisplayMode("ElvUI")
	if btn.isSkinned then return end
	if btn.Button then -- classic
		btn.Left:SetTexture()
		btn.Right:SetTexture()
		btn.Middle:SetTexture()
		btn:StripTextures()
		btn:CreateBackdrop()
		btn:SetFrameLevel(btn:GetFrameLevel() + 2)
		btn.backdrop:Point("TOPLEFT", 3, 1)
		btn.backdrop:Point("BOTTOMRIGHT", 1, 2)
		btn.Button.SetPoint = E.noop
		S:HandleNextPrevButton(btn.Button, "down")
	else -- retail
		btn.Background:SetTexture()
		if not btn.backdrop then
			btn:CreateBackdrop(template)
			btn:SetFrameLevel(btn:GetFrameLevel() + 2)
		end
		btn.backdrop:Point("TOPLEFT", 0, -2)
		btn.backdrop:Point("BOTTOMRIGHT", 0, 2)
		btn.Arrow:SetAlpha(0)
		local tex = btn:CreateTexture(nil, "ARTWORK")
		tex:SetTexture(E.Media.Textures.ArrowUp)
		tex:SetRotation(3.14)
		tex:Point('RIGHT', btn.backdrop, -3, 0)
		tex:Size(14)
	end
	btn.isSkinned = true
end


local function ddStreachButton(btn)
	btn:ddSetDisplayMode("ElvUI")
	if btn.isSkinned then return end
	btn.Arrow:SetTexture(E.Media.Textures.ArrowUp)
	btn.Arrow:SetRotation(S.ArrowRotation.right)
	btn.Arrow:SetVertexColor(1, 1, 1)
	S:HandleButton(btn)
end


-- JOURNAL
local function journal_init(journal)
	local bgFrame = journal.bgFrame
	S:HandlePortraitFrame(bgFrame)
	S:HandleCloseButton(bgFrame.closeButton)

	local function updateBG(self)
		local collect = journal.CollectionsJournal
		local show = not self:IsShown()
		collect.backdrop:SetShown(show)
		CollectionsJournalTitleText:SetShown(show)
		collect.CloseButton:SetShown(show)
	end
	updateBG(bgFrame)
	bgFrame:HookScript("OnShow", updateBG)
	bgFrame:HookScript("OnHide", updateBG)

	journal.navBar:StripTextures()
	journal.navBar.overlay:StripTextures()
	journal.navBar.homeButton:StripTextures()
	S:HandleButton(journal.navBar.homeButton)
	journal.navBar.homeButton:SetHeight(28)
	journal.navBar.homeButton.xoffset = 1
	journal.navBar.dropDown:ddSetDisplayMode("ElvUI")
	S:HandleButton(journal.navBar.overflowButton)
	journal.navBar.overflowButton:SetHeight(28)
	for _, tex in ipairs({journal.navBar.overflowButton:GetNormalTexture(), journal.navBar.overflowButton:GetPushedTexture()}) do
		S:SetupArrow(tex, 'left')
		tex:SetTexCoord(0, 1, 0, 1)
		tex:ClearAllPoints()
		tex:Point('CENTER')
		tex:Size(14)
	end

	journal.mountCount:StripTextures()
	bgFrame.rightInset:StripTextures()
	bgFrame.rightInset:Point("BOTTOM", 0, 27)
	journal.mountDisplay:StripTextures()
	journal.mountDisplay.shadowOverlay:StripTextures()

	if bgFrame.slotButton then -- retail
		local scale = bgFrame.slotButton:GetScale()
		local width, height = bgFrame.slotButton:GetSize()
		bgFrame.slotButton:SetScale(1)
		bgFrame.slotButton:SetSize(width * scale, height * scale)
		bgFrame.slotButton:StripTextures()
		S:HandleButton(bgFrame.slotButton)
		S:HandleIcon(bgFrame.slotButton.ItemIcon)
		width, height = bgFrame.slotButton.ItemIcon:GetSize()
		bgFrame.slotButton.ItemIcon:SetSize(width * scale, height * scale)
	end

	if bgFrame.OpenDynamicFlightSkillTreeButton then -- retail
		local function HandleDynamicFlightButton(button)
			button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			button:SetNormalTexture(0)
			button:StyleButton()

			local icon = select(4, button:GetRegions())
			if icon then
				S:HandleIcon(icon)
			end
		end

		HandleDynamicFlightButton(bgFrame.OpenDynamicFlightSkillTreeButton)
		HandleDynamicFlightButton(bgFrame.DynamicFlightModeButton)
		HandleDynamicFlightButton(bgFrame.targetMount)
	else -- classic
		S:HandleItemButton(bgFrame.targetMount)
	end
	local targetChecked = bgFrame.targetMount.checkedTexture
	targetChecked:SetTexture()
	targetChecked:CreateBackdrop("Transparent")
	targetChecked.backdrop:SetBackdropBorderColor(.5, .9, .5)
	targetChecked.backdrop:SetShown(targetChecked:IsShown())
	targetChecked:HookScript("OnShow", function(self) self.backdrop:Show() end)
	targetChecked:HookScript("OnHide", function(self) self.backdrop:Hide() end)

	S:HandleItemButton(bgFrame.summon1)
	bgFrame.summon1.icon:SetDrawLayer("OVERLAY")
	S:HandleItemButton(bgFrame.summon2)
	bgFrame.summon2.icon:SetDrawLayer("OVERLAY")

	bgFrame.summonPanelSettings:ddSetDisplayMode("ElvUI")
	S:HandleSliderFrame(MountsJournal.summonPanel.fade.slider)
	MountsJournal.summonPanel.fade.slider:Point("BOTTOMLEFT", 0, 3)
	S:HandleSliderFrame(MountsJournal.summonPanel.resize.slider)
	MountsJournal.summonPanel.resize.slider:Point("BOTTOMLEFT", 0, 3)

	journal.filtersPanel:StripTextures()
	S:HandleButton(journal.gridToggleButton)
	journal.gridToggleButton:SetSize(22, 22)
	S:HandleButton(journal.filtersToggle)
	journal.filtersToggle:SetSize(22, 22)
	S:HandleEditBox(journal.searchBox)
	ddStreachButton(journal.filtersButton)
	journal.filtersButton:Point("LEFT", journal.searchBox, "RIGHT", 5, 0)
	journal.filtersBar:StripTextures()
	journal.filtersBar:SetTemplate("Transparent")

	journal.gridToggleButton:Point("TOPLEFT", 3, -4)
	journal.filtersToggle:Point("LEFT", journal.gridToggleButton, "RIGHT", 1, 0)
	journal.searchBox:Point("TOPRIGHT", -96, -5)

	S:HandleSliderFrame(journal.gridModelSettings.strideSlider.slider)
	journal.gridModelSettings.strideSlider.slider:Point("BOTTOMLEFT", 0, 5)
	ddButton(journal.gridModelAnimation)
	journal.gridModelAnimation:SetHeight(25)

	journal.inspectFrame:StripTextures()
	journal.inspectFrame:SetTemplate("Transparent")
	if journal.inspectFrame.TitleContainer.TitleBg then -- classic
		journal.inspectFrame.TitleContainer.TitleBg:Hide()
	end
	S:HandleCloseButton(journal.inspectFrame.close)
	journal.inspectFrame.settings:ddSetDisplayMode("ElvUI")

	local function tabOnEnter(self)
		self.text:SetTextColor(0.9, 0.8, 0.1)
	end

	local function tabOnLeave(self)
		self.text:SetTextColor(1, 1, 1)
	end

	for i, tab in ipairs(journal.filtersBar.tabs) do
		tab:StripTextures()
		tab.selected:StripTextures()
		tab.selected:CreateBackdrop()
		tab.selected.backdrop:Point('TOPLEFT', 3, -3)
		tab.selected.backdrop:Point('BOTTOMRIGHT', -3, 3)
		tab:HookScript("OnEnter", tabOnEnter)
		tab:HookScript("OnLeave", tabOnLeave)

		for j, btn in ipairs(tab.content.childs) do
			S:HandleButton(btn)
			local checkedTexture = btn:GetCheckedTexture()
			checkedTexture:SetTexture(E.Media.Textures.White8x8)
			checkedTexture:SetVertexColor(0.9, 0.8, 0.1, 0.1)
		end
	end

	journal.shownPanel:StripTextures()
	journal.shownPanel:SetTemplate("Transparent")
	journal.shownPanel.resetFilter:ddSetDisplayMode("ElvUI")
	bgFrame.leftInset:StripTextures()
	bgFrame.leftInset:Point("BOTTOMLEFT", 0, 27)
	S:HandleTrimScrollBar(journal.leftInset.scrollBar)
	hooksecurefunc(journal.scrollBox, "Update", scrollMountButtons)
	scrollMountButtons(journal.scrollBox)

	journal.tags.mountOptionsMenu:ddSetDisplayMode("ElvUI")
	S:HandleSliderFrame(journal.percentSlider.slider)
	journal.percentSlider.slider:Point("BOTTOMLEFT", 0, 3)

	S:HandleSliderFrame(journal.xInitialAcceleration.slider)
	journal.xInitialAcceleration.slider:Point("BOTTOMLEFT", 0, 3)
	S:HandleSliderFrame(journal.xAcceleration.slider)
	journal.xAcceleration.slider:Point("BOTTOMLEFT", 0, 3)
	S:HandleSliderFrame(journal.xMinSpeed.slider)
	journal.xMinSpeed.slider:Point("BOTTOMLEFT", 0, 3)

	S:HandleSliderFrame(journal.yInitialAcceleration.slider)
	journal.yInitialAcceleration.slider:Point("BOTTOMLEFT", 0, 3)
	S:HandleSliderFrame(journal.yAcceleration.slider)
	journal.yAcceleration.slider:Point("BOTTOMLEFT", 0, 3)
	S:HandleSliderFrame(journal.yMinSpeed.slider)
	journal.yMinSpeed.slider:Point("BOTTOMLEFT", 0, 3)

	if bgFrame.mountColor then -- retail
		S:HandleSliderFrame(bgFrame.mountColor.threshold.slider)
		bgFrame.mountColor.threshold.slider:Point("BOTTOMLEFT", 0, 3)
		S:HandleButton(bgFrame.mountColor.reset)
	end

	local mountInfo = journal.mountDisplay.info
	mountInfo.linkLang:ddSetDisplayMode("ElvUI")
	mountInfo.linkLang.arrow:SetTexture(E.Media.Textures.ArrowUp)
	mountInfo.linkLang.arrow:SetRotation(S.ArrowRotation.right)
	mountInfo.linkLang.arrow:SetVertexColor(1, 1, 1)
	S:HandleIcon(mountInfo.icon, true)
	if mountInfo.mountDescriptionToggle then  -- retail
		S:HandleButton(mountInfo.mountDescriptionToggle)
		mountInfo.mountDescriptionToggle:SetWidth(18)
		mountInfo.mountDescriptionToggle:Point("LEFT", mountInfo.icon, "RIGHT", 2, 0)
	end
	petSelectionBtnSkin(mountInfo.petSelectionBtn)

	local petSelectionClick = mountInfo.petSelectionBtn:GetScript("OnClick")
	mountInfo.petSelectionBtn:HookScript("OnClick", function(self)
		petListSkin(journal, self.petSelectionList)
		self:SetScript("OnClick", petSelectionClick)
	end)

	journal.mountDisplay.info.modelSceneSettingsButton:ddSetDisplayMode("ElvUI")
	journal.multipleMountBtn:ddSetDisplayMode("ElvUI")
	ddButton(journal.modelScene.animationsCombobox)

	journal.worldMap:StripTextures()
	ddButton(journal.worldMap.navigation)
	journal.worldMap.navigation:Point("TOPLEFT", 1, -5)

	local mapSettings = journal.mapSettings
	mapSettings:StripTextures()
	mapSettings:SetTemplate("Transparent")
	mapSettings.mapControl:StripTextures()
	ddStreachButton(mapSettings.dnr)
	mapSettings.dnr:Point("TOPLEFT", mapSettings.mapControl, "TOPLEFT", 0, -3)
	mapSettings.dnr:Point("RIGHT", mapSettings.CurrentMap, "LEFT", -1, 0)
	S:HandleButton(mapSettings.CurrentMap)
	mapSettings.CurrentMap:Point("LEFT", mapSettings.mapControl, "LEFT", 134, -1)
	mapSettings.CurrentMap:Point("RIGHT", mapSettings.existingListsToggle, "LEFT", -1, 0)
	mapSettings.CurrentMap:SetWidth(253)
	S:HandleButton(mapSettings.existingListsToggle)
	mapSettings.existingListsToggle:Point("TOPRIGHT", mapSettings.mapControl, 0, -3)
	S:HandleCheckBox(mapSettings.Flags)
	S:HandleCheckBox(mapSettings.Ground)
	S:HandleCheckBox(mapSettings.WaterWalk)
	if mapSettings.HerbGathering then -- retail
		S:HandleCheckBox(mapSettings.HerbGathering)
	end
	ddStreachButton(mapSettings.listFromMap)

	mapSettings.existingLists:StripTextures()
	mapSettings.existingLists:CreateBackdrop("Transparent")
	mapSettings.existingLists:Point("TOPLEFT", bgFrame, "TOPRIGHT", 2, -1)
	mapSettings.existingLists:Point("BOTTOMLEFT", bgFrame, "BOTTOMRIGHT", 2, 1)
	S:HandleEditBox(mapSettings.existingLists.searchBox)
	mapSettings.existingLists.searchBox:Point("TOPLEFT", 10, -6)
	mapSettings.existingLists.searchBox:Point("TOPRIGHT", -7, -6)
	S:HandleTrimScrollBar(mapSettings.existingLists.scrollBar)

	hooksecurefunc(mapSettings.existingLists, "toggleInit", function(self, btn, data)
		btn.toggle:SetTexture(self.categories[data.id].expanded and E.Media.Textures.MinusButton or E.Media.Textures.PlusButton)
	end)

	S:HandleButton(journal.summonButton)
	ddStreachButton(bgFrame.profilesMenu)
	S:HandleButton(journal.mountSpecial)

	bgFrame.calendarFrame:StripTextures()
	S:HandleNextPrevButton(bgFrame.calendarFrame.prevMonthButton, "left", nil, true)
	S:HandleNextPrevButton(bgFrame.calendarFrame.nextMonthButton, "right", nil, true)

	bgFrame.settingsBackground:StripTextures()
	for i, tab in ipairs(bgFrame.settingsBackground.Tabs) do
		S:HandleTab(tab)
	end

	S:HandleTab(journal.bgFrame.settingsTab)
	local point, rFrame, rPoint, x, y = journal.bgFrame.settingsTab:GetPoint()
	journal.bgFrame.settingsTab:Point(point, rFrame, rPoint, x, y - 2)
	S:HandleTab(journal.bgFrame.mapTab)
	journal.bgFrame.mapTab:Point("RIGHT", journal.bgFrame.settingsTab, "LEFT", 5, 0)
	S:HandleTab(journal.bgFrame.modelTab)
	journal.bgFrame.modelTab:Point("RIGHT", journal.bgFrame.mapTab, "LEFT", 5, 0)
end


local journal_updateFilterNavBar do
	local setBackdropBorderColor = function(btn, r)
		if r > .6 then
			local r,g,b = unpack(E.media.rgbvaluecolor)
			btn:dSetBackdropBorderColor(r,g,b)
			btn.texture:SetVertexColor(r,g,b)
		else
			btn:dSetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end

	function journal_updateFilterNavBar(journal)
		for btn in journal.shownPanel.framePool:EnumerateActive() do
			if not btn.isSkinned then
				btn.isSkinned = true
				setBorderButton(btn, setBackdropBorderColor)
			end
		end
	end
end


-- SUMMON PANEL
MountsJournal:on("ADDON_INIT", function(mounts)
	local summonPanel = mounts.summonPanel

	local function skinButton(btn)
		if btn.isSkinned then return end
		btn.isSkinned = true
		local texture = btn.icon:GetTexture()
		btn:StripTextures()
		btn.icon:SetTexCoord(unpack(E.TexCoords))
		if btn.IconMask then -- retail
			btn.IconMask:Hide()
		end
		btn:CreateBackdrop(nil, true, nil, nil, nil, nil, nil, true)
		btn:StyleButton()
		btn.icon:SetInside(btn)
		btn.icon:SetTexture(texture)
	end

	skinButton(summonPanel.summon1)
	skinButton(summonPanel.summon2)
end)


-- OPTIONS
local function config_onShow(self)
	self.leftPanel:StripTextures()
	self.leftPanel:SetTemplate("Transparent")

	S:HandleCheckBox(self.waterJump)
	S:HandleItemButton(self.summon1Icon)
	self.summon1Icon.icon:SetDrawLayer("OVERLAY")
	S:HandleItemButton(self.summon2Icon)
	self.summon2Icon.icon:SetDrawLayer("OVERLAY")

	local function updateBindButton(btn)
		btn.selectedHighlight:SetTexture(E.media.normTex)
		btn.selectedHighlight:Point("TOPLEFT", 1, -1)
		btn.selectedHighlight:Point("BOTTOMRIGHT", -1, 1)
		btn.selectedHighlight:SetColorTexture(1, 1, 1, .25)
		S:HandleButton(btn)
	end

	updateBindButton(self.bindSummon1Key1)
	updateBindButton(self.bindSummon1Key2)
	updateBindButton(self.bindSummon2Key1)
	updateBindButton(self.bindSummon2Key2)
	ddButton(self.modifierCombobox)

	self.rightPanel:StripTextures()
	self.rightPanel:SetTemplate("Transparent")
	S:HandleTrimScrollBar(self.rightPanelScroll.ScrollBar)

	if self.showMinimapButton then -- classic
		self.minimapGroup:StripTextures()
		self.minimapGroup:SetTemplate(nil, true)
		S:HandleCheckBox(self.showMinimapButton)
		S:HandleCheckBox(self.lockMinimapButton)
	end

	if self.useHerbMounts then -- retail
		self.herbGroup:StripTextures()
		self.herbGroup:SetTemplate(nil, true)
		S:HandleCheckBox(self.useHerbMounts)
		S:HandleCheckBox(self.herbMountsOnZones)
	end

	self.repairGroup:StripTextures()
	self.repairGroup:SetTemplate(nil, true)
	S:HandleCheckBox(self.useRepairMounts)
	S:HandleCheckBox(self.repairFlyable)
	S:HandleCheckBox(self.freeSlots)
	ddButton(self.repairMountsCombobox)

	if self.magicBroomGroup then -- retail
		self.magicBroomGroup:StripTextures()
		self.magicBroomGroup:SetTemplate(nil, true)
	end
	S:HandleCheckBox(self.useMagicBroom)

	if self.magicBroomCombobox then -- retail
		ddButton(self.magicBroomCombobox)
	end

	if self.useUnderlightAngler then
		self.underlightAnglerGroup:StripTextures()
		self.underlightAnglerGroup:SetTemplate(nil, true)
		S:HandleCheckBox(self.useUnderlightAngler)
		S:HandleCheckBox(self.autoUseUnderlightAngler)
	end

	self.petGroup:StripTextures()
	self.petGroup:SetTemplate(nil, true)
	S:HandleCheckBox(self.summonPetEvery)
	S:HandleCheckBox(self.summonPetOnlyFavorites)
	S:HandleCheckBox(self.noPetInRaid)
	S:HandleCheckBox(self.noPetInGroup)

	self.mountListGroup:StripTextures()
	self.mountListGroup:SetTemplate(nil, true)
	if self.coloredMountNames then -- retail
		S:HandleCheckBox(self.coloredMountNames)
	end
	S:HandleCheckBox(self.arrowButtons)
	S:HandleCheckBox(self.showTypeSelBtn)

	S:HandleCheckBox(self.copyMountTarget)
	S:HandleCheckBox(self.openLinks)
	S:HandleCheckBox(self.showWowheadLink)
	S:HandleCheckBox(self.statisticCollection)
	S:HandleCheckBox(self.tooltipMount)
	if self.resetHelp then -- retail
		self.tooltipGroup:StripTextures()
		self.tooltipGroup:SetTemplate(nil, true)
		S:HandleCheckBox(self.tooltipItems)
		S:HandleButton(self.resetHelp)
	end
	S:HandleButton(self.applyBtn)
	S:HandleButton(self.cancelBtn)
end


-- IconData
local function config_iconData_onShow(self)
	self:StripTextures()
	self:SetTemplate("Transparent")

	S:HandleItemButton(self.selectedIconBtn)
	self.selectedIconBtn.icon:SetDrawLayer("OVERLAY")
	S:HandleEditBox(self.searchBox)
	self.searchBox:Point("TOPLEFT", 18, -27)
	ddStreachButton(self.filtersButton)
	self.filtersButton:Point("LEFT", self.searchBox, "RIGHT", 5, 0)
	S:HandleTrimScrollBar(self.scrollBar)
	S:HandleButton(self.cancel)
	S:HandleButton(self.ok)

	local function selectedTextureSetShown(texture, shown)
		local btn = texture:GetParent()
		if shown then
			btn.backdrop:SetBackdropBorderColor(1, .8, .1)
		else
			btn.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end

	hooksecurefunc(self.scrollBox, "Update", function(frame)
		for i, btn in ipairs({frame.ScrollTarget:GetChildren()}) do
			if not btn.isSkinned then
				S:HandleItemButton(btn)
				btn.icon:SetDrawLayer("OVERLAY")
				hooksecurefunc(btn.selectedTexture, "SetShown", selectedTextureSetShown)
				selectedTextureSetShown(btn.selectedTexture, btn.selectedTexture:IsShown())
				btn.isSkinned = true
			end
		end
	end)
end


-- CLASSES
local function reskinScrollBarArrow(frame, direction)
	S:HandleNextPrevButton(frame, direction)
	frame.Overlay:SetAlpha(0)
	frame.Texture:Hide()
end


local function reskinEditScrollBar(scrollBar)
	scrollBar.Background:Hide()
	scrollBar:StripTextures()

	local track = scrollBar.Track
	track:SetTemplate("Transparent")
	track:ClearAllPoints()
	track:Point("TOPLEFT", 4, -21)
	track:Point("BOTTOMRIGHT", -3, 21)

	local thumb = track.Thumb
	thumb.Middle:Hide()
	thumb.Begin:Hide()
	thumb.End:Hide()

	thumb:SetTemplate(nil, true, true)
	thumb:SetBackdropColor(unpack(E.media.rgbvaluecolor))

	reskinScrollBarArrow(scrollBar.Back, "up")
	reskinScrollBarArrow(scrollBar.Forward, "down")
end


local function classConfig_onShow(self)
	self.leftPanel:StripTextures()
	self.leftPanel:SetTemplate("Transparent")
	S:HandleCheckBox(self.charCheck)

	local mULx, mULy, mLLx, mLLy, mURx, mURy, mLRx, mLRy = unpack(E.TexCoords)
	mULy, mLLx, mURx, mURy, mLRx, mLRy = mLLx, mULx, mULy, mLLx, mULy, mLLy
	for i, btn in ipairs({self.leftPanel:GetChildren()}) do
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = btn.icon:GetTexCoord()
		local top = URx - ULx
		local right = LRy - URy
		local bottom = LRx - LLx
		local left = LLy - ULy
		URx = ULx + mURx * top
		ULx = ULx + mULx * top
		LRy = URy + mLRy * right
		URy = URy + mURy * right
		LRx = LLx + mLRx * bottom
		LLx = LLx + mLLx * bottom
		LLy = ULy + mLLy * left
		ULy = ULy + mULy * left
		btn.icon:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
	end

	self.rightPanel:StripTextures()
	self.rightPanel:SetTemplate("Transparent")
	self.rightPanel:Point("BOTTOMLEFT", self.leftPanel, "BOTTOMRIGHT", 2, 0)
	S:HandleTrimScrollBar(self.rightPanelScroll.ScrollBar)

	local function reskinEditBox(editFrame)
		editFrame:SetWidth(393)
		editFrame.background:SetTemplate("Transparent")
		S:HandleCheckBox(editFrame.enable)
		editFrame.enable:Point("BOTTOMLEFT", editFrame.background, "TOPLEFT", 10, -3)
		S:HandleButton(editFrame.defaultBtn)
		S:HandleButton(editFrame.cancelBtn)
		editFrame.cancelBtn:Point("TOPRIGHT", editFrame.background, "BOTTOMRIGHT", 0, -1)
		S:HandleButton(editFrame.saveBtn)
		editFrame.saveBtn:Point("RIGHT", editFrame.cancelBtn, "LEFT", -1, 0)
		editFrame.limitText:Point("BOTTOMLEFT", editFrame.background, 10, -14)
		reskinEditScrollBar(editFrame.scrollBar)
	end

	reskinEditBox(self.moveFallMF)
	reskinEditBox(self.combatMF)
end


local function classConfig_showClassSettings(self)
	if self.sliderPool then -- retail
		for option in self.sliderPool:EnumerateActive() do
			if not option.isSkinned then
				S:HandleSliderFrame(option.slider)
				option.slider:Point("BOTTOMLEFT", 0, 3)
				option.isSkinned = true
			end
		end
	end

	for option in self.checkPool:EnumerateActive() do
		if not option.isSkinned then
			S:HandleCheckBox(option)
			option.isSkinned = true
		end
	end
end


-- RULES
local function rules_onShow(self)
	ddStreachButton(self.ruleSets)
	S:HandleButton(self.snippetToggle)
	ddButton(self.summons)
	S:HandleButton(self.addRuleBtn)
	S:HandleButton(self.importRuleBtn)
	S:HandleEditBox(self.searchBox)
	self.searchBox:Point("RIGHT", self.resetRulesBtn, -4, 0)
	S:HandleButton(self.resetRulesBtn)
	S:HandleCheckBox(self.altMode)
	S:HandleTrimScrollBar(self.scrollBar)
	self.ruleMenu:ddSetDisplayMode("ElvUI")

	self.ruleEditor:HookScript("OnShow", function(self)
		self.menu:ddSetDisplayMode("ElvUI")

		self.panel:StripTextures()
		self.panel:SetTemplate()

		S:HandleTrimScrollBar(self.scrollBar)
		S:HandleButton(self.cancel)
		S:HandleButton(self.ok)

		self.mountSelect:StripTextures()
		self.mountSelect:SetTemplate("Transparent")
		S:HandleCloseButton(self.mountSelect.close)

		local onEnter = function(btn)
			btn.normal:SetTexture(E.Media.Textures.ArrowUp)
			btn.normal:SetVertexColor(unpack(E.media.rgbvaluecolor))
		end
		local onLeave = function(btn)
			btn.normal:SetTexture(E.Media.Textures.ArrowUp)
			btn.normal:SetVertexColor(1, 1, 1)
		end

		local function dropDonwSkin(btn)
			btn:StripTextures()
			btn:CreateBackdrop()
			btn.backdrop:Point("TOPLEFT", 0, -5)
			btn.backdrop:Point("BOTTOMRIGHT", 0, 5)

			if btn.arrow then -- retail
				btn.arrow:SetTexture(E.Media.Textures.ArrowUp)
				btn.arrow:SetRotation(S.ArrowRotation.down)
				btn.arrow:Point("RIGHT", -4, 0)
				btn.normal = btn.arrow

				btn:SetScript("OnMouseDown", nil)
				btn:SetScript("OnMouseUp", nil)
				btn:HookScript("OnEnter", onEnter)
				btn:HookScript("OnLeave", onLeave)
			else -- classic
				btn:SetNormalTexture(E.Media.Textures.ArrowUp)
				btn:SetPushedTexture(E.Media.Textures.ArrowUp)

				local rotation = S.ArrowRotation.down
				btn.normal = btn:GetNormalTexture()
				btn.normal:SetRotation(rotation)
				btn:GetPushedTexture():SetRotation(rotation)

				btn:HookScript("OnEnter", onEnter)
				btn:HookScript("OnLeave", onLeave)
			end

		end

		local function scrollButtons(frame)
			if not frame then return end
			for i, panel in ipairs({frame.ScrollTarget:GetChildren()}) do
				if not panel.isSkinned then
					panel.isSkinned = true
					S:HandleCheckBox(panel.notCheck)
					dropDonwSkin(panel.optionType)
				end
			end
		end
		hooksecurefunc(self.scrollBox, "Update", scrollButtons)

		dropDonwSkin(self.actionPanel.optionType)
		local macro = self.actionPanel.macro
		macro:SetTemplate("Transparent")
		reskinEditScrollBar(macro.scrollBar)

		if self.actionPanel.groupName then -- retail
			S:HandleEditBox(self.actionPanel.groupName)
			self.actionPanel.groupName:SetHeight(self.actionPanel.groupName:GetHeight() - 2)
		end

		local function onAcqure()
			for btn in self.btnPool:EnumerateActive() do
				if not btn.isSkinned then
					btn.isSkinned = true
					dropDonwSkin(btn)
				end
			end
			for edit in self.editPool:EnumerateActive() do
				if not edit.isSkinned then
					edit.isSkinned = true
					if edit.border then -- classic
						edit.border:Hide()
						edit:ClearBackdrop()
						edit:CreateBackdrop()
						edit.backdrop:Point("TOPLEFT", 0, -5)
						edit.backdrop:Point("BOTTOMRIGHT", 0, 5)
					else -- retail
						S:HandleEditBox(edit)
						edit:SetHeight(edit:GetHeight() - 2)
					end
				end
			end
		end

		hooksecurefunc(self, "setCondValueOption", onAcqure)
		hooksecurefunc(self, "setActionValueOption", onAcqure)
	end)
end


-- SNIPPETS
local function snippets_onShow(self)
	self:Point("TOPLEFT", MountsJournalFrame.bgFrame, "TOPRIGHT", 1, 0)
	self:Point("BOTTOMLEFT", MountsJournalFrame.bgFrame, "BOTTOMRIGHT", 1, 0)
	self:StripTextures()
	self:SetTemplate("Transparent")
	if self.TitleContainer.TitleBg then -- classic
		self.TitleContainer.TitleBg:Hide()
	end

	S:HandleButton(self.addSnipBtn)
	self.addSnipBtn:Point("RIGHT", -4, 0)
	S:HandleButton(self.importBtn)

	S:HandleEditBox(self.searchBox)
	self.searchBox:Point("LEFT", 12, 0)
	self.searchBox:Point("RIGHT", -8, 0)

	self.bg:StripTextures()
	S:HandleTrimScrollBar(self.scrollBar)

	self.snipMenu:ddSetDisplayMode("ElvUI")
end


local function codeEdit_onShow(self)
	self:StripTextures()
	self:SetTemplate("Transparent")
	S:HandleEditBox(self.nameEdit)
	S:HandleEditBox(self.line)
	ddStreachButton(self.settings)
	ddStreachButton(self.examples)
	S:HandleButton(self.nextBtn)
	S:HandleButton(self.backBtn)
	self.backBtn:Point("RIGHT", self.nextBtn, "LEFT", -1, 0)
	S:HandleButton(self.cancelBtn)
	S:HandleButton(self.completeBtn)

	self.codeBtn:SetTemplate("Transparent")
	self.codeBtn:SetBackdropColor(.08, .08, .08)
	reskinEditScrollBar(self.scrollBar)
end


local function dataDialog_onShow(self)
	self:StripTextures()
	self:SetTemplate("Transparent")
	if self.TitleContainer.TitleBg then -- classic
		self.TitleContainer.TitleBg:Hide()
	end
	S:HandleEditBox(self.nameEdit)
	self.codeBtn:SetTemplate("Transparent")
	reskinEditScrollBar(self.scrollBar)
	S:HandleButton(self.btn1)
	S:HandleButton(self.btn2)
end


local function dataDialog_open(self)
	if self.nameString:IsShown() then
		self.codeBtn:Point("TOPLEFT", self.nameString, "BOTTOMLEFT", -3, -7)
	end
end


local function skinUI()
	if E.private.skins.blizzard.enable and E.private.skins.blizzard.tooltip then
		TT:SetStyle(MJTooltipModel)
		MJTooltipModel.model:Point("TOPLEFT", 1, -1)
		MJTooltipModel.model:SetSize(198, 198)
		MJTooltipModel:HookScript("OnShow", function(self)
			local point, rFrame, rPoint, x, y = self:GetPoint()
			self:Point(point, rFrame, rPoint, -x, -y)
		end)
	end

	S:HandleCheckBox(MountsJournalFrame.useMountsJournalButton)

	hooksecurefunc(MountsJournalFrame, "init", journal_init)
	hooksecurefunc(MountsJournalFrame, "updateFilterNavBar", journal_updateFilterNavBar)
	MountsJournalConfig:HookScript("OnShow", config_onShow)
	MountsJournalConfig.iconData:HookScript("OnShow", config_iconData_onShow)
	MountsJournalConfigClasses:HookScript("OnShow", classConfig_onShow)
	hooksecurefunc(MountsJournalConfigClasses, "showClassSettings", classConfig_showClassSettings)
	MountsJournalConfigRules:HookScript("OnShow", rules_onShow)
	MountsJournalSnippets:HookScript("OnShow", snippets_onShow)
	MountsJournalCodeEdit:HookScript("OnShow", codeEdit_onShow)
	MountsJournalDataDialog:HookScript("OnShow", dataDialog_onShow)
	hooksecurefunc(MountsJournalDataDialog, "open", dataDialog_open)
end


if MountsJournal.ADDON_LOADED then
	hooksecurefunc(MountsJournal, "ADDON_LOADED", function(_, addonName)
		if addonName == "Blizzard_Collections" then skinUI() end
	end)
else
	skinUI()
end


-- DressUpFrame
if DressUpFrame and DressUpFrame.mjBtn then -- retail
	local mjBtn = DressUpFrame.mjBtn
	mjBtn:StripTextures(true)
	mjBtn:Size(14)
	mjBtn:Point("TOPLEFT", 3, -3)
	mjBtn:GetHighlightTexture():Kill()
	mjBtn:SetNormalTexture(E.Media.Textures.ArrowUp)
	mjBtn:GetNormalTexture():SetRotation(math.pi * .25)
	mjBtn:SetPushedTexture(E.Media.Textures.ArrowUp)
	mjBtn:GetPushedTexture():SetRotation(math.pi * .25)
	mjBtn:HookScript("OnEnter", function(btn)
		local r, g, b = unpack(E.media.rgbvaluecolor)
		btn:GetNormalTexture():SetVertexColor(r,g,b)
		btn:GetPushedTexture():SetVertexColor(r,g,b)
	end)
	mjBtn:HookScript("OnLeave", function(btn)
		btn:GetNormalTexture():SetVertexColor(1, 1, 1)
		btn:GetPushedTexture():SetVertexColor(1, 1, 1)
	end)
end
