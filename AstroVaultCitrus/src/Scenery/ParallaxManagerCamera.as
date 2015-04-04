package Scenery 
{
	import citrus.view.starlingview.StarlingCamera;
	import flash.desktop.InteractiveIcon;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.extensions.krecha.ScrollImage;
	import starling.extensions.krecha.ScrollTile;
	import starling.textures.Texture;
	import Utils.Precision;
	/**
	 * ...
	 * @author ...
	 */
	public class ParallaxManagerCamera extends Sprite
	{
		private var _cameraRef:StarlingCamera;
		private var _cameraPreviousPosX:Number;
		private var _cameraPreviousPosY:Number;
		private var _imagesDic:Dictionary;
		private var _imageNames:Array;
		
		public function ParallaxManagerCamera():void 
		{
			_imagesDic = new Dictionary();
			_imageNames = new Array();
			//addEventListener(EnterFrameEvent.ENTER_FRAME, onEnter);
		}
		
		public function addCameraRef(cameraRef:StarlingCamera):void
		{
			_cameraRef = cameraRef;
			_cameraPreviousPosX = _cameraRef.camPos.x
		}
		
		public function set enabled(value:Boolean):void
		{
			value ? addEventListener(EnterFrameEvent.ENTER_FRAME, onEnter) : removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(e:EnterFrameEvent):void 
		{
			var image:ScrollImage;
			var offSetX:Number,
				offSetY:Number;
			
			offSetX = -(_cameraPreviousPosX  - _cameraRef.camPos.x); // changed by RYAN
			//trace(_cameraRef.baseZoom);
			//offSetY = -(_cameraPreviousPosY  - _cameraRef.camPos.y); // added by RYAN
			//trace(_cameraPreviousPosX, Precision.setPrecision(_cameraRef.camPos.x, 0));
			for (var i:int = 0; i < _imageNames.length; i++) 
			{
				image = _imagesDic[_imageNames[i]];
				image.setCanvasSize(_cameraRef.cameraLensWidth * (1 / _cameraRef.getZoom()), image.texture.height); // added by RYAN
				//trace(offSet);
				image.tilesOffsetX -= offSetX;
				//(_imageDic[_imageNames[i]] as ScrollImage).tilesOffsetY = 
			}
			
			_cameraPreviousPosX = _cameraRef.camPos.x;
			//_cameraPreviousPosY = _cameraRef.camPos.y;
		}
		
		public function addParallax(name:String, parallax:Number, texture:Texture, x:int, y:int, scale:Number):void
		{
			_imagesDic[name] = new ScrollImage(_cameraRef.cameraLensWidth, texture.height * scale);
			var scrollTile:ScrollTile = (_imagesDic[name] as ScrollImage).addLayer(new ScrollTile(texture, true));
			scrollTile.paralax = parallax;
			scrollTile.scaleX = scale;
			scrollTile.scaleY = scale;
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
		
		public function set cameraRef(value:StarlingCamera):void 
		{
			_cameraRef = value;
		}
	
	}

}