package br.com.sixsided.ld32.old.assets;
import openfl.display.Shape;
import openfl.events.Event;

/**
 * LD32 :: A "Fruity" Shooter :: Test Projectile
 * ============================================================
 * 
 * A Test Projectile.
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class TestShot extends Shape
{
    // Stores distance traveled
    public var traveled:Float = 0;
    
    public function new() 
    {
        super();
        
        graphics.beginFill( 0xef2929 );
        graphics.drawRect( -8, -4, 16, 8 );
        graphics.endFill();
    }
    
    public function fireMove( e:Event ):Void 
    {
        var distance:Int = 16;
        var angles:Float = this.rotation;
        var newX:Float;
        var newY:Float;
        
        newX = this.x + ( distance * Math.cos( angles * ( Math.PI / 180 ) ) );
        newY = this.y + ( distance * Math.sin( angles * ( Math.PI / 180 ) ) );
        this.x = newX;
        this.y = newY;
    }
}