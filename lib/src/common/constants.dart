import 'package:flutter/material.dart';

/// API endpoints
const String trailbrakeApiUrl = 'https://driverapp-2022.de.r.appspot.com';
// const String trailbrakeApiUrl = 'http://192.168.50.107:8080';

/// Spacing options
const double widgetSpacing = 16;
const double widgetSpacingSmall = 8;
const Widget rowSpacer = SizedBox(height: widgetSpacing);
const Widget columnSpacer = SizedBox(width: widgetSpacing);

/// Color options
const double inactiveOpacity = 0.4;
const double overlayOpacity = 0.4;

/// Padding options
const EdgeInsets appDefaultPadding = EdgeInsets.all(16);

/// Displayed strings - General
const String invalidStateMessage =
    "ERROR: App is in an invalid state! Please re-open the app.";
const String rideScoreDenominator = "/100";

/// Displayed strings - Dashboard
const String dashboardScreenTitle = "Dashboard";
const String lifetimeMetricsSectionTitle = "Lifetime Metrics";
const String rideCatalogSectionTitle = "All Rides";
const String missingRideMessage = "This ride has been deleted.";

/// Displayed strings - Ride activity
const String exitRideButtonLabel = "Exit";
const String saveRidePromptMessage =
    "Would you like to save data for this ride?";
const String savingInProgressMessage = "Saving ride...";
const String saveSuccessfulMessage = "Ride saved!";

/// Displayed strings - Ride summary screen
const String rideSummaryScreenTitle = "Ride completed!";
const String rideScoreSectionTitle = "Ride score";
const String rideScoreProfileSectionTitle = "Score breakdown";

/// Displayed strings - User profile screen
const String userScoreSectionTitle = "Driver score";
const String userScoreProfileSectionTitle = "Score breakdown";

/// Ride metrics
enum RideActivityMetrics {
  timeElapsed,
  accelerometerX,
}

const Map RideActivityMetricsName = {
  RideActivityMetrics.timeElapsed: "Time Elapsed",
  RideActivityMetrics.accelerometerX: "Accelerometer X",
};

/// Gravity
const double gravity = 9.81;
