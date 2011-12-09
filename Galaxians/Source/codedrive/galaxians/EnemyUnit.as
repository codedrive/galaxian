package codedrive.galaxians
{
    import codedrive.galaxians.data.EnemyUnitData;
    import codedrive.galaxians.data.GameData;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.filters.ColorMatrixFilter;
    import flash.events.TimerEvent;


    // This class is abstract
    public class EnemyUnit extends Sprite implements IGameElement
    {
        private var _gamePlayScreen:GamePlayScreen;
        private var _symbol:String;
        private var _unitNumber:uint;

        private var _unitMovie:MovieClip;

        private var _haveActiveBullet:Boolean;
        private var _fireDelay:Number;

        private var _enemyArmyOffsetX:Number;
        private var _enemyArmyOffsetY:Number;

         // unitNumber is a number of this unit in enemy army rectangle: unitNumber = y * (row) + column
        function EnemyUnit(gamePlayScreen:GamePlayScreen, symbol:String, unitNumber:uint)
        {
            _gamePlayScreen = gamePlayScreen;
            _symbol = symbol;
            _unitNumber = unitNumber;

            this.addChild(createUnitMovie());

            var filters:Array = new Array();
            filters.push(createHueShiftColorMatrixFilter(unitData.hueShiftAngle));
            this.filters = filters;
            
            _fireDelay = Math.random();
            calculateUnitPlacement();
            move();
        }

        public function get unitData():EnemyUnitData
        {
            return _gamePlayScreen.gameData.getEnemyUnitBySymbol(_symbol);
        }

        public function handleGamePlayTimerEvent():void
        {
            _fireDelay = Math.max(0, _fireDelay - GameConstants.GAME_TIMER_INTERVAL);
            move();
            fireIfNeeded();
        }

        public function onDestroyBullet():void
        {
            _haveActiveBullet = false;
            _fireDelay = unitData.fireDelay;
        }

        private function createUnitMovie():MovieClip
        {
            var unitMovie:MovieClip = new MovieClip();
            switch (this.unitData.graphics)
            {
                case EnemyUnitData.GRAPHICS_REGULAR:
                {
                    unitMovie = new EnemyRegularUnitSprite();
                    break;
                }
                case EnemyUnitData.GRAPHICS_SHOOTER:
                {
                    unitMovie = new EnemyShooterUnitSprite();
                    break;
                }
                case EnemyUnitData.GRAPHICS_FLY:
                {
                    unitMovie = new EnemyFlyUnitSprite();
                    break;
                }
            }
            var frameIndex:uint = Math.floor(Math.random() * unitMovie.totalFrames);
            unitMovie.gotoAndPlay(frameIndex);
            return unitMovie;
        }

        private function calculateUnitPlacement():void
        {
            // unit X coordinate in enemy army rectangle
            var enemyArmyXCoord:uint = _unitNumber % GameConstants.ENEMY_UNIT_COLUMNS;
            // unit Y coordinate in enemy army rectangle
            var enemyArmyYCoord:uint = Math.floor(_unitNumber / GameConstants.ENEMY_UNIT_COLUMNS);

            _enemyArmyOffsetX = enemyArmyXCoord * (GameConstants.ENEMY_UNIT_WIDTH + GameConstants.ENEMY_UNIT_DISTANCE_X);
            _enemyArmyOffsetY = enemyArmyYCoord * (GameConstants.ENEMY_UNIT_HEIGHT + GameConstants.ENEMY_UNIT_DISTANCE_Y);
        }

        private static function createHueShiftColorMatrixFilter(angle:Number):ColorMatrixFilter
        {
            angle *= Math.PI/180;
            
            var c:Number = Math.cos(angle);
            var s:Number = Math.sin(angle);
            
            var mulR:Number = 0.213;
            var mulG:Number = 0.715;
            var mulB:Number = 0.072;
            
            var matrix:Array = new Array();
  
            matrix = matrix.concat([(mulR + (c * (1 - mulR))) + (s * (-mulR)), (mulG + (c * (-mulG))) + (s * (-mulG)), (mulB + (c * (-mulB))) + (s * (1 - mulB)), 0, 0]);
            matrix = matrix.concat([(mulR + (c * (-mulR))) + (s * 0.143), (mulG + (c * (1 - mulG))) + (s * 0.14), (mulB + (c * (-mulB))) + (s * -0.283), 0, 0]);
            matrix = matrix.concat([(mulR + (c * (-mulR))) + (s * (-(1 - mulR))), (mulG + (c * (-mulG))) + (s * mulG), (mulB + (c * (1 - mulB))) + (s * mulB), 0, 0]);
            matrix = matrix.concat([0, 0, 0, 1, 0]);

            var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
            return filter;
        }

        private function fireIfNeeded():void
        {
            if (!_haveActiveBullet && unitData.bulletSpeed != 0 && _fireDelay == 0)
            {
                var bullet:EnemyBullet = new EnemyBullet(_gamePlayScreen, this);
                _gamePlayScreen.addGameElement(bullet);
                _haveActiveBullet = true;
            }
        }

        private function move():void
        {
            this.x = _gamePlayScreen.enemyArmyX + _enemyArmyOffsetX;
            this.y = _gamePlayScreen.enemyArmyY + _enemyArmyOffsetY;            
        }
    }
}
