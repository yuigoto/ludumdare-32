package br.com.sixsided.ld32.object;

// Importing packages
import br.com.sixsided.ld32.libs.Zero;
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
 * GRAPE MOBS
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class MobsGrapes extends Mobs  
{
    /* CONSTRUCTOR + DESTRUCTOR
     * ============================================================ */
    
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Super constructor
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
        
        // Inicializa variáveis
        hp = Zero.randomNumber( 5, 8 );
        attack = Zero.randomNumber( 2, 4 );
        speed = Zero.randomNumber( 10, 14 ) * 0.25; 
        
        // Drawing bounding box
        bounding();
        
        // Initializes tilesheet
        tile = new Tilesheet( Assets.getBitmapData( "image/sprite-grapes.png" ) );
        
        // Defines all the tiles ( 64 X 112 )
        for ( row in 0...5 ) {
            for ( col in 0...4 ) {
                tile.addTileRect(
                    new Rectangle( col * 64, row * 64, 64, 64 ) 
                );
            }
        }
        
        // Initializing collision mask
        body = new Shape();
        
        // Drawing body
        body.graphics.beginFill( 0xef2929, 0 );
        body.graphics.drawCircle( 0, -16, 20 );
        body.graphics.endFill();
        
        // Adds body
        addChild( body );
        
        // Desenhando primeiro tile
        tile.drawTiles( graphics, [ -32, -48, tileCurr ] );
        
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
            // If player is spinning, plays the spining animation
            if ( isdead ) {
                if ( tileCurr < 16 || tileCurr > 19 ) {
                    tileCurr = 16;
                } else {
                    tileCurr += 1;
                }
                
                // Destruct the mob
                if ( tileCurr > 19 ) {
                    // Removes mob
                    destruct();
                    
                    // Returns, to prevent showing tile
                    return;
                }
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
            
            // Resets time
            tileTime = 3;
        } else {
            // Decreases time
            tileTime -= 1;
        }
        
        // Draws the current frame
        if ( tileCurr < 20 ) {
            // Clears graphics
            graphics.clear();
            
            // Draws bounding box.
            bounding();
            
            // Draws
            #if html5
                tile.drawTiles( graphics, [ 0, 0, tileCurr ] );
            #else
                tile.drawTiles( graphics, [ -32, -48, tileCurr ] );
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
        graphics.beginFill( 0xedd400, 0.0 );
        graphics.drawRect( -32, -48, 64, 64 );
        graphics.endFill();
    }
}