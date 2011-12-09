package codedrive.galaxians.data
{
    public class EnemyUnitData
    {
        function EnemyUnitData()
        {
            this.graphics = GRAPHICS_REGULAR;
            this.score = 1;
            this.hueShiftAngle = 0;
            this.bulletSpeed = 0; // Not able to fire

            this.speedDecreaseBonus = 1; // no decrease or increase
            this.multiFireBonus = 0;
            this.squeezeFireBonus = 0;
            this.lifeBonus = 0;
            this.randomKillBonus = 0;                
        }
        public static const GRAPHICS_REGULAR:uint = 1;
        public static const GRAPHICS_SHOOTER:uint = 2;
        public static const GRAPHICS_FLY:uint = 3;

        public var graphics:uint;
        public var hueShiftAngle:Number; 
        public var score:uint;
        public var bulletSpeed:Number;
        public var fireDelay:Number;

        // All bonuses are applied after this unit is killed.
        public var speedDecreaseBonus:Number; // Decreases enemy army speed at specific ratio
        public var multiFireBonus:uint; // Allows Hero to fire specified number of bulled simultaneously when holding 'fire' key
        public var squeezeFireBonus:uint; // Hero bullet will kill each enemy it crosses not depending on enemy type
        public var lifeBonus:uint; // Increases number of Hero lives by specified amount
        public var randomKillBonus:uint; // Randomly kills specified number of enemy units

        public static function constructFromXmlNodeAttributes(attributes:Object):EnemyUnitData
        {
            var data:EnemyUnitData = new EnemyUnitData();
            if (attributes.Graphics != null)
            {
                if (attributes.Graphics == "Regular")
                {
                    data.graphics = GRAPHICS_REGULAR;
                }
                else if (attributes.Graphics == "Shooter")
                {
                    data.graphics = GRAPHICS_SHOOTER;
                }
                else if (attributes.Graphics == "Fly")
                {
                    data.graphics = GRAPHICS_FLY;
                }
            }
            if (attributes.HueShiftAngle != null)
            {
                data.hueShiftAngle = parseFloat(attributes.HueShiftAngle);
            }
            if (attributes.Score != null)
            {
                data.score = parseInt(attributes.Score);
            }
            if (attributes.BulletSpeed != null)
            {
                data.bulletSpeed = parseFloat(attributes.BulletSpeed);
            }
            if (attributes.FireDelay != null)
            {
                data.fireDelay = parseFloat(attributes.FireDelay);
            }
            if (attributes.SpeedDecreaseBonus != null)
            {
                data.speedDecreaseBonus = parseFloat(attributes.SpeedDecreaseBonus);
            }
            if (attributes.MultiFireBonus != null)
            {
                data.multiFireBonus = parseInt(attributes.MultiFireBonus);
            }
            if (attributes.SqueezeFireBonus != null)
            {
                data.squeezeFireBonus = parseInt(attributes.SqueezeFireBonus);
            }
            if (attributes.LifeBonus != null)
            {
                data.lifeBonus = parseInt(attributes.LifeBonus);
            }
            if (attributes.RandomKillBonus != null)
            {
                data.randomKillBonus = parseInt(attributes.RandomKillBonus);
            }
            return data;
        }
    }
}
