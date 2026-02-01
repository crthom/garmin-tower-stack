import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application.Storage;

class MenuDelegate extends WatchUi.BehaviorDelegate {
    private var _gameView;
    private var _gameDelegate;


    function initialize() {
        BehaviorDelegate.initialize();

        _gameView = new TowerStackView();
        _gameDelegate = new TowerStackDelegate(_gameView);
    }

    function onSelect() as Boolean {
        // Reuse the same instances
        // onShow() in the delegate will handle resetting _inProgress and _gameOver
        WatchUi.pushView(
            _gameView,
            _gameDelegate,
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
        // Just pop the view - no manual reset needed
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onMenu() as Boolean {
        var menu = new WatchUi.Menu2({:title => "Settings"});
        
        var soundEnabled = Storage.getValue("soundEnabled");
        var vibrationEnabled = Storage.getValue("vibrationEnabled");
        
        if (soundEnabled == null) { soundEnabled = true; }
        if (vibrationEnabled == null) { vibrationEnabled = true; }
        
        menu.addItem(new WatchUi.ToggleMenuItem(
            "Sound",
            null,
            "sound",
            soundEnabled,
            null
        ));
        
        menu.addItem(new WatchUi.ToggleMenuItem(
            "Vibration",
            null,
            "vibration",
            vibrationEnabled,
            null
        ));
        
        WatchUi.pushView(menu, new SettingsMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}