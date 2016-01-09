package com.tudou.layout 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * CSS 文件加载器
	 * 
	 * @author 8088
	 */
	[Event(name = "open", type = "flash.events.Event")]
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "httpStatus", type = "flash.events.HTTPStatusEvent")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	[Event(name = "securityError", type = "flash.events.SecurityErrorEvent")]
	[Event(name = "unload", type = "flash.events.Event")]
	public class CSSLoader extends EventDispatcher
	{
		
		public function load(url:String):void
		{
			this.url = url;
			
			loader = new URLLoader();
			loader.addEventListener(Event.OPEN, openHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(Event.UNLOAD, unloadHandler);
			loader.load(new URLRequest(url));
		}	
		
		
		// Internals
		//
		
		private function openHandler(evt:Event):void
		{
			dispatchEvent(evt);
		}
		
		private function httpStatusHandler(evt:HTTPStatusEvent):void
		{
			dispatchEvent(evt);
		}
		
		private function completeHandler(evt:Event):void
		{
			var str:String = loader.data as String;
			var ary:Array = str.split("}");
			var ln:uint = ary.length;
			
			for (var i:int = 0; i != ln; i++)
			{
				var temp:Array = ary[i].split("{");
				if (temp && temp.length == 2)
				{
					if (temp[0] && temp[0].indexOf("#") != -1)
					{
						LayoutManager.record(temp[0].substring(temp[0].indexOf("#")+1), temp[1]);
					}
				}
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function errorHandler(evt:Event):void
		{			
			dispatchEvent(evt.clone());
		}
		
		private function unloadHandler(evt:Event):void
		{
			dispatchEvent(evt);
		}
		
		private var loader:URLLoader;
		private var url:String;
		
	}

}