package br.com.sixsided.ld32.old.assets;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * LD32 :: A "Fruity" Shooter :: A More Refined Test Player ;)
 * ============================================================
 * 
 * A More Refined Test Player (might be excluded later).
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class PlayerBase extends Sprite
{
    /* PUBLIC VARS
     * ======================================== */
    
    /**
     * Handle for spacebar.
     */
    public var spacebar:Bool;
    
    /**
     * Body (or at least the collision shape).
     */
    public var body:Shape;
    
    /**
     * Acceleration factor (?).
     */
    public var velocity:Float = 0.25;
    
    /**
     * Current speed.
     */
    public var speed:Float = 0;
    
    /**
     * Player health.
     */
    public var HP:Int = 100;
    
    /**
     * Health recovery timer.
     */
    public var HPTime:Int = 5;
    
    /**
     * Ammo indicator.
     */
    public var ammo:Int = 200;
    
    /**
     * Ammo recovery timer.
     */
    public var ammoTime:Int = 5;
    
    /**
     * Indicates if the sprite is spinning or not.
     */
    public var spinning:Bool = false;
    
    /**
     * Bleeding indicator.
     */
    public var bleeding:Bool = false;
    
    /**
     * Shooting indicator.
     */
    public var shooting:Bool = false;
    
    
    /* CONSTRUCTOR
     * ======================================== */
    
    /**
     * 
     */
    public function new() 
    {
        // Super constructor
        super();
        
        // Body
        body = new Shape();
        
        // Drawing "body"
        body.graphics.beginFill( 0x204a85, 1 );
        body.graphics.drawRect( -32, -32, 64, 64 );
        body.graphics.beginFill( 0xedd400, 1 );
        body.graphics.drawRect( -4, -32, 8, 4 );
        body.graphics.endFill();
        
        // Rotates the shape so head point to rotation "0" (FIX LATER)
        body.rotation = 90;
        
        // Adds child and sets index
        this.addChild( body );
        this.setChildIndex( body, 1 );
    }
    
    /* EVENT LISTENERS
     * ======================================== */
    
    /**
     * 
     * @param e
     */
    public function playerFrames( e:Event ):Void 
    {
    }
    
    /* MATHS AND ALGORITHMS
     * ======================================== */
    
    /**
     * Health, bleed and ammo related maths.
     */
    public function healthCalculations():Void 
    {
    }
}