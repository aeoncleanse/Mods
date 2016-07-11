DecalFunctions = {
    RULEUCC_Nuke = function()
        local innerSize = nil
        local outerSize = nil
        local invalid = false
        local validAttackers = GetValidAttackingUnits()
        
        if validAttackers and table.getn(validAttackers) > 0 then
            for index, unit in validAttackers do
                local bp = unit:GetBlueprint()
                for i, w in bp.Weapon do
                    if w.CountedProjectile == true and w.NukeWeapon == true then
                        -- Needs to be re-scaled to correspond to ingame radius values
                        innerSize = w.NukeInnerRingRadius * 2
                        outerSize = w.NukeOuterRingRadius * 2
                    end
                end
            end
        else
            invalid = true      
        end
        -- if no size specd, use default of 60
        
        if not innerSize or not outerSize then
            WARN('Nuke decal called for non-nuclear weapon')
        end
        return invalid, "/mods/balancepreview/textures/ui/common/game/AreaTargetDecal/nuke_icon_outer.dds", Vector(outerSize, 1, outerSize), "/mods/balancepreview/textures/ui/common/game/AreaTargetDecal/nuke_icon_inner.dds", Vector(innerSize, 1, innerSize)
    end,
    RULEUCC_Attack = AttackDecalFunc,
}

local oldWorldView = WorldView
WorldView = Class(oldWorldView) {

    HandleEvent = function(self, event)
        if self.EventRedirect then
            return self.EventRedirect(self,event)
        end
        if event.Type == 'MouseEnter' or event.Type == 'MouseMotion' then
            self.bMouseIn = true
            if self.Cursor then
                if (self.LastCursor == nil) or (self.Cursor[1] != self.LastCursor[1]) then
                    self.LastCursor = self.Cursor
                    GetCursor():SetTexture(unpack(self.Cursor))
                end
            else
                GetCursor():Reset()
            end
        elseif event.Type == 'MouseExit' then
            self.bMouseIn = false
            GetCursor():Reset()
            self.LastCursor = nil
            if self.TargetDecal then
                self.TargetDecal:Destroy()
                if self.TargetDecal2 then
                    self.TargetDecal2:Destroy()
                    self.TargetDecal2 = false
                end
                self.TargetDecal = false
                self.DecalTexture = false
                self.DecalScale = false
            end
        end
        return false
    end,

    OnUpdateCursor = function(self)
        local oldCursor = self.Cursor
        local newDecalTexture = false
        local newScale = Vector(0,0,0)
        local mode = import('/lua/ui/game/commandmode.lua').GetCommandMode()
        local outer = false
        local outerScale = Vector(0,0,0)
        
        self.NeedTargetDecal = false
        self.NeedOuterDecal = false
        if mode[1] == "order" then
            local showInvalidTargetCursor = false
            if self:ShowConvertToPatrolCursor() then
                self.Cursor = {UIUtil.GetCursor("MOVE2PATROLCOMMAND")}
            else
                if DecalFunctions[mode[2].name] then
                    if mode[2].name == "RULEUCC_Nuke" then
                        showInvalidTargetCursor, newDecalTexture, newScale, outer, outerScale = DecalFunctions[mode[2].name]()
                        self.NeedOuterDecal = not showInvalidTargetCursor
                    else
                        showInvalidTargetCursor, newDecalTexture, newScale = DecalFunctions[mode[2].name]()
                    end
                    self.NeedTargetDecal = not showInvalidTargetCursor
                end
                if showInvalidTargetCursor then
                    self.Cursor = {UIUtil.GetCursor('RULEUCC_Invalid')}
                elseif mode[2].cursor then
                    self.Cursor = {UIUtil.GetCursor(mode[2].cursor)}
                else
                    self.Cursor = {UIUtil.GetCursor(mode[2].name)}
                end
            end
        elseif mode[1] == "build" then
            self.Cursor = {UIUtil.GetCursor('BUILD')}
        elseif mode[1] == "ping" then
            self.Cursor = {UIUtil.GetCursor(mode[2].cursor)}
        elseif self:HasHighlightCommand() then
            if self:ShowConvertToPatrolCursor() then
                self.Cursor = {UIUtil.GetCursor("MOVE2PATROLCOMMAND")}
            else
                self.Cursor = {UIUtil.GetCursor('HOVERCOMMAND')}
            end
        else
            local order = self:GetRightMouseButtonOrder()
            if order then
                -- Don't show the move cursor as a right mouse button hightlight state
                if order == "RULEUCC_Move" then
                    self.Cursor = nil
                else
                    self.Cursor = {UIUtil.GetCursor(order)}
                end
            else
                self.Cursor = nil
            end

            -- Catches if there is no order, or if there is no cursor assigned to the order
            if not self.Cursor then
                GetCursor():Reset()
            end
        end
        if self.NeedTargetDecal then
            if not self.TargetDecal then
                self.TargetDecal = UserDecal {}
                if self.NeedOuterDecal then
                    self.TargetDecal2 = UserDecal {}
                end
            end
            if newDecalTexture and self.DecalTexture != newDecalTexture then
                self.TargetDecal:SetTexture(newDecalTexture)
                self.DecalTexture = newDecalTexture
                if self.TargetDecal2 then
                    self.TargetDecal2:SetTexture(outer)
                end
            end
            if newScale and self.DecalScale != newScale then
                self.TargetDecal:SetScale(newScale)
                self.DecalScale = newScale
                if self.TargetDecal2 then
                    self.TargetDecal2:SetScale(outerScale)
                end
            end
            self.TargetDecal:SetPosition(GetMouseWorldPos())
            if self.TargetDecal2 then
                self.TargetDecal2:SetPosition(GetMouseWorldPos())
            end
        elseif self.TargetDecal then
            self.TargetDecal:Destroy()
            self.TargetDecal = false
            if self.TargetDecal2 then
                self.TargetDecal2:Destroy()
                self.TargetDecal2 = false
            end
            self.DecalTexture = false
            self.DecalScale = false
        end
        if (self.Cursor == nil) or (oldCursor == nil) or (self.Cursor[1] != oldCursor[1]) then
            self:ApplyCursor()
        end
    end,
}
