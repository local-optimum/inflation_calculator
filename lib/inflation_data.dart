import 'dart:convert';
import 'package:http/http.dart' as http;

String country = 'united-states';

const List<String> cryptoList = ['BTC', 'ETH', 'LTC'];

var apiUrl = 'http://www.statbureau.org/calculate-inflation-price-json';

class InflationData {
  Future getInflationData(
      DateTime startDate, DateTime endDate, double amount) async {
    String requestURL =
        '$apiUrl?country=$country&start=$startDate&end=$endDate&amount=$amount';
    http.Response response = await http.get(Uri.parse(requestURL));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return decodedData;
    } else {
      
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}

//example
//https://www.statbureau.org/calculate-inflation-value-json?start=2020/01/01&country=united-states&end=2020/03/01&amount=100

var apiUrlrate = 'http://www.statbureau.org/calculate-inflation-rate-json';

class InflationRate {
  Future getInflationRate(DateTime startDate, DateTime endDate) async {
    String requestURL =
        '$apiUrlrate?country=$country&start=$startDate&end=$endDate';
    http.Response response = await http.get(Uri.parse(requestURL));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return decodedData;
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}
