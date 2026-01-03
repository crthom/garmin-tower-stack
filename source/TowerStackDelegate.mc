import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Timer;

class TowerStackDelegate extends WatchUi.BehaviorDelegate {

    private static var cycles = 5;
    private static var cycleDuration = 30;
    
    private var _inProgress = false;

    private var _currentDuration;
    private var _currentCycle;
    private var _timer;
    
    private var _view = getView();

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        if (_inProgress == false) {
            _inProgress = true;
            startCountdown();
        }
        return true;
    }

    function startCountdown() {
        _currentDuration = cycleDuration;
        _currentCycle = cycles - 1;
        _view.updateCyclesValue(_currentCycle);

        _timer = new Timer.Timer();
        _timer.start(method(:updateCountdownValue), 1000, true);
    }

    function updateCountdownValue() as Void{
        if (_currentDuration == 0 && _currentCycle == 0) {
            _timer.stop();
            _view.setTimerValue(_currentDuration);
            return;
        }
        if (_currentDuration == 0) {
            _currentDuration = cycleDuration;
            _currentCycle--;
            _view.updateCyclesValue(_currentCycle);
            _view.setWaterTypeValue((_currentCycle % 2) == 0 ? WaterType.Cold : WaterType.Hot);
        }

        _view.setTimerValue(_currentDuration);
        _currentDuration--;
    }
}