library Mirror needs MushroomMoving, Water, TriggerSleepAction, UnitMotion

    globals
        private boolean array inMirrorState
        private effect array shadowEffect
        private boolean isRunShadowEngine = false
        private boolean registed = false
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

    private function GetXY takes integer i, integer world, integer level returns location
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
        else
            return null
        endif
        return Location(nx, ny)
    endfunction

    public function RunShadowEngine takes integer world, integer level returns nothing
        local integer i = 1
        local location xy = null

        if registed == false then
            return
        endif

        //! runtextmacro for("set i = 1", "i <= PLAYER_MAXINUM")
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and shadowEffect[i] != null then
                set xy = GetXY(i, world, level)
                call EXSetEffectXY(shadowEffect[i], GetLocationX(xy), GetLocationY(xy))
                call RemoveLocation(xy)
            endif
        //! runtextmacro for_end("set i = i + 1")

        set xy = null
    endfunction

    private function RemoveShadow takes integer i returns nothing
        // 삭제해도 일정시간 남아있기 때문에 좌표를 멀리 이동시킨다.
        call EXSetEffectXY(shadowEffect[i], 13000, 8000)
        call DestroyEffect(shadowEffect[i])
    endfunction

    private function CreateShadow takes integer i returns nothing
        set shadowEffect[i] = AddSpecialEffect( "war3mapImported\\Mushroom.mdl", GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i]) )
        call EXEffectMatRotateZ(shadowEffect[i], 270)
        call SetSpecialEffectAlpha(shadowEffect[i], 90)
    endfunction

    private struct ShadowMotion extends UnitMotion_IMotionAble

        public method LeftJumpMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif
            
            call KeyEffectAnimation(shadow, LEFT_JUMP_ANIMATION)
        endmethod

        public method RightJumpMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, RIGHT_JUMP_ANIMATION)
        endmethod

        public method LeftStandMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, LEFT_STAND_ANIMATION)
        endmethod

        public method RightStandMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, RIGHT_STAND_ANIMATION)
        endmethod

        public method LeftWalkMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, LEFT_WALK_ANIMATION)
        endmethod

        public method RightWalkMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, RIGHT_WALK_ANIMATION)
        endmethod

        public method LeftDownMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, LEFT_DOWN_ANIMATION)
        endmethod

        public method RightDownMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, RIGHT_DOWN_ANIMATION)
        endmethod

        private static method onInit takes nothing returns nothing
            local thistype this = thistype.allocate()
            call UnitMotion_AddMotion(this)
        endmethod
    endstruct

    public function Main takes integer i, integer world, integer level returns boolean
        local location xy = GetXY(i, world, level)
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])

        if xy == null then
            return false
        endif
        
        if Teleport(i, x, y, GetLocationX(xy), GetLocationY(xy)) then
            set inMirrorState[i] = not(inMirrorState[i])
            call ChangeBackGround(i, inMirrorState[i])
        endif

        call RemoveLocation(xy)
        set xy = null
        return true
    endfunction

    public function Reset takes integer world, integer level returns nothing
        local integer i = 1

        if world != 17 then
            return
        endif

        if registed == false then
            call UnitMotion_AddMotion(ShadowMotion.create())
            set registed = true
        endif


        //! runtextmacro for("set i = 1", "i <= PLAYER_MAXINUM")
            set inMirrorState[i] = false
            call RemoveShadow(i)
            
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                call ChangeBackGround(i, false)
                call CreateShadow(i)
            endif
        //! runtextmacro for_end("set i = i + 1")
    endfunction
endlibrary  