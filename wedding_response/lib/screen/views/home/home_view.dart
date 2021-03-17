import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_diary/bloc/guests/bloc.dart';
import 'package:flutter_web_diary/bloc/wedding/bloc.dart';
import 'package:flutter_web_diary/firebase_repository/guest_firebase_repository.dart';
import 'package:flutter_web_diary/firebase_repository/wedding_firebase_repository.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/model/wedding.dart';
import 'package:flutter_web_diary/screen/views/error/error_page.dart';
import 'package:flutter_web_diary/screen/views/home/home_view_desktop.dart';
import 'package:flutter_web_diary/screen/views/home/home_view_tablet_mobile.dart';
import 'package:flutter_web_diary/screen/widgets/centered_view/centered_view.dart';
import 'package:flutter_web_diary/util/globle_variable.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  Wedding selectedWedding;
  ValueChanged<Guest> onTapped;
  HomeView({Key key,@required this.selectedWedding,@required this.onTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeddingBloc>(
          create: (BuildContext context) => WeddingBloc(
            weddingRepository: FirebaseWeddingRepository(),
          )..add(LoadWeddings()),
        ),
      ],
      child: Builder(
        builder: (context) => BlocBuilder(
            cubit: BlocProvider.of<WeddingBloc>(context),
            builder: (context, state) {
              if(state is WeddingLoaded){
                weddings.clear();
                weddings = state.weddings;
                if(weddings.contains(selectedWedding)){
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: Scaffold(
                      backgroundColor: Colors.grey[100],
                      body: CenteredView(
                        child: ScreenTypeLayout(
                          mobile: HomeViewTabletMobile(weddingID: selectedWedding.id ,onTapped: onTapped,),
                          tablet: HomeViewTabletMobile(weddingID: selectedWedding.id,onTapped: onTapped,),
                          desktop: HomeViewDesktop(weddingID: selectedWedding.id,onTapped: onTapped,),
                        ),
                      ),
                    ),
                  );}
                else return UnknownScreen();
              }
              return Container(
                color:  Colors.grey[100],
                child: Center(child: Image.asset(
                  "/favicon-32x32.png",
                ),),
              );
            }),
      ),
    );
  }
}
