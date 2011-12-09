package codedrive.galaxians
{
    import flash.ui.Keyboard;
    public class GameConstants
    {
        public static const GAME_ARENA_WIDTH:Number = 740;
        public static const GAME_ARENA_HEIGHT:Number = 665;

        public static const ENEMY_UNIT_WIDTH:Number = 40;
        public static const ENEMY_UNIT_HEIGHT:Number = 40;
        public static const HERO_UNIT_WIDTH:Number = 60;
        public static const HERO_UNIT_HEIGHT:Number = 100;

        public static const HERO_MOVE:Number = 10;

        public static const ENEMY_UNIT_COLUMNS:uint = 11;
        public static const ENEMY_UNIT_ROWS:uint = 5;

        public static const ENEMY_UNIT_DISTANCE_X:Number = 10;
        public static const ENEMY_UNIT_DISTANCE_Y:Number = 10;

        public static const BULLET_WIDTH:Number = 4;
        public static const BULLET_HEIGHT:Number = 18;

        public static const ENEMY_ARMY_WIDTH:Number = (ENEMY_UNIT_WIDTH + ENEMY_UNIT_DISTANCE_X) * ENEMY_UNIT_COLUMNS - ENEMY_UNIT_DISTANCE_X;
        
        public static const BULLET_MOVE_PIXEL_STEP:Number = 1;

        public static const GAME_TIMER_INTERVAL:Number = 0.03;
        public static const GAME_OVER_DISPLAY_TIME:Number = 1;
        public static const NO_UNIT_SYMBOL:String = "_";

        public static const START_GAME_BUTTON_X:Number = 200;
        public static const START_GAME_BUTTON_Y:Number = 330;
        public static const GAME_OVER_TEXT_X:Number = 130;
        public static const GAME_OVER_TEXT_Y:Number = 300;
        public static const CONGRATULATIONS_TEXT_X:Number = 70;
        public static const CONGRATULATIONS_TEXT_Y:Number = 250;

        public static const GAME_INFORMATION_FONT:String = "Tahoma";
        public static const GAME_INFORMATION_FONT_SIZE:Number = 30;
        public static const GAME_INFORMATION_FONT_COLOR:uint = 0x000000;
        public static const GAME_INFORMATION_TOP:Number = 680;
        public static const SCORE_LABEL_X:Number = 20;
        public static const LIVES_LABEL_X:Number = 220;
        public static const LEVEL_LABEL_X:Number = 380;
        public static const MULTIFIRE_ICON_X:Number = 530;
        public static const MULTIFIRE_LABEL_X:Number = 550;
        public static const SQUEEZEFIRE_ICON_X:Number = 620;
        public static const SQUEEZEFIRE_LABEL_X:Number = 650;
        public static const SOUND_ICON_X:Number = 690;

        public static const TEXT_SCORE:String = "Score: ";
        public static const TEXT_LIVES:String = "Lives: ";
        public static const TEXT_LEVEL:String = "Level: ";
    }
}
