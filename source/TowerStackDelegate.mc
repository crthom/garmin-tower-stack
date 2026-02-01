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
    
    var _timer;
    
    var _view;
    var highScore as Number;
    
    // Declare these variables without initializing them yet
    var _inProgress;
    var _xPosition;
    var _direction;
    var _gameOver;
    var _stoppedX;
    var _leftBorder;
    var _rightBorder;
    var _nextWidth;
    var _currentWidth;
    var _perfect;
    var _speed;
    
    function initialize(view as TowerStackView) {
        BehaviorDelegate.initialize();
        _view = view;

        highScore = App.Properties.getValue("highScore");
        
        // NOW we can initialize these from the view
        getVariables();
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

    function onSelect() as Boolean {
        getVariables();
        if (_view._inProgress == false) {
            startGame();  // startGame will set _inProgress = true
        } else {
            _view._stoppedX = _view._xPosition;
        }
        return true;
    }

    function startGame() {
        // Reload high score from storage at the start of each game
        highScore = App.Properties.getValue("highScore");
        if (highScore == null) {
            highScore = 0;
        }
        
        // Reset the view first
        _view.resetGame();

        // Reuse existing timer if available, only create if null
        if (_timer == null) {
            _timer = new Timer.Timer();
        }
        
        // IMPORTANT: Set _inProgress BEFORE starting timer
        _view._inProgress = true;
        _timer.start(method(:updateX), 10, true);
        
        // Reset all delegate state
        _view._xPosition = 0;
        _view._direction = 1;
        _view._gameOver = false;
        _view._stoppedX = null;
        
        // Initialize borders - CRITICAL: Calculate fresh each time
        _view._leftBorder = getDeviceWidth()/2 - (getDeviceWidth()*0.4/2);
        _view._rightBorder = _view._leftBorder + getDeviceWidth()*0.4;
        _view._nextWidth = getDeviceWidth()*0.4;
        _view._currentWidth = getDeviceWidth()*0.4;
        
        // Sync state to view
        _view._perfect = 0;
        
        // Update local copies
        getVariables();
    }

    function onHide() as Void {
        if (_timer != null) {
            _timer.stop();
            // Keep timer for reuse - don't set to null
        }
    }

    function getVariables() as Void {
        _inProgress = _view._inProgress;
        _xPosition = _view._xPosition;
        _direction = _view._direction;
        _gameOver = _view._gameOver;
        _stoppedX = _view._stoppedX;
        _leftBorder = _view._leftBorder;
        _rightBorder = _view._rightBorder;
        _nextWidth = _view._nextWidth;
        _currentWidth = _view._currentWidth;
        _perfect = _view._perfect;
    }

    function saveVariables() as Void {
        _view._inProgress = _inProgress;
        _view._xPosition = _xPosition;
        _view._direction = _direction;
        _view._gameOver = _gameOver;
        _view._stoppedX = _stoppedX;
        _view._leftBorder = _leftBorder;
        _view._rightBorder = _rightBorder;
        _view._nextWidth = _nextWidth;
        _view._currentWidth = _currentWidth;
        _view._perfect = _perfect;
    }

    function updateX() as Void{
        getVariables();
        
        // Only update if game is in progress
        if (!_inProgress || _gameOver == true) {
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
                _perfect += 1;
            } else if (_stoppedX < _leftBorder) {
                var fallingWidth = _leftBorder - _stoppedX;
                var fallingX = _stoppedX;
                saveVariables();
                _view.addFallingPiece(fallingX, getDeviceHeight() * 0.5, fallingWidth, _view._score);
                
                _nextWidth = (_stoppedX + _currentWidth) - _leftBorder;
                _rightBorder = _leftBorder + _nextWidth;
                _perfect = 0;
            } else {
                var fallingWidth = (_stoppedX + _currentWidth) - _rightBorder;
                var fallingX = _rightBorder;
                saveVariables();
                _view.addFallingPiece(fallingX, getDeviceHeight() * 0.5, fallingWidth, _view._score);
                
                _nextWidth = _rightBorder - _stoppedX;
                _leftBorder = _stoppedX;
                _perfect = 0;
            }
            if (_nextWidth <= 0 || _nextWidth < (getDeviceWidth()*0.01)) {
                saveVariables();
                var soundEnabled = Storage.getValue("soundEnabled");
                if (soundEnabled == null) { soundEnabled = true; }
                if (soundEnabled == true && Attention has :playTone) {
                    try {
                        Attention.playTone(Attention.TONE_ERROR);
                    } catch (ex) {}
                }
                _gameOver = true;
                _inProgress = false;
                
                // Save high score (onHide will also do this)
                if (_view._score > highScore) {
                    saveHighScore(_view._score);
                }
                saveVariables();                
                // Pop view - onHide handles all reset
                WatchUi.popView(WatchUi.SLIDE_RIGHT);
            } else {
                saveVariables();
                var vibrationEnabled = Storage.getValue("vibrationEnabled");
                if (vibrationEnabled == null) { vibrationEnabled = true; }
                if (vibrationEnabled == true && Attention has :vibrate) {
                    Attention.vibrate([new Attention.VibeProfile(50, 100)]);
                }
                _currentWidth = _nextWidth;
                _stoppedX = null;
                if (_perfect >= 5){
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
                    saveVariables();
                    _view.newBlock(_leftBorder,  _currentWidth);
                } else {
                    saveVariables();
                    _view.newBlock(_leftBorder,  _currentWidth);
                }
                _xPosition = 0;
                _direction = 1;
                saveVariables();
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

        saveVariables();

        _view.setXPosition(_xPosition);
    }
}
