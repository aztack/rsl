package com.tudou.layout 
{
	import com.tudou.utils.Global;
	import com.tudou.utils.HashMap;
	import flash.utils.Dictionary;
	
	/**
	 * @private
	 * 布局样式，模拟XHTML里的[css].用于LayoutSprite实现动态布局。
	 * 
	 * @author 8088
	 */
	public class LayoutStyle 
	{
		
		public function LayoutStyle() 
		{
			defaultSet();
		}
		
		private function defaultSet():void
		{
			_map = new HashMap();
			
			_position = CSSKeyword.POSITION_STATIC;
			_float = CSSKeyword.NONE;
			
			_top = null;
			_bottom = null;
			_left = null;
			_right = null;
			
			_x = 0.0;
			_y = 0.0;
			_width = 0.0;
			_height = 0.0;
			
			_background = { color:0, alpha:0, url:null, repeat:CSSKeyword.BACKGROUND_NO_REPEAT, xpos:0, ypos:0 };
			
			_visible = true;
			_alpha = 1;
			
		}
		
		private function transform(obj:Object):void
		{
			for (var key:* in obj)
			{
				if (key == CSSKeyword.BACKGROUND
					&& _map.getValueByKey(CSSKeyword.BACKGROUND)
					&& _map.getValueByKey(CSSKeyword.BACKGROUND).indexOf("url") != -1
					&& obj[key].indexOf("url") == -1
					&& obj[key].indexOf(CSSKeyword.NULL) == -1
					&& obj[key].indexOf(CSSKeyword.NONE) == -1
					)
				{
					var bg:String = _map.getValueByKey(CSSKeyword.BACKGROUND);
					obj[key] += " " + bg.slice(bg.indexOf("url"));
				}
				_map.put(key, obj[key]);
			}
			
			if (_map.hasKey(CSSKeyword.VISIBLE)) visible = _map.getValueByKey(CSSKeyword.VISIBLE) == "false"?false:true;
			if (_map.hasKey(CSSKeyword.ALPHA)) alpha = Number(_map.getValueByKey(CSSKeyword.ALPHA));
			
			if (_map.hasKey(CSSKeyword.WIDTH)) width = _map.getValueByKey(CSSKeyword.WIDTH);
			if (_map.hasKey(CSSKeyword.HEIGHT)) height = _map.getValueByKey(CSSKeyword.HEIGHT);
			if (_map.hasKey(CSSKeyword.BACKGROUND)) background = _map.getValueByKey(CSSKeyword.BACKGROUND);
			
			if (_map.hasKey(CSSKeyword.POSITION)) position = _map.getValueByKey(CSSKeyword.POSITION);
			
			if (_map.hasKey(CSSKeyword.X)) x = Number(_map.getValueByKey(CSSKeyword.X));
			if (_map.hasKey(CSSKeyword.Y)) y = Number(_map.getValueByKey(CSSKeyword.Y));
			
			if (_map.hasKey(CSSKeyword.TOP)) top = _map.getValueByKey(CSSKeyword.TOP);
			if (_map.hasKey(CSSKeyword.BOTTOM)) bottom = _map.getValueByKey(CSSKeyword.BOTTOM);
			if (_map.hasKey(CSSKeyword.LEFT)) left = _map.getValueByKey(CSSKeyword.LEFT);
			if (_map.hasKey(CSSKeyword.RIGHT)) right = _map.getValueByKey(CSSKeyword.RIGHT);
			
			if (_map.hasKey(CSSKeyword.FLOAT)) float = _map.getValueByKey(CSSKeyword.FLOAT);
		}
		
		/**
		 * 将CSS字符串解码为布局样式
		 * @param	css CSS布局字符串
		 */
		public function decode(css:String):void
		{
			var decoder:CSSDecoder = new CSSDecoder(css);
			
			transform(decoder.getCSSObj());
		}
		
		public function clear():void
		{
			//还原为默认值样式
			defaultSet();
		}
		
		public function get x():Number
		{
			return _x;
		}
		public function set x(n:Number):void
		{
			_x = n;
		}
		
		public function get y():Number
		{
			return _y;
		}
		public function set y(n:Number):void
		{
			_y = n;
		}
		
		public function get top():*
		{
			return _top;
		}
		
		public function set top(t:*):void
		{
			_top = t;
		}
		
		public function get bottom():*
		{
			return _bottom;
		}
		
		public function set bottom(b:*):void
		{
			_bottom = b;
		}
		
		public function get left():*
		{
			return _left;
		}
		
		public function set left(l:*):void
		{
			_left = l;
		}
		
		public function get right():*
		{
			return _right;
		}
		
		public function set right(r:*):void
		{
			_right = r;
		}
		
		public function get width():*
		{
			return _width;
		}
		public function set width(n:*):void
		{
			_width = n;
		}
		
		public function get height():*
		{
			return _height;
		}
		public function set height(n:*):void
		{
			_height = n;
		}
		
		public function get float():String
		{
			return _float;
		}
		
		public function set float(f:String):void
		{
			_float = f;
		}
		
		public function get background():*
		{
			return _background;
		}
		
		public function set background(obj:String):void
		{
			var ary:Array = obj.split(/ +/);
			
			var s:String = ary[0];
			var c:Number;
			var a:Number;
			
			//取背景色
			if (s.indexOf("url") != -1 || s == CSSKeyword.NULL || s == CSSKeyword.NONE) 
			{
				c = 0;
				a = 0;
			}
			else {
				ary.shift();
				if (s.length == 4)
				{
					a = 1;
					var t:Array = s.substr(1).split("");
					c = Number("0x" + t[0] + t[0] + t[1] + t[1] + t[2] + t[2]);
				}
				else if (s.length == 7) {
					a = 1;
					c = Number("0x" + s.substr(1));
				}
				else if (s.length == 9){
					a = Number("0x" + s.substr(1, 2)) / 255;
					c = Number("0x" + s.substr(3));
				}
				else {
					throw new CSSParseError("CSS里背景颜色值‘" + s +"’设置错误！");
				}
			}
			ary.unshift(c, a);
			
			//CSS背景如果不设置颜色值，则重置为透明度为0的黑色
			_background.color = Number(ary[0]);
			_background.alpha = Number(ary[1]);
			if (ary[2])
			{
				if (ary[2] == CSSKeyword.NULL || ary[2] == CSSKeyword.NONE) _background.url = null;
				else _background.url = ary[2].slice(ary[2].indexOf("(") + 1, ary[2].indexOf(")"));
			}
			
			if (ary[3]) _background.repeat = ary[3];
			if (ary[4]!=undefined) _background.xpos = ary[4];
			if (ary[5]!=undefined) _background.ypos = ary[5];
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(b:Boolean):void
		{
			_visible = b;
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(a:Number):void
		{
			var _a:Number;
			if (a > 1) _a = 1;
			else if (a < 0)_a = 0;
			else _a = a;
			_alpha = _a;
			
		}
		public function get position():String
		{
			return _position;
		}
		
		public function set position(p:String):void
		{
			_position = p;
		}
		
		public function get map():HashMap
		{
			return _map;
		}
		
		/**
		 * 输出所有样式 
		 * 
		 * @return
		 */
		public function toString():String
		{
			return _map.toString();
		}
		
		protected var _global:Global = Global.getInstance();
		
		private var _map:HashMap;
		
		private var _position:String;
		private var _float:String;
		
		private var _x:Number;
		private var _y:Number;
		
		private var _top:*;
		private var _bottom:*;
		private var _left:*;
		private var _right:*;
		
		private var _width:*;
		private var _height:*;
		private var _background:*;
		private var _visible:Boolean;
		private var _alpha:Number;
	}

}