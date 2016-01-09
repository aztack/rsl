package com.tudou.ui 
{
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * 右键菜单
	 * 
	 * @author 8088
	 */
	public class RightMenu extends EventDispatcher
	{
		
		public function RightMenu(interactiveObject:InteractiveObject , _defaultLen:int = 0)
		{
			super();
			
			registered = { };
			items = { }; 
			options = { };
			defaultLen = _defaultLen;
			
			contextMenu = new ContextMenu();
			interactiveObject.contextMenu = contextMenu;
			interactiveObject.contextMenu.hideBuiltInItems();
			if (interactiveObject.stage) interactiveObject.stage.showDefaultContextMenu = false;
		}
		
		private var defaultOptions:Object = 
			{ separatorBefore: false
			, enabled: true
			, visible: true
			};
			
		private function onMenuSelect(evt:ContextMenuEvent):void
		{
			var item:ContextMenuItem = evt.target as ContextMenuItem;
			if (item)
			{
				dispatch(registered[item.caption]);
			}
		}
		
		private function dispatch(_data:Array):void
		{
			var obj:Object = new Object();
			obj.code = _data[0];
			if (_data[1] != null) obj.data = _data[1];
			obj.level = "command";
			
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, obj
							)
						 );
			obj = null;
		}
		
		/**
		 * 设置右键菜单的内置默认项
		 * 
		 * @param	defaultItem:* 内置于上下文菜单中的项
		 */
		public function setBuiltInItems(defaultItem:*):void
		{
			if (defaultItem.forwardAndBack != undefined) contextMenu.builtInItems.forwardAndBack = defaultItem.forwardAndBack;
			if (defaultItem.loop != undefined) contextMenu.builtInItems.loop = defaultItem.loop;
			if (defaultItem.play != undefined) contextMenu.builtInItems.play = defaultItem.play;
			if (defaultItem.print != undefined) contextMenu.builtInItems.print = defaultItem.print;
			if (defaultItem.quality != undefined) contextMenu.builtInItems.quality = defaultItem.quality;
			if (defaultItem.rewind != undefined) contextMenu.builtInItems.rewind = defaultItem.rewind; 
			if (defaultItem.save != undefined) contextMenu.builtInItems.save = defaultItem.save;
			if (defaultItem.zoom != undefined) contextMenu.builtInItems.zoom = defaultItem.zoom;
		}
		
		/**
		 * 添加右键菜单项
		 * 
		 * @param	menu:String 右键菜单字符
		 * @param	evtCode:String 右键菜单对应的事件代码
		 * @param	option:Object 右键菜单对应的设置
		 */
		public function add(menu:String, evtCode:String = null, option:Object = null):void
		{
			if (!registered.hasOwnProperty(menu)) num++;
			
			registered[menu] = [evtCode, option];
			
			if (option == null)
			{
				option = { };
			}
			if (evtCode == null) option.enabled = false;
			options[menu] = option;
			
			var itemSeparatorBefore:Boolean = option.hasOwnProperty("separatorBefore") ? Boolean(option.separatorBefore) : defaultOptions.separatorBefore;
			var itemEnabled:Boolean = option.hasOwnProperty("enabled") ? Boolean(option.enabled) : defaultOptions.enabled;
			var itemVisible:Boolean = option.hasOwnProperty("visible") ? Boolean(option.visible) : defaultOptions.visible;
			
			if(!items[menu])
			{
				var item:ContextMenuItem = 
				new ContextMenuItem( menu
									, itemSeparatorBefore
									, itemEnabled
									, itemVisible
									);
				
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect);
				if (defaultLen > 0 && contextMenu.customItems.length > (defaultLen - 1))
				{
					contextMenu.customItems.splice((contextMenu.customItems.length - defaultLen), 0, item);
				}else {
					contextMenu.customItems.push(item);
				}
				items[menu] = item;
			}
			else {
				items[menu].separatorBefore = itemSeparatorBefore;
				items[menu].enabled = itemEnabled;
				items[menu].visible = itemVisible;
			}
		}
		
		/**
		 * 删除右键菜单项
		 * 
		 * @param	menu:String 右键菜的字符
		 */
		public function remove(menu:String):void
		{
			if (registered.hasOwnProperty(menu))
			{
				delete registered[menu];
				num--;
				
				var item:ContextMenuItem = items[menu] as ContextMenuItem;
				item.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect);
				contextMenu.customItems.splice(contextMenu.customItems.indexOf(item), 1);
			}
		}
		
		protected function processEnabledChange():void
		{
			for (var menu:String in items)
			{
				if (registered[menu] != null) items[menu].enabled = enabled;
				if (options[menu] != null && options[menu].hasOwnProperty("enabled")) items[menu].enabled = options[menu].enabled;
			}
		}
		protected function processVisibleChange():void
		{
			for (var menu:String in items)
			{
				if (registered[menu] != null) items[menu].visible = visible;
				if (options[menu] != null && options[menu].hasOwnProperty("visible")) items[menu].visible = options[menu].visible;
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
		public function set visible(value:Boolean):void
		{
			_visible = value;
			processVisibleChange();
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		private var contextMenu:ContextMenu;
		private var _enabled:Boolean = true;
		private var _visible:Boolean = true;
		
		private var registered:Object;
		private var items:Object;
		private var options:Object;
		private var num:int;
		private var defaultLen:int = 0;
	}

}