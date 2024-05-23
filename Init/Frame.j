/*
0.02초의 프레임마다 동작하는 트리거.
*/

scope Frame initializer init
    globals
        public group SentinelMissile = CreateGroup()
        real array Acceleration
        public integer MainPlayer = 0
        public integer MainPlayerY = 0
        private integer array TrackState
        private trigger SentinelTrigger
        private real array OldX
        private real array OldY
        private real SpeedX
        private boolean BoxState = false
        private boolean array JumpState
        private boolean array GravityState
        private boolean array PropellyState // 헬기 좌우 따라가는거 이동하면 t 아니면 f
        private boolean AirCheckState = false
        private boolean array AccelerationCheck
        boolean PropellyCondition = false
    endglobals
    
    private function ConLeft takes integer i, real x, real y, real widthDist, real distance returns boolean
        local boolean b = false
        if FinalStage then
            set b = IsPointInRegion(Rect_Unlimited, x-widthDist+Acceleration[i], y) and IsPointInRegion(Rect_Unlimited, x-widthDist+Acceleration[i], y-distance) and IsPointInRegion(Rect_Unlimited, x-widthDist+Acceleration[i], y+distance)
        endif
        return b or (GetTerrainType(x-widthDist+Acceleration[i], y) == BACKGROUND_TILE and IsPointInRegion(Rect_NoEntry, x-widthDist+Acceleration[i], y) == false and (GetTerrainType(x-widthDist+Acceleration[i], y-distance) == BACKGROUND_TILE or GetTerrainType(x-widthDist+Acceleration[i], y+distance) == BACKGROUND_TILE))
    endfunction
    
    private function ConRight takes integer i, real x, real y, real widthDist, real distance returns boolean
        local boolean b = false
        if FinalStage then
            set b = IsPointInRegion(Rect_Unlimited, x+widthDist+Acceleration[i], y) and IsPointInRegion(Rect_Unlimited, x+widthDist+Acceleration[i], y-distance) and IsPointInRegion(Rect_Unlimited, x+widthDist+Acceleration[i], y+distance)
        endif
        return b or (GetTerrainType(x+widthDist+Acceleration[i], y) == BACKGROUND_TILE and IsPointInRegion(Rect_NoEntry, x+widthDist+Acceleration[i], y) == false and (GetTerrainType(x+widthDist+Acceleration[i], y-distance) == BACKGROUND_TILE or GetTerrainType(x+widthDist+Acceleration[i], y+distance) == BACKGROUND_TILE))
    endfunction
    
    private function MovingX takes integer i, real x, real y returns nothing
        local real saveG = gravity[i]
        local integer pushNum
        local boolean conleft
        local boolean conright
        local boolean conleftmoving = (LeftArrow[i] == true and Acceleration[i]-SpeedX <= 0) or WhetherCollision[i] == -1 or Acceleration[i] < 0
        local boolean conrightmoving = (RightArrow[i] == true and Acceleration[i]+SpeedX >= 0) or WhetherCollision[i] == 1 or Acceleration[i] > 0
        
        if saveG < -25 then
            set saveG = -25
        elseif saveG > 25 then
            set saveG = 25
        endif
        
        //오른쪽키를 누르고 있는데 가속도 음수이며 현재 속도보가 느리다
        if Acceleration[i] < 0 and (Acceleration[i]+SpeedX > 0 and LeftArrow[i] == false and RightArrow[i] == true) then
            set conleft = ConRight(i, x, y, 48, gravity[i])
            set conright = ConRight(i, x, y, 48, gravity[i])
        elseif Acceleration[i] > 0 and (Acceleration[i]-SpeedX < 0 and LeftArrow[i] == true) then
            set conleft = ConLeft(i, x, y, 48, gravity[i])
            set conright = ConLeft(i, x, y, 48, gravity[i])
        else
            set conleft = ConLeft(i, x, y, 48, gravity[i])
            set conright = ConRight(i, x, y, 48, gravity[i])
        endif
        if conleftmoving and (conleft or (i > PLAYER_MAXINUM and GetUnitTypeId(OrangeMushroom[i]) == 'orai')) then
            set pushNum = MushroomMoving_Collision(i, x-64+Acceleration[i], y)
            //좌측에 붙어있는 플레이어 번호를 추출
            if GetUnitTypeId(OrangeMushroom[i]) != 'orai' and GetUnitTypeId(OrangeMushroom[pushNum]) != 'orai' then
            if (WhetherCollision[i] == -1 and RightArrow[i] == true) or MushroomMoving_RectCondition(i, x, y, saveG, "LeftHeightOM2") == false then
                // 좌측으로 밀리는 도중에 오른쪽 키를 누르는 경우
                set SpeedX = 0
            elseif pushNum != 0 then
                // 좌측에 플레이어가 존재할 시
                if Acceleration[i] != 0 then
                    if Acceleration[pushNum] > 0 then
                        set Acceleration[pushNum] = -(Acceleration[pushNum]/2)
                        set Acceleration[i] = -(Acceleration[i]/2)
                    else
                        set Acceleration[pushNum] = Acceleration[i]
                        set Acceleration[i] = 0
                    endif
                    set AccelerationCheck[pushNum] = true
                endif
                set SpeedX = SpeedX / 2
                call MovingX(pushNum, GetUnitX(OrangeMushroom[pushNum]), GetUnitY(OrangeMushroom[pushNum]))
            endif
            endif
            
            if LeftArrow[i] == false and RightArrow[i] == true and Acceleration[i] != 0 then
                set x = x+SpeedX+Acceleration[i]
            else
                set x = x-SpeedX+Acceleration[i]
            endif
        elseif conleftmoving and conleft == false and GetUnitTypeId(OrangeMushroom[i]) == 'otau' then
            //분홍문어블럭 우회전
            set LeftArrow[i] = false
            set RightArrow[i] = true
            set Direction[i] = "Right"
        elseif conrightmoving and (conright or (i > PLAYER_MAXINUM and GetUnitTypeId(OrangeMushroom[i]) == 'orai')) then
            set pushNum = MushroomMoving_Collision(i, x+64+Acceleration[i], y)
            //우측에 붙어있는 플레이어 번호를 추출
            if GetUnitTypeId(OrangeMushroom[i]) != 'orai' and GetUnitTypeId(OrangeMushroom[pushNum]) != 'orai' then
            if (WhetherCollision[i] == 1 and LeftArrow[i] == true) or MushroomMoving_RectCondition(i, x, y, saveG, "RightHeightOM2") == false then
                set SpeedX = 0
            elseif pushNum != 0 then
                // 우측에 플레이어가 존재할 시
                if Acceleration[i] != 0 then
                    if Acceleration[pushNum] < 0 then
                        set Acceleration[pushNum] = -(Acceleration[pushNum]/2)
                        set Acceleration[i] = -(Acceleration[i]/2)
                    else
                        set Acceleration[pushNum] = Acceleration[i]
                        set Acceleration[i] = 0
                    endif
                    set AccelerationCheck[pushNum] = true
                endif
                set SpeedX = SpeedX / 2
                call MovingX(pushNum, GetUnitX(OrangeMushroom[pushNum]), GetUnitY(OrangeMushroom[pushNum]))
            endif
            endif
            if LeftArrow[i] == true and RightArrow[i] == false and Acceleration[i] != 0 then
                set x = x-SpeedX+Acceleration[i]
            else
                set x = x+SpeedX+Acceleration[i]
            endif
        elseif conrightmoving and conright == false and GetUnitTypeId(OrangeMushroom[i]) == 'otau' then
            //분홍문어블럭 좌회전
            set LeftArrow[i] = true
            set RightArrow[i] = false
            set Direction[i] = "Left"
        else
            set SpeedX = 0
        endif
        set WhetherCollision[i] = 0
        call SetUnitX(OrangeMushroom[i], x)
        call SetUnitY(OrangeMushroom[i], y)
    endfunction
    
    private function SetJumpState takes nothing returns nothing
        local integer i = 1
        
        loop
        exitwhen i > PLAYER_MAXINUM+Stage_BoxsCount
            if JumpState[i] == true then
                set JumpState[i] = false
            endif
        set i = i + 1
        endloop
    endfunction
    
    private function TrackTileCheck takes real x, real y returns string
        local real distance = 40
        local real distance2 = -40
        local integer leftScore = 0
        local integer rightScore = 0
        
        if GravityChanger_State == true then
            set distance2 = 40
        endif
        if GetTerrainType(x, y+distance2) == TRACKS_LEFT_TILE then
            set leftScore = leftScore + 1
        elseif GetTerrainType(x, y+distance2) == TRACKS_RIGHT_TILE then
            set rightScore = rightScore + 1
        endif
        
        if GetTerrainType(x-distance, y+distance2) == TRACKS_LEFT_TILE then
            set leftScore = leftScore + 1
        elseif GetTerrainType(x-distance, y+distance2) == TRACKS_RIGHT_TILE then
            set rightScore = rightScore + 1
        endif
        
        if GetTerrainType(x+distance, y+distance2) == TRACKS_LEFT_TILE then
            set leftScore = leftScore + 1
        elseif GetTerrainType(x+distance, y+distance2) == TRACKS_RIGHT_TILE then
            set rightScore = rightScore + 1
        endif
        
        if leftScore > rightScore then
            return "Left"
        elseif leftScore < rightScore then
            return "Right"
        else
            return "Normal"
        endif
    endfunction
    
    // i가 맨 아래 (i > j > k)
    private function UnitJump takes integer i, integer j returns nothing
        local integer k = 1
        
        loop
        exitwhen k > PLAYER_MAXINUM+Stage_BoxsCount
            if MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), 40, "DownWidthJump") == true and (GetUnitTypeId(OrangeMushroom[k]) == 'orai' and k > PLAYER_MAXINUM) and SteppedPlayer[k] == j and gravity[k] < 0 then
                set gravity[i] = 0
            elseif (GetPlayerSlotState(Player(k-1)) == PLAYER_SLOT_STATE_PLAYING or k > PLAYER_MAXINUM) and j != k and SteppedPlayer[k] == j and (MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), 40, "DownWidthJump") or gravity[i] > 0) then
                call UnitJump(i, k)
                
                //헬기가 밑으로 갈때 상자 또는 유닛을 뚫는 오류를 없애기 위한 조건문
                set PropellyCondition = true
                if GravityChanger_State == false then
                    if GravityState[k] == false and not(MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k])+gravity[k], 40, "DownWidthOM") == false and GetUnitTypeId(OrangeMushroom[j]) == 'orai') then
                        call SetUnitY(OrangeMushroom[k], GetUnitY(OrangeMushroom[k]) + gravity[i])
                        set GravityState[k] = true
                    endif
                else
                    if GravityState[k] == false and not(MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k])-gravity[k], 40, "DownWidthOM") == false and GetUnitTypeId(OrangeMushroom[j]) == 'orai') then
                        call SetUnitY(OrangeMushroom[k], GetUnitY(OrangeMushroom[k]) - gravity[i])
                        set GravityState[k] = true
                    endif
                endif
                set PropellyCondition = false
                if GravityChanger_State == false then
                    if GetUnitY(OrangeMushroom[k]) - GetUnitY(OrangeMushroom[j]) < 50 then
                        call SetUnitY(OrangeMushroom[k], GetUnitY(OrangeMushroom[k]) + 32)
                        set JumpState[k] = true
                    endif
                else
                    if GetUnitY(OrangeMushroom[j]) - GetUnitY(OrangeMushroom[k]) < 50 then
                        call SetUnitY(OrangeMushroom[k], GetUnitY(OrangeMushroom[k]) - 32)
                        set JumpState[k] = true
                    endif
                endif
                set PropellyCondition = true
                if PropellyState[k] == false and GetUnitTypeId(OrangeMushroom[i]) == 'orai' then
                if i > PLAYER_MAXINUM then
                    if LeftArrow[i] == true and MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), gravity[k], "LeftHeight") and MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), gravity[k], "LeftHeightOM") then
                        call SetUnitX(OrangeMushroom[k], GetUnitX(OrangeMushroom[k])-8)
                        set PropellyState[k] = true
                    elseif RightArrow[i] == true and MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), gravity[k], "RightHeight") and MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), gravity[k], "RightHeightOM") then
                        call SetUnitX(OrangeMushroom[k], GetUnitX(OrangeMushroom[k])+8)
                        set PropellyState[k] = true
                    endif
                else
                    if LeftArrow[i] == true and MushroomMoving_RectCondition(i, GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i]), gravity[i], "LeftHeight") and MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), gravity[k], "LeftHeight") and MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), gravity[k], "LeftHeightOM") then
                        call SetUnitX(OrangeMushroom[k], GetUnitX(OrangeMushroom[k])-8)
                        set PropellyState[k] = true
                    elseif RightArrow[i] == true and MushroomMoving_RectCondition(i, GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i]), gravity[i], "RightHeight") and MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), gravity[k], "RightHeight") and MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), gravity[k], "RightHeightOM") then
                        call SetUnitX(OrangeMushroom[k], GetUnitX(OrangeMushroom[k])+8)
                        set PropellyState[k] = true
                    endif
                endif
                
                //코크버섯 점프(코크버섯이 공중에 떠있을때)
                elseif GetUnitTypeId(OrangeMushroom[i]) == 'ocat' and gravity[k] <= 0 and GetUnitTypeId(OrangeMushroom[k]) != 'orai' and GetUnitTypeId(OrangeMushroom[k]) != 'o001' then
                    if Player(k-1) == GetLocalPlayer() then
                        call StartSound( gg_snd_CokeJump001 )
                    endif
                    //set SteppedPlayer[k] = 0
                    if GravityChanger_State == false then
                        call DestroyEffect(AddSpecialEffect("war3mapImported\\JumperEffect.mdl", GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k])-80 ))
                    else
                        call DestroyEffect(AddSpecialEffect("war3mapImported\\JumperEffect.mdl", GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k])+80 ))
                    endif
                    set gravity[k] = 35.00
                endif
                set PropellyCondition = false
            elseif MushroomMoving_RectCondition(k, GetUnitX(OrangeMushroom[k]), GetUnitY(OrangeMushroom[k]), 40, "DownWidthJump") == false and gravity[i] < 0 then
                set SteppedPlayer[k] = 0
            endif
        set k = k + 1
        endloop
        
        // 천장 충돌
        if gravity[i] > 0 and MushroomMoving_RectCondition(j, GetUnitX(OrangeMushroom[j]), GetUnitY(OrangeMushroom[j]), 40,"UpWidth") == false then
            if GetUnitTypeId(OrangeMushroom[i]) != 'orai' or i <= PLAYER_MAXINUM then
                set gravity[i] = 0
            endif
        endif
        if i == j and gravity[i] > 0 and JumpState[k] == false then
            if GravityChanger_State == false then
                call SetUnitY(OrangeMushroom[j], GetUnitY(OrangeMushroom[j]) + gravity[i])
                if GetUnitY(OrangeMushroom[i]) - GetUnitY(OrangeMushroom[j]) < 50 then
                    call SetUnitY(OrangeMushroom[j], GetUnitY(OrangeMushroom[j]) + 32)
                endif
            else
                call SetUnitY(OrangeMushroom[j], GetUnitY(OrangeMushroom[j]) - gravity[i])
                if GetUnitY(OrangeMushroom[j]) - GetUnitY(OrangeMushroom[i]) < 50 then
                    call SetUnitY(OrangeMushroom[j], GetUnitY(OrangeMushroom[j]) - 32)
                endif
            endif
        endif
    endfunction
    
    private function AirCheck takes integer i, real x, real y returns boolean
        local boolean b
        set MainPlayerY = 0
        set b = MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false
        if MainPlayerY == 0 then
            set AirCheckState = false
            return false
        endif
        loop
        exitwhen SteppedPlayer[MainPlayerY] == 0
            set MainPlayerY = SteppedPlayer[MainPlayerY]
        endloop
        if gravity[MainPlayerY] > 27.00 then
            set AirCheckState = true
        else
            set AirCheckState = false
        endif
        return b and gravity[MainPlayerY] > 27.00 and gravity[i] > 0.00
    endfunction
    
    private function TrackCon takes integer i, real x, real y, string s, integer mP returns boolean
        local real mPx
        local real mPy
        local boolean b = (MushroomMoving_RectCondition(i, x, y, gravity[i], s + "Height") and MushroomMoving_RectCondition(i, x, y, gravity[i], s + "HeightOM"))

        if mP != 0 then
            set mPx = GetUnitX(OrangeMushroom[mP])
            set mPy = GetUnitY(OrangeMushroom[mP])
        endif
        if s == "Left" then
            if mP != 0 then
                set b = b and MushroomMoving_RectCondition(mP, mPx, mPy, gravity[mP], s + "Height") and MushroomMoving_RectCondition(mP, mPx, mPy, gravity[mP], s + "HeightOM")
                return b and TrackState[mP] == 1 and RightArrow[mP] == false
            else
                return b and TrackTileCheck(x, y) == s
            endif
        else
            if mP != 0 then
                set b = b and MushroomMoving_RectCondition(mP, mPx, mPy, gravity[mP], s + "Height") and MushroomMoving_RectCondition(mP, mPx, mPy, gravity[mP], s + "HeightOM")
                return b and TrackState[mP] == 2 and LeftArrow[mP] == false
            else
                return b and TrackTileCheck(x, y) == s
            endif
        endif
    endfunction
    
    private function MushmomJumpEffect takes integer i returns nothing
        if (OrangeMushroomType[i] == 'nanw' or OrangeMushroomType[i] == 'n007' or OrangeMushroomType[i] == 'n008') and MorphState[i] == false and gravity[i] < -15 then
            if GravityChanger_State == false then
                call DestroyEffect(AddSpecialEffect("war3mapImported\\MushmomEffectDown.mdl", GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i])-32 ))
            else
                call DestroyEffect(AddSpecialEffect("war3mapImported\\MushmomEffectUp.mdl", GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i])+32 ))
            endif
            if Player(i-1) == GetLocalPlayer() then
                call StopSound( gg_snd_MushmomJump002, false, false )
                call StartSound( gg_snd_MushmomJump002 )
            endif
        endif
    endfunction

    private function CanUseRail takes nothing returns boolean
        local boolean b = Status.World == 5 or (Status.World == 8 and Status.Level == 5) or FinalStage == true
        set b = b or (Status.World == 10 and (Status.Level == 4 or Status.Level == 6 or Status.Level == 7))
        set b = b or (Status.World == 13 and (Status.Level == 4))
        set b = b or (Status.World == 14 and (Status.Level == 1 or Status.Level == 4))
        set b = b or (Status.World == 16 and (Status.Level == 4))
        return b
    endfunction
                    
    private function MovingY takes integer i, real x, real y returns nothing
        local integer SaveMainPlayerY
        local boolean b = false
        local Decorate_PetSkin pet = Decorate_GetPetSkin(i - 1)

        if GetUnitTypeId(OrangeMushroom[i]) == 'orai' or GetUnitTypeId(OrangeMushroom[i]) == 'o001' then
            if i > PLAYER_MAXINUM then
                set b = true
            else
                set b = ((gravity[i] <= 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth")) or (gravity[i] > 0 and MushroomMoving_RectCondition(i, x, y, 40,"UpWidth")))
            endif
        else
            set b = (not(AirCheck(i, x, y)) and ((gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth")) or (gravity[i] > 0 and MushroomMoving_RectCondition(i, x, y, 40,"UpWidth"))))
        endif
        if b == true then
            set TrackState[i] = 0
            if MushroomMoving_RectCondition(i, x, y, 40, "DownWidthOM") == true then
                set SteppedPlayer[i] = 0
            endif
            if GravityChanger_State == false then
                if MushroomMoving_RectCondition(i, x, y+gravity[i], 40, "UpWidthOM") == false and GetUnitTypeId(OrangeMushroom[MainPlayerY]) != 'orai' then
                    set SteppedPlayer[MainPlayerY] = i
                    if GetUnitTypeId(OrangeMushroom[MainPlayerY]) == 'o001' and gravity[SteppedPlayer[MainPlayerY]] <= 0 then
                        set SteppedPlayer[MainPlayerY] = 0
                    endif
                endif
            else
                if MushroomMoving_RectCondition(i, x, y-gravity[i], 40, "UpWidthOM") == false and GetUnitTypeId(OrangeMushroom[MainPlayerY]) != 'orai' then
                    set SteppedPlayer[MainPlayerY] = i
                    if GetUnitTypeId(OrangeMushroom[MainPlayerY]) == 'o001' and gravity[SteppedPlayer[MainPlayerY]] <= 0 then
                        set SteppedPlayer[MainPlayerY] = 0
                    endif
                endif
            endif
            call SetJumpState()
            //플레이어 비행기 위아래 방향키 누르고 있으면 중력을 고정시키는 트리거
            if GetUnitTypeId(OrangeMushroom[i]) == 'orai' and i <= PLAYER_MAXINUM then
                if DownArrow[i] == true then
                    set gravity[i] = -8
                elseif UpArrow[i] == true then
                    set gravity[i] = 8
                endif
            endif
            call UnitJump(i, i)
            if GravityChanger_State == false then
                set y = y+gravity[i]
            else
                set y = y-gravity[i]
            endif
            set Landing[i] = true
            if BoxState == false or GetUnitTypeId(OrangeMushroom[i]) == 'ogru' or GetUnitTypeId(OrangeMushroom[i]) == 'otau' or GetUnitTypeId(OrangeMushroom[i]) == 'ocat' or GetUnitTypeId(OrangeMushroom[i]) == 'o001' or GetUnitTypeId(OrangeMushroom[i]) == 'o000' or GetUnitTypeId(OrangeMushroom[i]) == 'h00S' or GetUnitTypeId(OrangeMushroom[i]) == 'h00T' then
                if GetUnitTypeId(OrangeMushroom[i]) == 'o001' then
                    if Direction[i] == "Left" then
                        if GravityChanger_State == false then
                            call SetUnitMoveAnimation( OrangeMushroom[i], "Walk First" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Walk First" )
                            endif
                        else
                            call SetUnitMoveAnimation( OrangeMushroom[i], "Walk Second" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Walk Second" )
                            endif
                        endif
                    elseif Direction[i] == "Right" then
                        if GravityChanger_State == false then
                            call SetUnitMoveAnimation( OrangeMushroom[i], "Walk Second" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Walk Second" )
                            endif
                        else
                            call SetUnitMoveAnimation( OrangeMushroom[i], "Walk First" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Walk First" )
                            endif
                        endif
                    endif
                else
                    if Direction[i] == "Left" then
                        if GravityChanger_State == false then
                            call SetUnitAnimation( OrangeMushroom[i], "Spell First" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Spell First" )
                            endif
                        else
                            call SetUnitAnimation( OrangeMushroom[i], "Spell Second" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Spell Second" )
                            endif
                        endif
                    elseif Direction[i] == "Right" then
                        if GravityChanger_State == false then
                            call SetUnitAnimation( OrangeMushroom[i], "Spell Second" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Spell Second" )
                            endif
                        else
                            call SetUnitAnimation( OrangeMushroom[i], "Spell First" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Spell First" )
                            endif
                        endif
                    endif
                endif
                call SpecialDownStateEnd(i)
            endif
        else
            // 트랙. 최적화를 위해 등장하는 5라운드를 제외하고 작동 불가.
            // FinalStage는 보너스 스테이지를 말하며, 이 스테이지에선 월드6으로 인식하기에 조건문이 존재함
            if CanUseRail() == true then
                set SaveMainPlayerY = MainPlayerY
                if TrackCon(i, x, y, "Left", SaveMainPlayerY) then
                    set x = x - 8
                    set TrackState[i] = 1
                elseif TrackCon(i, x, y, "Right", SaveMainPlayerY) then
                    set x = x + 8
                    set TrackState[i] = 2
                else
                    set TrackState[i] = 0
                endif
            endif
            
            set MainPlayerY = 0
            if MushroomMoving_RectCondition(i, x, y, 40, "DownWidthOM") == false and MushroomMoving_RectCondition(i, x, y, 40,"UpWidth") then
                set SteppedPlayer[i] = MainPlayerY
                if GravityChanger_State == false then
                    if GetUnitY(OrangeMushroom[i]) - GetUnitY(OrangeMushroom[SteppedPlayer[i]]) < 80 then
                        set y = y + (80-(GetUnitY(OrangeMushroom[i])-GetUnitY(OrangeMushroom[SteppedPlayer[i]])))
                    endif
                else
                    if GetUnitY(OrangeMushroom[SteppedPlayer[i]]) - GetUnitY(OrangeMushroom[i]) < 80 then
                        set y = y - (80-(GetUnitY(OrangeMushroom[SteppedPlayer[i]])-GetUnitY(OrangeMushroom[i])))
                    endif
                endif
            endif
            
            if GravityChanger_State == false then
                if MushroomMoving_RectCondition(i, x, y+gravity[i], 40, "UpWidthOM") == false and GetUnitTypeId(OrangeMushroom[MainPlayerY]) != 'orai' then
                    set SteppedPlayer[MainPlayerY] = i
                endif
            else
                if MushroomMoving_RectCondition(i, x, y-gravity[i], 40, "UpWidthOM") == false and GetUnitTypeId(OrangeMushroom[MainPlayerY]) != 'orai' then
                    set SteppedPlayer[MainPlayerY] = i
                endif
            endif
            //코크버섯 점프(지상에 있을때)
            if GetUnitTypeId(OrangeMushroom[i]) == 'ocat' and SteppedPlayer[MainPlayerY] == i and gravity[MainPlayerY] <= 0 and GetUnitTypeId(OrangeMushroom[MainPlayerY]) != 'orai' and GetUnitTypeId(OrangeMushroom[MainPlayerY]) != 'o001' then
                if Player(MainPlayerY-1) == GetLocalPlayer() then
                    call StartSound( gg_snd_CokeJump001 )
                endif
                //set SteppedPlayer[MainPlayerY] = 0
                set gravity[MainPlayerY] = 35.00
                if GravityChanger_State == false then
                    call DestroyEffect(AddSpecialEffect("war3mapImported\\JumperEffect.mdl", GetUnitX(OrangeMushroom[MainPlayerY]), GetUnitY(OrangeMushroom[MainPlayerY])-80 ))
                else
                    call DestroyEffect(AddSpecialEffect("war3mapImported\\JumperEffect.mdl", GetUnitX(OrangeMushroom[MainPlayerY]), GetUnitY(OrangeMushroom[MainPlayerY])+80 ))
                endif
            elseif GetUnitTypeId(OrangeMushroom[MainPlayerY]) == 'ocat' and SteppedPlayer[i] == MainPlayerY and gravity[i] <= 0 and GetUnitTypeId(OrangeMushroom[i]) != 'orai' and GetUnitTypeId(OrangeMushroom[i]) != 'o001' then
                if Player(i-1) == GetLocalPlayer() then
                    call StartSound( gg_snd_CokeJump001 )
                endif
                //set SteppedPlayer[i] = 0
                set gravity[i] = 35.00
                if GravityChanger_State == false then
                    call DestroyEffect(AddSpecialEffect("war3mapImported\\JumperEffect.mdl", GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i])-80 ))
                else
                    call DestroyEffect(AddSpecialEffect("war3mapImported\\JumperEffect.mdl", GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i])+80 ))
                endif
                set AirCheckState = true
            endif
            if MushroomMoving_RectCondition(i, x, y, 40,"DownWidth") == false and (BoxState == false or GetUnitTypeId(OrangeMushroom[i]) == 'ogru' or GetUnitTypeId(OrangeMushroom[i]) == 'otau' or GetUnitTypeId(OrangeMushroom[i]) == 'ocat' or GetUnitTypeId(OrangeMushroom[i]) == 'o001' or GetUnitTypeId(OrangeMushroom[i]) == 'o000' or GetUnitTypeId(OrangeMushroom[i]) == 'h00S' or GetUnitTypeId(OrangeMushroom[i]) == 'h00T') and CinematicMode == false and GetUnitTypeId(OrangeMushroom[i]) != 'orai' then
                if LeftArrow[i] == true and MushroomMoving_RectCondition(i, x, y, gravity[i], "LeftHeight") then
                    call MushmomJumpEffect(i)
                    if GravityChanger_State == false then
                        call SetUnitMoveAnimation(OrangeMushroom[i], "Walk First")
                        if pet != 0 then
                            call SetUnitAnimation( pet.Unit, "Walk First" )
                        endif
                    else
                        call SetUnitMoveAnimation( OrangeMushroom[i], "Walk Second" )
                        if pet != 0 then
                            call SetUnitAnimation( pet.Unit, "Walk Second" )
                        endif
                    endif
                elseif RightArrow[i] == true and MushroomMoving_RectCondition(i, x, y, gravity[i], "RightHeight") then
                    call MushmomJumpEffect(i)
                    if GravityChanger_State == false then
                        call SetUnitMoveAnimation( OrangeMushroom[i], "Walk Second" )
                        if pet != 0 then
                            call SetUnitAnimation( pet.Unit, "Walk Second" )
                        endif
                    else
                        call SetUnitMoveAnimation( OrangeMushroom[i], "Walk First" )
                        if pet != 0 then
                            call SetUnitAnimation( pet.Unit, "Walk First" )
                        endif
                    endif
                elseif Direction[i] == "Left" and Landing[i] == true then
                    set Landing[i] = false
                    call MushmomJumpEffect(i)
                    if DownArrow[i] == false then
                        if GravityChanger_State == false then
                            call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Stand First" )
                            endif
                        else
                            call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Stand Second" )
                            endif
                        endif
                    else
                        if GravityChanger_State == false then
                            call SetUnitAnimation( OrangeMushroom[i], "Stand ready First" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Stand ready First" )
                            endif
                        else
                            call SetUnitAnimation( OrangeMushroom[i], "Stand ready Second" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Stand ready Second" )
                            endif
                        endif
                        call SpecialDownStateStart(i)
                    endif
                elseif Direction[i] == "Right" and Landing[i] == true then
                    set Landing[i] = false
                    call MushmomJumpEffect(i)
                    if DownArrow[i] == false then
                        if GravityChanger_State == false then
                            call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Stand Second" )
                            endif
                        else
                            call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Stand First" )
                            endif
                        endif
                    else
                        if GravityChanger_State == false then
                            call SetUnitAnimation( OrangeMushroom[i], "Stand ready Second" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Stand ready Second" )
                            endif
                        else
                            call SetUnitAnimation( OrangeMushroom[i], "Stand ready First" )
                            if pet != 0 then
                                call SetUnitAnimation( pet.Unit, "Stand ready First" )
                            endif
                        endif
                        call SpecialDownStateStart(i)
                    endif
                endif
            endif
            if (GetUnitTypeId(OrangeMushroom[i]) != 'orai' and AirCheckState == false) or (SteppedPlayer[i] != 0 and gravity[i] <= 0) then
                set gravity[i] = 0
            endif
        endif
        
        //땅에 박히면 가장 가까운 아래쪽의 공간으로 이동한다.
        loop
        exitwhen (GetTerrainType(x, y) == BACKGROUND_TILE and IsPointInRegion(Rect_NoEntry, x, y) == false) or GetUnitTypeId(OrangeMushroom[i]) == 'orai' or IsPointInRegion(Rect_Unlimited, x, y)
            if GravityChanger_State == false then
                set y = y - 8
            else
                set y = y + 8
            endif
        endloop
        
        call SetUnitX(OrangeMushroom[i], x)
        call SetUnitY(OrangeMushroom[i], y)
    endfunction
    
    private function SquaresMoving takes integer i returns nothing
        local real saveMaxG = -30
        local integer j = 1
        
        set SpeedX = 8
        set MainPlayer = i
        if LevelClearState[i] == false then
            call MovingX(i, GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i]))
            call MovingY(i, GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i]))
            
            if Status.World >= 6 then
                if IsUnitInRegion(Water_Rects, OrangeMushroom[i]) == true then
                    set saveMaxG = -10
                endif
            endif
            if GetUnitTypeId(OrangeMushroom[i]) != 'orai' then
                if GetUnitTypeId(OrangeMushroom[i]) == 'o001' then
                    if gravity[i] > 2 then
                        set gravity[i] = gravity[i] - 2.0
                    elseif gravity[i] < -2 then
                        set gravity[i] = gravity[i] + 2.0
                    else
                        set gravity[i] = 0
                    endif
                else
                    if Water_State[i] == true and DownArrow[i] == true then
                        set gravity[i] = -15
                    else
                        if gravity[i] > saveMaxG then
                            set gravity[i] = gravity[i] - 2.0
                        elseif gravity[i] < saveMaxG then
                            set gravity[i] = saveMaxG
                        endif
                    endif
                endif
            endif
            
            if GetUnitTypeId(OrangeMushroom[i]) != 'orai' then
                if AccelerationCheck[i] == false then
                    if Acceleration[i] != 0 then
                        if Acceleration[i] > 60 then
                            set Acceleration[i] = 60
                        elseif Acceleration[i] > 1 then
                            set Acceleration[i] = Acceleration[i] - 1
                        elseif Acceleration[i] < -60 then
                            set Acceleration[i] = -60
                        elseif Acceleration[i] < -1 then
                            set Acceleration[i] = Acceleration[i] + 1
                        else
                            set Acceleration[i] = 0
                        endif
                    endif
                else
                    set AccelerationCheck[i] = false
                endif
            endif
        endif
    endfunction
    
    private function ViewSetting takes integer i returns nothing
                    if CinematicMode == false then
                        if Observer_ViewNumber[i] == 0 then
                            if GravityChanger_State == false then
                                call SetCameraTargetControllerNoZForPlayer( Player(i-1), OrangeMushroom[i], 0, 128, false )
                            else
                                call SetCameraTargetControllerNoZForPlayer( Player(i-1), OrangeMushroom[i], 0, -128, false )
                            endif
                        else
                            if GravityChanger_State == false then
                                call SetCameraTargetControllerNoZForPlayer( Player(i-1), OrangeMushroom[Observer_ViewNumber[i]], 0, 128, false )
                            else
                                call SetCameraTargetControllerNoZForPlayer( Player(i-1), OrangeMushroom[Observer_ViewNumber[i]], 0, -128, false )
                            endif
                        endif
                    endif
    endfunction
    
    private function PlayersGroup takes nothing returns nothing
        local integer i = 1
        
        if GravityChanger_Loading == false then
        set BoxState = false
        loop
        exitwhen i > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                set OldX[i] = GetUnitX(OrangeMushroom[i])
                set OldY[i] = GetUnitY(OrangeMushroom[i])
            endif
        set i = i + 1
        endloop
        set i = 1
        loop
            exitwhen i > PLAYER_MAXINUM + Stage_BoxsCount
            if i <= PLAYER_MAXINUM then
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call ViewSetting(i)
                    call SquaresMoving(i)
                endif
            else
                set BoxState = true
                call SquaresMoving(i)
            endif
        set i = i + 1
        endloop
        
        
        // + 4는 관전자 숫자이다.
        //! runtextmacro for("set i = PLAYER_MAXINUM + 1", "i <= PLAYER_MAXINUM + 4")
            call ViewSetting(i)
        //! runtextmacro for_end("set i = i + 1")

        
        set BoxState = false
        set i = 1
        loop
        exitwhen i > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                if CinematicMode == false then
                    call BackGroundMove(i, OldX[i], OldY[i])
                endif
                set PropellyState[i] = false
                set GravityState[i] = false
                if NameTextTag[i] != null then
                    if GravityChanger_State == false then
                        call SetTextTagPos(NameTextTag[i], GetUnitX(OrangeMushroom[i])-50, GetUnitY(OrangeMushroom[i])-120, 0)
                    else
                        call SetTextTagPos(NameTextTag[i], GetUnitX(OrangeMushroom[i])+50, GetUnitY(OrangeMushroom[i])+120, 0)
                    endif
                endif
                call Jumper_Main(i)
                if Status.World == 6 and IsPointInRegion(Arrow_AllRects, GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i])) then
                    call Arrow_SecretAction(i)
                endif
            endif
            if Stage_BoxsCount != 0 and Stage_BoxsCount >= i then
                set PropellyState[PLAYER_MAXINUM+i] = false
                set GravityState[PLAYER_MAXINUM+i] = false
                call Jumper_Main(PLAYER_MAXINUM+i)
                if Status.World == 6 and IsPointInRegion(Arrow_AllRects, GetUnitX(OrangeMushroom[PLAYER_MAXINUM+i]), GetUnitY(OrangeMushroom[PLAYER_MAXINUM+i])) then
                    call Arrow_SecretAction(PLAYER_MAXINUM+i)
                endif
            endif
        set i = i + 1
        endloop
        endif
    endfunction
    
    private function SentinelMissileRange takes real x, real y returns boolean
        local integer i = 1
        local real otherx
        local real othery
        
        loop
        exitwhen i > PLAYER_MAXINUM+Stage_BoxsCount
            if (GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING or i > PLAYER_MAXINUM) and GetUnitTypeId(OrangeMushroom[i]) != 'orai' and GetUnitTypeId(OrangeMushroom[i]) != 'ohun' and LevelClearState[i] == false then
                set otherx = GetUnitX(OrangeMushroom[i])
                set othery = GetUnitY(OrangeMushroom[i])
                if ContainsCoords(otherx-64, othery-64, otherx+64, othery+64, x, y) == true then
                    if PropellyCondition == true then
                        if GetUnitTypeId(OrangeMushroom[i]) != 'orai' then
                            return false
                        endif
                    else
                        return false
                    endif
                endif
            endif
        set i = i + 1
        endloop
        return true
    endfunction
    
    public struct LaserBlockHistory
        static hashtable List = InitHashtable()
        static integer Count = 0

        public static method Add takes real x, real y returns nothing
            call SaveLocationHandle(List, 0, Count, Location(x, y))
            set Count = Count + 1
        endmethod

        public static method Clear takes nothing returns nothing
            local integer i = 0
            local location l 

            //! runtextmacro for("set i = 0", "i < Count")
                set l = LoadLocationHandle(List, 0, i)
                call RemoveLocation(l)
            //! runtextmacro for_end("set i = i + 1")

            set Count = 0
            set l = null
        endmethod
    endstruct

    private function SentinelMissileMove takes nothing returns nothing
        local integer i = 1
        local real x = GetUnitX(GetEnumUnit())
        local real y = GetUnitY(GetEnumUnit())
        
        if GetUnitUserData(GetEnumUnit()) == 0 then
            set x = x-16
        elseif GetUnitUserData(GetEnumUnit()) == 1 then
            set x = x+16
        elseif GetUnitUserData(GetEnumUnit()) == 2 then
            set y = y+16
        elseif GetUnitUserData(GetEnumUnit()) == 3 then
            set y = y-16
        endif
        if SentinelMissileRange(x, y) == false then
            call KillUnit(GetEnumUnit())
            call GroupRemoveUnit(SentinelMissile, GetEnumUnit())
        elseif (GetTerrainType(x, y) == BACKGROUND_TILE and IsPointInRegion(Rect_NoEntry, x, y) == false) or IsPointInRegion(Rect_MissileZone, x, y) then
            call SetUnitX(GetEnumUnit(), x)
            call SetUnitY(GetEnumUnit(), y)
            if FinalStage == true and BlackBoss != null then
                if DistanceBetween(x, y, GetUnitX(BlackBoss), GetUnitY(BlackBoss)) <= 386 then
                    call DestroyEffect(AddSpecialEffect("war3mapImported\\Orange1.mdx", GetUnitX(BlackBoss), GetUnitY(BlackBoss)+512 ))
                    call GroupRemoveUnit(SentinelMissile, GetEnumUnit())
                    call RemoveUnit(GetEnumUnit())
                    call StopSound(gg_snd_Damage001, false, false)
                    call StartSound( gg_snd_Damage001 )
                    if GetUnitState(BlackBoss, UNIT_STATE_LIFE) == 40 then
                        set BossAttackCount = 0
                    endif
                    if GetUnitState(BlackBoss, UNIT_STATE_LIFE)-1 <= 0 then
                        if  TrueEnding3_CaveEnding == true then
                            call TriggerExecute( TrueEnding4END_Trigger )
                        else
                            call TriggerExecute( TrueEnding3END_Trigger )
                        endif
                    else
                        call SetUnitLifeBJ( BlackBoss, GetUnitState(BlackBoss, UNIT_STATE_LIFE)-1 )
                    endif
                    call MultiboardSetItemValueBJ( Status.Borad, 2, 1, I2S(R2I(GetUnitState(BlackBoss, UNIT_STATE_LIFE))) + " / " + I2S(R2I(GetUnitState(BlackBoss, UNIT_STATE_MAX_LIFE))) )
                endif
            endif
        else
            call KillUnit(GetEnumUnit())
            call GroupRemoveUnit(SentinelMissile, GetEnumUnit())
            if GetTerrainType(x, y) == 'Xblm' then
                call SetTerrainType(x, y, BACKGROUND_TILE, -1, 1, 0)
                call LaserBlockHistory.Add(x, y)
            endif
        endif
    endfunction
    
    private function SentinelMain takes nothing returns nothing
        call ForGroup(SentinelMissile, function SentinelMissileMove)
    endfunction

    
    private function Main takes nothing returns nothing
        call PlayersGroup()
        call BossMoving()
        call Decorate_Movement()
        if GravityChanger_Loading == false then
            if GravityChanger_State == false then
                call SetCameraField(CAMERA_FIELD_ROTATION, 90.0, 0)
            else
                call SetCameraField(CAMERA_FIELD_ROTATION, 270.0, 0)
            endif
        endif
        call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 269.9, 0)
        if CinematicMode == false then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 0)
        endif
        if GravityChanger_Loading == false then
        if IsUnitGroupEmptyBJ(SentinelMissile) == false then
            call TriggerExecute( SentinelTrigger )
        endif
        endif
        if SubString("|", -1, 0) != "o" then
            call StopMusic(false)
        endif
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        
        call TriggerRegisterTimerEvent(t, 0.02, true)
        call TriggerAddAction( t, function Main )
        set SentinelTrigger = CreateTrigger(  )
        call TriggerAddAction( SentinelTrigger, function SentinelMain )
        
        set t = null
    endfunction
endscope
