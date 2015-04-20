package br.com.sixsided.ld32.object;

// Importing packages
import motion.Actuate;
import openfl.Assets;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import openfl.media.SoundTransform;

/**
 * LD32 :: An Unconventional Weapon :: "Berry, The Last Straw"
 * ============================================================
 * 
 * PROJECTILE OBJECT (FINAL)
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class Projectile extends Sprite 
{
    /* VARIABLES (PUBLIC)
     * ============================================================ */
    
    /**
     * Collision area for projectile.
     */
    public var body:Shape;
    
    
    
    /* VARIABLES (PRIVATE)
     * ============================================================ */
    
    /**
     * Projectile tilesheet.
     */
    private var tile:Tilesheet;
    
    /**
     * Current tile to show.
     */
    private var tileCurr:Int = 0;
    
    /**
     * Tile interval.
     */
    private var tileTime:Int = 2;
    
    /**
     * Shot sound.
     */
    private var shot:Sound;
    
    
    
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
        
        // Drawing bounding box
        bounding();
        
        // Initializes tilesheet
        tile = new Tilesheet( Assets.getBitmapData( "image/sprite-shot.png" ) );
        
        // Defines all the tiles ( 64 X 112 )
        for ( row in 0...3 ) {
            tile.addTileRect(
                new Rectangle( 0, row * 8, 16, 8 ) 
            );
        }
        
        // Desenhando primeiro tile
        tile.drawTiles( graphics, [ -8, -4, tileCurr ] );
        
        // Drawing body collision zone
        body = new Shape();
        body.graphics.beginFill( 0x729fcf, 0 );
        body.graphics.drawEllipse( -8, -4, 16, 8 );
        body.graphics.endFill();
        
        // Adds to sprite
        addChild( body );
        
        // Plays the sound
        shot = Assets.getSound( "sound/shot.wav" );
        shot.play( 0, 0, new SoundTransform( 0.05, 0 ) );
        
        // Add event listener for shot
        shot.addEventListener( Event.SOUND_COMPLETE, soundEnded );
        
        // Add event listener for animation
        // addEventListener( Event.ENTER_FRAME, animates );
    }
    
    /**
     * Handles animation.
     */
    public function animates( e:Event ):Void 
    {
        // Clears graphics
        graphics.clear();
        
        // Draws bounding box.
        bounding();
        
        // Changes frame, only, is timer is 0
        if ( tileTime == 0 ) {
            // Define current frame
            if ( tileCurr > 2 ) {
                tileCurr = 0;
            } else {
                tileCurr += 1;
            }
            if ( tileCurr > 2 ) tileCurr = 0;
            
            // Resets time
            tileTime = 2;
        } else {
            // Decreases time
            tileTime -= 1;
        }
        
        // Draws the current frame
        #if html5
            tile.drawTiles( graphics, [ 0, 0, tileCurr ] );
        #else
            tile.drawTiles( graphics, [ -8, -4, tileCurr ] );
        #end
    }
    
    /**
     * Handles sound complete.
     */
    public function soundEnded( e:Event ):Void 
    {
        // Deletes sound
        e.currentTarget.close();
    }
    
    
    
    /* METHODS
     * ============================================================ */
    
    /**
     * Draws the player's bounding box.
     */
    private function bounding():Void 
    {
        // Drawing bounding box
        graphics.beginFill( 0xedd400, 0);
        graphics.drawRect( -8, -4, 16, 8 );
        graphics.endFill();
    }
}