import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:driverapp/src/history/bloc/bloc.dart';

class RideHistoryCatalog extends StatelessWidget {
  const RideHistoryCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideHistoryBloc, RideHistoryState>(
      builder: (context, state) {
        if (state is RideHistoryGetCatalogSuccess) {
          return ListView.builder(
            itemCount: state.rideCatalog.length,
            // prototypeItem: ListTile(
            //   title: Text(state.rideHistory.first.rideName),
            // ),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.rideCatalog[index].rideName),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

// class RideActivityHistory extends StatefulWidget {
//   const RideActivityHistory({super.key});

//   @override
//   State<RideActivityHistory> createState() => _RideActivityHistoryState();
// }

// class _RideActivityHistoryState extends State<RideActivityHistory> {
//   RideData rideData = <SensorData>[];

//   List<DataColumn> _createDataColumns() {
//     return [
//       const DataColumn(label: Text('Timestamp')),
//       const DataColumn(label: Text('Accelerometer X')),
//       const DataColumn(label: Text('Accelerometer Y')),
//       const DataColumn(label: Text('Accelerometer Z')),
//       const DataColumn(label: Text('Gyroscope X')),
//       const DataColumn(label: Text('Gyroscope Y')),
//       const DataColumn(label: Text('Gyroscope Z')),
//       const DataColumn(label: Text('Latitude')),
//       const DataColumn(label: Text('Longitude')),
//     ];
//   }

//   List<DataRow> _createDataRows() {
//     List<DataRow> data = <DataRow>[];

//     if (rideData.isNotEmpty) {
//       for (final obs in rideData) {
//         data.add(
//           DataRow(
//             cells: [
//               DataCell(Text(obs.timestamp.toString())),
//               DataCell(Text(obs.accelerometerX.toString())),
//               DataCell(Text(obs.accelerometerY.toString())),
//               DataCell(Text(obs.accelerometerZ.toString())),
//               DataCell(Text(obs.gyroscopeX.toString())),
//               DataCell(Text(obs.gyroscopeY.toString())),
//               DataCell(Text(obs.gyroscopeZ.toString())),
//               DataCell(Text(obs.locationLat.toString())),
//               DataCell(Text(obs.locationLong.toString())),
//             ],
//           ),
//         );
//       }
//     }

//     return data;
//   }

//   Widget _createDataTable() {
//     if (rideData.isNotEmpty) {
//       return DataTable(
//         columns: _createDataColumns(),
//         rows: _createDataRows(),
//       );
//     } else {
//       return const Text('No data available!');
//     }
//   }

//   void getData() {}

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: _createDataTable(),
//         ),
//       ),
//     );
//   }
// }
