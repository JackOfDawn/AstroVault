package Scenery 
{
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.utils.Dictionary;
	import starling.events.EnterFrameEvent;
	import starling.extensions.krecha.ScrollImage;
	import starling.extensions.krecha.ScrollTile;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ...
	 */
	public class ParallaxManagerForced extends Sprite
	{
		
		private var _speed:Number;
		private var _imagesDic:Dictionary;
		private var _imageNames:Array;
		
		public function ParallaxManagerForced(speed:Number) 
		{
			_speed = speed;
			_imagesDic = new Dictionary();
			_imageNames = new Array();
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(e:Event):void 
		{
			var image:ScrollImage;

			for (var i:int = 0; i < _imageNames.length; i++) 
			{
				image = _imagesDic[_imageNames[i]];
				image.tilesOffsetX -= _speed;
			}
		}
		
		public function addParallax(name:String, parallax:Number, texture:Texture, x:int, y:int, scale:Number):void
		{
			_imagesDic[name] = new ScrollImage(800, texture.height * scale);
			
			var scrollTile:ScrollTile = (_imagesDic[name] as ScrollImage).addLayer(new ScrollTile(texture, true));
			scrollTile.paralax = parallax;
			scrollTile.scaleY = scale;
			scrollTile.scaleX = scale
			(_imagesDic[name] as ScrollImage).x = x;
			(_imagesDic[name] as ScrollImage).y = y;
			
			_imageNames.push(name);
			addChild(_imagesDic[name]);
		}
		
		public function deleteParallax(name:String):void
		{
			for (var i:int = 0; i < _imageNames.length; i++) 
			{
				if (_imageNames[i] == name)
				{
					removeChild(_imagesDic[name]);
					delete _imagesDic[name];
					_imageNames.splice(i, 1);
					break;
				}
			}
		}
		
		public function adjustForcedSpeed(value:Number):void
		{
			_speed = value;
		}
		
	}

}