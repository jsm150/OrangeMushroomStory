library BossMain initializer Init needs Observer
    globals
        integer BossAttackCount = 0
        real BossAttackAngle = 0
        boolean BossAttackAngleState = false
        group BossMissileGroup = CreateGroup()
        trigger BossMove = CreateTrigger()
    endglobals
    
    private function BossMissileMove takes nothing returns nothing
        local integer i = 1
        local real x = GetUnitX(GetEnumUnit())
        local real y = GetUnitY(GetEnumUnit())
        local real px
        local real py
        
        set x = DistanceX(x, GetUnitUserData(GetEnumUnit()), GetUnitFacing(GetEnumUnit()))
        set y = DistanceY(y, GetUnitUserData(GetEnumUnit()), GetUnitFacing(GetEnumUnit()))
        call SetUnitX(GetEnumUnit(), x)
        call SetUnitY(GetEnumUnit(), y)
        
        loop
        exitwhen i > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and LevelClearState[i] == false then
                set px = GetUnitX(OrangeMushroom[i])
                set py = GetUnitY(OrangeMushroom[i])
                if DistanceBetween(x, y, px, py) <= 80 then
                    call GroupRemoveUnit(BossMissileGroup, GetEnumUnit())
                    call RemoveUnit(GetEnumUnit())
                    call DestroyEffect(AddSpecialEffect("war3mapImported\\Purple99999.mdx", px, py+128 ))
                    call StopSound(gg_snd_MushroomDie, false, false)
                    call StartSound( gg_snd_MushroomDie )
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[i] + GetPlayerName(Player(i-1)) + "|r 님이 쓰러졌습니다!" )
                    call Observer_Start(i)
                endif
            endif
        set i = i + 1
        endloop
    endfunction
    
    private function CreateDagger takes real x, real y, real angle, real speed returns nothing
        local unit u = CreateUnit(Player(11), 'okod', x, y, angle )
        
        call GroupAddUnit(BossMissileGroup, u)
        call SetUnitUserData( u, R2I(speed) )
        
        set u = null
    endfunction
    
    function BossMoving takes nothing returns nothing
        local integer i = 1
        local real x
        local real y
        local real ran
        local real px
        local real py
        local real speed
        local real max
        
        if FinalStage == true and BlackBoss != null and CinematicMode == false and Stage_Loading == false and BossKill == false then
            set x = GetUnitX(BlackBoss)
            set y = GetUnitY(BlackBoss)
            if y > -30080 then
                call SetUnitUserData( BlackBoss, 0 )
            elseif y < -30976 then
                call SetUnitUserData( BlackBoss, 1 )
            endif
            set speed = (55-GetUnitState(BlackBoss, UNIT_STATE_LIFE))*0.5
            if BossAttackCount < 600 then
                if GetUnitState(BlackBoss, UNIT_STATE_LIFE) <= 10 then
                    set speed = 8
                endif
                if GetUnitUserData(BlackBoss) == 0 then
                    set y = y - speed
                else
                    set y = y + speed
                endif
            endif
            call SetUnitY(BlackBoss, y)
            
            //블랙과 충돌 시 사망
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and LevelClearState[i] == false then
                    set px = GetUnitX(OrangeMushroom[i])
                    set py = GetUnitY(OrangeMushroom[i])
                    if DistanceBetween(x, y, px, py) <= 386 then
                        call DestroyEffect(AddSpecialEffect("war3mapImported\\Purple99999.mdx", px, py+128 ))
                        call StopSound(gg_snd_MushroomDie, false, false)
                        call StartSound( gg_snd_MushroomDie )
                        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[i] + GetPlayerName(Player(i-1)) + "|r 님이 쓰러졌습니다!" )
                        call Observer_Start(i)
                    endif
                endif
            set i = i + 1
            endloop
            set max = GetUnitState(BlackBoss, UNIT_STATE_LIFE)+5
            if max <= 15 then
                set max = 5
            endif
            if GetUnitState(BlackBoss, UNIT_STATE_LIFE) > 40 then
                if BossAttackCount >= 50 then
                    call CreateDagger(x+GetRandomReal(-170,170), y+GetRandomReal(-170,170), GetRandomReal(-70,70), GetRandomInt(5, 15))
                    set BossAttackCount = 0
                endif
            elseif GetUnitState(BlackBoss, UNIT_STATE_LIFE) > 30 and BossAttackCount >= 10 then
                call CreateDagger(x, y, BossAttackAngle, 45-GetUnitState(BlackBoss, UNIT_STATE_LIFE))
                if BossAttackAngleState == false then
                    set BossAttackAngle = BossAttackAngle + 20
                else
                    set BossAttackAngle = BossAttackAngle - 20
                endif
                if BossAttackAngle < -70 then
                    set BossAttackAngleState = false
                elseif BossAttackAngle > 70 then
                    set BossAttackAngleState = true
                endif
                set BossAttackCount = 0
            elseif GetUnitState(BlackBoss, UNIT_STATE_LIFE) <= 30 and BossAttackCount < 600 then
                if GetUnitState(BlackBoss, UNIT_STATE_LIFE) > 20 then
                    if ModuloInteger(BossAttackCount, 25) == 0 then
                        call CreateDagger(x+GetRandomReal(-170,170), y+GetRandomReal(-170,170), GetRandomReal(-70,70), GetRandomInt(10, 20))
                    endif
                elseif GetUnitState(BlackBoss, UNIT_STATE_LIFE) > 10 then
                    if ModuloInteger(BossAttackCount, 50) == 0 then
                        set ran = GetRandomReal(-128, 128)
                        call CreateDagger(x, y+ran, 0, 15)
                        call CreateDagger(x, y+ran-512, 0, 15)
                        call CreateDagger(x, y+ran+512, 0, 15)
                        call CreateDagger(x+GetRandomReal(-170,170), y+GetRandomReal(-170,170), GetRandomReal(-70,70), GetRandomInt(5, 15))
                    endif
                elseif GetUnitState(BlackBoss, UNIT_STATE_LIFE) <= 10 then
                    if ModuloInteger(BossAttackCount, 5) == 0 then
                        call CreateDagger(x, y-386, 0, 10)
                        call CreateDagger(x, y+386, 0, 10)
                    endif
                    if ModuloInteger(BossAttackCount, 50) == 0 then
                        call CreateDagger(x+GetRandomReal(-170,170), y+GetRandomReal(-170,170), GetRandomReal(-70,70), GetRandomInt(5, 15))
                    endif
                endif
            endif
            
            
            //빔
            if BossAttackCount == 600 then
                set i = 0
                loop
                exitwhen i > 315
                    call CreateUnit(Player(11), 'nwgs', x, y, i )
                set i = i + 45
                endloop
                call StartSound(gg_snd_DeepDarkFantasy)
                call StartSound(gg_snd_BeamSound)
                call CinematicFilterGenericBJ( 2.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 100.00, 0.00, 0, 0, 0.00 )
            elseif BossAttackCount == 720 then
                call CreateUnit(Player(11), 'nnmg', 512, y, 0 )
            elseif BossAttackCount >= 735 and BossAttackCount <= 800 then
                call CameraSetSourceNoise(1000, 1000000)
                if ModuloInteger(BossAttackCount, 2) == 0 then
                    call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 10, 10.00, 10.00, 0.00, 10.00, 10, 10, 0.00 )
                else
                    call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 0.00, 0.00, 0, 0, 0.00 )
                endif
                set i = 1
                loop
                exitwhen i > PLAYER_MAXINUM
                    if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and LevelClearState[i] == false then
                        set py = GetUnitY(OrangeMushroom[i])
                        if y-192 <= py and y+192 >= py then
                            call DestroyEffect(AddSpecialEffect("war3mapImported\\Purple99999.mdx", px, py+128 ))
                            call StopSound(gg_snd_MushroomDie, false, false)
                            call StartSound( gg_snd_MushroomDie )
                            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[i] + GetPlayerName(Player(i-1)) + "|r 님이 쓰러졌습니다!" )
                            call Observer_Start(i)
                        endif
                    endif
                set i = i + 1
                endloop
            elseif BossAttackCount >= 800 then
                call CameraSetSourceNoise(0, 0)
                call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 100.00, 0.00, 0, 0, 100.00 )
                set BossAttackCount = 0
            endif
            set BossAttackCount = BossAttackCount + 1
            call ForGroup(BossMissileGroup, function BossMissileMove)
        endif
    endfunction
    
    private function RemoveDagger takes nothing returns nothing
        if GetUnitTypeId(GetTriggerUnit()) == 'okod' then
            call GroupRemoveUnit(BossMissileGroup, GetTriggerUnit())
            call RemoveUnit(GetTriggerUnit())
        endif
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        call TriggerRegisterLeaveRectSimple( t, gg_rct_BossZone )
        call TriggerAddAction( t, function RemoveDagger )
    endfunction
endlibrary