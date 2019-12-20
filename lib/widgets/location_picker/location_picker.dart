import 'dart:async';
import 'dart:convert';

import 'package:Rely/models/auto_complete.dart';
import 'package:Rely/models/location_result.dart';
import 'package:Rely/models/nearby_places.dart';
import 'package:Rely/provider/location_provider.dart';
import 'package:Rely/services/i18n.dart';
import 'package:Rely/widgets/location_picker/map.dart';
import 'package:Rely/widgets/location_picker/rich_suggestion.dart';
import 'package:Rely/widgets/location_picker/search_input.dart';
import 'package:Rely/widgets/location_picker/uuid.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class LocationPicker extends StatefulWidget {
  LocationPicker(
    this.apiKey, {
    Key key,
    this.initialCenter,
    this.requiredGPS,
    this.myLocationButtonEnabled,
    this.layersButtonEnabled,
    this.mapStylePath,
    this.appBarColor,
    this.searchBarBoxDecoration,
    this.hintText,
    this.resultCardConfirmWidget,
    this.resultCardAlignment,
    this.resultCardDecoration,
    this.resultCardPadding,
  });

  final String apiKey;

  final LatLng initialCenter;

  final bool requiredGPS;
  final bool myLocationButtonEnabled;
  final bool layersButtonEnabled;

  final String mapStylePath;

  final Color appBarColor;
  final BoxDecoration searchBarBoxDecoration;
  final String hintText;
  final Widget resultCardConfirmWidget;
  final Alignment resultCardAlignment;
  final Decoration resultCardDecoration;
  final EdgeInsets resultCardPadding;

  static Future<LocationResult> pickLocation(
    BuildContext context,
    String apiKey, {
    LatLng initialCenter = const LatLng(45.521563, -122.677433),
    bool requiredGPS = true,
    bool myLocationButtonEnabled = true,
    bool layersButtonEnabled = true,
    String mapStylePath,
    Color appBarColor = Colors.transparent,
    BoxDecoration searchBarBoxDecoration,
    String hintText,
    Widget resultCardConfirmWidget,
    AlignmentGeometry resultCardAlignment,
    EdgeInsetsGeometry resultCardPadding,
    Decoration resultCardDecoration,
  }) async {
    final results = await Navigator.of(context).push(
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) {
          return LocationPicker(
            apiKey,
            initialCenter: initialCenter,
            requiredGPS: requiredGPS,
            myLocationButtonEnabled: myLocationButtonEnabled,
            layersButtonEnabled: layersButtonEnabled,
            mapStylePath: mapStylePath,
            appBarColor: appBarColor,
            hintText: hintText,
            searchBarBoxDecoration: searchBarBoxDecoration,
            resultCardConfirmWidget: resultCardConfirmWidget,
            resultCardAlignment: resultCardAlignment,
            resultCardPadding: resultCardPadding,
            resultCardDecoration: resultCardDecoration,
          );
        },
      ),
    );

    if (results != null && results.containsKey('location')) {
      return results['location'];
    } else {
      return null;
    }
  }

  @override
  LocationPickerState createState() => LocationPickerState();
}

class LocationPickerState extends State<LocationPicker> {
  LocationResult locationResult;

  OverlayEntry overlayEntry;

  List<NearbyPlace> nearbyPlaces = List();

  String sessionToken = Uuid().generateV4();

  var mapKey = GlobalKey<MapPickerState>();

  var appBarKey = GlobalKey();

  var searchInputKey = GlobalKey<SearchInputState>();

  bool hasSearchTerm = false;

