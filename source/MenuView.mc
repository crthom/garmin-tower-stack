using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Graphics;
import Toybox.Lang;
using Toybox.Application as App;
using Toybox.Rez

class MenuView extends WatchUi.View {
    var highScore as Number;

    function initialize() {
        View.initialize();

        highScore = App.Properties.getValue("highScore");
    }

    function saveHighScore(score as Number) {
        App.Properties.setValue("highScore", score);
        highScore = score; // update cached value
    }

    function onShow() {
        loadHighScore();
        WatchUi.requestUpdate();
    }

    function loadHighScore() {
        highScore = App.Properties.getValue("highScore");
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        _highScoreElement = findDrawableById("HighScore");
    }

    function onUpdate(dc as Graphics.Dc) {
        dc.clear();
         _highScoreElement.setText("High Score: " + highScore.toString());
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.drawText(
            dc.getWidth() / 3,
            dc.getHeight() / 2 - dc.getHeight() / 3.5,
            Graphics.FONT_LARGE,
            "Tower",
            Graphics.TEXT_JUSTIFY_CENTER
        );
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.drawText(
            dc.getWidth() / 3 + dc.getWidth()/3,
            dc.getHeight() / 2 - dc.getHeight() / 3.5,
            Graphics.FONT_LARGE,
            "Stack",
            Graphics.TEXT_JUSTIFY_CENTER
        );
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2 + dc.getHeight() / 6,
            Graphics.FONT_SMALL,
            "Select to Start",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}
