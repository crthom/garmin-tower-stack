import Toybox.WatchUi;
import Toybox.Lang;

class MenuDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        var gameView = new TowerStackView();

        WatchUi.pushView(
            gameView,
            new TowerStackDelegate(gameView),
            WatchUi.SLIDE_LEFT
        );
        return true;
    }

    function onPreviousPage() as Boolean {
        var customizeView = new CustomizeView();

        WatchUi.pushView(
            customizeView,
            new CustomizeDelegate(customizeView),
            WatchUi.SLIDE_RIGHT
        );
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}