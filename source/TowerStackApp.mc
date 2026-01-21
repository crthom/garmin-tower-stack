import Toybox.Application;
import Toybox.WatchUi;

class TowerStackApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new MenuView(), new MenuDelegate() ];
    }
}