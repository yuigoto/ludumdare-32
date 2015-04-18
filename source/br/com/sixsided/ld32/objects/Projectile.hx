package br.com.sixsided.ld32.objects;
import openfl.display.Shape;

/**
 * ...
 * @author Fabio Yuiti Goto
 */
class Projectile extends Shape
{
    // Stores distance traveled
    public var traveled:Float = 0;
    
    /**
     * 
     */
    public function new() 
    {
        super();
        
        graphics.beginFill( 0xef2929 );
        graphics.drawRect( -8, -4, 16, 8 );
        graphics.endFill();
    }
}