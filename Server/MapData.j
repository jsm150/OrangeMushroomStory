library MapData initializer Init
    globals
        private trigger syncTrigger = CreateTrigger()
        private integer firstPlayer = 0

        public string NoticeString = "Notice"
        public string MirrorHiddenNoticeString = "MirrorHiddenNotice"
        public string MirrorHiddenMessage01String = "MirrorHiddenMessage01"
        public string MirrorHiddenMessage02String = "MirrorHiddenMessage02"
        public string MirrorHiddenMessage03String = "MirrorHiddenMessage03"
    endglobals

    //! runtextmacro MapObject_Init_Load("string", "Notice")
    //! runtextmacro MapObject_Init_Load("string", "MirrorHiddenNotice")
    //! runtextmacro MapObject_Init_Load("string", "MirrorHiddenMessage01")
    //! runtextmacro MapObject_Init_Load("string", "MirrorHiddenMessage02")
    //! runtextmacro MapObject_Init_Load("string", "MirrorHiddenMessage03")

    //! textmacro MapObject_Init_Load takes type, name
        globals
            public $type$ $name$
        endglobals

        private struct $type$_$name$
            private static key $type$_$name$Key

            private static method SyncData takes nothing returns nothing
                set $name$ = JNGetTriggerSyncData()
            endmethod

            private static method Load takes nothing returns nothing
                if GetLocalPlayer() == Player(firstPlayer) then
                    call DzSyncData(I2S($type$_$name$Key), JNObjectMapGetString($name$String))
                endif
            endmethod
            
            private static method onInit takes nothing returns nothing
                local trigger t = CreateTrigger()
                call DzTriggerRegisterSyncData(t, I2S($type$_$name$Key), false)
                call TriggerAddAction(t, function thistype.SyncData)
                call TriggerAddAction(syncTrigger, function thistype.Load)
                set t = null
            endmethod
        endstruct
    //! endtextmacro

    private function Init takes nothing returns nothing
        call JNUse()

        //! runtextmacro for("set firstPlayer = 0", "firstPlayer < PLAYER_MAXINUM")
            if GetPlayerSlotState(Player(firstPlayer)) == PLAYER_SLOT_STATE_PLAYING then
                if GetLocalPlayer() == Player(firstPlayer) then
                    call JNObjectMapInit(mapId, secretKey)
                endif
                exitwhen true
            endif
        //! runtextmacro for_end("set firstPlayer = firstPlayer + 1")

        call TriggerRegisterTimerEvent(syncTrigger, 0.00, false)
    endfunction
endlibrary