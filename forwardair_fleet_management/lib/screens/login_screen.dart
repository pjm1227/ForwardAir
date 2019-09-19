import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forwardair_fleet_management/blocs/barrels/login.dart';
import 'package:forwardair_fleet_management/components/button_widget.dart';
import 'package:forwardair_fleet_management/utility/utils.dart';
import 'package:forwardair_fleet_management/screens/drawermenu.dart';

/*class LoginPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fleet Owner',
      debugShowCheckedModeBanner: false,
      home: LoginPageHome(),
    );
  }
}*/

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  LoginBloc _loginBloc = LoginBloc();
  var _textControllerEmail;
  var _textControllerPassword;

//Used for visible/invisible password
  var isPasswordVisible = true;

  //To Dispose the Loginbloc
  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textControllerEmail = TextEditingController();
    _textControllerPassword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //For status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // status bar color
    ));
    //Returns a Scaffold
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      //Bloc Listener
      body: BlocListener<LoginBloc, LoginStates>(
        bloc: _loginBloc,
        listener: (context, state) {
          print('Listner state $state');
          if (state is ObSecureState) {
            print(state.isVisible);
            isPasswordVisible = state.isVisible;
          }
          if (state is FormErrorState) {
            Utils.showSnackBar(state.errorMessage, context);
          }
        },
        //Bloc Builder
        child: BlocBuilder<LoginBloc, LoginStates>(
          bloc: _loginBloc,
          builder: (context, state) {
            print('Login State $state');
            /* if (state is LoginLoadingState) {
              return Center(child: CircularProgressIndicator());
            }*/
            if (state is LoginSuccessState) {
              return HomePage();
            }
            return _initialWidget(state);
          },
        ),
      ),
    );
  }

  //Initial Widget for Login
  Widget _initialWidget(LoginStates state) {
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
            child:
                /*ListView(
              shrinkWrap: true,
              children: <Widget>[*/
                SingleChildScrollView(
              child: Padding(
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
                            labelText: "User Email",
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
                          controller: _textControllerPassword,
                          obscureText: isPasswordVisible,
                          decoration: new InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () => _loginBloc.dispatch(ObSecureEvent(
                                  isVisible: isPasswordVisible == false
                                      ? true
                                      : false)),
                              child: Icon(
                                isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
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
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          height: 50,
                          child: ButtonWidget(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              _loginBloc.dispatch(LoginPressedEvent(
                                  userName: _textControllerEmail.text,
                                  userPassword: _textControllerPassword.text));
                            },
                            text: 'LOGIN',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /*   ],
            ),*/
          ),
        ),
        Container(
          child: state is LoginLoadingState
              ? Opacity(
                  opacity: 0.4,
                  child: const ModalBarrier(
                      dismissible: false, color: Colors.grey),
                )
              : null,
        ),
        Center(
          child:
              state is LoginLoadingState ? CircularProgressIndicator() : null,
        ),
      ],
    );
  }
}
