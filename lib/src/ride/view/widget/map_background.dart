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
  final Set<Marker> mapMarkers = <Marker>{};
  final List<LatLng> mapLatLngs = <LatLng>[];

  void _updateMapLocation(LatLng newLocation) {
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: mapZoomLevel,
          target: newLocation,
        ),
      ),
    );

    // mapMarkers.add(Marker(
    //   markerId: const MarkerId('nowLocation'),
    //   position: newLocation,
    // ));

    mapLatLngs.add(newLocation);
  }

  void _lastLocation() {
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: mapZoomLevel,
          target: mapLatLngs.last,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideActivityCubit, RideActivityState>(
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
      builder: (context, state) {
        // child: Container(),
        return Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) => googleMapController = controller,
              initialCameraPosition: const CameraPosition(
                target: initialLocation,
                zoom: mapZoomLevel,
              ),
              markers: mapMarkers,
              polylines: {
                Polyline(
                  polylineId: const PolylineId('nowRoute'),
                  points: mapLatLngs,
                  color: Theme.of(context).colorScheme.primary,
                  width: 5,
                )
              },
            ),
            Positioned(
              bottom: 72,
              right: 16,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () => _lastLocation(),
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        );
      },
    );
  }
}
