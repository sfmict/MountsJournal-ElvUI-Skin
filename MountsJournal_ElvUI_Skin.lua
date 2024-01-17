local E = ElvUI[1]
if E.private.skins.blizzard.misc ~= true then return end
local S = E:GetModule("Skins")


MJTooltipModel:StripTextures()
MJTooltipModel:CreateBackdrop("Transparent")
MJTooltipModel:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, -2)


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
	infoFrame.qualityBorder:SetTexture()

	button:HookScript("OnEnter", btnOnEnter)
	button:HookScript("OnLeave", btnOnLeave)
	hooksecurefunc(button.selectedTexture, "SetShown", selectedTextureSetShown)
	hooksecurefunc(infoFrame.qualityBorder, "SetVertexColor", setQuality)
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
	petList.closeButton:SetPoint("TOPRIGHT", 6, 7)

	petList.filtersPanel:StripTextures()
	petList.filtersPanel:SetHeight(26)

	for i, btn in ipairs(petList.filtersPanel.buttons) do
		S:HandleButton(btn)
		local checkedTexture = btn:GetCheckedTexture()
		checkedTexture:SetTexture(E.Media.Textures.White8x8)
		checkedTexture:SetVertexColor(0.9, 0.8, 0.1, 0.1)
		btn.icon:SetTexCoord(unpack(E.TexCoords))
	end

	petList.controlButtons:StripTextures()
	petButtonSkin(petList.randomFavoritePet, 0)
	petButtonSkin(petList.randomPet, 0)
	petButtonSkin(petList.noPet, 0)

	petList.petListFrame:StripTextures()
	petList.petListFrame:SetPoint("TOPLEFT", petList.filtersPanel, "BOTTOMLEFT", 0, -1)
	petList.petListFrame:SetPoint("BOTTOMRIGHT", petList.controlButtons, "TOPRIGHT", 0, 1)

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
	else
		button.icon.backdrop:SetBackdropBorderColor(button.qualityBorder:GetVertexColor())
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
	else
		button.icon.backdrop:SetBackdropBorderColor(button.qualityBorder:GetVertexColor())
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
					g3btn.qualityBorder:SetTexture()

					g3btn.fly:SetPoint("TOPLEFT", g3btn, "TOPRIGHT", 2, 0)
					g3btn.ground:SetPoint("TOPLEFT", g3btn, "TOPRIGHT", 2, -14)
					g3btn.swimming:SetPoint("TOPLEFT", g3btn, "TOPRIGHT", 2, -28)

					g3btn:HookScript("OnEnter", gBtnOnEnter)
					g3btn:HookScript("OnLeave", gBtnOnLeave)
					hooksecurefunc(g3btn.qualityBorder, "SetVertexColor", gSetQuality)
					hooksecurefunc(g3btn.selectedTexture, "SetShown", gSelectedTextureSetShown)
					gSelectedTextureSetShown(g3btn.selectedTexture, g3btn.selectedTexture:IsShown())
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
				btn.dragButton.qualityBorder:SetTexture()
				btn.dragButton.icon:Size(40)
				btn.dragButton.icon:SetTexCoord(unpack(E.TexCoords))
				btn.dragButton.icon:CreateBackdrop(nil, nil, nil, true)
				btn.dragButton.activeTexture:SetTexture(E.Media.Textures.White8x8)
				btn.dragButton.activeTexture:SetVertexColor(0.9, 0.8, 0.1, 0.3)

				btn:HookScript("OnEnter", dBtnOnEnter)
				btn:HookScript("OnLeave", dBtnOnLeave)
				hooksecurefunc(btn.dragButton.qualityBorder, "SetVertexColor", dSetQuality)
				dSetQuality(btn.dragButton.qualityBorder, btn.dragButton.qualityBorder:GetVertexColor())
				hooksecurefunc(btn.selectedTexture, "SetShown", dSelectedTextureSetShown)
				dSelectedTextureSetShown(btn.selectedTexture, btn.selectedTexture:IsShown())
			end

			btn.isSkinned = true
		end
	end
