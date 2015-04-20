package br.com.sixsided.ld32.scenes;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * LD32 :: An Unconventional Weapon :: "Berry, The Last Straw"
 * ============================================================
 * 
 * GAME OVER SCREEN
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class SceneOver extends Sprite 
{
    /**
     * Handle for background.
     */
    private var back:BitmapData;
    
    /**
     * Best score counter.
     */
    private var currentScore:Int = 0;
    
    /**
     * Best time counter.
     */
    private var currentTime:Int = 0;
    
    /**
     * Current score textfield.
     */
    private var scorestext:TextField;
    
    /**
     * Current time textfield.
     */
    private var timestext:TextField;
    
    /**
     * Game start
     */
    public var gameinit:Bool = false;
    
    
    /**
     * Main constructor.
     */
    public function new( scores:Int = 0, times:Int = 0 ) 
    {
        // Calling super constructor
        super();
        
        currentScore = scores;
        currentTime = times;
        
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
        
        back = Assets.getBitmapData( "image/gameover.png" );
        
        graphics.beginBitmapFill( back, new Matrix( 1, 0 ), false, false );
        graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
        graphics.endFill();
        
        scorestext = new TextField();
        scorestext.defaultTextFormat = new TextFormat(
            Assets.getFont( "fonts/dekar.otf" ).fontName, 
            24, 
            true
        );
        scorestext.text = "YOUR SCORE: " + currentScore;
        scorestext.selectable = false;
        scorestext.multiline = false;
        scorestext.autoSize = TextFieldAutoSize.LEFT;
        
        scorestext.x = 20;
        scorestext.y = stage.stageHeight - 100;
        
        addChild( scorestext );
        
        timestext = new TextField();
        timestext.defaultTextFormat = new TextFormat(
            Assets.getFont( "fonts/dekar.otf" ).fontName, 
            24, 
            true
        );
        timestext.text = "YOUR TIME: " + currentTime + " seconds";
        timestext.selectable = false;
        timestext.multiline = false;
        timestext.autoSize = TextFieldAutoSize.LEFT;
        
        timestext.x = 20;
        timestext.y = stage.stageHeight - 140;
        
        addChild( timestext );
        
        stage.addEventListener( KeyboardEvent.KEY_DOWN, keydown );
        stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseclick );
    }
    
    public function mouseclick( e:MouseEvent ):Void 
    {
        gameinit = true;
        
        stage.removeEventListener( KeyboardEvent.KEY_DOWN, keydown );
        stage.removeEventListener( MouseEvent.MOUSE_DOWN, mouseclick );
    }
    
    public function keydown( e:KeyboardEvent ):Void 
    {
        if ( e.keyCode == 32 ) {
            gameinit = true;
            
            stage.removeEventListener( KeyboardEvent.KEY_DOWN, keydown );
            stage.removeEventListener( MouseEvent.MOUSE_DOWN, mouseclick );
        }
    }
}