using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Graphics;

class MenuView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Graphics.Dc) {
        dc.clear();
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.drawText(
            dc.getWidth() / 3,
            dc.getHeight() / 2 - 40,
            Graphics.FONT_LARGE,
            "Tower",
            Graphics.TEXT_JUSTIFY_CENTER
        );
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.drawText(
            dc.getWidth() / 3 + 70,
            dc.getHeight() / 2 - 40,
            Graphics.FONT_LARGE,
            "Stack",
            Graphics.TEXT_JUSTIFY_CENTER
        );
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_LARGE,
            "High Score: ",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}