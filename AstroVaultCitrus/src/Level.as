package  
{
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.view.starlingview.AnimationSequence;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import Main;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Jack Storm
	 */
	public class Level extends StarlingState 
	{
		private var textureAtlas:TextureAtlas;
		private var spr:CitrusSprite;
		
		public function Level() 
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
				
			textureAtlas = Main.assetManager.getTextureAtlas("Player");
			var texture:Texture = textureAtlas.getTexture("00MC_running0000");
			var heroSeq:AnimationSequence = new AnimationSequence(textureAtlas, ["Running"], "Running", 20, true);
			(heroSeq.mcSequences["Running"] as MovieClip).fps = 20;
			heroSeq.changeAnimation("Running", true);
			//heroSeq.scaleX = .25;
			//heroSeq.scaleY = .25;

			
			spr = new CitrusSprite("CircleTest", { x:50, y:100, height:texture.height, width:texture.width, view:heroSeq } );

			add(spr);
			
			
			stage.addEventListener(TouchEvent.TOUCH, handleTouch);

		}
		
		private function handleTouch(e:TouchEvent):void
		{
			var beginTouch:Touch  =  e.getTouch(stage, TouchPhase.BEGAN);
			var endTouch:Touch  =  e.getTouch(stage, TouchPhase.ENDED);
			
			if (beginTouch)
			{
				//trace("test");
				spr.velocity  = [5, 0];
			}
			if (endTouch)
			{
				//trace("test");
				spr.velocity  = [-5, 0];
			}
		}
		
		override public function update(deltaTime:Number):void
		{
			//trace("HELLO");
			super.update(deltaTime);
			spr.x += spr.velocity[0];
		}	
		
		
	}

}