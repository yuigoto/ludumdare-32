package br.com.sixsided.ld32.object;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * LD32 :: An Unconventional Weapon :: "Berry, The Last Straw"
 * ============================================================
 * 
 * RING/ARENA OBJECT (FINAL?)
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class Ring extends Sprite 
{
    /* VARIABLES (PUBLIC)
     * ============================================================ */
    
    /**
     * View of the arena.
     */
    public var gridView:Sprite;
    
    
    
    /* VARIABLES (PRIVATE)
     * ============================================================ */
    
    /**
     * Base tile size.
     */
    public var tileSize = 64;
    
    /**
     * Tile mapping for the arena.
     */
    private var tileGrid:Array<Array<Int>> = [
        [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ], 
        [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
    ];
    
    
    
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
        trace( 'Ring Init!' );
        
        // Drawing arena
        for ( row in 0...tileGrid.length ) {
            for ( col in 0...tileGrid[row].length ) {
                if ( tileGrid[row][col] == 1 ) {
                    graphics.beginFill( 0xce5c00, 1 );
                    graphics.drawRect(
                        col * tileSize, 
                        row * tileSize, 
                        tileSize, 
                        tileSize
                    );
                } else {
                    graphics.beginFill( 0x888a85, 1 );
                    graphics.drawRect(
                        col * tileSize, 
                        row * tileSize, 
                        tileSize, 
                        tileSize
                    );
                }
            }
        }
        graphics.endFill();
        
        var test:BitmapData = Assets.getBitmapData( "image/ring.png" );
        graphics.beginBitmapFill( test );
        graphics.drawRect( 0, 0, 1280, 1280 );
        graphics.endFill();
    }
}