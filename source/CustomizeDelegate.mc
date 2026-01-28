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
        WatchUi.requestUpdate();
        return true;
    }

    function onPreviousPage() as Boolean {
        _view._gradientIndex -= 1;
        if (_view._gradientIndex < 0) {
            _view._gradientIndex = _view._gradients.size() - 1;
        }
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPage() as Boolean {
        _view._gradientIndex += 1;
        if (_view._gradientIndex >= _view._gradients.size()) {
            _view._gradientIndex = 0;
        }
        WatchUi.requestUpdate();
        return true;
    }
}