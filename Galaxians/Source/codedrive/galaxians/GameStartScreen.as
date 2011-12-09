package codedrive.galaxians
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class GameStartScreen extends Sprite 
    {
        private var _game:GalaxiansGame;

        function GameStartScreen(game:GalaxiansGame)
        {
            _game = game;
            
            this.addChild(new GameStartScreenBackground());

            var startGameButton:MovieClip = new StartGameButton();
            this.addChild(startGameButton);

            startGameButton.x = GameConstants.START_GAME_BUTTON_X;
            startGameButton.y = GameConstants.START_GAME_BUTTON_Y;
            startGameButton.buttonMode = true;
            startGameButton.useHandCursor = true;
            
            startGameButton.addEventListener(MouseEvent.CLICK, startGameButtonClickHandler);
        }

        private function startGameButtonClickHandler(event:MouseEvent):void 
        {
            _game.runGamePlayScreen();
        }



    }
}
