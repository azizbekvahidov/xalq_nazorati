package com.example.xalq_nazorati;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.yandex.mapkit.MapKitFactory;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    MapKitFactory.setApiKey("c8faaaf7-6b6b-44ba-84a8-e298a0e513b3");
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }
}
