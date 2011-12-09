package codedrive.galaxians
{
    import avmplus.describeType;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class GameInformation extends Sprite
    {
        private var _gamePlayScreen:GamePlayScreen;

        private var _scoreLabel:TextField;
        private var _livesLabel:TextField;
        private var _levelLabel:TextField;
        private var _multiFireIcon:Sprite;
        private var _multiFireLabel:TextField;
        private var _squeezeFireIcon:Sprite;
        private var _squeezeFireLabel:TextField;
        private var _soundIcon:Sprite;
        private var _isSoundOn:Boolean = false;

        public function get isSoundOn():Boolean
        {
            return _isSoundOn;
        }

        public function get soundIcon():Sprite
        {
            return _soundIcon;
        }

        function GameInformation(gamePlayScreen:GamePlayScreen)
        {
            _gamePlayScreen = gamePlayScreen;
            gamePlayScreen.addChild(this);
            this.y = GameConstants.GAME_INFORMATION_TOP;

            _scoreLabel = createInformationLabel(GameConstants.SCORE_LABEL_X, 0);
            _livesLabel = createInformationLabel(GameConstants.LIVES_LABEL_X, 0);
            _levelLabel = createInformationLabel(GameConstants.LEVEL_LABEL_X, 0);
            _multiFireLabel = createInformationLabel(GameConstants.MULTIFIRE_LABEL_X, 0);
            _squeezeFireLabel = createInformationLabel(GameConstants.SQUEEZEFIRE_LABEL_X, 0);

            _multiFireIcon = new MultiFireIcon();
            _multiFireIcon.x = GameConstants.MULTIFIRE_ICON_X;
            _multiFireIcon.y = 0;
            this.addChild(_multiFireIcon);

            _squeezeFireIcon = new SqueezeFireIcon();
            _squeezeFireIcon.x = GameConstants.SQUEEZEFIRE_ICON_X;
            _squeezeFireIcon.y = 0;
            this.addChild(_squeezeFireIcon);

            _soundIcon = isSoundOn ? new SoundOn() : new SoundOff();
            _soundIcon.x = GameConstants.SOUND_ICON_X;
            _soundIcon.y = 10;
            this.addChild(_soundIcon);
        }

        public function update():void
        {
            _scoreLabel.text = GameConstants.TEXT_SCORE + _gamePlayScreen.score.toString();
            _livesLabel.text = GameConstants.TEXT_LIVES + _gamePlayScreen.hero.livesRemaining.toString();
            _levelLabel.text = GameConstants.TEXT_LEVEL + (_gamePlayScreen.level + 1).toString();
            _multiFireLabel.text = _gamePlayScreen.hero.multiFireBulletsRemaining.toString();
            _squeezeFireLabel.text = _gamePlayScreen.hero.squeezeBulletsRemaining.toString();

            _multiFireLabel.visible = (_gamePlayScreen.hero.multiFireBulletsRemaining != 0);
            _multiFireIcon.visible = (_gamePlayScreen.hero.multiFireBulletsRemaining != 0);

            _squeezeFireLabel.visible = (_gamePlayScreen.hero.squeezeBulletsRemaining != 0);
            _squeezeFireIcon.visible = (_gamePlayScreen.hero.squeezeBulletsRemaining != 0);
        }

        public function switchSound():void
        {
            _isSoundOn = Boolean ((int (_isSoundOn) + 1) % 2);

            this.removeChild(_soundIcon);
            if (_isSoundOn)
            {
                _soundIcon = new SoundOn();
            }
            else
            {
                _soundIcon = new SoundOff();
            }

            _soundIcon.x = GameConstants.SOUND_ICON_X;
            _soundIcon.y = 10;
            this.addChild(_soundIcon);
        }

        private function createInformationLabel(offsetX:Number, offsetY:Number):TextField
        {
            var textFormat:TextFormat = new TextFormat();
            textFormat.color = GameConstants.GAME_INFORMATION_FONT_COLOR;
            textFormat.font = GameConstants.GAME_INFORMATION_FONT;
            textFormat.size = GameConstants.GAME_INFORMATION_FONT_SIZE;

            var label:TextField = new TextField();
            label.defaultTextFormat = textFormat;
            label.autoSize = TextFieldAutoSize.LEFT;
            this.addChild(label);

            label.x = offsetX;
            label.y = offsetY;
            return label;
        }


    }
}
