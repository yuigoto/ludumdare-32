package br.com.sixsided.ld32.old.assets;

// Importing packages
import motion.Actuate;
import motion.easing.Quad;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;

/**
 * LD32 :: A "Fruity" Shooter :: Test Player ;)
 * ============================================================
 * 
 * A Test Player (might be excluded later).
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class PlayerTest extends Sprite
{
    /**
     * Handle for the body.
     */
    public var body:Shape;
    
    /**
     * Handles spacebar.
     */
    public var space:Bool;
    
    /**
     * Handles mouseclick.
     */
    public var mouse:Bool;
    
    /**
     * Acceleration.
     */
    public var accel:Float = 0.25;
    
    /**
     * Speed.
     */
    public var speed:Float = 0;
    
    /**
     * Spin.
     */
    public var spinning:Bool = false;
    
    /**
     * HP
     */
    public var HP:Float = 100;
    
    /**
     * HP recharge timer.
     */
    public var HPTime:Int = 100;
    
    /**
     * Bleeding indicator!
     */
    public var bleeds:Bool = false;
    
    /**
     * Bleeding timer
     */
    public var bleedsTime:Int = 20;
    
    /**
     * Ammo.
     */
    public var ammo:Int = 200;
    
    /**
     * Ammo recharge timer.
     */
    public var ammoTime:Int = 5;
    
    /**
     * Is Shooting
     */
    public var regenerate:Bool = false;
    
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Calling super constructor (OpenFl?)
        super();
        
        // Test Body
        body = new Shape();
        
        body.graphics.beginFill( 0x204a85, 1 );
        body.graphics.drawRect( -32, -32, 64, 64 );
        body.graphics.beginFill( 0xedd400, 1 );
        body.graphics.drawRect( -4, -32, 8, 4 );
        body.graphics.endFill();
        
        // Calibrate body angle
        body.rotation = 90;
        
        addChild( body );
        
        
        addEventListener( Event.ENTER_FRAME, framesHandle );
    }
    
    /**
     * 
     * @param e
     */
    private function framesHandle( e:Event ):Void 
    {
        if ( space == true ) {
            if ( speed <= 30 ) {
                speed += accel;
            }
        } else {
            if ( speed > 0 ) {
                speed -= accel;
            } else if ( speed < 0 ) {
                speed = 0;
            }
        }
        
        if ( mouse == true ) {
            if ( space ) {
                this.rotation += speed;
                if ( this.rotation > 360 ) this.rotation -= 360;
            } else {
                var ATAN:Float = Math.atan2(
                    this.parent.mouseY - this.y, 
                    this.parent.mouseX - this.x
                );
                
                var VALS:Float = ATAN * ( 180 / Math.PI );
                
                if ( VALS < 0 ) {
                    VALS = ( 360 - ( 180 - VALS ) ) + 180;
                }
                if ( speed < 5 && speed > 0 ) {
                    this.rotation += speed;
                    if ( this.rotation > 360 ) this.rotation -= 360;
                    
                    if ( Math.floor( this.rotation ) == VALS ) {
                        speed = 0;
                        this.rotation = VALS;
                    }
                } else {
                    this.rotation = VALS;
                }
            }
            
            // Make object follow mouse
            this.x += ( this.parent.mouseX - this.x ) * 0.05;
            if ( this.y > 64 || this.y < this.parent.height - 64 ) {
                this.y += ( this.parent.mouseY - this.y ) * 0.05;
            }
        } else {
            this.rotation += speed;
            if ( this.rotation > 360 ) this.rotation -= 360;
        }
        
        if ( ammo < 200 ) {
            if ( ammoTime == 0 ) {
                ammo += 1;
                ammoTime = 5;
            } else {
                ammoTime -= 1;
            }
            bleeds = true;
        } else {
            bleeds = false;
        }
        
        if ( bleeds == true ) {
            if ( bleedsTime == 0 ) {
                drawBleed();
                
                // Check ammo ratio
                var rate:Float = ( ammo / 200 ) * 100;
                
                if ( rate < 25 ) {
                    bleedsTime = 2;
                } else if ( rate < 50 ) {
                    bleedsTime = 5;
                } else if ( rate < 100 ) {
                    bleedsTime = 10;
                } else {
                    bleedsTime = 20;
                }
            } else {
                bleedsTime -= 1;
            }
        } else {
            if ( regenerate  ) {
                if ( HP < 100 ) {
                    HP += Math.ceil( 1 * ( ammo / 200 ) );
                } else if ( HP > 100 ) {
                    HP = 100;
                }
            } else {
                HP -= 0.25 * ( ammo / 200 );
            }
        }
    }
    
    public function drawBleed():Void
    {
        //
        var drop:Shape = new Shape();
        
        drop.graphics.beginFill( 0xef0000, 1 );
        drop.graphics.drawEllipse( -8, -4, 16, 8 );
        drop.graphics.endFill();
        
        drop.x = this.x + ( randomNumber( -16, 16 ) );
        drop.y = this.y + 32 + ( randomNumber( -16, 16 ) );
        
        stage.addChild( drop );
        
        Actuate.tween(
            drop, 
            2, 
            {
                width: 32, 
                height: 16, 
                alpha: 0
            }
        ).ease( Quad.easeOut ).onComplete( function() {
            stage.removeChild( drop );
        });
    }
    
    /**
     * 
     */
    public function spaceDown():Void 
    {
        space = true;
        spinning = true;
        regenerate = false;
    }
    
    /**
     * 
     */
    public function spaceUp():Void 
    {
        space = false;
        spinning = false;
        regenerate = true;
    }
    
    /**
     * 
     * @param e
     */
    public function mouseDown( e:MouseEvent ):Void 
    {
        mouse = true;
    }
    
    /**
     * 
     * @param e
     */
    public function mouseUp( e:MouseEvent ):Void 
    {
        mouse = false;
        if ( !space ) {
            speed = 0;
        }
    }
    
    public function randomNumber( min:Int, max:Int ):Int 
    {
        return Math.floor( Math.random() * ( max - min ) ) + min;
    }
}