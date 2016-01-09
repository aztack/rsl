package com.tudou.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 8088
	 */
	public class TweenEvent extends Event 
	{
		public static const START:String = "tweenStart";
        public static const UPDATE:String = "tweenUpdate";
        public static const END:String = "tweenEnd";
		
		public function TweenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TweenEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{
			return formatToString("TweenEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}