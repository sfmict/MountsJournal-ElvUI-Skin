local E = ElvUI[1]
if E.private.skins.blizzard.misc ~= true then return end
local S = E:GetModule("Skins")


MJTooltipModel:StripTextures()
MJTooltipModel:CreateBackdrop("Transparent")
MJTooltipModel:HookScript("OnShow", function(self)
	local point, rFrame, rPoint, x, y = self:GetPoint()
	self:Point(point, rFrame, rPoint, -x, -y)
end)


hooksecurefunc(MountsJournalFrame, "ADDON_LOADED", function(journal)
	if journal.useMountsJournalButton then
		S:HandleCheckBox(journal.useMountsJournalButton)
	end
end)


-- PET LIST
local function setQuality(texture, ...)
	texture:GetParent().icon.backdrop:SetBackdropBorderColor(...)
end


local function selectedTextureSetShown(texture, shown)
	local button = texture:GetParent()
	if button.hovered then return end
	if shown then
		button.backdrop:SetBackdropBorderColor(1, .8, .1)
	else
		local r, g, b = unpack(E.media.bordercolor)
		button.backdrop:SetBackdropBorderColor(r, g, b)
	end
end


local function btnOnEnter(button)
	local r, g, b = unpack(E.media.rgbvaluecolor)
	button.backdrop:SetBackdropBorderColor(r, g, b)
	button.hovered = true
end


local function btnOnLeave(button)
	local icon = button.icon or button.Icon
	if button.selectedTexture:IsShown() then
		button.backdrop:SetBackdropBorderColor(1, .8, .1)
	else
		local r, g, b = unpack(E.media.bordercolor)
		button.backdrop:SetBackdropBorderColor(r, g, b)
	end
	button.hovered = nil
end


local function petButtonSkin(button, rightPadding)
	button.background:SetTexture()
	button:GetHighlightTexture():SetTexture()
	button:CreateBackdrop('Transparent', nil, nil, true)
	button.backdrop:ClearAllPoints()
	button.backdrop:Point("TOPLEFT", button, 38, -1)
	button.backdrop:Point("BOTTOMRIGHT", button, rightPadding, 1)
	button.selectedTexture:SetTexture()
	button.petTypeIcon:SetPoint("BOTTOMRIGHT", -3, 1)

	local infoFrame = button.infoFrame
	infoFrame.icon:SetTexCoord(unpack(E.TexCoords))
	infoFrame.icon:CreateBackdrop(nil, nil, nil, true)

	button:HookScript("OnEnter", btnOnEnter)
	button:HookScript("OnLeave", btnOnLeave)
	hooksecurefunc(button.selectedTexture, "SetShown", selectedTextureSetShown)

	if infoFrame.qualityBorder then -- retail
		infoFrame.qualityBorder:SetTexture()
		hooksecurefunc(infoFrame.qualityBorder, "SetVertexColor", setQuality)
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
	petList:SetPoint("TOPLEFT", bgFrame, "TOPRIGHT", 2, -1)
	petList:SetPoint("BOTTOMLEFT", bgFrame, "BOTTOMRIGHT", 2, 1)

	petList.controlPanel:StripTextures()
	S:HandleEditBox(petList.searchBox)
	petList.searchBox:ClearAllPoints()
	petList.searchBox:SetPoint("TOPLEFT", 8, -8)
	petList.searchBox:SetPoint("RIGHT", petList.closeButton, "LEFT", 2, 0)
	petList.searchBox:SetHeight(20)
	S:HandleCloseButton(petList.closeButton)
	petList.closeButton:SetPoint("TOPRIGHT", 4, 4)

	if petList.filtersPanel then -- retail
		petList.filtersPanel:StripTextures()
		petList.filtersPanel:SetHeight(26)

		for i, btn in ipairs(petList.filtersPanel.buttons) do
			S:HandleButton(btn)
			local checkedTexture = btn:GetCheckedTexture()
			checkedTexture:SetTexture(E.Media.Textures.White8x8)
			checkedTexture:SetVertexColor(0.9, 0.8, 0.1, 0.1)
			btn.icon:SetTexCoord(unpack(E.TexCoords))
		end

		petList.petListFrame:SetPoint("TOPLEFT", petList.filtersPanel, "BOTTOMLEFT", 0, -1)
		petList.petListFrame:SetPoint("BOTTOMRIGHT", petList.controlButtons, "TOPRIGHT", 0, 1)
	end
	petList.petListFrame:StripTextures()

	petList.controlButtons:StripTextures()
	petButtonSkin(petList.randomFavoritePet, 0)
	petButtonSkin(petList.randomPet, 0)
	petButtonSkin(petList.noPet, 0)

	S:HandleTrimScrollBar(petList.petListFrame.scrollBar)
	hooksecurefunc(petList.scrollBox, "Update", scrollPetButtons)

	petList.companionOptionsMenu:ddSetDisplayMode("ElvUI")
