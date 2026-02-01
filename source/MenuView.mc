using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Graphics;
import Toybox.Lang;
using Toybox.Application as App;
import Toybox.Graphics;

class MenuView extends WatchUi.View {
    var highScore as Number;
    private var _highScoreElement;

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
        setLayout(Rez.Layouts.MenuLayout(dc));

        _highScoreElement = findDrawableById("highScore");
    }

    function onUpdate(dc as Graphics.Dc) {
        dc.clear();
        loadHighScore();
        _highScoreElement.setText("High Score: " + highScore.toString());
        View.onUpdate(dc);
    }
}