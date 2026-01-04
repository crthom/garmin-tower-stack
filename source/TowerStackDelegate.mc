import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Timer;

class TowerStackDelegate extends WatchUi.BehaviorDelegate {
    
    private var _inProgress = false;
    private var _gameOver = false;

    private var _xPosition = 0;
    private var _direction = 1;
    private var _timer;
    private var _stoppedX;
    
    private var _view = getView();

    function getDeviceWidth() as Lang.Number {
        var deviceSettings = System.getDeviceSettings();
        var fullScreenWidth = deviceSettings.screenWidth;
    
        return fullScreenWidth;
    }

    private var _leftBorder = getDeviceWidth()/2 - 40;
    private var _rightBorder = _leftBorder + 80;
    private var _nextWidth = 80;
    private var _currentWidth = 80;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        if (_inProgress == false) {
            _inProgress = true;
            startGame();
        } else {
            _stoppedX = _xPosition;
        }

        return true;
    }

    function startGame() {
        _timer = new Timer.Timer();
        _timer.start(method(:updateX), 1, true);
        _xPosition = 0;
        _direction = 1;
        _gameOver = false;
        _leftBorder = getDeviceWidth()/2 - 40;
        _rightBorder = _leftBorder + 80;
        _nextWidth = 80;
        _currentWidth = 80;
    }

    function updateX() as Void{
        if (_gameOver == true) {
            _timer.stop();
            return;
        }
        if (_stoppedX != null) {
            if (_stoppedX == _leftBorder) {
                _nextWidth = 80;
            } else if (_stoppedX < _leftBorder) {
                _nextWidth = (_stoppedX + _currentWidth) - _leftBorder;
            } else {
                _nextWidth = _rightBorder - _stoppedX;
            }
            return;
        }
        if (_xPosition == getDeviceWidth()-100){
            _direction = -1 ;
        }
        if (_xPosition == 0){
            _direction = 1;
        }
        
        _xPosition += 4 * _direction;

        _view.setXPosition(_xPosition);
    }
}