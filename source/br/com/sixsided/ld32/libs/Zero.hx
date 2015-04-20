package br.com.sixsided.ld32.libs;
import openfl.geom.Point;

/**
 * LD32 :: An Unconventional Weapon :: "Berry, The Last Straw"
 * ============================================================
 * 
 * LIBRARY AND REUSABLE CODE FOR THE GAME. :3
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class Zero
{
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Silence is golden.
    }
    
    
    
    /* CALCULATIONS AND STUFF
     * ============================================================ */
    
    /**
     * Defines a random number between min and max.
     */
    public static function randomNumber( min:Int = 1, max:Int = 2147483647 ):Int 
    {
        return Math.floor( Math.random() * ( max - min ) ) + min;
    }
    
    /**
     * Finds the second coordinate in a line, given the first coordinate, 
     * the angle and the distance.
     * 
     * @param angles
     * @param distance
     * @param pX
     * @param pY
     * @return
     */
    public static function defineVertex( 
        angles:Float, 
        distance:Float, 
        pX:Float, 
        pY:Float 
    ):Point {
        // Radian value
        var radian:Float = Math.PI / 180;
        
        return new Point (
            pX + ( distance * Math.cos( angles * radian ) ), 
            pY + ( distance * Math.sin( angles * radian ) )
        );
    }
}