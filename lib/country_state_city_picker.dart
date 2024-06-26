library country_state_city_picker_nona;

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'model/select_status_model.dart' as StatusModel;

class SelectState extends StatefulWidget {
  final ValueChanged<String>? onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;
  final VoidCallback? onCountryTap;
  final VoidCallback? onStateTap;
  final VoidCallback? onCityTap;
  final TextStyle? style;
  final Color? dropdownColor;
  final Color? boaderColor;
  final String stateTitle;
  final String cityTitle;
  final InputDecoration decoration;
  final double spacing;

  const SelectState(
      {Key? key,
      this.onCountryChanged,
      required this.stateTitle,
      required this.cityTitle,
      required this.boaderColor,
      required this.onStateChanged,
      required this.onCityChanged,
      this.decoration =
          const InputDecoration(contentPadding: EdgeInsets.all(0.0)),
      this.spacing = 0.0,
      this.style,
      this.dropdownColor,
      this.onCountryTap,
      this.onStateTap,
      this.onCityTap})
      : super(key: key);

  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  List<String> _cities = ["Choose City"];
  List<String> _country = ["Choose Country"];
  String _selectedCity = "Choose City";
  String _selectedCountry = "select Country";
  String _selectedState = "Choose State/Province";
  List<String> _states = ["Choose State/Province"];
  var responses;

  @override
  void initState() {
    getState('🇵🇰    Pakistan');

    super.initState();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    countryres.forEach((data) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) return;
      setState(() {
        _country.add(model.emoji! + "    " + model.name!);
      });
    });

    return _country;
  }

  Future getState(String value) async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == value)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.name).toList();
        for (var statename in name) {
          print(statename.toString());

          _states.add(statename.toString());
        }
      });
    });

    return _states;
  }

  Future getCity() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      var name = f.where((item) => item.name == _selectedState);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesname = ci.map((item) => item.name).toList();
          for (var citynames in citiesname) {
            print(citynames.toString());

            _cities.add(citynames.toString());
          }
        });
      });
    });
    print('bbbbbbbbb$_cities');
    return _cities;
  }

  void _onSelectedState(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = "Choose City";
      _cities = ["Choose City"];
      _selectedState = value;
      this.widget.onStateChanged(value);
      getCity();
    });
  }

  void _onSelectedCity(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = value;
      this.widget.onCityChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // DropdownSearch<String>(
        //   items: _country,
        //   dropdownBuilder: (context, selectedItem) {
        //     return Container(
        //         child: selectedItem != null
        //             ? Text(
        //                 selectedItem,
        //                 style: TextStyle(
        //                   color: Color(0xff0F1031),
        //                   fontSize: 11,
        //                 ),
        //               )
        //             : null);
        //   },
        //   popupProps: PopupProps.menu(
        //     disabledItemFn: (value) => value == "Choose Country",
        //     showSearchBox: true,
        //     searchFieldProps: TextFieldProps(autofocus: true),
        //     // showSelectedItems: true,
        //   ),
        //   dropdownDecoratorProps: DropDownDecoratorProps(
        //     dropdownSearchDecoration: InputDecoration(
        //         labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
        //         label: Text('Choose Country'),
        //         contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        //         border: OutlineInputBorder(
        //             borderRadius: BorderRadius.all(Radius.circular(10))),
        //         enabledBorder: OutlineInputBorder(
        //             borderRadius: BorderRadius.all(Radius.circular(10)),
        //             borderSide: BorderSide(color: Color(0xffBBC2C9))),
        //         focusedBorder: OutlineInputBorder(
        //             borderRadius: BorderRadius.all(Radius.circular(10)),
        //             borderSide: BorderSide(color: Color(0xff0F1031))),
        //         floatingLabelBehavior: FloatingLabelBehavior.auto),
        //   ),
        //   onChanged: (value) => _onSelectedCountry(value!),
        // ),
        SizedBox(
          height: widget.spacing,
        ),
        Text(widget.stateTitle),
        SizedBox(
          height: 08,
        ),
        DropdownSearch<String>(
            items: _states,
            dropdownBuilder: (context, selectedItem) {
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: selectedItem != null
                      ? Text(
                          selectedItem,
                          style: TextStyle(
                            color: Color(0xff0F1031),
                            fontSize: 14,
                          ),
                        )
                      : null);
            },
            popupProps: PopupProps.menu(
              disabledItemFn: (value) => value == "Choose  State/Province",
              showSearchBox: true,
              searchFieldProps: TextFieldProps(autofocus: true),
              // showSelectedItems: true,
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: widget.boaderColor!)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: widget.boaderColor!)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto),
            ),
            onChanged: (value) {
              setState(() {
                _onSelectedState(value!);
              });
            }),
        SizedBox(
          height: 15,
        ),
        Text(widget.stateTitle),
        SizedBox(
          height: 08,
        ),
        DropdownSearch<String>(
          items: _cities,
          dropdownBuilder: (context, selectedItem) {
            return Container(
                child: selectedItem != null
                    ? Text(
                        selectedItem,
                        style: TextStyle(
                          color: Color(0xff0F1031),
                          fontSize: 14,
                        ),
                      )
                    : null);
          },
          popupProps: PopupProps.menu(
            disabledItemFn: (value) => value == "Choose City",
            showSearchBox: true,
            searchFieldProps: TextFieldProps(autofocus: true),
            // showSelectedItems: true,
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: widget.boaderColor!)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: widget.boaderColor!)),
                floatingLabelBehavior: FloatingLabelBehavior.auto),
          ),
          onChanged: (value) => _onSelectedCity(value!),
        ),
      ],
    );
  }
}
