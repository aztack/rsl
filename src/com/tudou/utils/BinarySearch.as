package com.tudou.utils
{
	/**
	 * 二分查找
	 * 
	 * @author 8088
	 */
    public class BinarySearch
    {

        public function BinarySearch()
        {
            return;
        }
		
		/**
		 * 二分查找算法搜索
		 * 
		 * @param	list	要搜索的目标列表(Array、Vector)
		 * @param	target	用于比较的目标
		 * @param	low		搜索范围 起始值
		 * @param	high	搜索范围 结束值
		 * @return  位置索引
		 */
        private static function search(list:*, target:Number, low:int, high:int):int
        {
            var index:int = 0;
            do
            {
                index = (low + high) / 2;
                if (target > list[index])
                {
                    low = index + 1;
                    continue;
                }
                high = index - 1;
            }while (list[index] != target && low <= high)
            return index;
        }
		
		/**
		 * 大于
		 */
        public static function greaterThan(list:*, target:Number, low:int = 0, high:int = -1):int
        {
			if (!list.length) return -1;
            if (high < 0)
            {
                high = list.length - 1;
            }
            var index:int = search(list, target, low, high);
            if (list[index] <= target && index == high)
            {
                return -1;
            }
            return list[index] <= target && index < high ? (index + 1) : (index);
        }
		
		/**
		 * 小于
		 */
        public static function lessThan(list:*, target:Number, low:int = 0, high:int = -1):int
        {
			if (!list.length) return -1;
            if (high < 0)
            {
                high = list.length - 1;
            }
            var index:int = search(list, target, low, high);
            if (list[index] >= target && index == low)
            {
                return -1;
            }
            return list[index] >= target && index > low ? (index - 1) : (index);
        }
		
		/**
		 * 最接近
		 */
        public static function closest(list:*, target:Number, low:int = 0, high:int = -1):int
        {
			if (!list.length) return -1;
            if (high < 0)
            {
                high = list.length - 1;
            }
            var index:int = search(list, target, low, high);
            if (list[index] == target || index == 0)
            {
                return index;
            }
            return Math.abs(list[index - 1] - target) < Math.abs(list[index] - target) ? (index - 1) : (index);
        }
		
		/**
		 * 大于或等于
		 */
        public static function greaterThanOrEqual(list:*, target:Number, low:int = 0, high:int = -1):int
        {
			if (!list.length) return -1;
            if (high < 0)
            {
                high = list.length - 1;
            }
            var index:int = search(list, target, low, high);
            if (list[index] < target && index == high)
            {
                return -1;
            }
            return list[index] < target && index < high ? (index + 1) : (index);
        }
		
		/**
		 * 小于或等于
		 */
        public static function lessThanOrEqual(list:*, target:Number, low:int = 0, high:int = -1):int
        {
			if (!list.length) return -1;
            if (high < 0)
            {
                high = list.length - 1;
            }
            var index:int = search(list, target, low, high);
            if (list[index] > target && index == low)
            {
                return -1;
            }
            return list[index] > target && index > low ? (index - 1) : (index);
        }
		
    }
}
