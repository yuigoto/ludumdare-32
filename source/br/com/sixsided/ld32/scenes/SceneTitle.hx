package br.com.sixsided.ld32.scenes;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * LD32 :: An Unconventional Weapon :: "Berry, The Last Straw"
 * ============================================================
 * 
 * TITLE SCREEN
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class SceneTitle extends Sprite 
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
     * Current score textfield.
     */
    private var scorestext:TextField;
    
    /**
     * Click to start
     */
    private var starts:TextField;
    
    /**
     * Game start
     */
    public var gameinit:Bool = false;
    
    
    /**
     * Main constructor.
     */
    public function new( scores:Int = 0 ) 
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
        
        back = Assets.getBitmapData( "image/title.png" );
        
        graphics.beginBitmapFill( back, new Matrix( 1, 0 ), false, false );
        graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
        graphics.endFill();
        
        /*
        scorestext = new TextField();
        scorestext.defaultTextFormat = new TextFormat(
            Assets.getFont( "fonts/dekar.otf" ).fontName, 
            24, 
            true
        );
        scorestext.text = "BEST SCORE: " + currentScore;
        scorestext.selectable = false;
        scorestext.multiline = false;
        scorestext.autoSize = TextFieldAutoSize.LEFT;
        
        scorestext.x = stage.stageWidth - scorestext.width - 12;
        scorestext.y = stage.stageHeight - 60;
        
        addChild( scorestext );
        */
        
        starts = new TextField();
        starts.defaultTextFormat = new TextFormat(
            Assets.getFont( "fonts/dekar.otf" ).fontName, 
            48, 
            0x000000, 
            true, 
            false, 
            false
        );
        starts.text = "CLICK TO START";
        starts.selectable = false;
        starts.multiline = false;
        starts.autoSize = TextFieldAutoSize.LEFT;
        starts.x = stage.stageWidth / 2 - starts.width / 2;
        starts.y = stage.stageHeight - 128;
        addChild( starts );
        
        stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseclick );
    }
    
    public function mouseclick( e:MouseEvent ):Void 
    {
        gameinit = true;
        
        stage.removeEventListener( MouseEvent.MOUSE_DOWN, mouseclick );
    }
}