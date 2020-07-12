import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizlabsmock/src/blocs/user_bloc/user_bloc.dart';
import 'package:quizlabsmock/src/blocs/user_bloc/user_bloc_provider.dart';
import 'package:quizlabsmock/src/models/user.dart';
import 'package:quizlabsmock/src/utils/color_utils.dart';
import 'package:quizlabsmock/src/utils/constants.dart';

class RankingTab extends StatefulWidget {
  @override
  _RankingTabState createState() => _RankingTabState();
}

class _RankingTabState extends State<RankingTab> {

  UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    _userBloc = UserBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        Positioned(
          top: Constants.mediaHeight(context)*.01,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Ranking",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: ColorUtils.GRAY_TEXT_LIGHT,
                  fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            ),
          ),
        ),

        Positioned(
          bottom: Constants.mediaHeight(context)*.06,
          child: Container(
            height: Constants.mediaHeight(context)*.70,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: ColorUtils.ORANGE_LIGHT, boxShadow: [
              new BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 10.0,
                  offset: Offset(0, -3)),
            ]),
            width: Constants.mediaWidth(context),
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: StreamBuilder(
              stream: _userBloc.getTenFirstRakingUsersAsc(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: Container(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  );

                if(snapshot.data == null)
                  return Center(
                    child: Text(
                      "No data to show...",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  );

                List<User> users = [];

                if(snapshot.data.documents.isNotEmpty)
                  snapshot.data.documents.forEach((doc) {
                    users.add(User.fromDocument(doc));
                  });

                return _raking(users);
              },
            ),
          ),
        ),
        
        
      ],
    );
  }

  Widget _raking(List<User> users) => Container(
    child: users.length > 0 ? ListView.builder(
      itemCount: users.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: Constants.mediaWidth(context)*.3,
                child: Text(
                  (index+1).toString(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  ),
                ),
              ),

              Container(
                width: Constants.mediaWidth(context)*.3,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    users[index].username,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              Container(
                width: Constants.mediaWidth(context)*.3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    users[index].points.toString(),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                    ),
                  ),
                )
              ),
            ],
          ),
        );
      },
    ) : Center(
      child: Text(
        "Waiting for amazing users to show here... :D",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25
        ),
      ),
    ),
  );
}
