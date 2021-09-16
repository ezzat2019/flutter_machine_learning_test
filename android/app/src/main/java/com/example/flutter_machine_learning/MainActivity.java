package com.example.flutter_machine_learning;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.drawable.Icon;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.widget.Toast;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/battery";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("getBatteryLevel")) {
                                int batteryLevel = getBatteryLevel();

                                if (batteryLevel != -1) {
                                    result.success(batteryLevel);
                                } else {
                                    result.error("UNAVAILABLE", "Battery level not available.", null);
                                }
                            }else if(call.method.equals("showToast"))
                            {

                                showEzzatToast(call.argument("name").toString(),call.argument("age"));
                                result.success(call.arguments.toString());

                            }

                            else {
                                result.notImplemented();
                            }
                        }
                );
    }
    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        return batteryLevel;
    }

    private void showEzzatToast(String name,int age)
    {
        NotificationManager manager= (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

//        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
//            NotificationChannel notificationChannel=new NotificationChannel("any",
//                    "ezzxat", NotificationManager.IMPORTANCE_HIGH);
//
//           manager.createNotificationChannel(notificationChannel);
//           Notification notification=new Notification.Builder(getApplicationContext(),"any")
//                   .setSmallIcon(R.drawable.launch_background)
//                   .setContentTitle("helle sir")
//                   .setContentText("i am here").build();
//           manager.notify(1,notification);
//            }
//        Intent intent = new Intent();
//        intent.setType("image/*");
//        intent.setAction(Intent.ACTION_GET_CONTENT);
//        startActivityForResult(
//                Intent.createChooser(intent, "Select file to upload "),
//                1);
        Toast.makeText(getApplicationContext(), "Hi "+name+" my age is "+age+" iam native code", Toast.LENGTH_SHORT).show();

    }
}
