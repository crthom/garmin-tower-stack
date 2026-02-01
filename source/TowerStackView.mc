import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
using Toybox.Math as Math;
using Toybox.Application as App;

class TowerStackView extends WatchUi.View {
    private var _scoreElement;
    private var _xPosition = 0;
    private var _previousBlocks as Array<Array> = [];
    private var _selectedGradient;

    var _perfect = 0;

    function rgbToDec( rr, gg, bb ) as Number {
        return rr*65536 + gg*256 + bb;
    }

    //starter gradient 
    private var _blueRedColorGradient = [
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

    //unlocked at high score of 25 
    private var _purpleBlueColorGradient = [
        rgbToDec(103, 27, 162),
        rgbToDec(102, 43, 171),
        rgbToDec(101, 55, 179),
        rgbToDec(99, 67, 187),
        rgbToDec(98, 77, 195),
        rgbToDec(97, 87, 202),
        rgbToDec(96, 96, 208),
        rgbToDec(95, 106, 214),
        rgbToDec(94, 115, 220),
        rgbToDec(95, 124, 225),
        rgbToDec(96, 133, 230),
        rgbToDec(97, 141, 235),
        rgbToDec(100, 150, 239),
        rgbToDec(103, 158, 243),
        rgbToDec(107, 167, 247),
        rgbToDec(112, 175, 250),
        rgbToDec(118, 183, 253),
        rgbToDec(112, 175, 250),
        rgbToDec(107, 167, 247),
        rgbToDec(103, 158, 243),
        rgbToDec(100, 150, 239),
        rgbToDec(97, 141, 235),
        rgbToDec(96, 133, 230),
        rgbToDec(95, 124, 225),
        rgbToDec(94, 115, 220),
        rgbToDec(95, 106, 214),
        rgbToDec(96, 96, 208),
        rgbToDec(97, 87, 202),
        rgbToDec(98, 77, 195),
        rgbToDec(99, 67, 187),
        rgbToDec(101, 55, 179),
        rgbToDec(102, 43, 171),
        rgbToDec(103, 27, 162),
    ];

    //unlocked at high score of 35
    private var _forestGreenBrownGradient = [
        rgbToDec(34, 139, 34),
        rgbToDec(40, 134, 30),
        rgbToDec(46, 129, 26),
        rgbToDec(52, 124, 22),
        rgbToDec(58, 119, 18),
        rgbToDec(64, 114, 14),
        rgbToDec(70, 109, 10),
        rgbToDec(76, 104, 6),
        rgbToDec(82, 99, 2),
        rgbToDec(88, 94, 0),
        rgbToDec(94, 89, 0),
        rgbToDec(100, 84, 0),
        rgbToDec(106, 79, 0),
        rgbToDec(112, 74, 0),
        rgbToDec(118, 69, 0),
        rgbToDec(124, 64, 0),
        rgbToDec(118, 69, 0),
        rgbToDec(112, 74, 0),
        rgbToDec(106, 79, 0),
        rgbToDec(100, 84, 0),
        rgbToDec(94, 89, 0),
        rgbToDec(88, 94, 0),
        rgbToDec(82, 99, 2),
        rgbToDec(76, 104, 6),
        rgbToDec(70, 109, 10),
        rgbToDec(64, 114, 14),
        rgbToDec(58, 119, 18),
        rgbToDec(52, 124, 22),
        rgbToDec(46, 129, 26),
        rgbToDec(40, 134, 30),
        rgbToDec(34, 139, 34),
];
    
    //unlocked at high score of 40 
    private var _pinkTanColorGradient = [
        rgbToDec(255, 105, 180),
        rgbToDec(255, 112, 176),
        rgbToDec(255, 119, 172),
        rgbToDec(255, 126, 168),
        rgbToDec(255, 133, 164),
        rgbToDec(255, 140, 160),
        rgbToDec(255, 147, 156),
        rgbToDec(255, 154, 152),
        rgbToDec(255, 161, 148),
        rgbToDec(255, 168, 144),
        rgbToDec(255, 175, 140),
        rgbToDec(255, 182, 136),
        rgbToDec(255, 189, 132),
        rgbToDec(255, 196, 128),
        rgbToDec(255, 203, 124),
        rgbToDec(255, 210, 120),
        rgbToDec(255, 217, 116),
        rgbToDec(255, 210, 120),
        rgbToDec(255, 203, 124),
        rgbToDec(255, 196, 128),
        rgbToDec(255, 189, 132),
        rgbToDec(255, 182, 136),
        rgbToDec(255, 175, 140),
        rgbToDec(255, 168, 144),
        rgbToDec(255, 161, 148),
        rgbToDec(255, 154, 152),
        rgbToDec(255, 147, 156),
        rgbToDec(255, 140, 160),
        rgbToDec(255, 133, 164),
        rgbToDec(255, 126, 168),
        rgbToDec(255, 119, 172),
        rgbToDec(255, 112, 176),
        rgbToDec(255, 105, 180),
    ];
    
    //unlocked at high score of 50 
    private var _rainbowColorGradient = [
        rgbToDec(148, 0, 211),
        rgbToDec(120, 0, 230),
        rgbToDec(90, 0, 255),
        rgbToDec(60, 40, 255),
        rgbToDec(30, 80, 255),
        rgbToDec(0, 120, 255),
        rgbToDec(0, 145, 255),
        rgbToDec(0, 170, 255),
        rgbToDec(0, 200, 255),
        rgbToDec(0, 230, 255),
        rgbToDec(0, 255, 255),
        rgbToDec(0, 255, 200),
        rgbToDec(0, 255, 150),
        rgbToDec(0, 255, 100),
        rgbToDec(0, 255, 0),
        rgbToDec(80, 255, 0),
        rgbToDec(140, 255, 0),
        rgbToDec(200, 255, 0),
        rgbToDec(230, 255, 0),
        rgbToDec(255, 255, 0),
        rgbToDec(255, 220, 0),
        rgbToDec(255, 190, 0),
        rgbToDec(255, 160, 0),
        rgbToDec(255, 120, 0),
        rgbToDec(255, 80, 0),
        rgbToDec(255, 40, 0),
        rgbToDec(255, 0, 0),
        rgbToDec(255, 0, 60),
        rgbToDec(255, 0, 100),
        rgbToDec(255, 0, 140),
        rgbToDec(230, 0, 170),
        rgbToDec(200, 0, 200),
        rgbToDec(170, 0, 210),
        rgbToDec(148, 0, 211),
    ];

    //unlocked at high score of 30
    private var _tealBlueColorGradient = [
        rgbToDec(0, 200, 180),
        rgbToDec(0, 196, 183),
        rgbToDec(0, 192, 186),
        rgbToDec(0, 188, 189),
        rgbToDec(0, 184, 192),
        rgbToDec(0, 180, 195),
        rgbToDec(0, 176, 198),
        rgbToDec(0, 172, 201),
        rgbToDec(0, 168, 204),
        rgbToDec(0, 164, 207),
        rgbToDec(0, 160, 210),
        rgbToDec(0, 156, 213),
        rgbToDec(0, 152, 216),
        rgbToDec(0, 148, 219),
        rgbToDec(0, 144, 222),
        rgbToDec(0, 140, 225),
        rgbToDec(0, 136, 228),
        rgbToDec(0, 140, 225),
        rgbToDec(0, 144, 222),
        rgbToDec(0, 148, 219),
        rgbToDec(0, 152, 216),
        rgbToDec(0, 156, 213),
        rgbToDec(0, 160, 210),
        rgbToDec(0, 164, 207),
        rgbToDec(0, 168, 204),
        rgbToDec(0, 172, 201),
        rgbToDec(0, 176, 198),
        rgbToDec(0, 180, 195),
        rgbToDec(0, 184, 192),
        rgbToDec(0, 188, 189),
        rgbToDec(0, 192, 186),
        rgbToDec(0, 196, 183),
        rgbToDec(0, 200, 180),
    ];

    var _gradients as Array = [
        _blueRedColorGradient,
        _purpleBlueColorGradient,
        _pinkTanColorGradient,
        _forestGreenBrownGradient,
        _tealBlueColorGradient,
        _rainbowColorGradient,
    ];

    function getDeviceWidth() as Lang.Number {
        var deviceSettings = System.getDeviceSettings();
        var fullScreenWidth = deviceSettings.screenWidth;
    
        return fullScreenWidth;
    }

    function getDeviceHeight() as Lang.Number {
        var deviceSettings = System.getDeviceSettings();
        var fullScreenHeight = deviceSettings.screenHeight;
    
        return fullScreenHeight;
    }
    
    var _currentWidth = getDeviceWidth()*0.4;
    var _score = 0;

    function initialize() {
        View.initialize();

        _selectedGradient = App.Properties.getValue("selectedGradientIndex");
    }

    function loadGradient() {
        _selectedGradient = App.Properties.getValue("selectedGradientIndex");
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
        loadGradient();
        var blockHeight = (dc.getHeight() / 14);
        View.onUpdate(dc);
        var reverseGradient = _gradients[_selectedGradient].reverse();
        for (var i = 0; i < dc.getHeight()*((dc.getHeight()/14)/dc.getHeight()) + dc.getHeight()/blockHeight; i++) {
            dc.setColor(reverseGradient[i%_gradients[_selectedGradient].size()], Graphics.COLOR_BLACK);
            dc.fillRoundedRectangle(
                dc.getWidth()/2-(getDeviceWidth()*0.4/2), // x
                (dc.getHeight() * 0.5) + blockHeight + (blockHeight*_score) + blockHeight*i,                   // y
                (getDeviceWidth()*0.4),                  // width
                blockHeight,                   // height
                2                     // corner radius 
            );
        }
        dc.setColor(_gradients[_selectedGradient][0], Graphics.COLOR_BLACK);
        dc.fillRoundedRectangle(
            dc.getWidth()/2-(getDeviceWidth()*0.4/2), // x
            (dc.getHeight() * 0.5) + blockHeight + (blockHeight*_score),                   // y
            (getDeviceWidth()*0.4),                  // width
            blockHeight,                   // height
            2                     // corner radius
        );
        for (var i = 0; i < _previousBlocks.size(); i++) {
            var block = _previousBlocks[i];
            dc.setColor(_gradients[_selectedGradient][(i)%_gradients[_selectedGradient].size()], Graphics.COLOR_BLACK);
            dc.fillRoundedRectangle(
                block[0], // x
                (dc.getHeight() * 0.5) + blockHeight + ((_score - (block[1] + 1)) * blockHeight),                   // y
                block[2],                  // width
                blockHeight,                   // height
                2                     // corner radius
            );
        }

        // Set color
        dc.setColor(_gradients[_selectedGradient][_score%_gradients[_selectedGradient].size()], Graphics.COLOR_BLACK);

        // Draw rectangle
        dc.fillRoundedRectangle(
            _xPosition, // x
            (dc.getHeight() * 0.5),                   // y
            _currentWidth,                  // width
            blockHeight,                   // height
            2                     // corner radius
        );

        if (_perfect!= 0) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.drawText(
                dc.getWidth()/2,
                (dc.getHeight() * 0.3),
                Graphics.FONT_SMALL,
                "Perfect x" +_perfect.toString(),
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
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
