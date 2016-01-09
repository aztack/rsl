package com.tudou.utils 
{
	import flash.utils.*;
	/**
	 +------------------------------------------------
	 * AS3.0 ArrayUtil CODE Expanded Array
	 +------------------------------------------------ 
	 * @author 8088 at 2011-09-26
	 * version: 1.0
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class ArrayUtil 
	{
		
		public function ArrayUtil() 
		{
			return;
		}
		
		public static function search(obj:Object, ary:Array, f:Function):int 
		{
			if (!ary) return -1;
			var _i:int = 0;
			var b:int = 0;
			var i:int = -1;
			var ln:* = ary.length;
			while (i < (ln - 1))
			{
				_i = i + ln >> 1;
				b = f(obj, ary[_i]);
				if (b == 0) return _i;
				if (b < 0) 
				{
					ln = _i;
					continue;
				}
				i = _i;
			}
			return i;
		}
		
		public static function find(obj:Object, ary:Array):int
		{
			if (!ary) return -1;
			var ln:* = ary.length;
			var i:int = 0;
			while ( i < ln)
			{
				if (ary[i] == obj) return i;
				i++;
			}
			return -1;
		}
		
		public static function isEmpty(ary:Array):Boolean
		{
			return ary == null || ary.length == 0;
		}
		
		public static function shuffle(ary:Array):Array
		{
			if (!ary) return null;
			var ln:* = ary.length;
			var _ary:Array = ary.slice();
			var i:int = 0;
			var obj:Object = null;
			var n:Number = NaN;
			while (i < ln)
			{
				obj = _ary[i];
				n = Math.floor(Math.random() * ln);
				_ary[i] = _ary[n];
				_ary[n] = obj;
				i++;
			}
			return _ary;
		}
		
		public static function equals(ary1:Array, ary2:Array):Boolean
        {
            if (ary1 === ary2) return true;
            if (ary1 == null && ary2 == null) return true;
            if (ary1 == null || ary2 == null || ary1.length != ary2.length)
            {
                return false;
            }
            var i:int = 0;
			var ln:* = ary1.length;
            while (i < ln)
            {
                if (ary1[i] != ary2[i]) return false;
                i++;
            }
            return true;
        }
		
		public static function removeDuplicate(ary:Array):Array
		{
			if (!ary) return null;
			var ln:* = ary.length;
			var _ary:Array = [];
			var i:int = 0;
			var obj:Object = {};
			while (i < ln)
			{
				if (undefined == obj[ary[i]])
				{
					_ary.push(ary[i]);
					obj[ary[i]] = i;
				}
				i++;
			}
			return _ary;
		}
		//OVER
	}
	
}