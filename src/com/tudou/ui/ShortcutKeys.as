package com.tudou.ui 
{
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.NetStatusEvent;
	import flash.utils.Dictionary;
	/**
	 * 功能快捷键
	 * 
	 * @author 8088
	 */
	public class ShortcutKeys extends EventDispatcher
	{
		//快捷键配置,版本自动化时再提到配置文件。
		/*private var config:Object =
			{ "Ctrl+F": { code:"setPlayerSizeFullScreen", type:"全屏" }
			, "Space": { code:"toggleVideoPause", type:"切换播放暂停" }
			, "Down": { code:"down", type:"降低音量" }
			, "Up": { code:"up", type:"增加音量" }
			, "Left": { code:"left", type:"快退" }
			, "Right": { code:"right", type:"快进" }
			};
		*/
		public function ShortcutKeys(lock:Class = null)
		{
			if (lock != ConstructorLock)
			{
				throw new IllegalOperationError("ShortcutKeys 是单例模式，禁止实例化！!");
			}
			
			registered = { };
			
			/*
			for (var key:String in config)
			{
				add( key, config[key].code, config[key].type);
			}*/
		}
		
		public static function getInstance(stage:Stage=null):ShortcutKeys
		{
			
			instance ||= new ShortcutKeys(ConstructorLock);
			
			if (stage)
			{
				instance._stage = stage;
				instance.enabled = true;
			}
			
			if (instance._stage == null)
			{
				throw new ArgumentError("快捷键未被注册使用, 获取实例时需要 stage 参数！！");
			}
			
			return instance;
		}
		
		private var defaultOptions:Object = 
			{ "type": "keyUp"
			, "disable_in_input": false
			, "keycode": false
			};
		
		//Shift+数字键 与 对应的字符
		private var shiftNums:Object = 
			{ "`":"~"
			, "1":"!"
			, "2":"@"
			, "3":"#"
			, "4":"$"
			, "5":"%"
			, "6":"^"
			, "7":"&"
			, "8":"*"
			, "9":"("
			, "0":")"
			, "-":"_"
			, "=":"+"
			, ";":":"
			, "'":"\""
			, ",":"<"
			, ".":">"
			, "/":" "
			, "\\":"|"
			};
		
		//特殊键 和 对应的代码
		private var specialKeys:Object =
			{ "esc":27
			, "tab":9
			, "space":32
			, "enter":13
			, "backspace":8
			
			, "scrolllock":145
			, "capslock":20
			, "numlock":144
			, "break":19
			
			, "insert":45
			, "home":36
			, "delete":46
			, "end":35
			, "pageup":33
			, "pagedown":34
			
			, "left":37
			, "up":38
			, "right":39
			, "down":40
			
			, "f1":112
			, "f2":113
			, "f3":114
			, "f4":115
			, "f5":116
			, "f6":117
			, "f7":118
			, "f8":119
			, "f9":120
			, "f10":121
			, "f11":122
			, "f12":123
			};
		
		private function keyUp(evt:KeyboardEvent):void
		{
			var code:uint = evt.keyCode;
			var character:String = String.fromCharCode(code).toLowerCase();
			
			for (var key:String in specialKeys)
			{
				if (code == specialKeys[key]) character = key;
			}
			
			if (registered.hasOwnProperty(character))
			{
				dispatch(registered[character].code);
			}
		}
		
		private function keyDown(evt:KeyboardEvent):void
		{
			var code:uint = evt.keyCode;
			var character:String = String.fromCharCode(code).toLowerCase();
			
			for (var key:String in specialKeys)
			{
				if (code == specialKeys[key]) character = key;
			}
			
			if (!registered.hasOwnProperty(character))
			{
				for (var shortcut:String in registered)
				{
					var keys:Array = shortcut.split("+");
					var k:String;
					var kp:int = 0;
					
					var modifiers:Object = 
					{ shift: { wanted:false, pressed:false }
					, ctrl : { wanted:false, pressed:false }
					, alt  : { wanted:false, pressed:false }
					};
						
					if (evt.ctrlKey) modifiers.ctrl.pressed = true;
					if (evt.shiftKey) modifiers.shift.pressed = true;
					if (evt.altKey) modifiers.alt.pressed = true;
					
					for (var i:int = 0; i < keys.length; i++)
					{
						k = keys[i];
						if(k == 'ctrl' || k == 'control') {
							kp++;
							modifiers.ctrl.wanted = true;
						}
						else if(k == 'shift') {
							kp++;
							modifiers.shift.wanted = true;
						}
						else if(k == 'alt') {
							kp++;
							modifiers.alt.wanted = true;
						}
						else {
							if(character == k) kp++;
						}
					}
					
					if ( kp == keys.length
						&& modifiers.ctrl.pressed == modifiers.ctrl.wanted
						&& modifiers.shift.pressed == modifiers.shift.wanted
						&& modifiers.alt.pressed == modifiers.alt.wanted
						)
					{
						dispatch(registered[shortcut].code);
					}
				}
			}
		}
		
		private function dispatch(code:String):void
		{
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:code, level:"status" }
							)
						 );
		}
		
		/**
		 * 添加、修改快捷键
		 * 
		 * @param	keys:String 快捷键的字符
		 * @param	evtCode:String 快捷键对应的事件代码
		 * @param	evtType:String 快捷键对应的事件类型
		 */
		public function add(keys:String, evtCode:String, evtType:String):void
		{
			var shortcut:String = keys.toLowerCase();
			
			if (!registered.hasOwnProperty(shortcut)) num++;
			
			var evt:Object = { };
			evt.keys = keys;
			evt.code = evtCode;
			evt.type = evtType;
			registered[shortcut] = evt;
		}
		
		/**
		 * 删除快捷键
		 * 
		 * @param	keys:String 快捷键的字符
		 */
		public function remove(keys:String):void
		{
			var shortcut:String = keys.toLowerCase();
			
			if (registered.hasOwnProperty(shortcut))
			{
				delete registered[shortcut];
				num--;
			}
		}
		
		protected function processEnabledChange():void
		{
			if (enabled)
			{
				_stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			}
			else {
				_stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			}
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			processEnabledChange();
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		override public function toString():String
		{
			var str:String = "";
			
			for (var key:String in registered)
			{
				str += registered[key].keys + " -> " + registered[key].type+"\n";
			}
			return str;
		}
		
		private static var instance:ShortcutKeys;
		private var _enabled:Boolean = true;
		private var _stage:Stage;
		
		private var registered:Object;
		private var num:int;
	}

}

class ConstructorLock {};