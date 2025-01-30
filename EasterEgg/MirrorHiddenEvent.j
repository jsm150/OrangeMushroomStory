library MirrorHiddenEvent needs TriggerSleepAction

    globals
        private constant string BLACK_NAME = "|cff282828블랙|r"
        private constant string PINK_NAME = "|cffE45AAF분홍버섯|r"
        private constant string SNOW_PINK_NAME = "|cffE45AAF눈사람|r"
    endglobals

    private function MsgPrint takes string s returns nothing
        call ClearTextMessages()
        call BJDebugMsg("　　　　　　" + s )
    endfunction

    public function Notice takes tick tk, code c returns nothing
static if DEBUG_MODE then
        call TriggerSleepActionByTimer(5.0)
        call MsgPrint(BLACK_NAME + ": ...")
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": 여기 오는길 중간에 기계 장치가 있는 것 같던데.")
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": 정확하게 제어하고 오면 좋은 정보를 알려줄께.")
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": 그럼 다음에 또 보자고 BOY♂♥")
        call tk.start(4.0, false, c)
else
        call TriggerSleepActionByTimer(5.0)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenNotice, "||", 0))
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenNotice, "||", 1))
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenNotice, "||", 2))
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenNotice, "||", 3))
        call tk.start(4.0, false, c)
endif
    endfunction

    public function FirstMessage takes tick tk, code c returns nothing
static if DEBUG_MODE then
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": 아, 깜빡할뻔 했어.")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": 너.. 진짜 소개팅 장소를 찾고 있는거지?")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": 레버를 순서대로 조작해야 한다던데.")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": 지금 켜져 있는 레버가 첫 번째 순서야.")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": 그러니까, 초기 상태에서 한번에 지금 레버를 켜야 한다는 거지.")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": ..그 다음은 나도 잘 몰라")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": 아무튼.. 주황버섯씨! 화이팅이야!")
        call tk.start(4.0, false, c)
else
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage01, "||", 0))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage01, "||", 1))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage01, "||", 2))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage01, "||", 3))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage01, "||", 4))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage01, "||", 5))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(SNOW_PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage01, "||", 6))
        call tk.start(4.0, false, c)
endif
    endfunction
    
    public function SecondMessage takes tick tk, code c returns nothing
static if DEBUG_MODE then
        call TriggerSleepActionByTimer(5.0)
        call MsgPrint(BLACK_NAME + ": ...")
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": 어떻게 찾은거야?")
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": 지금 켜져 있는 레버는 두 번째 순서야.")
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": 레버들을 순서대로 조작 한다면")
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": 진짜 소개팅 장소로 갈 수 있어.")
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": 혹시.. 다음 레버의 순서가 궁금해 BOY♂?")
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": 하지만, 내가 아는건 이것 뿐이야♂")
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": 그럼 다음에 또 보자고 BOY♂♥")
        call tk.start(4.0, false, c)
else
        call TriggerSleepActionByTimer(5.0)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage02, "||", 0))
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage02, "||", 1))
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage02, "||", 2))
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage02, "||", 3))
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage02, "||", 4))
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage02, "||", 5))
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage02, "||", 6))
        call TriggerSleepActionByTimer(4.5)
        call MsgPrint(BLACK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage02, "||", 7))
        call tk.start(4.0, false, c)
endif
    endfunction

    public function ThirdMessage takes tick tk, code c returns nothing
static if DEBUG_MODE then
        call TriggerSleepActionByTimer(2.0)
        call MsgPrint(PINK_NAME + ": 훗...")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": 그쪽으로 가면 안될텐데요..")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": 진짜 소개팅 장소는 그 곳에 없어요.")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": ...")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": 지금 켜져 있는 레버가 세 번째 순서에요.")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": 그 다음은 초기 상태로 되돌려야 하죠.")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": 그러면 진짜 소개팅 장소로 갈 수 있을꺼에요.")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": 잘 찾아올 수 있겠죠♥?")
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": 그럼.. 먼저가서 기다리고 있을께요♥")
        call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
        set tk.data = 18
        call tk.start(4.0, false, c)
else
        call TriggerSleepActionByTimer(2.0)
        call MsgPrint(PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage03, "||", 0))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage03, "||", 1))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage03, "||", 2))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage03, "||", 3))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage03, "||", 4))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage03, "||", 5))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage03, "||", 6))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage03, "||", 7))
        call TriggerSleepActionByTimer(4.0)
        call MsgPrint(PINK_NAME + ": " + JNStringSplit(MapData_MirrorHiddenMessage03, "||", 8))
        call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
        set tk.data = 18
        call tk.start(4.0, false, c)
endif
    endfunction
endlibrary