library Multiboard// initializer init
    function BackGroundChange takes integer unitType returns nothing
        local integer i = 1
        local real x
        local real y
        
        loop
        exitwhen i > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                set x = GetUnitX(BackGroundUnits[i])
                set y = GetUnitY(BackGroundUnits[i])
                call RemoveUnit(BackGroundUnits[i])
                set BackGroundUnits[i] = CreateUnit(Player(i-1), unitType, x, y, 270 )
                if SubString("|", -1, 0) != "o" and GetUnitTypeId(BackGroundUnits[i]) != 'hspt' then
                    call SetUnitScale(BackGroundUnits[i], 4, 4, 4)
                endif
                call SetUnitVertexColorBJ( BackGroundUnits[i], 0.00, 0.00, 0.00, 100 )
                if Player(i-1) == GetLocalPlayer() then
                    call SetUnitVertexColorBJ( BackGroundUnits[i], 100.00, 100.00, 100.00, 0 )
                endif
            endif
        set i = i + 1
        endloop
    endfunction

    private function SetBackgroundAndMusic takes integer world, integer stage returns nothing
        call StopSound( BackgroundMusic, false, true )
        if world == 1 or (world == 8 and stage == 1) then
            set BackgroundMusic = gg_snd_Green_Greens
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('hfoo')
        elseif world == 2 or (world == 8 and stage == 2) then
            set BackgroundMusic = gg_snd_William_tell_Overture_Remix
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('hkni')
        elseif world == 3 or (world == 8 and stage == 3) then
            set BackgroundMusic = gg_snd_CaptainJack
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('hmtm')
        elseif world == 4 or (world == 8 and stage == 4) then
            set BackgroundMusic = gg_snd_Virtual_Riot___Energy_Drink
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('hsor')
        elseif world == 5 or (world == 8 and stage == 5) then
            set BackgroundMusic = gg_snd_FREE_BGM_OMG_Hello_u
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('hspt')
        elseif world == 6 or (world == 8 and stage == 6) then
            set BackgroundMusic = gg_snd_Waterflame_Swirl
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('hdhw')
        elseif world == 7 or (world == 8 and stage == 7) then
            set BackgroundMusic = gg_snd_CokeTown001
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('ebal')
        elseif world == 9 or (world == 14 and stage == 3) then
            set BackgroundMusic = gg_snd_skylight_harbor
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('hgyr')
        elseif world == 10 or (world == 14 and stage == 1) then
            set BackgroundMusic = gg_snd_Ariant
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('h000')
        elseif world == 11 or (world == 14 and stage == 2) then
            set BackgroundMusic = gg_snd_EllinforestBGM
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('h001')
        elseif world == 12 or (world == 14 and stage == 4) then
            set BackgroundMusic = gg_snd_Waterflame___Red___Layerz_OST
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('h002')
        elseif world == 13 or (world == 14 and stage == 5) then
            set BackgroundMusic = gg_snd_EverybodyBounce
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('h00D')
        elseif world == 15 then
            set BackgroundMusic = gg_snd_LeafreBgm
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('h00P')
        elseif world == 16 then
            set BackgroundMusic = gg_snd_Vacation_Beach
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call BackGroundChange('h00W')
        endif
    endfunction

    struct StatusBorad
        multiboard Borad
        integer World
        integer Level
        integer Continues
        integer Portal
        boolean Leave
        
        method SetContinues takes integer Continues returns nothing
            set this.Continues = Continues
            call MultiboardSetItemValueBJ( Borad, 2, 1, I2S(this.Continues) )
        endmethod
    
        method SetLevel takes integer World, integer Level returns nothing
            set this.World = World
            set this.Level = Level
            if this.Level > 8 then
                set this.World = this.World + 1
                set this.Level = 1
                if FinalStage == false then
                    call SetBackgroundAndMusic(this.World, this.Level)
                endif
            elseif this.World == 8 or RandomStage_isRandom or PracticeMode or this.World == 14 then
                call SetBackgroundAndMusic(this.World, this.Level)
            endif
            if this.World >= 3 then
                if FinalStage == true then
                    call MultiboardSetItemValueBJ( Borad, 2, 2, "최종 레벨")
                elseif RandomStage_isRandom == true then
                    call MultiboardSetItemValueBJ( Borad, 2, 2, "3-" + I2S(RandomStage_state))
                elseif this.World == 8 then
                    call MultiboardSetItemValueBJ( Borad, 2, 2, "W-" + I2S(this.Level))
                elseif this.World == 14 then
                    call MultiboardSetItemValueBJ( Borad, 2, 2, "W2-" + I2S(this.Level))
                else
                    call MultiboardSetItemValueBJ( Borad, 2, 2, "3-" + I2S(this.Level))
                endif
            else
                call MultiboardSetItemValueBJ( Borad, 2, 2, I2S(this.World) + "-" + I2S(this.Level))
            endif
        endmethod
    
        method SetEscapers takes integer Portal returns nothing
            local integer count = 0
            set this.Portal = Portal
            if FinalStage == true and Ending3 == false then
                set count = count - 1
            endif
            if Leave == true then
                call MultiboardSetItemValueBJ( Borad, 2, 3, I2S(this.Portal) + "/" + I2S(PersonPlayer()-1+count))
            else
                call MultiboardSetItemValueBJ( Borad, 2, 3, I2S(this.Portal) + "/" + I2S(PersonPlayer()+count))
            endif
            set Leave = false
        endmethod

        method SetPlayTime takes integer hour, integer min returns nothing
            call MultiboardSetItemValueBJ( Borad, 2, 4, I2S(hour) + "시간 " + I2S(min) + "분")
        endmethod
    endstruct
    
    globals
        StatusBorad Status
    endglobals
    
    public function CreateMenu takes nothing returns nothing
        set Status = StatusBorad.create()
        set Status.Borad = CreateMultiboardBJ( 2, 4, "메뉴(Menu)" )
        call MultiboardSetItemStyleBJ( Status.Borad, 0, 0, true, false )
        call MultiboardSetItemValueBJ( Status.Borad, 1, 1, "컨티뉴(Continues):" )
        call Status.SetContinues(20)
        call MultiboardSetItemValueBJ( Status.Borad, 1, 2, "레벨(Level):" )
        call Status.SetLevel(1,0)
        set BackgroundMusic = gg_snd_Green_Greens
        call MultiboardSetItemValueBJ( Status.Borad, 1, 3, "탈출인원(Escapers):" )
        call MultiboardSetItemValueBJ( Status.Borad, 1, 4, "플레이 타임:" )
        call MultiboardSetItemValueBJ( Status.Borad, 2, 4, "0시간 0분")
        call Status.SetEscapers(0)
        call MultiboardSetItemWidthBJ( Status.Borad, 1, 0, 8.00 )
        call MultiboardMinimizeBJ( false, Status.Borad )
    endfunction
endlibrary