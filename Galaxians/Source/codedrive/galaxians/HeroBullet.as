package codedrive.galaxians
{
    import flash.display.Sprite;

    public class HeroBullet extends Sprite implements IGameElement
    {
        private var _gamePlayScreen:GamePlayScreen;
        private var _hero:HeroUnit;

        function HeroBullet(gamePlayScreen:GamePlayScreen, hero:HeroUnit)
        {
            _gamePlayScreen = gamePlayScreen;
            _hero = hero;

            this.addChild(new HeroBulletSprite());
            
            this.x = _hero.x + GameConstants.HERO_UNIT_WIDTH / 2 - GameConstants.BULLET_WIDTH / 2;
            this.y = _hero.y - GameConstants.BULLET_HEIGHT;
        }

        // Squeeze bullets destroy all enemies they pass
        // not depending on enemy lives count
        public var isSqueezeBullet:Boolean;

        public function handleGamePlayTimerEvent():void
        {
            var pixelsToMove:Number = _gamePlayScreen.currentLevelData.heroBulletSpeed * GameConstants.GAME_TIMER_INTERVAL;
            var isDestroyed:Boolean = false;
            while (pixelsToMove > 0 && !isDestroyed)
            {
                this.y -= GameConstants.BULLET_MOVE_PIXEL_STEP;
                pixelsToMove -= GameConstants.BULLET_MOVE_PIXEL_STEP;
                isDestroyed = checkIfHit();
            }

        }

        private function checkIfHit():Boolean
        {
            var needDestroy:Boolean;
            if (this.y < -this.height)
            {
                needDestroy = true;
            }
            else
            {
                for (var enemyIndex:uint = 0; enemyIndex < _gamePlayScreen.enemies.length; enemyIndex ++)
                {
                    var enemy:EnemyUnit = _gamePlayScreen.enemies[enemyIndex] as EnemyUnit;
                    if (this.hitTestObject(enemy))
                    {
                        if (!this.isSqueezeBullet)
                        {
                            needDestroy = true;
                        }
                        _gamePlayScreen.killEnemy(enemy, true);
                        break;
                    }
                } 
            }
            if (needDestroy)
            {
                _gamePlayScreen.removeGameElement(this);
                _gamePlayScreen.hero.onDestroyBullet();
            }
            return needDestroy;
        }
    }
}
