import 'package:flutter/material.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 100.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 60.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);

const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
);

const kTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(
    Icons.location_city,
    color: Colors.white,
  ),
  hintText: 'Enter City Name',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide.none,
  ),
);

String getWeatherIcon(int condition) {
  if (condition < 300) {
    return '🌩';
  } else if (condition < 400) {
    return '🌧';
  } else if (condition < 600) {
    return '☔️';
  } else if (condition < 700) {
    return '☃️';
  } else if (condition < 800) {
    return '🌫';
  } else if (condition == 800) {
    return '☀️';
  } else if (condition <= 804) {
    return '☁️';
  } else {
    return '🤷‍';
  }
}

String getMessage(double temp) {
  if (temp > 25) {
    return 'It\'s 🍦 time';
  } else if (temp > 20) {
    return 'Time for shorts and 👕';
  } else if (temp < 10) {
    return 'You\'ll need 🧣 and 🧤';
  } else {
    return 'Bring a 🧥 just in case';
  }
}
