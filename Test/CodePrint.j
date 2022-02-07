library CodePrint initializer Init
    private function Trig_codePrint_Actions takes nothing returns nothing
        local integer i = 1
        local integer saveIntName
        local integer array CharCode
        local string array Code
        local string array Code2
        local string array Code3
        local string array Code4
        local string array Code5
        local string array Code6
        local string array Code7
        local string array Code8
        local string array Code9
        local string array Code10
        local string array Code11
        local string array Code12
	    local string s = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        local string userChat = SubString(GetEventPlayerChatString(), 1, StringLength(GetEventPlayerChatString()))

        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "//==================")

        set saveIntName = StringHash(userChat)
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code[i] = Code[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code[i] = Code[i] + SubString(s,CharCode[3],CharCode[3]+1)
        
        set saveIntName = StringHash(Code[i])
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code2[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code2[i] = Code2[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code2[i] = Code2[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "캡틴: " + Code[i])
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "지하철: " + Code2[i])
        
        set saveIntName = StringHash(Code2[i])
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code3[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code3[i] = Code3[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code3[i] = Code3[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "발렌: " + Code3[i])
        
        set saveIntName = StringHash(Code3[i])
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code4[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code4[i] = Code4[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code4[i] = Code4[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "해변: " + Code4[i])
        
        set saveIntName = StringHash(I2S(StringHash(userChat)))
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code5[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code5[i] = Code5[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code5[i] = Code5[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "코크: " + Code5[i])
        
        set saveIntName = StringHash(Code5[i])
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code6[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code6[i] = Code6[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code6[i] = Code6[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "카페: " + Code6[i])
        
        set saveIntName = StringHash(Code6[i])
        set saveIntName = StringHash(I2S(saveIntName))
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code7[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code7[i] = Code7[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code7[i] = Code7[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "사막: " + Code7[i])
        
        set saveIntName = StringHash(Code5[i])
        set saveIntName = StringHash(I2S(saveIntName))
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code8[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code8[i] = Code8[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code8[i] = Code8[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "월드: " + Code8[i])
        
        set saveIntName = StringHash(Code8[i])
        set saveIntName = StringHash(I2S(saveIntName))
        set saveIntName = StringHash(I2S(saveIntName))
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code9[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code9[i] = Code9[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code9[i] = Code9[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "엘린숲: " + Code9[i])
        
        set saveIntName = StringHash(Code7[i])
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code10[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code10[i] = Code10[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code10[i] = Code10[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "랜덤: " + Code10[i])

        set saveIntName = StringHash(Code10[i])
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code11[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code11[i] = Code11[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code11[i] = Code11[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "얼음 동굴: " + Code11[i])

        set saveIntName = StringHash(Code11[i])
        if saveIntName < 0 then
            set saveIntName = saveIntName * -1
        endif
        if saveIntName < 100000 then
            set saveIntName = saveIntName + 100000
        endif
        set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
        set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
        set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
        set Code12[i] = SubString(s,CharCode[1],CharCode[1]+1)
        set Code12[i] = Code12[i] + SubString(s,CharCode[2],CharCode[2]+1)
        set Code12[i] = Code12[i] + SubString(s,CharCode[3],CharCode[3]+1)
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "아랫 마을: " + Code12[i])
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        call TriggerRegisterPlayerChatEvent( t, Player(0), "@", false )
        call TriggerAddAction( t, function Trig_codePrint_Actions )
        set t = null
    endfunction
 
endlibrary