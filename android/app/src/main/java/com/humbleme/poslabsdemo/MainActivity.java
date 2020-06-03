package com.humbleme.poslabsdemo;

import android.os.Bundle;
import io.flutter.app.FlutterFragmentActivity;
import io.flutter.plugins.localauth.LocalAuthPlugin;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import io.flutter.plugins.googlemaps.GoogleMapsPlugin;
import com.lyokone.location.LocationPlugin;

public class MainActivity extends FlutterFragmentActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    LocalAuthPlugin.registerWith(registrarFor("io.flutter.plugins.localauth.LocalAuthPlugin"));
    FirebaseMessagingPlugin.registerWith(registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    LocationPlugin.registerWith(registrarFor("com.lyokone.location.LocationPlugin"));
    GoogleMapsPlugin.registerWith(registrarFor("io.flutter.plugins.googlemaps.GoogleMapsPlugin"));
  }
}
