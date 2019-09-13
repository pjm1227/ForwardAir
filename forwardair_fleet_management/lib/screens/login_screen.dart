import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/blocs/barrels/login.dart';
import 'package:forwardair_fleet_management/components/button_widget.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  LoginBloc _loginBloc = LoginBloc();
  var _textControllerEmail = TextEditingController();
  var _textControllerpassword = TextEditingController();

  var isPasswordVisible = true;
  var textPassword;

  @override
  void initState() {
    //_textControllerEmail = TextEditingController();
    // _textControllerpassword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //For status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // status bar color
    ));
    print("Build Called");
    return Scaffold(
      body: BlocListener<LoginBloc, LoginStates>(
        bloc: _loginBloc,
        listener: (context, state) {
          if (state is ObSecureState) {
            print(state.isVisible);
            isPasswordVisible = state.isVisible;
          }
          if (state is FormErrorState) {
            Utils.showSnackBar(state.emailError, context);
          }
        },
        child: BlocBuilder<LoginBloc, LoginStates>(
          bloc: _loginBloc,
          builder: (context, state) {
            print('Login State $state');
            if (state is ObSecureState) {
              return Scaffold(body: _initialWidget());
            } else if (state is LoginLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is LoginSuccessState) {
              return Center(child: Text('UserLogged IN'));
            } else {
              return _initialWidget();
            }
          },
        ),
      ),
    );
  }

  //Initial Widget for Login
  Widget _initialWidget() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Align(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset('images/ic_fa_logo.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: TextField(
                            controller: _textControllerEmail,
                            decoration: new InputDecoration(
                              labelText: "User Name",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: TextField(
                            controller: _textControllerpassword,
                            obscureText: isPasswordVisible,
                            decoration: new InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () => _loginBloc.dispatch(ObSecureEvent(
                                    isVisible: isPasswordVisible == false
                                        ? true
                                        : false)),
                                child: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  semanticLabel: isPasswordVisible
                                      ? 'show password'
                                      : 'hide password',
                                ),
                              ),
                              labelText: "Password",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ButtonWidget(
                            onPressed: () => _loginBloc.dispatch(
                                LoginPressedEvent(
                                    userName: _textControllerEmail.text,
                                    userPassword:
                                        _textControllerpassword.text)),
                            text: 'LOGIN',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