end


-- MOUNT SCROLL BUTTONS
local function dSetQuality(texture, ...)
	texture:GetParent().icon.backdrop:SetBackdropBorderColor(...)
end


local function dSelectedTextureSetShown(texture, shown)
	local button = texture:GetParent()
	if button.hovered then return end
	if shown then
		button.backdrop:SetBackdropBorderColor(1, .8, .1)
	else
		local r, g, b = unpack(E.media.bordercolor)
		button.backdrop:SetBackdropBorderColor(r, g, b)
	end
end


local function dBtnOnEnter(button)
	local r, g, b = unpack(E.media.rgbvaluecolor)
	button.backdrop:SetBackdropBorderColor(r, g, b)
	button.hovered = true
end


local function dBtnOnLeave(button)
	if button.selectedTexture:IsShown() then
		button.backdrop:SetBackdropBorderColor(1, .8, .1)
	else
		local r, g, b = unpack(E.media.bordercolor)
		button.backdrop:SetBackdropBorderColor(r, g, b)
	end
	button.hovered = nil
end


local function gSetQuality(texture, ...)
	local button = texture:GetParent()
	if not (button.hovered or button.selectedTexture:IsShown()) then
		button.icon.backdrop:SetBackdropBorderColor(...)
	end
end


local function gSelectedTextureSetShown(texture, shown)
	local button = texture:GetParent()
	if button.hovered then return end
	if shown then
		button.icon.backdrop:SetBackdropBorderColor(1, .8, .1)
	elseif button.qualityBorder then -- retail
		button.icon.backdrop:SetBackdropBorderColor(button.qualityBorder:GetVertexColor())
	else -- classic
		button.icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end
end


local function gBtnOnEnter(button)
	local r, g, b = unpack(E.media.rgbvaluecolor)
	button.icon.backdrop:SetBackdropBorderColor(r, g, b)
	button.hovered = true
end


local function gBtnOnLeave(button)
	if button.selectedTexture:IsShown() then
		button.icon.backdrop:SetBackdropBorderColor(1, .8, .1)
	elseif button.qualityBorder then -- retail
		button.icon.backdrop:SetBackdropBorderColor(button.qualityBorder:GetVertexColor())
	else -- classic
		button.icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end
	button.hovered = nil
end


