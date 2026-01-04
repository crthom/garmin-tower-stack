import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
using Toybox.Math as Math;

class TowerStackView extends WatchUi.View {
    private var _scoreElement;
    private var _xPosition = 0;
    private var _previousBlocks as Array<Array> = [];
    
    var _currentWidth = 80;
    var _score = 0;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        _scoreElement = findDrawableById("score");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.clear();
        View.onUpdate(dc);
        dc.drawLine(0, 140 + (20 * _score), dc.getWidth(), 140 + (20 * _score));
        dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_BLACK);
        dc.fillRoundedRectangle(
            dc.getWidth()/2-40, // x
            120 + (20*_score),                   // y
            80,                  // width
            20,                   // height
            2                     // corner radius
        );
        for (var i = 0; i < _previousBlocks.size(); i++) {
            var block = _previousBlocks[i];
            dc.fillRoundedRectangle(
                block[0], // x
                120 + ((_score - (block[1] + 1)) * 20),                   // y
                block[2],                  // width
                20,                   // height
                2                     // corner radius
            );
        }
        // Set color
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);

        // Draw rectangle
        dc.fillRoundedRectangle(
            _xPosition, // x
            100,                   // y
            _currentWidth,                  // width
            20,                   // height
            2                     // corner radius
        );
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function setXPosition(x as Number) as Void {
        _xPosition = x;
        WatchUi.requestUpdate();
    }

    function updateScore() as Void {
        _score += 1;
        _scoreElement.setText(_score.toString());
        WatchUi.requestUpdate();
    }

    function newBlock(left as Number, width as Number) as Void {
        _previousBlocks.add([left, _score, width]);
        System.println(_previousBlocks.toString());
        _xPosition = 0;
        WatchUi.requestUpdate();
    }
}
