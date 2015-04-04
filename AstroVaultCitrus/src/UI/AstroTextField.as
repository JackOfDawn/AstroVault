package UI 
{
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AstroTextField extends Sprite
	{
		//[Embed(source = "../Assets/Arial.ttf", embedAsCFF = "false", fontFamily = "Arial")]
		//public static const ARIAL:Class;
		
		[Embed(source="../Assets/arialBM_0.png")]
		protected static const FontTexture:Class;
		 
		[Embed(source="../Assets/arialBM.xml", mimeType="application/octet-stream")]
		protected static const FontXml:Class;
		
		private var _text:String;
		private var _textField:TextField;
		
		
		public function AstroTextField(text:String, textFieldWidth:int, textFieldHeight:int, fontSize:Number = 12, color:uint = 0) 
		{
			initDefaultFont();
			_text = text;
			_textField = new TextField(textFieldWidth, textFieldHeight, _text, "Arial", fontSize, color);
			_textField.hAlign = "left";
			_textField.vAlign = "top";
			_textField.border = false;
			addChild(_textField);			
		}
		
		protected function initDefaultFont():void
		{
			var texture:Texture = Texture.fromBitmap(new FontTexture());
			var xml:XML = XML(new FontXml());
			TextField.registerBitmapFont(new BitmapFont(texture, xml));
		}
		
		public function set Text(text:String):void
		{
			_text = text;
			_textField.text = _text;
		}
		
		public function set FontSize(fontSize:Number):void
		{
			_textField.fontSize = fontSize;
		}
		
		public function set Scale(scale:Number):void
		{
			_textField.scaleX = scale;
			_textField.scaleY = scale;
		}
		
		public function set RotationRad(angle:Number):void
		{
			_textField.rotation = angle;
		}
		
		public function set RotationDeg(angle:Number):void
		{
			angle = angle * (Math.PI / 180);
			_textField.rotation = angle;
		}
		
		public function kill():void
		{
			removeChild(_textField);
		}
		
	}

}