import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dr_ai/core/utils/constant/api_url.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../model/find_hospital_place_info.dart';

class PlacesWebservices {
  static Dio dio = Dio();

  // static Future<void> fetchNearestHospitals(
  //     double latitude, double longitude) async {
  //   final Map<String, dynamic> queryParameters = {
  //     'location': '$latitude,$longitude',
  //     'radius': '5000',
  //     'type': 'hospital',
  //     'key': ApiUrlManager.googleMap,
  //   };

  //   try {
  //     final response =
  //         await _dio.get(, queryParameters: queryParameters);
  //     if (response.statusCode == 200) {
  //       print('Hospitals data: ${response.data}');
  //       // Handle the received data
  //     } else {
  //       print('Error fetching hospitals: ${response.statusMessage}');
  //     }
  //   } catch (e) {
  //     print('Exception caught: $e');
  //   }
  // }

  //! Fetch Suggetions.
  static Future fetchPlaceSuggestions(String place, String sessionToken, {double? latitude, double? longitude}) async {
    try {
      Response response = await dio.get(
        EnvManager.placeSuggetion,
        queryParameters: {
          'location': '$latitude,$longitude',
          'radius': 5000,
          'input': place,
          'region': 'eg',
          'keyword': 'cruise',
          'types': 'hospital',
          'components': 'country:eg',
          'key': EnvManager.googleMapApiKey,
          'sessiontoken': sessionToken,
        },
      );

      // log(response.data['predictions'].toString());
      // log(response.statusCode.toString());
      // //! DATA MAPING
      // List<dynamic> predictions = response.data['predictions'];
      // List<PlaceSuggestionModel> suggestionList = predictions
      //     .map((prediction) => PlaceSuggestionModel.fromJson(prediction))
      //     .toList();

      return response.data['predictions'];
    } on DioException {
      return Future.error("Place suggestions error: ", StackTrace.fromString("this is the trace"));
    } catch (err) {
      log('Dio Method err:$err');
    }
  }

  //! fetch Location
  static Future fetchPlaceLocation(String placeId, String sessionToken) async {
    try {
      Response response = await dio.get(
        EnvManager.placeLocation,
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': EnvManager.googleMapApiKey,
          'sessiontoken': sessionToken,
        },
      );
      return response.data;
    } on DioException {
      return Future.error("Place location error: ", StackTrace.fromString("this is the trace"));
    } catch (err) {
      log('Dio Method err:$err');
    }
  }

  //! get destination
  static Future getPlaceDirections(LatLng origin, LatLng destination) async {
    try {
      Response response = await dio.get(
        EnvManager.directions,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': EnvManager.googleMapApiKey,
        },
      );
      return response.data;
    } on DioException {
      return Future.error("Place destination error: ", StackTrace.fromString("this is the trace"));
    } catch (err) {
      log('Dio Method err:$err');
    }
  }

  static Future getNearestHospital(double latitude, double longitude, String sessionToken) async {
    final queryParameters = {
      'location': '$latitude,$longitude',
      'radius': '5000',
      'types': 'hospital',
      'key': EnvManager.googleMapApiKey,
      'sessiontoken': sessionToken,
    };

    try {
      final response = await dio.get(EnvManager.nearestHospital, queryParameters: queryParameters);
      // log("Nearby hospitals data are here: ${response.data}");

      for (int i = 0; i < response.data['results'].length; i++) {
        log(response.data['results'][i]['name']);
      }
    } catch (err) {
      log(err.toString());
    }
  }
}

class FindHospitalWebService {
  static final Dio dio = Dio();

  // static Future<List<FindHospitalsPlaceInfo>> getNearestHospital(double latitude, double longitude, double? radius) async {
  //   List<FindHospitalsPlaceInfo> hospitals = [];

  //   log('call getNearestHospital');
  //   final queryParams = {
  //     'location': '$latitude,$longitude',
  //     'radius': radius?.toString() ?? '5000',
  //     // 'types': ['hospital', 'emergency_hospital', 'surgery_hospital'],
  //     'types': 'hospital',
  //     'key': EnvManager.googleMapApiKey,
  //   };
  //   final url = EnvManager.nearestHospital;
  //   log('URL: $url');
  //   log('Query Parameters: $queryParams');
  //   try {
  //     final response = await dio.get(
  //       url,
  //       queryParameters: queryParams,
  //     );

  //     if (response.data == null || response.data['results'] == null) {
  //       log('Response data is null or missing results key');
  //       return hospitals;
  //     }

  //     final List<dynamic> results = response.data['results'];
  //     for (var item in results) {
  //       hospitals.add(FindHospitalsPlaceInfo.fromJson(item));
  //     }
  //   } catch (err) {
  //     log('Error: $err');
  //     return hospitals;
  //   }

  //   return hospitals;
  // }

//!<----------------------------------- new
static Future<List<FindHospitalsPlaceInfo>> getNearestHospital(
    double latitude, double longitude, double? radius) async {
      
  final double maxDistance = radius != null ? radius / 1000.0 : 5.0; 
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  log('call getNearestHospital (Firestore Manual Query)');
  log('User Location: $latitude, $longitude | Max Distance: $maxDistance KM');

  try {
    //!<---------------- fetch data from firestore
    final QuerySnapshot snapshot = await firestore.collection('nearest_hospital').get();

    List<FindHospitalsPlaceInfo> nearbyHospitals = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      
     
      final double hospitalLat = (data['latitude'] is num) ? data['latitude'].toDouble() : 0.0;
      final double hospitalLng = (data['longitude'] is num) ? data['longitude'].toDouble() : 0.0;

      //!<---------------- distance calculation
      double distanceInMeters = Geolocator.distanceBetween(
        latitude,  
        longitude,
        hospitalLat,
        hospitalLng,
      );
      
      double distanceInKm = distanceInMeters / 1000.0;

      //!<---------------- filter by radius
      if (distanceInKm <= maxDistance) {
        //!<---------------- create FindHospitalsPlaceInfo and add to list
        nearbyHospitals.add(
          FindHospitalsPlaceInfo.fromFirestore(doc, distanceInKm)
        );
      }
    }

    //!<---------------- sort by distance
    nearbyHospitals.sort((a, b) {
      double parseDistance(dynamic d) {
        if (d == null) return 0.0;
        if (d is num) return d.toDouble();
        if (d is String) return double.tryParse(d) ?? 0.0;
        return 0.0;
      }

      final da = parseDistance(a.distance);
      final db = parseDistance(b.distance);
      return da.compareTo(db);
    });

    log('Found ${nearbyHospitals.length} hospitals manually within ${maxDistance}km.');
    return nearbyHospitals;

  } catch (err) {
    log('Firestore Manual Query Error: $err');
    return [];
  }
}

}
