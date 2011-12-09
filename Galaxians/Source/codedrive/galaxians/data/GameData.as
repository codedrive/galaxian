package codedrive.galaxians.data
{
    import codedrive.galaxians.EnemyUnit;
    import codedrive.galaxians.GalaxiansGame;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.xml.XMLDocument;
    import flash.xml.XMLNode;
    import flash.xml.XMLNodeType;
    import flash.utils.ByteArray;

    public class GameData
    {
        private var game:GalaxiansGame;

        public function GameData(game:GalaxiansGame)
        {
            this.game = game;    

            this.gameLevels = new Array();
            this.enemyUnits = new Object();

            this.heroLivesCount = 3;

        }

        public function loadAndParseXml():void
        {
            var xmlString:String = loadXml();
            parse(xmlString);
        }

        public var heroLivesCount:uint;
        public var gameLevels:Array;
        private var enemyUnits:Object;

        public function getEnemyUnitBySymbol(symbol:String):EnemyUnitData
        {
            var unit:EnemyUnitData = enemyUnits[symbol] as EnemyUnitData;
            if (unit == null)
            {
                unit = new EnemyUnitData();
            }
            return unit;
        }

        private function loadXml():String
        {
            var byteArray:ByteArray = new GalaxiansXmlData();
            return byteArray.toString(); 
        }

        private function parse(xmlString:String):void
        {
            var xmlDocument:XMLDocument = new XMLDocument();
            xmlDocument.parseXML(xmlString);

            var xmlNode:XMLNode = xmlDocument.firstChild;
            if (xmlNode.nodeName == "Galaxians")
            {
                if (xmlNode.attributes.HeroLivesCount != null)
                {
                    this.heroLivesCount = parseInt(xmlNode.attributes.HeroLivesCount)
                }
                xmlNode = xmlNode.firstChild;
                while (xmlNode != null)
                {
                    if (xmlNode.nodeName == "EnemyUnits")                    
                    {
                        var enemyUnitNode:XMLNode = xmlNode.firstChild;
                        while (enemyUnitNode != null)
                        {
                            if (enemyUnitNode.nodeName == "EnemyUnit")
                            {
                                var symbol:String = enemyUnitNode.attributes.Symbol;
                                var enemyUnitData:EnemyUnitData = EnemyUnitData.constructFromXmlNodeAttributes(enemyUnitNode.attributes);
                                this.enemyUnits[symbol] = enemyUnitData;
                            }
                            enemyUnitNode = enemyUnitNode.nextSibling;
                        }
                    }
                    if (xmlNode.nodeName == "Levels")
                    {
                        var levelNode:XMLNode = xmlNode.firstChild;
                        while (levelNode != null)
                        {
                            if (levelNode.nodeName == "Level")
                            {
                                var gameLevelData:GameLevelData = GameLevelData.constructFromXmlNode(levelNode);
                                this.gameLevels.push(gameLevelData);
                            }
                            levelNode = levelNode.nextSibling;
                        }
                    }
                    xmlNode = xmlNode.nextSibling;
                }
            }
            game.runGameStartScreen();
        }
    }
}
