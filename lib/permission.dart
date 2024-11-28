// lib/services/permission_service.dart

import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  /// Request all necessary permissions
  Future<bool> requestPermissions(BuildContext context) async {
    // Request Activity Recognition Permission (Android)
    if (Platform.isAndroid) {
      var activityRecognitionStatus = await Permission.activityRecognition.status;
      if (!activityRecognitionStatus.isGranted) {
        activityRecognitionStatus = await Permission.activityRecognition.request();
        if (!activityRecognitionStatus.isGranted) {
          // Permission denied
          _showPermissionDialog(context, 'Activity Recognition Permission is required to track your steps.');
          return false;
        }
      }

      // Check and request to ignore battery optimizations
      var ignoreBatteryOptimizations = await _isIgnoringBatteryOptimizations();
      if (!ignoreBatteryOptimizations) {
        bool userAgreed = await _promptDisableBatteryOptimizations(context);
        if (!userAgreed) {
          // User did not agree to disable battery optimizations
          _showPermissionDialog(context, 'Battery optimizations may interfere with step tracking. Please disable them in settings.');
          return false;
        }
      }
    }

    // Request Motion Usage Permission (iOS)
    if (Platform.isIOS) {
      var motionStatus = await Permission.sensors.status;
      if (!motionStatus.isGranted) {
        motionStatus = await Permission.sensors.request();
        if (!motionStatus.isGranted) {
          // Permission denied
          _showPermissionDialog(context, 'Motion Permission is required to track your steps.');
          return false;
        }
      }
    }

    // Additional permissions can be requested here

    return true;
  }

  /// Check if the app is ignoring battery optimizations (Android)
  Future<bool> _isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    // The permission_handler package does not support checking battery optimizations directly.
    // As a workaround, attempt to request ignoring battery optimizations.
    var status = await Permission.ignoreBatteryOptimizations.status;
    return status.isGranted;
  }

  /// Prompt the user to disable battery optimizations
  Future<bool> _promptDisableBatteryOptimizations(BuildContext context) async {
    bool userAgreed = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Disable Battery Optimizations'),
        content: Text(
            'To ensure accurate step tracking, please disable battery optimizations for this app.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _openBatteryOptimizationSettings();
              userAgreed = true;
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
    return userAgreed;
  }

  /// Open the battery optimization settings screen (Android)
  Future<void> _openBatteryOptimizationSettings() async {
    if (!Platform.isAndroid) return;
    final intent = AndroidIntent(
      action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
    );
    await intent.launch();
  }

  /// Show a dialog informing the user about required permissions
  void _showPermissionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permissions Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
