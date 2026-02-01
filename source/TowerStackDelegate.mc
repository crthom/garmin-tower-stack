import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Lang;
using Toybox.Application as App;
using Toybox.Math;
using Toybox.Attention;
import Toybox.Application.Storage;

class TowerStackDelegate extends WatchUi.BehaviorDelegate {
    
    private var _inProgress = false;
    private var _gameOver = false;

    private var _xPosition = 0;
    private var _direction = 1;
    private var _timer;
    private var _stoppedX;
    
    private var _view;
    var highScore as Number;
    
    function initialize(view as TowerStackView) {
        BehaviorDelegate.initialize();
        _view = view;

        highScore = App.Properties.getValue("highScore");
    }

    function saveHighScore(score as Number) {
        App.Properties.setValue("highScore", score);
        highScore = score; // update cached value
    }

    function loadHighScore() as Number {
        return highScore; // always safe
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
        _view._perfect = 0;
    }

    function updateX() as Void{
        if (_gameOver == true) {
            _timer.stop();
            return;
        }
        if (_stoppedX != null) {
            if (_stoppedX == _leftBorder || (_stoppedX - _leftBorder).abs() < getDeviceWidth()*0.015) {
                var soundEnabled = Storage.getValue("soundEnabled");
                if (soundEnabled == null) { soundEnabled = true; }
                if (soundEnabled == true && Attention has :playTone) {
                    try {
                        Attention.playTone(Attention.TONE_KEY);
                    } catch (ex) {}
                }
                _nextWidth = _currentWidth;
                _view._perfect += 1;
            } else if (_stoppedX < _leftBorder) {
                _nextWidth = (_stoppedX + _currentWidth) - _leftBorder;
                _rightBorder = _leftBorder + _nextWidth;
                _view._perfect = 0;
            } else {
                _nextWidth = _rightBorder - _stoppedX;
                _leftBorder = _stoppedX;
                _view._perfect = 0;
            }
            if (_nextWidth <= 0 || _nextWidth < (getDeviceWidth()*0.01)) {
                var soundEnabled = Storage.getValue("soundEnabled");
                if (soundEnabled == null) { soundEnabled = true; }
                if (soundEnabled == true && Attention has :playTone) {
                    try {
                        Attention.playTone(Attention.TONE_ERROR);
                    } catch (ex) {}
                }
                _gameOver = true;
                _inProgress = false;
                if (_view._score > highScore) {
                    saveHighScore(_view._score);
                }
                WatchUi.popView(WatchUi.SLIDE_RIGHT);
            } else {
                var vibrationEnabled = Storage.getValue("vibrationEnabled");
                if (vibrationEnabled == null) { vibrationEnabled = true; }
                if (vibrationEnabled == true && Attention has :vibrate) {
                    Attention.vibrate([new Attention.VibeProfile(50, 100)]);
                }
                _currentWidth = _nextWidth;
                _stoppedX = null;
                if (_view._perfect >= 5){
                    // Reward perfect stacks with a width increase over 5 perfects
                    _currentWidth += getDeviceWidth()*0.01;
                    if (_currentWidth > getDeviceWidth()*0.4) {
                        _currentWidth = getDeviceWidth()*0.4;
                    }
                    _rightBorder = _leftBorder + _currentWidth;
                    if (_rightBorder > getDeviceWidth()/2 - (getDeviceWidth()*0.4/2) + getDeviceWidth()*0.4) {
                        _rightBorder = getDeviceWidth()/2 - (getDeviceWidth()*0.4/2) + getDeviceWidth()*0.4;
                        _leftBorder = _rightBorder - _currentWidth;
                    }
                    _view.newBlock(_leftBorder,  _currentWidth);
                } else {
                    _view.newBlock(_leftBorder,  _currentWidth);
                }
                _xPosition = 0;
                _direction = 1;
                _view._currentWidth = _currentWidth;
                _view.updateScore();
            }
            return;
        }
        if (_xPosition == getDeviceWidth()-_currentWidth || _xPosition > getDeviceWidth()-_currentWidth){
            _direction = -1 ;
        }
        if (_xPosition == 0 || _xPosition < 0){
            _direction = 1;
        }
        
        _speed = (((((_view._score+1)*0.002)+0.08)*(getDeviceHeight()/5)));
        if (_speed > (getDeviceWidth()/20)) {
            _speed = (getDeviceWidth()/20);
        }
        _xPosition += _speed * _direction;

        _view.setXPosition(_xPosition);
    }
}