package com.tudou.events 
{
	import flash.events.Event;
	/**
	 +------------------------------------------------
	 * AS3.0 SchedulerEvent CODE scheduler event
	 +------------------------------------------------ 
	 * @author 8088 at 2011-11-02
	 * version: 1.0
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class SchedulerEvent extends Event
	{
		public var elapsed:Number;
		public static const END:String = "end";
		public static const TICK:String = "tick";
		public function SchedulerEvent(type:String, num:Number) 
		{
			this.elapsed = num;
			super(type, false, false);
		}
		override public function clone():Event
		{
			return new SchedulerEvent(type, this.elapsed);
		}
	}

}