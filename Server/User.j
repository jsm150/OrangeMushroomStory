scope User initializer Init
    globals
        constant string secretKey = "3b1e2c80-db90-462a-9835-a0ddb80752b1"
        constant string mapId = "OM150"
        constant string clearListName = "ClearList"
    endglobals

    private struct worldCount
        integer CaptainJack = 0
        integer Subway = 0
        integer Valentine = 0
        integer Beach = 0
        integer Coke = 0
        integer WorldChallenge = 0
        integer Cafe = 0
        integer Desert = 0
        integer Forest = 0
        integer IceCave = 0
        integer DownTown = 0
        integer Random = 0
    endstruct

    private struct user
        static integer WorldCount = 10
        worldCount ClearList
        integer PinkBeanDesignation = 0

        public method GetClearCountByWorldId takes integer worldId returns integer
            if worldId >= 1 and worldId <= 2 then
                return 1
            elseif worldId == 3 then
                return this.ClearList.CaptainJack
            elseif worldId == 4 then
                return this.ClearList.Subway
            elseif worldId == 5 then
                return this.ClearList.Valentine
            elseif worldId == 6 then
                return this.ClearList.Beach
            elseif worldId == 7 then
                return this.ClearList.Coke
            elseif worldId == 8 then
                return this.ClearList.WorldChallenge
            elseif worldId == 9 then
                return this.ClearList.Cafe
            elseif worldId == 10 then
                return this.ClearList.Desert
            elseif worldId == 11 then
                return this.ClearList.Forest
            elseif worldId == 12 then
                return this.ClearList.IceCave
            elseif worldId == 13 then
                return this.ClearList.DownTown
            else
                return 0
            endif
        endmethod

        static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            set this.ClearList = worldCount.create()
            return this
        endmethod
    endstruct
    
    //! runtextmacro Make_Container("user", "7")
    
    globals
        public userContainer UserList
    endglobals

    public function PrintCode takes integer i returns nothing
        local boolean none = true

        if GetLocalPlayer() == Player(i) then
            call ClearTextMessages()
        endif
        if UserList[i].ClearList.CaptainJack > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　핑크: " + WorldKey_Code[i + 1])
        endif
        if UserList[i].ClearList.Subway > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　지하철: " + WorldKey_Code2[i + 1])
        endif
        if UserList[i].ClearList.Valentine > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　발렌: " + WorldKey_Code3[i + 1])
        endif
        if UserList[i].ClearList.Beach > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　해변: " + WorldKey_Code4[i + 1])
        endif
        if UserList[i].ClearList.Coke > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　코크: " + WorldKey_Code5[i + 1])
        endif
        if UserList[i].ClearList.WorldChallenge > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　월드: " + WorldKey_Code8[i + 1])
        endif
        if UserList[i].ClearList.Cafe > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　카페: " + WorldKey_Code6[i + 1])
        endif
        if UserList[i].ClearList.Desert > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　사막: " + WorldKey_Code7[i + 1])
        endif
        if UserList[i].ClearList.Forest > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　엘린숲: " + WorldKey_Code9[i + 1])
        endif
        if UserList[i].ClearList.IceCave > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　얼음 동굴: " + WorldKey_Code11[i + 1])
        endif
        if UserList[i].ClearList.DownTown > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　아랫 마을: " + WorldKey_Code12[i + 1])
        endif
        if UserList[i].ClearList.Random > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　랜덤: " + WorldKey_Code10[i + 1])
        endif
        if none then
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 20, "　　　　　　|cffFFFC00※ 클리어한 맵이 없습니다! ※|r")
        endif
    endfunction

    private function CreateUserContainer takes nothing returns nothing
        local integer i = 0

        set UserList = userContainer.create()

        loop
            exitwhen i >= UserList.Count
            set UserList[i] = user.create()
            set i = i + 1
        endloop
    endfunction

    //! runtextmacro MakeFuncToDataLoadSync("CaptainJack", "UserList[idx].ClearList.CaptainJack", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("Subway", "UserList[idx].ClearList.Subway", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("Valentine", "UserList[idx].ClearList.Valentine", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("Beach", "UserList[idx].ClearList.Beach", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("Coke", "UserList[idx].ClearList.Coke", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("WorldChallenge", "UserList[idx].ClearList.WorldChallenge", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("Cafe", "UserList[idx].ClearList.Cafe", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("Desert", "UserList[idx].ClearList.Desert", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("Forest", "UserList[idx].ClearList.Forest", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("IceCave", "UserList[idx].ClearList.IceCave", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("DownTown", "UserList[idx].ClearList.DownTown", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("Random", "UserList[idx].ClearList.Random", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("PinkBeanDesignation", "UserList[idx].PinkBeanDesignation", "S2I", "string name, string itemName", "JNUseUserRoleItemInfo(mapId, secretKey, name, itemName)")

    private function LoadUserData takes nothing returns nothing
        local integer i = 0
        local integer temp = 0
        local string name

        loop
            exitwhen i >= PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
                set name = StringCase(GetPlayerName(Player(i)), false)
                if GetLocalPlayer() == Player(i) then
                    call JNObjectCharacterInit(mapId, name, secretKey, clearListName)
                endif
                call DataLoadSyncToCaptainJack(i, name, "CaptainJack")
                call DataLoadSyncToSubway(i, name, "Subway")
                call DataLoadSyncToValentine(i, name, "Valentine")
                call DataLoadSyncToBeach(i, name, "Beach")
                call DataLoadSyncToCoke(i, name, "Coke")
                call DataLoadSyncToWorldChallenge(i, name, "WorldChallenge")
                call DataLoadSyncToCafe(i, name, "Cafe")
                call DataLoadSyncToDesert(i, name, "Desert")
                call DataLoadSyncToForest(i, name, "Forest")
                call DataLoadSyncToIceCave(i, name, "IceCave")
                call DataLoadSyncToDownTown(i, name, "DownTown")
                call DataLoadSyncToRandom(i, name, "Random")
                call DataLoadSyncToPinkBeanDesignation(i, name, "PinkBean Designation")
            endif
            set i = i + 1
        endloop
    endfunction
    

    private function Init takes nothing returns nothing
        call JNUse()
        call CreateUserContainer()
        call LoadUserData()
    endfunction
endscope

//! textmacro MakeFuncToDataLoadSync takes keyword, memory, converter, args, action
    globals
        private key $keyword$Key
    endglobals

    private function DataLoadSyncTo$keyword$ takes integer idx, $args$ returns nothing
        if GetLocalPlayer() == Player(idx) then
            call DzSyncData(I2S($keyword$Key), $action$)
        endif
    endfunction

    private function SyncDataTo$keyword$ takes nothing returns nothing
        local integer idx = GetPlayerId(DzGetTriggerSyncPlayer())
        set $memory$ = $converter$(DzGetTriggerSyncData())
    endfunction

    private struct MakeFuncToDataLoadSyncInit$keyword$
        private static method onInit takes nothing returns nothing
            local trigger t = CreateTrigger()
            call DzTriggerRegisterSyncData(t, I2S($keyword$Key), false)
            call TriggerAddAction(t, function SyncDataTo$keyword$)
            set t = null
        endmethod
    endstruct
//! endtextmacro