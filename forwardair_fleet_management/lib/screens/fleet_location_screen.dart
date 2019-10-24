import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:forwardair_fleet_management/blocs/events/map_event.dart';
import 'package:forwardair_fleet_management/blocs/map_bloc.dart';
import 'package:forwardair_fleet_management/blocs/states/map_state.dart';
import 'package:forwardair_fleet_management/components/no_internet_connection.dart';
import 'package:forwardair_fleet_management/components/no_result_found.dart';
import 'package:forwardair_fleet_management/components/shimmer/google_map_shimmer.dart';
import 'package:forwardair_fleet_management/components/text_widget.dart';
import 'package:forwardair_fleet_management/models/fleetTracker/fleet_tracker_model.dart';
import 'package:forwardair_fleet_management/utility/colors.dart';
import 'package:forwardair_fleet_management/utility/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';

class FleetLocationPage extends StatefulWidget {
  final CurrentPositions fleetData;

  const FleetLocationPage({Key key, this.fleetData}) : super(key: key);

  @override
  State<FleetLocationPage> createState() => _LocationPage(this.fleetData);
}

class _LocationPage extends State<FleetLocationPage> {
  //Fleet Data
  final CurrentPositions fleetData;
//Constructor
  _LocationPage(this.fleetData);

  Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor markerIcon;

  CameraPosition currentLocation;

  MapBloc _mapBloc = MapBloc();
  String streetAddress;

  void initState() {
    _mapBloc.dispatch(FetchLocationEvent(
        latitude: fleetData.latitude, longitude: fleetData.longitude));
    _createMarkerImageFromAsset();
    currentLocation = CameraPosition(
      tilt: 89.440717697143555,
      target: LatLng(
          double.parse(fleetData.latitude), double.parse(fleetData.longitude)),
      zoom: 9.5746,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return SafeArea(
        child: _mainWidget(),
      );
    } else {
      return _mainWidget();
    }
  }

  Widget _mainWidget() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.colorWhite),
        title: TextWidget(
            text: 'Location - ${fleetData.unitNbr} ',
            textType: TextType.TEXT_LARGE,
            colorText: AppColors.colorWhite),
      ),
      body: BlocListener<MapBloc, MapState>(
        listener: (context, state) {},
        bloc: _mapBloc,
        child: BlocBuilder<MapBloc, MapState>(
          bloc: _mapBloc,
          builder: (context, state) {
            if (state is LocationErrorState) {
              if (state.errorMessage == Constants.NO_INTERNET_FOUND) {
                return NoInternetFoundWidget();
              } else {
                return NoResultFoundWidget();
              }
            }
            //If state is success then map will be shown
            if (state is LocationSuccessState) {
              if (state.address != null) {
                streetAddress = state.address;
                return _mapWidget();
              } else {
                return NoResultFoundWidget();
              }
            }
            return MapShimmer();
          },
        ),
      ),
    );
  }

  //this is mapWidget which will be called after successState to implement map
  Widget _mapWidget() {
    //column widget will hold the map and bottom bar
    return Column(
      children: <Widget>[
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            markers: _createMarker(),
            initialCameraPosition: currentLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),

        //this widget to show the address in bottom
        Container(
          color: AppColors.colorAppBar,
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextWidget(
                text: streetAddress,
                colorText: AppColors.colorWhite,
              )),
        ),
      ],
    );
  }
//Creating custom Icon for marker
  Future<void> _createMarkerImageFromAsset() async {
    await Future.delayed(Duration.zero);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final ImageConfiguration imageConfiguration =
        ImageConfiguration(devicePixelRatio: mediaQueryData.devicePixelRatio);
    BitmapDescriptor.fromAssetImage(imageConfiguration, 'images/ic_truck.png')
        .then((bitmap) {
      markerIcon = bitmap;
    });
  }

  void dispose() {
    currentLocation = null;
    _mapBloc.dispose();
    super.dispose();
  }

//This method create a custom marker with info window.
  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(double.parse(fleetData.latitude),
            double.parse(fleetData.longitude)),
        infoWindow: InfoWindow(title: streetAddress),
        icon: markerIcon,
        rotation: 45.0,
      ),
    ].toSet();
  }
}
