package com.tudou.layout 
{
	import com.tudou.utils.HashMap;
	import flash.errors.IllegalOperationError;
	/**
	 * ...
	 * @author 8088
	 */
	public class LayoutManager 
	{
		
		public function LayoutManager(lock:Class = null) 
		{
			if (lock != ConstructorLock)
			{
				throw new IllegalOperationError("LayoutManager 是单例，禁止外部实例化！!");
			}
			
			list = new HashMap();
			css = new HashMap();
		}
		
		public static function record(id:String, value:String):void
		{
			if (instance == null)
			{
				instance = new LayoutManager(ConstructorLock);
			}
			
			instance.css.put(id, value);
			
			if (instance.list.hasKey(id))
			{
				var view:LayoutSprite = instance.list.getValueByKey(id) as LayoutSprite;
				view.style = value;
			}
		}
		
		public static function register(id:String, view:LayoutSprite):void
		{
			if (instance == null)
			{
				instance = new LayoutManager(ConstructorLock);
			}
			
			instance.list.put(id, view);
			
			if (instance.css.hasKey(id))
			{
				view.style = instance.css.getValueByKey(id);
			}
		}
		
		public static function unregister(id:String):void
		{
			if (instance != null) {
				instance.list.remove(id);
			}
		}
		
		private static var instance:LayoutManager = null;
		private var list:HashMap;
		private var css:HashMap;
	}

}

class ConstructorLock {};