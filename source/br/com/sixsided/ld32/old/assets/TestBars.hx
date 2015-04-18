package br.com.sixsided.ld32.old.assets;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * TEST HP BAR
 * @author Fabio Yuiti Goto
 */
class TestBars extends Sprite 
{
    /**
     * Body
     */
    public var body:Sprite;
    
    /**
     * Text
     */
    public var text:TextField;
    
    /**
     * Format
     */
    public var look:TextFormat;
    
    /**
     * Full value.
     */
    public var full:Float;
    
    /**
     * Current value.
     * 
     * @param max
     */
    public var curr:Float;
    
    public var barName:String;
    
    public var barColor:Int;
    
    /**
     * :)
     */
    public function new( name:String = "", max:Float = 100, color:Int = null ) 
    {
        super();
        
        if ( null == name || '' == name ) {
            barName = "";
        } else {
            barName = name;
        }
        
        if ( 0 == max ) {
            full = 100;
        } else {
            full = max;
        }
        
        if ( null == color ) {
            barColor = 0x204a85;
        } else {
            barColor = color;
        }
        
        body = new Sprite();
        body.graphics.beginFill( 0xedd400 );
        body.graphics.drawRect( 0, 0, 100, 10 );
        body.graphics.endFill();
        addChild(body);
        
        text = new TextField();
        look = new TextFormat( "_sans", 10, 0x000000, true );
        text.defaultTextFormat = look;
        text.text = ( barName != '' ) ? barName : "";
        
        addChild( text );
        
        addEventListener( Event.ENTER_FRAME, barsUpdate );
    }
    
    public function barsUpdate( e:Event ) {
        // New value
        var size:Float = curr / full;
        body.width = 100 * size;
        text.text = ( barName != '' ) ? barName + ": " + curr + "/" + full : curr + "/" + full;
    }
}