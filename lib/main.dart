import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/logo_intro_page.dart';
import 'screens/home_page.dart';
import 'screens/room_list_page.dart';
import 'screens/profile_page.dart';
import 'screens/order_summary.dart';
import 'screens/dashboard.dart';
import 'screens/review_page.dart';
import 'providers/theme_provider.dart'; // Adjusted import for ThemeProvider
import 'screens/card_payment_page.dart'; // Import Card Payment Page
import 'models/room.dart'; // Import Room model

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add your providers here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Get the theme provider

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Colombo City Space',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home: IntroPage(), // Initial screen of the app
      routes: _buildAppRoutes(),
    );
  }

  // Method to define application routes
  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      '/login': (ctx) => LoginScreen(),
      '/register': (ctx) => RegistrationScreen(),
      '/home': (ctx) {
        final userName = ModalRoute.of(ctx)!.settings.arguments as String;
        return UserHomePage(userName: userName);
      },
      '/profile': (ctx) {
        final userName = ModalRoute.of(ctx)!.settings.arguments as String;
        return ProfilePage(userName: userName);
      },
      '/orderSummary': (ctx) {
        final args = ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>; // Change here
        return OrderSummaryPage(
          userName: args['userName'], // Retrieve userName
          roomName: args['roomName'],  // Retrieve room name
          date: args['date'],          // Retrieve date
          timeSlot: args['timeSlot'],  // Retrieve time slot
        );
      },

      '/room-list': (ctx) {
        final rooms = ModalRoute.of(ctx)!.settings.arguments as List<Room>;
        return RoomListPage(rooms: rooms);
      },
      '/dashboard': (ctx) {
        final userName = ModalRoute.of(ctx)!.settings.arguments as String;
        return DashboardPage(userName: userName);
      },
      '/rateReview': (ctx) => RateReviewPage(),
    };
  }
}
