package  
{
	//import Levels.BeachLevel;
	import Levels.TutorialNew;
	import Scenery.ParallaxManagerCamera;
	import Scenery.StaticBackground;
	import starling.display.Image;
	import starling.extensions.Gauge;
	import starling.extensions.SoundManager;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import UI.AstroTextField;
	import Units.Asteroid;
	import Units.AstroVaulter;
	import Units.Pole;
	import Utils.AsteroidManager;
	/**
	 * ...
	 * @author Jack Storm
	 * CONTAINS VARIOUS THINGS THAT ARE CONSTANTLY REUSED;
	 */
	public class Registry 
	{
		public static var currentLevel:int = 0;
		//WORTH A SHOT?
		public static var firstRun:Boolean = true;
		public static var winHeight:Number = 500;
		/*asset Manager*/
		public static var assetManager:AssetManager;
		
		public static var tutorialNew:TutorialNew;
		//public static var beachLevel:BeachLevel;
		
		/*UI BASED ELEMENTS*/
		public static var progressBar:Gauge;
		public static var pbTexture:Texture;
		
		public static var menuTexture:Texture;
		public static var menu:Image;
		
		public static var loading:Image;
		
		/*IN GAME ELEMENTS*/
		public static var pole:Pole;
		public static var player:AstroVaulter;
		public static var asteroidManager:AsteroidManager;
		
		public static var parallaxCamera:ParallaxManagerCamera;
		public static var staticBG:StaticBackground;
		public static var countdownText:AstroTextField;
		public static var altitudeText:AstroTextField;
		
		public static var soundManager:SoundManager;
		public static var jukeBox:SoundManager;
		
		
	}

}