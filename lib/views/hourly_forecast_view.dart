import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/extensions/int.dart';
import 'package:weather_app/providers/hourly_weather_provider.dart';

import '../constants/app_colors.dart';
import '../constants/text_styles.dart';
import '../utils/get_weather_icons.dart';

// HourlyForecastView is a ConsumerWidget that listens to weather data updates and displays the hourly forecast
class HourlyForecastView extends ConsumerWidget {
  const HourlyForecastView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the weather provider, which returns either data, error, or loading states
    final hourlyWeatherData = ref.watch(hourlyWeatherProvider);

    // Handling different states (data, error, loading)
    return hourlyWeatherData.when(
      data: (hourlyWeather) {
        // Displays a horizontal list of hourly forecast data when available
        return SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: hourlyWeather.cnt, // Number of forecast items
            shrinkWrap: true, // Makes sure the list takes only as much space as needed
            scrollDirection: Axis.horizontal, // Scrolls horizontally
            itemBuilder: (context, index) {
              final weather = hourlyWeather.list[index]; // Fetches weather data for each hour
              return HourlyForecastTile(
                id: weather.weather[0].id, // Weather condition ID used for the weather icon
                hour: weather.dt.time, // Time for the hourly forecast
                temp: weather.main.temp.round(), // Rounded temperature
                isActive: index == 0, // Highlights the first item (current hour) as active
              );
            },
          ),
        );
      },
      error: (error, stackTree) {
        // Displays the error message in case of a failure
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        // Displays a loading indicator while data is being fetched
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

// HourlyForecastTile is a StatelessWidget representing a single forecast tile
class HourlyForecastTile extends StatelessWidget {
  const HourlyForecastTile({
    super.key,
    required this.id, // Weather condition ID to determine the icon
    required this.hour, // Forecast hour (time)
    required this.temp, // Temperature value
    required this.isActive, // Whether this tile is highlighted as active (current hour)
  });

  final int id; // Weather condition code for selecting the icon
  final String hour; // Time label for the forecast
  final int temp; // Temperature for the forecast
  final bool isActive; // Highlights the tile if it is the current hour

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adds padding around each tile for spacing
      padding: const EdgeInsets.only(
        right: 16, // Padding on the right
        top: 12, // Padding on the top
        bottom: 12, // Padding on the bottom
      ),
      child: Material(
        // Defines the appearance of each forecast tile
        color: isActive ? AppColors.lightBlue : AppColors.accentBlue, // Changes color if active
        borderRadius: BorderRadius.circular(15.0), // Rounds the corners of the tile
        elevation: isActive ? 8 : 0, // Adds elevation (shadow) if the tile is active
        child: Padding(
          // Adds internal padding to the content of the tile
          padding: const EdgeInsets.symmetric(
            horizontal: 16, // Horizontal padding
            vertical: 10, // Vertical padding
          ),
          child: Row(
            // Aligns the icon and the text in a row
            crossAxisAlignment: CrossAxisAlignment.center, // Centers the content vertically
            children: [
              // Displays the weather icon based on the weather condition ID
              Image.asset(
                getWeatherIcon(weatherCode: id), // Uses a utility function to get the appropriate icon
                width: 50, // Icon size
              ),
              const SizedBox(width: 10), // Adds spacing between the icon and the text
              Column(
                // Organizes the time and temperature text in a column
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes space between the elements
                mainAxisSize: MainAxisSize.min, // Minimizes the size of the column
                children: [
                  // Displays the hour
                  Text(
                    hour,
                    style: const TextStyle(
                      color: AppColors.white, // Sets text color
                    ),
                  ),
                  const SizedBox(height: 5), // Adds space between the time and temperature
                  // Displays the temperature
                  Text(
                    '$temp°',
                    style: TextStyles.h3, // Uses a predefined style for the text
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
