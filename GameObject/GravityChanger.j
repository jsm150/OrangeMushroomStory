library GravityChanger initializer init
    globals
        private tick tk
        public boolean Loading = false
        public boolean State = false
        private boolean array RectState
        
        public region array Rects
        
        private rect array CompareRect
        private integer CountInt = 0
        
        public real SentinelTime = 0
        public real SentinelTime2 = 0

        public integer array UseList
        public integer UseCount
    endglobals
    
    private function HistoryRecord takes integer i returns nothing
        set UseList[UseCount] = i
        set UseCount = UseCount + 1
        call JNWriteLog("Save " + I2S(i) + " Count " + I2S(UseCount))
    endfunction

    private function InitHistory takes nothing returns nothing
        set UseCount = 0
    endfunction

    public function Use takes integer i returns nothing
        call SetDoodadAnimationRect(CompareRect[i], 'LOar', "death", false)
        set RectState[i] = true
        call HistoryRecord(i)
    endfunction

    private function SentinelStartAnimation takes nothing returns nothing
        call SetUnitTimeScale(GetEnumUnit(), 1)
    endfunction
    
    private function SentinelStopAnimation takes nothing returns nothing
        call SetUnitTimeScale(GetEnumUnit(), 0)
    endfunction
    
    private function TypeCondition takes nothing returns boolean
        local integer kind = GetUnitTypeId(GetTriggerUnit())
        return MushroomType(kind) or kind == 'opeo' or kind == 'ogru' or kind == 'otau' or kind == 'ocat' or kind == 'ohun' or kind == 'o000' or kind == 'o001' or kind == 'h00S' or kind == 'h00T'
    endfunction
    
    public function ChangeTimerAction takes nothing returns nothing
        local integer i = 1
        local real x
        local real y

        set State = not(State)
        loop
        exitwhen i > PLAYER_MAXINUM+Stage_BoxsCount
            if i <= PLAYER_MAXINUM then
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set SteppedPlayer[i] = 0
                    call SetUnitTimeScale(OrangeMushroom[i], 1)
                    set gravity[i] = gravity[i]*-1
                    if gravity[i] < -30 then
                        set gravity[i] = -30
                    endif
                    if LeftArrow[i] == false or RightArrow[i] == false then
                        if LeftArrow[i] == true then
                            set LeftArrow[i] = false
                            set RightArrow[i] = true
                            set Direction[i] = "Right"
                        elseif RightArrow[i] == true then
                            set LeftArrow[i] = true
                            set RightArrow[i] = false
                            set Direction[i] = "Left"
                        endif
                    endif
                    if NameTextTag[i] != null and LevelClearState[i] == false then
                        call SetTextTagVisibility(NameTextTag[i], true)
                        if GravityChanger_State == false then
                            call SetUnitFacing( OrangeMushroom[i], 270 )
                            call Decorate_SetUnitAngle(i - 1, 270)
                            call SetTextTagPos(NameTextTag[i], GetUnitX(OrangeMushroom[i])-50, GetUnitY(OrangeMushroom[i])-120, 0)
                        else
                            call SetUnitFacing( OrangeMushroom[i], 90 )
                            call Decorate_SetUnitAngle(i - 1, 90)
                            call SetTextTagPos(NameTextTag[i], GetUnitX(OrangeMushroom[i])+50, GetUnitY(OrangeMushroom[i])+120, 0)
                        endif
                    endif
                endif
            else
                call SetUnitTimeScale(OrangeMushroom[i], 1)
                if LeftArrow[i] == false or RightArrow[i] == false then
                    if LeftArrow[i] == true then
                        set LeftArrow[i] = false
                        set RightArrow[i] = true
                        set Direction[i] = "Right"
                    elseif RightArrow[i] == true then
                        set LeftArrow[i] = true
                        set RightArrow[i] = false
                        set Direction[i] = "Left"
                    endif
                endif
                set SteppedPlayer[i] = 0
                set gravity[i] = gravity[i]*-1
                if gravity[i] < -30 then
                    set gravity[i] = -30
                endif
                if GravityChanger_State == false then
                    call SetUnitFacing( OrangeMushroom[i], 270 )
                else
                    call SetUnitFacing( OrangeMushroom[i], 90 )
                endif
                if GetUnitTypeId(OrangeMushroom[i]) == 'orai' then
                    set x = GetUnitX(OrangeMushroom[i])
                    set y = GetUnitY(OrangeMushroom[i])
                    call RemoveUnit(OrangeMushroom[i])
                    if GravityChanger_State == false then
                        set OrangeMushroom[i] = CreateUnit(Player(i-1), 'orai', x, y, 270 )
                    else
                        set OrangeMushroom[i] = CreateUnit(Player(i-1), 'orai', x, y, 90 )
                    endif
                    call SetUnitBlendTime(OrangeMushroom[i], 0.00)
                    call SetUnitUserData( OrangeMushroom[i], 0 )
                    if Direction[i] == "Left" then
                        if GravityChanger_State == false then
                            call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                        else
                            call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                        endif
                    elseif Direction[i] == "Right" then
                        if GravityChanger_State == false then
                            call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                        else
                            call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                        endif
                    endif
                endif
            endif
        set i = i + 1
        endloop
    endfunction

    private function ChangeTimer takes nothing returns nothing
        call tk.destroy()
        set Loading = false
        call SetSoundVolume(BackgroundMusic, 127)
        call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0.00, 0.00, 0.00, 30, 0, 0, 0, 100 )
        call ForGroup(Stage_SentinelGroup, function SentinelStartAnimation)
        if SentinelTime != 0 or SentinelTime2 != 0 then
            call TriggerExecute( Stage_SentinelTrigger )
        endif
        call ChangeTimerAction()
    endfunction
    
    public function Init takes nothing returns nothing
        local integer i = 1
        
        loop
        exitwhen CompareRect[i] == null
            if RectState[i] == true then
                set RectState[i] = false
                call SetDoodadAnimationRect(CompareRect[i], 'LOar', "Stand", false)
            endif
        set i = i + 1
        endloop
        call InitHistory()
    endfunction

    public function ChangeAction takes nothing returns nothing
        local integer i = 1
        
        loop
        exitwhen i > PLAYER_MAXINUM+Stage_BoxsCount
            if i <= PLAYER_MAXINUM then
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitTimeScale(OrangeMushroom[i], 0)
                    if NameTextTag[i] != null then
                        call SetTextTagVisibility(NameTextTag[i], false)
                    endif
                    if State == false then
                        call SetUnitFacingTimed( OrangeMushroom[i], 85.0, 0.82)
                    else
                        call SetUnitFacingTimed( OrangeMushroom[i], 275.0, 0.82)
                    endif
                    if GravityChanger_State == false and Player(i-1) == GetLocalPlayer() then
                        if Observer_ViewNumber[i] == 0 then
                            call PanCameraToTimed(GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i])-128, 1)
                        else
                            call PanCameraToTimed(GetUnitX(OrangeMushroom[Observer_ViewNumber[i]]), GetUnitY(OrangeMushroom[Observer_ViewNumber[i]])-128, 1)
                        endif
                    elseif Player(i-1) == GetLocalPlayer() then
                        if Observer_ViewNumber[i] == 0 then
                            call PanCameraToTimed(GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i])+128, 1)
                        else
                            call PanCameraToTimed(GetUnitX(OrangeMushroom[Observer_ViewNumber[i]]), GetUnitY(OrangeMushroom[Observer_ViewNumber[i]])+128, 1)
                        endif
                    endif
                endif
            else
                call SetUnitTimeScale(OrangeMushroom[i], 0)
                if State == false then
                    call SetUnitFacingTimed( OrangeMushroom[i], 85.0, 0.82)
                else
                    call SetUnitFacingTimed( OrangeMushroom[i], 275.0, 0.82)
                endif
            endif
        set i = i + 1
        endloop

        if State == false then
            call SetCameraField(CAMERA_FIELD_ROTATION, 270.0, 1)
        else
            call SetCameraField(CAMERA_FIELD_ROTATION, 90.0, 1)
        endif
    endfunction
    
    private function Change takes nothing returns nothing
        set Loading = true
        call SetSoundVolume(BackgroundMusic, 80)
        call StopSound(gg_snd_GearSound001, false, false)
        call StartSound(gg_snd_GearSound001)
        call ForGroup(Stage_SentinelGroup, function SentinelStopAnimation)
        call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0.00, 0.00, 0.00, 100, 0, 0, 0, 30 )
        call ChangeAction()

        
        set tk = tick.create(0)
        call tk.start(1.0, false, function ChangeTimer)
    endfunction
    
    public function Action takes integer i returns nothing
        local real x
        local real y

        set SentinelTime = TimerGetRemaining(Stage_SentinelTimer)
        call PauseTimer(Stage_SentinelTimer)
        if TimerGetRemaining(Stage_SentinelTimer2) != 0 then
            set SentinelTime2 = TimerGetRemaining(Stage_SentinelTimer2)
            call PauseTimer(Stage_SentinelTimer2)
        endif
        set x = GetRectCenterX(CompareRect[i])
        set y = GetRectCenterY(CompareRect[i])
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", x, y ))
        call SetDoodadAnimationRect(CompareRect[i], 'LOar', "death", false)
        set RectState[i] = true
        call HistoryRecord(i)
        call Change()
    endfunction

    private function Main takes nothing returns nothing
        local integer i = 1
        
        
        if Loading == false and Stage_Loading == false then
        loop
        exitwhen CompareRect[i] == null
            if GetTriggeringRegion() == Rects[i] and RectState[i] == false and TypeCondition() == true then
                call Action(i)
            endif
        set i = i + 1
        endloop
        endif
    endfunction
    
    private function SetRect takes trigger t, rect r returns nothing
        set CountInt = CountInt + 1
        set Rects[CountInt] = CreateRegion()
        call RegionAddRect( Rects[CountInt], r )
        set CompareRect[CountInt] = r
        call TriggerRegisterEnterRegion(t, Rects[CountInt], null)
    endfunction
    
    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call SetRect(t, gg_rct_GravityChanger001)
        call SetRect(t, gg_rct_GravityChanger002)
        call SetRect(t, gg_rct_GravityChanger003)
        call SetRect(t, gg_rct_GravityChanger004)
        call SetRect(t, gg_rct_GravityChanger005)
        call SetRect(t, gg_rct_GravityChanger006)
        call SetRect(t, gg_rct_GravityChanger007)
        call SetRect(t, gg_rct_GravityChanger008)
        call SetRect(t, gg_rct_GravityChanger009)
        call SetRect(t, gg_rct_GravityChanger010)
        call SetRect(t, gg_rct_GravityChanger011)
        call SetRect(t, gg_rct_GravityChanger012)
        call SetRect(t, gg_rct_GravityChanger013)
        call SetRect(t, gg_rct_GravityChanger014)
        call SetRect(t, gg_rct_GravityChanger015)
        call SetRect(t, gg_rct_GravityChanger016)
        call SetRect(t, gg_rct_GravityChanger017)
        call SetRect(t, gg_rct_GravityChanger018)
        call SetRect(t, gg_rct_GravityChanger019)
        call SetRect(t, gg_rct_GravityChanger020)
        call SetRect(t, gg_rct_GravityChanger021)
        call SetRect(t, gg_rct_GravityChanger022)
        call SetRect(t, gg_rct_GravityChanger023)
        call SetRect(t, gg_rct_GravityChanger024)
        call SetRect(t, gg_rct_GravityChanger025)
        call SetRect(t, gg_rct_GravityChanger026)
        call SetRect(t, gg_rct_GravityChanger027)
        call SetRect(t, gg_rct_GravityChanger028)
        call SetRect(t, gg_rct_GravityChanger029)
        call SetRect(t, gg_rct_GravityChanger030)
        call SetRect(t, gg_rct_GravityChanger031)
        call SetRect(t, gg_rct_GravityChanger032)
        call SetRect(t, gg_rct_GravityChanger033)
        call SetRect(t, gg_rct_GravityChanger034)
        call SetRect(t, gg_rct_GravityChanger035)
        call SetRect(t, gg_rct_GravityChanger036)
        call SetRect(t, gg_rct_GravityChanger037)
        call SetRect(t, gg_rct_GravityChanger038)
        call SetRect(t, gg_rct_GravityChanger039)
        call SetRect(t, gg_rct_GravityChanger040)
        call SetRect(t, gg_rct_GravityChanger041)
        call SetRect(t, gg_rct_GravityChanger042)
        call SetRect(t, gg_rct_GravityChanger043)
        call SetRect(t, gg_rct_GravityChanger044)
        call SetRect(t, gg_rct_GravityChanger045)
        call SetRect(t, gg_rct_GravityChanger046)
        call SetRect(t, gg_rct_GravityChanger047)

        call TriggerAddAction( t, function Main )
        
        set t = null
    endfunction
endlibrary