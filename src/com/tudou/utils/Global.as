package com.tudou.utils 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.errors.IllegalOperationError;
	
	/**
	 * 类似as2.0里的_global全局动态对象
	 * 
	 * @author 8088
	 */
	public dynamic class Global extends Proxy implements IEventDispatcher
	{
		
		public function Global(lock:Class = null) 
		{
			if (lock != ConstructorLock)
			{
				throw new IllegalOperationError("Global 是单例模式，禁止外部实例化！!"); 
			}
			
			dispatcher = new EventDispatcher(this);
			repository = new HashMap();
		}
		
		public static function getInstance():Global
		{
			if (instance == null)
			{
				instance = new Global(ConstructorLock);
			}
			
			return instance;
		}
		
 	 	override flash_proxy function callProperty(methodName:*, ...args):*
		{
			var result:*;
	       	switch (methodName.toString()) {
				default:
					result = repository.getValueByKey(methodName).apply(repository, args);
					break;
			}
			return result;
		}
	    
 	 	override flash_proxy function getProperty(name:*):* {
			var value:*;
			if (repository) value = repository.getValueByKey(name);
			return value;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			var oldValue:* = repository.getValueByKey(name);
			
			repository.put(name , value);
			
			if(oldValue !== value) {
				changeName = name;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function getChangeName():*
		{
			return changeName;
		}
		
	    public function remove(name:String):void
		{
			repository.remove(name);
		}
		
		public function destroy():void
		{
			repository.clear();
			repository = null;
			instance = null;
		}
		
		public function toString():String {
	    	var temp:Array = new Array();
	    	for (var key:* in repository)
			{
				if (repository[key] != null)
				{
					temp.push ("{" + key + ":" + repository[key] + "}");
				}
	    	}
	    	return temp.join(",");
		}
	    
		
		/**
		 * Event Dispatcher Functions
		 */
	    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
        	dispatcher.addEventListener(type, listener, useCapture, priority);
	    }
	    
	    public function dispatchEvent(evt:Event):Boolean{
	        return dispatcher.dispatchEvent(evt);
	    }
	    
	    public function hasEventListener(type:String):Boolean{
	        return dispatcher.hasEventListener(type);
	    }
	    
	    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
	        dispatcher.removeEventListener(type, listener, useCapture);
	    }
	    
	    public function willTrigger(type:String):Boolean {
	        return dispatcher.willTrigger(type);
	    }
		
		private static var instance:Global = null;
		private var dispatcher:EventDispatcher;
		private var repository:HashMap;
		private var changeName:*;
	}
}

class ConstructorLock {};