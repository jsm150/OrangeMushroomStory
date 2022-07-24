scope initialize initializer init
    globals
        hashtable Hash = InitHashtable()
        
        constant integer PLAYER_MAXINUM = 7
        constant boolean TESTMODE = false
        boolean PracticeMode = false
        unit array OrangeMushroom
        unit array OrangeMushroomSkin
        unit array OrangeMushroomFloorSkin
        unit array BackGroundUnits
        timer array PlayerSentinelTimer
        
        rect StartRect
        integer array OrangeMushroomType
        integer HostNumber = 0
    endglobals

    private function SetEasterEggDummyUnit takes integer i returns nothing
        local unit u
        local integer array colorfulType

        set colorfulType[1] = 'nmyr'
        set colorfulType[2] = 'nnrg'
        set colorfulType[3] = 'nhyc'
        set colorfulType[4] = 'nmpe'
        set colorfulType[5] = 'nanm'
        set colorfulType[6] = 'hpea'
        set colorfulType[7] = 'nanb'

        set u = CreateUnit(Player(11), colorfulType[i], 5888+(256*(i-1)),-28704, 270 )
        call SetUnitVertexColorBJ( u, 100.00, 100.00, 100.00, 20 )
        set u = CreateUnit(Player(11), colorfulType[i], GetRectCenterX(gg_rct_MazeHiddenEvent001) + (256 * (i - 1)), GetRectCenterY(gg_rct_MazeHiddenEvent001) - 16.0, 270 )
        call SetUnitVertexColorBJ( u, 100.00, 100.00, 100.00, 20 )

        set u = null
    endfunction

    private function PlayersCheck takes nothing returns nothing
        local integer i = 1
        
        loop
        exitwhen i > PLAYER_MAXINUM
            call SetEasterEggDummyUnit(i)
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                if HostNumber == 0 then
                    set HostNumber = i
                endif
                set OrangeMushroomType[i] = 'hpea'
                set OrangeMushroom[i] = CreateUnit(Player(i-1), OrangeMushroomType[i], GetRectMinX(StartRect)+(128*(i-1)), GetRectCenterY(StartRect), 270 )
                set BackGroundUnits[i] = CreateUnit(Player(i-1), 'hfoo', GetRectMinX(StartRect)+(128*(i-1)), GetRectCenterY(StartRect), 270 )
                if SubString("|", -1, 0) != "o" and GetUnitTypeId(BackGroundUnits[i]) != 'hspt' then
                    call SetUnitScale(BackGroundUnits[i], 4, 4, 4)
                endif
                call SetUnitVertexColorBJ( BackGroundUnits[i], 0.00, 0.00, 0.00, 100 )
                if Player(i-1) == GetLocalPlayer() then
                    call SetUnitVertexColorBJ( BackGroundUnits[i], 100.00, 100.00, 100.00, 0 )
                endif
                call SetUnitBlendTime(OrangeMushroom[i], 0.00)
                call SetUnitPosition(OrangeMushroom[i], GetRectMinX(StartRect)+(128*(i-1)), GetRectCenterY(StartRect))
                set NameTextTag[i] = CreateTextTag()
                call SetTextTagText(NameTextTag[i], TeamColor[i] + GetPlayerName(Player(i-1)), TextTagSize2Height(10))
                call SetTextTagPos(NameTextTag[i], -7168, -7168, 0)
                set PlayerSentinelTimer[i] = CreateTimer()
                call SaveInteger(Hash, GetHandleId(PlayerSentinelTimer[i]), 0, i)
            endif
        set i = i + 1
        endloop
    endfunction
    
    private function Quest takes nothing returns nothing
        local string s
        set s = "10.2\n"
        set s = s + "- 스킨 인벤토리가 추가되었습니다.\n"
        set s = s + "  스킨은 월드를 클리어 하면 추가됩니다.\n"
        set s = s + "  발렌타인 데이, 해변, 코-크 월드만 지원합니다.\n"
        set s = s + "\n"
        set s = s + "10.3\n"
        set s = s + "- 스킨 인벤토리에 카페, 엘린 숲 스킨을 제외하고 모두 추가되었습니다.\n"
        set s = s + "- 스킨을 변경하는 명령어는 더이상 동작하지 않습니다.\n"
        set s = s + "- 마우스 클릭시, 클릭 위치에 이펙트가 생성됩니다.\n"
        set s = s + "\n"
        set s = s + "10.4\n"
        set s = s + "- 비석이 작동하지 않던 버그가 수정되었습니다.\n"
        set s = s + "- 아랫마을 스킨이 누락되었던 점을 수정하였습니다.\n"
        set s = s + "\n"
        set s = s + "10.5\n"
        set s = s + "- 스킨 인벤토리 버그를 수정했습니다.\n"
        set s = s + "- 월드 3-1의 난이도를 하향했습니다.\n"
        set s = s + "\n"
        set s = s + "10.6\n"
        set s = s + "- 아래 맵들의 난이도가 하향 조정됬습니다.\n"
        set s = s + "  월드: 3-6\n"
        set s = s + "  카페: 3-5, 3-6, 3-8\n"
        set s = s + "  사막: 3-5, 3-6, 3-7\n"
        set s = s + "  엘린숲: 3-4\n"
        set s = s + "  얼음 동굴: 3-2, 3-4, 3-8\n"
        set s = s + "  아랫마을: 3-1, 3-4, 3-8\n"
        set s = s + "10.7\n"
        set s = s + "- 일부 월드 스킨과 핑크빈 스킨이 수정되었습니다.\n"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "10.2~10.6", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "9.8\n"
        set s = s + "- 깊은 산속 월드의 코스가 약간 수정되었습니다.\n"
        set s = s + "- 점멸 후 텔레포트 스톤이 작동하던 버그가 수정되었습니다.\n"
        set s = s + "- 텔레포트 스톤에서 점멸이 불가능 하던 버그가 수정되었습니다.\n"
        set s = s + "- 단축키 기능에 딜레이가 있던 현상이 해결되었습니다.\n"
        set s = s + "\n"
        set s = s + "9.9\n"
        set s = s + "- 깊은 산속 월드의 코스가 약간 수정되었습니다.\n"
        set s = s + "- 연습모드 상태에서 클리어가 가능하던 버그가 수정되었습니다.\n"
        set s = s + "- 가끔 단축키가 두번 동작하던 버그를 수정했습니다.\n"
        set s = s + "- 다른 유즈맵을 실행할때 페이탈이 나는 버그를 완화했습니다.\n"
        set s = s + "\n"
        set s = s + "10.0\n"
        set s = s + "- 아랫마을 코스가 약간 수정되었습니다.\n"
        set s = s + "- -시간 명령어가 추가되었습니다.\n"
        set s = s + "- 랜덤 월드에서만 나오는 히든스테이지가 추가되었습니다.\n"
        set s = s + "- 단축키가 두번 이상 동작하던 현상을 완화했습니다.\n"
        set s = s + "- 다른 유즈맵을 실행할때 페이탈이 발생하던 현상을 완화했습니다.\n"
        set s = s + "\n"
        set s = s + "10.1\n"
        set s = s + "- 게임을 종료할 때 워크래프트가 강제로 종료되도록 변경하였습니다.\n"
        set s = s + "- -시간 명령어가 삭제되었습니다. 이제 우측 상단에 플레이 타임이 표시됩니다.\n"
        set s = s + "- 아랫마을 3-8 열쇠 버그가 수정되었습니다.\n"
        set s = s + "- 아랫마을 3-6 코스가 수정되었습니다.\n"
        set s = s + "- 호스트가 나가도 딜레이가 유지됩니다."
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "9.8~10.1", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "9.4\n"
        set s = s + "- 일부 맵들의 코스가 약간 변경되었습니다.\n"
        set s = s + "- 플레이어가 게임을 나갔을 때 스테이지가 클리어 되던 버그가 수정되었습니다.\n"
        set s = s + "- 열쇠 블럭이 타일에서 장식물로 변경되었습니다.\n"
        set s = s + "- 엔딩이 이상하게 나오던 버그가 수정되었습니다.\n"
        set s = s + "- 엘린숲 배경이 짤리던 버그가 수정되었습니다.\n"
        set s = s + "- 얼음 동굴 월드에 새로운 맵이 추가됩니다.\n"
        set s = s + "\n"
        set s = s + "9.5\n"
        set s = s + "- 플레이어가 게임을 나갔을 때 필드에 아무도 없다면 클리어가 되도록 변경되었습니다.\n"
        set s = s + "- 얼음 동굴 3-2 코스가 수정되었습니다.\n"
        set s = s + "- 얼음 동굴 스킨이 개선되었습니다.\n"
        set s = s + "- 얼음 동굴 엔딩이 추가되었습니다.\n"
        set s = s + "- 머쉬맘 스킨 이펙트 버그가 수정되었습니다.\n"
        set s = s + "- F9의 설명 일부분이 짤리던 버그가 수정되었습니다.\n"
        set s = s + "- 랜덤 월드 알고리즘이 변경되었습니다. 자세한건 F9의 확률표를 참고하여 주십시오.\n"
        set s = s + "- 랜덤 월드 에서 월드 챌린지가 나왔을 경우 컨티뉴가 두개 늘어나던 버그가 수정되었습니다.\n"
        set s = s + "- 컨티뉴가 25개 이상 주어지던 월드들을 스테이지 클리어시 컨티뉴 2개 증가로 변경하였습니다.\n"
        set s = s + "- 새로운 월드가 추가되었습니다.\n"
        set s = s + "\n"
        set s = s + "9.6\n"
        set s = s + "- 깊은 산속 3-2 코스가 너프되었습니다.\n"
        set s = s + "- 깊은 산속 플레이어 배치 버그가 수정되었습니다.\n"
        set s = s + "\n"
        set s = s + "9.7\n"
        set s = s + "- 깊은 산속 3-2, 3-7 코스가 수정되었습니다.\n"
        set s = s + "- 가끔 단축키가 작동하지 않던 버그가 수정되었습니다.\n"
        set s = s + "- 가끔 유닛 모션이 이상한 버그가 수정되었습니다.\n"
        set s = s + "- 연습모드가 추가되었습니다. 자세한건 F9를 확인해 주십시오.\n"
        set s = s + "- 스테이지 클리어시 컨티뉴 2개가 추가되던 월드들이 1개 추가로 변경되었습니다.\n"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "9.4~9.7", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "|cffFFFC00※ 9.1 버전부터 JN로더가 필요합니다. ※|r\n"
        set s = s + "9.1\n"
        set s = s + "- 이제 재선택은 2번만 사용할 수 있습니다.\n"
        set s = s + "- 재선택할 때 목숨을 소모하지 않습니다.\n"
        set s = s + "- 재선택시 가끔 게임이 멈추던 버그가 수정되었습니다.\n"
        set s = s + "- 얼음 동굴 스킨이 추가되었습니다.\n"
        set s = s + "- 얼음 동굴 코스가 약간 수정되었습니다.\n"
        set s = s + "- UI가 변경되었습니다.\n"
        set s = s + "- 단축키가 추가되었습니다. 자세한건 F9를 참고해주십시오.\n\n"
        set s = s + "9.2\n"
        set s = s + "- 패치노트가 반대로 정렬되었습니다.\n"
        set s = s + "- BGM 목록이 갱신되었습니다.\n"
        set s = s + "- 상단에 알 수 없는 그래픽이 보이던 버그가 수정되었습니다.\n"
        set s = s + "- 얼음 동굴 코스가 약간 수정되었습니다.\n"
        set s = s + "- 코드가 서버에 저장됩니다.\n"
        set s = s + "- -코드확인 명령어가 추가되었습니다.\n\n"
        set s = s + "9.3\n"
        set s = s + "- 트래픽이 과도하게 발생하던 버그가 수정되었습니다.\n"
        set s = s + "- 이제 닉네임의 대소문자 상관없이 서버에 저장됩니다."
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "9.1~9.3", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "8.2\n"
        set s = s + "- 새로운 월드가 추가되었습니다.\n"
        set s = s + "- 다른 분기점으로 가는 조건이 과반수가 아닌 다수로 변경되었습니다.\n"
        set s = s + "- 특정 코드가 사용이 안되던 버그를 수정하였습니다.\n"
        set s = s + "- 여러 스테이지가 약간 수정되었습니다.\n"
        set s = s + "- 이제 1-8 또는 2-8로 스킵을 선택할 수 있습니다.\n"
        set s = s + "- 카페 입구 모델이 변경되었습니다.\n"
        set s = s + "8.3\n"
        set s = s + "- 얼음 동굴의 목숨이 30개로 변경됩니다.\n"
        set s = s + "- 얼음 동굴 3-2 코스가 수정되었습니다.\n"
        set s = s + "- 이제 랜덤에 얼음 동굴 월드가 등장합니다.\n"
        set s = s + "8.4\n"
        set s = s + "- 특정 코드가 사용이 안되던 버그를 재수정 하였습니다.\n"
        set s = s + "- 사막 3-7 코스 시간제한이 인원수 비례로 변경되었습니다.\n"
        set s = s + "- 석상 오브젝트의 진동을 끌수있는 명령어가 추가되었습니다.\n"
        set s = s + "- 카운트다운의 최소 수치가 2로 변경되었습니다.\n"
        set s = s + "8.5\n"
        set s = s + "- 얼음 동굴 3-2 코스가 수정되었습니다.\n"
        set s = s + "- 스킨 버그가 수정되었습니다.\n"
        set s = s + "- 패턴 인식이 개선되었습니다.\n"
        set s = s + "8.6\n"
        set s = s + "- 시작하면 바로 비석이 먹어지는 버그가 수정되었습니다.\n"
        set s = s + "- 가끔 엔딩이 나오지 않는 버그가 수정되었습니다.\n"
        set s = s + "8.7\n"
        set s = s + "- 얼음 동굴의 스테이지 순서가 변경되었습니다.\n"
        set s = s + "- 얼음 동굴 3-3 코스가 수정되었습니다.\n"
        set s = s + "8.8\n"
        set s = s + "- 얼음 동굴 전체적인 코스가 수정되었습니다.\n"
        set s = s + "8.9\n"
        set s = s + "- 얼음 동굴 3-4 코스가 수정되었습니다.\n"
        set s = s + "9.0\n"
        set s = s + "- 이제 랜덤 월드에서 레벨을 재선택 할 수 있습니다.\n"
        set s = s + "- -재선택 명령어가 추가되었습니다."
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "8.2~9.0", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "- 체력바가 보이던 버그가 수정되었습니다.\n"
        set s = s + "- 투명스킨을 착용하면 오브젝트와 상호작용이 불가능하던 버그가 수정되었습니다.\n"
        set s = s + "- 이제 월드맵에 입장할 수 있습니다.\n"
        set s = s + "- 월드맵 3-3 물속 낙하속도가 빠른 버그가 수정되었습니다.\n"
        set s = s + "- 엘린숲 루트가 약간 수정되었습니다.\n"
        set s = s + "7.7: 게임 진행이 불가능하던 버그가 수정되었습니다.\n"
        set s = s + "7.7: 랜덤 스테이지에서 고 난이도의 맵이 나올 확률이 소폭 감소하였습니다.\n"
        set s = s + "7.8: 텔레포트 버그가 수정되었습니다.\n"
        set s = s + "7.8: 일부 코드가 작동하지 않던 버그를 수정하였습니다.\n"
        set s = s + "7.9: 사막 3-4 진행이 불가능하던 버그가 수정되었습니다.\n"
        set s = s + "7.9: 카페 3-7 판정이 소폭 상향되었습니다.\n"
        set s = s + "8.0: 변신 중 재시작 했을 때 포탈에 들어갈 수 없던 버그를 수정하였습니다.\n"
        set s = s + "8.1: 버그 수정.\n"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "7.6~8.1", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "- 랜덤 스테이지 추가\n"
        set s = s + "7.0: 버그 수정, 히든맵 하향\n"
        set s = s + "7.1: 히든맵 하향\n"
        set s = s + "7.2: 히든맵 3-3, 사막맵 3-6 하향\n"
        set s = s + "7.3: 히든맵 버그 수정, 랜덤맵 코드 스킨 추가, 스킨 버그 수정\n"
        set s = s + "7.4: 히든맵 코드 스킨 추가, 히든맵 하향, 랜덤맵 버그 수정, 코드가 안나오는 버그 수정\n"
        set s = s + "7.5: 비행기가 오브젝트에 영향을 받던 버그 수정"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "6.9~7.5", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "- 월드맵 코드 스킨 추가\n"
        set s = s + "- 새로운 히든 스테이지 추가\n"
        set s = s + "6.2: 카페 스킨 추가, 히든 스테이지 난이도 수정, 사막 스테이지 버그 수정\n"
        set s = s + "6.3: 사막 3-6 버그 수정, 사막 스테이지 스킨 추가\n"
        set s = s + "6.4: 스킨 버그 수정, 히든 스테이지 완성\n"
        set s = s + "6.5: 지형이 안보이던 버그 수정\n"
        set s = s + "6.6: 전체적인 난이도 하향\n"
        set s = s + "6.7: 사막 코드 변경, 사막 3-4 변경, 히든 스테이지 하향\n"
        set s = s + "6.8: 사막 난이도 조절"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "6.1~6.8", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "- 렉 최적화\n"
        set s = s + "- 히든 스테이지 버그 수정\n"
        set s = s + "- 사막 스테이지 난이도 수정\n"
        set s = s + "- 그외 잡다한 버그 수정\n"
        set s = s + "5.9: 사막 스테이지 3-6 버그 수정\n"
        set s = s + "6.0: 사막 스테이지 수정, 텔레포트 버그 수정"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "5.8~6.0", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "-신규 오브젝트 추가\n"
        set s = s + "-신규 분기 월드 추가\n"
        set s = s + "-게임 렉 최적화\n"
        set s = s + "-신규 비밀 코드 추가\n"
        set s = s + "5.1: 사막 스테이지 3-3 7명에서 못깨던 버그수정\n"
        set s = s + "5.2: 사막 스테이지 3-5 최적화\n"
        set s = s + "5.3: 사막 스테이지 3-5 난이도 너프"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "4.4~5.7", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "3.7\n"
        set s = s + "-강퇴 기능 3월드에서도 사용 가능하게 설정\n"
        set s = s + "-강퇴 기능 재사용 시간 3분 → 1분으로 변경\n"
        set s = s + "-게임 렉 최적화\n"
        set s = s + "-신규 오브젝트 추가\n"
        set s = s + "-신규 분기 월드 추가\n"
        set s = s + "-해변 3-8 난이도 너프\n"
        set s = s + "-관전 명령어 추가\n"
        set s = s + "-관전 중인 플레이어가 나가면 다른 플레이어 자동으로 관전하도록 설정\n"
        set s = s + "-신규 비밀 코드 추가\n"
        set s = s + "-신규 엔딩 추가\n"
        set s = s + "-분기점에서 들어간 인원수가 적은 곳으로 이동되는 버그 수정\n"
        set s = s + "-리포지드에서 구동시 워크 기본 배경음악 들리지 않게 설정\n"
        set s = s + "-스킵 명령어 추가\n"
        set s = s + "3.8\n"
        set s = s + "-신규 월드 3-4 코스 수정\n"
        set s = s + "-텔레포트 스톤 이펙트 변경\n"
        set s = s + "-해변 3-8 난이도 롤백\n"
        set s = s + "-오브젝트 위에서 내려갈때 간혹 기존보다 빠르게 낙하되는 버그 수정\n"
        set s = s + "-기타 컨텐츠 추가\n"
        set s = s + "3.9\n"
        set s = s + "-코스 오류 수정\n"
        set s = s + "4.0\n"
        set s = s + "-펩시 3-6 코스 수정\n"
        set s = s + "-특수 코드 초기화\n"
        set s = s + "-기타 수정\n"
        set s = s + "4.1\n"
        set s = s + "-몇몇 코스 수정\n"
        set s = s + "4.2\n"
        set s = s + "-코스 난이도 조정\n"
        set s = s + "4.3\n"
        set s = s + "-코스 난이도 조정 및 오류 수정, 기타\n"
        set s = s + "4.4\n"
        set s = s + "-텔레포트 스톤 탑승 시 오브젝트 겹치는 버그 수정"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "3.7~4.4", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "-보너스 스테이지 버그 수정\n"
        set s = s + "-신규 분기 스테이지 추가\n"
        set s = s + "-몇 코스 약간 변경\n"
        set s = s + "-시간 표시 인터페이스 모양 변경\n"
        set s = s + "-금, 식량, 목재 란에 게임 플레이 타임 표시\n"
        set s = s + "-강퇴 명령어 추가(단 게임 시작 후 3분이 지나면 사용 불가)\n"
        set s = s + "2.5: 해변 스테이지 3-2 난이도 너프\n"
        set s = s + "2.6: 해변 스테이지 입장 코드 입력시 이펙트 과자성에 뜨는 버그 수정\n"
        set s = s + "2.7: 3-5화살표 방향 오류 수정, 강퇴 명령어 3분 제한 제거, 해변 보너스 스테이지 시간 증가\n"
        set s = s + "방장 외의 플레이어가 강퇴 가능한 버그 수정\n"
        set s = s + "2.8: 네 번째 비밀 코드 추가, 강퇴 명령어 삭제\n"
        set s = s + "2.9: 네 번째 코드 전용 외형 추가\n"
        set s = s + "3.0: 신규 외형 중력 변환 도중 이미지 짤리는 현상 제거\n"
        set s = s + "3.1: F9 오브젝트 설명 짤린 점 수정, 중력 변환 시 오브젝트들은 회전속도가 다른 점 수정\n"
        set s = s + "3.2: 슬라임 외형 버그 수정, 강퇴 명령어 다시 추가.\n"
        set s = s + "3.3: 강퇴 명령어 오류 수정\n"
        set s = s + "3.4: 좌우키 동시에 누른 상태에서 우측 가속도로 인해 벽에 충돌하면 생기는 버그 수정\n"
        set s = s + "3.5: 3.4 패치내역이 제대로 고쳐지지 않은 점 수정, 해변 3-2 꼼수 수정, 기타\n"
        set s = s + "3.6: 강퇴 명령어 재 입력시 버튼 데이터가 남아있는 버그 수정"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "2.4~3.6", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "2.1\n"
        set s = s + "-코드 외형 추가\n"
        set s = s + "-보너스 스테이지 하향\n"
        set s = s + "-과자 스테이지 코스 약간 변경\n"
        set s = s + "-외형 변경시 현재 외형은 목록에 표시하지 않게 설정\n"
        set s = s + "2.2: 새 외형 추가, 2-6 비행기 밀림 현상 제거, 보너스 스테이지 너프\n"
        set s = s + "2.3: 보너스 스테이지 트랙 오류 수정, 기타 코스 수정"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "2.1~2.3", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "1.5\n"
        set s = s + "-두 번째 분기점 월드 추가\n"
        set s = s + "-세 번째 엔딩 추가\n"
        set s = s + "-새로운 장치 추가\n"
        set s = s + "-2-6 코스 약간 변경\n"
        set s = s + "-외형 변경 코드 추가(과자성 루트 클리어시 획득)\n"
        set s = s + "-문어 블럭 모델 높이 위치 변경\n"
        set s = s + "-음악(music)명령어 추가"
        set s = s + "1.6: 2-6코스 수정\n"
        set s = s + "1.7: 2-7이후 버그 수정\n"
        set s = s + "1.8: 과자 스테이지 3-6 열쇠 위치 오류 수정\n"
        set s = s + "1.9: 코드 타이핑 오류 수정, 배경 오류 수정\n"
        set s = s + "2.0: 버그 수정"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "1.5~2.0", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "1.2: 벽 끼임 방지(완벽하지 않을 수 있음)\n"
        set s = s + "1.3\n"
        set s = s + "-분기점 월드 추가\n"
        set s = s + "-비밀 코드 추가(분기점 월드로 가는데 사용됨)\n"
        set s = s + "-2-8 코스 수정\n"
        set s = s + "-텔레포트 스톤 탑승 점프가 가능한 버그 수정\n"
        set s = s + "1.4\n"
        set s = s + "-코드 출력 잘 보이게 변경\n"
        set s = s + "-분기점 3-8 시간 제한 인원 별로 다르게 설정\n"
        set s = s + "-(1~4명: 30초, 5~6명: 60초, 7명: 180초)\n"
        set s = s + "-두 번째 엔딩(?) 추가\n"
        set s = s + "-엔딩 글자 출력 위치 약간 조절"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "1.2~1.4", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "-사용된 BGM 목록 정확하게 수정\n"
        set s = s + "-워크 1.30 버전에서 일부 배경이 짤려 나오는 점 수정\n"
        set s = s + "-더미 데이터 제거\n"
        set s = s + "-유닛 곂칠시 게임 멈추는 오류 수정\n"
        set s = s + "-점프대에서 뛰는 버섯위에 탑 쌓으면 통과하는 오류 수정\n"
        set s = s + "-머리위에 오브젝트가 있을때 움직이면 멈칫하는 버그 수정\n"
        set s = s + "-위의 버그를 제거하기 위해 오브젝트 밀 때 y축 범위가 약간 감소\n"
        set s = s + "-카운트 다운 명령어 도중 스테이지 넘어가면 자동 종료되게 설정"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "1.1", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "-이동중 아래 방향키 누르면 모션 캔슬되는 오류 수정\n"
        set s = s + "-텔레포트 포탈 공중에서 이용 시 도움말 문구 안 나오는 점 수정\n"
        set s = s + "-열쇠 판정 범위 이상한 점 수정\n"
        set s = s + "-관전자로 볼때 생기는 페이트 필터 오작동 수정\n"
        set s = s + "-카운트 다운 명령어 추가\n"
        set s = s + "-3-4 코스 약간 수정"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "1.0", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "0.7: 워크 배경 음악 제거\n"
        set s = s + "0.8: 점프력 약간 증가, 방향키 아래를 누르면 모션이 나오게 설정\n"
        set s = s + "0.9: 0.8버전에서 발생하는 텔레포트 포탈 오작동 수정"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "0.7~0.9", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "-3-4 코스 약간 수정\n"
        set s = s + "-F9 아이콘 변경\n"
        set s = s + "-플레이어 나갈 시 메뉴판 최신화 오류 수정"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "0.6", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "-3-5 시간제한 90 → 120초로 변경\n"
        set s = s + "-빨강 나가면 재시작 권한 빨강이 받는 기능 오류 수정\n"
        set s = s + "-코스 재조정\n"
        set s = s + "-기타 잡버그 해결"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "0.5", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "0.1: 최초 버전\n"
        set s = s + "0.2: 월드 3 난이도 대폭 하향\n"
        set s = s + "0.3: 코스 수정, 단체로 밀면 유닛 통과 하는 버그 수정, 월드 1 노래 길이 변경\n"
        set s = s + "0.4: 텍스트 출력 버그 제거"
        call CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "0.1~0.4", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomPinkIcon.blp" )
        set s = "소개팅 약속이 잡힌 주황버섯!\n"
        set s = s + "그런데 약속 장소로 가는 길의 상태가(?)\n"
        set s = s + "다 같이 협동하여 소개팅 장소로 데려다 주세요!\n\n"
        set s = s + "-모든 주황버섯이 포탈로 들어가면 레벨이 통과됩니다.\n"
        set s = s + "-방장이 'ESC'를 누르면 다시 시작하며 컨티뉴를 하나 소모합니다.\n"
        set s = s + "-모든 컨티뉴를 소모하면 패배합니다.\n"
        set s = s + "-컨티뉴는 한 월드를 클리어하면 20으로 초기화됩니다.\n"
        set s = s + "\n"
        set s = s + "제작: 2p4p, JungHun\n"
        set s = s + "원작자: z1z1z1"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "게임 설명", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = "● 방장 명령어\n"
        set s = s + "-카운트 (2~10) / -count (2~10)\n"
        set s = s + "카운트다운을 합니다. 팀원과 호홉을 맞출때 사용하면 좋습니다.\n"
        set s = s + "\n"
        set s = s + "-강퇴 / -kick\n"
        set s = s + "원하는 플레이어를 투표를 통해 강제로 퇴장시킵니다.\n"
        set s = s + "사용하고 나면 1분의 재사용 대기시간이 존재합니다.\n"
        set s = s + "\n"
        set s = s + "-스킵 ??? / -skip ???(첫 번째 비밀 코드 기입)\n"
        set s = s + "1-1에서만 사용 가능하며, 2-8로 스킵할 수 있습니다.\n"
        set s = s + "첫번째 비밀 코드는 일반 스테이지를 클리어하면 얻을 수 있습니다.\n"
        set s = s + "\n"
        set s = s + "● 전체 명령어\n"
        set s = s + "-음악 / -music\n"
        set s = s + "배경음악을 정지 또는 재생합니다.\n"
        set s = s + "\n"
        set s = s + "-관전 / -obs / -observe\n"
        set s = s + "다른 플레이어를 관전할 수 있습니다.\n"
        set s = s + "명령어를 다시 입력하면 관전을 종료합니다.\n"
        set s = s + "\n"
        set s = s + "-진동끄기\n"
        set s = s + "석상 오브젝트의 진동을 끕니다.\n"
        set s = s + "\n"
        set s = s + "-진동켜기\n"
        set s = s + "석상 오브젝트의 진동을 켭니다.\n"
        set s = s + "\n"
        set s = s + "-재선택\n"
        set s = s + "현재 스테이지를 변경합니다.\n"
        set s = s + "총 2번 사용할 수 있으며, 랜덤 월드에서만 사용할 수 있습니다."
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "명령어1", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = "● 전체 명령어\n"
        set s = s + "-연습모드\n"
        set s = s + "연습모드로 변경합니다.\n"
        set s = s + "1-1 에서만 사용할 수 있습니다.\n"
        set s = s + "연습모드 상태에서는 클리어를 할 수 없습니다.\n"
        set s = s + "연습모드는 다시 해제할 수 없습니다.\n"
        set s = s + "연습모드를 사용 후 F9에 뜨는 연습모드 명령어를 참고하여 주십시오.\n"
        set s = s + "\n"
        set s = s + "-코드확인\n"
        set s = s + "흭득한 코드를 보여줍니다."
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "명령어2", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = "● C\n"
        set s = s + "- 카운트 3 을 실행합니다.\n"
        set s = s + "- 방장만 사용할 수 있습니다.\n\n"
        set s = s + "● V\n"
        set s = s + "- 다른사람을 관전합니다.\n"
        set s = s + "- 다시 입력하면 관전이 해제됩니다.\n\n"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "단축키", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = "● 상자\n"
        set s = s + "-밟고 올라가거나 밀어서 옮길 수 있습니다.\n"
        set s = s + "\n"
        set s = s + "● 열쇠\n"
        set s = s + "-열쇠 색깔과 같은 블럭을 모두 제거합니다.\n"
        set s = s + "-가끔 열쇠 색깔과 같은 블럭을 생성합니다.\n"
        set s = s + "-다른 오브젝트로도 작동시킬 수 있습니다.(상자, 문어 블럭)\n"
        set s = s + "\n"
        set s = s + "● 문어 블럭\n"
        set s = s + "-상자와 비슷하지만 정해진 방향으로 고정 이동합니다.\n"
        set s = s + "\n"
        set s = s + "● 비행기\n"
        set s = s + "-공중 발판입니다.\n"
        set s = s + "-위에 오브젝트(상자, 문어블럭)를 올릴 수도 있습니다.\n"
        set s = s + "\n"
        set s = s + "● 슬라임\n"
        set s = s + "-밟으면 6칸 점프합니다.\n"
        set s = s + "-오브젝트(상자, 문어블럭)도 밟으면 점프합니다.\n"
        set s = s + "\n"
        set s = s + "● 텔레포트 스톤\n"
        set s = s + "-아래 방향키를 누르면 같은 색의 스톤으로 이동합니다.\n"
        set s = s + "-자신이 무엇을 밟고 있을때만 작동합니다.\n"
        set s = s + "-즉 공중에서 탈려면 오브젝트(버섯, 상자, 문어 블럭)를 타고 있어야 합니다.\n"
        set s = s + "-상자, 문어 블럭을 밟은 상태에서 이동할 시 같이 이동합니다."
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "오브젝트 설명", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = "● 분홍 문어 블럭\n"
        set s = s + "-문어 블럭과 동일하나 벽에 부딪치면 방향을 바꿉니다.\n"
        set s = s + "\n"
        set s = s + "● 스톤볼\n"
        set s = s + "-파란 벽돌이 맞으면 부숴지는 빔을 발사합니다.\n"
        set s = s + "\n"
        set s = s + "● 트랙\n"
        set s = s + "-밟고 있으면 화살표 방향으로 움직입니다.\n"
        set s = s + "\n"
        set s = s + "● 중력 변환기\n"
        set s = s + "-맵을 180도 회전시킵니다.\n"
        set s = s + "-다른 오브젝트로도 작동시킬 수 있습니다.(상자, 문어 블럭)\n"
        set s = s + "\n"
        set s = s + "● 물\n"
        set s = s + "-물 속에서 방향키(↑)를 누르면 수영할 수 있습니다.\n"
        set s = s + "-또한 방향키(↓)를 누르고 있으면 빠르게 하강합니다.\n"
        set s = s + "\n"
        set s = s + "● 마법 활\n"
        set s = s + "-충돌하면 활이 보는 방향으로 발사합니다.\n"
        set s = s + "-가속도가 붙은 상태에서 오브젝트와 충돌하면 밀쳐집니다.\n"
        set s = s + "\n"
        set s = s + "● 코-크 버섯\n"
        set s = s + "-문어 블럭과 동일하나 밟으면 3칸 점프합니다.\n"
        set s = s + "-오브젝트(상자, 문어블럭)도 밟으면 점프합니다.\n"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "오브젝트 설명2", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = "● 푸른 비석\n"
        set s = s + "-비석에 표시된 오브젝트로 변신합니다.\n"
        set s = s + "-변신을 풀지 않으면 출구 포탈을 이용할 수 없습니다.\n"
        set s = s + "-비행기로 변신하면 특정 오브젝트를 건들 수 없습니다(예: 열쇠, 슬라임, 마법 활)\n"
        set s = s + "\n"
        set s = s + "● 초록 비석\n"
        set s = s + "-변신을 해제하여 원래 모습으로 돌아옵니다.\n"
        set s = s + "\n"
        set s = s + "● 블랙홀\n"
        set s = s + "-같은 색의 블랙홀로 이동합니다.\n"
        set s = s + "\n"
        set s = s + "● 석상\n"
        set s = s + "-석상에 접촉시 특정 블럭이 사라지며, 특정 블럭이 생성됩니다.\n"
        set s = s + "-석상에서 떨어지면 다시 원래 상태로 돌아갑니다.\n"
        set s = s + "\n"
        set s = s + "● 보름달\n"
        set s = s + "-아래 방향키를 누르면 같은 색의 보름달에 있는 오브젝트와 바꿔치기 합니다.\n"
        set s = s + "-텔레포트 스톤과 다르게 공중에서도 작동됩니다.\n"
        set s = s + "-반드시 반대쪽에도 오브젝트가 있어야 작동합니다.\n"
        set s = s + "-반대쪽 보름달에 여러 오브젝트가 같이 있다면 반드시 최상단에 있는 오브젝트와 바꿔치기 합니다.\n"
        set s = s + "\n"
        set s = s + "● 깨비 블럭\n"
        set s = s + "-문어 블럭과 동일하나, 깨비 블럭 위에서 방향키(↓)를 누르면 영혼 상태로 변신합니다.\n"
        set s = s + "\n"
        set s = s + "● 깨비(영혼)\n"
        set s = s + "-문어 블럭과 동일하나, 공중에 떠있습니다. 깨비(영혼) 위에서 방향키(↓)를 누르면 다시 블럭 상태로 돌아옵니다."
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "오브젝트 설명3", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = "2-8에 분기점 입구가 있습니다.\n"
        set s = s + "이 곳에 입장하기 위해선 호스트가 비밀 코드를 입력하셔야 합니다.\n"
        set s = s + "첫 번째 비밀 코드는 기존 스테이지를 전부 클리어해서 얻으며,\n"
        set s = s + "두 번째 비밀 코드는 지하철 루트 스테이지를 전부 클리어하면 얻습니다.\n"
        set s = s + "참고로 비밀 암호는 RPG 세이브 코드처럼 닉네임마다 다르니 주의하세요!"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "분기점?", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = TeamColor[7] + "쉬움|r : 1.62%, " + TeamColor[5] + "보통|r : 1.21%, " + TeamColor[6] + "어려움|r : 0.81%," + TeamColor[1] + " 매우어려움|r : 0.4%\n\n"
        set s = s + "--- 핑크핑크 ---:\n"
        set s = s + "  3-1 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-2 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-3 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-4 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-5 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-6 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-7 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-8 : " + TeamColor[7] + "쉬움|r( 1.62% )\n\n"
        set s = s + "--- 도시 ---:\n"
        set s = s + "  3-1 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-2 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-3 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-4 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-5 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-6 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-7 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-8 : " + TeamColor[7] + "쉬움|r( 1.62% )\n\n"
        set s = s + "--- 발렌타인 ---:\n"
        set s = s + "  3-1 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-2 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-3 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-4 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-5 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-6 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-7 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-8 : " + TeamColor[7] + "쉬움|r( 1.62% )\n\n"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "랜덤 월드 확률표1", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = TeamColor[7] + "쉬움|r : 1.62%, " + TeamColor[5] + "보통|r : 1.21%, " + TeamColor[6] + "어려움|r : 0.81%," + TeamColor[1] + " 매우어려움|r : 0.4%\n\n"
        set s = s + "--- 해변 ---:\n"
        set s = s + "  3-1 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-2 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-3 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-4 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-5 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-6 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-7 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-8 : " + TeamColor[7] + "쉬움|r( 1.62% )\n\n"
        set s = s + "--- 코크타운 ---:\n"
        set s = s + "  3-1 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-2 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-3 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-4 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-5 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-6 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-7 : " + TeamColor[7] + "쉬움|r( 1.62% )\n"
        set s = s + "  3-8 : " + TeamColor[7] + "쉬움|r( 1.62% )\n\n"
        set s = s + "--- 월드 챌린지 ---:\n"
        set s = s + "  3-1 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-2 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-3 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-4 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-5 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-6 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-7 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n\n"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "랜덤 월드 확률표2", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = TeamColor[7] + "쉬움|r : 1.62%, " + TeamColor[5] + "보통|r : 1.21%, " + TeamColor[6] + "어려움|r : 0.81%," + TeamColor[1] + " 매우어려움|r : 0.4%\n\n"
        set s = s + "--- 카페 ---:\n"
        set s = s + "  3-1 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-2 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-3 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-4 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-5 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-6 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-7 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-8 : " + TeamColor[6] + "어려움|r( 0.81% )\n\n"
        set s = s + "--- 사막 ---:\n"
        set s = s + "  3-1 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-2 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-3 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-4 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-5 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-6 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-7 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-8 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n\n"
        set s = s + "--- 엘린 숲 ---:\n"
        set s = s + "  3-1 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-2 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-3 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-4 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-5 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n\n"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "랜덤 월드 확률표3", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = TeamColor[7] + "쉬움|r : 1.62%, " + TeamColor[5] + "보통|r : 1.21%, " + TeamColor[6] + "어려움|r : 0.81%," + TeamColor[1] + " 매우어려움|r : 0.4%\n\n"
        set s = s + "--- 얼음 동굴 ---:\n"
        set s = s + "  3-1 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-2 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-3 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-4 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-5 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-6 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-7 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-8 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n\n"
        set s = s + "--- 깊은 산속 ---:\n"
        set s = s + "  3-1 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-2 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-3 : " + TeamColor[5] + "보통|r( 1.21% )\n"
        set s = s + "  3-4 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-5 : " + TeamColor[6] + "어려움|r( 0.81% )\n"
        set s = s + "  3-6 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-7 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n"
        set s = s + "  3-8 : " + TeamColor[1] + "매우 어려움|r( 0.4% )\n\n"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "랜덤 월드 확률표4", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = "● Kirby Super Star Ultra - Green Greens\n"
        set s = s + "● Sword Lord - William tell Overture Remix\n"
        set s = s + "● Captain Jack - Captain Jack\n"
        set s = s + "● Virtual Riot - Energy Drink\n"
        set s = s + "● OMFG - Hello\n"
        set s = s + "● Waterflame - Swirl!\n"
        set s = s + "● Maple Story - Coke Town\n"
        set s = s + "● EverPlanet - Skylight Harbor\n"
        set s = s + "● Maple Story - Ariant Remix\n"
        set s = s + "● Maple Story - The Tune of the Azure Light\n"
        set s = s + "● Waterflame - Red - Layerz OST\n"
        set s = s + "● Waterflame - Everybody Bounce"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "사용된 BGM", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
    endfunction

    private function SetLongQuest takes nothing returns nothing
        call DzFrameSetAbsolutePoint(DzFrameFindByName("QuestDisplay", 0), JN_FRAMEPOINT_TOPLEFT, 0.2, 0.36)
        call DzFrameSetAbsolutePoint(DzFrameFindByName("QuestDisplay", 0), JN_FRAMEPOINT_BOTTOMRIGHT, 0.6, 0.22)
    endfunction

    private function GameSaveDisable takes nothing returns nothing
        call DzFrameSetEnable(DzFrameFindByName("PauseButton", 0), false)
        //일시 정지 버튼 비활성화 & 숨김
        call DzFrameShow(DzFrameFindByName("PauseButton", 0), false)
        
        //게임 저장 버튼 비활성화
        call DzFrameSetEnable(DzFrameFindByName("SaveGameButton", 0), false)
        call DzFrameSetEnable(DzFrameFindByName("SaveGameSaveButton", 0), false)
        call DzFrameShow(DzFrameFindByName("SaveGameSaveButton", 0), false)
        call DzFrameSetEnable(DzFrameFindByName("OverwriteOverwriteButton", 0), false)
        call DzFrameSetEnable(DzFrameFindByName("SaveGameFileEditBox", 0), false)
        call DzFrameShow(DzFrameFindByName("SaveGameFileEditBox", 0), false)
    endfunction
    
    private function EasterEggHide takes nothing returns nothing
        // World Challenge entrance
        call SetDoodadAnimation(6144, -448, 128.00, 'YOf3', false, "death", false)

        // Maze
        call SetDoodadAnimation(22396, -31293, 128.00, 'D00A', false, "Death", false)
        call SetDoodadAnimation(22396, -31548, 128.00, 'YOf3', false, "Death", false)
        call SetDoodadAnimation(16256 + (128 * 23), -27648 - (128 * 15), 128.00, 'VOfl', false, "Death", false)
        call SetDoodadAnimation(16701, -27520, 128.00, 'VOfl', false, "Death", false)

        // Maze Water
        call SetDoodadAnimation(16383, -27392, 128.00, 'DObw', false, "Death", false)
        call SetDoodadAnimation(16383 + 128, -27392, 128.00, 'YObb', false, "Death", false)
        call SetDoodadAnimation(16383 + 256, -27392, 128.00, 'YOwb', false, "Death", false)
        call SetDoodadAnimation(16383 + 384, -27392, 128.00, 'LOic', false, "Death", false)
        call SetDoodadAnimation(16383 + 512, -27392, 128.00, 'YObw', false, "Death", false)
        call SetDoodadAnimation(16383 + 640, -27392, 128.00, 'IOsm', false, "Death", false)

        // CaveEnding
        call SetDoodadAnimation(27584, -29504, 128.00, 'D00A', false, "Death", false)
    endfunction

    private function Main takes nothing returns nothing
        call PauseGame(true)
        call PauseGame(false)
        call PauseGame(true)
        call PauseGame(false)
        call PauseGame(true)
        call PauseGame(false)
        call DzFrameHideInterface()
        call DzFrameEditBlackBorders(0, 0)
        call DzFrameSetAbsolutePoint(DzFrameGetChatMessage(), JN_FRAMEPOINT_LEFT, 0.02, 0.4)
        call DzFrameSetAbsolutePoint(DzFrameGetUnitMessage(), JN_FRAMEPOINT_CENTER, 0.3, 0.4)
        call DzFrameShow(DzFrameGetMinimap(), false)
        call DestroyTrigger( GetTriggeringTrigger() )
        call EnableDragSelect( false, false )
        call FogEnable(false)
        call FogMaskEnable(false)
        call SetFloatGameState(GAME_STATE_TIME_OF_DAY, 12)
        call SetTimeOfDayScale(0)
        call StopMusic(false)
        call PlayMusic(".mp3")
        call SetMusicVolume(127)
        call SetPlayerColorBJ( Player(11), ConvertPlayerColor(12), true )
        call EasterEggHide()
        call PlayersCheck()
        call Quest()
        call GameSaveDisable()
        call JNSetSyncDelay(15)
        
        call Multiboard_CreateMenu()
        call Stage_Clear(1)
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        

        call TriggerRegisterTimerEvent(t, 0.00, false)
        call TriggerAddAction( t, function Main )

        set t = CreateTrigger()

        debug if false then
            call TriggerRegisterTimerEvent(t, 0.02, true)
            call TriggerAddAction( t, function SetLongQuest )
        debug endif
        
        set t = null
    endfunction
endscope