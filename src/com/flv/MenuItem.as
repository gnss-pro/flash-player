package com.flv
{
    import flash.events.*;
    import flash.external.*;
    import flash.ui.*;

    public class MenuItem extends Object
    {
        public var menuId:String;
        public var menuName:String;
        public var item:ContextMenuItem;
        var id:int;

        public function MenuItem(param1:String, param2:String, param3:int, param4:int)
        {
            this.id = param4;
            this.menuId = param1;
            this.menuName = param2;
            this.item = new ContextMenuItem(param2);
            if (param3 == 1)
            {
                this.item.separatorBefore = true;
            }
            this.item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onMenu);
            return;
        }// end function

        function onMenu(event:ContextMenuEvent)
        {
            trace("index " + this.id + " menuid" + this.menuId);
            ExternalInterface.call("onTtxVideoRightMenu", "" + this.id + "", this.menuId);
            return;
        }// end function

        public function del():void
        {
            this.item.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onMenu);
            this.item = null;
            return;
        }// end function

    }
}