end


-- JOURNAL
hooksecurefunc(MountsJournalFrame, "init", function(journal)
	local function ddStreachButton(btn)
		btn.Arrow:SetTexture(E.Media.Textures.ArrowUp)
		btn.Arrow:SetRotation(S.ArrowRotation.right)
		btn.Arrow:SetVertexColor(1, 1, 1)
		S:HandleButton(btn)
	end

	local function ddButton(btn)
		btn:StripTextures()
		btn:CreateBackdrop()
		btn:SetFrameLevel(btn:GetFrameLevel() + 2)
		btn.backdrop:Point("TOPLEFT", 3, 1)
		btn.backdrop:Point("BOTTOMRIGHT", 1, 2)
		btn.Button.SetPoint = E.noop
		S:HandleNextPrevButton(btn.Button, "down")
	end

	local bgFrame = journal.bgFrame
	S:HandlePortraitFrame(bgFrame)
	S:HandleCloseButton(bgFrame.closeButton)
	bgFrame.Center:Hide()

	journal.navBar:StripTextures()
	journal.navBar.overlay:StripTextures()
	journal.navBar.homeButton:StripTextures()
	S:HandleButton(journal.navBar.homeButton)
	journal.navBar.homeButton:SetHeight(28)
	journal.navBar.homeButton.xoffset = 1
	journal.navBar.dropDown:ddSetDisplayMode("ElvUI")

	journal.navBarBtn:StripTextures()
	S:HandleButton(journal.navBarBtn)
	journal.navBarBtn:SetSize(42, 28)
	journal.navBarBtn:SetPoint("TOPRIGHT", -6, -62)
	journal.navBarBtn.texture:SetSize(40, 26)
	journal.navBarBtn.texture:SetTexture("Interface/QuestFrame/UI-QuestMap_Button")
	journal.navBarBtn.texture:SetTexCoord(.26, .7125, .075, .4125)
	journal.navBarBtn.texture.SetTexCoord = E.noop
	journal.navBarBtn.texture:ClearAllPoints()
	journal.navBarBtn.texture:SetPoint("CENTER")
	local checkedTexture = journal.navBarBtn:GetCheckedTexture()
	checkedTexture:SetTexture(E.Media.Textures.White8x8)
	checkedTexture:SetVertexColor(0.9, 0.8, 0.1, 0.2)
	checkedTexture:SetPoint("TOPLEFT", 1, -1)
	checkedTexture:SetPoint("BOTTOMRIGHT", -1, 1)

	journal.mountCount:StripTextures()
	bgFrame.rightInset:StripTextures()
	bgFrame.rightInset:SetPoint("TOPRIGHT", journal.navBarBtn, "BOTTOMRIGHT", 1, 0)
	bgFrame.rightInset:SetPoint("BOTTOM", 0, 27)
	journal.mountDisplay:StripTextures()
	journal.mountDisplay.shadowOverlay:StripTextures()

	local scale = bgFrame.slotButton:GetScale()
	local width, height = bgFrame.slotButton:GetSize()
	bgFrame.slotButton:SetScale(1)
	bgFrame.slotButton:SetSize(width * scale, height * scale)
	bgFrame.slotButton:StripTextures()
	S:HandleButton(bgFrame.slotButton)
	S:HandleIcon(bgFrame.slotButton.ItemIcon)
	width, height = bgFrame.slotButton.ItemIcon:GetSize()
	bgFrame.slotButton.ItemIcon:SetSize(width * scale, height * scale)

	S:HandleItemButton(bgFrame.summon1)
	S:HandleItemButton(bgFrame.summon2)
	S:HandleItemButton(bgFrame.summon3)

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
	journal.filtersButton:ddSetDisplayMode("ElvUI")
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
		S:HandleTab(tab.selected)
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
	S:HandleTrimScrollBar(journal.bgFrame.scrollBar)
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
	S:HandleIcon(mountInfo.icon, true)
	S:HandleButton(mountInfo.mountDescriptionToggle)
	mountInfo.mountDescriptionToggle:SetWidth(18)
	mountInfo.mountDescriptionToggle:SetPoint("LEFT", mountInfo.icon, "RIGHT", 2, 0)
	mountInfo.petSelectionBtn.bg:SetTexCoord(unpack(E.TexCoords))
	mountInfo.petSelectionBtn.border:SetTexture()
	mountInfo.petSelectionBtn.highlight:SetTexture()
	S:HandleButton(mountInfo.petSelectionBtn)

	local infoFrame = mountInfo.petSelectionBtn.infoFrame
	infoFrame.icon:SetTexCoord(unpack(E.TexCoords))
	infoFrame.icon:CreateBackdrop(nil, nil, nil, true)
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

	mountInfo.petSelectionBtn:HookScript("OnEnter", function(self)
		local infoFrame = self.infoFrame
		infoFrame.icon.backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		infoFrame.hovered = true
	end)
	mountInfo.petSelectionBtn:HookScript("OnLeave", function(self)
		local infoFrame = self.infoFrame
		if infoFrame.qualityBorder:IsShown() then
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
	journal.multipleMountBtn:ddSetDisplayMode("ElvUI")
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
	mapSettings.dnr:ddSetDisplayMode("ElvUI")
	S:HandleButton(mapSettings.CurrentMap)
	mapSettings.CurrentMap:SetPoint("RIGHT", mapSettings.existingListsToggle, "LEFT", -1, 0)
	mapSettings.CurrentMap:SetWidth(253)
	S:HandleButton(mapSettings.existingListsToggle)
	mapSettings.existingListsToggle:SetPoint("TOPRIGHT", mapSettings.mapControl, 0, -3)
	S:HandleCheckBox(mapSettings.Flags)
	S:HandleCheckBox(mapSettings.Fly)
	S:HandleCheckBox(mapSettings.Ground)
	S:HandleCheckBox(mapSettings.WaterWalk)
	S:HandleCheckBox(mapSettings.HerbGathering)
	ddStreachButton(mapSettings.listFromMap)
	mapSettings.listFromMap:ddSetDisplayMode("ElvUI")

	mapSettings.existingLists:StripTextures()
	mapSettings.existingLists:CreateBackdrop("Transparent")
	mapSettings.existingLists:SetPoint("TOPLEFT", bgFrame, "TOPRIGHT", 2, -1)
	mapSettings.existingLists:SetPoint("BOTTOMLEFT", bgFrame, "BOTTOMRIGHT", 2, 1)
	S:HandleEditBox(mapSettings.existingLists.searchBox)
	S:HandleTrimScrollBar(mapSettings.existingLists.scrollFrame.ScrollBar)

	hooksecurefunc(mapSettings.existingLists, "collapse", function(self, btn)
		local checked = btn:GetChecked()
		btn.toggle.plusMinus:SetTexture(checked and E.Media.Textures.PlusButton or E.Media.Textures.MinusButton)
	end)

	S:HandleButton(journal.summonButton)
	ddStreachButton(bgFrame.profilesMenu)
	bgFrame.profilesMenu:ddSetDisplayMode("ElvUI")
	S:HandleButton(bgFrame.btnConfig)

	bgFrame.calendarFrame:StripTextures()
	S:HandleNextPrevButton(bgFrame.calendarFrame.prevMonthButton, "left", nil, true)
	S:HandleNextPrevButton(bgFrame.calendarFrame.nextMonthButton, "right", nil, true)
end)


-- OPTIONS
MountsJournalConfig:HookScript("OnShow", function(self)
	self.leftPanel:StripTextures()
	self.leftPanel:SetTemplate("Transparent")

	S:HandleCheckBox(self.waterJump)
	S:HandleButton(self.createMacroBtn)
	self.bindMount.selectedHighlight:SetTexture(E.media.normTex)
	self.bindMount.selectedHighlight:Point("TOPLEFT", 1, -1)
	self.bindMount.selectedHighlight:Point("BOTTOMRIGHT", -1, 1)
	self.bindMount.selectedHighlight:SetColorTexture(1, 1, 1, .25)
	S:HandleButton(self.bindMount)
	S:HandleButton(self.createSecondMacroBtn)
	self.bindSecondMount.selectedHighlight:SetTexture(E.media.normTex)
	self.bindSecondMount.selectedHighlight:Point("TOPLEFT", 1, -1)
	self.bindSecondMount.selectedHighlight:Point("BOTTOMRIGHT", -1, 1)
	self.bindSecondMount.selectedHighlight:SetColorTexture(1, 1, 1, .25)
	S:HandleButton(self.bindSecondMount)
	S:HandleButton(self.createThirdMacroBtn)
	self.bindThirdMount.selectedHighlight:SetTexture(E.media.normTex)
	self.bindThirdMount.selectedHighlight:Point("TOPLEFT", 1, -1)
	self.bindThirdMount.selectedHighlight:Point("BOTTOMRIGHT", -1, 1)
	self.bindThirdMount.selectedHighlight:SetColorTexture(1, 1, 1, .25)
	S:HandleButton(self.bindThirdMount)

	self.rightPanel:StripTextures()
	self.rightPanel:SetTemplate("Transparent")
	S:HandleTrimScrollBar(self.rightPanelScroll.ScrollBar)

	S:HandleCheckBox(self.useHerbMounts)
	S:HandleCheckBox(self.herbMountsOnZones)
	S:HandleCheckBox(self.useRepairMounts)
	S:HandleCheckBox(self.repairFlyable)
	S:HandleCheckBox(self.useMagicBroom)
	if self.useUnderlightAngler then
		S:HandleCheckBox(self.useUnderlightAngler)
		S:HandleCheckBox(self.autoUseUnderlightAngler)
	end
	S:HandleCheckBox(self.summonPetEvery)
	S:HandleCheckBox(self.summonPetOnlyFavorites)
	S:HandleCheckBox(self.noPetInRaid)
	S:HandleCheckBox(self.noPetInGroup)
	S:HandleCheckBox(self.copyMountTarget)
	S:HandleCheckBox(self.coloredMountNames)
	S:HandleCheckBox(self.arrowButtons)
	S:HandleCheckBox(self.openLinks)
	S:HandleCheckBox(self.showWowheadLink)
	S:HandleButton(self.resetHelp)
	S:HandleButton(self.applyBtn)
	S:HandleButton(self.cancelBtn)
end)


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

	local function reskinScrollBarArrow(frame, direction)
		S:HandleNextPrevButton(frame, direction)
		frame.Overlay:SetAlpha(0)
		frame.Texture:Hide()
	end

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

		editFrame.scrollBar.Background:Hide()
		editFrame.scrollBar:StripTextures()

		local track = editFrame.scrollBar.Track
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

		reskinScrollBarArrow(editFrame.scrollBar.Back, "up")
		reskinScrollBarArrow(editFrame.scrollBar.Forward, "down")
	end

	reskinEditBox(self.moveFallMF)
	reskinEditBox(self.combatMF)
end)


hooksecurefunc(MountsJournalConfigClasses, "showClassSettings", function(self)
	for option in self.sliderPool:EnumerateActive() do
		if not option.isSkinned then
			S:HandleSliderFrame(option.slider)
			option.slider:SetPoint("BOTTOMLEFT", 0, 3)
			option.isSkinned = true
		end
	end

	for option in self.checkPool:EnumerateActive() do
		if not option.isSkinned then
			S:HandleCheckBox(option)
			option.isSkinned = true
		end
	end
end)