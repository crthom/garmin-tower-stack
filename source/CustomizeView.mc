using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Graphics;
import Toybox.Lang;
using Toybox.Application as App;
import Toybox.Graphics;

class CustomizeView extends WatchUi.View {
    var highScore as Number;
    private var _highScoreElement;
    
    var _gradientIndex = 0;

    var _gradients as Array = [
        "Thermal shift",
        "Forest",
        "Rose sand",
        "Indigo Drift",
        "Ocean flow",
        "Rainbow",
    ];

    function initialize() {
        View.initialize();

        highScore = App.Properties.getValue("highScore");
    }

    function onShow() {
        loadHighScore();
        WatchUi.requestUpdate();
    }

    function loadHighScore() {
        highScore = App.Properties.getValue("highScore");
    }

    // Load your resources here
    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.CustomizeLayout(dc));

    }

    function onUpdate(dc as Graphics.Dc) {
        dc.clear();
        loadHighScore();
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.drawLine(0, (dc.getHeight() * 0.3), dc.getWidth(), (dc.getHeight() * 0.3));
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            dc.getWidth()/2,
            dc.getHeight()/2,
            Graphics.FONT_LARGE,
            _gradients[_gradientIndex],
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}