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
    function getDeviceHeight() as Lang.Number {
        var deviceSettings = System.getDeviceSettings();
        var fullScreenHeight = deviceSettings.screenHeight;
    
        return fullScreenHeight;
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
        _timer.start(method(:updateX), 10, true);
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
                _nextWidth = _currentWidth;
            } else if (_stoppedX < _leftBorder) {
                _nextWidth = (_stoppedX + _currentWidth) - _leftBorder;
                _rightBorder = _leftBorder + _nextWidth;
            } else {
                _nextWidth = _rightBorder - _stoppedX;
                _leftBorder = _stoppedX;
            }
            if (_nextWidth <= 0) {
                _gameOver = true;
                _inProgress = false;
            } else {
                _currentWidth = _nextWidth;
                _stoppedX = null;
                _view.newBlock(_leftBorder, _currentWidth);
                _xPosition = 0;
                _direction = 1;
                _view._currentWidth = _currentWidth;
                _view.updateScore();
            }
            return;
        }
        if (_xPosition == getDeviceWidth()-_currentWidth){
            _direction = -1 ;
        }
        if (_xPosition == 0){
            _direction = 1;
        }
        
        _xPosition += (getDeviceHeight()/50) * _direction;

        _view.setXPosition(_xPosition);
    }
}