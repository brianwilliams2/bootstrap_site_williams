package lib.survive
{
	import flash.display.MovieClip
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import lib.survive.Player;
	import lib.survive.Particle;
	import lib.survive.Chopper;
	import lib.survive.Turret;
	import lib.survive.Laser;
	import com.greensock.*;
	import com.greensock.easing.*;



	public class SurviveGame extends MovieClip
	{
		private var bullets:Array;
		private var turrets:Array;
		private var turretBases:Array;
		private var touchLayer:Sprite;
		private var background:Sprite;
		private var player:Player;
		private var turret:Turret;
		private var bossTurret1:Laser;
		private var bossTurret2:Laser;
		private var particlesLayer:Sprite;
		private var turretsLayer:Sprite;
		private var turretBaseLayer:Sprite;
		private var splodeSpread:Number;
		private var splodeNum:Number;
		private var turretsNum:int;
		
		private var playerHealth:Number;
		private var playerFuel:Number;
		
		private var yourScore:Number;
		private var yourField:TextField;
		
		private var yourHealth:MovieClip;
		private var percenthp:Number;
		private var maxhp:Number;
		
		private var yourFuel:MovieClip;
		private var percentFuel:Number;
		private var maxFuel:Number;
		
		private var bossHealth:Number;
		private var bossLayer:Sprite;
		private var boss:MovieClip;
		private var bossStatus:String;
		private var turretDeaths:Number;
		private var bossTurretStatus:String;
		
		private var chopper:Chopper;
		private var healthIncrease:Number;
		
		private var fuel:MovieClip;
		
		private var light:Chopper;
		

		
		
		public function SurviveGame()
		{
			bossHealth=200;
			bossTurretStatus="Dead";
			bossStatus="Dead";
			bullets = new Array();
			chopper = new ChopperGunner();
			light = new spotlight();
			player = new ShipA();
			background = new LevelOne();
			boss = new Boss();
			yourScore = 0;
			playerHealth = 200;
			playerFuel = 100;
			maxFuel = playerFuel;
			maxhp = playerHealth;
			healthIncrease = 0;
			chopper.chopperHealth = 10;
			turretsNum = 10;
			splodeSpread = 0.5;
			splodeNum = 2;
			turretDeaths=0;
			
			makeLevelOne();
			addEventListener(Event.ENTER_FRAME, update);
			
			touchLayer = new Sprite();
			addChild(touchLayer);
			
			addEventListener(Event.ADDED_TO_STAGE, setupTouchLayer);
			touchLayer.addEventListener(MouseEvent.MOUSE_UP, stopFiring);
			touchLayer.addEventListener(MouseEvent.MOUSE_DOWN, startFiring);
			
		}
		
		private function startFiring(evt:MouseEvent):void
		{
			if (player.status != "Dead")
			{
			player.startFiring();
			}
		}

		
		private function stopFiring(evt:MouseEvent):void
		{
			player.stopFiring();
		}
		
		private function keyDownHandler(evt:KeyboardEvent):void
		{
			if (evt.keyCode == 87)
			{
				if(playerFuel >= 1 )
				{
					playerFuel--;
					updateFuelBar();
					player.directionY = "up";
				}
				else
				{
					player.directionY = "none";
				}
				
			}
			else if (evt.keyCode == 83)
			{
				player.directionY = "down";
			}
			else if (evt.keyCode == 68)
			{
				player.directionX = "right";
			}
			else if (evt.keyCode == 65)
			{
				player.directionX = "left";
			}
		}
		
		private function keyUpHandler(evt:KeyboardEvent):void
		{
			//87=w 68=d 83=s 65=a 
			if (evt.keyCode == 87 || evt.keyCode == 83)
			{
				player.directionY = "none";
			}
			else if (evt.keyCode == 68 || evt.keyCode == 65)
			{
				player.directionX = "none";
			}
		}
		
		private function setupTouchLayer(evt:Event):void
		{
			touchLayer.graphics.beginFill(0x000000, 0);
			touchLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			touchLayer.graphics.endFill();
			//initial positions
			player.x = 600;
			player.y = 1000;
			chopper.x= 2000;
			chopper.y=1500;
			light.x=chopper.x;
			light.y=chopper.y;
			light.scaleY=2;
			boss.x=3000;
			boss.y=1600;
		
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private function makeLevelOne():void
		{
			//add library objects to stage
			addChild(background);
			
			
			
			turretsLayer = new Sprite();
			background.addChild(turretsLayer);
			
			turretBaseLayer = new Sprite();
			background.addChild(turretBaseLayer);
			
			background.addChild(light);
			background.addChild(chopper);
			
			bossLayer = new Sprite();
			background.addChild(bossLayer);
			background.addChild(player);
			
			particlesLayer = new Sprite();
			background.addChild(particlesLayer);
			
			//establish parameters for the scoring text field and add to stage
			yourField = new TextField;
			yourField.background = true;
			yourField.backgroundColor = 0xF0FFFF;
			yourField.width = 90;
			yourField.height = 20;
			yourField.text = "Your Score: 0";
			addChild(yourField);
			
			//adds hp bar to stage
			yourHealth = new hpFrame();
			yourHealth.x = yourField.x + yourField.width + 5;
			addChild(yourHealth);
			
			//adds fuel bar to stage
			yourFuel = new fuelFrame();
			yourFuel.x = yourHealth.x + yourHealth.width + 5;
			addChild(yourFuel);
			
			
			makeTurrets();
			
		}
		
		//this method returns distance between two objects for distance based collision testing
		private function getDistance(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			var dx:Number = x1-x2;
			var dy:Number = y1-y2;
			var distance:Number = Math.sqrt(dx*dx+dy*dy);
			return distance;
		}
		
		
		//this method removes fuel when it leaves screen or collides with player
		private function updateFuel(fuel):void
		{
			if(fuel.y >2200 )
			{
				background.removeChild(fuel);
				trace("Fuel escaped!");
			}
			
			if(getDistance(player.x,player.y,fuel.x,fuel.y)<=75)
			{
				background.removeChild(fuel);
				if(percentFuel <= 0.9)
				{
				playerFuel+=10;
				}
				else
				{
					playerFuel+= (maxFuel-playerFuel);
				}
				updateFuelBar();
			}
				
		}
		
		//spawns chopper object
		private function makeChopper():void
		{
			if(player.status!="Dead")
			{
			
			healthIncrease+=5;
			chopper.x= 3400;
			chopper.y= Math.random() * 300 + 1400;
			light.x=chopper.x;
			light.y=chopper.y;
			background.addChild(light);
			background.addChild(chopper);
			light.scaleY=2;
			
			chopper.chopperHealth = 10 + healthIncrease;
			}
			
		}
		
		//spawns fuel object
		private function makeFuel():void
		{
			fuel = new fuelTank();
			fuel.x = chopper.x
			fuel.y = chopper.y
			background.addChild(fuel);
			fuel.status="Alive";
			//add greensock motion tween to fuel
			TweenLite.to(fuel, 12, {x:fuel.x, y:2400, ease:Linear.easeNone});
		}
			//add turrets and define locations
		private function makeTurrets():void
		{
			turrets = new Array();
			turretBases = new Array();
			
			
			while (turrets.length < turretsNum)
			{
				turret = new BlueTurret();
				turrets.push(turret);
				turretsLayer.addChild(turret);
				
				turret.target = player;
				//turrets spawn at random x locations on ground
				turret.x = Math.random() * 0.7 * background.width;

				turret.y = 2000;
				//adds turretbase to layer with location
				var turretBase = new TurretBase();
				turretBases.push(turretBase);
				turretBaseLayer.addChild(turretBase);
				turretBase.x = turret.x;
				turretBase.y = turret.y;
				
			}
			
		}
		
		//spawns boss
		private function makeBoss():void
		{
		bossLayer.addChild(boss);
		TweenLite.to(boss, 15, {x:1200, y:1600, ease:Linear.easeNone});
		bossStatus="Alive";
		
		bossTurret1 = new BossTurret();
		bossLayer.addChild(bossTurret1);
		bossTurret1.target = player;
				
		bossTurret1.scaleX=2;
		bossTurret1.scaleY=2;
				
		bossTurret1.x = boss.x;
		bossTurret1.y = boss.y;
		TweenLite.to(bossTurret1, 15, {x:1200, y:1600, ease:Linear.easeNone});
		
		bossTurret2 = new BossTurret();
		bossLayer.addChild(bossTurret2);
		bossTurret2.target = player;
				
		bossTurret2.scaleX=2;
		bossTurret2.scaleY=2;
				
		bossTurret2.x = boss.x-40;
		bossTurret2.y = boss.y;
		TweenLite.to(bossTurret2, 15, {x:1160, y:1600, ease:Linear.easeNone});
		}
		
		
		//chopper updater 
		private function updateChopper():void
		{
			if (chopper.status!="Dead")
			{
			light.update();
			chopper.update();
			}
			else 
			{
				chopper.status="Ok";
				makeChopper();
			}
			
		}
	
		private function updatePlayer():void
		{
			if(player.status !="Dead")
			{
			player.update();
			var shot:Particle = player.fire();
			}
			//moves background based on player position, if statements only move background between a range related to background dimensions.
			if (player.x >= 475 && player.x <= 2100)
			{
			background.x = -player.x + stage.stageWidth / 2;
			}
			if (player.y <= 1800)
			{
			background.y = -player.y + stage.stageHeight / 2;
			}
			
			
			if (shot != null && player.status!="Dead")
			{
				particlesLayer.addChild(shot);
				bullets.push(shot);
			}
			//destroys player if they hit the ground
			if (player.y >= 2050 && player.status!="Dead")
			{
				player.destroy();
				playerHealth = 0;
				updateHealthBar();
			}
			
		}
		
		
		//method that removes bullets from stage
		private function killBullet(bullet:Particle):void
		{
			try 
			{
				var i:int;
				for (i = 0; i < bullets.length; i++)
				{
					if (bullets[i].name == bullet.name)
					{
						bullets.splice(i, 1);
						particlesLayer.removeChild(bullet);
						
						if (bullet.interacts && player.status != "Dead")
						{
							var j:int;
							for (j = 0; j < splodeNum; j++)
							{
								var splode:Particle = new Explosion();
								splode.scaleX = splode.scaleY = 1 + Math.random();
								splode.x = bullet.x;
								splode.y = bullet.y;
								splode.xVel = Math.random() * splodeSpread - splodeSpread / 2;
								splode.yVel = Math.random() * splodeSpread - splodeSpread / 2;
								splode.life = 20;
								splode.interacts = false;
								bullets.push(splode);
								particlesLayer.addChild(splode);
							}
						}
						
						i = bullets.length;
					}
				}
			}
			catch(e:Error)
			{
				trace("Failed to delete bullet!", e);
			}
		}
		
		
		
		//RESTARTS GAME
		var deathMenu:DeathScreen = new DeathScreen();
		//removes children from background and adds death Menu
		private function restartGame():void
		{
			addChild(deathMenu);
			deathMenu.deathButton.addEventListener(MouseEvent.MOUSE_DOWN, restartGameHandler);
			if(bossLayer.parent==background)background.removeChild(bossLayer);
			if(particlesLayer.parent==background)background.removeChild(particlesLayer);
			if(chopper.parent==background)background.removeChild(chopper);
			if(light.parent==background)background.removeChild(light);
			if(turretsLayer.parent==background)background.removeChild(turretsLayer);
			if(turretsLayer.parent==background)background.removeChild(turretsLayer);
			if(turretBaseLayer.parent==background)background.removeChild(turretBaseLayer);
			if(bossLayer.parent==background)background.removeChild(bossLayer);
			
			
		}
		
		private function restartGameHandler(evt:MouseEvent):void
		{
			removeChild(evt.currentTarget.parent);
			
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, restartGameHandler);
			
			bullets = new Array();
			chopper = new ChopperGunner();
			player = new ShipA();
			yourScore = 0;
			playerHealth = 200;
			playerFuel = 100;
			maxFuel = playerFuel;
			maxhp = playerHealth;
			healthIncrease = 0;
			turretDeaths=0;
			chopper.chopperHealth = 10;
			background.addChild(bossLayer);
			background.addChild(player);
			
			turretsLayer = new Sprite();
			background.addChild(turretsLayer);
			
			turretBaseLayer = new Sprite();
			background.addChild(turretBaseLayer);
			
			particlesLayer = new Sprite();
			background.addChild(particlesLayer);
			makeTurrets();
			updateHealthBar();
			updateFuelBar();
			yourField.text = "Your Score: " + yourScore;
			
		}
		
		//method for changing the health bar size
		private function updateHealthBar():void
		{
			percenthp = playerHealth / maxhp;
			yourHealth.hpColor.scaleX = percenthp;
		}
		
		//method for changing the fuel bar size
		private function updateFuelBar():void
		{
			percentFuel = playerFuel / maxFuel;
			yourFuel.fuelColor.scaleX = percentFuel;
		}

		private function update(evt:Event):void
		{
			
			var target:Point = new Point(background.mouseX, background.mouseY);
			var angleRad:Number = Math.atan2(target.y, target.x);
			var angle:Number = angleRad * 180 / Math.PI;
			
			//call the update player and chopper methods
			updatePlayer();
			updateChopper();
			
			//spawns boss when all turrets are eliminated
			if(turretDeaths==10 && bossStatus=="Dead")
			{
				makeBoss();
				bossTurretStatus="Alive";
			}
			
			//call the updatefuel update method if it exists on stage
			if(fuel != null && fuel.parent == background)updateFuel(fuel);
			
			//calls the restartgame method if player dies
			if (player.status == "Dead")restartGame();
			
			//destroy chopper if it falls off stage
			if (chopper.x <= -500 || chopper.y >= 2200)
			{
				trace("Dispatched Chopper Escaped!");
				chopper.destroy();
				if(chopper.parent==background)background.removeChild(chopper);
			}
			
			//damage player and destroy chopper if they collide
			if(getDistance(player.x,player.y,chopper.x,chopper.y) <= 100 && chopper.status!="Falling")
			{
				background.removeChild(chopper);
				chopper.destroy();
				makeFuel();
				
				if(playerHealth>=50)
				{
					playerHealth-=50;
				}
				else
				{
					playerHealth = 0;
				}
				updateHealthBar();
			}
			//loop through all bullets
			for each (var bullet:Particle in bullets)
			{
				bullet.update();
				
				//removes bullet if its hits something
				if (bullet.life <= 0)
				{
					killBullet(bullet);
				}
				//bullet collision interactions
				else if (bullet.interacts)
				{
					//PLAYER SHOT COLLISIONS
					if (bullet.ownedByPlayer)
					{
						//add hittest for player bullets on boss
						if (boss.hitTestPoint(bullet.x + background.x, bullet.y + background.y, true))
							{
								
								if (boss.parent==bossLayer && bossHealth >=1)
								{
									bossHealth--;
									trace ("boss hit", bossHealth)
								}
							
							else if(boss.parent==bossLayer&&bossTurret1.parent==bossLayer)
									{
									boss.play()
									trace ("BOSS ELIMINATED");
									//increase score when boss killed
									yourScore+=5000;
									yourField.text = "Your Score: " + yourScore;
									bossLayer.removeChild(bossTurret1);
									bossLayer.removeChild(bossTurret2);
									bossStatus="ELIMINATED";
									}
								killBullet(bullet);
							}
								
						//end hittest
						//add hittest for player bullets on choppers
						if (chopper.hitTestPoint(bullet.x + background.x, bullet.y + background.y, true))
							{
								
								if (chopper.status != "Dead" && chopper.status !="Falling" && chopper.chopperHealth >=1)
								{
									chopper.chopperHealth--;
									trace ("enemy hit", chopper.chopperHealth)
								}
							
								else if(chopper.status !="Falling" && chopper.status != "Dead")
								{
									background.removeChild(light);
									chopper.fall();
									trace ("TARGET ELIMINATED");
									//increase score when chopper killed
									yourScore+=10;
									yourField.text = "Your Score: " + yourScore;
									//spawns fuel if chopper dies
									makeFuel();
								}
								killBullet(bullet);
							}
								
						//end hittest
						//player shot on turret collisions
						for each (var targetTurret:Turret in turrets)
						{
							if (targetTurret.hitTestPoint(bullet.x + background.x, bullet.y + background.y, true))
							{
								//adds damage every time a turret is hit by a bullet from the player
							if (targetTurret.status != "Dead" && targetTurret.turretHealth >=1)
							{
								targetTurret.turretHealth--;
								trace ("enemy hit", targetTurret.turretHealth)
							}
							//calls the turret destroy method and updates score when a turret's hp reaches 0
							else if(targetTurret.status != "Dead")
									{
									targetTurret.destroy();
									trace ("TARGET ELIMINATED");
									yourScore+=50;
									yourField.text = "Your Score: " + yourScore;
									turretDeaths++;
									}
								killBullet(bullet);
								break;
							}
						}
					}
					//TURRET SHOT ON PLAYER COLLISION
					else
					{
						if (player.hitTestPoint(bullet.x + background.x, bullet.y + background.y, true))
						{
							//adds damage to playerhealth upon collison with enemy bullet if they have hp
							if (playerHealth >=1)
							{
								playerHealth-=5;
								trace ("player hit", playerHealth)
								updateHealthBar();
							}
							//calls player destroy method if player gets hit with no hp left
							else
								{
								player.destroy();
								}

							
							killBullet(bullet);
						}
					}
				}
			}
			//updates the boss turrets
			if(bossStatus=="Alive")
			{
			var bossShot2:Particle = bossTurret2.update();	
			if (bossShot2 != null)
			{
				particlesLayer.addChild(bossShot2);
				bullets.push(bossShot2);
			}
			}
			if(bossStatus=="Alive")
			{
			var bossShot:Particle = bossTurret1.update();	
			if (bossShot != null)
			{
				particlesLayer.addChild(bossShot);
				bullets.push(bossShot);
			}
			}
			for each (var turret:Turret in turrets)
			{
				var shot:Particle = turret.update();
				
				if (shot != null)
				{
					particlesLayer.addChild(shot);
					bullets.push(shot);
					
				}
			}
		}
	}
}