import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:one_food/session/session_data.dart';

class MyGeoCoder{


  static dynamic addressFromLatLong(double latitude,double longitude) async {

    var url = "http://fayaz07.epizy.com/geocode.php";

    //url = "https://mobile-app-devs.000webhostapp.com/geocode.php";

    url = "http://fayaz07.epizy.com/conn.php";


   // var response = await post(url,body: {"lati":"$latitude","longi":"$longitude"},headers: {"accept":"application/json"});

    var response = await get(url);
    print(response.body);

    var jsonData = json.decode(response.body);

    SessionData.userPosition.localAddress = jsonData["display_name"];

    return jsonData;
  }

}
/*
{
"place_id":"163478936",
"licence":"https:\/\/locationiq.com\/attribution",
"osm_type":"way",
"osm_id":"366103652",
"lat":"18.7894145564649",
"lon":"78.2894007186767",
"display_name":"Armoor, Nizamabad District, Telangana, 503200, India",
"address":{
  "town":"Armoor",
  "state_district":"Nizamabad District",
  "state":"Telangana",
  "postcode":"503200",
  "country":"India",
  "country_code":"in"
  },
"boundingbox":
[
"18.7891048",
"18.795192",
"78.2893015",
"78.2965131"
]
}
 */