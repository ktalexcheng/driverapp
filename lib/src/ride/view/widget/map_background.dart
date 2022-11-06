import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trailbrake/src/ride/cubit/cubit.dart';

mixin MapBackgroundMixin on StatelessWidget {
  late final GoogleMapController? googleMapController;
}

class MapBackground extends StatelessWidget with MapBackgroundMixin {
  MapBackground({super.key});

  // late final GoogleMapController? googleMapController;
  static const LatLng initialLocation = LatLng(0, 0);
  static const double mapZoomLevel = 17;
  final mapMarkers = <Marker>{};

  void _updateMapLocation(LatLng newLocation) {
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: mapZoomLevel,
          target: newLocation,
        ),
      ),
    );

    mapMarkers.add(
      Marker(
        markerId: const MarkerId('nowLocation'),
        position: newLocation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RideActivityCubit, RideActivityState>(
      listener: (context, state) {
        if (state is RideActivityNewRideInProgress) {
          if (state.newSensorData.locationUpdated ?? false) {
            LatLng _newLocation = LatLng(
              state.newSensorData.locationLat!,
              state.newSensorData.locationLong!,
            );

            _updateMapLocation(_newLocation);
          }
        } else if (state is RideActivityPrepareSuccess) {
          _updateMapLocation(state.initialLocation);
        }
      },
      // child: Container(),
      child: GoogleMap(
        onMapCreated: (controller) => googleMapController = controller,
        initialCameraPosition: const CameraPosition(
          target: initialLocation,
          zoom: mapZoomLevel,
        ),
      ),
    );
  }
}
