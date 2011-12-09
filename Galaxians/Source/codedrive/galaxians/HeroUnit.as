package codedrive.galaxians
{
    import codedrive.galaxians.data.GameData;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.geom.Rectangle;
    import flash.media.Sound;
    import flash.ui.Keyboard;

    public class HeroUnit extends Sprite implements IGameElement
    {
        private var _gamePlayScreen:GamePlayScreen;

        private var _livesRemaining:uint;
        private var _multiFireBulletsRemaining:uint;
        private var _squeezeBulletsRemaining:uint;

        private var _activeBulletCount:uint;
        private var _fireMode:Boolean;

        function HeroUnit(gamePlayScreen:GamePlayScreen)
        {
            _gamePlayScreen = gamePlayScreen;

            this.addChild(new HeroUnitSprite());

            _livesRemaining = _gamePlayScreen.gameData.heroLivesCount;
            
            moveToStart();
        }

        public function get livesRemaining():uint
        {
            return _livesRemaining;
        }

        public function get multiFireBulletsRemaining():uint
        {
            return _multiFireBulletsRemaining;
        }

        public function get squeezeBulletsRemaining():uint
        {
            return _squeezeBulletsRemaining;
        }
        
        public function collectDeadEnemyUnitPrize(unit:EnemyUnit):void
        {
            _livesRemaining += unit.unitData.lifeBonus;
            _multiFireBulletsRemaining += unit.unitData.multiFireBonus;
            _squeezeBulletsRemaining += unit.unitData.squeezeFireBonus; 
        }

        public function onDestroyBullet():void
        {
            _activeBulletCount--;
        }

        public function handleGamePlayTimerEvent():void
        {
            fireIfNeeded(false);
        }

        public function fire():void
        {
            _fireMode = true;
            fireIfNeeded(true);  
        }

        public function stopFire():void
        {
            _fireMode = false;
        }

        public function looseLife():void
        {
            if (_livesRemaining)
            {
                _livesRemaining --;
            }
        }

        public function handleArenaMouseDown(event:MouseEvent):void 
        {
            fire();
        }

        public function handleArenaMouseUp(event:MouseEvent):void 
        {
            stopFire();
        }

        public function handleArenaMouseMove(event:MouseEvent):void 
        {
            move(event.localX);
            event.updateAfterEvent();
        }

        public function move(posX:Number):void
        {
            var minX:Number = 0;
            var maxX:Number = GameConstants.GAME_ARENA_WIDTH - GameConstants.HERO_UNIT_WIDTH;
            this.x = Math.max(Math.min(posX - GameConstants.HERO_UNIT_WIDTH / 2, maxX), minX);
            
        }

        private function moveToStart():void
        {
            this.x = (GameConstants.GAME_ARENA_WIDTH / 2) - GameConstants.HERO_UNIT_WIDTH / 2;
            this.y = GameConstants.GAME_ARENA_HEIGHT - GameConstants.HERO_UNIT_HEIGHT;
        }

        private function fireIfNeeded(triggeredByClick:Boolean):void
        {
            if (_fireMode && (_activeBulletCount == 0 || (_multiFireBulletsRemaining != 0 && triggeredByClick)))
            {
                if (_activeBulletCount != 0)
                {
                    _multiFireBulletsRemaining --;
                }
                var bullet:HeroBullet = new HeroBullet(_gamePlayScreen, this);
                if (_squeezeBulletsRemaining != 0)
                {
                    bullet.isSqueezeBullet = true;
                    _squeezeBulletsRemaining --;
                }
                _gamePlayScreen.addGameElement(bullet);
                _activeBulletCount ++;

                if (_gamePlayScreen.isSoundOn)
                {
                    var fireSound:Sound = new FireSound();
                    fireSound.play();
                }
            }
            
        }
    }
}


