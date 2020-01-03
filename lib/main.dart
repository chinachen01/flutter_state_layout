import 'package:flutter/material.dart';
import 'package:state_layout/state_layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StateLayoutDemo(),
    );
  }
}

class StateLayoutDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StateLayoutDemoState();
  }
}

class _StateLayoutDemoState extends State<StateLayoutDemo> {
  StateLayoutContoller _contoller = StateLayoutContoller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('state layout'),
      ),
      body: StateLayout<int>(
        future: _fetchData,
        builder: (count) {
          return Column(
            children: <Widget>[
              Text('数量是: $count'),
              RaisedButton(
                child: Text('to next'),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text('test page'),
                                ),
                                body: Text('test'),
                              )));
                  _contoller.callRefresh();
                },
              )
            ],
          );
        },
        contoller: _contoller,
      ),
    );
  }

  Future<int> _fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    print('fetch data');
    return 1;
  }
}
