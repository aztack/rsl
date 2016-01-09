package com.tudou.utils
{
	import flash.filters.ColorMatrixFilter;
    import flash.text.TextField;
    /**
	 * 可修改动态文双击本选择后的背景色
	 * 
	 * @author 8088 at 2014/7/14 16:38:02
	 */
    public class TextFieldColor
	{
		
        private static const byteToPerc:Number = 1 / 0xff;
		
        private var _textField:TextField;
        private var _textColor:uint;
        private var _selectedColor:uint;
        private var _selectionColor:uint;
        private var _colorMatrixFilter:ColorMatrixFilter;
		
        public function TextFieldColor(textField:TextField, textColor:uint = 0x000000, selectionColor:uint = 0x000000, selectedColor: uint = 0x000000)
		{
			
            this._textField = textField;
            this._textColor = textColor;
            this._selectionColor = selectionColor;
            this._selectedColor = selectedColor;
            this._colorMatrixFilter = new ColorMatrixFilter();
			
            updateFilter();
        }
		
        public function set textField(tf:TextField):void
		{
            this._textField = tf;
        }
		
        public function get textField():TextField
		{
            return this._textField;
        }
		
        public function set textColor(c:uint):void
		{
            this._textColor = c;
            updateFilter();
        }
		
        public function get textColor():uint
		{
            return this._textColor;
        }
		
        public function set selectionColor(c:uint):void
		{
            this._selectionColor = c;
            updateFilter();
        }
		
        public function get selectionColor():uint
		{
            return this._selectionColor;
        }
		
        public function set selectedColor(c:uint):void
		{
            this._selectedColor = c;
            updateFilter();
        }
		
        public function get selectedColor():uint
		{
            return this._selectedColor;
        }
		
        private function updateFilter():void
		{
			
            this._textField.textColor = 0xff0000;
			
            var o:Array = splitRGB(this._selectionColor);
            var r:Array = splitRGB(this._textColor);
            var g:Array = splitRGB(this._selectedColor);
			
            var ro:int = o[0];
            var go:int = o[1];
            var bo:int = o[2];
			
            var rr:Number = ((r[0] - 0xff) - o[0]) * byteToPerc + 1;
            var rg:Number = ((r[1] - 0xff) - o[1]) * byteToPerc + 1;
            var rb:Number = ((r[2] - 0xff) - o[2]) * byteToPerc + 1;
			
            var gr:Number = ((g[0] - 0xff) - o[0]) * byteToPerc + 1 - rr;
            var gg:Number = ((g[1] - 0xff) - o[1]) * byteToPerc + 1 - rg;
            var gb:Number = ((g[2] - 0xff) - o[2]) * byteToPerc + 1 - rb;
			
            this._colorMatrixFilter.matrix = [rr, gr, 0, 0, ro, rg, gg, 0, 0, go, rb, gb, 0, 0, bo, 0, 0, 0, 1, 0];
			
            this._textField.filters = [this._colorMatrixFilter];
            
        }
		
        private static function splitRGB(color:uint):Array
		{
            return [color >> 16 & 0xff, color >> 8 & 0xff, color & 0xff];
        }
    }

}


	