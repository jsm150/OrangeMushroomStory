library CaveHiddenEvent initializer Init
    globals
        private constant integer KeyTableID = 'n001'
        private constant integer DownArrow = 'n002'
        private constant integer LeftArrow = 'n003'
        private constant integer RightArrow = 'n004'
        private constant integer UpArrow = 'n005'
        private tick TimeLimit

        public boolean CaveEntranceOpen = false
    endglobals


    private struct KeyInfo
        static integer DownArrow = 1
        static integer LeftArrow = 2
        static integer RightArrow = 3
        static integer UpArrow = 4

        private real size = 0.7
        private integer transparency = 70

        boolean destroyed = false
        unit Unit
        integer UnitArrow
        trigger Trigger

        public method KeyRemoveAction takes nothing returns nothing
            call this.SetSizeAndTransparency()

            if this.transparency > 90 then
                call DestroyTrigger(this.Trigger)
                call RemoveUnit(this.Unit)
                
                set this.Trigger = null
                set this.Unit = null
            endif
        endmethod

        method SetSizeAndTransparency takes nothing returns nothing
            call SetUnitScale(this.Unit, this.size, this.size, 1)
            call SetUnitVertexColorBJ( this.Unit, 100.00, 100.00, 100.00, this.transparency )
            set this.transparency = this.transparency + 5
        endmethod

        method destroy takes nothing returns nothing
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl", GetUnitX(this.Unit), GetUnitY(this.Unit)))
            call RemoveUnit(this.Unit)
            call EventMethod.Destroy(this.Trigger)

            set this.Trigger = null
            set this.Unit = null

            if this.destroyed == false then
                call thistype.deallocate(this)
                set this.destroyed = true
            endif
        endmethod
    endstruct

    //! runtextmacro Make_Container("KeyInfo", "7")

    private struct CaveHiddenObject
        private integer accessNumber = 0

        trigger EventStartTrigger
        trigger array KeyboardTrigger[4]
        boolean Reverse = false
        region Region
        string Hint
        rect NoticeRect
        rect KeyTableRect
        unit KeyTable
        rect array Rects[7]
        KeyInfoContainer Key
        
        
        method onDestroy takes nothing returns nothing
            local integer i = 0

            call Key.destroy()
            call DestroyTrigger(this.EventStartTrigger)
            call RemoveRegion(this.Region)
            call RemoveUnit(this.KeyTable)
            call RemoveRect(this.KeyTableRect)
            call RemoveRect(this.NoticeRect)
            
            set this.EventStartTrigger = null
            set this.Region = null
            set this.KeyTable = null
            set this.KeyTableRect = null
            set this.NoticeRect = null
            
            loop
                exitwhen i >= 7
                call RemoveRect(this.Rects[i])
                set this.Rects[i] = null

                if i < 4 then
                    call EventMethod.Destroy(this.KeyboardTrigger[i])
                    set this.KeyboardTrigger[i] = null
                endif

                set i = i + 1
            endloop

        endmethod

        private static method DestroyObject takes nothing returns nothing
            local thistype obj = TimeLimit.data
            call obj.destroy()
        endmethod

        public method OnEnterRegion takes nothing returns nothing
            local integer i = 0

            loop
                exitwhen i >= 7
                // exitwhen i >= 1
                if GetPlayerId(GetOwningPlayer(GetTriggerUnit())) != i and RectContainsUnit(this.Rects[i], OrangeMushroom[i + 1]) == false then
                    return
                endif
                set i = i + 1
            endloop

            call this.KeyboardEventStart()
        endmethod

        //! runtextmacro Make_Keyboard_Event_Method("ArrowDownEvent", "KeyInfo.DownArrow")
        //! runtextmacro Make_Keyboard_Event_Method("ArrowLeftEvent", "KeyInfo.LeftArrow")
        //! runtextmacro Make_Keyboard_Event_Method("ArrowRightEvent", "KeyInfo.RightArrow")
        //! runtextmacro Make_Keyboard_Event_Method("ArrowUpEvent", "KeyInfo.UpArrow")
        
        method KeyDownAction takes integer i, integer Arrow returns nothing
            local integer id = 'D003'

            if this.Reverse then
                set id = 'D004'
            endif

            if this.Key[i].UnitArrow == Arrow then
                call StartSound(gg_snd_KeySound)
                call TriggerRegisterTimerEvent(this.Key[i].Trigger, 0.05, true)
                set this.accessNumber = this.accessNumber + 1

                if this.accessNumber == 7 then
                // if this.accessNumber == 1 then
                    call SetFilter(1.00, 100, 100, 100, 0, 100, 100, 100, 100 )
                    call SetDoodadAnimation(GetRectMinX(this.NoticeRect), GetRectMaxY(this.NoticeRect), 128.00, id, false, this.Hint, false)

                    call this.onDestroy()
                endif
            else
                call this.onDestroy()
            endif

        endmethod

        method SetKeyboardTrigger takes nothing returns nothing
            local integer i = 0

            set this.KeyboardTrigger[0] = CreateTrigger()
            call EventMethod.AddByEvaluate(this.KeyboardTrigger[0], this, this.ArrowDownEvent)
            set this.KeyboardTrigger[1] = CreateTrigger()
            call EventMethod.AddByEvaluate(this.KeyboardTrigger[1], this, this.ArrowLeftEvent)
            set this.KeyboardTrigger[2] = CreateTrigger()
            call EventMethod.AddByEvaluate(this.KeyboardTrigger[2], this, this.ArrowRightEvent)
            set this.KeyboardTrigger[3] = CreateTrigger()
            call EventMethod.AddByEvaluate(this.KeyboardTrigger[3], this, this.ArrowUpEvent)

            loop
                exitwhen i >= 7
                call TriggerRegisterPlayerEvent(this.KeyboardTrigger[0], Player(i), EVENT_PLAYER_ARROW_DOWN_DOWN)
                call TriggerRegisterPlayerEvent(this.KeyboardTrigger[1], Player(i), EVENT_PLAYER_ARROW_LEFT_DOWN)
                call TriggerRegisterPlayerEvent(this.KeyboardTrigger[2], Player(i), EVENT_PLAYER_ARROW_RIGHT_DOWN)
                call TriggerRegisterPlayerEvent(this.KeyboardTrigger[3], Player(i), EVENT_PLAYER_ARROW_UP_DOWN)
                set i = i + 1
            endloop
        endmethod

        method KeyboardEventStart takes nothing returns nothing
            local integer angle = 270
            local integer array KeyList
            local integer array KeyList2
            local integer i = 0
            local integer idx = -1
            local real posX = 0
            
            if this.Reverse then
                set angle = 90
            endif

            set KeyList[0] = DownArrow
            set KeyList[1] = LeftArrow
            set KeyList[2] = RightArrow
            set KeyList[3] = UpArrow

            set KeyList2[0] = KeyInfo.DownArrow
            set KeyList2[1] = KeyInfo.LeftArrow
            set KeyList2[2] = KeyInfo.RightArrow
            set KeyList2[3] = KeyInfo.UpArrow

            call this.SetKeyboardTrigger()            

            set this.KeyTable = CreateUnit(Player(11), KeyTableID, GetRectCenterX(KeyTableRect), GetRectCenterY(KeyTableRect), angle)
            call SetUnitVertexColorBJ(this.KeyTable, 100, 100, 100, 20)
            
            set this.Key = KeyInfoContainer.create()

            loop
                exitwhen i >= 7
                if this.Reverse then
                    set posX = GetRectMaxX(KeyTableRect) - (i * 128) - 91
                else
                    set posX = GetRectMinX(KeyTableRect) + (i * 128) + 91
                endif

                set this.Key[i] = KeyInfo.create()
                set this.Key[i].Trigger = CreateTrigger()
                call EventMethod.AddByEvaluate(this.Key[i].Trigger, this.Key[i], KeyInfo.KeyRemoveAction)

                set idx = GetRandomInt(0, 3)
                set this.Key[i].UnitArrow = KeyList2[idx]

                set this.Key[i].Unit = CreateUnit(Player(11), KeyList[idx], posX, GetRectCenterY(KeyTableRect), angle)
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl", posX, GetRectCenterY(KeyTableRect) ))

                set i = i + 1
            endloop

            set TimeLimit.data = this
            call TimeLimit.start(3.5, false, function thistype.DestroyObject)

            call DestroyTrigger(this.EventStartTrigger)
            set this.EventStartTrigger = null
        endmethod
    endstruct

    //! runtextmacro Make_Container("CaveHiddenObject", "7")

    private struct CaveOpenKey
        static key eventId

        trigger array KeyboardTrigger[4]
        integer array Arrow[6]
        region Region
        trigger EventStartTrigger
        integer AccessNumber = 0

        method destroy takes nothing returns nothing
            local integer i = 0

            call DestroyTrigger(this.EventStartTrigger)
            call RemoveRegion(this.Region)

            set this.EventStartTrigger = null
            set this.Region = null

            loop
                exitwhen i >= 4
                call EventMethod.Destroy(this.KeyboardTrigger[i])
                set this.KeyboardTrigger[i] = null

                set i = i + 1
            endloop

            call thistype.deallocate(this)
        endmethod

        //! runtextmacro Make_Keyboard_Event_Method2("ArrowDownEvent", "KeyInfo.DownArrow")
        //! runtextmacro Make_Keyboard_Event_Method2("ArrowLeftEvent", "KeyInfo.LeftArrow")
        //! runtextmacro Make_Keyboard_Event_Method2("ArrowRightEvent", "KeyInfo.RightArrow")
        //! runtextmacro Make_Keyboard_Event_Method2("ArrowUpEvent", "KeyInfo.UpArrow")

        public method StartInputKey takes nothing returns nothing
            local integer i = 0

            set this.KeyboardTrigger[0] = CreateTrigger()
            call EventMethod.AddByEvaluate(this.KeyboardTrigger[0], this, this.ArrowDownEvent)
            set this.KeyboardTrigger[1] = CreateTrigger()
            call EventMethod.AddByEvaluate(this.KeyboardTrigger[1], this, this.ArrowLeftEvent)
            set this.KeyboardTrigger[2] = CreateTrigger()
            call EventMethod.AddByEvaluate(this.KeyboardTrigger[2], this, this.ArrowRightEvent)
            set this.KeyboardTrigger[3] = CreateTrigger()
            call EventMethod.AddByEvaluate(this.KeyboardTrigger[3], this, this.ArrowUpEvent)

            loop
                exitwhen i >= 7
                call TriggerRegisterPlayerEvent(this.KeyboardTrigger[0], Player(i), EVENT_PLAYER_ARROW_DOWN_DOWN)
                call TriggerRegisterPlayerEvent(this.KeyboardTrigger[1], Player(i), EVENT_PLAYER_ARROW_LEFT_DOWN)
                call TriggerRegisterPlayerEvent(this.KeyboardTrigger[2], Player(i), EVENT_PLAYER_ARROW_RIGHT_DOWN)
                call TriggerRegisterPlayerEvent(this.KeyboardTrigger[3], Player(i), EVENT_PLAYER_ARROW_UP_DOWN)
                set i = i + 1
            endloop

            call EventMethod.Destroy(this.EventStartTrigger)
            set this.EventStartTrigger = null
        endmethod

        method KeyDownAction takes integer arrow returns nothing
            local integer i = GetPlayerId(GetTriggerPlayer()) + 1

            if i == HostNumber and this.Arrow[this.AccessNumber] == arrow and RectContainsUnit(gg_rct_Cave, OrangeMushroom[i]) then
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl", GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i])))
                set this.AccessNumber = this.AccessNumber + 1

                if this.AccessNumber < 6 then
                    return                    
                endif

                set HiddenCode[8] = true
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_Cave), GetRectCenterY(gg_rct_Cave)))
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 얼음 동굴 입구가 열렸습니다!|r" )
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 단 얼음 동굴 입구로 들어간 인원이 다른 포탈에 들어간 인원보다 적으면 기존 스테이지로 이동합니다.|r" )

                call this.destroy()
            elseif i == HostNumber then
                set this.AccessNumber = 0
            endif
        endmethod
    endstruct

    globals
        private CaveHiddenObjectContainer Objects
    endglobals
    
    private function InitObjects takes nothing returns nothing
        local integer i = 0
        local integer j = 0

        set Objects = Objects.create()

        // Up Up Right Up Left Left
        loop
            exitwhen i >= 7
            set Objects[i] = CaveHiddenObject.create()
            set Objects[i].Region = CreateRegion()

            if i == 0 then
                set Objects[i].KeyTableRect = gg_rct_KeyTableLoc001
                set Objects[i].NoticeRect = gg_rct_CaveHintNotice001
                set Objects[i].Hint = "Up"
                set Objects[i].Rects[0] = gg_rct_CaveHiddenEvent001_1
                set Objects[i].Rects[1] = gg_rct_CaveHiddenEvent001_2
                set Objects[i].Rects[2] = gg_rct_CaveHiddenEvent001_3
                set Objects[i].Rects[3] = gg_rct_CaveHiddenEvent001_4
                set Objects[i].Rects[4] = gg_rct_CaveHiddenEvent001_5
                set Objects[i].Rects[5] = gg_rct_CaveHiddenEvent001_6
                set Objects[i].Rects[6] = gg_rct_CaveHiddenEvent001_7
            elseif i == 1 then
                set Objects[i].KeyTableRect = gg_rct_KeyTableLoc002
                set Objects[i].NoticeRect = gg_rct_CaveHintNotice002
                set Objects[i].Hint = "Left"
                set Objects[i].Rects[0] = gg_rct_CaveHiddenEvent002_1
                set Objects[i].Rects[1] = gg_rct_CaveHiddenEvent002_2
                set Objects[i].Rects[2] = gg_rct_CaveHiddenEvent002_3
                set Objects[i].Rects[3] = gg_rct_CaveHiddenEvent002_4
                set Objects[i].Rects[4] = gg_rct_CaveHiddenEvent002_5
                set Objects[i].Rects[5] = gg_rct_CaveHiddenEvent002_6
                set Objects[i].Rects[6] = gg_rct_CaveHiddenEvent002_7
            elseif i == 2 then
                set Objects[i].KeyTableRect = gg_rct_KeyTableLoc003
                set Objects[i].NoticeRect = gg_rct_CaveHintNotice003
                set Objects[i].Hint = "Up"
                set Objects[i].Rects[0] = gg_rct_CaveHiddenEvent003_1
                set Objects[i].Rects[1] = gg_rct_CaveHiddenEvent003_2
                set Objects[i].Rects[2] = gg_rct_CaveHiddenEvent003_3
                set Objects[i].Rects[3] = gg_rct_CaveHiddenEvent003_4
                set Objects[i].Rects[4] = gg_rct_CaveHiddenEvent003_5
                set Objects[i].Rects[5] = gg_rct_CaveHiddenEvent003_6
                set Objects[i].Rects[6] = gg_rct_CaveHiddenEvent003_7
            elseif i == 3 then
                set Objects[i].KeyTableRect = gg_rct_KeyTableLoc004
                set Objects[i].NoticeRect = gg_rct_CaveHintNotice004
                set Objects[i].Hint = "Up"
                set Objects[i].Rects[0] = gg_rct_CaveHiddenEvent004_1
                set Objects[i].Rects[1] = gg_rct_CaveHiddenEvent004_2
                set Objects[i].Rects[2] = gg_rct_CaveHiddenEvent004_3
                set Objects[i].Rects[3] = gg_rct_CaveHiddenEvent004_4
                set Objects[i].Rects[4] = gg_rct_CaveHiddenEvent004_5
                set Objects[i].Rects[5] = gg_rct_CaveHiddenEvent004_6
                set Objects[i].Rects[6] = gg_rct_CaveHiddenEvent004_7
            elseif i == 4 then
                set Objects[i].KeyTableRect = gg_rct_KeyTableLoc005
                set Objects[i].NoticeRect = gg_rct_CaveHintNotice005
                set Objects[i].Hint = "Right"
                set Objects[i].Rects[0] = gg_rct_CaveHiddenEvent005_1
                set Objects[i].Rects[1] = gg_rct_CaveHiddenEvent005_2
                set Objects[i].Rects[2] = gg_rct_CaveHiddenEvent005_3
                set Objects[i].Rects[3] = gg_rct_CaveHiddenEvent005_4
                set Objects[i].Rects[4] = gg_rct_CaveHiddenEvent005_5
                set Objects[i].Rects[5] = gg_rct_CaveHiddenEvent005_6
                set Objects[i].Rects[6] = gg_rct_CaveHiddenEvent005_7
            elseif i == 5 then
                set Objects[i].Reverse = true
                set Objects[i].KeyTableRect = gg_rct_KeyTableLoc006
                set Objects[i].NoticeRect = gg_rct_CaveHintNotice006
                set Objects[i].Hint = "Stand Ready"
                set Objects[i].Rects[0] = gg_rct_CaveHiddenEvent006_1
                set Objects[i].Rects[1] = gg_rct_CaveHiddenEvent006_2
                set Objects[i].Rects[2] = gg_rct_CaveHiddenEvent006_3
                set Objects[i].Rects[3] = gg_rct_CaveHiddenEvent006_4
                set Objects[i].Rects[4] = gg_rct_CaveHiddenEvent006_5
                set Objects[i].Rects[5] = gg_rct_CaveHiddenEvent006_6
                set Objects[i].Rects[6] = gg_rct_CaveHiddenEvent006_7
            elseif i == 6 then
                set Objects[i].KeyTableRect = gg_rct_KeyTableLoc007
                set Objects[i].NoticeRect = gg_rct_CaveHintNotice007
                set Objects[i].Hint = "Left"
                set Objects[i].Rects[0] = gg_rct_CaveHiddenEvent007_1
                set Objects[i].Rects[1] = gg_rct_CaveHiddenEvent007_2
                set Objects[i].Rects[2] = gg_rct_CaveHiddenEvent007_3
                set Objects[i].Rects[3] = gg_rct_CaveHiddenEvent007_4
                set Objects[i].Rects[4] = gg_rct_CaveHiddenEvent007_5
                set Objects[i].Rects[5] = gg_rct_CaveHiddenEvent007_6
                set Objects[i].Rects[6] = gg_rct_CaveHiddenEvent007_7
            endif

            set j = 0
            loop
                exitwhen j >= 7
                call RegionAddRect(Objects[i].Region, Objects[i].Rects[j])
                set j = j + 1
            endloop

            set Objects[i].EventStartTrigger = CreateTrigger()
            call EventMethod.AddByEvaluate(Objects[i].EventStartTrigger, Objects[i], CaveHiddenObject.OnEnterRegion)
            call TriggerRegisterEnterRegion(Objects[i].EventStartTrigger, Objects[i].Region, null)

            set i = i + 1
        endloop
    endfunction

    private function InstallMushroomInCaveHiddenRect takes nothing returns nothing
        local integer i = 0
        local integer j = 0
        local unit u
        local integer array colorfulType

        set colorfulType[0] = 'nmyr'
        set colorfulType[1] = 'nnrg'
        set colorfulType[2] = 'nhyc'
        set colorfulType[3] = 'nmpe'
        set colorfulType[4] = 'nanm'
        set colorfulType[5] = 'hpea'
        set colorfulType[6] = 'nanb'

        loop
            exitwhen i >= 7

            set j = 0
            loop
                exitwhen j >= 7
                if i != 5 then
                    set u = CreateUnit(Player(11), colorfulType[j], GetRectCenterX(Objects[i].Rects[j]), GetRectCenterY(Objects[i].Rects[j]) - 16.0, 270 )
                else
                    set u = CreateUnit(Player(11), colorfulType[j], GetRectCenterX(Objects[i].Rects[j]), GetRectCenterY(Objects[i].Rects[j]) + 16.0, 90 )
                endif
                call SetUnitVertexColorBJ( u, 100.00, 100.00, 100.00, 20 )
                set j = j + 1
            endloop

            set i = i + 1
        endloop

        set u = null
    endfunction

    private function InitCaveOpenKey takes nothing returns nothing
        local CaveOpenKey obj = CaveOpenKey.create()

        set obj.EventStartTrigger = CreateTrigger()
        call EventMethod.AddByEvaluate(obj.EventStartTrigger, obj, CaveOpenKey.StartInputKey)

        set obj.Region = CreateRegion()
        call RegionAddRect(obj.Region, gg_rct_Cave)

        call TriggerRegisterEnterRegion(obj.EventStartTrigger, obj.Region, null)

        set obj.Arrow[0] = KeyInfo.UpArrow
        set obj.Arrow[1] = KeyInfo.UpArrow
        set obj.Arrow[2] = KeyInfo.RightArrow
        set obj.Arrow[3] = KeyInfo.UpArrow
        set obj.Arrow[4] = KeyInfo.LeftArrow
        set obj.Arrow[5] = KeyInfo.LeftArrow
    endfunction

    public function CaveOpen takes nothing returns nothing
        set CaveEntranceOpen = true
        call CreateUnit(Player(11), 'h005', GetRectCenterX(gg_rct_CaveEntrance), GetRectCenterY(gg_rct_CaveEntrance), 270 )
    endfunction

    private function Init takes nothing returns nothing
        set TimeLimit = tick.create(0)
        call InitObjects()
        call InstallMushroomInCaveHiddenRect()
        call InitCaveOpenKey()
    endfunction

endlibrary


//! textmacro Make_Keyboard_Event_Method takes FuncName, Arrow
    private method $FuncName$ takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())

        if RectContainsUnit(this.Rects[this.accessNumber], OrangeMushroom[i + 1]) and this.accessNumber == i then
            call this.KeyDownAction(i, $Arrow$)
        endif
    endmethod
//! endtextmacro

//! textmacro Make_Keyboard_Event_Method2 takes FuncName, Arrow
    private method $FuncName$ takes nothing returns nothing
        call this.KeyDownAction($Arrow$)
    endmethod
//! endtextmacro
