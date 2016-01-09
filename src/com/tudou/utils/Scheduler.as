package com.tudou.utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import com.tudou.events.*;
	/**
	 +------------------------------------------------
	 * AS3.0 Scheduler CODE schedule anything
	 +------------------------------------------------ 
	 * @author 8088 at 2011-11-02
	 * version: 1.0
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class Scheduler extends EventDispatcher
	{
		protected var interval:Number = 0;
		protected var lastTick:Number = -1;
		protected var timeout:Number = Infinity;
		protected var start:Number;
		protected var elapsedTimeAtPause:Number = 0;
		protected var endHandler:Function;
		protected var next:Scheduler;
		protected var previous:Scheduler;
		protected var lastVisited:Number = -1;
		protected var tickHandler:Function;
		
		public static var clock:Function = getTimer;
		
		private static var clockHandler:Function = run;
		private static var stage:Object;
		private static var lastExecuted:Number = 0;
		private static var ticker:Sprite;
		private static var blank:Scheduler = new Scheduler;
		private static var head:Scheduler;
		private static var current:Scheduler;
		
		private static const TIMEOUT:int = 1000;
		private static const MIN_FPS:Number = 4;
		private static const MAX_FPS:Number = 24;
		private static const CANONICAL_END_EVENT:SchedulerEvent = new SchedulerEvent(SchedulerEvent.END, 0);
		private static const CANONICAL_TICK_EVENT:SchedulerEvent = new SchedulerEvent(SchedulerEvent.TICK, 0);
		
		public function Scheduler(_timeout:Number = Infinity, _interval:Number = 0):void
		{
			this.endHandler = this.noop;
			this.tickHandler = this.noop;
			if (! ticker && blank)
			{
				ticker = new Sprite();
				resetClockHandler(clockHandler);
			}
			this.timeout = _timeout;
			this.interval = _interval;
			if (blank)
			{
				this.restart();
			}
		}
		
		protected function noop(evt:Event=null):void
		{
			return;
		}
		
		override public function dispatchEvent(evt:Event):Boolean
		{
			switch (evt.type)
			{
				case SchedulerEvent.END :
					this.endHandler(evt);
					break;
				case SchedulerEvent.TICK :
					this.tickHandler(evt);
					break;
				default :
					super.dispatchEvent(evt);
					break;
			}
			return true;
		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			switch (type)
			{
				case SchedulerEvent.END :
					this.endHandler = this.endHandler == this.noop? listener : (super.dispatchEvent);
					break;
				case SchedulerEvent.TICK :
					this.tickHandler = this.tickHandler == this.noop? listener : (super.dispatchEvent);
					break;
				default :
					break;
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			this.endHandler = (type == SchedulerEvent.END && this.endHandler == listener)? (this.noop) : (this.endHandler);
			this.tickHandler = (type == SchedulerEvent.TICK && this.tickHandler == listener)? (this.noop) : (this.tickHandler);
			super.removeEventListener(type, listener, useCapture);
		}
		
		//
		private static function run(evt:Event = null):void
		{
			var schedule:Scheduler;
			var elapsed:Number;
			var frameRate:Number;
			var t:* = clock();
			var timeElapsed:* = t - lastExecuted;
			lastExecuted = t;
			if (timeElapsed >= TIMEOUT)
			{
				return; //init Scheduler
			}
			
			current = head;
			var minInterval:* = Infinity;
			while (current && current.lastVisited < t)
			{
				schedule = current;
				schedule.lastVisited = t;
				elapsed = t - schedule.start;
				if (schedule.isTickable(t))
				{
					CANONICAL_TICK_EVENT.elapsed = elapsed;
					schedule.lastTick = t;
					schedule.dispatchEvent(CANONICAL_TICK_EVENT);
				}
				if (elapsed >= schedule.timeout)
				{
					CANONICAL_END_EVENT.elapsed = elapsed;
					schedule.dispatchEvent(CANONICAL_END_EVENT);
					schedule.stop();
				}
				else{
					minInterval = Math.min(minInterval, schedule.interval);
				}
				current = current.next;
			}
			current = null;
			blank.next = null;
			if (stage)
			{
				minInterval = Math.max(minInterval,1);
				frameRate = Math.max(MIN_FPS, Math.min(1000 / minInterval, MAX_FPS));
				try
				{
					if (stage.frameRate != frameRate)
					{
						//set stage frame rate 4~24
						stage.frameRate = frameRate;
					}
				}
				catch (err:SecurityError){
					stage = null;
				}
			}
		}
		public function pause():void
		{
			if (this.isRunning())
			{
				this.stop();
				this.elapsedTimeAtPause = clock() - this.start;
			}
		}
		
		public function isRunning():Boolean
		{
			return this.next || this.previous || head == this;
		}
		
		public function resume():void
		{
			var _p_n:Number = NaN;
			if (! this.isRunning())
			{
				_p_n = this.elapsedTimeAtPause;
				this.restart();
				this.start = this.start - _p_n;
			}
		}
		
		public function restart():void
		{
			this.elapsedTimeAtPause = 0;
			this.start = clock();
			if (! this.previous && ! this.next)
			{
				if (head && head !=this)
				{
					head.previous = this;
					this.next = head;
				}
				head = this;
			}
		}
		
		public function isTickable(num:Number):Boolean
		{
			return num - this.lastTick >= this.interval;
		}
		
		public function stop():void
		{
			if (current == this || current == blank && blank.next == this)
			{
				blank.next = this.next;
				current = blank;
			}
			if (this.previous)
			{
				this.previous.next = this.next;
			}
			if (this.next)
			{
				this.next.previous = this.previous;
			}
			if (head == this)
			{
				head = this.next;
			}
			previous = null;
			next = null;
			elapsedTimeAtPause = 0;
		}
		//
		public static function resetClockHandler(f:Function = null):void
		{
			f = f || run;
			if (ticker)
			{
				ticker.removeEventListener(Event.ENTER_FRAME, clockHandler);
				ticker.addEventListener(Event.ENTER_FRAME, f, false, 0, true);
			}
			clockHandler = f;
		}
		
		public static function composeClockHandler(h:Function):void
		{
			var f:* = h;
			var handler:* = function(...args):void
			{
				args.unshift(run);
				f.apply(null, args);
				return;
			};
			resetClockHandler(handler);
		}
		
		public static function setInterval(time:Number, listener:Function):Scheduler
		{
			var scheduler:* = new Scheduler(Infinity,time);
			scheduler.addEventListener(SchedulerEvent.TICK, listener);
			return scheduler;
		}
		
		public static function setTimeout(time:Number, listener:Function):Scheduler
		{
			var scheduler:* = new Scheduler(time, Infinity);
			scheduler.addEventListener(SchedulerEvent.END, listener);
			return scheduler;
		}
		
		public static function setFrameRateOf(obj:Object):void
		{
			Scheduler.stage = obj;
		}
		//OVER
	}

}