local function scrollMountButtons(frame)
	if not frame then return end

	for i, btn in ipairs({frame.ScrollTarget:GetChildren()}) do
		if not btn.isSkinned then
			if btn.mounts then
				for i, g3btn in ipairs(btn.mounts) do
					g3btn.icon:SetTexCoord(unpack(E.TexCoords))
					g3btn.icon:CreateBackdrop(nil, nil, nil, true)
					g3btn.highlight:SetTexture()
					g3btn.selectedTexture:SetTexture()

					g3btn.fly:SetPoint("TOPLEFT", g3btn, "TOPRIGHT", 2, 0)
					g3btn.ground:SetPoint("TOPLEFT", g3btn, "TOPRIGHT", 2, -14)
					g3btn.swimming:SetPoint("TOPLEFT", g3btn, "TOPRIGHT", 2, -28)

					g3btn:HookScript("OnEnter", gBtnOnEnter)
					g3btn:HookScript("OnLeave", gBtnOnLeave)
					hooksecurefunc(g3btn.selectedTexture, "SetShown", gSelectedTextureSetShown)
					gSelectedTextureSetShown(g3btn.selectedTexture, g3btn.selectedTexture:IsShown())

					if g3btn.qualityBorder then -- retail
						g3btn.qualityBorder:SetTexture()
						hooksecurefunc(g3btn.qualityBorder, "SetVertexColor", gSetQuality)
					end
				end
			else
				btn:StripTextures()
				btn:CreateBackdrop("Transparent", nil, nil, true)
				btn.backdrop:ClearAllPoints()
				btn.backdrop:Point('TOPLEFT', btn, 2, -2)
				btn.backdrop:Point('BOTTOMRIGHT', btn, -2, 2)

				btn.factionIcon:Size(38)
				btn.factionIcon:SetPoint("BOTTOMRIGHT", -2, 3)

				btn.dragButton.highlight:SetTexture()
				btn.dragButton.icon:Size(40)
				btn.dragButton.icon:SetTexCoord(unpack(E.TexCoords))
				btn.dragButton.icon:CreateBackdrop(nil, nil, nil, true)
				btn.dragButton.activeTexture:SetTexture(E.Media.Textures.White8x8)
				btn.dragButton.activeTexture:SetVertexColor(0.9, 0.8, 0.1, 0.3)

				btn:HookScript("OnEnter", dBtnOnEnter)
				btn:HookScript("OnLeave", dBtnOnLeave)
				hooksecurefunc(btn.selectedTexture, "SetShown", dSelectedTextureSetShown)
				dSelectedTextureSetShown(btn.selectedTexture, btn.selectedTexture:IsShown())

				if btn.dragButton.qualityBorder then -- retail
					btn.dragButton.qualityBorder:SetTexture()
					hooksecurefunc(btn.dragButton.qualityBorder, "SetVertexColor", dSetQuality)
					dSetQuality(btn.dragButton.qualityBorder, btn.dragButton.qualityBorder:GetVertexColor())
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
hooksecurefunc(MountsJournalFrame, "init", function(journal)
	local bgFrame = journal.bgFrame
	S:HandlePortraitFrame(bgFrame)
	S:HandleCloseButton(bgFrame.closeButton)

	local function updateBG(self)
		local collect = journal.CollectionsJournal
		local show = not self:IsShown()
		collect.Center:SetShown(show)
		collect.TopEdge:SetShown(show)
		collect.RightEdge:SetShown(show)
		collect.BottomEdge:SetShown(show)
		collect.LeftEdge:SetShown(show)
		CollectionsJournalTitleText:SetShown(show)
		collect.CloseButton:SetShown(show)
		if collect.shadow then -- retail
			collect.shadow:SetShown(show)
		end
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

	journal.mountCount:StripTextures()
	bgFrame.rightInset:StripTextures()
	bgFrame.rightInset:SetPoint("BOTTOM", 0, 27)
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
		bgFrame.targetMount.checkedTexture:SetInside()
		bgFrame.targetMount.checkedTexture:SetColorTexture(.5, .9, .5, .3)
		bgFrame.targetMount.icon:SetDrawLayer("OVERLAY")
	end

	S:HandleItemButton(bgFrame.summon1)
	bgFrame.summon1.icon:SetDrawLayer("OVERLAY")
	S:HandleItemButton(bgFrame.summon2)
	bgFrame.summon2.icon:SetDrawLayer("OVERLAY")

	bgFrame.summonPanelSettings:ddSetDisplayMode("ElvUI")
	S:HandleSliderFrame(journal.summonPanel.fade.slider)
	journal.summonPanel.fade.slider:SetPoint("BOTTOMLEFT", 0, 3)
	S:HandleSliderFrame(journal.summonPanel.resize.slider)
	journal.summonPanel.resize.slider:SetPoint("BOTTOMLEFT", 0, 3)

	journal.filtersPanel:StripTextures()
	S:HandleButton(journal.filtersToggle)
	journal.filtersToggle:SetSize(22, 22)
	journal.filtersToggle:SetPoint("TOPLEFT", 4, -4)
	S:HandleButton(journal.gridToggleButton)
	journal.gridToggleButton:SetSize(22, 22)
	journal.gridToggleButton:SetPoint("LEFT", journal.filtersToggle, "RIGHT", 1, 0)
	S:HandleEditBox(journal.searchBox)
	journal.searchBox:SetPoint("TOPLEFT", 53, -5)
	ddStreachButton(journal.filtersButton)
	journal.filtersButton:SetPoint("LEFT", journal.searchBox, "RIGHT", 2, 0)
	journal.filtersBar:StripTextures()
	journal.filtersBar:SetTemplate("Transparent")

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
	bgFrame.leftInset:StripTextures()
	bgFrame.leftInset:SetPoint("BOTTOMLEFT", 0, 27)
	S:HandleTrimScrollBar(journal.leftInset.scrollBar)
	hooksecurefunc(journal.scrollBox, "Update", scrollMountButtons)
	scrollMountButtons(journal.scrollBox)

	journal.tags.mountOptionsMenu:ddSetDisplayMode("ElvUI")
	S:HandleSliderFrame(journal.percentSlider.slider)
	journal.percentSlider.slider:SetPoint("BOTTOMLEFT", 0, 3)

	S:HandleSliderFrame(journal.xInitialAcceleration.slider)
	journal.xInitialAcceleration.slider:SetPoint("BOTTOMLEFT", 0, 3)
	S:HandleSliderFrame(journal.xAcceleration.slider)
	journal.xAcceleration.slider:SetPoint("BOTTOMLEFT", 0, 3)
	S:HandleSliderFrame(journal.xMinSpeed.slider)
	journal.xMinSpeed.slider:SetPoint("BOTTOMLEFT", 0, 3)

	S:HandleSliderFrame(journal.yInitialAcceleration.slider)
	journal.yInitialAcceleration.slider:SetPoint("BOTTOMLEFT", 0, 3)
	S:HandleSliderFrame(journal.yAcceleration.slider)
	journal.yAcceleration.slider:SetPoint("BOTTOMLEFT", 0, 3)
	S:HandleSliderFrame(journal.yMinSpeed.slider)
	journal.yMinSpeed.slider:SetPoint("BOTTOMLEFT", 0, 3)

	local mountInfo = journal.mountDisplay.info
	mountInfo.linkLang:ddSetDisplayMode("ElvUI")
	mountInfo.linkLang.arrow:SetTexture(E.Media.Textures.ArrowUp)
	mountInfo.linkLang.arrow:SetRotation(S.ArrowRotation.right)
	mountInfo.linkLang.arrow:SetVertexColor(1, 1, 1)
	S:HandleIcon(mountInfo.icon, true)
	if mountInfo.mountDescriptionToggle then  -- retail
		S:HandleButton(mountInfo.mountDescriptionToggle)
		mountInfo.mountDescriptionToggle:SetWidth(18)
		mountInfo.mountDescriptionToggle:SetPoint("LEFT", mountInfo.icon, "RIGHT", 2, 0)
	end
	mountInfo.petSelectionBtn.bg:SetTexCoord(unpack(E.TexCoords))
	mountInfo.petSelectionBtn.border:SetTexture()
	mountInfo.petSelectionBtn.highlight:SetTexture()
	S:HandleButton(mountInfo.petSelectionBtn)

	local infoFrame = mountInfo.petSelectionBtn.infoFrame
	infoFrame.icon:SetTexCoord(unpack(E.TexCoords))
	infoFrame.icon:CreateBackdrop(nil, nil, nil, true)
	if infoFrame.qualityBorder then -- retail
		infoFrame.qualityBorder:SetTexture()
		hooksecurefunc(infoFrame.qualityBorder, "SetVertexColor", function(self, ...)
			local parent = self:GetParent()
			if parent.hovered then return end
			parent.icon.backdrop:SetBackdropBorderColor(...)
		end)
		hooksecurefunc(infoFrame.qualityBorder, "Hide", function(self)
			local parent = self:GetParent()
			if parent.hovered then return end
			local r, g, b = unpack(E.media.bordercolor)
			parent.icon.backdrop:SetBackdropBorderColor(r, g, b)
		end)
	end

	mountInfo.petSelectionBtn:HookScript("OnEnter", function(self)
		local infoFrame = self.infoFrame
		infoFrame.icon.backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		infoFrame.hovered = true
	end)
	mountInfo.petSelectionBtn:HookScript("OnLeave", function(self)
		local infoFrame = self.infoFrame
		if infoFrame.qualityBorder and infoFrame.qualityBorder:IsShown() then -- retail
			infoFrame.icon.backdrop:SetBackdropBorderColor(infoFrame.qualityBorder:GetVertexColor())
		else
			infoFrame.icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		infoFrame.hovered = nil
	end)

	local petSelectionClick = mountInfo.petSelectionBtn:GetScript("OnClick")
	mountInfo.petSelectionBtn:HookScript("OnClick", function(self)
		petListSkin(journal, self.petSelectionList)
		self:SetScript("OnClick", petSelectionClick)
	end)

	journal.mountDisplay.info.modelSceneSettingsButton:ddSetDisplayMode("ElvUI")
	if journal.multipleMountBtn then -- retail
		journal.multipleMountBtn:ddSetDisplayMode("ElvUI")
	end
	ddButton(journal.modelScene.animationsCombobox)
	journal.modelScene.animationsCombobox:SetPoint("LEFT", journal.modelScene.modelControl, "RIGHT", 10, -2)

	journal.worldMap:StripTextures()
	ddButton(journal.worldMap.navigation)
	journal.worldMap.navigation:SetPoint("TOPLEFT", 1, -5)

	local mapSettings = journal.mapSettings
	mapSettings:StripTextures()
	mapSettings:SetTemplate("Transparent")
	mapSettings.mapControl:StripTextures()
	ddStreachButton(mapSettings.dnr)
	mapSettings.dnr:SetPoint("TOPLEFT", mapSettings.mapControl, "TOPLEFT", 0, -3)
	mapSettings.dnr:SetPoint("RIGHT", mapSettings.CurrentMap, "LEFT", -1, 0)
	S:HandleButton(mapSettings.CurrentMap)
	mapSettings.CurrentMap:SetPoint("RIGHT", mapSettings.existingListsToggle, "LEFT", -1, 0)
	mapSettings.CurrentMap:SetWidth(253)
	S:HandleButton(mapSettings.existingListsToggle)
	mapSettings.existingListsToggle:SetPoint("TOPRIGHT", mapSettings.mapControl, 0, -3)
	S:HandleCheckBox(mapSettings.Flags)
	S:HandleCheckBox(mapSettings.Ground)
	S:HandleCheckBox(mapSettings.WaterWalk)
	if mapSettings.HerbGathering then -- retail
		S:HandleCheckBox(mapSettings.HerbGathering)
	end
	ddStreachButton(mapSettings.listFromMap)

	mapSettings.existingLists:StripTextures()
	mapSettings.existingLists:CreateBackdrop("Transparent")
	mapSettings.existingLists:SetPoint("TOPLEFT", bgFrame, "TOPRIGHT", 2, -1)
	mapSettings.existingLists:SetPoint("BOTTOMLEFT", bgFrame, "BOTTOMRIGHT", 2, 1)
	S:HandleEditBox(mapSettings.existingLists.searchBox)
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
	S:HandleTab(journal.bgFrame.mapTab)
	journal.bgFrame.mapTab:Point("RIGHT", journal.bgFrame.settingsTab, "LEFT", 5, 0)
	S:HandleTab(journal.bgFrame.modelTab)
	journal.bgFrame.modelTab:Point("RIGHT", journal.bgFrame.mapTab, "LEFT", 5, 0)
end)


