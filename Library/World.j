library World initializer Init

    private function Trig_Subway_Actions takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        if MushroomType(GetUnitTypeId(GetTriggerUnit())) and HiddenCode[0] == false then
            if GetLocalPlayer() == GetOwningPlayer(GetTriggerUnit()) then
                call ClearTextMessages()
            endif
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff92e3de※ 방장(재시작 권한을 가진 사람)이 여기서 첫 번째 비밀 코드를 입력하면 이용하실 수 있습니다!|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff92e3de※ 첫 번째 비밀 코드는 기존 스테이지를 클리어하면 얻을 수 있습니다.|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff92e3de※ 예: \"-???\"|r")
        endif
    endfunction

    private function Trig_WitchTower_Actions takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        if MushroomType(GetUnitTypeId(GetTriggerUnit())) and HiddenCode[1] == false then
            if GetLocalPlayer() == GetOwningPlayer(GetTriggerUnit()) then
                call ClearTextMessages()
            endif
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffdfee59※ 방장(재시작 권한을 가진 사람)이 여기서 두 번째 비밀 코드를 입력하면 이용하실 수 있습니다!|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffdfee59※ 두 번째 비밀 코드는 지하철 루트를 클리어하면 얻을 수 있습니다.|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffdfee59※ 예: \"-???\"|r")
        endif
    endfunction

    private function Trig_Beach_Actions takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        if MushroomType(GetUnitTypeId(GetTriggerUnit())) and HiddenCode[2] == false then
            if GetLocalPlayer() == GetOwningPlayer(GetTriggerUnit()) then
                call ClearTextMessages()
            endif
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff24f3ff※ 방장(재시작 권한을 가진 사람)이 여기서 두 번째 비밀 코드를 입력하면 이용하실 수 있습니다!|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff24f3ff※ 두 번째 비밀 코드는 지하철 루트를 클리어하면 얻을 수 있습니다.|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff24f3ff※ 예: \"-???\"|r")
        endif
    endfunction

    private function Trig_oke_Actions takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        if MushroomType(GetUnitTypeId(GetTriggerUnit())) and HiddenCode[3] == false then
            if GetLocalPlayer() == GetOwningPlayer(GetTriggerUnit()) then
                call ClearTextMessages()
            endif
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffff5555※ 방장(재시작 권한을 가진 사람)이 여기서 두 번째 비밀 코드를 입력하면 이용하실 수 있습니다!|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffff5555※ 두 번째 비밀 코드는 지하철 루트를 클리어하면 얻을 수 있습니다.|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffff5555※ 예: \"-???\"|r")
        endif
    endfunction

    private function Trig_Cafe_Actions takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        if MushroomType(GetUnitTypeId(GetTriggerUnit())) and HiddenCode[5] == false then
            if GetLocalPlayer() == GetOwningPlayer(GetTriggerUnit()) then
                call ClearTextMessages()
            endif
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffff5555※ 방장(재시작 권한을 가진 사람)이 여기서 두 번째 비밀 코드를 입력하면 이용하실 수 있습니다!|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffff5555※ 두 번째 비밀 코드는 지하철 루트를 클리어하면 얻을 수 있습니다.|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffff5555※ 예: \"-???\"|r")
        endif
    endfunction

    private function Trig_Pyramid_Actions takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        if MushroomType(GetUnitTypeId(GetTriggerUnit())) and HiddenCode[6] == false then
            if GetLocalPlayer() == GetOwningPlayer(GetTriggerUnit()) then
                call ClearTextMessages()
            endif
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffc3eb13※ 방장(재시작 권한을 가진 사람)이 여기서 두 번째 비밀 코드를 입력하면 이용하실 수 있습니다!|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffc3eb13※ 두 번째 비밀 코드는 지하철 루트를 클리어하면 얻을 수 있습니다.|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cffc3eb13※ 예: \"-???\"|r")
        endif
    endfunction

    private function Trig_Cave_Actions takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        if MushroomType(GetUnitTypeId(GetTriggerUnit())) and HiddenCode[8] == false then
            if GetLocalPlayer() == GetOwningPlayer(GetTriggerUnit()) then
                call ClearTextMessages()
            endif
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff325de9※ 암호를 입력하세요!|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff325de9※ 암호는 방장(재시작 권한을 가진 사람)만 입력할 수 있습니다.|r")
        endif
    endfunction

    private function Trig_Random_Actions takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        if MushroomType(GetUnitTypeId(GetTriggerUnit())) and HiddenCode[11] == false then
            if GetLocalPlayer() == GetOwningPlayer(GetTriggerUnit()) then
                call ClearTextMessages()
            endif
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff325de9※ 방장(재시작 권한을 가진 사람)이 여기서 두 번째 비밀 코드를 입력하면 이용하실 수 있습니다!|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff325de9※ 두 번째 비밀 코드는 지하철 루트를 클리어하면 얻을 수 있습니다.|r")
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "|cff325de9※ 예: \"-???\"|r")
        endif
    endfunction

    

    private function Init takes nothing returns nothing
        local trigger array t
        local integer i = 0
        local integer count = 7

        loop
            exitwhen i > count
            set t[i] = CreateTrigger(  )
            set i = i + 1
        endloop

        call TriggerRegisterEnterRectSimple( t[0], gg_rct_Subway )
        call TriggerRegisterEnterRectSimple( t[1], gg_rct_WitchTower )
        call TriggerRegisterEnterRectSimple( t[2], gg_rct_Beach )
        call TriggerRegisterEnterRectSimple( t[3], gg_rct_Coke )
        call TriggerRegisterEnterRectSimple( t[4], gg_rct_Cafe )
        call TriggerRegisterEnterRectSimple( t[5], gg_rct_Pyramid )
        call TriggerRegisterEnterRectSimple( t[6], gg_rct_Cave )
        call TriggerRegisterEnterRectSimple( t[7], gg_rct_RandomPortal )

        call TriggerAddAction( t[0], function Trig_Subway_Actions )
        call TriggerAddAction( t[1], function Trig_WitchTower_Actions )
        call TriggerAddAction( t[2], function Trig_Beach_Actions )
        call TriggerAddAction( t[3], function Trig_oke_Actions )
        call TriggerAddAction( t[4], function Trig_Cafe_Actions )
        call TriggerAddAction( t[5], function Trig_Pyramid_Actions )
        call TriggerAddAction( t[6], function Trig_Cave_Actions )
        call TriggerAddAction( t[7], function Trig_Random_Actions )

        set i = 0
        loop
            exitwhen i > count
            set t[i] = null
            set i = i + 1
        endloop
    endfunction

endlibrary