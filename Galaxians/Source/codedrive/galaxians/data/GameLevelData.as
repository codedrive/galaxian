package codedrive.galaxians.data
{
    import codedrive.galaxians.GameConstants;
    import flash.xml.XMLNode;

    public class GameLevelData
    {
        public function GameLevelData()
        {
            this.score = 1;
            this.enemyArmyInitialSpeed = 1;
            this.enemyArmyMaximumSpeed = 500;
            this.enemyArmyAcceleration = 0.02;
            this.enemyArmyMoveDownDistance = 20;
            this.heroBulletSpeed = 1000;
            
            // no enemies
            for (var i:uint = 0; i < GameConstants.ENEMY_UNIT_ROWS; i ++)
            {
                this.enemyArmyRectangle += buildEmptyEnemyLine();
            }
        }

        public var score:uint;
        public var enemyArmyInitialSpeed:Number;
        public var enemyArmyMaximumSpeed:Number;
        public var enemyArmyAcceleration:Number;
        public var enemyArmyMoveDownDistance:Number;
        public var heroBulletSpeed:Number;
        public var enemyArmyRectangle:String;

        public static function constructFromXmlNode(node:XMLNode):GameLevelData
        {
            var data:GameLevelData = new GameLevelData();
            if (node.attributes.Score != null)
            {
                data.score = parseInt(node.attributes.Score);
            }
            if (node.attributes.EnemyArmyInitialSpeed != null)
            {
                data.enemyArmyInitialSpeed = parseFloat(node.attributes.EnemyArmyInitialSpeed)
            }
            if (node.attributes.EnemyArmyMaximumSpeed != null)
            {
                data.enemyArmyMaximumSpeed = parseFloat(node.attributes.EnemyArmyMaximumSpeed)
            }
            if (node.attributes.EnemyArmyAcceleration != null)
            {
                data.enemyArmyAcceleration = parseFloat(node.attributes.EnemyArmyAcceleration)
            }
            if (node.attributes.EnemyArmyMoveDownDistance != null)
            {
                data.enemyArmyMoveDownDistance = parseFloat(node.attributes.EnemyArmyMoveDownDistance)
            }
            if (node.attributes.HeroBulletSpeed != null)
            {
                data.heroBulletSpeed = parseInt(node.attributes.HeroBulletSpeed)
            }
            var enemyLine1:String = buildEmptyEnemyLine(); // empty line, no enemies
            var enemyLine2:String = buildEmptyEnemyLine();
            var enemyLine3:String = buildEmptyEnemyLine();
            var enemyLine4:String = buildEmptyEnemyLine();
            var enemyLine5:String = buildEmptyEnemyLine();

            var enemyLineNode:XMLNode = node.firstChild;
            while (enemyLineNode != null)
            {
                if (enemyLineNode.nodeName == "EnemyLine1")
                {
                    enemyLine1 = enemyLineNode.attributes.Enemies;
                }
                else if (enemyLineNode.nodeName == "EnemyLine2")
                {
                    enemyLine2 = enemyLineNode.attributes.Enemies;
                }
                else if (enemyLineNode.nodeName == "EnemyLine3")
                {
                    enemyLine3 = enemyLineNode.attributes.Enemies;
                }
                else if (enemyLineNode.nodeName == "EnemyLine4")
                {
                    enemyLine4 = enemyLineNode.attributes.Enemies;
                }
                else if (enemyLineNode.nodeName == "EnemyLine5")
                {
                    enemyLine5 = enemyLineNode.attributes.Enemies;
                }
                enemyLineNode = enemyLineNode.nextSibling;
            }
            data.enemyArmyRectangle = enemyLine1 + enemyLine2 + enemyLine3 + enemyLine4 + enemyLine5;
            return data;
        }

        private static function buildEmptyEnemyLine():String
        {
            var result:String;
            for (var i:uint = 0; i < GameConstants.ENEMY_UNIT_COLUMNS; i++)
            {
                result += GameConstants.NO_UNIT_SYMBOL;
            }
            return result;
        }
    }
}
