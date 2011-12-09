package codedrive.galaxians
{
    import codedrive.galaxians.data.GameData;
    import flash.display.Sprite;

    public class GalaxiansGame extends Sprite
    {
        private var _activeGameScreen:Sprite;
        private var _gameData:GameData;

        function GalaxiansGame()
        {
            _gameData = new GameData(this);
            _gameData.loadAndParseXml();
            //_gameData.loadAndParseXml("Galaxians.xml");
        }

        public function runGameStartScreen():void
        {
            if (_activeGameScreen != null)
            {
                this.removeChild(_activeGameScreen);
            }
            _activeGameScreen = new GameStartScreen(this);
            this.addChild(_activeGameScreen);
        }

        public function runGamePlayScreen():void
        {
            this.removeChild(_activeGameScreen);
            _activeGameScreen = new GamePlayScreen(this, _gameData);
            this.addChild(_activeGameScreen);
            (_activeGameScreen as GamePlayScreen).startBattle();
        }
        
    }
}
