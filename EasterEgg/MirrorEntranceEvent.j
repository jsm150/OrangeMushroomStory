scope MirrorEntranceEvent initializer Init

    private function Open takes nothing returns nothing
        local effect e
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_Mirror), GetRectCenterY(gg_rct_Mirror)))
        set e = AddSpecialEffect( "war3mapImported\\WillMirror.mdx", GetRectCenterX(gg_rct_Mirror), GetRectCenterY(gg_rct_Mirror) - 96 )
        call EXEffectMatRotateZ(e, 270)
        call EXSetEffectSize(e, 3)
        call SetDoodadAnimation(9152, -3456, 128.00, 'YOf3', false, "stand", false)
        call CameraShaker.All(1.0)

        call SetTerrainType(8960, -3872, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960 + 128, -3872, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960 + 256, -3872, UnTerrain, -1, 1, 0)

        call SetTerrainType(8960, -3872 + 128, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960 + 128, -3872 + 128, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960 + 256, -3872 + 128, UnTerrain, -1, 1, 0)

        call SetTerrainType(8960 - 128, -3872 + 256, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960, -3872 + 256, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960 + 128, -3872 + 256, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960 + 256, -3872 + 256, UnTerrain, -1, 1, 0)

        call SetTerrainType(8960 - 256, -3872 + 384, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960 - 128, -3872 + 384, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960, -3872 + 384, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960 + 128, -3872 + 384, UnTerrain, -1, 1, 0)
        call SetTerrainType(8960 + 256, -3872 + 384, UnTerrain, -1, 1, 0)

        set e = null
    endfunction

    private struct Lever
        public static trigger ValueChangedEvent = CreateTrigger()
        private static integer value = 0
        private boolean waiting = false
        private boolean currentOn = false
        private integer bit
        private rect r

        public static method CurrentValue takes nothing returns integer
            return value
        endmethod

        public static method SetValue takes integer v returns nothing
            set value = v
            call TriggerExecute(ValueChangedEvent)
        endmethod

        private method Wait takes nothing returns nothing
            set waiting = true
            call TriggerSleepActionByTimer(0.50)
            set waiting = false
        endmethod

        public method On takes nothing returns nothing
            local integer i = GetPlayerId(GetTriggerPlayer()) + 1
            if waiting == false and currentOn == false and RectContainsUnit(r, OrangeMushroom[i]) then
                set currentOn = true
                call SetDoodadAnimation(GetRectCenterX(r), GetRectCenterY(r), 128.00, 'D00T', false, "stand2", false)
                call StartSound( gg_snd_light_switch )
                call SetValue(JNBitOr(value, BitShiftL(1, bit - 1)))
                call Wait.execute()
            endif
        endmethod

        public method Off takes nothing returns nothing
            local integer i = GetPlayerId(GetTriggerPlayer()) + 1 
            if waiting == false and currentOn and RectContainsUnit(r, OrangeMushroom[i]) then
                set currentOn = false
                call SetDoodadAnimation(GetRectCenterX(r), GetRectCenterY(r), 128.00, 'D00T', false, "stand", false)
                call StartSound( gg_snd_light_switch )
                call SetValue(JNBitXor(value, BitShiftL(1, bit - 1)))
                call Wait.execute()
            endif
        endmethod

        public static method create takes integer bit, rect r, trigger t returns thistype
            local thistype this = thistype.allocate()
            set this.bit = bit
            set this.r = r
            call EventMethod.AddByEvaluate(t, this, this.On)
            call EventMethod.AddByEvaluate(t, this, this.Off)
            return this
        endmethod
    endstruct


    private struct OpenEventCheck   
        private static integer step = 0
        private static boolean waiting = false

        public static method Action takes nothing returns nothing
            if waiting then
                return
            endif
            set waiting = true
            if step == 0 then
                call TriggerSleepActionByTimer(0.50)
                if Lever.CurrentValue() == 15 then
                    set step = 1
                endif
            elseif step == 1 then
                call TriggerSleepActionByTimer(0.50)
                if Lever.CurrentValue() == 12 then
                    set step = 2
                else
                    set step = 0
                endif
            elseif step == 2 then
                call TriggerSleepActionByTimer(0.50)
                if Lever.CurrentValue() == 3 then
                    set step = 3
                else
                    set step = 0
                endif
            elseif step == 3 then
                call TriggerSleepActionByTimer(0.50)
                if Lever.CurrentValue() == 0 then
                    call Open()
                    set step = -1
                else
                    set step = 0
                endif
            endif
            set waiting = false
        endmethod
    endstruct


    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        local integer i = 0
        local Lever a
        
        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
                call TriggerRegisterPlayerEvent(t, Player(i), EVENT_PLAYER_ARROW_DOWN_DOWN)
            endif
        //! runtextmacro for_end("set i = i + 1")
        
        set a = Lever.create(4, gg_rct_Lever001, t)
        set a = Lever.create(3, gg_rct_Lever002, t)
        set a = Lever.create(2, gg_rct_Lever003, t)
        set a = Lever.create(1, gg_rct_Lever004, t)

        call TriggerAddAction(Lever.ValueChangedEvent, function OpenEventCheck.Action)
        set t = null
    endfunction
endscope