package  
{
	import citrus.core.starling.StarlingState;
	//import Levels.BeachLevel;
	import Levels.TutorialNew;
	import Scenery.StaticBackground;
	import starling.display.Image;
	import Units.AstroVaulter;
	
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Jack Storm
	 */
	public class Menu extends StarlingState 
	{
		private var gameStart:Boolean;
		private var bgMusic:Boolean;
		public function Menu() 
		{
			super();
		}
		
		public override function initialize():void
		{
			super.initialize();
			bgMusic = false;
			Registry.menu = new Image(Registry.menuTexture);
			if (!Registry.firstRun)
			{
				addChild(Registry.menu);
				bgMusic = true;
			}
			gameStart = false;
			stage.addEventListener(TouchEvent.TOUCH, handleTouch)
			
			//Registry.player = new AstroVaulter("AstroVaulter", { group: 2 } );
		
			//Registry.staticBG = new StaticBackground();
			//Registry.staticBG.addStaticBG("sky", Registry.assetManager.getTexture("Gradient_Sky45"), true);
			//Registry.staticBG.addStaticBG("stars1", Registry.assetManager.getTexture("Stars1"), true );
			//Registry.staticBG.addStaticBG("stars2", Registry.assetManager.getTexture("Stars2"), true );
			//Registry.staticBG.addStaticBG("space", Registry.assetManager..getTexture("Gradient_Space45"), true );
			//Registry.staticBG.setAlpha("stars1", 0)
			//Registry.staticBG.setAlpha("stars2", 0)
			//Registry.staticBG.setAlpha("space", 0)
			//Registry.staticBG.setAlpha("sky", 1);
			
			
			
			
		}
		
		private function handleTouch(e:TouchEvent):void 
		{
			var beginTouch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			var	endTouch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if (beginTouch && !gameStart)
			{
				
				gameStart = true;
			}
			else if (endTouch && gameStart)
			{
				//_ce.futureState.destroy();
				this.killAllObjects();
				Registry.currentLevel++;
				_ce.state = new TutorialNew();
				Registry.jukeBox.stopAllSounds();
				stage.removeEventListener(TouchEvent.TOUCH, handleTouch);
			}
		}
		
		public override function update(deltaTime:Number):void
		{
			super.update(deltaTime);
			
			if (bgMusic)
			{
				Registry.jukeBox.playSound("title", 1.0, 5);
				bgMusic = false;
			}
			
			if (Registry.firstRun && gameStart == false)
			{
				gameStart = true;
				_ce.futureState = new TutorialNew();
				stage.removeEventListener(TouchEvent.TOUCH, handleTouch);
			}
			else if (Registry.firstRun && gameStart)
			{
				this.killAllObjects();
				
				_ce.state = _ce.futureState;
			}
		}
		
		
	}

}