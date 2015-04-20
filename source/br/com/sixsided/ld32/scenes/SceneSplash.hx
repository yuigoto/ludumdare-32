package br.com.sixsided.ld32.scenes;

// Importing packages
import motion.Actuate;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * LD32 :: An Unconventional Weapon :: "Berry, The Last Straw"
 * ============================================================
 * 
 * SPLASH SCREEN
 * 
 * Shows my logo...and stuff. :3
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class SceneSplash extends Sprite
{
    /**
     * Indicates that logo is complete. :3
     */
    public var complete:Bool = false;
    
    /**
     * Handle for logo.
     */
    private var logo:Sixsided;
    
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Calling super constructor
        super();
        
        // Certifying that stage is set
        if ( null != stage ) {
            init( null );
        } else {
            addEventListener( Event.ADDED_TO_STAGE, init );
        }
    }
    
    /**
     * Initial event, sets stage.
     * 
     * @param e
     */
    public function init( e:Event ):Void 
    {
        // Removes event listener
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Initializes logo, adds to stage
        logo = new Sixsided( true );
        
        // Adding
        addChild( logo );
        
        // Adds event listener to this
        this.addEventListener( Event.ENTER_FRAME, logoFrames );
    }
    
    /**
     * Checks whether the logo has finished animating or not.
     * 
     * @param e
     */
    public function logoFrames( e:Event ):Void 
    {
        // Checks if animation is complete...or not
        if ( logo.iscomplete ) {
            // Change logo iscomplete, just to prevent from firing again
            logo.iscomplete = false;
            
            // Execute actuate
            Actuate.tween(
                logo, 
                1, 
                {
                    alpha: 0
                }
            ).delay( 2 ).onComplete(
                function() 
                {
                    // Removes this event listener
                    this.removeEventListener( Event.ENTER_FRAME, logoFrames );
                    
                    // Removes logo
                    removeChild( logo );
                    
                    // Defines this as complete
                    complete = true;
                }
            );
        }
        
        // Center
        logo.x = stage.stageWidth / 2 - logo.width / 2;
        logo.y = stage.stageHeight / 2 - logo.height / 2;
    }
}