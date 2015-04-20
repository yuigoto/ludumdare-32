package br.com.sixsided.ld32.ui;

import openfl.Assets;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

/**
 * ...
 * @author Fabio Yuiti Goto
 */
class ButtonMini extends Sprite
{
    public var body:Shape;
    public var over:Shape;
    public var data:String;
    public var text:TextField;
    
    /**
     * Main constructor.
     * 
     * @param textData Button text
     */
    public function new( textData:String ) 
    {
        // Calling super constructor
        super();
        
        // Define text var
        data = textData;
        
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
        
        // Draw first shape
        body = new Shape();
        body.graphics.beginFill( 0xef2929, 1 );
        body.graphics.drawRect( 0, 0, 120, 40 );
        body.graphics.endFill();
        
        // Text and format
        text = new TextField();
        text.defaultTextFormat = new TextFormat(
            Assets.getFont( "fonts/dekar.otf" ).fontName, 
            16,  
            0xffffff, 
            true
        );
        text.text = data;
        text.selectable = false;
        text.multiline = false;
        text.type = TextFieldType.DYNAMIC;
        text.autoSize = TextFieldAutoSize.LEFT;
        text.x = body.width / 2 - text.width / 2;
        text.y = body.height / 2 - text.height / 2;
        
        // Draw overlay (mouse over) shape
        over = new Shape();
        over.graphics.beginFill( 0xffffff, 1 );
        over.graphics.drawRect( 0, 0, 120, 40 );
        over.graphics.endFill();
        over.alpha = 0;
        
        // Add'em all
        this.addChild( body );
        this.addChild( text );
        this.addChild( over );
        
        addEventListener( MouseEvent.MOUSE_OVER, mouseOv );
        addEventListener( MouseEvent.MOUSE_OUT, mouseOu );
        addEventListener( MouseEvent.MOUSE_DOWN, mouseDn );
        addEventListener( MouseEvent.MOUSE_UP, mouseUp );
    }
    
    /**
     * Mouse up event handler.
     */
    public function mouseUp( e:MouseEvent ):Void 
    {
        over.alpha = 0.4;
    }
    
    /**
     * Mouse down event handler.
     */
    public function mouseDn( e:MouseEvent ):Void 
    {
        over.alpha = 0.8;
    }
    
    /**
     * Mouse over event handler.
     */
    public function mouseOv( e:MouseEvent ):Void 
    {
        over.alpha = 0.4;
    }
    
    /**
     * Mouse down  event handler.
     */
    public function mouseOu( e:MouseEvent ):Void 
    {
        over.alpha = 0;
    }
}