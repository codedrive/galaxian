package codedrive.galaxians
{
    import codedrive.galaxians.data.GameData;
    import flash.display.MovieClip;
    import flash.display.SpreadMethod;
    import flash.display.Sprite;
    import codedrive.galaxians.data.GameData;
    import codedrive.galaxians.data.GameLevelData;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.globalization.CurrencyParseResult;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    import flash.display.SimpleButton;

    public class GamePlayScreen extends Sprite 
    {
        private static const MOVE_DIRECTION_LEFT:uint = 1;
        private static const MOVE_DIRECTION_RIGHT:uint = 2;

        private var _game:GalaxiansGame;
        private var _gameData:GameData;
        private var _gameElements:Array;

        private var _gameInformation:GameInformation;
        
        private var _hero:HeroUnit;
        private var _enemies:Array;

        private var _gameTimer:Timer;
        private var _levelTime:Number;

        private var _gamePlayRectangle:Sprite;
        private var _gameArenaBackground:Sprite;

        private var _level:uint;
        private var _score:uint;

        private var _enemyArmyX:Number;
        private var _enemyArmyY:Number;
        
        private var _enemyArmyMoveDirection:uint;
        private var _enemyArmyPixelsMovedDown:Number;
        private var _enemyArmyIsMovingDown:Boolean;

        private var _isGameOver:Boolean;
        private var _gameOverDisplayTime:Number;

        private var _keys:Array;

        private var _explosion:UnitExplode = null;
        private var _soundIcon:SimpleButton;

        public function get isSoundOn():Boolean
        {
            if (!_gameInformation)
                return true;

            return _gameInformation.isSoundOn;
        }

        public function GamePlayScreen(game:GalaxiansGame, gameData:GameData)
        {
            _game = game;
            _gameData = gameData;

            this.addChild(new GamePlayScreenBackground());

            _gameElements = new Array();

            initArenaBackground();

            _hero = new HeroUnit(this);
            addGameElement(_hero);

            _gameTimer = new Timer(GameConstants.GAME_TIMER_INTERVAL * 1000);
            _gameTimer.addEventListener(TimerEvent.TIMER, gameTimerHandler);

            this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            this.addEventListener(MouseEvent.MOUSE_UP,   mouseUpHandler);
            this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            
            this.mouseChildren = false;

            _gameInformation = new GameInformation(this);
            _gameInformation.update();

            _keys = new Array();
        }

        public function startBattle():void
        {
            constructEnemies();
            _levelTime = 0;
            _gameTimer.start();
            stage.focus = this;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
        }

        public function addGameElement(element:IGameElement):void
        {
            this.gamePlayRectangle.addChild(element as Sprite);
            _gameElements.push(element);
        }

        public function removeGameElement(element:IGameElement):void
        {
            this.gamePlayRectangle.removeChild(element as Sprite);
            var elementIndex:int = _gameElements.indexOf(element);
            _gameElements.splice(elementIndex, 1);
        }

        public function killEnemy(enemy:EnemyUnit, collectPrizes:Boolean):void
        {
            var explosion:UnitExplode = new UnitExplode(this, enemy);
            var enemyIndex:int = _enemies.indexOf(enemy);
            _enemies.splice(enemyIndex, 1);
            removeGameElement(enemy);

            if (collectPrizes)
            {
                collectDeadEnemyUnitPrize(enemy);
            }
        }

        public function collectDeadEnemyUnitPrize(deadEnemy:EnemyUnit):void
        {
            _hero.collectDeadEnemyUnitPrize(deadEnemy);

            for (var randomKill:uint = 0; randomKill < deadEnemy.unitData.randomKillBonus; randomKill ++)
            {
                if (enemies.length == 0)
                {
                    break;
                }
                var enemyIndexToKill:uint = Math.floor(_enemies.length * Math.random());
                var enemyToKill:EnemyUnit = _enemies[enemyIndexToKill] as EnemyUnit;
                // Do not collect prizes for randomly killed enemies
                killEnemy(enemyToKill, false);
            }
            if (deadEnemy.unitData.speedDecreaseBonus != 0)
            {
                // decrease speed for the enemy army
                // speed decrease bonus can be used to increase enemy army speed,
                // but this is not a good prize :)
                _levelTime *= deadEnemy.unitData.speedDecreaseBonus;
            }
            _score += deadEnemy.unitData.score;
       }

        public function get gamePlayRectangle():Sprite
        {
            return _gamePlayRectangle;
        }

        public function get enemyArmyX():Number
        {
            return _enemyArmyX;
        }

        public function get enemyArmyY():Number
        {
            return _enemyArmyY;
        }

        public function get gameData():GameData
        {
            return _gameData;
        }

        public function get currentLevelData():GameLevelData
        {
            return _gameData.gameLevels[_level];
        }

        public function get hero():HeroUnit
        {
            return _hero;
        }

        public function get enemies():Array
        {
            return _enemies;
        }

        public function get level():uint
        {
            return _level;
        }

        public function get score():uint
        {
            return _score;
        }

        private function constructEnemies():void
        {
            _enemies = new Array();

            _enemyArmyX = (GameConstants.GAME_ARENA_WIDTH - GameConstants.ENEMY_ARMY_WIDTH) / 2;
            _enemyArmyY = 0;
            _enemyArmyMoveDirection = MOVE_DIRECTION_RIGHT;

            var levelData:GameLevelData = this.currentLevelData;
            for (var enemyIndex:uint = 0; enemyIndex < GameConstants.ENEMY_UNIT_COLUMNS * GameConstants.ENEMY_UNIT_ROWS; enemyIndex ++)
            {
                var enemySymbol:String = levelData.enemyArmyRectangle.charAt(enemyIndex);
                if (enemySymbol != GameConstants.NO_UNIT_SYMBOL)
                {
                    var enemy:EnemyUnit = new EnemyUnit(this, enemySymbol, enemyIndex);
                    addGameElement(enemy);
                    _enemies.push(enemy);
                }
            }
        }

        private function initArenaBackground():void
        {
            _gamePlayRectangle = new Sprite();
            _gamePlayRectangle.graphics.beginFill(0, 0);
            _gamePlayRectangle.graphics.drawRect(0, 0, GameConstants.GAME_ARENA_WIDTH,  GameConstants.GAME_ARENA_HEIGHT);
            _gamePlayRectangle.graphics.endFill();

            this.addChild(_gamePlayRectangle);

            var gamePlayRectangleMask:Sprite = new Sprite();
            gamePlayRectangleMask.graphics.beginFill(0);
            gamePlayRectangleMask.graphics.drawRect(0, 0, GameConstants.GAME_ARENA_WIDTH, GameConstants.GAME_ARENA_HEIGHT);
            gamePlayRectangleMask.graphics.endFill();

            this.addChild(gamePlayRectangleMask);
            gamePlayRectangle.mask = gamePlayRectangleMask;
        }

        private function mouseDownHandler(event:MouseEvent):void 
        {
            if (_gameInformation.soundIcon.hitTestPoint(event.stageX, event.stageY))
            {
                _gameInformation.switchSound();
            }

            if (!_isGameOver && !_explosion)
            {
                _hero.handleArenaMouseDown(event);
            }
            else if (_gameOverDisplayTime <= 0)
            {
                _game.runGameStartScreen();
            }
        }

        private function mouseUpHandler(event:MouseEvent):void 
        {
            _hero.handleArenaMouseUp(event);
        }

        private function mouseMoveHandler(event:MouseEvent):void 
        {
            if (!_isGameOver)
            {
                _hero.handleArenaMouseMove(event);
            }
        }

        private function keyDownHandler(event:KeyboardEvent):void
        {
            _keys[event.keyCode] = true;
        }

        private function keyUpHandler(event:KeyboardEvent):void
        {
            _keys[event.keyCode] = false;
        }

        private function enterFrameHandler(e:Event):void
        {
            update();
        }


        private function update():void
        {
            if (_explosion)
            {
                return;
            }

            if (_keys[Keyboard.LEFT])
            {
                _hero.move(_hero.x + GameConstants.HERO_UNIT_WIDTH / 2 - GameConstants.HERO_MOVE);
            }
            else if(_keys[Keyboard.RIGHT])
            {
                _hero.move(_hero.x + GameConstants.HERO_UNIT_WIDTH / 2 + GameConstants.HERO_MOVE);
            }
            
            if(_keys[Keyboard.SPACE])
            {
                _hero.fire();
            }
            else
            {
                _hero.stopFire();
            }
        }

        private function gameTimerHandler(event:TimerEvent):void 
        {
            update();
            if (_isGameOver)
            {
                _gameOverDisplayTime -= GameConstants.GAME_TIMER_INTERVAL;                
            }
            else
            {
                _levelTime += GameConstants.GAME_TIMER_INTERVAL;
                moveEnemyArmy();
                for (var gameElementIndex:uint = 0; gameElementIndex < _gameElements.length; gameElementIndex ++)
                {
                    var gameElement:IGameElement = _gameElements[gameElementIndex];
                    gameElement.handleGamePlayTimerEvent();
                }
                _gameInformation.update();
                checkIfGameIsOver();
                checkIfLevelIsCompleted();
                event.updateAfterEvent();
            }
        }


        private function moveEnemyArmy():void
        {
            var speed:Number = Math.min(currentLevelData.enemyArmyInitialSpeed + _levelTime * currentLevelData.enemyArmyAcceleration,
                currentLevelData.enemyArmyMaximumSpeed) * GameConstants.GAME_TIMER_INTERVAL;
            
            if (_enemyArmyIsMovingDown)
            {
                _enemyArmyY += speed;
                _enemyArmyPixelsMovedDown += speed;
                if (_enemyArmyPixelsMovedDown > currentLevelData.enemyArmyMoveDownDistance)
                {
                    _enemyArmyIsMovingDown = false;
                }
            }
            else if (_enemyArmyMoveDirection == MOVE_DIRECTION_RIGHT)
            {
                _enemyArmyX += speed;
                if (_enemyArmyX >= GameConstants.GAME_ARENA_WIDTH - GameConstants.ENEMY_ARMY_WIDTH)
                {
                    _enemyArmyX = GameConstants.GAME_ARENA_WIDTH - GameConstants.ENEMY_ARMY_WIDTH;
                    _enemyArmyMoveDirection = MOVE_DIRECTION_LEFT;
                    _enemyArmyPixelsMovedDown = 0;
                    _enemyArmyIsMovingDown = true;
                }
            }
            else if (_enemyArmyMoveDirection == MOVE_DIRECTION_LEFT)
            {
                _enemyArmyX -= speed;
                if (enemyArmyX <= 0)
                {
                    _enemyArmyX = 0;
                    _enemyArmyMoveDirection = MOVE_DIRECTION_RIGHT;
                    _enemyArmyPixelsMovedDown = 0;
                    _enemyArmyIsMovingDown = true;
                }
            }            
        }

        private function checkIfGameIsOver():void
        {
            var enemyHitTheBorder:Boolean = false;
            for (var enemyIndex:uint = 0; enemyIndex < _enemies.length; enemyIndex ++)
            {
                var enemy:EnemyUnit = _enemies[enemyIndex];
                if (enemy.hitTestObject(_hero) || enemy.y >= (GameConstants.GAME_ARENA_HEIGHT - enemy.height))
                {
                    enemyHitTheBorder = true;
                    break;
                }
            }
            _isGameOver = enemyHitTheBorder || (hero.livesRemaining == 0);

            if (_isGameOver)
            {
                if (!_explosion)
                {
                    removeGameElement(_hero);
                    this.removeEventListener(MouseEvent.MOUSE_UP,   mouseUpHandler);
                    this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
                    _explosion = new UnitExplode(this, _hero);
                    _isGameOver = false;
                }
                else
                {
                    _isGameOver = _explosion.isExplodeOver;
                }
            }
            
            if (_isGameOver)
            {
                _gamePlayRectangle.visible = false;
                _gameOverDisplayTime = GameConstants.GAME_OVER_DISPLAY_TIME;
                var gameOverText:Sprite = new GameOverText();
                this.addChild(gameOverText);
                gameOverText.x = GameConstants.GAME_OVER_TEXT_X;
                gameOverText.y = GameConstants.GAME_OVER_TEXT_Y;
            }
        }

        private function checkIfLevelIsCompleted():void
        {
            if (enemies.length == 0)
            {
                _score += currentLevelData.score;
                _level ++;
                if (_level < _gameData.gameLevels.length)
                {
                    _levelTime = 0;
                    constructEnemies();
                }
                else
                {
                    _isGameOver = true;
                    _gamePlayRectangle.visible = false;
                    _gameOverDisplayTime = GameConstants.GAME_OVER_DISPLAY_TIME;
                    var congratulationsText:Sprite = new CongratulationsText();
                    this.addChild(congratulationsText);
                    congratulationsText.x = GameConstants.CONGRATULATIONS_TEXT_X;
                    congratulationsText.y = GameConstants.CONGRATULATIONS_TEXT_Y;
                }
            }
        }

    }
}
