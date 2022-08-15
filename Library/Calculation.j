library Calculation
    function DistanceBetween takes real x1, real y1, real x2, real y2 returns real // [x1,y2] 와 [x2,y2] 의 거리
        local real dx = x2 - x1
        local real dy = y2 - y1
        return SquareRoot(dx * dx + dy * dy)
    endfunction
    
    function PlayersPlayMusic takes nothing returns nothing
        local integer i = GetPlayerId(GetEnumPlayer())+1
        
        if SoundState[i] == false and GetEnumPlayer() == GetLocalPlayer() then
            call StartSound( BackgroundMusic )
        endif
    endfunction
    
    function MushroomType takes integer types returns boolean // 플레이어 주황버섯 타입 체크
        local boolean b = types == 'hpea' or types == 'uaco' or types == 'ushd' or types == 'ugho' or types == 'uabo' or types == 'umtw' or types == 'ucry' or types == 'ugar'
        set b = b or types == 'uban' or types == 'unec' or types == 'uobs' or types == 'ufro' or types == 'earc' or types == 'esen' or types == 'edry'
        set b = b or types == 'nmyr' or types == 'nnrg' or types == 'nhyc' or types == 'nmpe' or types == 'nanm' or types == 'nanb' or types == 'nanc' or types == 'nanw'
        set b = b or types == 'n000' or types == 'h003' or types == 'n007' or types == 'o003' or types == 'o002' or types == 'n008'
        set b = b or types == 'ehpr' or types == 'echm' or types == 'edot' or types == 'edoc' or types == 'emtg'  or types == 'efdr'  or types == 'nnsw' 
        return b or types == 'h00F' or types == 'h00G'
    endfunction

    function AngleBetween takes real x1, real y1, real x2, real y2 returns real // [x1,y2] 와 [x2,y2] 의 각도
        return bj_RADTODEG * Atan2(y2-y1, x2-x1)
    endfunction

    function DistanceX takes real x, real distance, real angle returns real // MainX 위치에서 a각도에 m거리만큼 이동한 곳의 x값
        return x + distance * Cos(angle * bj_DEGTORAD)
    endfunction

    function DistanceY takes real y, real distance, real angle returns real // MainY 위치에서 a각도에 m거리만큼 이동한 곳의 y값
        return y + distance * Sin(angle * bj_DEGTORAD)
    endfunction
    
    function SetCameraBoundsXY takes real x, real y returns nothing
        call SetCameraBounds(x, y, x, y, x, y, x, y)
    endfunction
    
    function ContainsCoords takes real minx, real miny, real maxx, real maxy, real x, real y returns boolean
        return minx <= x and x <= maxx and miny <= y and y <= maxy
    endfunction
    
    function PersonPlayer takes nothing returns integer
        local integer i = 1
        local integer j = 0
        
        loop
        exitwhen i > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                set j = j + 1
            endif
        set i = i + 1
        endloop
        return j
    endfunction
    
    //배경화면 움직임
    function BackGroundMove takes integer i, real x, real y returns nothing
        local real now_x = GetUnitX(OrangeMushroom[i])
        local real now_y = GetUnitY(OrangeMushroom[i])
        
        set now_x = now_x - x
        set now_x = now_x*0.95
        
        set now_y = now_y - y
        set now_y = now_y*0.95
        if GameAllOver == false then
            set now_x = GetUnitX(BackGroundUnits[i]) + now_x
            set now_y = GetUnitY(BackGroundUnits[i]) + now_y
            if GetUnitX(OrangeMushroom[i])-386 > now_x then
                call SetUnitX(BackGroundUnits[i], GetUnitX(OrangeMushroom[i])-386)
            elseif GetUnitX(OrangeMushroom[i])+386 < now_x then
                call SetUnitX(BackGroundUnits[i], GetUnitX(OrangeMushroom[i])+386)
            else
                call SetUnitX(BackGroundUnits[i], now_x)
            endif
            if GetUnitY(OrangeMushroom[i])-200 > now_y then
                call SetUnitY(BackGroundUnits[i], GetUnitY(OrangeMushroom[i])-200)
            elseif GetUnitY(OrangeMushroom[i])+200 < now_y then
                call SetUnitY(BackGroundUnits[i], GetUnitY(OrangeMushroom[i])+200)
            else
                call SetUnitY(BackGroundUnits[i], now_y)
            endif
        else
            call SetUnitX(BackGroundUnits[i], GetUnitX(OrangeMushroom[i]))
            call SetUnitY(BackGroundUnits[i], GetUnitY(OrangeMushroom[i]))
        endif
    endfunction

    function BlinChange takes integer i, integer types returns nothing
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        
        set gravity[i] = 0.00
        call StopSound(gg_snd_Morph001, false, false)
        call StartSound( gg_snd_Morph001 )
        call DestroyEffect(AddSpecialEffect("war3mapImported\\Morph.mdl", x, y ))
                            
        call RemoveUnit(OrangeMushroom[i])
        if GravityChanger_State == false then
            set OrangeMushroom[i] = CreateUnit(Player(i-1), types, x, y, 270 )
        else
            set OrangeMushroom[i] = CreateUnit(Player(i-1), types, x, y, 90 )
        endif
            
        if Direction[i] == "Left" then
            if GravityChanger_State == false then
                call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
            else
                call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
            endif
        else
            if GravityChanger_State == false then
                call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
            else
                call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
            endif
        endif
        call SetUnitBlendTime(OrangeMushroom[i], 0.00)
        
        if GravityChanger_State == false then
            call SetCameraTargetControllerNoZForPlayer( Player(i-1), OrangeMushroom[i], 0, 128, false )
        else
            call SetCameraTargetControllerNoZForPlayer( Player(i-1), OrangeMushroom[i], 0, -128, false )
        endif
    endfunction
    
    function PlayerSentinelAttack takes nothing returns nothing
        local integer i = LoadInteger(Hash, GetHandleId(GetExpiredTimer()), 0)
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        local unit u
        
        if GetUnitTypeId(OrangeMushroom[i]) == 'ohun' then
            set u = CreateUnit(Player(11), 'hmtt', x, y, 270 )
             call GroupAddUnit(Frame_SentinelMissile, u)
            if Direction[i] == "Left" then
                call SetUnitUserData( u, 0 )
            else
                call SetUnitUserData( u, 1 )
            endif
        elseif GetUnitTypeId(OrangeMushroom[i]) == 'o003' or GetUnitTypeId(OrangeMushroom[i]) == 'o002' then
            call DestroyEffect(CastingBar[i])
            if Player(i-1) == GetLocalPlayer() then
                call StopSound(gg_snd_Morph001, false, false)
                call StartSound( gg_snd_Morph001 )
            endif
            call DestroyEffect(AddSpecialEffect("war3mapImported\\Morph.mdl", x, y ))
                            
            call RemoveUnit(OrangeMushroom[i])
            if GravityChanger_State == false then
                if GetUnitTypeId(OrangeMushroom[i]) == 'o003' then
                    set OrangeMushroom[i] = CreateUnit(Player(i-1), 'o002', x, y, 270 )
                    set OrangeMushroomType[i] = 'o002'
                else
                    set OrangeMushroom[i] = CreateUnit(Player(i-1), 'o003', x, y, 270 )
                endif
            else
                if GetUnitTypeId(OrangeMushroom[i]) == 'o003' then
                    set OrangeMushroom[i] = CreateUnit(Player(i-1), 'o002', x, y, 90 )
                else
                    set OrangeMushroom[i] = CreateUnit(Player(i-1), 'o003', x, y, 90 )
                endif
            endif
            set OrangeMushroomType[i] = GetUnitTypeId(OrangeMushroom[i])
                
            if Direction[i] == "Left" then
                if GravityChanger_State == false then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                else
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            else
                if GravityChanger_State == false then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                else
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            endif
            call SetUnitBlendTime(OrangeMushroom[i], 0.00)
            
            if GravityChanger_State == false then
                call SetCameraTargetControllerNoZForPlayer( Player(i-1), OrangeMushroom[i], 0, 128, false )
            else
                call SetCameraTargetControllerNoZForPlayer( Player(i-1), OrangeMushroom[i], 0, -128, false )
            endif
        endif
        
        set u = null
    endfunction
    
    function SetUnitMoveAnimation takes unit u, string aniName returns nothing
        local integer tp = GetUnitTypeId(u)
        if aniName == "Walk First" then
            if tp == 'uobs' then
                call SetUnitAnimationByIndex( u, 0 )
            elseif tp == 'ufro' or tp == 'earc' then
                call SetUnitAnimationByIndex( u, 6 )
            elseif tp == 'esen' or tp == 'edry' then
                call SetUnitAnimationByIndex( u, 4 )
            elseif tp == 'ohun' or tp == 'edot' then
                call SetUnitAnimationByIndex( u, 6 )
            elseif tp == 'orai' then
                call SetUnitAnimation( u, "Stand First" )
            else
                call SetUnitAnimationByIndex( u, 1 )
            endif
        elseif aniName == "Walk Second" then
            if tp == 'ogru' or tp == 'uabo' or tp == 'otau'  or tp == 'umtw' then
                call SetUnitAnimationByIndex( u, 4 )
            elseif tp == 'uobs' then
                call SetUnitAnimationByIndex( u, 1 )
            elseif tp == 'ufro' or tp == 'earc' then
                call SetUnitAnimationByIndex( u, 7 )
            elseif tp == 'ohun' or tp == 'edot' then
                call SetUnitAnimationByIndex( u, 7 )
            elseif tp == 'orai' then
                call SetUnitAnimation( u, "Stand Second" )
            else
                call SetUnitAnimationByIndex( u, 5 )
            endif
        endif
    endfunction
    
    globals
        private effect array MushmomEyeDummy
        effect array CastingBar

        private real FilterTime
        private real FilterRed0
        private real FilterGreen0
        private real Filterblue0
        private real Filtertrans0
        private real FilterRed1
        private real FilterGreen1
        private real Filterblue1
        private real Filtertrans1
    endglobals
    
    function MushmomEyeEffect takes integer i returns nothing
        if (OrangeMushroomType[i] == 'nanw' or OrangeMushroomType[i] == 'n007') and MorphState[i] == false then
            call DestroyEffect(MushmomEyeDummy[i])
            
            set MushmomEyeDummy[i] = AddSpecialEffectTarget("war3mapImported\\MushmomEye.mdl", OrangeMushroom[i], "origin")
            if Player(i-1) == GetLocalPlayer() then
                call StopSound( gg_snd_MushmomAttack, false, false )
                call StartSound( gg_snd_MushmomAttack )
            endif
        endif
    endfunction
    
    function RemoveMushmomEyeEffect takes integer i returns nothing
        if (OrangeMushroomType[i] == 'nanw' or OrangeMushroomType[i] == 'n007') and MorphState[i] == false and MushmomEyeDummy[i] != null then
            if Player(i-1) == GetLocalPlayer() then
                call StopSound( gg_snd_MushmomAttack, false, false )
            endif
            call DestroyEffect(MushmomEyeDummy[i])
            set MushmomEyeDummy[i] = null
        endif
    endfunction

    function MorphBar takes integer i returns nothing
        local string s = ".mdx"
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        
        if GetUnitTypeId(OrangeMushroom[i]) == 'o003' or GetUnitTypeId(OrangeMushroom[i]) == 'o002' then
            call DestroyEffect(CastingBar[i])
            
            if Direction[i] == "Left" then
                if Player(i-1) == GetLocalPlayer() then
                    set s = "war3mapImported\\[UI]SpellBar1.5.mdx"
                endif
            else
                if Player(i-1) == GetLocalPlayer() then
                    set s = "war3mapImported\\[UI]SpellBar1.5Right.mdx"
                endif
            endif
            set CastingBar[i] = AddSpecialEffectTarget(s, OrangeMushroom[i], "origin")
        endif
    endfunction
    
    function SpecialDownStateStart takes integer i returns nothing
        if LeftArrow[i] == false and RightArrow[i] == false then
        if (OrangeMushroomType[i] == 'nanw' or OrangeMushroomType[i] == 'n007') and MorphState[i] == false then
            call DestroyEffect(MushmomEyeDummy[i])
            
            set MushmomEyeDummy[i] = AddSpecialEffectTarget("war3mapImported\\MushmomEye.mdl", OrangeMushroom[i], "origin")
            if Player(i-1) == GetLocalPlayer() then
                call StopSound( gg_snd_MushmomAttack, false, false )
                call StartSound( gg_snd_MushmomAttack )
            endif
        elseif GetUnitTypeId(OrangeMushroom[i]) == 'ohun' then
            call TimerStart(PlayerSentinelTimer[i], 1.5, false, function PlayerSentinelAttack)
            if GetUnitTypeId(OrangeMushroom[i]) == 'ohun' and Player(i-1) == GetLocalPlayer() then
                call StopSound(gg_snd_SentinelEffect, false, false)
                call StartSound( gg_snd_SentinelEffect )
            endif
        elseif GetUnitTypeId(OrangeMushroom[i]) == 'o003' or GetUnitTypeId(OrangeMushroom[i]) == 'o002' then
            call TimerStart(PlayerSentinelTimer[i], 1.5, false, function PlayerSentinelAttack)
            call MorphBar(i)
        endif
        endif
    endfunction
    
    function SpecialDownStateEnd takes integer i returns nothing
        if (OrangeMushroomType[i] == 'nanw' or OrangeMushroomType[i] == 'n007') and MorphState[i] == false and MushmomEyeDummy[i] != null then
            if Player(i-1) == GetLocalPlayer() then
                call StopSound( gg_snd_MushmomAttack, false, false )
            endif
            call DestroyEffect(MushmomEyeDummy[i])
            set MushmomEyeDummy[i] = null
        elseif GetUnitTypeId(OrangeMushroom[i]) == 'ohun' or GetUnitTypeId(OrangeMushroom[i]) == 'o003' or GetUnitTypeId(OrangeMushroom[i]) == 'o002' then
            call PauseTimer(PlayerSentinelTimer[i])
            if GetUnitTypeId(OrangeMushroom[i]) == 'ohun' and Player(i-1) == GetLocalPlayer() then
                call StopSound(gg_snd_SentinelEffect, false, false)
            endif
            if GetUnitTypeId(OrangeMushroom[i]) == 'o003' or GetUnitTypeId(OrangeMushroom[i]) == 'o002' then
                call DestroyEffect(CastingBar[i])
                set CastingBar[i] = null
            endif
        endif
    endfunction
    
    private function SetFilterForce takes nothing returns nothing
        local integer i = GetPlayerId(GetEnumPlayer())+1
        
        if GetLocalPlayer() == Player(i-1) then
            call CinematicFilterGenericBJ( FilterTime, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", FilterRed0, FilterGreen0, Filterblue0, Filtertrans0, FilterRed1, FilterGreen1, Filterblue1, Filtertrans1 )
        endif
    endfunction
    
    function SetFilter takes real time, real red0, real green0, real blue0, real trans0, real red1, real green1, real blue1, real trans1 returns nothing 
        set FilterTime = time
        set FilterRed0 = red0
        set FilterGreen0 = green0
        set Filterblue0 = blue0
        set Filtertrans0 = trans0
        set FilterRed1 = red1
        set FilterGreen1 = green1
        set Filterblue1 = blue1
        set Filtertrans1 = trans1
        call ForForce( bj_FORCE_ALL_PLAYERS, function SetFilterForce )
    endfunction
endlibrary