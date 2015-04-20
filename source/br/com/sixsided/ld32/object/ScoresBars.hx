package br.com.sixsided.ld32.object;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author Fabio Yuiti Goto
 */
class ScoresBars extends Sprite
{
    /**
     * Time value.
     */
    public var time:Int;
    
    /**
     * Score value.
     */
    public var scores:Int;
    
    /**
     * TextField
     */
    public var scoresText:TextField;
    
    public function new( vals:Int = 0, clock:Int = 0 ) 
    {
        super();
        
        scores = vals;
        time = clock;
        
        graphics.beginFill( 0xffffff, 1 );
        graphics.drawRect( 0, 0, 540, 40 );
        graphics.endFill();
        
        scoresText = new TextField();
        scoresText.defaultTextFormat = new TextFormat(
            Assets.getFont( "fonts/dekar.otf" ).fontName, 
            16, 
            0x000000, 
            true
        );
        scoresText.text = "SCORE: " + scores + "\nTIME: " + time + "''";
        scoresText.multiline = true;
        scoresText.selectable = false;
        scoresText.autoSize = TextFieldAutoSize.LEFT;
        scoresText.x = 10;
        scoresText.y = this.height / 2 - scoresText.height / 2;
        addChild( scoresText );
    }
    
    public function update( vals:Int, clock:Int ):Void 
    {
        scores = vals;
        time = clock;
        scoresText.text = "SCORE: " + scores + "\nTIME: " + time + "''";
    }
}