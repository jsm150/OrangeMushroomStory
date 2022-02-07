scope SkinFrame initializer Init
    globals
        
    endglobals


    private function Init takes nothing returns nothing
        local integer A = DzCreateFrame("ScriptDialogButton", DzGetGameUI(), 0)
        call DzFrameSetAbsolutePoint(A, JN_FRAMEPOINT_CENTER, 0.275, 0.35)
        call DzFrameSetSize(A, 0.04, 0.04)
    endfunction
endscope