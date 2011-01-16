package jp.takkjoga.khaki.events
{

import flash.events.Event;

public class PopUpCloseEvent extends Event
{
    public static const POP_UP_CLOSE:String = "popUpClose";

    public function PopUpCloseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
    {
        super(type, bubbles, cancelable);
    }
}
}
