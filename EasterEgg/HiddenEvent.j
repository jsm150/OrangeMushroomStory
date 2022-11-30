library HiddenEvent initializer init
    private struct Hint
        public stub method View takes nothing returns nothing
        endmethod
    endstruct

    private struct WorldChallengeHint extends Hint
        public method View takes nothing returns nothing
            call SetFilter(1.00, 100, 100, 100, 0, 100, 100, 100, 100 )
            call SetDoodadAnimation(6144, -29120, 128.00, 'LOxx', false, "stand ready", false)
        endmethod
    endstruct

    private struct MazeClearHint extends Hint
        public method View takes nothing returns nothing
            call SetFilter(1.00, 100, 100, 100, 0, 100, 100, 100, 100 )
            call SetDoodadAnimation(13295, -31512, 128.00, 'LOxx', false, "stand work", false)
        endmethod
    endstruct

    private struct WorldChallenge2Hint extends Hint
        public method View takes nothing returns nothing
            call SetFilter(1.00, 100, 100, 100, 0, 100, 100, 100, 100 )
            call SetDoodadAnimation(22880, 27600, 128.00, 'LOxx', false, "stand first", false)
            call SetDoodadAnimation(22880 + 512, 27600, 128.00, 'LOxx', false, "stand second", false)
            call SetDoodadAnimation(22880 + 1024, 27600, 128.00, 'LOxx', false, "stand third", false)
        endmethod
    endstruct

    private struct HiddenEventRegister
        private region array Rects[7]
        private integer CountInt = 0
        private trigger T
        private Hint hint

        public method Add takes rect r returns nothing
            set this.CountInt = this.CountInt + 1
            set this.Rects[CountInt] = CreateRegion()
            call RegionAddRect( this.Rects[CountInt], r )
            call TriggerRegisterEnterRegion(this.T, this.Rects[CountInt], null)
        endmethod

        private method Execute takes nothing returns nothing
            local integer i = 1
            local integer p = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
            
            loop
                exitwhen i > PLAYER_MAXINUM
                // exitwhen i > 1
                if GetPlayerId(GetOwningPlayer(GetTriggerUnit())) != i - 1 and IsUnitInRegion(this.Rects[i], OrangeMushroom[i]) == false then
                    return
                endif
                set i = i + 1
            endloop

            call this.hint.View()
            call this.destroy()
        endmethod

        public static method create takes Hint hint returns thistype
            local thistype this = thistype.allocate()
            set this.T = CreateTrigger()
            call EventMethod.AddByExecute(this.T, this, this.Execute)
            set this.hint = hint
            return this
        endmethod

        public method destroy takes nothing returns nothing
            local integer i = 1
            //! runtextmacro for("set i = 1", "i <= CountInt")
                call RemoveRegion(this.Rects[i])
            //! runtextmacro for_end("set i = i + 1")
            call EventMethod.Destroy(this.T)
            call thistype.deallocate(this)
        endmethod
    endstruct
    
    private function init takes nothing returns nothing
        local HiddenEventRegister e = HiddenEventRegister.create(WorldChallengeHint.create())
        call e.Add(gg_rct_HiddenEvent001)
        call e.Add(gg_rct_HiddenEvent002)
        call e.Add(gg_rct_HiddenEvent003)
        call e.Add(gg_rct_HiddenEvent004)
        call e.Add(gg_rct_HiddenEvent005)
        call e.Add(gg_rct_HiddenEvent006)
        call e.Add(gg_rct_HiddenEvent007)

        set e = HiddenEventRegister.create(MazeClearHint.create())
        call e.Add(gg_rct_MazeHiddenEvent001)
        call e.Add(gg_rct_MazeHiddenEvent002)
        call e.Add(gg_rct_MazeHiddenEvent003)
        call e.Add(gg_rct_MazeHiddenEvent004)
        call e.Add(gg_rct_MazeHiddenEvent005)
        call e.Add(gg_rct_MazeHiddenEvent006)
        call e.Add(gg_rct_MazeHiddenEvent007)

        set e = HiddenEventRegister.create(WorldChallenge2Hint.create())
        call e.Add(gg_rct_World2Event001)
        call e.Add(gg_rct_World2Event002)
        call e.Add(gg_rct_World2Event003)
        call e.Add(gg_rct_World2Event004)
        call e.Add(gg_rct_World2Event005)
        call e.Add(gg_rct_World2Event006)
        call e.Add(gg_rct_World2Event007)
    endfunction
endlibrary