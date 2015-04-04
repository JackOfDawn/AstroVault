package Scenery 
{
	import citrus.objects.CitrusSprite;
	import feathers.controls.ScrollBar;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.extensions.krecha.ScrollImage;
	import starling.extensions.krecha.ScrollTile;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ...
	 */
	public class ParallaxBGTest extends Sprite 
	{
		[Embed(source = "../Assets/TestAssets/testBG.png")] private static const BG1:Class;
		[Embed(source = "../Assets/TestAssets/testBG2.png")] private static const BG2:Class;
		
		private var _forestFront:ScrollImage;
		private var _forestBack:ScrollImage;
		private var speed:Number;
		public function ParallaxBGTest() 
		{
			super();
			var scrollTile:ScrollTile;
			
			_forestBack = new ScrollImage(800, 239);
			scrollTile = _forestBack.addLayer(new ScrollTile(Texture.fromBitmap(new BG2()), true));
			scrollTile.paralax = .2;
			
			_forestFront = new ScrollImage(800, 480);
			scrollTile = _forestFront.addLayer(new ScrollTile(Texture.fromBitmap(new BG1()), true));
			scrollTile.paralax = .5;
			
			addChild(_forestBack);
			addChild(_forestFront);
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(e:EnterFrameEvent):void 
		{
			_forestBack.tilesOffsetX -= 1
			_forestFront.tilesOffsetX -= 1;
		}
		
	}

}