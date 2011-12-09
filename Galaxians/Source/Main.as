package 
{
    import codedrive.galaxians.GalaxiansGame;
    import flash.display.MovieClip;

    public class Main extends MovieClip
    {
        public function Main()
        {
            var game:GalaxiansGame = new GalaxiansGame();
            this.addChild(game);
        }
    }
}
