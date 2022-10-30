import 'package:flutter/material.dart';

/// API endpoints
const String trailbrakeApiUrl = 'https://driverapp-2022.de.r.appspot.com';
// const String trailbrakeApiUrl = 'http://192.168.50.107:8080';

/// Spacing options
const double widgetSpacing = 16;
const double widgetSpacingSmall = 8;
const Widget rowSpacer = SizedBox(height: widgetSpacing);
const Widget columnSpacer = SizedBox(width: widgetSpacing);

/// Padding options
const EdgeInsets appDefaultPadding = EdgeInsets.all(16);

/// Displayed strings - General
const String invalidStateMessage =
    "ERROR: App is in an invalid state! Please re-open the app.";

/// Displayed strings - Dashboard
const String dashboardScreenTitle = "Dashboard";
const String lifetimeMetricsSectionTitle = "Lifetime Metrics";
const String missingRideMessage = "This ride has been deleted.";

/// Displayed strings - Ride activity
const String saveRidePromptMessage =
    "Would you like to save data for this ride?";
const String savingInProgressMessage = "Saving ride...";
const String saveSuccessfulMessage = "Ride saved!";

/// Ride metrics
enum RideActivityMetrics {
  timeElapsed,
  accelerometerX,
}

/// Gravity
const double gravity = 9.81;
