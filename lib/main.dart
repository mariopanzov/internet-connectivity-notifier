import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        ConnectivityChangeNotifier changeNotifier =
            ConnectivityChangeNotifier();
        changeNotifier.initialLoad();
        return changeNotifier;
      },
      child: MaterialApp(
        title: 'Internet Connection Notifier',
        // theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Widget myWidget =
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internet Connection Notifier'),
      ),
      body: Center(

          //builder rebilds when the data from the provider changes
          // child: Consumer<ConnectivityChangeNotifier>(
          //   builder: (_, connectivityChangeNotifier, __) {
          //     if (connectivityChangeNotifier.connection_status) {
          //       return Text('ONLINE',
          //           style: TextStyle(color: Colors.green[200], fontSize: 50));
          //     } else {
          //       return Text('OFFLINE',
          //           style: TextStyle(color: Colors.red[600], fontSize: 50));
          //     }
          //   },
          // ),

          //used selector because only one value is needed from the provider
          //builder rebilds when the data from the provider changes
          child: Selector<ConnectivityChangeNotifier, bool>(
        selector: (context, connectivityChangeNotifier) =>
            connectivityChangeNotifier.connection_status,
        builder: (context, value, child) {
          if (value) {
            return Text('ONLINE',
                style: TextStyle(color: Colors.green[200], fontSize: 50));
          } else {
            return Text('OFFLINE',
                style: TextStyle(color: Colors.red[600], fontSize: 50));
          }
        },
      )),
    );
  }
}

class ConnectivityChangeNotifier extends ChangeNotifier {
  ConnectivityChangeNotifier() {
    //runs when connectivity changed
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      //call function for handling result
      resultHandler(result);
    });
  }
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool _isconnected = true;

//get methods
  //ConnectivityResult get connectivity => _connectivityResult;
  bool get connection_status => _isconnected;

  void initialLoad() async {
    //runs at start to to get primary connection status when starting the app
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    resultHandler(connectivityResult);
  }

//result handler function
  void resultHandler(ConnectivityResult result) {
    _connectivityResult = result;
    if (result == ConnectivityResult.none) {
      _isconnected = false;
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      _isconnected = true;
    }
    notifyListeners();
  }
}
