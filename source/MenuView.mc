using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Graphics;
import Toybox.Lang;
using Toybox.Application as App;

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

    function onUpdate(dc as Graphics.Dc) {
        dc.clear();
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
            dc.getHeight() / 2,
            Graphics.FONT_SMALL,
            "High Score: " + highScore,
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