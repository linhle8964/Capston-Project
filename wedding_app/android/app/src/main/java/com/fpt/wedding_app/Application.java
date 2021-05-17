package com.fpt.wedding_app;

import io.flutter.app.FlutterApplication;
import io.flutter.plugins.androidalarmmanager.AlarmService;
import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;
@SuppressWarnings("deprecation")
public class Application extends FlutterApplication
        implements io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
        //AlarmService.setPluginRegistrant(this);
    }

    @Override
    @SuppressWarnings("deprecation")
    public void registerWith(io.flutter.plugin.common.PluginRegistry registry) {
        AndroidAlarmManagerPlugin.registerWith(
                registry.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"));
    }
}