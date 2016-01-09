package com.tudou.layout 
{
	import com.tudou.utils.Global;
	import flash.system.ApplicationDomain;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	/**
	 * @private
	 * 支持CSS布局的Sprite,模拟XHTML里的<div>.
	 * 
	 * @author 8088
	 */
	public class LayoutSprite extends Sprite
	{
		
		public function LayoutSprite() 
		{
			this.mouseEnabled = false;
			
			_css = new LayoutStyle();
			
			_x = 0.0;
			_y = 0.0;
			_w = 0.0;
			_h = 0.0;
			
			_bg = new Shape();
			_bg.visible = false;
			_bg.addEventListener(Event.REMOVED, bgRemovError);
			addChild(_bg);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		public function setSize():void
		{
			this.width = getLength(CSSKeyword.WIDTH, css.width);
			
			this.height = getLength(CSSKeyword.HEIGHT, css.height);
		}
		
		public function get css():LayoutStyle
		{
			return _css;
		}
		
		/**
		 * 元素的唯一 id
		 */
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			if (_id == value) return;
			_id = value;
			LayoutManager.register(_id, this);
		}
		
		/**
		 * 元素的样式
		 */
		public function get style():String
		{
			return _css.toString();
		}
		
		public function set style(value:String):void
		{
			if (value) 
			{
				if (value !== _style)
				{
					css.decode(value);
					_style = value;
				}
			}
			else {
				css.clear();
				_style = null;
			}
			
			applyStyle();
		}
		
		/**
		 * 元素的额外信息（可在工具提示中显示）
		 */
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
		}
		
		public function applyStyle():void
		{
			visible = css.visible;
			alpha = css.alpha;
			
			setSize();
			
			drawBackground();
			
			switch(css.position)
			{
				case CSSKeyword.POSITION_STATIC:
					_top = null;
					_bottom = null;
					_left = null;
					_right = null;
					
					if (css.float != CSSKeyword.NONE)
					{
						if (this.visible)
						{
							if(!this.prve) linkFloat();
							else resetFloat();
						}
					}
					else setPoint();
					
					break;
					
				case CSSKeyword.POSITION_STAGE:
				case CSSKeyword.POSITION_FIXED:
				case CSSKeyword.POSITION_RELATIVE:
					x = 0.0;
					y = 0.0;
					
					setLocation();
					break;
			}
			
		}
		
		
		// Internal..
		//
		
		private var _l:Number;
		private var _r:Number;
		private var _floatY:Number;
		public function resetFloat():void
		{
			if (!this.parent) return;
			var _tl:Number = 0.0;
			switch(css.float)
			{
				case CSSKeyword.NONE:
					_r = 0.0;
					_l = 0.0;
					_floatY = 0.0;
					break;
				case CSSKeyword.LEFT:
					_r = 0.0;
					
					if (prve) _tl = prve.x + prve.width;
					else _tl = 0.0;
					
					if (_tl + this.width <= this.parent.width)
					{
						_l = _tl;
						if (prve) _floatY = prve.floatY;
						else _floatY = 0.0;
					}
					else {
						_l = 0.0;
						if (prve) _floatY = prve.y + prve.height;
						else _floatY = 0.0
					}
					
					break;
				case CSSKeyword.RIGHT:
					_l = 0.0;
					
					if (prve) _tl = prve.x - this.width;
					else _tl = this.parent.width - this.width;
					
					if (_tl >= 0)
					{
						_r = _tl;
						if (prve) _floatY = prve.floatY;
						else _floatY = 0.0;
					}
					else {
						_r = this.parent.width - this.width;;
						if (prve) _floatY = prve.y + prve.height;
						else _floatY = 0.0;
					}
					break;
			}
			
			x = css.x + _l + _r;
			y = css.y + _floatY;
			
			if (this.next != null) this.next.resetFloat();
		}
		
		private function setPoint():void
		{
			if (css.position != CSSKeyword.POSITION_STATIC) return;
			
			if (!isNaN(css.x)) x = css.x;
			if (!isNaN(css.y)) y = css.y;
			
		}
		
		private function setLocation():void
		{
			if (css.position == CSSKeyword.POSITION_STATIC) return;
			
			if (css.top != null) top = css.top;
			if (css.bottom != null) bottom = css.bottom;
			if (css.left != null) left = css.left;
			if (css.right != null) right = css.right;
		}
		
		public function get layoutStyle():LayoutStyle
		{
			return _css;
		}
		
		public function get prve():LayoutSprite
		{
			return _prve;
		}
		
		public function set prve(ls:LayoutSprite):void
		{
			_prve = ls;
		}
		
		public function get next():LayoutSprite
		{
			return _next;
		}
		
		public function set next(ls:LayoutSprite):void
		{
			_next = ls;
		}
		
		public function get floatY():Number
		{
			return _floatY;
		}
		
		
		/**
		 * 重写 Sprite接口
		 */
		override public function get numChildren():int
		{
			return super.numChildren - 1;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child, index + 1);
		}
	
		override public function getChildAt(index:int):DisplayObject
		{
			return super.getChildAt(index + 1);
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			return super.getChildIndex(child) - 1;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var layoutSprite:LayoutSprite = child as LayoutSprite;
			if(layoutSprite) LayoutManager.unregister(layoutSprite.id);
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var layoutSprite:LayoutSprite = getChildAt(index) as LayoutSprite;
			if(layoutSprite) LayoutManager.unregister(layoutSprite.id);
			return super.removeChildAt(index + 1);
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			return super.setChildIndex(child, index + 1);
		}
		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			return super.swapChildrenAt(index1 + 1, index2 + 1);
		}
		
		CONFIG::FLASH_11
		{
			override public function removeChildren(beginIndex:int = 0, endIndex:int = 0x7fffffff):void
			{
				for (var i:int = beginIndex; i < endIndex + 1; i++)
				{
					var layoutSprite:LayoutSprite = getChildAt(i) as LayoutSprite;
					if(layoutSprite) LayoutManager.unregister(layoutSprite.id);
				}
				return super.removeChildren(beginIndex + 1, endIndex + 1);
			}
		}
		
		override public function set x(n:Number):void
		{
			if (n == _x) return;
			_x = n;
			reSetX();
			super.x = _x;
		}
		
		override public function set y(n:Number):void
		{
			if (n == _y) return;
			_y = n;
			reSetY();
			super.y = _y;
		}
		
		override public function get width():Number
		{
			return _w;
		}
		
		override public function set width(w:Number):void
		{
			if (w == _w) return;
			_w = w;
			//按背景样式重新绘制
			reDrawBg(_w, height);
			reSetChildLocation();
			reSetWidth();
			if (resizeTimer)
			{
				resizeTimer.reset();
				resizeTimer.start();
			}
			else {
				resizeTimer = new Timer(30);
				resizeTimer.addEventListener(TimerEvent.TIMER, resizeTimerHandler);
				resizeTimer.start();
			}
			
			scaleX = 1;
			super.width = _w;
			scaleX = 1;
		}
		
		override public function get height():Number
		{
			return _h;
		}
		
		override public function set height(h:Number):void
		{
			if (h == _h) return;
			_h = h;
			//按背景样式重新绘制
			reDrawBg(width, _h);
			reSetChildLocation();
			reSetHeight();
			if (resizeTimer)
			{
				resizeTimer.reset();
				resizeTimer.start();
			}
			else {
				resizeTimer = new Timer(30);
				resizeTimer.addEventListener(TimerEvent.TIMER, resizeTimerHandler);
				resizeTimer.start();
			}
			scaleY = 1;
			super.height = _h;
			scaleY = 1;
		}
		
		override public function set visible(v:Boolean):void
		{
			if (this.visible != v) 
			{
				if (this.css.map.hasKey("visible"))
				{
					this.css.map.put("visible", v.toString());
					this.css.visible = v;
				}
				
				if (css.float != CSSKeyword.NONE)
				{
					if (v)
					{
						linkFloat();
					}
					else disconFloat();
				}
				
			}
			super.visible = v;
		}
		
		
		protected function onStage(evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			applyStyle();
			
		}
		
		/**
		 * 为解决连接外跳,播放器不退出全屏问题特意增加此方法,在外跳时退出全屏.
		 * 因前期已经将全屏切换控制统一到一处，皮肤和快捷键只能发消息通知，
		 * 所以最终应将此方法提到播放器内，这里只往外发外跳事件。
		 * 广告模块也这么处理，外跳的操作统一由播放器控制
		 * 
		 * @param request:URLRequest URLRequest对象，指定要导航到哪个 URL
		 * @param target:String 浏览器窗口或 HTML 帧
		 */
		protected function navigateToUrl(request:URLRequest, target:String = null):void
        {
            if (request)
            {
                if (stage && stage.displayState != StageDisplayState.NORMAL)
                {
                   stage.displayState == StageDisplayState.NORMAL;
                }
				
                try
                {
                    navigateToURL(request, target);
                }
                catch (error:SecurityError) {
					//..
                }
            }
        }
		
		
		// Internals..
		//
		
		private function bgRemovError(evt:Event):void
		{
			throw new Error("禁止删除用于显示LayoutSprite背景图像的Shape！");
		}
		
		private function reSetChildLocation():void
		{
			var ls:LayoutSprite;
			var n:int = this.numChildren;
			
			for (var i:int = 0; i != n; i++)
			{
				ls = getChildAt(i) as LayoutSprite;
				if (ls)
				{
					ls.applyStyle();
				}
			}
		}
		
		
		private function drawBackground():void
		{
			//当CSS背景颜色样式改变时，则重新绘制背景颜色
			if (_background_color != css.background.color || _background_alpha != css.background.alpha)
			{
				_background_color = css.background.color;
				_background_alpha = css.background.alpha;
				if (width > 0 && height > 0)
				{
					drawBackgroundColor(_background_color
										, _background_alpha
										, width
										, height
										);
				}
			}
			
			//当CSS背景图像样式改变时，则重新绘制背景图像
			if (css.background.url)
			{
				if ( _background_url != css.background.url 
					|| _background_repeat != css.background.repeat
					|| _background_xpos != css.background.xpos
					|| _background_ypos != css.background.ypos
					)
				{
					_background_url = css.background.url 
					_background_repeat = css.background.repeat
					_background_xpos = css.background.xpos
					_background_ypos = css.background.ypos
					if (width > 0 && height > 0)
					{
						drawBackgroundImg(_background_url
										 , _background_repeat
										 , _background_xpos
										 , _background_ypos
										 );
					}
				}
			}
			else {
				_background_url = null;
				_bg.graphics.clear();
				if(_bg.visible) _bg.visible = false;
			}
		}
		
		protected function getDefinitionByName(url:String):Object
		{
			throw new Error("有CSS里背景图像的元素需要覆盖重写此方法，并返回ApplicationDomain.currentDomain.getDefinition(url).！");
		}
		
		private function drawBackgroundImg(url:String, repeat:String, xpos:*, ypos:*):void
		{
			if (!url || width <= 0 || height <= 0) return;
			//如果是外部图片(根据地址协议或地址后缀名辨别)则加载后绘制，暂不支持
			var BgUrl:Class = getDefinitionByName(url) as Class;
			
			var bd:BitmapData;
			var bg:*;
			if (!BgUrl) throw new CSSParseError("CSS里背景图像‘" + url +"’无法找到！");
			bg = new BgUrl();
			
			if (bg is DisplayObject)
			{
				if (repeat == CSSKeyword.BACKGROUND_SCALE)
				{
					bd = new BitmapData(width, height, true, 0);
					bg.width = width;
					bg.height = height;
					var tc:Sprite = new Sprite()
					tc.addChild(bg);
					bd.draw(tc);
					tc.removeChild(bg);
					tc = null;
				}
				else {
					bd = new BitmapData(bg.width, bg.height, true, 0);
					bd.draw(bg);
				}
			}
			else if (bg is BitmapData) {
				bd = bg;
			}
			else {
				throw new CSSParseError("CSS里背景图像‘" + url + "’类型暂不支持！");
			}
			
			_bg.graphics.clear();
			
			//初始化背景图像坐标及边界
			var _x:Number = 0;
			var _y:Number = 0;
			var _w:Number = bg.width;
			var _h:Number = bg.height;
			
			//内联计算方法
			function checkPos(pos:*, s:String):Number {
				var n:Number = 0;
				if (isNaN(pos))
				{
					switch(pos)
					{
						case CSSKeyword.LEFT:
						case CSSKeyword.TOP:
							n = 0;
							break;
						case CSSKeyword.CENTER:
							n = int((getExtent(s) - bg[s]) * .5);
							break;
						case CSSKeyword.BOTTOM:
						case CSSKeyword.RIGHT:
							n = getExtent(s) - bg[s];
							break;
					}
				}
				else {
					if (pos <= (getExtent(s) - bg[s])) n = pos;
					else n = getExtent(s) - bg[s];
				}
				return n
			}
			
			//检查如何重复背景图像
			switch(repeat)
			{
				case CSSKeyword.BACKGROUND_REPEAT_X:
					_w = width;
					_y = checkPos(ypos, CSSKeyword.HEIGHT);
					break;
				case CSSKeyword.BACKGROUND_REPEAT_Y:
					_x = checkPos(xpos, CSSKeyword.WIDTH);
					_h = height;
					break;
				case CSSKeyword.BACKGROUND_NO_REPEAT:
					_x = checkPos(xpos, CSSKeyword.WIDTH);
					_y = checkPos(ypos, CSSKeyword.HEIGHT);
					_w = bg.width;
					_h = bg.height;
					break;
				case CSSKeyword.BACKGROUND_SCALE:
				case CSSKeyword.BACKGROUND_REPEAT:
					_w = width;
					_h = height;
					break;
			}
			
			//对图像相对位移，保证平铺时显示正确
			var matrix:Matrix = new Matrix();
			if (repeat != CSSKeyword.BACKGROUND_SCALE)
			{
				matrix.tx = _x;
				matrix.ty = _y;
			}
			
			if(!_bg.visible) _bg.visible = true;
			_bg.graphics.beginBitmapFill(bd, matrix);
			_bg.graphics.drawRect(_x, _y, _w, _h);
			_bg.graphics.endFill();
		}
		
		private function drawBackgroundColor(c:Number, a:Number, w:Number, h:Number):void
		{
			this.graphics.clear();
			if(a) this.graphics.beginFill(c, a);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}
		
		private function reDrawBg(w:Number, h:Number):void
		{
			drawBackgroundColor(_background_color
										, _background_alpha
										, w
										, h
										);
			drawBackgroundImg(_background_url
										, _background_repeat
										, _background_xpos
										, _background_ypos
										);
		}
		
		private function getExtent(s:String):Number
		{
			switch(s)
			{
				case CSSKeyword.WIDTH:
					return width;
					break;
				case CSSKeyword.HEIGHT:
					return height;
					break;
			}
			throw new Error("暂不支持获取属性" + s);
		}
		
		/**
		 * 相对于stage和parent定位时，使用CSS样式top/bottom、left/right计算出相对的坐标。
		 */
		private function set top(t:*):void
		{
			_top = getPosition(CSSKeyword.HEIGHT, t, 0);
			if (!isNaN(_top)) y = _top;
		}
		
		private function set bottom(b:*):void
		{
			_bottom = getPosition(CSSKeyword.HEIGHT, b, 1);
			if (!isNaN(_bottom)) y = _bottom;
		}
		
		private function set left(l:*):void
		{
			_left = getPosition(CSSKeyword.WIDTH, l, 0);
			if (!isNaN(_left)) x = _left;
		}
		
		private function set right(r:*):void
		{
			_right = getPosition(CSSKeyword.WIDTH, r, 1);
			if (!isNaN(_right)) x = _right;
		}
		
		protected function getLength(s:String, l:*):Number
		{
			var _l:Number;
			var c:Number;
			
			switch(css.position)
			{
				case CSSKeyword.POSITION_STAGE:
				case CSSKeyword.POSITION_FIXED:
					if(stage) c = (s == CSSKeyword.WIDTH)? stage.stageWidth:stage.stageHeight;
					break;
				case CSSKeyword.POSITION_RELATIVE:
				case CSSKeyword.POSITION_STATIC:
					if(parent) c = (s == CSSKeyword.WIDTH)? parent.width:parent.height;
					break;
			}
			
			//根据相对值c求长度
			if (isNaN(l))
			{
				if (isNaN(c)) return 0;
				var r:Number = Number(l.slice(0, l.indexOf("%"))) / 100;//相对比例
				var o_s:Number = 0;
				if (l.indexOf("-")!=-1) o_s = Number(l.slice(l.indexOf("-")));
				if (l.indexOf("+")!=-1) o_s = Number(l.slice(l.indexOf("+")));
				_l = c * r + o_s;
			}
			else {
				_l = l;
			}
			return _l;
			
		}
		
		protected function getPosition(s:String, p:*, i:int = 0):Number
		{
			var _p:Number;
			var n:Number;
			var c:Number;
			
			switch(css.position)
			{
				case CSSKeyword.POSITION_STAGE:
				case CSSKeyword.POSITION_FIXED:
					if(stage) c = (s == CSSKeyword.WIDTH)? stage.stageWidth:stage.stageHeight;
					break;
				case CSSKeyword.POSITION_RELATIVE:
				case CSSKeyword.POSITION_STATIC:
					if(parent) c = (s == CSSKeyword.WIDTH)? parent.width:parent.height;
					break;
			}
			
			//根据相对值c求定位值
			if (isNaN(p))
			{
				var r:Number = Number(p.slice(0, p.indexOf("%"))) / 100;//相对比例
				n = Math.abs(r - i);
				var o_s:Number = 0;
				if (p.indexOf("-")!=-1) o_s = Number(p.slice(p.indexOf("-")));
				if (p.indexOf("+")!=-1) o_s = Number(p.slice(p.indexOf("+")));
				_p = int((c - getExtent(s)) * n + o_s);
				
			}
			else {
				if (i) _p = (c - getExtent(s)) - p;
				else _p = p;
			}
			return _p;
		}
		
		
		private function resizeTimerHandler(evt:TimerEvent):void
		{
			delayResize();
			
			resizeTimer.removeEventListener(TimerEvent.TIMER, resizeTimerHandler);
			resizeTimer.stop();
			resizeTimer = null;
			
		}
		
		private function linkFloat():void {
			if (!this.parent) return;
			
			var curIndex:int = this.parent.getChildIndex(this);
			var i:int = 0;
			var ls:LayoutSprite;
			for (i = curIndex-1; i > -1; i--)
			{
				ls = this.parent.getChildAt(i) as LayoutSprite;
				if (ls && ls.visible && ls.css.float == this.css.float && ls.css.position == CSSKeyword.POSITION_STATIC)
				{
					this.prve = ls;
					if (ls.next) 
					{
						this.next = ls.next;
						ls.next.prve = this;
					}
					ls.next = this;
					break;
				}
			}
			
			if (this.next == null&& this.parent.numChildren>curIndex+1)
			{
				for (i = curIndex + 1; i < this.parent.numChildren; i++)
				{
					ls = this.parent.getChildAt(i) as LayoutSprite;
					if (ls && ls.visible && ls.css.float == this.css.float && ls.css.position == CSSKeyword.POSITION_STATIC)
					{
						this.next = ls;
						ls.prve = this;
						break;
					}
				}
			}
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, disconFloat);
			
			resetFloat();
		}
		
		private function disconFloat(evt:Event=null):void
		{
			if (evt != null) this.removeEventListener(Event.REMOVED_FROM_STAGE, disconFloat);
			
			if (this.prve!=null) this.prve.next = this.next;
			if (this.next!=null) this.next.prve = this.prve;
			
			if (this.next != null) this.next.resetFloat();
			
			this.prve = null;
			this.next = null;
		}
		
		protected var _global:Global = Global.getInstance();
		
		private var resizeTimer:Timer;
		protected function reSetX():void {};
		protected function reSetY():void {};
		protected function reSetWidth():void {};
		protected function reSetHeight():void {};
		protected function delayResize():void {};
		
		private var _x:Number;
		private var _y:Number;
		private var _w:Number;
		private var _h:Number;
		
		private var _top:*;
		private var _bottom:*;
		private var _left:*;
		private var _right:*;
		
		private var _prve:LayoutSprite;
		private var _next:LayoutSprite;
		private var _bg:Shape;
		
		protected var _classname:String;
		protected var _id:String;
		protected var _style:String;
		protected var _title:String;
		protected var _css:LayoutStyle;
		
		private var _background_color:Number = 0.0;
		private var _background_alpha:Number = 0.0;
		private var _background_url:String;
		private var _background_repeat:String;
		private var _background_xpos:*;
		private var _background_ypos:*;
		
		
	}

}