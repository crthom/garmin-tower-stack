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
    
    private var _view;

    function initialize(view as TowerStackView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

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

    private var _leftBorder = getDeviceWidth()/2 - (getDeviceWidth()*0.4/2);;
    private var _rightBorder = _leftBorder + getDeviceWidth()*0.4;
    private var _nextWidth = getDeviceWidth()*0.4;
    private var _currentWidth = getDeviceWidth()*0.4;
    private var _speed;

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
        _leftBorder = getDeviceWidth()/2 - (getDeviceWidth()*0.4/2);
        _rightBorder = _leftBorder + getDeviceWidth()*0.4;
        _nextWidth = getDeviceWidth()*0.4;
        _currentWidth = getDeviceWidth()*0.4;
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
                WatchUi.popView(WatchUi.SLIDE_RIGHT);
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
        
        _speed = (((((_view._score+1)*0.002)+0.1)*(getDeviceHeight()/5)));
        if (_speed > (getDeviceWidth()/20)) {
            _speed = (getDeviceWidth()/20);
        }
        System.println(_speed);
        _xPosition += _speed * _direction;

        _view.setXPosition(_xPosition);
    }
}