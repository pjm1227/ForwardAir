import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/events/login_events.dart';
import 'blocs/login_bloc.dart';
import 'blocs/states/login_states.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NavigationDrawer Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeTestPage(),
    );
  }
}

class HomeTestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeTestPage> {
  String title = 'Test';
  Widget _widget;
  LoginBloc _loginBloc = LoginBloc();

  @override
  void initState() {
    _widget = Text('Test Widget');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 108.0),
          child: Column(
            children: <Widget>[
              InkWell(
                child: Text('Menu 1'),
                onTap: () {
                  setState(() {
                    title = "Menu 1";
                  });
                },
              ),
              InkWell(
                child: Text('Menu 2'),
                onTap: () {
                  setState(() {
                    title = "Menu 2";
                  });

                  _loginBloc.dispatch(
                      LoginPressedEvent(userPassword: '', userName: ''));
                },
              ),
              InkWell(
                child: Text('Menu 3'),
                onTap: () {
                  setState(() {
                    title = "Menu 3";
                  });
                },
              )
            ],
          ),
        ),
      ),
      body: BlocListener<LoginBloc, LoginStates>(
        bloc: _loginBloc,
        listener: (context, state) {
          print('Listner state $state');
          if (state is ObSecureState) {}
          if (state is FormErrorState) {
            _widget = Text('Form Error State');
          }
        },
        //Bloc Builder
        child: BlocBuilder<LoginBloc, LoginStates>(
          bloc: _loginBloc,
          builder: (context, state) {
            if (state is FormErrorState) {
              return _widget;
            }
            return _widget;
          },
        ),
      ),
    );
  }
}
