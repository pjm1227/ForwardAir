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

class LocationPage extends StatefulWidget {
  final  CurrentPositions fleetData;

  const LocationPage({Key key, this.fleetData})
      : super(key: key);
  @override
  State<LocationPage> createState() => _LocationPage(this.fleetData);
}

class _LocationPage extends State<LocationPage> {
    final  CurrentPositions fleetData; //variable carrying from fleet tracker page which will be used to retrieve lat,long,place,id

  _LocationPage(this.fleetData);//creating constructor with parameter to initialize the fleetdata and streetAddress variable
  Completer<GoogleMapController> _controller = Completer(); //controller is required for the map if any further changes needed in location
    BitmapDescriptor  markerIcon;  //this variable initialized with the icon which is used as marker
    CameraPosition currentLocation; //this is cameraposition of google map needed to zoom camera on specified location
    MapBloc _mapBloc = MapBloc();
    String streetAddress; //this variable is used for the location based based on lat,long and shown when user click on marker or in the bottomSheet


   void initState(){
     _mapBloc.dispatch(FetchLocationEvent(latitude: fleetData.latitude,longitude: fleetData.longitude));
//     getLocationAddress(); //this method will initialize the streetAddress based on lat,long using geoCoder
     super.initState();
   }


  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context); //this method called for creating custom marker


    if (Platform.isAndroid) {
      return SafeArea(
        child: _mainWidget(),
      );
    } else {
      return _mainWidget();
    }
  }


  Widget _mainWidget(){
    return Scaffold(
      appBar:AppBar(
        iconTheme: IconThemeData(color: AppColors.colorWhite),
        title: TextWidget(text:'Location - ${fleetData.unitNbr} ',
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
                streetAddress=state.address;
                 return _mapWidget();
              } else {
                return NoResultFoundWidget();
              }
            }
            if(state is InitialState){
              CurrentPositions locationData=fleetData; // this local variable is required to set lat long for cameraPosition because it accept only static data
              currentLocation= CameraPosition(
                tilt: 89.440717697143555,
                target: LatLng(double.parse(locationData.latitude),double.parse(locationData.longitude)),
                zoom: 9.5746,
              );
              return MapShimmer();
            }
            return MapShimmer();
          },
        ),
      ),
    );
  }

  //this is mapWidget which will be called after successState
  Widget _mapWidget(){
    return  Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
                  markers: _createMarker(),
                  initialCameraPosition: currentLocation,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);

                  },
                ),
          ),
          Container(
            color: AppColors.colorAppBar,
            width:  MediaQuery.of(context).size.width,
            child: Padding(
                padding: EdgeInsets.all(12.0),
                child:TextWidget(text: streetAddress,colorText: AppColors.colorWhite,)),
          ),
        ],
      );

  }



  Future<void> _createMarkerImageFromAsset(BuildContext context) async{
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    if (markerIcon == null) {
      final ImageConfiguration imageConfiguration =
      ImageConfiguration(devicePixelRatio: mediaQueryData.devicePixelRatio);
      BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'images/ic_truck.png')
          .then(_updateBitmap);
    }
  }

  //this method called for initializing icon which will be used for marker
  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      markerIcon = bitmap;  //custom icon initialization after configuration of the icon
    });
  }

  void dispose(){
     currentLocation=null;
    _mapBloc.dispose();
     super.dispose();
  }

  //this method return the set of markers with positions,id,icon etc
  Set<Marker> _createMarker() {

    return <Marker>[
      Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(double.parse(fleetData.latitude),double.parse(fleetData.longitude)),
        infoWindow: InfoWindow(title:streetAddress),
        icon: markerIcon,
        rotation:45.0,
      ),
    ].toSet();
  }


}