import 'package:animated_introduction/animated_introduction.dart';



final List<SingleIntroScreen> pages = [
  const SingleIntroScreen(
    title: 'Welcome to the Event Management App !',
    description: 'You plans your Events, We\'ll do the rest and will be the best! Guaranteed!  ',
    imageAsset: 'assets/onboard_one.png',
  ),
  const SingleIntroScreen(
    title: 'Book tickets to cricket matches and events',
    description: 'Tickets to the latest movies, crickets matches, concerts, comedy shows, plus lots more !',
    imageAsset: 'assets/onboard_two.png',
  ),
  const SingleIntroScreen(
    title: 'Grabs all events now only in your hands',
    description: 'All events are now in your hands, just a click away ! ',
    imageAsset: 'assets/onboard_three.png',
  ),
];


// Scaffold(
//   body: AnimatedIntroduction(
//     slides: pages,
//     indicatorType: IndicatorType.circle,
//     onDone: () {
// /// TODO: Go to desire page like login or home
//       },
//     ),
//   );