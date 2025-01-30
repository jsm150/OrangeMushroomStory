scope User initializer Init
    globals
        constant string secretKey = "3b1e2c80-db90-462a-9835-a0ddb80752b1"
        constant string mapId = "OM150"
        constant string clearListName = "ClearList"
        string mapVersion = "v12.6"
        public key GoldLeafChangedEvent

        private trigger DOWNLOAD_CALLBACK = CreateTrigger( )
        private trigger UPLOAD_CALLBACK = CreateTrigger( )
    endglobals

    function PrivateLogging takes integer playerId, string log, string logType returns nothing
        if GetLocalPlayer() == Player(playerId) then
            call JNMapServerLogUseType(mapId, secretKey, mapVersion, log, logType)
        endif
    endfunction

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
        integer WorldChallenge2 = 0
        integer Refre = 0
        integer Random = 0
        integer HardRandom = 0
    endstruct

    struct Money extends Verification
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
            call this.destroy()
        endmethod
        endif
    endstruct

    //! textmacro USERDATA_GETTER_AND_SETTER takes Funcname, Property
        public method operator $Funcname$ takes nothing returns integer
            return S2I(JNStringDecrypt(StashLoad(this.PLAYER_ENCRYPTED_DATA, $Property$, "0"), this.encryptKey))
        endmethod

        public method operator $Funcname$= takes integer value returns nothing
            call StashSave(this.PLAYER_ENCRYPTED_DATA, $Property$, JNStringEncrypt(I2S(value), this.encryptKey))
        endmethod
    //! endtextmacro

    // ========================================
    // Stash를 이용하여 서버에서 얻은 데이터
    // ========================================
    private struct UserData
        private stash PLAYER_DATA
        private stash PLAYER_ENCRYPTED_DATA
        private string encryptKey

        // ==========================================================================
        // WorldClearCount : 클리어 횟수
        // ==========================================================================
        private static constant string WorldClearCount_CaptainJack = "WorldClearCount_CaptainJack"
        private static constant string WorldClearCount_Subway = "WorldClearCount_Subway"
        private static constant string WorldClearCount_Valentine = "WorldClearCount_Valentine"
        private static constant string WorldClearCount_Beach = "WorldClearCount_Beach"
        private static constant string WorldClearCount_Coke = "WorldClearCount_Coke"
        private static constant string WorldClearCount_WorldChallenge = "WorldClearCount_WorldChallenge"
        private static constant string WorldClearCount_Cafe = "WorldClearCount_Cafe"
        private static constant string WorldClearCount_Desert = "WorldClearCount_Desert"
        private static constant string WorldClearCount_Forest = "WorldClearCount_Forest"
        private static constant string WorldClearCount_IceCave = "WorldClearCount_IceCave"
        private static constant string WorldClearCount_DownTown = "WorldClearCount_DownTown"
        private static constant string WorldClearCount_WorldChallenge2 = "WorldClearCount_WorldChallenge2"
        private static constant string WorldClearCount_Refre = "WorldClearCount_Refre"
        private static constant string WorldClearCount_Mirror = "WorldClearCount_Mirror"
        private static constant string WorldClearCount_Random = "WorldClearCount_Random"
        private static constant string WorldClearCount_HardRandom = "WorldClearCount_HardRandom"

        //! runtextmacro USERDATA_GETTER_AND_SETTER("CaptainJackCount", "WorldClearCount_CaptainJack")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("SubwayCount", "WorldClearCount_Subway")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("ValentineCount", "WorldClearCount_Valentine")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("BeachCount", "WorldClearCount_Beach")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("CokeCount", "WorldClearCount_Coke")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("WorldChallengeCount", "WorldClearCount_WorldChallenge")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("CafeCount", "WorldClearCount_Cafe")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("DesertCount", "WorldClearCount_Desert")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("ForestCount", "WorldClearCount_Forest")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("IceCaveCount", "WorldClearCount_IceCave")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("DownTownCount", "WorldClearCount_DownTown")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("WorldChallenge2Count", "WorldClearCount_WorldChallenge2")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("RefreCount", "WorldClearCount_Refre")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("MirrorCount", "WorldClearCount_Mirror")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("RandomCount", "WorldClearCount_Random")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("HardRandomCount", "WorldClearCount_HardRandom")
        // ==========================================================================
        // WorldLastStage : 가장 멀리 간 스테이지
        // ==========================================================================
        private static constant string WorldLastStage_CaptainJack = "WorldLastStage_CaptainJack"
        private static constant string WorldLastStage_Subway = "WorldLastStage_Subway"
        private static constant string WorldLastStage_Valentine = "WorldLastStage_Valentine"
        private static constant string WorldLastStage_Beach = "WorldLastStage_Beach"
        private static constant string WorldLastStage_Coke = "WorldLastStage_Coke"
        private static constant string WorldLastStage_WorldChallenge = "WorldLastStage_WorldChallenge"
        private static constant string WorldLastStage_Cafe = "WorldLastStage_Cafe"
        private static constant string WorldLastStage_Desert = "WorldLastStage_Desert"
        private static constant string WorldLastStage_Forest = "WorldLastStage_Forest"
        private static constant string WorldLastStage_IceCave = "WorldLastStage_IceCave"
        private static constant string WorldLastStage_DownTown = "WorldLastStage_DownTown"
        private static constant string WorldLastStage_WorldChallenge2 = "WorldLastStage_WorldChallenge2"
        private static constant string WorldLastStage_Refre = "WorldLastStage_Refre"
        private static constant string WorldLastStage_Mirror = "WorldLastStage_Mirror"

        //! runtextmacro USERDATA_GETTER_AND_SETTER("CaptainJackMax", "WorldLastStage_CaptainJack")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("SubwayMax", "WorldLastStage_Subway")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("ValentineMax", "WorldLastStage_Valentine")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("BeachMax", "WorldLastStage_Beach")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("CokeMax", "WorldLastStage_Coke")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("WorldChallengeMax", "WorldLastStage_WorldChallenge")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("CafeMax", "WorldLastStage_Cafe")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("DesertMax", "WorldLastStage_Desert")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("ForestMax", "WorldLastStage_Forest")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("IceCaveMax", "WorldLastStage_IceCave")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("DownTownMax", "WorldLastStage_DownTown")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("WorldChallenge2Max", "WorldLastStage_WorldChallenge2")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("RefreMax", "WorldLastStage_Refre")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("MirrorMax", "WorldLastStage_Mirror")

        // ==========================================================================
        // Item : 인벤토리에 있는 것
        // ==========================================================================
        private static constant string Item_PinkBeanDesignation = "Item_PinkBeanDesignation"
        private static constant string Item_BellaPet = "Item_BellaPet"
        private static constant string Item_LucidSoul = "Item_LucidSoul"
        private static constant string Item_SpiritPendant = "Item_SpiritPendant"

        //! runtextmacro USERDATA_GETTER_AND_SETTER("PinkBeanDesignation", "Item_PinkBeanDesignation")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("BellaPet", "Item_BellaPet")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("LucidSoul", "Item_LucidSoul")
        //! runtextmacro USERDATA_GETTER_AND_SETTER("SpiritPendant", "Item_SpiritPendant")


        // ==========================================================================
        // Money : 재화
        // ==========================================================================
        private static constant string Money_GoldLeaf = "Money_GoldLeaf"
        //! runtextmacro USERDATA_GETTER_AND_SETTER("GoldLeaf", "Money_GoldLeaf")


        public method Balance takes nothing returns Money
            return Money.create(this.GoldLeaf) 
        endmethod

        public method Withdraw takes integer playerId, Money amount returns nothing
            set this.GoldLeaf = this.GoldLeaf - amount.ToInt()
            call Events.Raise(GoldLeafChangedEvent, playerId)
        endmethod

        public method Deposit takes integer playerId, Money amount returns nothing
            set this.GoldLeaf = this.GoldLeaf + amount.ToInt()
            call Events.Raise(GoldLeafChangedEvent, playerId)
        endmethod

        // --------------------------------------------------------------------------
        
        public method GetSize takes nothing returns integer
            return StashSize(this.PLAYER_DATA)
        endmethod

        private method Decrypt takes nothing returns nothing
            local integer i = 0
            local integer N = StashSize(this.PLAYER_ENCRYPTED_DATA)
            
            //! runtextmacro for("set i = 0", "i < N")
                call StashSave(this.PLAYER_DATA, StashKeyAt(this.PLAYER_ENCRYPTED_DATA, i), JNStringDecrypt(StashValueAt(this.PLAYER_ENCRYPTED_DATA, i, "0"), this.encryptKey))
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public method Upload takes integer p returns nothing
            local string name = StringCase(GetPlayerName(Player(p)), false)
            call Decrypt()
            call JNStashNetUploadUser( Player(p), mapId, name, secretKey, this.PLAYER_DATA, UPLOAD_CALLBACK )
        endmethod

        private method Encrypt takes nothing returns nothing
            local integer i = 0
            local integer N = StashSize(this.PLAYER_DATA)

            set this.PLAYER_ENCRYPTED_DATA = CreateStash()
            //! runtextmacro for("set i = 0", "i < N")
                call StashSave(this.PLAYER_ENCRYPTED_DATA, StashKeyAt(this.PLAYER_DATA, i), JNStringEncrypt(StashValueAt(this.PLAYER_DATA, i, "0"), this.encryptKey))
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        private method CreateKey takes nothing returns nothing
	        local string s = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            local integer i = 0

            set this.encryptKey = ""
            //! runtextmacro for("set i = 0", "i < 32")
                set this.encryptKey = this.encryptKey + JNStringSub(s, GetRandomInt(0, 35), 1)
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public static method create takes stash s returns thistype
            local thistype this = thistype.allocate()
            set this.PLAYER_DATA = s
            call CreateKey()
            call Encrypt()
            debug call StashPrint( this.PLAYER_DATA )
            return this
        endmethod
    endstruct

    


    // ====================================================
    // Legacy. 새로운 저장 방식으로 옴기기 위해서만 사용.
    // ====================================================
    private struct user
        worldCount ClearList
        integer PinkBeanDesignation = 0
        integer BellaPet = 0
        integer LucidSoul = 0
        integer SpiritPendant = 0
        Money GoldLeaf

        static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            set this.ClearList = worldCount.create()
            return this
        endmethod
    endstruct

    //! runtextmacro Make_Container("user", "7")
    //! runtextmacro Make_Container("UserData", "7")
    
    globals
        public userContainer UserList
        public UserDataContainer UserDataList
        public key ReconnectedEventKey 
    endglobals

    //! textmacro MOVE_USERDATA takes NewData, OldData
        if $OldData$ > 0 then
            set $NewData$ = $OldData$
        endif
    //! endtextmacro

    private function MoveToNewSystem takes integer p returns nothing
        //! runtextmacro MOVE_USERDATA("UserDataList[p].CaptainJackCount", "UserList[p].ClearList.CaptainJack")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].SubwayCount", "UserList[p].ClearList.Subway")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].ValentineCount", "UserList[p].ClearList.Valentine")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].BeachCount", "UserList[p].ClearList.Beach")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].CokeCount", "UserList[p].ClearList.Coke")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].WorldChallengeCount", "UserList[p].ClearList.WorldChallenge")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].CafeCount", "UserList[p].ClearList.Cafe")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].DesertCount", "UserList[p].ClearList.Desert")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].ForestCount", "UserList[p].ClearList.Forest")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].IceCaveCount", "UserList[p].ClearList.IceCave")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].DownTownCount", "UserList[p].ClearList.DownTown")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].WorldChallenge2Count", "UserList[p].ClearList.WorldChallenge2")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].RefreCount", "UserList[p].ClearList.Refre")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].RandomCount", "UserList[p].ClearList.Random")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].HardRandomCount", "UserList[p].ClearList.HardRandom")

        //! runtextmacro MOVE_USERDATA("UserDataList[p].PinkBeanDesignation", "UserList[p].PinkBeanDesignation")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].BellaPet", "UserList[p].BellaPet")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].LucidSoul", "UserList[p].LucidSoul")
        //! runtextmacro MOVE_USERDATA("UserDataList[p].SpiritPendant", "UserList[p].SpiritPendant")

        call UserDataList[p].Deposit(p, UserList[p].GoldLeaf) 
        call UserDataList[p].Upload(p)
    endfunction

    private function DownloadCallback takes nothing returns nothing
        local player u = JNStashNetGetPlayer( )
        local integer p = GetPlayerId(u)
        
        if JNStashNetGetFinished( ) then
            if JNStashNetGetResult( ) then
                call DisplayTimedTextToPlayer(u, 0, 0, 5, JNStashNetGetMessage( ))
                set UserDataList[p] = UserData.create(JNStashNetGetStash( ))
                
                if UserDataList[p].GetSize() == 0 then
                    call MoveToNewSystem(p)
                endif

            else
                call DisplayTimedTextToPlayer(u, 0, 0, 5, JNStashNetGetMessage( ))
                call DisplayTimedTextToPlayer(u, 0, 0, 5, "|cffFFFC00※ -재연결 / -rec 명령어를 이용하여 다시 시도해주세요.|r")
            endif

            call DisplayTimedTextToPlayer(u, 0, 0, 5, "로드 중 : " + I2S(JNStashNetGetProgress()) + "/" + I2S(JNStashNetGetMaximum()))
        endif
    endfunction
    
    private function UploadCallback takes nothing returns nothing
        local player u = JNStashNetGetPlayer( )

        if JNStashNetGetFinished( ) then
            if JNStashNetGetResult( ) then
                call DisplayTimedTextToPlayer(u, 0, 0, 5, "|cffFFFC00※ 서버에 데이터가 저장되었습니다! ※|r")
            else
                call DisplayTimedTextToPlayer(u, 0, 0, 5, "|cffFFFC00※ 서버에 저장하는데 실패하였습니다.|r")
                call DisplayTimedTextToPlayer(u, 0, 0, 5, JNStashNetGetMessage( ))
            endif

            call DisplayTimedTextToPlayer(u, 0, 0, 5, JNStashNetGetMessage( ))
        endif
    endfunction
    

    public function PrintCode takes integer i returns nothing
        local boolean none = true

        if GetLocalPlayer() == Player(i) then
            call ClearTextMessages()
        endif
        if UserDataList[i].CaptainJackCount > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　핑크: " + WorldKey_Code[i + 1])
        endif
        if UserDataList[i].SubwayCount > 0 then
            set none = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　지하철: " + WorldKey_Code2[i + 1])
        endif
        // if UserList[i].ClearList.Valentine > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　발렌: " + WorldKey_Code3[i + 1])
        // endif
        // if UserList[i].ClearList.Beach > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　해변: " + WorldKey_Code4[i + 1])
        // endif
        // if UserList[i].ClearList.Coke > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　코크: " + WorldKey_Code5[i + 1])
        // endif
        // if UserList[i].ClearList.WorldChallenge > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　월드: " + WorldKey_Code8[i + 1])
        // endif
        // if UserList[i].ClearList.Cafe > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　카페: " + WorldKey_Code6[i + 1])
        // endif
        // if UserList[i].ClearList.Desert > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　사막: " + WorldKey_Code7[i + 1])
        // endif
        // if UserList[i].ClearList.Forest > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　엘린숲: " + WorldKey_Code9[i + 1])
        // endif
        // if UserList[i].ClearList.IceCave > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　얼음 동굴: " + WorldKey_Code11[i + 1])
        // endif
        // if UserList[i].ClearList.DownTown > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　아랫 마을: " + WorldKey_Code12[i + 1])
        // endif
        // if UserList[i].ClearList.WorldChallenge2 > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　월드2: " + WorldKey_Code13[i + 1])
        // endif
        // if UserList[i].ClearList.Random > 0 then
        //     set none = false
        //     call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "　　　　　　랜덤: " + WorldKey_Code10[i + 1])
        // endif
        if none then
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 20, "　　　　　　|cffFFFC00※ 클리어한 맵이 없습니다! ※|r")
        endif
    endfunction

    public function GameClearDataUpload takes integer p, string name, string world returns nothing
        local Money amount
        local Money now

        if world == "CaptainJack" then
            set amount = Money.create(150)
            set UserDataList[p].CaptainJackCount = UserDataList[p].CaptainJackCount + 1
        elseif world == "Subway" then
            set amount = Money.create(200)
            set UserDataList[p].SubwayCount = UserDataList[p].SubwayCount + 1
        elseif world == "Valentine" then
            set amount = Money.create(200)
            set UserDataList[p].ValentineCount = UserDataList[p].ValentineCount + 1
        elseif world == "Beach" then
            set amount = Money.create(300)
            set UserDataList[p].BeachCount = UserDataList[p].BeachCount + 1
        elseif world == "Coke" then
            set amount = Money.create(200)
            set UserDataList[p].CokeCount = UserDataList[p].CokeCount + 1
        elseif world == "WorldChallenge" then
            set amount = Money.create(450)
            set UserDataList[p].WorldChallengeCount = UserDataList[p].WorldChallengeCount + 1
        elseif world == "Cafe" then
            set amount = Money.create(450)
            set UserDataList[p].CafeCount = UserDataList[p].CafeCount + 1
        elseif world == "Desert" then
            set amount = Money.create(450)
            set UserDataList[p].DesertCount = UserDataList[p].DesertCount + 1
        elseif world == "Forest" then
            set amount = Money.create(450)
            set UserDataList[p].ForestCount = UserDataList[p].ForestCount + 1
        elseif world == "IceCave" then
            set amount = Money.create(700)
            set UserDataList[p].IceCaveCount = UserDataList[p].IceCaveCount + 1
        elseif world == "DownTown" then
            set amount = Money.create(800)
            set UserDataList[p].DownTownCount = UserDataList[p].DownTownCount + 1
        elseif world == "WorldChallenge2" then
            set amount = Money.create(800)
            set UserDataList[p].WorldChallenge2Count = UserDataList[p].WorldChallenge2Count + 1
        elseif world == "Random" then
            set amount = Money.create(GetRandomInt(150, 300))
            set UserDataList[p].RandomCount = UserDataList[p].RandomCount + 1
        elseif world == "HardRandom" then
            set amount = Money.create(GetRandomInt(350, 650))
            set UserDataList[p].HardRandomCount = UserDataList[p].HardRandomCount + 1
        elseif world == "Refre" then
            set amount = Money.create(800)
            set UserDataList[p].RefreCount = UserDataList[p].RefreCount + 1
        endif

        
        call UserDataList[p].Deposit(p, amount)
        call UserDataList[p].Upload(p)
        set now = UserDataList[p].Balance()

        call PrivateLogging(p, GetPlayerName(Player(p)) + "님이 골드리프 " + amount.ToString() + "을 획득했습니다. 잔액은 " /*
                */ + now.ToString() + "입니다.", "GoldLeafGetLog")
        
        if GetLocalPlayer() == Player(p) then
            call JNPublicMapServerLog(mapId, secretKey, mapVersion, name + "님이 " + world + " 월드를 클리어 했습니다.")
            call BJDebugMsg("             " + TeamColor[p + 1] + GetPlayerName(GetLocalPlayer()) + "|r 님이 골드리프 " + amount.ToString() + "을 획득했습니다. 잔액은 " /*
            */ + now.ToString() + "입니다.")
        endif

        call amount.destroy()
        call now.destroy()
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

    // world
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
    //! runtextmacro MakeFuncToDataLoadSync("WorldChallenge2", "UserList[idx].ClearList.WorldChallenge2", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("Refre", "UserList[idx].ClearList.Refre", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("Random", "UserList[idx].ClearList.Random", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")
    //! runtextmacro MakeFuncToDataLoadSync("HardRandom", "UserList[idx].ClearList.HardRandom", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")

    // item
    //! runtextmacro MakeFuncToDataLoadSync("PinkBeanDesignation", "UserList[idx].PinkBeanDesignation", "S2I", "string name, string itemName", "JNUseUserRoleItemInfo(mapId, secretKey, name, itemName)")
    //! runtextmacro MakeFuncToDataLoadSync("BellaPet", "UserList[idx].BellaPet", "S2I", "string name, string itemName", "JNUseUserRoleItemInfo(mapId, secretKey, name, itemName)")
    //! runtextmacro MakeFuncToDataLoadSync("LucidSoul", "UserList[idx].LucidSoul", "S2I", "string name, string itemName", "JNUseUserRoleItemInfo(mapId, secretKey, name, itemName)")
    //! runtextmacro MakeFuncToDataLoadSync("SpiritPendant", "UserList[idx].SpiritPendant", "S2I", "string name, string keyword", "I2S(JNObjectCharacterGetInt(name, keyword))")

    // money
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
            call DataLoadSyncToWorldChallenge2(playerId, name, "WorldChallenge2")
            call DataLoadSyncToRefre(playerId, name, "Refre")
            call DataLoadSyncToRandom(playerId, name, "Random")
            call DataLoadSyncToHardRandom(playerId, name, "HardRandom")
            call DataLoadSyncToPinkBeanDesignation(playerId, name, "PinkBean Designation")
            call DataLoadSyncToBellaPet(playerId, name, "Bella Pet")
            call DataLoadSyncToLucidSoul(playerId, name, "Lucid Soul")
            call DataLoadSyncToSpiritPendant(playerId, name, "SpiritPendant")
            call DataLoadSyncToGoldLeaf(playerId, name, "GoldLeaf")
        endif
    endfunction

    private function LoadAllUserData takes nothing returns nothing
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            call LoadUserData(i)
        //! runtextmacro for_end("set i = i + 1")
    endfunction


    globals
        private boolean array reconnectingWait
    endglobals

    public function Reconnecting takes integer p returns nothing
        if reconnectingWait[p] then
            call DisplayTimedTextToPlayer(Player(p), 0, 0, 5, "|cffFFFC00※ 아직 시도할 수 없습니다.|r")
            call DisplayTimedTextToPlayer(Player(p), 0, 0, 5, "|cffFFFC00※ 재연결 실행 후 3분뒤에 다시 시도해주세요.|r")
            return
        endif

        set reconnectingWait[p] = true
        call DisplayTimedTextToPlayer(Player(p), 0, 0, 5, "|cffFFFC00※ 서버와의 연결을 시도합니다.|r")
        call JNStashNetDownloadUser( Player(p), mapId, StringCase(GetPlayerName(Player(p)), false), secretKey, DOWNLOAD_CALLBACK )

        call TriggerSleepActionByTimer(180)
        set reconnectingWait[p] = false
    endfunction
    
    private function Main takes nothing returns nothing
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
                call JNStashNetDownloadUser( Player(i), mapId, StringCase(GetPlayerName(Player(i)), false), secretKey, DOWNLOAD_CALLBACK )
            endif
        //! runtextmacro for_end("set i = i + 1")
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()

        call TriggerRegisterTimerEvent(t, 0.00, false)
        call TriggerAddAction( t, function Main )

        static if DEBUG_MODE then
            set mapVersion = "TEST"
        endif
        call JNUse()
        call CreateUserContainer()
        call LoadAllUserData()

        // Stash Code
        set UserDataList = UserDataContainer.create()
        call TriggerAddAction( DOWNLOAD_CALLBACK, function DownloadCallback )
        call TriggerAddAction( UPLOAD_CALLBACK, function UploadCallback )

        set t = null
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