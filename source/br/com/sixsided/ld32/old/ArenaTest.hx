package br.com.sixsided.ld32.old;
import br.com.sixsided.ld32.assets.PlayerTest;
import br.com.sixsided.ld32.old.assets.TestShot;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Fabio Yuiti Goto
 */
class ArenaTest extends Sprite 
{
    /**
     * Key code array.
     */
    public var keys:Array<Bool> = [];
    
    /**
     * Shot array.
     */
    public var Shot:Array<Dynamic>;
    
    /**
     * TEST player
     */
    public var player:PlayerTest;
    
    /**
     * Base tile size.
     */
    public var tileSize = 64;
    
    /**
     * Stores the tile mapping for the arena.
     */
    public var map:Array<Array<Int>> = [
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
        [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
    ];
    
    /**
     * View of the arena.
     */
    public var view:Sprite;
    
    /**
     * Initialize.
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
    
    /**
     * Main method, works like a "constructor".
     * 
     * @param e
     */
    private function init( e:Event ):Void 
    {
        // Removing event listener
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Start Shot array
        Shot = new Array();
        
        // Drawing arena
        for ( row in 0...map.length ) {
            for ( col in 0...map[row].length ) {
                if ( map[row][col] == 1 ) {
                    graphics.beginFill( 0xce5c00, 1 );
                    graphics.drawRect(
                        col * tileSize, 
                        row * tileSize, 
                        tileSize, 
                        tileSize
                    );
                } else {
                    graphics.beginFill( 0xce5c00, .25 );
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
        
        player = new PlayerTest();
        this.addChild( player );
        
        player.x = this.width / 2;
        player.y = this.height / 2;
        
        stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
        stage.addEventListener( KeyboardEvent.KEY_UP, keyUp );
        addEventListener( MouseEvent.MOUSE_DOWN, player.mouseDown );
        addEventListener( MouseEvent.MOUSE_UP, player.mouseUp );
        addEventListener( Event.ENTER_FRAME, framesEvents );
    }
    
    /**
     * 
     * @param e
     */
    private function framesEvents( e:Event ):Void 
    {
        playerEvents();
        
        // Handle spacebar
        if ( false != keys[32] ) {
            player.spaceDown();
        } else {
            if ( player.space ) {
                player.spaceUp();
            }
        }
        
        // MAKES camera follow player
        root.scrollRect = new Rectangle(
            player.x - stage.stageWidth / 2, 
            player.y - stage.stageHeight / 2, 
            stage.stageWidth, 
            stage.stageHeight
        );
    }
    
    
    
    private function playerEvents():Void 
    {
        if (
            player.spinning 
            && player.speed > 15
        ) {
            // Get current rotation
            var rots:Float = Math.floor( player.rotation );
            
            if ( ( randomNumber() & 12 ) < 8 && player.ammo > 0 ) {
                // Bullet
                var bull:TestShot = new TestShot();
                
                // Defines rotation
                bull.rotation = player.rotation;
                bull.x = player.x;
                bull.y = player.y;
                
                // Pushing into array
                Shot.push( bull );
                
                // Making certain that Shot has less than 200
                if ( Shot.length > 200 ) {
                    removeChild( Shot[0] );
                    Shot.shift();
                }
                
                // Add to stage
                this.addChild( bull );
                
                bull.addEventListener( Event.ENTER_FRAME, bull.fireMove );
                
                player.ammo -= 1;
            }
        }
    }
    
    public function keyDown(e:KeyboardEvent):Void 
    {
        keys[ e.keyCode ] = true;
    }
    
    public function keyUp(e:KeyboardEvent):Void 
    {
        keys[ e.keyCode ] = false;
    }
    
    public function randomNumber():Int 
    {
        return Math.floor( Math.random() * ( 2147483647 - 1 ) ) + 1;
    }
}