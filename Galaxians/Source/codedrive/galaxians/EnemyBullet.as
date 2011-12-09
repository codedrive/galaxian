package codedrive.galaxians
{
    import flash.display.Sprite;

    public class EnemyBullet extends Sprite implements IGameElement
    {
        private var _gamePlayScreen:GamePlayScreen;
        private var _enemy:EnemyUnit;


        public function EnemyBullet(gamePlayScreen:GamePlayScreen, enemy:EnemyUnit)
        {
            _gamePlayScreen = gamePlayScreen;
            _enemy = enemy;

            this.addChild(new EnemyBulletSprite());

            this.x = _enemy.x + GameConstants.ENEMY_UNIT_WIDTH / 2 - GameConstants.BULLET_WIDTH / 2;
            this.y = _enemy.y + GameConstants.ENEMY_UNIT_HEIGHT;
        }

        public function handleGamePlayTimerEvent():void
        {
            var pixelsToMove:Number = _enemy.unitData.bulletSpeed * GameConstants.GAME_TIMER_INTERVAL;
            var isDestroyed:Boolean;
            while (pixelsToMove > 0 && !isDestroyed)
            {
                this.y += GameConstants.BULLET_MOVE_PIXEL_STEP;
                pixelsToMove -= GameConstants.BULLET_MOVE_PIXEL_STEP;
                isDestroyed = checkIfHit();
            }
        }

        private function checkIfHit():Boolean
        {
            var needDestroy:Boolean;
            if (this.y > GameConstants.GAME_ARENA_HEIGHT)
            {
                needDestroy = true;
            }
            else if (this.hitTestObject(_gamePlayScreen.hero))
            {
                needDestroy = true;
                _gamePlayScreen.hero.looseLife();
            }
            if (needDestroy)
            {
                _gamePlayScreen.removeGameElement(this);
                _enemy.onDestroyBullet();
            }
            return needDestroy;
        }
    }
}
