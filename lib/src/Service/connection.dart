import 'package:connectivity/connectivity.dart';
import 'package:uahage/src/Controller/connection.controller.dart';

connection() async {
  ConnectivityResult connectResult;
  connectResult = await Connectivity().checkConnectivity();
  print(connectResult);
  ConnectionController.to.connectionState(connectResult.toString());
}
