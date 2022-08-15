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

    public struct Money extends Verification
        private integer money

        public method operator Data takes nothing returns integer
            return this.money
        endmethod

        public method operator Data= takes integer val returns nothing
            set this.money = val
        endmethod

        public method Plus takes integer money returns thistype
            call this.Restore()
            return thistype.create(this.money + money)
        endmethod

        public method Minus takes integer money returns thistype
            call this.Restore()
            return thistype.create(this.money - money)
        endmethod

        public method ToInt takes nothing returns integer
            call this.Restore()
            return this.money
        endmethod

        public method ToString takes nothing returns string
            local string s = JNStringReverse(I2S(this.ToInt()))
            local integer i = 0
            
            //! runtextmacro for("set i = 3", "i < JNStringLength(s)")
                set s = JNStringInsert(s, i, ",")
            //! runtextmacro for_end("set i = i + 4")
            return JNStringReverse(s)
        endmethod

        public static method create takes integer money returns thistype
            local thistype this = thistype.allocate(money)
            set this.money = money
            return this
        endmethod

        public static method CreateArgsString takes string money returns thistype
            return thistype.create(S2I(money))
        endmethod

        static if DEBUG_MODE then
        public static method onInit takes nothing returns nothing
            local thistype this = thistype.create(10)
            call JNWriteLog("  money: " + I2S(this.money))
            set this = this.Plus(20)
            call JNWriteLog("  money: " + I2S(this.money))
            set this.money = 60
            call JNWriteLog("  money: " + I2S(this.money))
            set this = this.Minus(25)
            call JNWriteLog("  money: " + I2S(this.money))
        endmethod
        endif
    endstruct

    private struct user
        static integer WorldCount = 10
        worldCount ClearList
        integer PinkBeanDesignation = 0
        integer BellaPet = 0
        Money GoldLeaf

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

        public method Deposit takes integer amount returns nothing
            local Money temp = this.GoldLeaf
            set this.GoldLeaf = temp.Plus(amount)
            call temp.destroy()
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
        public key ReconnectedEventKey 
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

    public function IncWorldClearCount takes string name, string world returns nothing
        call JNObjectCharacterSetInt(name, world, JNObjectCharacterGetInt(name, world) + 1)
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
    //! runtextmacro MakeFuncToDataLoadSync("BellaPet", "UserList[idx].BellaPet", "S2I", "string name, string itemName", "JNUseUserRoleItemInfo(mapId, secretKey, name, itemName)")
    //! runtextmacro MakeFuncToDataLoadSync("GoldLeaf", "UserList[idx].GoldLeaf", "Money.CreateArgsString", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")

    public function LoadUserData takes integer playerId returns nothing
        local string name = ""
        
        if GetPlayerSlotState(Player(playerId)) == PLAYER_SLOT_STATE_PLAYING then
            set name = StringCase(GetPlayerName(Player(playerId)), false)
            if GetLocalPlayer() == Player(playerId) then
                call JNObjectCharacterInit(mapId, name, secretKey, clearListName)
            endif
            call DataLoadSyncToCaptainJack(playerId, name, "CaptainJack")
            call DataLoadSyncToSubway(playerId, name, "Subway")
            call DataLoadSyncToValentine(playerId, name, "Valentine")
            call DataLoadSyncToBeach(playerId, name, "Beach")
            call DataLoadSyncToCoke(playerId, name, "Coke")
            call DataLoadSyncToWorldChallenge(playerId, name, "WorldChallenge")
            call DataLoadSyncToCafe(playerId, name, "Cafe")
            call DataLoadSyncToDesert(playerId, name, "Desert")
            call DataLoadSyncToForest(playerId, name, "Forest")
            call DataLoadSyncToIceCave(playerId, name, "IceCave")
            call DataLoadSyncToDownTown(playerId, name, "DownTown")
            call DataLoadSyncToRandom(playerId, name, "Random")
            call DataLoadSyncToPinkBeanDesignation(playerId, name, "PinkBean Designation")
            call DataLoadSyncToBellaPet(playerId, name, "Bella Pet")
            call DataLoadSyncToGoldLeaf(playerId, name, "GoldLeaf")
        endif
    endfunction

    private function LoadAllUserData takes nothing returns nothing
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            call LoadUserData(i)
        //! runtextmacro for_end("set i = i + 1")
    endfunction

    private function ReconnectingSync takes integer playerId returns nothing
        call LoadUserData(playerId)
        call TriggerSleepActionByTimer(1.5)
        if GetLocalPlayer() == Player(playerId) then
            if JNObjectCharacterServerConnectCheck() == false then
                call BJDebugMsg("|cffFFFC00※ 서버와의 연결에 실패했습니다.|r")
            else
                call BJDebugMsg("|cffFFFC00※ 서버와 연결했습니다!|r")
            endif
        endif
        call Events.Raise(ReconnectedEventKey, 0)
    endfunction
    
    //! runtextmacro MakeSyncAction("SyncReconnectingKey", "call ReconnectingSync(playerId)")

    public function Reconnecting takes integer playerId returns nothing
        if GetLocalPlayer() == Player(playerId) then
            if JNObjectCharacterServerConnectCheck() == false then
                call BJDebugMsg("|cffFFFC00※ 서버와의 연결을 시도합니다.|r")
                call DzSyncData(I2S(SyncReconnectingKey), "")
            else
                call BJDebugMsg("|cffFFFC00※ 이미 서버와 연결중입니다.|r")
            endif
        endif
    endfunction

    private function Init takes nothing returns nothing
        call JNUse()
        call CreateUserContainer()
        call LoadAllUserData()
    endfunction
endscope

//! textmacro MakeFuncToDataLoadSync takes keyword, variable, converter, args, action
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
        set $variable$ = $converter$(DzGetTriggerSyncData())
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