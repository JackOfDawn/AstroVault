package 
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Jack Storm
	 */
	public class Main extends Sprite 
	{
		private var _starling:Starling;
		public function Main():void 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		public function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_starling = new Starling(screen1, this.stage, new Rectangle(0,0, stage.fullScreenWidth, stage.fullScreenHeight));
			_starling.start();
			
			var isDavePhone:Boolean  = (stage.fullScreenWidth == 1920 || stage.fullScreenHeight == 1020); 
			_starling.stage.stageWidth =  isDavePhone ? 480 : 480
			_starling.stage.stageHeight = isDavePhone ? 270 : 260;
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}