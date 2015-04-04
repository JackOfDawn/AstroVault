package Utils 
{
	import Assets.EmbeddedAssets1x;
	import Assets.EmbeddedAssets2x;
	import Assets.EmbeddedAssets3x;
	import aze.motion.EazeTween;
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import feathers.controls.ProgressBar;
	import Levels.Tutorial;
	import Levels.TutorialNew;
	import Scenery.ParallaxManagerCamera;
	import Scenery.StaticBackground;
	import starling.extensions.Gauge;
	import starling.extensions.SoundManager;
	import UI.AstroTextField;
	import Units.AstroVaulter;

	
	import Registry;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Loadingscreen extends StarlingState 
	{
		
		private var gameStart:Boolean;
		public function Loadingscreen() 
		{
			super();
		}
		
		public override function initialize():void
		{
			gameStart = false;
			super.initialize();
			Registry.progressBar = new Gauge(Registry.pbTexture);
			addChild(Registry.loading);
			addChild(Registry.progressBar);
			loadInAssets();
			
			
		}
		
		public override function update(deltaTime:Number):void
		{
			super.update(deltaTime);
				if (gameStart)
				{
					startGame();
				}
		}
		
		private function loadInAssets():void
		{
			Registry.countdownText = new AstroTextField("AV COUNTDOWN", 400, 400, 100, 0xFFFFFF);
			Registry.parallaxCamera = new ParallaxManagerCamera();
			Registry.altitudeText = new AstroTextField("AV Altitude", 550, 400, 20, 0xFFFFFF);
			Registry.soundManager = new SoundManager();
			Registry.jukeBox = new SoundManager();

			Registry.assetManager.enqueue(EmbeddedAssets1x);
			Registry.assetManager.enqueue(EmbeddedAssets2x);
			Registry.assetManager.enqueue(EmbeddedAssets3x);

			
			Registry.assetManager.loadQueue(function(ratio:Number):void
			{
				Registry.progressBar.ratio = ratio;
				if (ratio == 1.0)
				{
					trace(ratio);
					if (Registry.currentLevel <= 10)
						_ce.futureState = new Menu();
					else
						_ce.futureState = new TutorialNew();
					gameStart = true;
				}
			});
		}
		
		private function startGame(): void
		{
			
			this.killAllObjects();
			_ce.state = _ce.futureState;
			Registry.player = new AstroVaulter("AstroVaulter", { group: 2 } );
			Registry.asteroidManager = new AsteroidManager();
			Registry.staticBG = new StaticBackground();
			Registry.staticBG.addStaticBG("sky", Registry.assetManager.getTexture("Gradient_Sky45"), true);
			Registry.staticBG.addStaticBG("stars1", Registry.assetManager.getTexture("Stars1"), true );
			Registry.staticBG.addStaticBG("stars2", Registry.assetManager.getTexture("Stars2"), true );
			Registry.staticBG.addStaticBG("space", Registry.assetManager..getTexture("Gradient_Space45"), true );
			Registry.staticBG.setAlpha("stars1", 0)
			Registry.staticBG.setAlpha("stars2", 0)
			Registry.staticBG.setAlpha("space", 0)
			Registry.staticBG.setAlpha("sky", 1);
			
			
			Registry.soundManager.addSound("explosion", Registry.assetManager.getSound("explosion"));
			Registry.soundManager.addSound("meteorhit", Registry.assetManager.getSound("meteorhit"));
			Registry.soundManager.addSound("polebend", Registry.assetManager.getSound("polebend"));
			Registry.soundManager.addSound("step1", Registry.assetManager.getSound("step1"));
			Registry.soundManager.addSound("step2", Registry.assetManager.getSound("step2"));
			Registry.soundManager.addSound("stepfast1", Registry.assetManager.getSound("stepfast1"));
			Registry.soundManager.addSound("stepfast2", Registry.assetManager.getSound("stepfast2"));
			//Registry.soundManager.addSound("title", Registry.assetManager.getSound("TitleScreen"));
			
			Registry.jukeBox.addSound("title", Registry.assetManager.getSound("TitleScreen"));
			Registry.jukeBox.addSound("space", Registry.assetManager.getSound("SpaceTunes"));
			//removeChild(Registry.progressBar);
		}
		
		
	}

}