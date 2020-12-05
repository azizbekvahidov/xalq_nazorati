package uz.digital_tashkent.xalq_nazorati;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;

//import com.yandex.mapkit.MapKitFactory;


public class Application extends FlutterApplication implements PluginRegistrantCallback {
  @Override
  public void onCreate() {
    super.onCreate();
    FlutterFirebaseMessagingService.setPluginRegistrant(this);
//    MapKitFactory.setApiKey("c8faaaf7-6b6b-44ba-84a8-e298a0e513b3");
  }

  @Override
  public void registerWith(PluginRegistry registry) {
    FirebaseCloudMessagingRegistrant.registerWith(registry);

  }
}