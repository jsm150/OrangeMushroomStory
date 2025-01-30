library Mirror needs MushroomMoving, Water, UnitMotion

    globals
        private boolean array inMirrorState
        private effect array shadowEffect
        private boolean isRunShadowEngine = false
        private boolean registed = false
    endglobals

    private struct Rects
        private static hashtable table = InitHashtable()
        public rect Main
        public rect Sub

        public static method Find takes integer world, integer level returns thistype
            return LoadInteger(table, world, level)
        endmethod

        public static method Add takes integer world, integer level, rect mainRect, rect subRect returns nothing
            call SaveInteger(table, world, level, thistype.create(mainRect, subRect))
        endmethod

        public static method create takes rect mainRect, rect subRect returns thistype
            local thistype this = thistype.allocate()
            set this.Main = mainRect
            set this.Sub = subRect
            return this
        endmethod
    endstruct

    public function InLevel takes integer world, integer level returns boolean
        return Rects.Find(world, level) != 0
    endfunction
    
    private struct TeleportEffect
        private static sList list = 0
        private static integer end = 550
        private static real tick = 20
        private integer repeat = 0
        private effect e

        private method Remove takes nothing returns nothing
            call list.remove(this)
            call EXSetEffectXY(this.e, 13000, 8000)
            call DestroyEffect(this.e)
            call thistype.deallocate(this)
        endmethod

        private stub method GetHandle takes nothing returns integer
            return 0
        endmethod

        private stub method GetX takes nothing returns real
            return 1.0
        endmethod

        private stub method GetY takes nothing returns real
            return 1.0
        endmethod

        public method PositionSync takes nothing returns nothing
            call EXSetEffectXY(this.e, this.GetX(), this.GetY())

            set this.repeat = this.repeat + 1
            if this.repeat * tick >= end then
                call this.Remove()
            endif
        endmethod

        public static method Sync takes nothing returns nothing
            local integer i = 0
            //! runtextmacro for("set i = 0", "i < list.size")
                call thistype(list[i]).PositionSync()
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public static method Add takes thistype this returns nothing
            local integer i = 0
            //! runtextmacro for("set i = 0", "i < list.size")
                if thistype(list[i]).GetHandle() == this.GetHandle() then
                    call thistype(list[i]).Remove()
                    exitwhen true
                endif
            //! runtextmacro for_end("set i = i + 1")

            call list.add(this)
        endmethod

        public static method create takes integer alpha, boolean inMirror returns thistype
            local thistype this = thistype.allocate()
            local string path = "MirrorPurpleTeleport.mdx"
            if inMirror then
                set path = "MirrorBlueTeleport.mdx"
            endif

            set this.e = AddSpecialEffect(path, this.GetX(), this.GetY())
            set this.repeat = 0
            call EXSetEffectZ(this.e, 5)
            call EXSetEffectSize(this.e, 1.9)
            if alpha < 100 then
                call SetSpecialEffectAlpha(this.e, alpha)
            endif

            return this
        endmethod

        private static method onInit takes nothing returns nothing
            set list = sList.create()
        endmethod
    endstruct

    private struct TeleportEffectFromUnit extends TeleportEffect
        private unit u

        private method GetHandle takes nothing returns integer
            return GetHandleId(this.u)
        endmethod

        private method GetX takes nothing returns real
            return GetUnitX(this.u)
        endmethod

        private method GetY takes nothing returns real
            return GetUnitY(this.u)
        endmethod

        public static method create takes unit u, integer alpha, boolean inMirror returns thistype
            local thistype this = thistype.allocate(alpha, inMirror)
            set this.u = u
            return this
        endmethod
    endstruct

    private struct TeleportEffectFromEffect extends TeleportEffect
        private effect ef

        private method GetHandle takes nothing returns integer
            return GetHandleId(this.ef)
        endmethod

        private method GetX takes nothing returns real
            return EXGetEffectX(this.ef)
        endmethod

        private method GetY takes nothing returns real
            return EXGetEffectY(this.ef)
        endmethod

        public static method create takes effect ef, integer alpha, boolean inMirror returns thistype
            local thistype this = thistype.allocate(alpha, inMirror)
            set this.ef = ef
            return this
        endmethod
    endstruct

    private function BackGroundsCheck takes real x, real y returns boolean
        return GetTerrainType(x, y) == BACKGROUND_TILE and IsPointInRegion(Rect_NoEntry, x, y) == false
    endfunction

    private function BackGroundMove takes integer i, real offsetX, real offsetY returns nothing
        call SetUnitX(BackGroundUnits[i], GetUnitX(BackGroundUnits[i]) + offsetX)
        call SetUnitY(BackGroundUnits[i], GetUnitY(BackGroundUnits[i]) + offsetY)
    endfunction

    private function CollisionCheck takes real nx, real ny returns boolean
        return BackGroundsCheck(nx - 39.9, ny) and BackGroundsCheck(nx + 39.9, ny) and BackGroundsCheck(nx, ny - 10) and BackGroundsCheck(nx, ny + 10)
    endfunction

    private function Teleport takes integer i, real x, real y, real nx, real ny returns boolean
        local real offsetX = 0
        set Frame_MainPlayerY = 0
        call MushroomMoving_RectCondition(i, x, y, 40, "DownWidthOM")

        if CollisionCheck(nx, ny) then
            call SetUnitPosition( OrangeMushroom[i], nx, ny )
            call BackGroundMove(i, nx - x, ny - y)
            call TeleportEffect.Add(TeleportEffectFromUnit.create(OrangeMushroom[i], 100, inMirrorState[i]))
            call TeleportEffect.Add(TeleportEffectFromEffect.create(shadowEffect[i], 90, not(inMirrorState[i])))

            if Frame_MainPlayerY != 0 and MushroomType(GetUnitTypeId(OrangeMushroom[Frame_MainPlayerY])) == false and Frame_MainPlayerY > PLAYER_MAXINUM then
                set offsetX = GetUnitX(OrangeMushroom[Frame_MainPlayerY]) - x
                call Water_EffectTimer(Frame_MainPlayerY)
                if GravityChanger_State == false and CollisionCheck(nx + offsetX, ny-90) then
                    call SetUnitPosition( OrangeMushroom[Frame_MainPlayerY], nx + offsetX, ny-90 )
                elseif GravityChanger_State == true and CollisionCheck(nx + offsetX, ny+90) then
                    call SetUnitPosition( OrangeMushroom[Frame_MainPlayerY], nx + offsetX, ny+90 )
                endif
                call TeleportEffect.Add(TeleportEffectFromUnit.create(OrangeMushroom[Frame_MainPlayerY], 100, inMirrorState[i]))
            endif
            
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
        local Rects rects = Rects.Find(world, level)
        
        if rects == 0 then
            return null
        endif

        if inMirrorState[i] then
            set nx = x - GetRectCenterX(rects.Sub) + GetRectCenterX(rects.Main)
            set ny = y - GetRectCenterY(rects.Sub) + GetRectCenterY(rects.Main)
        else
            set nx = x - GetRectCenterX(rects.Main) + GetRectCenterX(rects.Sub)
            set ny = y - GetRectCenterY(rects.Main) + GetRectCenterY(rects.Sub)
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
                call TeleportEffect.Sync()
                call RemoveLocation(xy)
            endif
        //! runtextmacro for_end("set i = i + 1")

        set xy = null
    endfunction

    public function RemoveShadow takes integer i returns nothing
        local effect shadow = shadowEffect[i]
        set shadowEffect[i] = null
        // 삭제해도 일정시간 남아있기 때문에 좌표를 멀리 이동시킨다.
        call EXSetEffectXY(shadow, 13000, 8000)
        call DestroyEffect(shadow)
        set shadow = null
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
            set shadow = null
        endmethod

        public method RightJumpMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, RIGHT_JUMP_ANIMATION)
            set shadow = null
        endmethod

        public method LeftStandMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, LEFT_STAND_ANIMATION)
            set shadow = null
        endmethod

        public method RightStandMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, RIGHT_STAND_ANIMATION)
            set shadow = null
        endmethod

        public method LeftWalkMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, LEFT_WALK_ANIMATION)
            set shadow = null
        endmethod

        public method RightWalkMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, RIGHT_WALK_ANIMATION)
            set shadow = null
        endmethod

        public method LeftDownMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, LEFT_DOWN_ANIMATION)
            set shadow = null
        endmethod

        public method RightDownMotion takes integer i returns nothing
            local effect shadow = shadowEffect[i]
            if shadow == null then
                return
            endif

            call KeyEffectAnimation(shadow, RIGHT_DOWN_ANIMATION)
            set shadow = null
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
            call Observer_Reload.evaluate(i)
        endif

        call RemoveLocation(xy)
        set xy = null
        return true
    endfunction

    public function Reset takes integer world, integer level returns nothing
        local integer i = 1

        //! runtextmacro for("set i = 1", "i <= PLAYER_MAXINUM")
            set inMirrorState[i] = false
            call RemoveShadow(i)
        //! runtextmacro for_end("set i = i + 1")

        if InLevel(world, level) == false then
            return
        endif

        if registed == false then
            call UnitMotion_AddMotion(ShadowMotion.create())
            set registed = true
        endif

        //! runtextmacro for("set i = 1", "i <= PLAYER_MAXINUM")
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                call ChangeBackGround(i, false)
                call CreateShadow(i)
            endif
        //! runtextmacro for_end("set i = i + 1")
    endfunction

    private function Init takes nothing returns nothing
        call Rects.Add(17, 1, gg_rct_MirrorOffsetMain001, gg_rct_MirrorOffsetSub001)
        call Rects.Add(17, 2, gg_rct_MirrorOffsetMain002, gg_rct_MirrorOffsetSub002)
        call Rects.Add(17, 3, gg_rct_MirrorOffsetMain003, gg_rct_MirrorOffsetSub003)
    endfunction
endlibrary  