import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class TowerStackView extends WatchUi.View {
    private var _scoreElement;
    private var _xPosition = 0;

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
        dc.drawLine(0, 140, dc.getWidth(), 140);
        dc.fillRoundedRectangle(
            dc.getWidth()/2-40, // x
            120,                   // y
            80,                  // width
            20,                   // height
            2                     // corner radius
        );
        
        // Set color
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_DK_BLUE);

        // Draw rectangle
        dc.fillRoundedRectangle(
            _xPosition, // x
            100,                   // y
            80,                  // width
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

    function updateScore(score as Number) as Void {
        _scoreElement.setText(score.toString());
        WatchUi.requestUpdate();
    }
}
