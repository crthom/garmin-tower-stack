import Toybox.Lang;
import Toybox.WatchUi;

class TowerStackDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new TowerStackMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}