import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
using Toybox.Math as Math;

class TowerStackView extends WatchUi.View {
    private var _scoreElement;
    private var _xPosition = 0;
    private var _previousBlocks as Array<Array> = [];

    function rgbToDec( rr, gg, bb ) as Number {
        return rr*65536 + gg*256 + bb;
    }

    private var _colorGradient = [
        rgbToDec(8, 78, 199),
        rgbToDec(11, 72, 182),
        rgbToDec(22, 52, 147),
        rgbToDec(34, 36, 114),
        rgbToDec(42, 25, 90),
        rgbToDec(68, 18, 71),
        rgbToDec(104, 18, 62),
        rgbToDec(157, 17, 53),
        rgbToDec(196, 16, 49),
        rgbToDec(213, 12, 40),
        rgbToDec(247, 23, 31),
        rgbToDec(254, 34, 26),
        rgbToDec(255, 60, 20),
        rgbToDec(255, 92, 17),
        rgbToDec(253, 122, 11),
        rgbToDec(255, 138, 16),
        rgbToDec(254, 154, 17),
        rgbToDec(255, 138, 16),
        rgbToDec(253, 122, 11),
        rgbToDec(255, 92, 17),
        rgbToDec(255, 60, 20),
        rgbToDec(254, 34, 26),
        rgbToDec(247, 23, 31),
        rgbToDec(213, 12, 40),
        rgbToDec(196, 16, 49),
        rgbToDec(157, 17, 53),
        rgbToDec(104, 18, 62),
        rgbToDec(68, 18, 71),
        rgbToDec(42, 25, 90),
        rgbToDec(34, 36, 114),
        rgbToDec(22, 52, 147),
        rgbToDec(11, 72, 182),
        rgbToDec(8, 78, 199),
    ];

    function getDeviceWidth() as Lang.Number {
        var deviceSettings = System.getDeviceSettings();
        var fullScreenWidth = deviceSettings.screenWidth;
    
        return fullScreenWidth;
    }
    
    var _currentWidth = getDeviceWidth()*0.4;
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
        var blockHeight = (dc.getHeight() / 14);
        View.onUpdate(dc);
        dc.drawLine(0, (dc.getHeight() * 0.5) + (blockHeight * 2) + (blockHeight * _score), dc.getWidth(), (dc.getHeight() * 0.5) + (blockHeight * 2) + (blockHeight * _score));
        dc.setColor(_colorGradient[0], Graphics.COLOR_BLACK);
        dc.fillRoundedRectangle(
            dc.getWidth()/2-(getDeviceWidth()*0.4/2), // x
            (dc.getHeight() * 0.5) + blockHeight + (blockHeight*_score),                   // y
            (getDeviceWidth()*0.4),                  // width
            blockHeight,                   // height
            2                     // corner radius
        );
        for (var i = 0; i < _previousBlocks.size(); i++) {
            var block = _previousBlocks[i];
            dc.setColor(_colorGradient[(i)%30], Graphics.COLOR_BLACK);
            dc.fillRoundedRectangle(
                block[0], // x
                (dc.getHeight() * 0.5) + blockHeight + ((_score - (block[1] + 1)) * blockHeight),                   // y
                block[2],                  // width
                blockHeight,                   // height
                2                     // corner radius
            );
        }

        // Set color
        dc.setColor(_colorGradient[_score%30], Graphics.COLOR_BLACK);

        // Draw rectangle
        dc.fillRoundedRectangle(
            _xPosition, // x
            (dc.getHeight() * 0.5),                   // y
            _currentWidth,                  // width
            blockHeight,                   // height
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
        _xPosition = 0;
        WatchUi.requestUpdate();
    }
}
