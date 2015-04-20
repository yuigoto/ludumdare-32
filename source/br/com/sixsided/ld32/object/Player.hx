package br.com.sixsided.ld32.object;

// Importing packages
import openfl.Assets;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.events.Event;
import openfl.geom.Rectangle;

/**
 * LD32 :: An Unconventional Weapon :: "Berry, The Last Straw"
 * ============================================================
 * 
 * PLAYER OBJECT (FINAL)
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class Player extends Sprite
{
    /* VARIABLES (PUBLIC)
     * ============================================================ */
    
    /**
     * Player is dead?
     */
    public var isdead:Bool;
    
    /**
     * Collision area for player.
     */
    public var body:Shape;
    
    /**
     * Weapon object for the game, because of shots and stuff.
     */
    public var arms:Shape;
    
    /**
     * Weapon rotation speed.
     */
    public var armsSpin:Float = 0;
     
    /**
     * Direction the player is facing.
     * 
     * - 0: top;
     * - 1: right (default, same as rotation);
     * - 2: bottom;
     * - 3: left;
     */
    public var isfacing:Int = 1;
    
    /**
     * Player is moving status.
     */
    public var ismoving:Bool = false;
    
    /**
     * Player is spinning status.
     */
    public var spinning:Bool = false;
    
    /**
     * Player has some time after hit.
     */
    public var hitsTime:Int = 25;
    
    /**
     * Player health.
     */
    public var hp:Float = 200;
    
    /**
     * Player health regeneration time.
     */
    public var hpTime:Int = 5;
    
    /**
     * Player ammunition.
     */
    public var ammo:Int = 200;
    
    /**
     * Ammo is full? If not, the player bleeds.
     */
    public var ammoFull:Bool = true;
    
    /**
     * Player ammunition recovery time.
     */
    public var ammoTime:Int = 2;
    
    /**
     * Player bleeding status.
     */
    public var bleeding:Bool = false;
    
    /**
     * Player blood drop interval.
     */
    public var bleedingTime:Int = 20;
    
    
    
    /* VARIABLES (PRIVATE)
     * ============================================================ */
    
    /**
     * Player tilesheet.
     * 
     *  0 ~  3: Up
     *  4 ~  7: Right
     *  8 ~ 11: Down
     * 12 ~ 15: Left
     * 16 ~ 19: Spin
     * 20 ~ 23: Death animation
     */
    private var tile:Tilesheet;
    
    /**
     * Current tile to show.
     */
    private var tileCurr:Int = 4;
    
    /**
     * Tile interval.
     */
    private var tileTime:Int = 3;
    
    
     
    /* CONSTRUCTOR + DESTRUCTOR
     * ============================================================ */
    
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Super constructor!
        super();
        
        // Certifying that stage is set
        if ( null != stage ) {
            init( null );
        } else {
            addEventListener( Event.ADDED_TO_STAGE, init );
        }
    }
    
    /**
     * Destructor method.
     */
    public function destruct():Void 
    {
        // Remove this event listener
        removeEventListener( Event.ENTER_FRAME, animates );
        
        // Remove this object
        this.parent.removeChild( this );
    }
    
    
    
    /* EVENT HANDLERS
     * ============================================================ */
    
    /**
     * Initial event listener, fires only once.
     * 
     * @param e
     */
    private function init( e:Event ):Void 
    {
        // Removes this event
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Debug message
        trace( 'Player Init!' );
        
        // Drawing bounding box
        bounding();
        
        // Initializes tilesheet
        tile = new Tilesheet( Assets.getBitmapData( "image/sprite-player.png" ) );
        
        // Defines all the tiles ( 64 X 112 )
        for ( row in 0...6 ) {
            for ( col in 0...4 ) {
                tile.addTileRect(
                    new Rectangle( col * 64, row * 112, 64, 112 ) 
                );
            }
        }
        
        // Desenhando primeiro tile
        tile.drawTiles( graphics, [ -32, -96, tileCurr ] );
        
        // Drawing body collision zone
        body = new Shape();
        body.graphics.beginFill( 0x729fcf, 0 );
        body.graphics.drawEllipse( -28, -80, 56, 72 );
        body.graphics.endFill();
        
        // Adds to sprite
        addChild( body );
        
        // Player weapon
        arms = new Shape();
        arms.graphics.beginFill( 0xedd400, 0 );
        arms.graphics.drawEllipse( -16, -8, 32, 16 );
        arms.graphics.endFill();
        arms.graphics.beginFill( 0xffffff, 0 );
        arms.graphics.drawEllipse( 12, -2, 4, 4 );
        arms.graphics.endFill();
        
        // Positioning
        arms.y -= 32;
        
        // Adds to sprite
        addChild( arms );
        
        // Add event listener for animation
        addEventListener( Event.ENTER_FRAME, animates );
    }
    
    /**
     * Handles animation.
     */
    public function animates( e:Event ):Void 
    {
        // Changes frame, only, is timer is 0
        if ( tileTime == 0 ) {
            if ( isdead ) {
                if ( tileCurr < 20 || tileCurr > 23 ) {
                    tileCurr = 20;
                } else {
                    tileCurr += 1;
                }
                
                // Destruct the mob
                if ( tileCurr > 23 ) {
                    // Removes mob
                    destruct();
                    
                    // Returns, to prevent showing tile
                    return;
                }
            } else {
                // If player is spinning, plays the spining animation
                if ( spinning ) {
                    if ( tileCurr < 16 || tileCurr > 19 ) {
                        tileCurr = 16;
                    } else {
                        tileCurr += 1;
                    }
                    if ( tileCurr > 19 ) tileCurr = 16;
                } else {
                    // Is player is moving
                    if ( ismoving ) {
                        // Verifies the player direction
                        switch ( isfacing ) {
                            case 1:
                                // Right
                                if ( tileCurr < 4 || tileCurr > 7 ) {
                                    tileCurr = 4;
                                } else {
                                    tileCurr += 1;
                                }
                                if ( tileCurr > 7 ) tileCurr = 4;
                            case 2:
                                // Bottom
                                if ( tileCurr < 8 || tileCurr > 11 ) {
                                    tileCurr = 8;
                                } else {
                                    tileCurr += 1;
                                }
                                if ( tileCurr > 11 ) tileCurr = 8;
                            case 3:
                                // Left
                                if ( tileCurr < 12 || tileCurr > 15 ) {
                                    tileCurr = 12;
                                } else {
                                    tileCurr += 1;
                                }
                                if ( tileCurr > 15 ) tileCurr = 12;
                            default:
                                // Top
                                if ( tileCurr > 3 ) {
                                    tileCurr = 0;
                                } else {
                                    tileCurr += 1;
                                }
                                if ( tileCurr > 3 ) tileCurr = 0;
                        }
                    } else {
                        // Verifies the player direction
                        switch ( isfacing ) {
                            case 1:
                                // Right
                                tileCurr = 4;
                            case 2:
                                // Bottom
                                tileCurr = 8;
                            case 3:
                                // Left
                                tileCurr = 12;
                            default:
                                // Top
                                tileCurr = 0;
                        }
                    }
                }
            }
            
            // Resets time
            tileTime = 3;
        } else {
            // Decreases time
            tileTime -= 1;
        }
        
        // Draws the current frame
        if ( tileCurr < 24 ) {
            // Clears graphics
            graphics.clear();
            
            // Draws bounding box.
            bounding();
            #if html5
                tile.drawTiles( graphics, [ 0, 0, tileCurr ] );
            #else
                tile.drawTiles( graphics, [ -32, -96, tileCurr ] );
            #end
        }
    }
    
    
    
    /* METHODS
     * ============================================================ */
    
    /**
     * Draws the player's bounding box.
     */
    private function bounding():Void 
    {
        // Drawing bounding box
        graphics.beginFill( 0xedd400, 0 );
        graphics.drawRect( -32, -96, 64, 112 );
        graphics.endFill();
    }
}