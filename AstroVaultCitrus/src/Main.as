package 
{
	import Assets.EmbeddedAssets1x;
	import Assets.EmbeddedAssets2x;
	import Assets.EmbeddedAssets3x;
	import citrus.core.IState;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.core.starling.ViewportMode;
	import flash.filesystem.File;
	import Levels.ParallaxTest;
	import Levels.Tutorial;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	import Utils.Loadingscreen;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * ...
	 * @author Jack Storm
	 */
	public class Main extends StarlingCitrusEngine
	{
		//public static var assetManager:AssetManager;
		[Embed(source = "Assets/ProgressBarTexture.png")] public static const ProgressBarTexture:Class;
		[Embed(source = "Assets/Menu.png")] public static const MENU:Class;
		[Embed(source = "Assets/LoadingScreen.png")] public static const LOADING:Class;
		//[Embed(source="Assets/007_ASTROVAULT.png")] public static const LOGO:Class;
		
		public static var stateTest:IState;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			_baseWidth = 270;
			_baseHeight = 480;
			_viewportMode = ViewportMode.FULLSCREEN;
			_assetSizes = [1];
			
			stateTest = state;
		
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}

		override protected function handleAddedToStage(e:Event):void
		{
			super.handleAddedToStage(e);
			_context3DProfileTestDelay = 0;
			setUpStarling(false);
		}
		
		override public function handleStarlingReady():void
		{
			initAssetmanager();
			Registry.pbTexture = Texture.fromBitmap(new ProgressBarTexture());
			Registry.menuTexture = Texture.fromBitmap(new MENU());
			Registry.loading = new Image(Texture.fromBitmap(new LOADING()));
			state = new Loadingscreen();
			//initAssetmanager();
		}
		
		private function initAssetmanager():void
		{
			
			//assetManager = new AssetManager();
			Registry.assetManager = new AssetManager();
			
			/*
			//assetManager.enqueue("Assets/Assets1x/GroundAssets.xml");
			//assetManager.enqueue("Assets/Assets1x/GroundAssets.png");
			 
			assetManager.enqueue(EmbeddedAssets1x);
			assetManager.enqueue(EmbeddedAssets2x);
			//xml = EmbeddedAssets1x.getXML();
			//atlas = EmbeddedAssets1x.getTexture();
			//textureAtlas = new TextureAtlas(atlas, xml);
			//assetManager.addTextureAtlas("TestAtlas", textureAtlas);
		
			
			//xml = XML(new EmbeddedAssets1x.PlayerXML());
			//atlas = Texture.fromBitmap(new EmbeddedAssets1x.Player())
			
			
			//textureAtlas = new TextureAtlas(atlas, xml);
			//assetManager.addTextureAtlas("Player", textureAtlas)
			
			assetManager.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					trace(ratio);
					startGame();
				}
			});
			*/
			
		}
		

		
	}
}