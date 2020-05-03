import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Ever/services/authentication.dart';
import 'package:Ever/template/colors.dart';
import 'package:Ever/template/style.dart';

class noGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final userDatabase = FirebaseDatabase.instance.reference().child("user");

  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;
  String _name;
  String _phoneNumber;
  String _dateOfBirth;
  String _gender;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);

          // widget.auth.sendEmailVerification();
          // _showVerifyEmailSentDialog();

          userDatabase.child(userId).set({
            'userID': userId,
            'userName': _name,
            'userEmail': _email,
            'userPhone': _phoneNumber,
            'userDOB': _dateOfBirth,
            'userGender': _gender,
            'userIdenURL': 'UserIdenURL',
            'userActiveEvent': null,
            'userPastEvent': null,
            'isVerified': 0,
            'organizationID': null
          });

          _isLoginForm = !_isLoginForm;
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: _isLoginForm ? 350.0 : 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                      color: darkBackgroundColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _isLoginForm ? 240.0 : 90.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_isLoginForm ? 'Login' : 'Create Account',
                              style: header),
                          Text(
                              _isLoginForm
                                  ? 'Please sign in to continue'
                                  : 'Please sign up to continue',
                              style: tagline)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: noGlowBehavior(),
                  child: ListView(
                    children: <Widget>[
                      _showForm(),
                      showPrimaryButton(),
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: showSecondaryButton(),
          )
        ],
      ),
    );
  }

  // void _showVerifyEmailSentDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Verify your account"),
  //         content:
  //             new Text("Link to verify account has been sent to your email"),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: new Text("Dismiss"),
  //             onPressed: () {
  //               toggleFormMode();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _showForm() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[showAll()],
        ),
      ),
    );
  }

  Widget showAll() {
    if (_isLoginForm) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          showEmailInput(),
          showPasswordInput(),
          showErrorMessage(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          showUsernameInput(),
          showEmailInput(),
          showPasswordInput(),
          showPhoneNumberInput(),
          showDateOfBirthInput(),
          showGenderInput(),
          showErrorMessage(),
        ],
      );
    }
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showUsernameInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: false,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Full Name',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Fullname can\'t be empty' : null,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget showPhoneNumberInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: false,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Phone Number',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Phone number can\'t be empty' : null,
        onSaved: (value) => _phoneNumber = value.trim(),
      ),
    );
  }

  Widget showDateOfBirthInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: false,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Date of Birth',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Date of Birth can\'t be empty' : null,
        onSaved: (value) => _dateOfBirth = value.trim(),
      ),
    );
  }

  Widget showGenderInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: false,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Gender',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Gender can\'t be empty' : null,
        onSaved: (value) => _gender = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(250.0, 10.0, 30.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          color: orange,
          child: new Text(_isLoginForm ? 'Sign In' : 'Sign Up',
              style: new TextStyle(fontSize: 14.0, color: Colors.white)),
          onPressed: validateAndSubmit,
        ),
      ),
    );
  }

  Widget showSecondaryButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _isLoginForm
              ? 'Don\'t have an account? '
              : 'Already have an account? ',
          style: bottomText,
        ),
        InkWell(
          child: Text(
            _isLoginForm ? 'Sign Up' : 'Sign In',
            style: bottomSign,
          ),
          onTap: toggleFormMode,
        ),
      ],
    );
  }
}