-- SUMMON PANEL
MountsJournal:on("CREATE_BUTTONS", function()
	local summonPanel = MountsJournalFrame.summonPanel

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
MountsJournalConfig:HookScript("OnShow", function(self)
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

	S:HandleCheckBox(self.copyMountTarget)
	if self.coloredMountNames then -- retail
		S:HandleCheckBox(self.coloredMountNames)
	end
	S:HandleCheckBox(self.arrowButtons)
	S:HandleCheckBox(self.openLinks)
	S:HandleCheckBox(self.showWowheadLink)
	if self.resetHelp then -- retail
		S:HandleButton(self.resetHelp)
	end
	S:HandleButton(self.applyBtn)
	S:HandleButton(self.cancelBtn)
end)


-- IconData
MountsJournalConfig.iconData:HookScript("OnShow", function(self)
	self:StripTextures()
	self:SetTemplate("Transparent")

	S:HandleItemButton(self.selectedIconBtn)
	self.selectedIconBtn.icon:SetDrawLayer("OVERLAY")
	S:HandleEditBox(self.searchBox)
	self.searchBox:SetPoint("TOPLEFT", 18, -27)
	ddStreachButton(self.filtersButton)
	self.filtersButton:SetPoint("LEFT", self.searchBox, "RIGHT", 2, 0)
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
end)


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
	track:SetPoint("TOPLEFT", 4, -21)
	track:SetPoint("BOTTOMRIGHT", -3, 21)

	local thumb = track.Thumb
	thumb.Middle:Hide()
	thumb.Begin:Hide()
	thumb.End:Hide()

	thumb:SetTemplate(nil, true, true)
	thumb:SetBackdropColor(unpack(E.media.rgbvaluecolor))

	reskinScrollBarArrow(scrollBar.Back, "up")
	reskinScrollBarArrow(scrollBar.Forward, "down")
end


MountsJournalConfigClasses:HookScript("OnShow", function(self)
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
	self.rightPanel:SetPoint("BOTTOMLEFT", self.leftPanel, "BOTTOMRIGHT", 2, 0)
	S:HandleTrimScrollBar(self.rightPanelScroll.ScrollBar)

	local function reskinEditBox(editFrame)
		editFrame:SetWidth(393)
		editFrame.background:SetTemplate("Transparent")
		S:HandleCheckBox(editFrame.enable)
		editFrame.enable:SetPoint("BOTTOMLEFT", editFrame.background, "TOPLEFT", 10, -3)
		S:HandleButton(editFrame.defaultBtn)
		S:HandleButton(editFrame.cancelBtn)
		editFrame.cancelBtn:SetPoint("TOPRIGHT", editFrame.background, "BOTTOMRIGHT", 0, -1)
		S:HandleButton(editFrame.saveBtn)
		editFrame.saveBtn:SetPoint("RIGHT", editFrame.cancelBtn, "LEFT", -1, 0)
		editFrame.limitText:SetPoint("BOTTOMLEFT", editFrame.background, 10, -14)
		reskinEditScrollBar(editFrame.scrollBar)
	end

	reskinEditBox(self.moveFallMF)
	reskinEditBox(self.combatMF)
end)


hooksecurefunc(MountsJournalConfigClasses, "showClassSettings", function(self)
	if self.sliderPool then -- retail
		for option in self.sliderPool:EnumerateActive() do
			if not option.isSkinned then
				S:HandleSliderFrame(option.slider)
				option.slider:SetPoint("BOTTOMLEFT", 0, 3)
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
end)


-- RULES
MountsJournalConfigRules:HookScript("OnShow", function(self)
	ddStreachButton(self.ruleSets)
	S:HandleButton(self.snippetToggle)
	ddButton(self.summons)
	S:HandleButton(self.addRuleBtn)
	S:HandleEditBox(self.searchBox)
	S:HandleButton(self.resetRulesBtn)
	S:HandleCheckBox(self.altMode)
	S:HandleTrimScrollBar(self.scrollBar)

	self.ruleEditor:HookScript("OnShow", function(self)
		self.menu:ddSetDisplayMode("ElvUI")

		self.panel:StripTextures()
		self.panel:SetTemplate("Transparent")

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
				btn.arrow:SetPoint("RIGHT", -4, 0)
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
					edit.border:Hide()
					edit:ClearBackdrop()
					edit:CreateBackdrop()
					edit.backdrop:Point("TOPLEFT", 0, -5)
					edit.backdrop:Point("BOTTOMRIGHT", 0, 5)
				end
			end
		end

		hooksecurefunc(self, "setCondValueOption", onAcqure)
		hooksecurefunc(self, "setActionValueOption", onAcqure)
	end)
end)


-- SNIPPETS
MountsJournalSnippets:HookScript("OnShow", function(self)
	self:SetPoint("TOPLEFT", MountsJournalFrame.bgFrame, "TOPRIGHT", 1, 0)
	self:SetPoint("BOTTOMLEFT", MountsJournalFrame.bgFrame, "BOTTOMRIGHT", 1, 0)
	self:StripTextures()
	self:SetTemplate("Transparent")
	if self.TitleContainer.TitleBg then -- classic
		self.TitleContainer.TitleBg:Hide()
	end

	S:HandleButton(self.addSnipBtn)
	self.addSnipBtn:SetPoint("RIGHT", -4, 0)

	S:HandleEditBox(self.searchBox)
	self.searchBox:SetPoint("LEFT", 10, 0)
	self.searchBox:SetPoint("RIGHT", -4, 0)

	self.bg:StripTextures()
	S:HandleTrimScrollBar(self.scrollBar)
end)


MountsJournalCodeEdit:HookScript("OnShow", function(self)
	self:StripTextures()
	self:SetTemplate("Transparent")
	S:HandleEditBox(self.nameEdit)
	S:HandleEditBox(self.line)
	ddStreachButton(self.settings)
	ddStreachButton(self.examples)
	S:HandleButton(self.nextBtn)
	S:HandleButton(self.backBtn)
	self.backBtn:SetPoint("RIGHT", self.nextBtn, "LEFT", -1, 0)
	S:HandleButton(self.cancelBtn)
	S:HandleButton(self.completeBtn)

	self.codeBtn:SetTemplate("Transparent")
	reskinEditScrollBar(self.scrollBar)
end)