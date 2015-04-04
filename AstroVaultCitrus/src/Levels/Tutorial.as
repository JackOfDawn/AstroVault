package Levels 
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.math.MathUtils;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.nape.Platform;
	import citrus.physics.nape.Nape;
	import citrus.view.spriteview.SpriteArt;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingCamera;
	import citrus.view.starlingview.StarlingView;
	import feathers.controls.TextArea;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import nape.geom.Vec2;
	import Obstacles.CollisionBox;
	import Scenery.ParallaxBackground;
	import Scenery.ParallaxManagerCamera;
	import Scenery.ParallaxManagerForced;
	import Scenery.StaticBackground;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	import UI.AstroTextField;
	import UI.StarlingScoreBoard;
	import Units.AstroVaulter;
	import Utils.InputManager;
	import Utils.Loadingscreen;
	import Utils.Precision;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Tutorial extends StarlingState 
	{
		/*[Embed(source = "../Assets/TestAssets/Track.png")] private static const TRACK:Class;
		[Embed(source = "../Assets/TestAssets/Gradient_Sky.png")] private static const BLUESKY:Class;
		[Embed(source = "../Assets/TestAssets/Fence.png")] private static const FENCE:Class;
		[Embed(source = "../Assets/TestAssets/Mountain.png")] private static const MOUNTAIN:Class;
		[Embed(source = "../Assets/TestAssets/testBG2.png")] private static const BG2:Class;
		[Embed(source = "../Assets/TestAssets/Vaulting_Pad.png")] private static const PAD:Class;*/
		
		private const COUNTDOWN_TIME:int = 5; // seconds
		public static var publicDeltaTime:Number;
		
		/* public */
		public var player:AstroVaulter;
		public var nape:Nape;
		public var parallaxBG:Vector.<ParallaxBackground>;
		public var mainPhase:int = -1; // -1: No Start, 0: Sprint, 1: Pole Jump, 2: Launch, 3: Space
		public var inputManager:InputManager;
		public var wall:CollisionBox;
		
		// scene
		
		/* protected */
		protected var _camTarget:Point = new Point();
		protected var _camera:StarlingCamera;
		protected var _roomParam:Point = new Point();
		protected var _countdown:Number = COUNTDOWN_TIME;

		
		/* private */
		private var _cameraOffset:Point = new Point(0, 0),
					_cameraCenter:Point = new Point(0, 0);
		private var _cameraShake:Boolean = false,
					_cameraEaseOut:Boolean = false;
		private var _shakeIntensity:Number = 0,
					_shakeTime:Number = 0,
					_shakeEasing:Number = 0,
					_transitionTime:Number = 0,
					_totalTransTime:Number = 0;
		// phase one
		private var _countdownSprite:CitrusSprite;
		private var _countdownSpriteRef:Sprite;
		private var _countdownText:AstroTextField;
		private var _countdownAlive:Boolean = false;
		private var _playerStart:Point,
					_barLocation:Point,
					_poleLocation:Point;
		private var _percentToBar:Number,
					_percentToPole:Number,
					_distanceFromStartActual:Number,
					_distanceFromStartWorld:Number,
					_distanceToBarActual:Number,
					_distanceToBarWorld:Number,
					_startPhaseTwoDistance:Number; // percentage of total distance to bar
					
		// phase two
		private var _camEasing:Point = new Point(0, 0);
		private var _distanceFromFloorActual:Number,
					_distanceFromFloorWorld:Number,
					_floorPosition:Number,
					_easingRate:Number = .02,
					_cameraZoom:Number = .25,
					_findTime:Number = 0, 
					_findTimeTarget:Number = 3,
					_timeFound:Number = 0,
					_timeFoundTarget:Number = 2,
					_camRot:Number = 0;
		private var _playerFound:Boolean = false,
					_cameraLaunch:Boolean = false;
					
		private var _staticBG:StaticBackground;
		
		
		public function Tutorial(_roomWidth:Number = 10000, _roomHeight:Number = 10000, _barDistancePercent:Number = .75, _poleDistancePercent:Number = .25, _phaseTwoDist:Number = .8) 
		{
			super();
			_roomParam.x = _roomWidth;
			_roomParam.y = _roomHeight;
			_startPhaseTwoDistance = _phaseTwoDist;
			_percentToBar = _barDistancePercent;
			_percentToPole = _poleDistancePercent;
		}
		
		override public function initialize():void
		{
			super.initialize();
			/* init input*/
			inputManager = new InputManager();
			inputManager.initialize();
			inputManager.enabled = true;
			
			
			
			/* init variables */
			_playerStart = new Point( 75, 0 );
			_barLocation = new Point(( _roomParam.x * _percentToBar) + _playerStart.x, 0 );
			_poleLocation = new Point(( _roomParam.x * _percentToPole) + _playerStart.x, 0);
			//TODO:Ryan - Create pole object at _poleLocation
			
			
			/* graphics */
			var _skyTexture:Texture = Registry.assetManager.getTexture("Gradient_Sky45");
			var _mountainTexture:Texture =  Registry.assetManager.getTexture("Mountain");
			var _fenceTexture:Texture =  Registry.assetManager.getTexture("Fence");
			//var _bGtexture2:Texture =  Registry.assetManager.getTexture("Gradient_Sky");
			var _trackTexture:Texture =  Registry.assetManager.getTexture("Track");
			var _padTexture:Texture =  Registry.assetManager.getTexture("vaultAndPole");
			
			_staticBG = new StaticBackground();
			
			/* entities */
			nape = new Nape("Nape", { gravity: new Vec2( 0, 300 ) } );
			add(nape);
			
			//scaleBackgrounds(1, 1);
			
			wall = new CollisionBox( "Floor", { x: 0 + _roomParam.x * .5, y: _roomParam.y - 30, group: 1, width: _roomParam.x, height: 32 } );
			add(wall);
			view.getArt(wall).scaleX = _roomParam.x / wall.height;
			//trace(wall.y);
			
			//player = new AstroVaulter( "AstroVaulter", { x: _playerStart.x, y: wall.y, group: 2} );
			player = new AstroVaulter( "AstroVaulter", { x: _playerStart.x, y: _roomParam.y - 100, group: 2 } );
			
			_floorPosition = player.y;
			add(player);
			
			/* camera */
			setUpCamera();
			var parallaxCam:ParallaxManagerCamera = new ParallaxManagerCamera(_camera);
			//parallaxCam.addParallax("Sky", 0, _skyTexture, 0, _roomParam.y - _skyTexture.height, 1);
			parallaxCam.addParallax("Mountain", .04, _mountainTexture, 0, _roomParam.y - _mountainTexture.height, 1);
			parallaxCam.addParallax("Fence", .45, _fenceTexture, 0, _roomParam.y - _fenceTexture.height/2 - _trackTexture.height/2, .5);
			parallaxCam.addParallax("Track", 0, _trackTexture, 0, _roomParam.y - _trackTexture.height /2, .5);
			add(new CitrusSprite("BG3", { x:0, y:0, parallaxX: 0, group:0, view:parallaxCam } ));
			//addChild(parallaxCam);
			/* static bg */
			var padScale:Number = .5;
			var pad:CitrusSprite = new CitrusSprite("Pad", { x: _barLocation.x, y: _roomParam.y - (_trackTexture.height) * .5 - _padTexture.height *.66, view:_padTexture, group: 1 } );
			add(pad);
			
			_staticBG.addStaticBG("sky", _skyTexture, true);
			_staticBG.addStaticBG("stars1", Registry.assetManager.getTextureAtlas("SpaceAssets").getTexture("Stars1"), true );
			_staticBG.addStaticBG("stars2", Registry.assetManager.getTextureAtlas("SpaceAssets").getTexture("Stars2"), true );
			_staticBG.addStaticBG("space", Registry.assetManager.getTextureAtlas("SpaceAssets").getTexture("Gradient_Space45"), true );
			_staticBG.setAlpha("stars1", 0)
			_staticBG.setAlpha("stars2", 0)
			_staticBG.setAlpha("space", 0)
			_staticBG.setAlpha("sky", 1);
			addChild(_staticBG);
			swapChildren((view as StarlingView).viewRoot as Sprite, _staticBG);
			//var _padSpriteRef:Sprite = (this.view.getArt(pad) as Sprite);
			//_padSpriteRef.scaleX = padScale;
			//_padSpriteRef.scaleY = padScale;
			
			//trace(player.y, pad.y);
			
			/* textfields */
			_countdownText = new AstroTextField("AstroVault", 400, 400, 100, 0xFFFFFF);
			_countdownText.RotationDeg = -30;
			_countdownSprite = new CitrusSprite("ScoreTest", { x:200, y:100, parallaxX:0 , parallaxY:0, group:2, view:_countdownText} );
			add(_countdownSprite);
			_countdownAlive = true;
			_countdownSpriteRef = this.view.getArt(_countdownSprite) as Sprite;
		}
		
		override public function update(deltaTime:Number):void 
		{
			//(this.view.getArt(_countdownSprite) as Sprite).alpha -= .01;
			super.update(deltaTime);
			publicDeltaTime = deltaTime;
			player.mainPhase = mainPhase;
			_distanceFromStartActual = player.x - _playerStart.x;
			_distanceFromStartWorld = Precision.setPrecision(_distanceFromStartActual / 100, 2); // convert to meters
			_distanceFromFloorActual = Math.abs(player.y - _floorPosition);
			_distanceFromFloorWorld = Precision.setPrecision(_distanceFromFloorActual / 10, 2);
			_distanceToBarActual = _barLocation.x - player.x;
			_distanceToBarWorld = Precision.setPrecision(_distanceToBarActual / 100, 2)
			//trace(_distanceFromStartWorld);
			
			//_staticBG.setAlpha("sky", _staticBG.getAlpha("sky") - .001);
			
			//WTF
			//_staticBG.rotateRadians("space", player.y);
			
			/* phases */
			handlePhases();
			
			handleCameraFollow();
			
			if (_ce.input.justDid("up"))
			{
				trace("restart");
				restartLevel();
			}
		}
		private function restartLevel():void 
		{
			this.clean();
			this.killAllObjects();
			Registry.assetManager.dispose();
			_ce.state = new Loadingscreen();
		}
		
		public function clean():void 
		{
				
			if (_countdownText != null)
			{
				_countdownText.kill();
			}
	
		}

		
		/* custom methods */
		public function scaleBackgrounds(scaleX:Number, scaleY:Number):void
		{
			for (var i:int = 0; i < parallaxBG.length; i++) 
			{
				view.getArt(parallaxBG[i]).scaleX = scaleX;
				view.getArt(parallaxBG[i]).scaleY = scaleY;
			}
		}
		
		private function setUpCamera():void
		{
			_camTarget.x = player.x + (player.width * .5) + _cameraOffset.x;
			_camTarget.y = player.y + (player.height * .5) + _cameraOffset.y;
			
			_camera = view.camera as StarlingCamera; // a reference for future use
			
			_camera.setUp(_camTarget, null, new Point(0.45, 0.75));
			_cameraCenter = _camera.center;
			 
			_camera.bounds = new Rectangle(0, 0, _roomParam.x, _roomParam.y);
			_camera.allowRotation = true;
			_camera.allowZoom = true;
			_camera.easing.setTo(.5, .5);
			_camera.rotationEasing = 1;
			_camera.zoomEasing = 1;	
			_camera.zoomFit(_ce.baseWidth, _ce.baseHeight, true);
			_camera.reset();
		}
		
		/* camera shizzle */
		private function handleCameraFollow():void
		{
			_camTarget.x = player.x + (player.width * .5) + _cameraOffset.x;
			_camTarget.y = player.y + (player.height * .5) + _cameraOffset.y;
		}
		
		public function startCameraShake(_duration:Number = 1, _intensity:Number = 20, _ease:Number = 0):void
		{
			if (_cameraShake == false)
			{
				_cameraShake == true;
				_shakeTime = _duration;
				_shakeIntensity = _intensity;
				_shakeEasing = _ease;
				if (_ease > 0)
				{
					_cameraEaseOut = true;
				}
				addEventListener(EnterFrameEvent.ENTER_FRAME, shakeCamera);
			}
		}
		
		private function shakeCamera(e:EnterFrameEvent):void 
		{
			_shakeTime = Math.max(0, _shakeTime - publicDeltaTime);
			_cameraOffset.x = Math.random() * _shakeIntensity;
			_cameraOffset.y = Math.random() * _shakeIntensity;
			
			if (_cameraEaseOut == true)
			{
				_shakeIntensity = Math.max(0, _shakeIntensity - _shakeEasing);
				if (_shakeIntensity <= 0)
				{
					_cameraOffset.setTo(0, 0);
					_cameraEaseOut = false;
					removeEventListener(EnterFrameEvent.ENTER_FRAME, shakeCamera);
				}
			}
			else
			{
				if (_shakeTime <= 0)
				{
					_cameraOffset.setTo(0, 0);
					_cameraEaseOut = false;
					removeEventListener(EnterFrameEvent.ENTER_FRAME, shakeCamera);
				}
			}
		}
		
		
		/* phase stuff */
		
		private function handlePhases():void 
		{
			
			if (_countdownAlive == true)
			{
				_countdown = Math.max( -2, _countdown - publicDeltaTime);
				
				if (_countdownText != null && _countdown <= 0)
				{
					_countdownText.Text = "TAP RIGHT";
				}
				else
				{
					_countdownText.Text = String(Math.ceil(_countdown));
				}
				
				if (_countdown <= -2 && _countdownSpriteRef.alpha <= 0)
				{
					remove(_countdownSprite);
					_countdownText.kill();
					_countdownText = null;
					_countdownAlive = false;
					//trace("CT DEAD");
					
				}
			}
			switch (mainPhase)
			{
				case -1: // no start: Countdown
					//_countdownText.scale = 5;
					//trace(Math.ceil(_countdown));
					countDown();
					break;
				case 0: // sprint
					phaseZero();
					break;
				case 1: // pole vault
					phaseOne();
					break;
				case 2:
					phaseTwo();
					break;
				case 3:
					break;
			}
		}
		
		private function phaseTwo():void 
		{
			trace("SPACE");
			
		}
		
		private function phaseOne():void 
		{
			// handle camera follow of player and find
			//trace(_distanceFromFloorWorld);
			if (player.launched == true)
			{
				/*/* change screen "orientation" 
				_camRot = Math.min(90, _camRot + 10);
				var _camRotRad:Number = _camRot * (Math.PI / 180);
				_camera.setRotation(_camRotRad);
				trace(_camRot, _camRotRad);*/
				// do once
				if (_cameraLaunch == false)
				{
					//_camera.center.setTo(.25, .5);
					_camera.center.setTo(.5, .5);
					_cameraCenter.setTo(.5, .5);
					_camera.zoomEasing = .1;
					_camera.zoom(_cameraZoom);
					_cameraLaunch = true;
					startCameraShake(1.5, 275, 2.8);
					startTransitionSkyToSpace(4.5);
				}
						
				_camEasing.x = Math.min(1, _camEasing.x + _easingRate);
				_camEasing.y = Math.min(1, _camEasing.y + _easingRate);
				
				_camera.easing = _camEasing;
				
				if (_camera.contains(player.x, player.y) && _playerFound == false )
				{
					_findTime = Math.min(_findTimeTarget, _findTime + publicDeltaTime);
					//trace(_findTime);
				}
				else
				{
					
				}
				
				if (_findTime == _findTimeTarget && _playerFound == false)
				{
					_camera.zoomEasing = .025;
					_camera.setZoom(.8);
					_playerFound = true;
					trace("FOUND");
				}
				
				//TODO: RYAN -do camera rotate/orientation switch after the camera finds and zooms back into the player
				if (_playerFound == true)
				{
					_timeFound = Math.min(_timeFoundTarget, _timeFound + publicDeltaTime);
					if (_timeFound == _timeFoundTarget)
					{
						// break sound barriers
						
						// hit space and rotate camera (prompt player)
						var _prevRot:Number = _camRot,
							_dif:Number = 0;
						_camRot = Math.max( -90, _camRot - 8);
						
						_dif = -Math.abs(_prevRot - _camRot);
						var _camRotRad:Number = _camRot * (Math.PI / 180),
							_camRotRadDif:Number = _dif * (Math.PI / 180);
						_camera.setRotation(_camRotRad);

						_staticBG.rotateRadians("space", _camRotRadDif);
						_staticBG.rotateRadians("stars1", _camRotRadDif);
						_staticBG.rotateRadians("stars2", _camRotRadDif);
						_staticBG.rotateRadians("sky", _camRotRadDif);
						_cameraCenter.x = Math.min(.85, _cameraCenter.x + .02);
						_cameraCenter.y = Math.min(.6, _cameraCenter.y + .02);
						_camera.center = _cameraCenter;
					}
					
					if (_camRot == -90)
					{
						//_camEasing.setTo(.1, .1);
						//_cameraCenter.setTo(.5, .5);
						mainPhase = 2;
					}
					
				}
			}
			else if (player.launched == false)
			{
				player.distanceToBarActual = _distanceToBarActual;
				player.distanceToBarWorld = _distanceToBarWorld;
				
				_cameraCenter.x = Math.max(.25, _cameraCenter.x - .005);
				//_cameraCenter.y = Math.max(.5, _cameraCenter.y + .025);
				_camera.center = _cameraCenter;
			}
		}
		
		private function phaseZero():void 
		{
			var totalDistanceCoveredPercent:Number = _distanceFromStartActual / _barLocation.x;
			//trace(Precision.setPrecision(_barLocation.x - _playerStart.x, 2));
			//trace(Precision.setPrecision(totalDistanceCoveredPercent, 2), _distanceFromStartWorld);
			if (mainPhase == 0 && totalDistanceCoveredPercent >= _startPhaseTwoDistance)
			{
				//startCameraShake(1, 10);
				mainPhase = 1; // pole vault
				trace("PHASE TWO");
			}
			
			if (player.minorPhase == -1 && totalDistanceCoveredPercent >= _percentToPole/*distance to pole*/) // swith to polerun
			{
				player.minorPhase = 0;
			}
			if (player.beganSprint == true)
			{
				_countdownSpriteRef.alpha -= .05;
			}
			
		}
		
		private function countDown():void
		{
			//_countdownSprite.
			if (_countdown <= 0)
			{
				mainPhase = 0; // begin
			}
			
		}
	
		
		private function startTransitionSkyToSpace(_duration:Number = 1):void
		{
			_transitionTime = _duration;
			_totalTransTime = _duration;
			addEventListener(EnterFrameEvent.ENTER_FRAME, transition);
		}
		
		private function transition(e:EnterFrameEvent):void 
		{
			_transitionTime = Math.max(0, _transitionTime - publicDeltaTime);
			
			//lower sky alpha
			_staticBG.setAlpha("sky", _transitionTime / _totalTransTime);
			//increase space alpha
			_staticBG.setAlpha("space", 1 - (_transitionTime / _totalTransTime));
			//increase star alpha
			_staticBG.setAlpha("stars1", 1 - (_transitionTime / (_totalTransTime * .25)));
			_staticBG.setAlpha("stars2", 1 - (_transitionTime / (_totalTransTime * .5)));

			if (_transitionTime == 0)
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, transition);
			}
		}
	}

}