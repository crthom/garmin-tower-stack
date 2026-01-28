import Toybox.WatchUi;
import Toybox.Lang;
using Toybox.Application as App;

class CustomizeDelegate extends WatchUi.BehaviorDelegate {

    private var _view;

    function initialize(view as CustomizeView) {
        BehaviorDelegate.initialize();

        _view = view;
    }
    function saveSelectedGradient(index as Number) {
        App.Properties.setValue("selectedGradientIndex", index);
    }

    function onSelect() as Boolean {
        saveSelectedGradient(_view._gradientIndex);
        return true;
    }
}