package codedrive.galaxians
{
    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class UnitExplode extends Sprite implements IGameElement
    {
        private var _gamePlayScreen:GamePlayScreen;
        private var _explode:MovieClip;
        private var _prevFrameNumber:int = 0;
        private var _isExplodeOver:Boolean = true;

        private const ENEMY_EXPLOSION_WIDTH:int = 100;
        private const ENEMY_EXPLOSION_HEIGHT:int = 100;
        private const HERO_EXPLOSION_WIDTH:int = 80;
        private const HERO_EXPLOSION_HEIGHT:int = 40;

        public function get isExplodeOver():Boolean
        {
            return _isExplodeOver;
        }

        public function UnitExplode(gamePlayScreen:GamePlayScreen, unit:*):void
        {
            _gamePlayScreen = gamePlayScreen;
            if (unit is EnemyUnit)
            {
                _explode = new EnemyUnitExplode();
                _explode.x = unit.x + GameConstants.ENEMY_UNIT_WIDTH / 2 - ENEMY_EXPLOSION_WIDTH / 2;
                _explode.y = unit.y + GameConstants.ENEMY_UNIT_HEIGHT / 2 - ENEMY_EXPLOSION_HEIGHT / 2;
            }
            else if (unit is HeroUnit)
            {
                _explode = new HeroUnitExplode();
                _explode.x = unit.x - GameConstants.HERO_UNIT_WIDTH / 2 - HERO_EXPLOSION_WIDTH / 2;
                _explode.y = unit.y - GameConstants.HERO_UNIT_HEIGHT / 2 - HERO_EXPLOSION_HEIGHT / 2;
            }
            else
            {
                return;
            }
            this.addChild(_explode);
            _isExplodeOver = false;
            _gamePlayScreen.addGameElement(this);
        }

        public function handleGamePlayTimerEvent():void
        {
            if (_explode.currentFrame >= _explode.totalFrames || _explode.currentFrame < _prevFrameNumber)
            {
                this.removeChild(_explode);
                _isExplodeOver = true;
                _gamePlayScreen.removeGameElement(this);
            }
            _prevFrameNumber = _explode.currentFrame;
        }
    }
}
