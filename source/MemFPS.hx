package;

// Importing packages
import haxe.Timer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * MemFPS
 * ============================================================
 * 
 * Simple FPS and memory (peak and current) monitor, from the article 
 * "Displaying FPS and Memory usage using OpenFL", by Kirill Poletaev.
 * 
 * More info on:
 * http://haxecoder.com/post.php?id=24
 * 
 * @author Fabio Yuiti Goto
 * @version 0.0.1.0
 */
class MemFPS extends Sprite
{
    /**
     * Font to be used with the monitor.
     */
    private var FONT:Font = null;
    
    /**
     * TextField handle.
     */
    private var FIELDS:TextField;
    
    /**
     * Formatação para o campo.
     */
    private var FORMAT:TextFormat;
    
    /**
     * Frame counter (?).
     */
    private var FRAMES:Array<Float> = [];
    
    /**
     * Memory peak indicator.
     */
    private var MEMORY:Float = 0;
    
    /**
     * Main custructor.
     * 
     * @param font A Font type object (optional)
     */
    public function new( font:Font = null ) 
    {
        // Calling super constructor
        super();
        
        // Defines font
        if ( null != font ) {
            FONT = font;
        }
        
        // Added to stage event
        if ( null != stage ) {
            init( null );
        } else {
            // Adds init as event listener if stage not set (?)
            addEventListener( Event.ADDED_TO_STAGE, init );
        }
    }
    
    /**
     * Main method.
     * 
     * @param e Event
     */
    private function init( e:Event ):Void 
    {
        // Remove event listener
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Drawing a background
        graphics.beginFill( 0x5a6257, 0.75 );
        graphics.drawRect( 0, 0, 100, 60 );
        graphics.endFill();
        
        // Font definition
        #if html5
            var usedFont = "_sans";
        #else
            var usedFont = ( null != FONT ) ? FONT.fontName : "_sans";
        #end
        
        // Define TextField and TextFormat
        FIELDS = new TextField();
        FORMAT = new TextFormat(
            usedFont, 
            12, 
            0xffffff
        );
        
        // Sets default text format, default text and properties
        FIELDS.defaultTextFormat = FORMAT;
        FIELDS.selectable = false;
        FIELDS.multiline = true;
        FIELDS.text = "FPS: 0\nMEM: 0\nPEAK:0";
        FIELDS.x = 5;
        FIELDS.y = 5;
        
        // Add to stage
        addChild( FIELDS );
        
        // Event listener
        addEventListener( Event.ENTER_FRAME, memoryEvents );
    }
    
    /**
     * Monitors FPS and memory use.
     * 
     * @param e
     */
    private function memoryEvents( e:Event ):Void 
    {
        // Current timestamp
        var time = Timer.stamp();
        
        // Adds to array
        FRAMES.push( time );
        
        // Removes first element from array if less than time - 1
        while ( FRAMES[0] < time - 1 ) {
            FRAMES.shift();
        }
        
        // Memory use, in MB
        var memy:Float = Math.round( System.totalMemory / 1024 / 1024 * 100 ) / 100;
        
        // Compare peak
        if ( memy > MEMORY ) MEMORY = memy;
        
        // Updating TextField
        FIELDS.text = "FPS: " + FRAMES.length + "\nMEM: " + memy + "\nPEAK: " + MEMORY;
    }
}