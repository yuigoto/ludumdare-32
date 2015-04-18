package br.com.sixsided.ld32.old;

// Importing packages
import br.com.sixsided.ld32.old.assets.PlayerTest;
import br.com.sixsided.ld32.old.assets.TestBars;
import br.com.sixsided.ld32.old.assets.TestShot;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

/**
 * LD32 :: A "Fruity" Shooter :: MainTest
 * ============================================================
 * 
 * This "MainTest" class is to avoid using the Main class and making it 
 * cluttered.
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class MainTest extends Sprite
{
    /**
     * Arena wrapper.
     */
    public var arenaWrap:Sprite;
    
    /**
     * Arena.
     */
    public var arena:BitmapData = Assets.getBitmapData( "image/dummyarena.png" );
    
    /**
     * Key code array.
     */
    public var keys:Array<Bool> = [];
    
    /**
     * Player handle.
     */
    public var plyr:PlayerTest;
    
    /**
     * Shot array.
     */
    public var Shot:Array<Dynamic>;
    
    /**
     * Health bar.
     */
    public var health:TestBars;
    
    /**
     * Ammo bar.
     */
    public var ammo:TestBars;
    
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Calling super constructor (OpenFl?)
        super();
        
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
        // Removing event listener
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Debug initial message
        trace( 'Test Class Initialized!' );
        
        // Start Shot array
        Shot = new Array();
        
        // ArenaWrap
        arenaWrap = new Sprite();
        arenaWrap.graphics.beginBitmapFill( arena );
        arenaWrap.graphics.drawRect( 0, 0, 1280, 1280 );
        arenaWrap.graphics.endFill();
        
        addChild( arenaWrap );
        
        // Test player on stage
        plyr = new PlayerTest();
        stage.addChild( plyr );
        
        plyr.x = stage.stageWidth / 2;
        plyr.y = stage.stageHeight / 2;
        
        // HEALTH BAR
        health = new TestBars( "HP", plyr.HP, 0x729fcf );
        addChild( health );
        health.curr = plyr.HP;
        health.x = 10;
        health.y = stage.stageHeight - 60;
        
        // HEALTH BAR
        ammo = new TestBars( "AMMO", plyr.ammo, 0xce5c00 );
        addChild( ammo );
        ammo.x = 10;
        ammo.y = stage.stageHeight - 20;
        
        stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
        stage.addEventListener( KeyboardEvent.KEY_UP, keyUp );
        stage.addEventListener( MouseEvent.MOUSE_DOWN, plyr.mouseDown );
        stage.addEventListener( MouseEvent.MOUSE_UP, plyr.mouseUp );
        addEventListener( Event.ENTER_FRAME, framesEvents );
    }
    
    public function keyDown(e:KeyboardEvent):Void 
    {
        keys[ e.keyCode ] = true;
    }
    
    public function keyUp(e:KeyboardEvent):Void 
    {
        keys[ e.keyCode ] = false;
    }
    
    /**
     * 
     * @param e
     */
    private function framesEvents( e:Event ):Void 
    {
        playerEvents();
        
        health.curr = plyr.HP;
        ammo.curr = plyr.ammo;
        
        // Handle spacebar
        if ( false != keys[32] ) {
            plyr.spaceDown();
        } else {
            if ( plyr.space ) {
                plyr.spaceUp();
            }
        }
        
        // MAKES camera follow player
        root.scrollRect = new Rectangle(
            plyr.x - stage.stageWidth / 2, 
            plyr.y - stage.stageHeight / 2, 
            stage.stageWidth, 
            stage.stageHeight
        );
    }
    
    
    
    private function playerEvents():Void 
    {
        if (
            plyr.spinning 
            && plyr.speed > 15
        ) {
            // Get current rotation
            var rots:Float = Math.floor( plyr.rotation );
            
            if ( ( randomNumber() & 12 ) < 8 && plyr.ammo > 0 ) {
                // Bullet
                var bull:TestShot = new TestShot();
                
                // Defines rotation
                bull.rotation = plyr.rotation;
                bull.x = plyr.x;
                bull.y = plyr.y;
                
                // Pushing into array
                Shot.push( bull );
                
                // Making certain that Shot has less than 200
                if ( Shot.length > 200 ) {
                    removeChild( Shot[0] );
                    Shot.shift();
                }
                
                // Add to stage
                addChild( bull );
                
                bull.addEventListener( Event.ENTER_FRAME, bull.fireMove );
                
                plyr.ammo -= 1;
            }
        }
        
        trace( stage.mouseX );
    }
    
    public function randomNumber():Int 
    {
        return Math.floor( Math.random() * ( 2147483647 - 1 ) ) + 1;
    }
}