package Levels 
{
	import citrus.core.starling.StarlingState;
	import citrus.math.MathUtils;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.nape.Platform;
	import citrus.physics.nape.Nape;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingCamera;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import nape.geom.Vec2;
	import Obstacles.CollisionBox;
	import Scenery.ParallaxBackground;
	import Scenery.ParallaxBGTest;
	import starling.textures.Texture;
	import Units.AstroVaulter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ParallaxTest extends StarlingState 
	{
		[Embed(source = "../Assets/TestAssets/testBG.png")] private static const BG1:Class;
		[Embed(source="../Assets/TestAssets/testBG2.png")] private static const BG2:Class;
		private const COUNTDOWN_TIME:int = 3; // seconds
		public static var publicDeltaTime:Number;
		
		
		/* public */
		public var player:AstroVaulter;
		public var nape:Nape;
		public var parallaxBG:Vector.<ParallaxBackground>;
		public var mainPhase:int = 0; // -1: No Start, 0: Sprint, 1: Pole Jump, 2: Launch, 3: Space
		
		/* protected */
		protected var _camTarget:Point = new Point();
		protected var _camera:StarlingCamera;
		protected var _roomParam:Point = new Point();
		protected var _countdown:Number = COUNTDOWN_TIME;
		
		/* private */
		
		
		public function ParallaxTest(_roomWidth:Number, _roomHeight:Number) 
		{
			super();
			_roomParam.x = _roomWidth;
			_roomParam.y = _roomHeight;
		}
		
		override public function initialize():void
		{
			super.initialize();
			//view.camera.enabled = true;
			
			/* graphics */
			var BGtexture1:Texture = Texture.fromBitmap(new BG1 as Bitmap);
			var BGtexture2:Texture = Texture.fromBitmap(new BG2 as Bitmap);
			
			
			/* entities */
			nape = new Nape("Nape", { gravity: new Vec2( 0, 150 ) } );
			add(nape);
			
			var bg2:ParallaxBackground = new ParallaxBackground("BG2", { x: -75, y: stage.stageHeight - BGtexture2.height, parallaxX: 0.2, group: 0, view: BGtexture2 } );
			//add(bg2);
			var bg3:CitrusSprite = new CitrusSprite ("BG3", {y: stage.stageHeight, parallaxX: 0, group: 0, view: new ParallaxBGTest()} );
			add(bg3);
			var bg1:ParallaxBackground = new ParallaxBackground("BG1", { x: 0, y: stage.stageHeight - (BGtexture1.height /2), parallaxX: 0.5, group: 0, view: BGtexture1 } );
			//add(bg1);
			
			// the vectors into one nice vector
			parallaxBG = new Vector.<ParallaxBackground>;
			parallaxBG.push(bg1, bg2);
			
			//scaleBackgrounds(1, 1);
			
			var wall:CollisionBox = new CollisionBox( "Floor", { x: 0, y: stage.stageHeight, group: 1, width: _roomParam.x, height: 32 } );
			add(wall);
			/*for (var i:int = 0; i < 400; i++) 
			{
				wall = new CollisionBox( "Floor", { x:wall.width * i, y: stage.stageHeight } );
				add(wall);
			}*/
			
			
			
			player = new AstroVaulter( "AstroVaulter", { x: 0, y: 0, group: 2} );
			add(player);
			
			/* camera */
			_camera = view.camera as StarlingCamera; // a reference for future use
			
			_camera.setUp(_camTarget, null, new Point(0.5, 0.5));
			 
			_camera.bounds = new Rectangle(0, 0, _roomParam.x, _roomParam.y);
			_camera.allowRotation = true;
			_camera.allowZoom = true;
			_camera.easing.setTo(.5, .5);
			_camera.rotationEasing = 1;
			_camera.zoomEasing = 1;	
			_camera.zoomFit(_ce.baseWidth, _ce.baseHeight, true);
			_camera.reset();
		}
		
		override public function update(deltaTime:Number):void 
		{
			super.update(deltaTime);
		
			//trace(MathUtils.lerp(0, 1, deltaTime));
			
			_camTarget.x = player.x + (player.width * .5);
			_camTarget.y = player.y + (player.height * .5);
		}
		
		public function scaleBackgrounds(scaleX:Number, scaleY:Number):void
		{
			for (var i:int = 0; i < parallaxBG.length; i++) 
			{
				view.getArt(parallaxBG[i]).scaleX = scaleX;
				view.getArt(parallaxBG[i]).scaleY = scaleY;
			}
			
		}
		
	
	}

}