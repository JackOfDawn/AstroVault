package Units 
{
	import citrus.core.CitrusEngine;
	import citrus.math.MathUtils;
	import citrus.objects.CitrusSprite;
	import citrus.objects.NapePhysicsObject;
	import citrus.physics.simple.SimpleCitrusSolver;
	import citrus.view.spriteview.SpriteArt;
	import citrus.view.starlingview.AnimationSequence;
	import flash.display.Shape;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.Color;
	import UI.AstroTextField;
	import Utils.Precision;
	//import citrus.view.starlingview.StarlingCamera;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import Obstacles.CollisionBox;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import Utils.OffsetStruct;
	
	import Utils.InputManager;
	//import citrus.objects.platformer.nape.Hero
	
	import citrus.input.controllers.Accelerometer;
	
	/**
	 * ...
	 * @author ...
	 */
	
	public class AstroVaulter extends NapePhysicsObject 
	{
		//[Embed(source = "../Assets/Meteor_2.png")] private static const METEOR:Class;//[Embed(source = "../Assets/Assets1x/Circle1x.png")] private static const PLAYER:Class;
		
		/* public */
		public var mainPhase:int = -1; // -1: No Start, 0: Sprint, 1: Pole Jump, 2: Launch, 3: Space
		public var minorPhase:int = -1; /*
										main = 0: minor = 0: pole run
										
										
										*/
		
		//public var accelerationY:Number = 1.0;
		
		public var inputChannel:uint = 0;
		
		/* private */
		private var _lastPressed:String = "";
		private var _currentSide:String = "right";
		
		private var _deltaTime:Number;
		private var _localGravity:Number = 3.0;
		private var _maxVelocity:Point = new Point(1000, 1000);
		private var _maxAnimationSpeed:Number = 40;
		//private var _maxAltitude:Number =
		private var _targetVelocity:Point = new Point(0, 0);
		private var _reachedMaxSpeed:Boolean = false;
		
		private var _previousPhase:int = -1;
		private var _previousParam:Point = new Point(0, 0);

		// phase SPRINT
		private var _canSprint:Boolean = false;
		private var _beganSprint:Boolean = false;
		private var _startMotion:Boolean = false;
		private var _reactionTimeSprint:Number = 0.0;
		private var _animationAccel:Number = .9;
		private var _animationStartSpeed:Number = 9.0;
		private var _sprintAccel:Number = 30.0;
		private var _stepBoost:Number = 35.0;
		private var _maxStartBoost:Number = 400.0;
		private var _startFactor:Number = 0;
		private var _pressedR:Boolean = false,
					_pressedL:Boolean = false,
					_pressedRSuccess:Boolean = false,
					_pressedLSuccess:Boolean = false;
		private var _leftHud:Shape = new Shape(),
					_rightHud:Shape = new Shape(),
					_bottomHud:Shape = new Shape();
					
		// phase POLEVAULT
		private var _launched:Boolean = false,
					_launchedFail:Boolean = false;
		private var _targetAnimationSpeed:Number,
					_runningSpeed:Number,
					_sprintDecel:Number,
					_distanceToBarActual:Number,
					_distanceToBarWorld:Number,
					_launchHeight:Number,
					_launchSpeedOffsetMax:Number = 100000,
					_launchSpeedOffset:Number = 0,
					_launchDecay:Number = _launchSpeedOffsetMax / 5000;
		private var _launchVector:Vec2 = new Vec2(0, 0);
		private var _resetDelay:Number = 5;
		
		//Phase SPACE
		private var _tilt:int = 0;
		private var _artRef:Sprite;
		private var _lose:Boolean = false;
		
		//private var _camera:StarlingCamera;
		
		/*animation related*/
		private var _currentAnimation:String;
		private var _animationSeq:AnimationSequence;
		
		/*acceler*/
		private var acceler:Accelerometer;
		
		private var _rightFoot:Boolean;
		private var _leftFoot:Boolean;
		private var _fasterRun:Boolean;
		private var _win:Boolean = false;
		

		public function AstroVaulter(name:String, params:Object=null) 
		{
			super(name, params);
			
			//_camera = _ce.state.view.camera as StarlingCamera;
			
			/* graphics & animation*/

			_animationSeq = new AnimationSequence(Registry.assetManager.getTextureAtlas("Player"), ["Running", "Vault", "PoleRun", "Launch", "Launch2"], "Running", .5, true);
			_animationSeq.addTextureAtlasWithAnimations(Registry.assetManager.getTextureAtlas("Sprint"), ["Sprint"]);
			//_animationSeq = new AnimationSequence(Main.assetManager.getTextureAtlas("TestAtlas"), ["Running", "Sprint", "Vault2", "PoleRun"], "Sprint", .5, true);
			_currentAnimation = "Sprint";
			_animationSeq.changeAnimation("Sprint", false)
	
			_previousParam.setTo(_animationSeq.width, _animationSeq.height);
			
			height = _animationSeq.height;
			width = _animationSeq.width;
			
			view = _animationSeq;
			
			updateCallEnabled = true;
			_animationSeq.pauseAnimation(false);
			
			_rightFoot = true;
			_leftFoot = false;
			_fasterRun = false;
			initHud();
		}
		
		private function initHud():void 
		{
			var _halfStageW:Number = _ce.stage.stageWidth * .5,
				_halfStageH:Number = _ce.stage.stageHeight * .5;
				
			_leftHud.graphics.beginFill(Color.RED, 1);
			_leftHud.graphics.drawRoundRect(0, 0, 151, _halfStageH * 1.25, 50);
			_leftHud.graphics.endFill();
			_leftHud.alpha = 0;
			
			_ce.addChild(_leftHud);
			
			_rightHud.graphics.beginFill(Color.RED, 1);
			_rightHud.graphics.drawRoundRect(_halfStageW * 2 - 150, 0, _halfStageW, _halfStageH * 1.25, 50);
			_rightHud.graphics.endFill();
			_rightHud.alpha = 0;
			
			_ce.addChild(_rightHud);
			
			_bottomHud.graphics.beginFill(Color.RED, 1);
			_bottomHud.graphics.drawRoundRect(_halfStageW, _halfStageH + 75, _halfStageW, _halfStageH - 75, 50);

			_bottomHud.graphics.endFill();
			_bottomHud.alpha = 0;
			
			_ce.addChild(_bottomHud);
			
		}
		
		override protected function createBody():void
		{
			super.createBody();
			_body.allowRotation = false;
		}
		
		override protected function createMaterial():void 
		{
			_material = new Material(0, 0, 0, 1, 0);
		}
		
		override public function update(deltaTime:Number):void
		{
			super.update(deltaTime);
			_deltaTime = deltaTime;
			
			checkPhases();
			
			/* gravity */
			gravity();
			
			/* movement */
			movement();
			
			_previousPhase = mainPhase;
		}
				
		private function checkPhases():void 
		{
			if (_launched == true)
			{
				// launch decay
				_launchSpeedOffset = Math.max( -1000000, _launchSpeedOffset - _launchDecay);
				if (_launchSpeedOffset <= 15000)
				{
					_launchDecay = Math.min(5000, _launchDecay + 25);
				}
				//swag
				
				if (_launchSpeedOffset <= 20000)
				{
					if (_win == false)
					{
						_lose = true;
					}
				}
				//TODO: trace(_launchSpeedOffset);
			}
			//trace(_body.velocity.x);
			if (mainPhase == 0) // run
			{	
				if (minorPhase == -1)
				{
					if (_currentAnimation == "Sprint" && getCurrentFrame() >= 10)
					{
						changeAnimation("Running", 0);
						//trace(offsetX, offsetY);
						_previousParam.setTo(_animationSeq.width, _animationSeq.height);
					}
					else if (_currentAnimation == "Sprint" && getCurrentFrame() == 4)
					{
						startSprint(_maxStartBoost * _startFactor, 0);
						//trace(_startFactor, _targetVelocity);
					}
				}
				else if (minorPhase == 0) // pole run
				{
					if (_currentAnimation == "Running")
					{
						changeAnimation("PoleRun", getCurrentFrame(), true, true, 130);
						//changeAnimation("PoleRun", getCurrentFrame(), false, true, 110);
						_previousParam.setTo(_animationSeq.width, _animationSeq.height);
					}
				}
				
				if (_beganSprint == false)
				{
					_reactionTimeSprint += _deltaTime;
				}
				if (_previousPhase == -1)
				{
					_canSprint = true;
				}
			}
			else if (mainPhase == 1) // pole vault
			{
				if (minorPhase == 0 || minorPhase == 1)
				{
					if (_distanceToBarActual < 600 && _bottomHud.alpha != .5)
					{
						_bottomHud.alpha = Math.min(.25, _bottomHud.alpha += .02);
						//_bottomHud.alpha = .25;
					}
				}
				if (minorPhase == 0) // "slow motion"
				{
					// slows down "gameplay"
					_runningSpeed = _targetVelocity.x; // get the speed that will influence launch proficiency
					_targetVelocity.x = _body.velocity.x * .25;
					_targetAnimationSpeed = 12;
					_sprintDecel = (_runningSpeed - _targetVelocity.x) / 30;
					if (_targetVelocity.x < 250)
					{
						_targetVelocity.x = 250;
					}
					minorPhase = 1;
					//_bottomHud.alpha = .1;
				}
				else if (minorPhase == 1) // vaulting
				{
					if (_ce.input.justDid("vault") || _ce.input.justDid("down"))
					{
						//trace("down touch");
						_bottomHud.alpha = Math.min(.5, _bottomHud.alpha + .1);
						if (_currentAnimation == "PoleRun")
						{
							changeAnimation("Vault", 0, true, true, 110, 0, false);
							_previousParam.setTo(_animationSeq.width, _animationSeq.height);
							setAnimationSpeed(20);
							_targetAnimationSpeed = 20;
							minorPhase = 2;
							Registry.soundManager.playSound("polebend");
						}
					}
					if (_distanceToBarActual < -150)
					{
						_lose = true;
					}
				}
				else if (minorPhase == 2) // Vault attempt
				{
					if (_currentAnimation == "Vault" && _launched == false)
					{
						if (getCurrentFrame() >= 5)
						{
							setAnimationSpeed(12);
							_targetAnimationSpeed = 12;
							_targetVelocity.x = 0;
							_body.velocity.x = 0;
						}
					}
					if ((_ce.input.justDid("vault") || _ce.input.hasDone("down")))
					{
						_bottomHud.alpha = Math.max(.25, _bottomHud.alpha - .1);
						if (_launched == false && _launchedFail == false)
						{
							var _frame:int = getCurrentFrame();
							if (_frame >= 9 && _frame <= 13)
							{
								//trace(_frame);
								_body.velocity.y = -2500;
								_targetVelocity.y = -1500;
								// determine launch height
								_launchHeight = determineLaunchHeight(_runningSpeed,_distanceToBarActual, _frame);
								_launched = true;
								if (_leftHud != null)
								{
									_ce.removeChild(_leftHud);
									_leftHud = null;
								}
								if (_rightHud != null)
								{
									_ce.removeChild(_rightHud);
									_rightHud = null;
								}
								
								minorPhase = 3;
								
								trace("LAUNCH", _frame, getAnimationSpeed());
								Registry.soundManager.stopSound("polebend");
								Registry.soundManager.playSound("explosion");

							}
							else
							{
								// determine launch height
								_launchHeight = determineLaunchHeight(_runningSpeed,_distanceToBarActual, _frame);
								_body.velocity.y = -450;
								if (_frame < 11)
								{
									_body.velocity.x = -450;
								}
								else
								{
									//_body.velocity.x = 200;
									_body.velocity.x = 450;
								}
								_launchedFail = true;
								minorPhase = 3;
								
								trace("FAILED", _frame);
								Registry.soundManager.stopSound("polebend");
							}
							
							// separate pole and player (or separate them at a certain frame
								// pole needs to be created in the state, not in the player
							// launch the player based on release timing
							// change to appropriate animation
							changeAnimation("Launch2", 0);
							_animationSeq.scaleY = -1;
							//offsetX = 216;
							//offsetY = _animationSeq.height;
							offsetX = 153;
							offsetY = (_animationSeq.height) + 130 * .5;
							//trace(offsetX, offsetY);
							//rotation = -180;
							//rotation = -180;
						}
					}
				}
				else if (minorPhase == 3) // launch or fail
				{
					if (launched == true)
					{
						// locks velocity at -200
						if (_body.velocity.y > -1500)
						{
							_targetVelocity.y = -50;
						}
						//trace(_body.velocity.y, Precision.setPrecision(y, 2));
					}
					if (_bottomHud != null)
					{
						_bottomHud.alpha = Math.max(0, _bottomHud.alpha - .02);
						if (_bottomHud.alpha == 0)
						{
							_ce.removeChild(_bottomHud);
							_bottomHud = null;
						}
					}
					if (_launchedFail == true)
					{
						_resetDelay -= _deltaTime;
						if (_resetDelay <= 0)
						{
							_lose = true;
						}
					}
				}
			}
			else if (mainPhase == 2) // vertical space exploration
			{
				changeAnimation("Launch", 0);
				//offsetX = 216;
				//offsetY = _animationSeq.height;
				offsetX = 153;
				offsetY = (_animationSeq.height) + 130 * .5;
				if (_body.velocity.y > -1500)
				{
					_targetVelocity.y = -50;
				}
			}
			else if (mainPhase == 3) //dodging time
			{
				changeAnimation("Launch", 0);
				//offsetX = 216;
				//offsetY = _animationSeq.height;
				offsetX = 153;
				offsetY = (_animationSeq.height) + 130 * .5;
				if (_tilt < 0)
				{
					//rotation = 160;
				}
				else if ( _tilt > 0)
				{
					//rotation = 200;
				}
				else
				{
					//rotation = 180;
				}
			}
			
			/*if (_lose == true)
			{
				Registry.tutorialNew.loseSprite.visible = true;
				_resetDelay = Math.min(0, _resetDelay -= _deltaTime);
				if (_resetDelay == 0)
				{
					
				}
				//_countdownAlive = true;
				//_countdownSpriteRef = this.view.getArt(_countdownSprite) as Sprite;
			}
			if (_win == true)
			{
				Registry.tutorialNew.winSprite.visible = true;
				_resetDelay = Math.min(0, _resetDelay -= _deltaTime);
				if (_resetDelay == 0)
				{
					
				}
			}*/
		}
		
		private function determineLaunchHeight(_speed:Number, _distance:Number, _releaseFrame:int):Number 
		{
			
			trace(_speed, _distance, _releaseFrame);
			
			if (_distance <= 10 && _distance > -10)
			{
				_distance = 10;
			}
			
			var _spdCoefficient:Number = _speed / _maxVelocity.x,
				_distCoefficient:Number = (10 / Math.abs(_distance)) * 1.5,
				_releaseCoefficient:Number,
				_launchCoefficient:Number;
				
			_distCoefficient = Math.min(1, _distCoefficient);
			
			if (within(_releaseFrame, 11, 11))
			{
				_releaseCoefficient = 1;
			}
			else if (within(_releaseFrame, 10, 12))
			{
				_releaseCoefficient = .8;
			}
			else if (within(_releaseFrame, 9, 13))
			{
				_releaseCoefficient = .6;
			}
			
			_launchCoefficient =  (_spdCoefficient + _distCoefficient + _releaseCoefficient) / 3;
			
			_launchSpeedOffset = _launchSpeedOffsetMax * _launchCoefficient;
			
			trace(_launchCoefficient);
			return _launchCoefficient;
		}
		
		/* custom methods */
		private function gravity():void
		{
			//_body.velocity..y = Math.min(_maxVelocity.y, _body.velocity.y + _localGravity);
		}
		
		private function movement():void
		{
			
			if (_currentAnimation == "Running" || _currentAnimation == "PoleRun")
				{
					if (getAnimationSpeed() > 25) _fasterRun = true;
					if ((getCurrentFrame() == 3) && _rightFoot)
					{
						if (!_fasterRun) Registry.soundManager.playSound("step1");
						else Registry.soundManager.playSound("stepfast1")
						_rightFoot = false;
						_leftFoot = true;
					}
					else if ((getCurrentFrame() == 9) && _leftFoot)
					{
						if (!_fasterRun) Registry.soundManager.playSound("step2");
						else Registry.soundManager.playSound("stepfast2")
						_leftFoot = false;
						_rightFoot = true;
					}
				}
			
			if (_beganSprint == false)
			{
				if (_ce.input.justDid( "right")/* || _ce.input.justDid( "left")*/)
				{
					if (_canSprint == true)
					{
						_beganSprint = true;
						
						//trace(_reactionTimeSprint);
							
						if (_reactionTimeSprint <= 0.2)
						{
							_startFactor = 1;
						}
						else if (_reactionTimeSprint > 0.2 && _reactionTimeSprint <= 0.4)
						{
							_startFactor = 0.75;
						}
						else if (_reactionTimeSprint > 0.4 && _reactionTimeSprint <= 0.6)
						{
							_startFactor = 0.65;
						}
						else  if (_reactionTimeSprint > 0.6 && _reactionTimeSprint <= 0.8)
						{
							_startFactor = 0.5;
						}
						else 
						{
							_startFactor = .25;
						}
						
						//trace(_startFactor);
						adjustAnimationSpeed(((_animationStartSpeed) * 1.5 * _startFactor));
						//adjustAnimationSpeed((1));
						
						/*temp*/
						_animationSeq.pauseAnimation(true);
						//trace(_reactionTimeSprint);
					}
					else
					{
						trace("FALSE START");
					}
				}
			}
			
			if (mainPhase == 0 && _startMotion == true) // if running is possible
			{
				if (_currentAnimation == "Running" || _currentAnimation == "PoleRun")
				{
					if ((getCurrentFrame() == 3) && _rightFoot)
					{
						if (_fasterRun) Registry.soundManager.playSound("step1");
						else Registry.soundManager.playSound("stepfast1")
						_rightFoot = false;
						_leftFoot = true;
					}
					else if ((getCurrentFrame() == 9) && _leftFoot)
					{
						if (_fasterRun) Registry.soundManager.playSound("step2");
						else Registry.soundManager.playSound("stepfast2")
						_leftFoot = false;
						_rightFoot = true;
					}
					
					if (_reachedMaxSpeed == false)
					{
						/* determine if player times tap correctly and check if tap is on the right side */
						if (_ce.input.justDid("right"))
						{
							if (_canSprint == true)
							{
								if (_currentSide == "right" && (getCurrentFrame() >= 0 && getCurrentFrame() <=6) && _pressedR == false)
								{								
									if (_targetVelocity.x >= _maxVelocity.x)
									{
										trace("MAX");
										_reachedMaxSpeed = true;
									}
									else
									{
										trace("RIGHT", getAnimationSpeed());
										_targetVelocity.x = Math.min(_maxVelocity.x, _targetVelocity.x + _stepBoost);
										adjustAnimationSpeed(_animationAccel);
									}
									
									_pressedRSuccess = true;
								}
								
								_lastPressed = "right";
								//_velocity.x = accelerationX;
							}
							_pressedR = true;
						}
			 
						if (_ce.input.justDid("left"))
						{
							if (_canSprint == true)
							{
								if (_currentSide == "left" && (getCurrentFrame() > 6  && getCurrentFrame() <= 12) && _pressedL == false)
								{
									if (_targetVelocity.x >= _maxVelocity.x)
									{
										trace("MAX");
										_reachedMaxSpeed = true;
									}
									else
									{
										trace("LEFT", getAnimationSpeed());
										_targetVelocity.x = Math.min(_maxVelocity.x, _targetVelocity.x + _stepBoost);
										adjustAnimationSpeed(_animationAccel);
									}
									
									_pressedLSuccess = true;
								}
								_lastPressed = "left";
								//_velocity.x = -accelerationX;
							}
							_pressedL = true;
						}
					}
					
					if (getCurrentFrame() <= 6)
					{
						if (_currentSide != "right")
						{
							_currentSide = "right";
							//if (_pressedL == true)
							{
								_pressedL = false;
								_pressedLSuccess = false;
							}
							
							//trace(_currentSide);
						}
					}
					else 
					{
						if (_currentSide != "left")
						{
							_currentSide = "left";
							//if (_pressedR == true)
							{
								_pressedR = false;
								_pressedRSuccess = false;
							}
							//trace(_currentSide);
						}
					}
					
					var _lAlpha:Number = _leftHud.alpha,
						_rAlpha:Number = _rightHud.alpha,
						_rate:Number = 1.5;
					/* determine which foot is about to impact */
					//if ((getCurrentFrame() >= 0 && getCurrentFrame() <= 6))
					{
						if (_pressedR == false && _pressedRSuccess == false)
						{
							_rightHud.alpha = .25;
							//_leftHud.alpha .1;
						}
						else if (_pressedRSuccess == true)
						{
							_rightHud.alpha = .5;
							//_leftHud.alpha .1;
							//trace("RSUCCESS");
						}
					}
					//if ((getCurrentFrame() > 6  && getCurrentFrame() <= 12))
					{
						if (_pressedL == false && _pressedLSuccess == false)
						{
							_leftHud.alpha = .25;
							//_rightHud.alpha = .1;
						}
						else if (_pressedLSuccess == true)
						{
							_leftHud.alpha = .5;
							//_rightHud.alpha = .1;
							//trace("LSUCCESS");
						}
					}
				}
			}
			
			// handle speed and animation transitional periods
			if (mainPhase == 0) // running
			{
				if (_body.velocity.x < _targetVelocity.x) // if actual velocity is less than target velocity
				{
					_body.velocity.x = Math.min(_targetVelocity.x, _body.velocity.x + _sprintAccel);
				}
				else if (_body.velocity.x > _targetVelocity.x)
				{
					_body.velocity.x = Math.max(_targetVelocity.x, _body.velocity.x - _sprintAccel);
				}
			}
			else if (mainPhase == 1) // if vault phase
			{
				if (_rightHud != null)
				{
					_rightHud.alpha = Math.max(0, _rightHud.alpha - .02);
					_leftHud.alpha = Math.max(0, _leftHud.alpha - .02);
				}
				
				if (minorPhase == 0 || minorPhase == 1) // slow motion or vaulting
				{
					_body.velocity.x = Math.max(_targetVelocity.x, _body.velocity.x - _sprintDecel);
					
					if ((getAnimationSpeed() - _animationAccel) > _targetAnimationSpeed)
					{
						adjustAnimationSpeed( -_animationAccel);
						//trace(getAnimationSpeed());
					}
					else
					{
						setAnimationSpeed(_targetAnimationSpeed);
					}
					
				}
				else if (minorPhase == 2) // starting launch
				{
					// when pole hits the ground, stop horizontal velocity
					if (getCurrentFrame() == 5)
					{
						_body.velocity.x = _targetVelocity.x;
					}
				}
				else if (minorPhase == 3) // complete or fail launch
				{
					// if launch was successful
					if (_launched == true) 
					{
						// normalize speed once player has launched (keeps the player from ascending too high)
						_body.velocity.y = Math.min(_targetVelocity.y, _body.velocity.y + _sprintAccel);
					}
					else
					{
						if (_body.velocity.x < _targetVelocity.x) // if actual velocity is less than target velocity
						{
							_body.velocity.x = Math.min(_targetVelocity.x, _body.velocity.x + .5);
						}
						else if (_body.velocity.x > _targetVelocity.x)
						{
							_body.velocity.x = Math.max(_targetVelocity.x, _body.velocity.x - .5);
						}
					}
				}
			}
			else if (mainPhase == 2) // vertical space exploration
			{
				_body.velocity.y = Math.min(_targetVelocity.y, _body.velocity.y + _sprintAccel);
				
				//_body.rotation = InputManager.tiltY;
				/*if (_body.velocity.x + _sprintAccel < _targetVelocity.x)
				{
					_body.velocity.x = Math.min(_targetVelocity.x, _body.velocity.x + _sprintAccel);
				}
				else if (_body.velocity.x - _sprintAccel > _targetVelocity.x)
				{
					_body.velocity.x = Math.max(_targetVelocity.x, _body.velocity.x - _sprintAccel);
				}*/
			}
			else if (mainPhase == 3)
			{
				_body.velocity.y = 0; // keep body in space
				
				if (InputManager.tiltY < -.2 || _ce.input.isDoing("right")) // right
				{
					_tilt  = 1;
					_body.velocity.x = 150;
				}
				else if (InputManager.tiltY > .2 || _ce.input.isDoing("left")) // left
				{
					_tilt  = -1;
					_body.velocity.x = -150;
				}
				else
				{
					_tilt = 0;
					_body.velocity.x = 0;
				}
				
				
			}
		}
		
		public function clear():void
		{
			if (_leftHud != null)
			{
				_ce.removeChild(_leftHud);
				_ce.removeChild(_rightHud);
				_leftHud = null;
				_rightHud = null
			}
			
			if (_bottomHud != null)
			{
				_ce.removeChild(_bottomHud);
				_bottomHud = null;
			}
		}
		
		private function startSprint(_x:Number = 0, _y:Number = 0):void
		{
			_startMotion = true;
			_targetVelocity.x = _x;
			_targetVelocity.y = _y;
			_body.velocity.x = _x;
			_body.velocity.y = _y;
		}
		public function scaleAnimation(scaleX:Number, scaleY:Number):void
		{
			_animationSeq.scaleX = scaleX;
			_animationSeq.scaleY = scaleY;
			
		}
		public function setAnimationSpeed(speed:Number):void
		{
			if (speed >= 0)
			{
				(_animationSeq.mcSequences[_currentAnimation] as MovieClip).fps = speed;
			}
		}
		public function adjustAnimationSpeed(speed:Number):void
		{
			var _fps:Number = (_animationSeq.mcSequences[_currentAnimation] as MovieClip).fps;
			if (speed > 0)
			{
				_fps = Math.min(_maxAnimationSpeed, _fps + speed);
			}
			else if (speed < 0)
			{
				_fps = Math.max(0, _fps + speed);
			}
			(_animationSeq.mcSequences[_currentAnimation] as MovieClip).fps = _fps;
		}
		public function getAnimationSpeed():Number
		{
			return (_animationSeq.mcSequences[_currentAnimation] as MovieClip).fps;
		}
		public function getCurrentFrame():int
		{
			return (_animationSeq.mcSequences[_currentAnimation] as MovieClip).currentFrame;
		}
		public function setFrame(frame:int):void
		{
			(_animationSeq.mcSequences[_currentAnimation] as MovieClip).currentFrame = frame;
		}
		public function changeAnimation(_name:String, _frame:int, _offsetX:Boolean = true, _offsetY:Boolean = true, _offsetXNum:Number = 0, _offsetYNum:Number = 0, _loop:Boolean = true ):void
		{
			var _fps:Number = getAnimationSpeed();
			_currentAnimation = _name;
			_animationSeq.changeAnimation(_name, _loop);
			setAnimationSpeed(_fps);
			setFrame(_frame);
			
			var _size:Point = new Point(width - _animationSeq.width, height - _animationSeq.height);
			var _sizeOffset:Point = new Point(_offsetXNum, _offsetYNum);
			
			if (_offsetX)
			{
				offsetX = _size.x + _sizeOffset.x;
			}
			else if (_sizeOffset.y > 0)
			{
				offsetX = _sizeOffset.x;
			}
			if (_offsetY)
			{
				offsetY = _size.y + _sizeOffset.y;
			}
			else if (_sizeOffset.y > 0)
			{
				offsetY = _sizeOffset.y;
			}
			//trace(_size, _sizeOffset);
			//trace(_animationSeq.width, _animationSeq.height);
		}
		private function within(_num:Number, _lower:Number, _upper:Number):Boolean
		{
			if (_num >= _lower && _num <= _upper)
			{
				return true;
			}
			return false;
		}
		public function get beganSprint():Boolean 
		{
			return _beganSprint;
		}
		public function get launched():Boolean 
		{
			return _launched;
		}
		public function get distanceToBarActual():Number 
		{
			return _distanceToBarActual;
		}
		public function set distanceToBarActual(value:Number):void 
		{
			_distanceToBarActual = value;
		}
		public function get distanceToBarWorld():Number 
		{
			return _distanceToBarWorld;
		}
		public function set distanceToBarWorld(value:Number):void 
		{
			_distanceToBarWorld = value;
		}
		
		public function get launchSpeedOffset():Number 
		{
			return _launchSpeedOffset;
		}
		
		public function get artRef():Sprite 
		{
			return _artRef;
		}
		
		public function set artRef(value:Sprite):void 
		{
			_artRef = value;
		}
		
		public function set launchSpeedOffset(value:Number):void 
		{
			_launchSpeedOffset = value;
		}
		
		public function get win():Boolean 
		{
			return _win;
		}
		
		public function get lose():Boolean 
		{
			return _lose;
		}
		
		public function set lose(value:Boolean):void 
		{
			_lose = value;
		}
		public function checkAnimComplete():Boolean
		{
			return (_animationSeq.mcSequences[_currentAnimation] as MovieClip).isComplete;
		}
		
		

	}

}