  void clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  void searchPlace(String place) {
    if (context == null) return;

    clearOverlay();

    setState(() => hasSearchTerm = place.length > 0);

    if (place.length < 1) return;

    final RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;

    final RenderBox appBarBox = appBarKey.currentContext.findRenderObject();

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: appBarBox.size.height,
        width: size.width,
        child: Material(
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: Text(
                    S.of(context)?.finding_place ?? 'Finding place...',
                    style: TextStyle(fontSize: 16, color: Color(0xff4564e5), fontFamily: 'Standard'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    autoCompleteSearch(place);
  }

  void autoCompleteSearch(String place) {
    place = place.replaceAll(" ", "+");
    var endpoint =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?" +
            "key=${widget.apiKey}&" +
            "input={$place}&sessiontoken=$sessionToken";

    if (locationResult != null) {
      endpoint += "&location=${locationResult.latLng.latitude}," +
          "${locationResult.latLng.longitude}";
    }
    http.get(endpoint).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> predictions = data['predictions'];

        List<RichSuggestion> suggestions = [];

        if (predictions.isEmpty) {
          AutoCompleteItem aci = AutoCompleteItem();
          aci.text = S.of(context)?.no_result_found ?? 'No result found';
          aci.offset = 0;
          aci.length = 0;

          suggestions.add(RichSuggestion(aci, () {}));
        } else {
          for (dynamic t in predictions) {
            AutoCompleteItem aci = AutoCompleteItem();

            aci.id = t['place_id'];
            aci.text = t['description'];
            aci.offset = t['matched_substrings'][0]['offset'];
            aci.length = t['matched_substrings'][0]['length'];

            suggestions.add(RichSuggestion(aci, () {
              decodeAndSelectPlace(aci.id);
            }));
          }
        }

        displayAutoCompleteSuggestions(suggestions);
      }
    }).catchError((error) {
      print(error);
    });
  }

  void decodeAndSelectPlace(String placeId) {
    clearOverlay();

    String endpoint =
        "https://maps.googleapis.com/maps/api/place/details/json?key=${widget.apiKey}" +
            "&placeid=$placeId";

    http.get(endpoint).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> location =
            jsonDecode(response.body)['result']['geometry']['location'];

        LatLng latLng = LatLng(location['lat'], location['lng']);

        moveToLocation(latLng);
      }
    }).catchError((error) {
      print(error);
    });
  }

  void displayAutoCompleteSuggestions(List<RichSuggestion> suggestions) {
    final RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;

    final RenderBox appBarBox = appBarKey.currentContext.findRenderObject();

    clearOverlay();

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        top: appBarBox.size.height,
        child: Material(
          elevation: 1,
          child: Column(
            children: suggestions,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

 
  void getNearbyPlaces(LatLng latLng) {
    http
        .get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?" +
            "key=${widget.apiKey}&" +
            "location=${latLng.latitude},${latLng.longitude}&radius=150")
        .then((response) {
      if (response.statusCode == 200) {
        nearbyPlaces.clear();
        for (Map<String, dynamic> item
            in jsonDecode(response.body)['results']) {
          NearbyPlace nearbyPlace = NearbyPlace();

          nearbyPlace.name = item['name'];
          nearbyPlace.icon = item['icon'];
          double latitude = item['geometry']['location']['lat'];
          double longitude = item['geometry']['location']['lng'];

          LatLng _latLng = LatLng(latitude, longitude);

          nearbyPlace.latLng = _latLng;

          nearbyPlaces.add(nearbyPlace);
        }
      }

      setState(() {
        hasSearchTerm = false;
      });
    }).catchError((error) {});
  }

  Future reverseGeocodeLatLng(LatLng latLng) async {
    var response = await http.get(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}"
        "&key=${widget.apiKey}");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);

      String road =
          responseJson['results'][0]['address_components'][0]['short_name'];

      setState(() {
        locationResult = LocationResult();
        locationResult.address = road;
        locationResult.latLng = latLng;
      });
    }
  }

  void moveToLocation(LatLng latLng) {
    mapKey.currentState.mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 16,
          ),
        ),
      );
    });

    reverseGeocodeLatLng(latLng);

    getNearbyPlaces(latLng);
  }

  @override
  void dispose() {
    clearOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            
            iconTheme: Theme.of(context).iconTheme,
            elevation: 0,
            backgroundColor:  widget.appBarColor,
            key: appBarKey,
            title: SearchInput(
              (input) => searchPlace(input),
              key: searchInputKey,
              boxDecoration: widget.searchBarBoxDecoration,
            ),
          ),
          body: MapPicker(
            widget.apiKey,
            initialCenter: widget.initialCenter,
            requiredGPS: widget.requiredGPS,
            myLocationButtonEnabled: widget.myLocationButtonEnabled,
            layersButtonEnabled: widget.layersButtonEnabled,
            mapStylePath: widget.mapStylePath,
            appBarColor: widget.appBarColor,
            searchBarBoxDecoration: widget.searchBarBoxDecoration,
            hintText: widget.hintText,
            resultCardConfirmWidget: widget.resultCardConfirmWidget,
            resultCardAlignment: widget.resultCardAlignment,
            resultCardDecoration: widget.resultCardDecoration,
            resultCardPadding: widget.resultCardPadding,
            key: mapKey,
          ),
        );
      }),
    );
  }
}