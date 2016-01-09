package com.tudou.net 
{
	if (!CONFIG::FLASH_11)
	{
		import com.adobe.serialization.json.JSON;
	}
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.HTTPStatusEvent;
	
	[Event(name = "open", type = "flash.events.Event")]
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "httpStatus", type = "flash.events.HTTPStatusEvent")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	[Event(name = "securityError", type = "flash.events.SecurityErrorEvent")]
	/**
	 * JSON 文件加载器
	 * 
	 * @author 8088
	 */
	public class JSONFileLoader extends EventDispatcher
	{
		
		public function load(url:String):void
		{
			this.url = url;
			
			loader = new URLLoader();
			loader.addEventListener(Event.OPEN, openHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, completionSignalingHandler);
			try
			{
				loader.load(new URLRequest(url));
			}
			catch (err:Error) {
				throw new Error("无法启动JSON文件加载！" + url);
			}
			
			
		}	
		
		public function get json():*
		{
			var json:* = null;
			try
			{
				json = loader ?
					  loader.data != null?
						  JSON.decode(loader.data)
						: null
					: null;
			} 
			catch (error:Error) {
				throw new Error("JSON文件格式错误！" + url);
			}
			return json;
		}
		
		public function get data():*
		{
			return loader ? (loader.data != null ? loader.data : null) : null;
		}
		
		public function close():void
		{
			if (loader) {
				loader.close();
				loader.removeEventListener(Event.OPEN, openHandler);
				loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.removeEventListener(Event.COMPLETE, completionSignalingHandler);
				loader = null;
			}
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
		
		private function completionSignalingHandler(event:Event):void
		{			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function errorHandler(event:Event):void
		{			
			dispatchEvent(event.clone());
		}
		
		private var loader:URLLoader;
		private var url:String;
		
	}

}