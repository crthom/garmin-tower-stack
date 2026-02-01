using Toybox.WatchUi;
using Toybox.Application.Storage;

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    function initialize() {
        Menu2InputDelegate.initialize();
    }
    
    function onSelect(item) as Void {
        var id = item.getId();
        
        if (id.equals("sound")) {
            var currentValue = Storage.getValue("soundEnabled");
            if (currentValue == null) { currentValue = true; }
            Storage.setValue("soundEnabled", !currentValue);
        } else if (id.equals("vibration")) {
            var currentValue = Storage.getValue("vibrationEnabled");
            if (currentValue == null) { currentValue = true; }
            Storage.setValue("vibrationEnabled", !currentValue);
        }
    }
}