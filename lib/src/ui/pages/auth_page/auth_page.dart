import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quizlabsmock/src/blocs/auth_bloc/auth_bloc.dart';
import 'package:quizlabsmock/src/blocs/auth_bloc/auth_bloc_provider.dart';
import 'package:quizlabsmock/src/blocs/loading_bloc/loading_bloc.dart';
import 'package:quizlabsmock/src/models/basic_response.dart';
import 'package:quizlabsmock/src/resources/repository.dart';
import 'package:quizlabsmock/src/ui/pages/home_page/home_page.dart';
import 'package:quizlabsmock/src/ui/pages/landing_page/landing_page.dart';
import 'package:quizlabsmock/src/ui/widgets/button_main.dart';
import 'package:quizlabsmock/src/ui/widgets/form_field_main.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:quizlabsmock/src/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quizlabsmock/src/utils/firebase_analytics_utils.dart';

class AuthPage extends StatefulWidget {

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthBloc _authBloc;

  final _repository = Repository();
  Future<FirebaseUser> user;

  @override
  void didChangeDependencies() {
    _authBloc = AuthBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    user = _repository.firebaseUser;
    super.initState();
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: FutureBuilder(
        future: user,
        builder: (context, AsyncSnapshot<FirebaseUser> firebaseUser) {

          if(firebaseUser.connectionState == ConnectionState.waiting)
            return Center(
              child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            );

          if(firebaseUser.data != null && firebaseUser.data.uid != null) {

            return HomePage(userUUID: firebaseUser.data.uid,);
          }

          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                SizedBox(height: Constants.mediaHeight(context)*.1,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(LandingPage.routeName);
                  },
                  child: Container(
                    child: Text(
                      "QuizLabs",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: ColorUtils.BLUE_MAIN,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Constants.mediaHeight(context)*.025,),
                StreamBuilder(
                  stream: _authBloc.email,
                  builder: (context, snapshot) {
                    return FormFieldMain(
                      hintText: 'email_form'.tr(),
                      onChanged: _authBloc.changeEmail,
                      textInputType: TextInputType.text,
                      obscured: false,
                      errorText: snapshot.error,
                    );
                  },
                ),

                SizedBox(height: Constants.mediaHeight(context)*.025,),
                StreamBuilder(
                  stream: _authBloc.password,
                  builder: (context, snapshot) {
                    return FormFieldMain(
                      hintText: 'password_form'.tr(),
                      onChanged: _authBloc.changePassword,
                      textInputType: TextInputType.text,
                      obscured: true,
                      errorText: snapshot.error,
                    );
                  },
                ),

                SizedBox(height: Constants.mediaHeight(context)*.05,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Builder(builder: (BuildContext context) {
                      return ButtonMain(
                        width: 100,
                        height: 50,
                        colorMain: ColorUtils.BLUE_ACCENT,
                        colorSec: ColorUtils.BLUE_LIGHT,
                        text: "login_btn".tr(),
                        onTap: () async {
                          await FirebaseAnalyticsUtils.analytics.logEvent(name: 'auth_page__login_button_clicked');

                          FocusScope.of(context).requestFocus(FocusNode());
                          Scaffold.of(context).hideCurrentSnackBar();

                          if(_authBloc.canAuthenticate()) {
                            BlocProvider.of<LoadingBloc>(context).add(StartLoad());

                            BasicResponse response = await _authBloc.loginUser();

                            if(response.success) {
                              await FirebaseAnalyticsUtils.analytics.logEvent(name: 'auth_page__login_successful');

                              _authBloc.clearFields();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.green,
                                content: Text(response.message.tr()),
                              ));
                            } else {
                              await FirebaseAnalyticsUtils.analytics.logEvent(name: 'auth_page__login_unsuccessful',
                                  parameters: <String, dynamic> {
                                    'message': response.message
                                  }
                              );

                              BlocProvider.of<LoadingBloc>(context).add(EndLoad());
                              Scaffold.of(context).showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                                content: Text(response.message.tr()),
                              ));
                            }
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red,
                              content: Text("fill_form_correctly".tr()),
                            ));
                          }
                        },
                      );
                    }),


                    SizedBox(width: Constants.mediaWidth(context)*.065,),
                    Builder(builder: (BuildContext context) {
                      return ButtonMain(
                        width: 100,
                        height: 50,
                        colorMain: ColorUtils.GREEN_MAIN,
                        colorSec: ColorUtils.GREEN_LIGHT,
                        text: "register_btn".tr(),
                        onTap: () async {
                          await FirebaseAnalyticsUtils.analytics.logEvent(name: 'auth_page__register_button_clicked');

                          FocusScope.of(context).requestFocus(FocusNode());
                          Scaffold.of(context).hideCurrentSnackBar();

                          if(_authBloc.canAuthenticate()) {
                            BlocProvider.of<LoadingBloc>(context).add(StartLoad());

                            BasicResponse response = await _authBloc.registerUser();

                            if(response.success) {
                              _authBloc.clearFields();
                              await FirebaseAnalyticsUtils.analytics.logEvent(name: 'auth_page__register_successful');
                            }

                            if(!response.success) {
                              await FirebaseAnalyticsUtils.analytics.logEvent(name: 'auth_page__register_unsuccessful',
                                  parameters: <String, dynamic> {
                                    'message': response.message
                                  }
                              );

                              BlocProvider.of<LoadingBloc>(context).add(EndLoad());

                              Scaffold.of(context).showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                                content: Text(response.message.tr()),
                              ));
                            }
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red,
                              content: Text("fill_form_correctly".tr()),
                            ));
                          }
                        },
                      );
                    }),
                  ],
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
