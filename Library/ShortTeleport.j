library ShortTeleport needs Water
    private function BackGroundsCheck takes real x, real y returns boolean
        return GetTerrainType(x, y) == BACKGROUND_TILE and IsPointInRegion(Rect_NoEntry, x, y) == false
    endfunction
    
    public function Main takes integer i, real x, real y returns nothing
        local real py = y
        set Frame_MainPlayerY = 0
        call MushroomMoving_RectCondition(i, x, y, 40, "DownWidthOM")
        if LeftArrow[i] == true then
            if BackGroundsCheck(x-350, y) and BackGroundsCheck(x-250, y) and BackGroundsCheck(x, y-10) and BackGroundsCheck(x, y+10) then
                call SetUnitPosition( OrangeMushroom[i], x-300, y )
                call BackGroundMove(i, x, py)
                if Frame_MainPlayerY != 0 and MushroomType(GetUnitTypeId(OrangeMushroom[Frame_MainPlayerY])) == false and Frame_MainPlayerY > PLAYER_MAXINUM then
                    call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", GetUnitX(OrangeMushroom[Frame_MainPlayerY]), GetUnitY(OrangeMushroom[Frame_MainPlayerY]) ))
                    call Water_EffectTimer(Frame_MainPlayerY)
                    if GravityChanger_State == false and GetTerrainType(x, y-100) == BACKGROUND_TILE and i < 8 then
                        call SetUnitPosition( OrangeMushroom[Frame_MainPlayerY], x-300, y-90 )
                        call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl", x-300, y-90 ))
                    elseif GravityChanger_State == true and GetTerrainType(x, y+100) == BACKGROUND_TILE and i < 8 then
                        call SetUnitPosition( OrangeMushroom[Frame_MainPlayerY], x-300, y+90 )
                        call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl", x-300, y+90 ))
                    endif
                endif
                call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl", x-300, y ))
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 빈 공간이 없어 이동할 수 없습니다!")
            endif
        elseif RightArrow[i] == true and LeftArrow[i] == false then
            if BackGroundsCheck(x+350, y) and BackGroundsCheck(x+250, y) and BackGroundsCheck(x, y-10) and BackGroundsCheck(x, y+10) then
                call SetUnitPosition( OrangeMushroom[i], x+300, y)
                call BackGroundMove(i, x, py)
                if Frame_MainPlayerY != 0 and MushroomType(GetUnitTypeId(OrangeMushroom[Frame_MainPlayerY])) == false and Frame_MainPlayerY > PLAYER_MAXINUM then
                    call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", GetUnitX(OrangeMushroom[Frame_MainPlayerY]), GetUnitY(OrangeMushroom[Frame_MainPlayerY]) ))
                    call Water_EffectTimer(Frame_MainPlayerY)
                    if GravityChanger_State == false and GetTerrainType(x, y-100) == BACKGROUND_TILE and i < 8  then
                        call SetUnitPosition( OrangeMushroom[Frame_MainPlayerY], x+300, y-90 )
                        call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl", x+300, y-90 ))
                    elseif GravityChanger_State == true and GetTerrainType(x, y+100) == BACKGROUND_TILE and i < 8  then
                        call SetUnitPosition( OrangeMushroom[Frame_MainPlayerY], x+300, y+90 )
                        call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl", x+300, y+90 ))
                    endif
                endif
                call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl", x+300, y ))
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 빈 공간이 없어 이동할 수 없습니다!")
            endif
        endif
        
    endfunction
endlibrary