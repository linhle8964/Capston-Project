import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();

}

class _FilterState extends State<Filter> {
  var selectedRange = RangeValues(400, 1000);
  String cityValue;
  String stateValue;
  String countryValue;

  @override
  Widget build(BuildContext context) {
    var _category;
    List<String> categories = ["1", "2", "#", "4", "5", "6"];
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(right: 24, left: 24, top: 32, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "your search",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Text(
                  "City",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(child: SelectState(
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = "VietNam" ;
                    });
                  },
                  onStateChanged:(value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged:(value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),)

              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption(String text, bool selected) {
    return Container(
      height: 45,
      width: 65,
      decoration: BoxDecoration(
          color: selected ? Colors.blue[900] : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            width: selected ? 0 : 1,
            color: Colors.grey,
          )),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
