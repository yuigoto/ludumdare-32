package br.com.sixsided.ld32;

import br.com.sixsided.ld32.objects.Arena;
import br.com.sixsided.ld32.objects.Player;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

/**
 * Debug main.
 * 
 * @author Fabio Yuiti Goto
 */
class MainTest extends Sprite
{
    /* VARIABLES
     * ============================================================ */
    
    public var arena:Arena;
    public var player:Player;
    public var keys:Array<Bool> = [];
    public var mouseclick:Bool = false;
    public var mouseleave:Bool = false;
    public var mouseleavetime:Int = 120;
    
    /* CONSTRUCTOR
     * ============================================================ */
    
    /**
     * Main constructor.
     */
    public function new() 
    {
        super();
        
        // Checks if stage was initialized
        if ( null != stage ) {
            init( null );
        } else {
            addEventListener( Event.ADDED_TO_STAGE, init );
        }
    }
    
    
    
    /* EVENT HANDLERS
     * ============================================================ */
    
    /**
     * Main method, works like a "constructor".
     * 
     * @param e
     */
    private function init( e:Event ):Void 
    {
        // Remove event listener
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Initial debug message
        trace( 'Debug mode initialized!' );
        
        arena = new Arena();
        addChild( arena );
        
        arena.x = stage.stageWidth / 2 - arena.width / 2;
        arena.y = stage.stageHeight / 2 - arena.height / 2;
        
        player = new Player();
        arena.addChild( player );
        
        player.x = arena.width / 2;
        player.y = arena.height / 2;
        
        // Adding keyboard events to stage
        addEventListener( Event.ENTER_FRAME, handleFrames );
        stage.addEventListener( KeyboardEvent.KEY_DOWN, keysDn );
        stage.addEventListener( KeyboardEvent.KEY_UP, keysUp );
        stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDn );
        stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
    }
    
    /**
     * 
     * @param e
     */
    private function handleFrames( e:Event ):Void 
    {
        playerMovement();
        
        // MAKES camera follow player
        arena.x = stage.stageWidth / 2 - player.x;
        arena.y = stage.stageHeight / 2 - player.y;
    }
    
    /**
     * 
     * @param e
     */
    private function keysDn( e:KeyboardEvent ):Void 
    {
        keys[ e.keyCode ] = true;
    }
    
    /**
     * 
     * @param e
     */
    private function keysUp( e:KeyboardEvent ):Void 
    {
        keys[ e.keyCode ] = false;
    }
    
    /**
     * 
     * @param e
     */
    private function mouseUp( e:MouseEvent ):Void 
    {
        mouseclick = false;
        mouseleave = true;
    }
    
    /**
     * 
     * @param e
     */
    private function mouseDn( e:MouseEvent ):Void 
    {
        mouseclick = true;
        mouseleave = false;
        mouseleavetime = 120;
    }
    
    
    
    /* MOVEMENT HANDLERS
     * ============================================================ */
    
    /**
     * 
     */
    public function playerMovement():Void 
    {
        // Checking spacebar pressed for rotation
        if ( true == keys[32] ) {
            if ( player.speed < 30 ) {
                player.speed += player.velocity;
            }
        } else {
            if ( player.speed > 0 ) {
                player.speed -= player.velocity;
            } else {
                player.speed = 0;
            }
        }
        
        // Checks spinning status
        if ( true == keys[32] && player.speed > 10 ) {
            player.spinning = true;
        } else {
            player.spinning = false;
        }
        
        // Checking mouse click for movement and rotation
        if ( mouseclick ) {
            
            // If spacebar is pressed, do the default rotation
            if ( true == keys[32] ) {
                playerRotation();
            } else {
                // Do a conditional rotation (try to make it organic and nice!)
                
                // Decreases speed
                player.speed -= player.velocity;
                
                // Define Arc Tangent
                var arcs:Float = Math.atan2(
                    player.parent.mouseY - player.y, 
                    player.parent.mouseX - player.x
                );
                
                // Calculating the angle
                var angles:Float = arcs * ( 180 / Math.PI );
                
                // Calibrates angle (?)
                if ( angles < 0 ) angles = ( 360 - ( 180 - angles ) ) + 180;
                
                // Try to provide a smooth transition between rotation stages
                if ( player.speed < 5 ) {
                    // Change rotation
                    playerRotation();
                    
                    if ( Math.floor( player.rotation ) == Math.floor( angles ) ) {
                        // Sets rotation as angle
                        player.rotation = angles;
                        
                        // Resets player speed
                        player.speed = 0;
                    } else {
                        player.rotation = angles;
                    }
                } else {
                    // Player rotation is angles
                    player.rotation += player.speed;
                }
            }
            
            // Follow the direction of the mouse! (WORK MORE LATER!)
            if ( 
                player.x + player.width / 2 <= arena.width - 64 
                && player.x - player.width / 2 >= 64
            ) {
                player.x += ( player.parent.mouseX - player.x ) * 0.05;
            } else if ( player.x + player.width / 2 >= arena.width - 64 ) {
                player.x = arena.width - 64 - player.width / 2;
            } else {
                player.x = 64 + player.width / 2;
            }
            
            if ( 
                player.y + player.height / 2 <= arena.height - 64 
                && player.y - player.height / 2 >= 64
            ) {
                player.y += ( player.parent.mouseY - player.y ) * 0.05;
            } else if ( player.y + player.height / 2 >= arena.height - 64 ) {
                player.y = arena.height - 64 - player.height / 2;
            } else {
                player.y = 64 + player.height / 2;
            }
            
        } else {
            if ( mouseleave && true != keys[32] ) {
                if ( mouseleavetime > 0 && player.speed > 0 ) {
                    mouseleavetime -= 1;
                } else {
                    player.speed = 0;
                    mouseleave = false;
                }
            } else {
                mouseleave = false;
                mouseleavetime = 0;
                playerRotation();
            }
        }
    }
    
    /**
     * Just rotates player.
     */
    public function playerRotation():Void 
    {
        // Rotates player
        if ( player.speed > 0 ) player.rotation += player.speed;
        
        // Checks if rotation is > than 360
        if ( player.rotation > 360 ) player.rotation -= 360;
    }
    
    /**
     * Checks ammo status and bleeding status.
     */
    public function playerHealthAmmo():Void 
    {
    }
    
    /**
     * Fires a projectile if conditions are met.
     */
    public function playerFire():Void 
    {
        if (
            player.spinning 
            && player.speed > 15
        ) {
            
        }
    }
}