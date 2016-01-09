package com.tudou.utils 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	/**
	 * 检查工具
	 * 
	 * @author 8088
	 */
	public class Check 
	{
		
		/**
		 * 检查鼠标点是否超出范围，是返回true,否返回false。
		 * 类似于Rectangle自带的检测方法。
		 * 
		 * @param point:Point 需要检查的点
		 * @param rectangle:Rectangle 范围
		 */
		public static function Out(point:Point, rectangle:Rectangle):Boolean
		{
			var _x:Number = point.x;
			var _y:Number = point.y;
			if (_x <= rectangle.x || _x >= rectangle.width) return true;
			if (_y <= rectangle.y || _y >= rectangle.height) return true;
			return false;
		}
		
		/**
		 * 检查字符串是否超出设定的范围,如果是则切掉超出的字符并追加..,如果否则返回原字符串
		 * 
		 * @param str:String 需要检查的字符串
		 * @param width:Number 设定的范围
		 * @param size:int 字体的字号
		 */
		public static function View(str:String, width:Number, size:int=12):String
		{
			var c:int = width / size;
			var n:int = str.length;
			var s:String = "";
			if (n < c) s = str;
			else {
				s = str.slice(0, (c - 1)) + "..";
			}
			return s;
		}
		
		/**
		 * 检查是否在Debug Flash Player中运行
		 * 
		 * @return 
		 */
		public static function isDebugPlayer():Boolean
		{
			return Capabilities.isDebugger;
		}
		
		/**
		 * 检查是否以Debug方式构建
		 * 
		 * @return
		 */
		public static function isDebugBuild():Boolean
		{
			var b:Boolean;
			try {
				b = new Error().getStackTrace().search(/:[0-9]+]$/m) > -1
			}
			catch (err:Error) {
				//ignore..
			}
			return b;
		}
		
		/**
		 * 检查是否以Release方式构建
		 * 
		 * @return
		 */
		public static function isReleaseBuild() : Boolean
		{
			var bol:Boolean;
			var _t:Object;
			try {
				_t = new Error().getStackTrace();
			}
			catch (err:Error) {
				//ignore..
			}
			
			if (_t == null) bol = true;
			else bol = false;
			
			return bol;
		}
  
	}

}