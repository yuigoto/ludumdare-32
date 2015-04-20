package br.com.sixsided.ld32.object;

// Importing packages
import br.com.sixsided.ld32.libs.Zero;
import openfl.Assets;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author Fabio Yuiti Goto
 */
class CircBars extends Sprite {
    /**
     * Title.
     */
    private var title:String = "";
     
    /**
     * Radian value.
     */
    private var radian:Float = Math.PI / 180;
    
    /**
     * Thickness of the bar.
     */
    private var weight:Float = 20;
    
    /**
     * Radius of the circle.
     */
    private var radius:Float;
    
    /**
     * Color of the bar.
     */
    private var colour:Int;
    
    /**
     * Maximum value.
     */
    private var full:Float;
    
    /**
     * Current value.
     */
    private var curr:Float;
    
    /**
     * Bar Shape.
     */
    private var bars:Shape;
    
    /**
     * Text Field.
     */
    private var text:TextField;
    
    /**
     * Text Field Format.
     */
    private var look:TextFormat;
    
    /**
     * Main constructor.
     * 
     * @param rad Radius of the circular part
     * @param quantity Maximum value
     * @param tint Color of the bar
     */
    public function new( name:String = "", rad:Float = 100, quantity:Float = 100, tint:Int = 0 ) 
    {
        super();
        
        if ( "" != name ) {
            title = name;
        }
        
        if ( 0 == rad ) {
            radius = 100;
        } else {
            radius = rad;
        }
        
        if ( 0 == quantity ) {
            full = 100;
        } else {
            full = quantity;
        }
        curr = full;
        
        colour = tint;
        
        // Initializing
        bars = new Shape();
        
        // Add to stage
        addChild( bars );
        
        // Initialize text
        text = new TextField();
        text.defaultTextFormat = new TextFormat(
            Assets.getFont( "fonts/dekar.otf" ).fontName, 
            14, 
            0xffffff, 
            true
        );
        text.autoSize = TextFieldAutoSize.LEFT;
        text.selectable = false;
        text.multiline = false;
        if ( "" != title ) {
            text.text = title + ": " + Math.floor( curr ) + " - " + Math.floor( full );
        } else {
            text.text = Math.floor( curr ) + " - " + Math.floor( full );
        }
        text.x = radius + 5;
        text.y = 0;
        addChild( text );
        
        // Drawing
        drawBars();
    }
    
    /**
     * Draws the circular bar.
     */
    private function drawBars():Void 
    {
        // Point handler
        var PT:Point = Zero.defineVertex( 270, radius, radius, radius );
        
        // Checking percentage
        var IN:Float = 270 - ( 180 * ( curr / full ) );
        
        // Flag
        var i:Int = 270;
        
        // Update text
        if ( "" != title ) {
            text.text = title + ": " + Math.floor( curr ) + " | " + Math.floor( full );
        } else {
            text.text = Math.floor( curr ) + " | " + Math.floor( full );
        }
        
        bars.graphics.clear();
        
        bars.graphics.beginFill( colour, 1 );
        
        bars.graphics.drawRect( radius, 0, 160, weight );
        
        bars.graphics.moveTo( PT.x, PT.y );
        
        while ( i >= IN ) {
            PT = Zero.defineVertex( i, radius, radius, radius );
            bars.graphics.lineTo( PT.x, PT.y );
            i -= 1;
        }
        
        PT = Zero.defineVertex( IN, radius - weight, radius, radius );
        bars.graphics.lineTo( PT.x, PT.y );
        
        while ( i <= 270 ) {
            PT = Zero.defineVertex( i, radius - weight, radius, radius );
            bars.graphics.lineTo( PT.x, PT.y );
            i += 1;
        }
        
        PT = Zero.defineVertex( 270, radius, radius, radius );
        bars.graphics.lineTo( PT.x, PT.y );
    }
    
    /**
     * Updates the status of the bar.
     */
    public function update( vals:Float ):Void 
    {
        // Reduces from current
        curr = vals;
        
        // Draw the bar
        drawBars();
    }
}