package br.com.sixsided.ld32;

// Importing packages
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * LD32 :: A "Fruity" Shooter
 * ============================================================
 * 
 * My entry for LD#32.
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class Main extends Sprite {
    
    /**
     * Main constructor.
     */
	public function new () {
        // Calling super constructor
		super ();
        
        // Checks if stage was initialized
        if ( null != stage ) {
            init( null );
        } else {
            addEventListener( Event.ADDED_TO_STAGE, init );
        }
	}
    
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
        trace( 'Application initialized!' );
        
        // Insert test object/main
        var test:MainTest = new MainTest();
        
        addChild( test );
        
        // MemFPS
        var mems:MemFPS = new MemFPS();
        addChild( mems );
    }
}