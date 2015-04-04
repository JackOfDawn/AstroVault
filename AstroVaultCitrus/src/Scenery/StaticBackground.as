package Scenery 
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.textures.Texture;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.MatrixUtil;
	
	/**
	 * ...
	 * @author Jack Storm
	 */
	public class StaticBackground extends Sprite 
	{
		//private var
		private var _imagesDic:Dictionary;
		private var _imageNames:Array;
		public function StaticBackground() 
		{
			super();
			_imagesDic = new Dictionary();
			_imageNames = new Array();
			//addEventListener(EnterFrameEvent.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(e:Event):void 
		{
			
		}
		
		public function addStaticBG(name:String, texture:Texture, visible:Boolean, scale:Number = 1, layer:int = 0):void
		{
			_imageNames[name] = new Image(texture);
			(_imageNames[name] as Image).scaleX = scale;
			(_imageNames[name] as Image).scaleY = scale;
			
			_imageNames.push(name);
			
			addChildAt((_imageNames[name] as Image), layer);
		}
		
		public function setAlpha(name:String, pAplha:Number):void
		{
			(_imageNames[name] as Image).alpha = pAplha;
		}
		
		public function getAlpha(name:String):Number
		{
			return (_imageNames[name] as Image).alpha;
		}
		
		// NEED TO FIGURE OUT HOW TO ROTATE SCALED OBJECT AROUND CENTER POINT
		public function rotateRadians(name:String, pRotation:Number):void
		{
			var matrix:Matrix;
			//var tmpY;
			var _sprite:Image = (_imageNames[name] as Image);
			var rect:Rectangle;
			
			matrix = _sprite.transformationMatrix;
			rect = _sprite.getBounds(this);
			//translate
			//translate
			matrix.translate(-(rect.left + rect.width / 2), -(rect.top + rect.height / 2));
			
			//rotate
			matrix.rotate(pRotation);
			
			//translate back
			matrix.translate((rect.top + rect.width / 2), (rect.top + rect.height / 2));
		}
		
		public function rotateRadiansAll(pRotation:Number):void
		{
			var matrix:Matrix;
			var _sprite:Image;
			var rect:Rectangle;
			
			for (var i:int = 0; i < _imageNames.length; i++) 
			{
				// ARE YOU FUCKING KIDDING ME? THIS WORKS? WTF
				_sprite = _imageNames[_imageNames[i]];
				rect = _sprite.getBounds(this);
				
				trace(_imageNames[i]);
				matrix = _sprite.transformationMatrix;
			
				//translate
				trace(rect.width, rect.height);
				//matrix.scale(2, 2);
				matrix.translate(-(rect.left + rect.width / 2), -(rect.top + rect.height / 2));
				
				//rotate
				matrix.rotate(pRotation);
				
				//translate back
				matrix.translate((rect.top + rect.width / 2), (rect.top + rect.height / 2));
				
			}
		}
	}

}