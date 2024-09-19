import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/constants/app_colors.dart';
import 'package:weather_app/constants/text_styles.dart';
import 'package:weather_app/extensions/datetime.dart';
import 'package:weather_app/providers/weekly_weather_provider.dart';
import 'package:weather_app/utils/get_weather_icons.dart';
import 'package:weather_app/widgets/subscript_text.dart';

class WeeklyForecastView extends ConsumerWidget {
  const WeeklyForecastView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyForecastData = ref.watch(weeklyWeatherProvider);
    return weeklyForecastData.when(data: (weeklyWeather) {
      return ListView.builder(
        itemBuilder: (context, index) {
          final dayOfWeek = DateTime.parse(weeklyWeather.daily.time[index]).dayOfWeek;
          final date = weeklyWeather.daily.time[index];
          final temp = weeklyWeather.daily.temperature2mMax[index];
          final icon = weeklyWeather.daily.weatherCode[index];

          return weeklyWeatherTile(
            day: dayOfWeek,
            date: date,
            temp: temp.toInt(),
            icon: getWeatherIcon2(icon),
          );
        },
        itemCount: weeklyWeather.daily.weatherCode.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      );
    }, error: (error, stackTrace) {
      return Center(
        child: Text(error.toString()),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}

class weeklyWeatherTile extends StatelessWidget {
  const weeklyWeatherTile({
    super.key,
    required this.day,
    required this.date,
    required this.temp,
    required this.icon,
  });

  final String day;
  final String date;
  final int temp;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      margin:const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.accentBlue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                day,
                style: TextStyles.h3,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                date,
                style: TextStyles.subtitleText,
              ),
            ],
          ),
          SuperscriptText(
            text: temp.toString(),
            superScript: "°C",
            color: AppColors.white,
            superscriptColor: AppColors.grey,
          ),
          Image.asset(icon, width: 60,)
        ],
      ),
    );
  }
}
