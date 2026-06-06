import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:safe_go/UI/passenger/passenger_dashboard.dart';
import 'package:safe_go/UI/Auth/LoginPage.dart';
import 'package:safe_go/UI/Auth/ResetPasswordPage.dart';
import 'package:safe_go/UI/Auth/SignupPage.dart';
import 'package:safe_go/UI/Auth/ChangePasswordPage.dart';
import 'package:safe_go/UI/Auth/SplashPage.dart';
import 'package:safe_go/UI/RoleSelection/role_selection_view.dart';
import 'package:safe_go/UI/passenger/ride_request.dart';
import 'package:safe_go/UI/passenger/searching_driver_screen.dart';
import 'package:safe_go/UI/passenger/ride_status.dart';
import 'package:safe_go/UI/passenger/ride_completed.dart';
import 'package:safe_go/UI/passenger/ride_completed.dart';
import 'package:safe_go/UI/passenger/passenger_profile.dart';
import 'package:safe_go/UI/passenger/passenger_history_screen.dart';
import 'package:safe_go/UI/passenger/passenger_payment_methods.dart';
import 'package:safe_go/UI/driver/driver_dashboard.dart';
import 'package:safe_go/UI/driver/ride_requests.dart';
import 'package:safe_go/UI/driver/update_screen_status.dart';
import 'package:safe_go/UI/driver/ride_completed_screen.dart';
import 'package:safe_go/UI/driver/driver_history_screen.dart';
import 'package:safe_go/UI/driver/driver_profile.dart';
import 'package:safe_go/UI/driver/driver_profile_edit_field.dart';
import 'package:safe_go/UI/driver/vehicles_screen.dart';
import 'package:safe_go/UI/driver/driver_payment_methods_page.dart';
import 'package:safe_go/UI/driver/driver_change_password_page.dart';
import 'package:safe_go/firebase_options.dart';
import 'binding/loginbinding.dart';
import 'binding/driver_bindings.dart';
import 'binding/authbinding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
  runApp(SafeGoApp());
}

class SafeGoApp extends StatelessWidget {
  const SafeGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'safe_go',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashPage(),
          binding: AuthInitBinding(),
        ),
        GetPage(
          name: '/roleSelect',
          page: () => const RoleSelectionScreen(),
          binding: AuthInitBinding(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/signup',
          page: () => const SignupPage(),
          binding: SignUpBinding(),
        ),
        GetPage(
          name: '/reset',
          page: () => const ResetPasswordPage(),
          binding: ResetBinding(),
        ),
         

        GetPage(
          name: '/passenger/dashboard',
          page: () => PassengerDashboard(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/change',
          page: () => const ChangePasswordPage(),
          binding: ChangePasswordBinding(),
        ),
        GetPage(
          name: '/passenger/request',
          page: () => const RequestRideUI(),
          binding: PassengerRideBinding(),
        ),
        GetPage(
          name: '/passenger/searching',
          page: () => const SearchingDriverScreen(),
          binding: PassengerRideBinding(),
        ),
        GetPage(
          name: '/passenger/status',
          page: () => const RideStatusScreen(),
          binding: PassengerRideBinding(),
        ),
        GetPage(
          name: '/passenger/completed',
          page: () => const RideCompletedScreen(),
          binding: PassengerRideBinding(),
        ),
        GetPage(
          name: '/passenger/profile',
          page: () => const ProfileScreen(),
          binding: PassengerProfileBinding(),
        ),
        GetPage(
          name: '/passenger/history',
          page: () => const PassengerHistoryScreen(),
          binding: PassengerRideBinding(),
        ),
        GetPage(
          name: '/passenger/payment',
          page: () => const PassengerPaymentMethodsPage(),
        ),

         
        GetPage(
          name: '/driver/requests',
          page: () => const RideRequestsScreen(),
          binding: DriverRequestsBinding(),
        ),
        GetPage(
          name: '/driver/progress',
          page: () => const UpdateRideStatusScreen(),
          binding: DriverProgressBinding(),
        ),
        GetPage(
          name: '/driver/completed',
          page: () => const TripCompletedScreen(),
          binding: DriverProgressBinding(),
        ),
        GetPage(
          name: '/driver/dashboard',
          page: () => const DriverDashboard(),
          binding: DriverDashboardBinding(),
        ),
        GetPage(
          name: '/driver/history',
          page: () => const DriverHistoryScreen(),
          binding: DriverHistoryBinding(),
        ),
        GetPage(
          name: '/driver/profile',
          page: () => const DriverProfileScreen(),
          binding: DriverProfileBinding(),
        ),
        GetPage(
          name: '/driver/profile/editField',
          page: () => const DriverProfileEditFieldPage(),
          binding: DriverProfileBinding(),
        ),
        GetPage(
          name: '/driver/vehicles',
          page: () => const MyVehiclesScreen(),
          binding: DriverVehiclesBinding(),
        ),
        GetPage(
          name: '/driver/paymentMethods',
          page: () => const DriverPaymentMethodsPage(),
          binding: DriverProfileBinding(),
        ),
        GetPage(
          name: '/driver/changePassword',
          page: () => const DriverChangePasswordPage(),
          binding: DriverChangePasswordBinding(),
        ),
      ],
    );
  }
}
