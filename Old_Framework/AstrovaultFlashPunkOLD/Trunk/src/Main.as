package 
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Screen;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Jack Storm
	 */
	
	 
	public class Main extends Engine 
	{
		private var landscape:Boolean;
		public function Main():void 
		{
			super(400, 400, 30);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//stage.addEventListener(Event.DEACTIVATE, deactivate);

			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			
			// new to AIR? please read *carefully* the readme.txt files!
		}
		
		override public function init():void
		{
			landscape = true;
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, OnOrientationChange);
		
			FP.world = new TestWorld();
			
			//stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			resize();
			super.init();
		}
		
		private function OnOrientationChange(e:StageOrientationEvent):void
		{
			resize();
		}
		
		private function resize():void 
		{
			if (stage && stage.orientation == StageOrientation.ROTATED_RIGHT)
			{
				FP.width = stage.stageWidth;
				FP.height = stage.fullScreenHeight;
				FP.halfHeight = FP.height / 2;
				FP.halfWidth = FP.width / 2;
				FP.screen = new Screen;
				FP.bounds = new Rectangle(0, 0, FP.width, FP.height);
				Draw.resetTarget();	
			}
			else if (stage && stage.orientation == StageOrientation.DEFAULT)
			{
				FP.width = stage.fullScreenHeight;
				FP.height = stage.stageWidth;
				FP.halfHeight = FP.height / 2;
				FP.halfWidth = FP.width / 2;
				FP.screen = new Screen;
				FP.bounds = new Rectangle(0, 0, FP.width, FP.height);
				Draw.resetTarget();	
				
			}
			
			FP.console.enable();
		}
		
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}