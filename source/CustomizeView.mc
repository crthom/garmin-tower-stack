using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Graphics;
import Toybox.Lang;
using Toybox.Application as App;
import Toybox.Graphics;

class CustomizeView extends WatchUi.View {
    var highScore as Number;
    private var _selectedGradient;
    
    var _gradientIndex = 0;

    var _gradients as Array = [
        ["Thermal shift", 0],
        ["Indigo Drift", 30],
        ["Rose sand", 40],
        ["Forest", 50],
        ["Ocean flow", 60],
        ["Rainbow", 75],
    ];

    function rgbToDec( rr, gg, bb ) as Number {
        return rr*65536 + gg*256 + bb;
    }

    private var _blueRedColorGradient = [
        rgbToDec(8, 78, 199),
        rgbToDec(34, 36, 114),
        rgbToDec(104, 18, 62),
        rgbToDec(213, 12, 40),
        rgbToDec(255, 60, 20),
        rgbToDec(255, 138, 16),
    ];

    private var _purpleBlueColorGradient = [
        rgbToDec(103, 27, 162),
        rgbToDec(99, 67, 187),
        rgbToDec(96, 96, 208),
        rgbToDec(95, 124, 225),
        rgbToDec(100, 150, 239),
        rgbToDec(118, 183, 253),
    ];

    private var _forestGreenBrownGradient = [
        rgbToDec(34, 139, 34),
        rgbToDec(52, 124, 22),
        rgbToDec(70, 109, 10),
        rgbToDec(88, 94, 0),
        rgbToDec(106, 79, 0),
        rgbToDec(124, 64, 0),
    ];

    private var _pinkTanColorGradient = [
        rgbToDec(255, 105, 180),
        rgbToDec(255, 133, 164),
        rgbToDec(255, 154, 152),
        rgbToDec(255, 175, 140),
        rgbToDec(255, 196, 128),
        rgbToDec(255, 217, 116),
    ];

    private var _rainbowColorGradient = [
        rgbToDec(148, 0, 211),
        rgbToDec(60, 40, 255),
        rgbToDec(0, 145, 255),
        rgbToDec(0, 230, 255),
        rgbToDec(80, 255, 0),
        rgbToDec(230, 255, 0),
        rgbToDec(255, 190, 0),
        rgbToDec(255, 80, 0),
        rgbToDec(255, 0, 60),
    ];

    private var _tealBlueColorGradient = [
        rgbToDec(0, 200, 180),
        rgbToDec(0, 184, 192),
        rgbToDec(0, 172, 201),
        rgbToDec(0, 160, 210),
        rgbToDec(0, 148, 219),
        rgbToDec(0, 136, 228),
    ];

    var _miniGradients as Array = [
        _blueRedColorGradient,
        _purpleBlueColorGradient,
        _pinkTanColorGradient,
        _forestGreenBrownGradient,
        _tealBlueColorGradient,
        _rainbowColorGradient,
    ];
    
    function initialize() {
        View.initialize();

        highScore = App.Properties.getValue("highScore");
        _selectedGradient = App.Properties.getValue("selectedGradientIndex");
    }

    function onShow() {
        loadHighScore();
        loadGradient();
        WatchUi.requestUpdate();
    }

    function loadHighScore() {
        highScore = App.Properties.getValue("highScore");
    }
    
    function loadGradient() {
        _selectedGradient = App.Properties.getValue("selectedGradientIndex");
    }

    // Load your resources here
    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.CustomizeLayout(dc));

    }

    function onUpdate(dc as Graphics.Dc) {
        dc.clear();
        loadHighScore();
        loadGradient();
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            dc.getWidth()/2,
            dc.getHeight()/2,
            Graphics.FONT_SMALL,
            _gradients[_gradientIndex][0],
            Graphics.TEXT_JUSTIFY_CENTER
        );
        if (highScore >= _gradients[_gradientIndex][1]) {
            if (_selectedGradient == _gradientIndex) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
            } else {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            }
            dc.drawText(
                dc.getWidth()/2,
                dc.getHeight()/2+dc.getHeight()*0.15,
                Graphics.FONT_TINY,
                _selectedGradient==_gradientIndex ? "Selected" : "Press start to select",
                Graphics.TEXT_JUSTIFY_CENTER
            );
        } else {
            dc.drawText(
                dc.getWidth()/2,
                dc.getHeight()/2+dc.getHeight()*0.15,
                Graphics.FONT_TINY,
                "Score " + _gradients[_gradientIndex][1].toString() + " to unlock",
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        //right arrow
        dc.drawLine(dc.getWidth()*0.95, dc.getHeight()/2, dc.getWidth()*0.95 - dc.getWidth()*0.05, dc.getHeight()/2 - dc.getHeight()*0.05); // top line
        dc.drawLine(dc.getWidth()*0.95, dc.getHeight()/2, dc.getWidth()*0.95 - dc.getWidth()*0.05, dc.getHeight()/2 + dc.getHeight()*0.05); // bottom line
        //left arrow
        dc.drawLine(dc.getWidth()*0.05, dc.getHeight()/2, dc.getWidth()*0.05 + dc.getWidth()*0.05, dc.getHeight()/2 + dc.getHeight()*0.05); // top line
        dc.drawLine(dc.getWidth()*0.05, dc.getHeight()/2, dc.getWidth()*0.05 + dc.getWidth()*0.05, dc.getHeight()/2 - dc.getHeight()*0.05); // bottom line

        //gradient preview
        for (var i = 0; i < _miniGradients[_gradientIndex].size(); i++) {
            dc.setColor(_miniGradients[_gradientIndex][i], Graphics.COLOR_BLACK);
            dc.fillRectangle(
                dc.getWidth()*0.2 + (i * (dc.getWidth()*0.6/_miniGradients[_gradientIndex].size())),
                dc.getHeight()*0.35,
                dc.getWidth()*0.6/_miniGradients[_gradientIndex].size(),
                dc.getHeight()*0.1
            );
        }

    }
}