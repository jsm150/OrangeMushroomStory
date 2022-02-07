//! textmacro for takes init, condition
    $init$
    loop
        exitwhen not($condition$)
//! endtextmacro

//! textmacro for_end takes increase
    $increase$
    endloop
//! endtextmacro