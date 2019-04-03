package lib.survive
{
	import flash.media.Sound;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import lib.survive.SurviveGame;



	
	public class SurviveDoc extends MovieClip
	{
		public function SurviveDoc()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			createStartMenu();
		}
		
		private function createStartMenu():void
		{
			//adds background music
			//var bMusic:StartScreenAudio = new StartScreenAudio();
			//bMusic.play();
			
			
			var startMenu:StartScreen = new StartScreen();
			
			addChild(startMenu);
			
			play();
			
			startMenu.startButton.addEventListener(MouseEvent.CLICK, startGameHandler);
	
			startMenu.instructionsButton.addEventListener(MouseEvent.CLICK, startInstructions);
		}
		
		private function startGameHandler(evt:MouseEvent):void
		{
			removeChild(evt.currentTarget.parent);
			
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, startGameHandler);
			
			createGame();
		}
		
		private function createGame():void
		{
			var game:SurviveGame = new SurviveGame();
			
			addChild(game);
		}
		private function startInstructions(evt2:MouseEvent):void
		{
			removeChild(evt2.currentTarget.parent);
			
			evt2.currentTarget.removeEventListener(MouseEvent.CLICK, startInstructions);
			
			createInstructions();
		}
		private function createInstructions():void
		{
			
			var instructions:InstructionsScreen = new InstructionsScreen();
			addChild(instructions);
			instructions.returnButton.addEventListener(MouseEvent.CLICK, returnHandler);
		}
		
		public function returnHandler(evt:MouseEvent):void
		{
			removeChild(evt.currentTarget.parent);
			
			evt.currentTarget.removeEventListener(MouseEvent.CLICK, returnHandler);
			
			createStartMenu();
		}
	}
}