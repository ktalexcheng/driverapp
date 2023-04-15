import 'package:flutter/material.dart';

/// API endpoints
const String trailbrakeApiUrl =
    'https://trailbrake-api-f6muv3fwlq-de.a.run.app';
// const String trailbrakeApiUrl = 'http://10.0.2.2:8080'; // 10.0.2.2 is localhost

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
const String guestModeDashbaord = "Please login to see your dashboard.";

/// Displayed strings - Ride activity
const String exitRideButtonLabel = "Exit";
const String saveRidePromptMessage =
    "Would you like to save data for this ride?";
const String savingInProgressMessage = "Saving ride...";
const String saveSuccessfulMessage = "Ride saved!";
const String guestModeActivity = "Please login to start recording a ride.";

/// Displayed strings - Ride summary screen
const String rideSummaryScreenTitle = "Ride completed!";
const String rideScoreSectionTitle = "Ride score";
const String rideScoreProfileSectionTitle = "Score breakdown";

/// Displayed strings - User profile screen
const String userScoreSectionTitle = "Driver score";
const String userScoreProfileSectionTitle = "Score breakdown";
const String userScoreDefinition =
    "Driver score based on 10 most recent rides.";
const String userLogout = "Logout";

/// Displayed strings - Login/Signup screen
const String signupLabel = "Signup";
const String loginLabel = "Login";
const String createProfileLabel = "Create profile";
const String emailLabel = "Email";
const String passwordLabel = "Password";
const String confirmPasswordLabel = "Confirm password";
const String mismatchedPasswordLabel = "Passwords do not match";
const String loginFailedDialogTitle = "Login failed";
const String loginFailedDialogMsg = "Invalid credentials";
const String signUpFailedDialogTitle = "Unable to create user profile";
const String signUpFailedDialogMsg = "Email already registered";
const String guestModeProfile = "Please login to see your profile.";

/// Ride metrics
enum RideActivityMetrics {
  timeElapsed,
  accelerometerX,
  avgSpeed,
  avgMovingSpeed,
  distance,
}

const Map rideActivityMetricsName = {
  RideActivityMetrics.timeElapsed: "Time Elapsed",
  RideActivityMetrics.accelerometerX: "Accelerometer X",
  RideActivityMetrics.avgSpeed: "Average Speed",
  RideActivityMetrics.avgMovingSpeed: "Average Moving Speed",
  RideActivityMetrics.distance: "Distance",
};

/// Gravity
const double gravity = 9.81;
