import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_diary/bloc/guests/bloc.dart';
import 'package:flutter_web_diary/firebase_repository/guest_firebase_repository.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/model/wedding.dart';
import 'package:flutter_web_diary/screen/views/error/error_page.dart';
import 'package:flutter_web_diary/screen/views/input_details/input_detail_desktop.dart';
import 'package:flutter_web_diary/screen/views/input_details/input_details_mobile_tablet.dart';
import 'package:flutter_web_diary/screen/widgets/centered_view/centered_view.dart';
import 'package:flutter_web_diary/util/globle_variable.dart';
import 'package:responsive_builder/responsive_builder.dart';

class InputDetailsPage extends StatelessWidget {
  Wedding selectedWedding;
  String selectedGuestID;
  ValueChanged<bool> onTapped;
  InputDetailsPage(
      {Key key,
      @required this.selectedWedding,
      @required this.selectedGuestID,
      @required this.onTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GuestsBloc(
        guestsRepository: FirebaseGuestRepository(),
      )..add(LoadGuestByID(selectedWedding.id, selectedGuestID)),
      child: Builder(
        builder: (context) => BlocBuilder(
          buildWhen: (privous, current){
            if(privous == CompanionChose || current == CompanionChose) return false;
            return true;
          },
          cubit: BlocProvider.of<GuestsBloc>(context),
          builder: (context, state) {
            if (state is GuestsLoadedByID) {
              Guest guest = state.guest;
              if (guest.id == selectedGuestID) {
                return Scaffold(
                  backgroundColor: Colors.white12,
                  body: CenteredView(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ScreenTypeLayout(
                            mobile: InputDetailsMobileTablet(onTapped: onTapped,guest: guest,),
                            tablet: InputDetailsMobileTablet(onTapped: onTapped,guest: guest,),
                            desktop: InputDetailsDesktop(onTapped: onTapped,guest: guest,),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              return UnknownScreen();
            }
            return Container(
              color: Colors.grey[100],
              child: Center(
                child: Image.asset(
                  "/favicon-32x32.png",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
