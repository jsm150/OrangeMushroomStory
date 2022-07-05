//! textmacro LinkedList_Foreach_Top takes nodeName, containerName
    set $nodeName$ = $containerName$.First
    loop
    exitwhen node == 0
//! endtextmacro

//! textmacro LinkedList_Foreach_Bottom
    set node = node.Next
    endloop
//! endtextmacro

//! textmacro Make_LinkedList takes Type, Init
    public struct $Type$Node
        public $Type$ Item
        public $Type$Node Next = 0
        public $Type$Node Prev = 0

        public method destroy takes nothing returns nothing
            set this.Next = 0
            set this.Prev = 0
            set this.Item = $Init$
            call thistype.deallocate(this)
        endmethod

        public static method create takes $Type$ t returns thistype
            local thistype this = thistype.allocate()
            set this.Item = t
            return this
        endmethod
    endstruct

    public struct $Type$LinkedList
        public integer Count = 0
        public $Type$Node First = 0
        public $Type$Node Last = 0

        public method destroy takes nothing returns nothing
            call this.Clear()
            call thistype.deallocate(this)
        endmethod

        public method Contains takes $Type$ arg returns boolean
            local $Type$Node node = this.First
                
            loop
                exitwhen node == 0
                if node.Item == arg then
                    return true
                endif
                set node = node.Next
            endloop

            return false
        endmethod

        public method Clear takes nothing returns nothing
            local $Type$Node node = this.First
            local $Type$Node next

            loop
                exitwhen node == 0
                set next = node.Next
                call node.destroy()
                set node = next
            endloop

            set this.First = 0
            set this.Last = 0
            set this.Count = 0
        endmethod

        public method RemoveNode takes $Type$Node node returns nothing
            local $Type$Node next = node.Next
            local $Type$Node prev = node.Prev

            if this.Last == node then
                set this.Last = prev
            else
                set next.Prev = prev
            endif

            if this.First == node then
                set this.First = next
            else
                set prev.Next = next
            endif

            set this.Count = this.Count - 1
            call node.destroy()
        endmethod

        public method Remove takes $Type$ arg returns nothing
            local $Type$Node node = this.First
            local $Type$Node next
            local $Type$Node prev

            loop
                exitwhen node == 0
                if node.Item == arg then
                    call this.RemoveNode(node)
                    return
                endif
                set node = node.Next
            endloop
        endmethod

        public method RemoveAll takes $Type$ arg returns nothing
            local $Type$Node node = this.First
            local $Type$Node next
            local $Type$Node prev

            loop
                exitwhen node == 0
                set next = node.Next

                if node.Item == arg then
                    call this.RemoveNode(node)
                endif

                set node = next
            endloop
        endmethod
        
        public method RemoveFirst takes nothing returns nothing
            local $Type$Node first = this.First
            if first == 0 then
                return
            endif
            set this.First = first.Next
            set this.First.Prev = 0
            set this.Count = this.Count - 1
            call first.destroy()
        endmethod

        public method RemoveLast takes nothing returns nothing
            local $Type$Node last = this.Last
            if last == 0 then
                return
            endif
            set this.Last = last.Prev
            set this.Last.Next = 0
            set this.Count = this.Count - 1
            call last.destroy()
        endmethod

        public method AddFirst takes $Type$ t returns nothing
            local $Type$Node node = $Type$Node.create(t)

            if this.First != 0 then
                set this.First.Prev = node
                set node.Next = this.First
            elseif this.Last == 0 then
                set this.Last = node
            endif
            set this.First = node
            set this.Count = this.Count + 1
        endmethod

        public method AddLast takes $Type$ t returns nothing
            local $Type$Node node = $Type$Node.create(t)

            if this.Last != 0 then
                set this.Last.Next = node
                set node.Prev = this.Last
            elseif this.First == 0 then
                set this.First = node
            endif
            set this.Last = node
            set this.Count = this.Count + 1
        endmethod
    endstruct
//! endtextmacro

//! textmacro Make_Container takes StructName, Count
    public struct $StructName$Container
        private boolean destroyed = false
        private integer array Item[$Count$]

        integer Count = $Count$
        
        method operator [] takes integer i returns $StructName$
            return Item[i]
        endmethod

        method operator []= takes integer i, $StructName$ obj returns nothing
            set Item[i] = obj
        endmethod

        method destroy takes nothing returns nothing
            local integer i = 0
            local $StructName$ obj

            loop
                exitwhen i >= this.Count
                set obj = Item[i]
                if obj > 0 then
                    call obj.destroy()
                endif
                set i = i + 1
            endloop
            
            if this.destroyed == false then
                call thistype.deallocate(this)
                set this.destroyed = true
            endif
        endmethod
    endstruct
//! endtextmacro