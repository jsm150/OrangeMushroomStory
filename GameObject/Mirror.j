library Mirror initializer Init needs MushroomMoving, Water

    globals
        private boolean array inMirrorState
        private effect array shadowEffect
        private boolean isRunShadowEngine
    endglobals

    private function BackGroundsCheck takes real x, real y returns boolean
        return GetTerrainType(x, y) == BACKGROUND_TILE and IsPointInRegion(Rect_NoEntry, x, y) == false
    endfunction

    private function BackGroundMove takes integer i, real offsetX, real offsetY returns nothing
        call SetUnitX(BackGroundUnits[i], GetUnitX(BackGroundUnits[i]) + offsetX)
        call SetUnitY(BackGroundUnits[i], GetUnitY(BackGroundUnits[i]) + offsetY)
    endfunction

    private function Teleport takes integer i, real x, real y, real nx, real ny returns boolean
        set Frame_MainPlayerY = 0
        call MushroomMoving_RectCondition(i, x, y, 40, "DownWidthOM")

        if BackGroundsCheck(nx - 39.9, ny) and BackGroundsCheck(nx + 39.9, ny) and BackGroundsCheck(nx, ny - 10) and BackGroundsCheck(nx, ny + 10) then
            call SetUnitPosition( OrangeMushroom[i], nx, ny )
            call BackGroundMove(i, nx - x, ny - y)

            if Frame_MainPlayerY != 0 and MushroomType(GetUnitTypeId(OrangeMushroom[Frame_MainPlayerY])) == false and Frame_MainPlayerY > PLAYER_MAXINUM then
                // call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", GetUnitX(OrangeMushroom[Frame_MainPlayerY]), GetUnitY(OrangeMushroom[Frame_MainPlayerY]) ))
                call Water_EffectTimer(Frame_MainPlayerY)
                if GravityChanger_State == false and GetTerrainType(nx, ny-100) == BACKGROUND_TILE then
                    call SetUnitPosition( OrangeMushroom[Frame_MainPlayerY], nx, ny-90 )
                    // call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl", nx-300, ny-90 ))
                elseif GravityChanger_State == true and GetTerrainType(nx, ny+100) == BACKGROUND_TILE then
                    call SetUnitPosition( OrangeMushroom[Frame_MainPlayerY], nx, ny+90 )
                    // call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl", nx-300, ny+90 ))
                endif
            endif
            
            // call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl", nx, ny ))
            return true
        else
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 빈 공간이 없어 이동할 수 없습니다!")
            return false
        endif
    endfunction

    public function ChangeBackGround takes integer i, boolean inMirror returns nothing
        if inMirror then
            // 거울속 배경
            call BackGroundChangeById(i, 'h00Z') 
        else
            // 기본 배경
            call BackGroundChangeById(i, 'h00Y')
        endif
    endfunction

    private function RunShadowEngine takes integer i returns nothing
        local integer i = 1
        set isRunShadowEngine = true

        loop
            exitwhen isRunShadowEngine == false
            //! runtextmacro for("set i = i + 1", "i <= PLAYER_MAXINUM")
                
            //! runtextmacro for_end("set i = i + 1")
            call TriggerSleepActionByTimer(0.02)
        endloop
    endfunction

    private function StopShadowEngine takes integer i returns nothing
        set isRunShadowEngine = false
    endfunction

    private function RemoveShadow takes integer i returns nothing
        
    endfunction

    private function CreateShadow takes integer i returns nothing
        
    endfunction

    public function Main takes integer i, integer world, integer level returns boolean
        local real nx = 0
        local real ny = 0
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])

        if world == 17 and level == 1 then
            if inMirrorState[i] then
                set nx = x - GetRectCenterX(gg_rct_MirrorOffsetSub001) + GetRectCenterX(gg_rct_MirrorOffsetMain001)
                set ny = y - GetRectCenterY(gg_rct_MirrorOffsetSub001) + GetRectCenterY(gg_rct_MirrorOffsetMain001)
            else
                set nx = x - GetRectCenterX(gg_rct_MirrorOffsetMain001) + GetRectCenterX(gg_rct_MirrorOffsetSub001)
                set ny = y - GetRectCenterY(gg_rct_MirrorOffsetMain001) + GetRectCenterY(gg_rct_MirrorOffsetSub001)
            endif
        elseif world == 17 and level == 2 then
            
        else
            return false
        endif
        
        if Teleport(i, x, y, nx, ny) then
            set inMirrorState[i] = not(inMirrorState[i])
            call ChangeBackGround(i, inMirrorState[i])
        endif

        return true
    endfunction

    

    public function Reset takes nothing returns nothing
        local integer i = 1
        //! runtextmacro for("set i = 1", "i <= PLAYER_MAXINUM")
            set inMirrorState[i] = false
            call ChangeBackGround(i, false)

            call RemoveShadow(i)
            call CreateShadow(i)
        //! runtextmacro for_end("set i = i + 1")
    endfunction
    
    private function Init takes nothing returns nothing
        call Reset()
    endfunction
endlibrary  