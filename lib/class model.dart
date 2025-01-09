class WeatherModel {
  String name;
  String country;
  double tempMin;
  double tempMax;
  String temp;
  String description;
  int pressure;
  int humidity;
  String icon;

  WeatherModel(this.country, this.description, this.humidity, this.name,
      this.pressure, this.temp, this.tempMax, this.tempMin, this.icon);

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
        map['sys']['country'],
        map['weather'][0]['description'],
        map['main']['humidity'],
        map['name'],
        map['main']['pressure'],
        map['main']['temp'].toString(),
        map['main']['temp_max'],
        map['main']['temp_min'],
        map['weather'][0]['icon']);
  }
}