package br.com.sixsided.ld32.objects;
import openfl.display.Sprite;

/**
 * ...
 * @author Fabio Yuiti Goto
 */
class Player extends Sprite  
{   
    public var velocity:Float = 0.25;
    public var speed:Float = 0;
    public var spinning:Bool = false;
    public var HP:Float = 100;
    public var HPTime:Int = 5;
    public var AMMO:Float = 200;
    public var AMMOTime:Int = 2;
    
    public function new() 
    {
        super();
        graphics.beginFill( 0x204a85, 1 );
        graphics.drawRect( -32, -32, 64, 64 );
        graphics.beginFill( 0xedd400, 1 );
        graphics.drawRect( 28, -4, 4, 8 );
        graphics.endFill();
    }
}