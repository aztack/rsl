package com.tudou.layout 
{
	/**
	 * @private
	 * CSS 属性关键字列表
	 * 已经支持的CSS样式表
	 * 
	 * @author 8088
	 */
	public class CSSKeyword 
	{
		public static const X:String = "x";
		public static const Y:String = "y";
		
		public static const WIDTH:String = "width";
		public static const HEIGHT:String = "height";
		
		public static const TOP:String = "top";
		public static const RIGHT:String = "right";
		public static const BOTTOM:String = "bottom";
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		public static const NULL:String = "null";
		public static const NONE:String = "none";
		
		public static const BACKGROUND:String = "background";
		public static const BACKGROUND_SCALE:String = "scale";
		public static const BACKGROUND_REPEAT:String = "repeat";
		public static const BACKGROUND_REPEAT_X:String = "repeat-x";
		public static const BACKGROUND_REPEAT_Y:String = "repeat-y";
		public static const BACKGROUND_NO_REPEAT:String = "no-repeat";
		
		public static const POSITION:String = "position";
		public static const POSITION_STATIC:String = "static"; //默认值，正常的x、y定位 忽略top/left/right/bottom
		public static const POSITION_RELATIVE:String = "relative"; //相对与父容器定位，(元素框偏移某个距离。元素仍保持其未定位前的形状，它原本所占的空间仍保留。)，忽略 x/y;
		//public static const POSITION_ABSOLUTE:String = "absolute"; //暂不支持，太复杂...
		public static const POSITION_FIXED:String = "fixed"; //相对与窗体定位，忽略 x/y;
		public static const POSITION_STAGE:String = "stage"; //同上，Aser比较熟悉stage
		
		public static const VISIBLE:String = "visible";//正常设置.visible已关联到CSS的visible修改
		public static const ALPHA:String = "alpha";//透明暂不关联，因透明经常需要做动画 
		
		public static const FLOAT:String = "float";//向左/向右浮动的元素分别在不同的关联序列里
	}

}