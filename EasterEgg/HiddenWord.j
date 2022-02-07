library HiddenWord initializer init
    globals
        private rect array CompareRect
        private string array word
        endglobals
    
    public function Main takes integer i returns nothing
        local integer j = 1
        
        loop
        exitwhen CompareRect[j] == null
            if RectContainsUnit(CompareRect[j], OrangeMushroom[i]) == true then
                call DisplayTimedTextToForce( GetPlayersAll(), 0.05, word[j])
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(CompareRect[j]), GetRectCenterY(CompareRect[j]) ))
                return
            endif
            set j = j + 1
        endloop
    endfunction
    
    private function SetRect takes rect r, integer i, string s returns nothing
        set CompareRect[i] = r
        set word[i] = s
        set r = null
    endfunction
    
    private function init takes nothing returns nothing
        call SetRect(gg_rct_HiddenWord001, 1, "-E??????????")
        call SetRect(gg_rct_HiddenWord002, 2, "-?L?????????")
        call SetRect(gg_rct_HiddenWord003, 3, "-??L????????")
        call SetRect(gg_rct_HiddenWord004, 4, "-???I???????")
        call SetRect(gg_rct_HiddenWord005, 5, "-????N??????")
        call SetRect(gg_rct_HiddenWord006, 6, "-?????F?????")
        call SetRect(gg_rct_HiddenWord007, 7, "-??????O????")
        call SetRect(gg_rct_HiddenWord008, 8, "-???????R???")
        call SetRect(gg_rct_HiddenWord009, 9, "-????????E??")
        call SetRect(gg_rct_HiddenWord010, 10, "-?????????S?")
        call SetRect(gg_rct_HiddenWord011, 11, "-??????????T")
    endfunction
endlibrary