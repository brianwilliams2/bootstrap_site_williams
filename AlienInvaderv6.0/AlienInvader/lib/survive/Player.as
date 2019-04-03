package lib.survive
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import lib.survive.Particle;
	
	public class Player extends MovieClip
	{
		public var speed:Number;
		public var turnRate:Number;
		public var directionX:String;
		public var directionY:String;
		public var brakes:Number;
		public var xVel:Number;
		public var yVel:Number;
		public var accel:Number;
		private var targetAngle:Number;
		public var firing:Boolean;
		public var fireDelay:int;
		public var fireCounter:int;
		public var shotSpeed;
		public var gravity:Number;
		public var status:String;
		
		public function Player()
		{
			fireDelay = 3;
			fireCounter = 0;
			firing = false;
			targetAngle = 0;
			accel = 0.1;
			xVel = 0;
			yVel = 0;
			directionX = "none";
			directionY = "none";
			speed = 15;
			turnRate = 0.1;
			brakes = 0.99;
			gravity = 0.5;
			status="OK";
			x=600;
			y=1000;
			gotoAndStop(1);

		}
		
		//method called when player health reaches zero or crashes into the ground 
		//causes player to stop moving and goto frame displaying explosion 
		public function destroy():void
		{
			gravity = 0;
			speed = 0;
			status="Dead";
			xVel = 0;
			yVel = 0;
			play();
			
		}
		
		
		public function startFiring():void
		{
			firing = true;
		}
		
		public function stopFiring():void
		{
			firing = false;
		}
		
		public function fire():Particle
		{
			var shot:Particle;
			if (firing)
			{
				shot = new Bullet();
				shot.x = x;
				shot.y = y;
				
				var shotAngle:Number = Math.atan2(stage.mouseY - stage.stageHeight / 2, stage.mouseX - stage.stageWidth / 2);
				
				shot.interacts = true;
				shot.xVel = xVel + Math.cos(shotAngle) * speed;
				shot.yVel = yVel + Math.sin(shotAngle) * speed;
			}
			if (fireCounter < fireDelay)
			{
				fireCounter++;
			}
			return shot;
		}
		
		public function update():void
		{
			if (directionX == "none" || directionX == "left" || directionX == "right")
			{
				yVel+=gravity;
			}
			
			if (directionX != "none" || directionY != "none")
			{
				targetAngle = 0;
				if (directionY != "none")
				{
					if (directionX == "left")
					{
						targetAngle = 135;
					}
					else if (directionX == "right")
					{
						targetAngle = 45;
					}
					else
					{
						targetAngle = 90;
					}
					if (directionY == "up")
					{
						targetAngle *= -1;
					}
				}
				else if (directionX == "left")
				{
					targetAngle = 180;
				}
				
				xVel += ((Math.cos(targetAngle / 180 * Math.PI) * speed) - xVel) * accel;
				yVel += ((Math.sin(targetAngle / 180 * Math.PI) * speed) - yVel) * accel;
				
			}
			
		
			xVel *= brakes;
			yVel *= brakes;
			
			
			x += xVel;
			y += yVel;
		}
	}
}