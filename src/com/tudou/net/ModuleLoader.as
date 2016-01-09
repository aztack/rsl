package com.tudou.net 
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	[Event(name = "open", type = "flash.events.Event")]
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "httpStatus", type = "flash.events.HTTPStatusEvent")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	[Event(name = "securityError", type = "flash.events.SecurityErrorEvent")]
	[Event(name = "unload", type = "flash.events.Event")]
	/**
	 * 模块加载器
	 * - 依赖SWFLoader载入文件，对外提供模块Class
	 * - 需要限制仅安全域可使用
	 * 
	 * @author 8088 at 2014/7/4 17:20:05
	 */
	public class ModuleLoader extends EventDispatcher 
	{
		
		public function ModuleLoader() 
		{
			loader = new SWFLoader();
			loader.addEventListener(Event.OPEN, openHandler);
			loader.addEventListener(Event.COMPLETE,completeHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(Event.UNLOAD, unLoadHandler);
		}
		
		public function load(url:String):void
		{
			module_path = url;
			try {
				loader.load(module_path);
			}
			catch (err:IllegalOperationError) {
				throw err;
			}
		}
		
		public function getModuleClssByName(name:String):Class
		{
			try {
				return loader.contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
			}
			catch (err:Error) {
				throw new IllegalOperationError(name + " definition not found in " + module_path);
			}
			return null;
		}

		// Internal..
		//
		private function openHandler(evt:Event):void
		{
			dispatchEvent(evt);
		}
		
		private function completeHandler(evt:Event):void
		{
			dispatchEvent(evt);
		}
		
		private function httpStatusHandler(evt:HTTPStatusEvent):void
		{
			dispatchEvent(evt);
		}
		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			dispatchEvent(evt);
		}
		
		private function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			dispatchEvent(evt);
		}
		
		private function unLoadHandler(evt:Event):void
		{
			dispatchEvent(evt);
		}
		
		
		private var loader:SWFLoader;
		private var module_path:String;
	}

}