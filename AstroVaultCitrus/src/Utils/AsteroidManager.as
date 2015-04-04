package Utils 
{
	import citrus.core.starling.StarlingState;
	import Units.Asteroid;
	import Units.AstroVaulter;
	/**
	 * ...
	 * @author ...
	 */
	public class AsteroidManager
	{
		
		private var _asteroids:Array;
		private var _state:StarlingState;
		private const NUM_ASTEROIDS:int = 10;
		private var _player:AstroVaulter = Registry.player;
		public function AsteroidManager() 
		{
			_asteroids = new Array();
		}
		
		public function createAsteroids():void
		{
			for (var i:int = 0; i < NUM_ASTEROIDS; i++) 
			{
				_asteroids.push(new Asteroid ("asteroid" + i.toString()));
			}
		}
		
		public function changeState(state:StarlingState):void
		{
			_state = state;
		}
		
		public function addToState():void
		{
			for (var i:int = 0; i < NUM_ASTEROIDS; i++) 
			{
				_state.add(_asteroids[i])
			}
		}
		
		public function spawnAsteroid():void
		{
			var xLoc:int = _player.x - 700 + (Math.random() * 1400);
			var yLoc:int = _player.y - (Math.random() * 1000) - 1000;
			
			var asteroid:Asteroid;
			
			for (var i:int = 0; i < NUM_ASTEROIDS ; ++i) 
			{
				if ((_asteroids[i] as Asteroid).isAlive == false)
				{
					asteroid = _asteroids[i];
					break;
				}
			}
			
			if (asteroid != null)
				asteroid.spawn(xLoc, yLoc);
		}
		
		public function get asteroids():Array 
		{
			return _asteroids;
		}
		
		
		
	}

}