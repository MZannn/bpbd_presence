import 'package:get/get.dart';

import '../binding/global_binding.dart';
import '../models/user_model.dart';
import '../modules/business_trip/bindings/business_trip_binding.dart';
import '../modules/business_trip/views/business_trip_view.dart';
import '../modules/change_device/bindings/change_device_binding.dart';
import '../modules/change_device/views/change_device_view.dart';
import '../modules/detail_presence/bindings/detail_presence_binding.dart';
import '../modules/detail_presence/views/detail_presence_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/emergency_attendance/bindings/emergency_attendance_binding.dart';
import '../modules/emergency_attendance/views/emergency_attendance_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/permission/bindings/permission_binding.dart';
import '../modules/permission/views/permission_view.dart';
import '../modules/presence_history/bindings/presence_history_binding.dart';
import '../modules/presence_history/views/presence_history_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/vacation/bindings/vacation_binding.dart';
import '../modules/vacation/views/vacation_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const splash = Routes.splash;
  static const home = Routes.home;
  static const login = Routes.login;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => ProfileView(UserModel()),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.presenceHistory,
      page: () => const PresenceHistoryView(),
      binding: PresenceHistoryBinding(),
    ),
    GetPage(
      name: _Paths.changeDevice,
      page: () => const ChangeDeviceView(),
      binding: ChangeDeviceBinding(),
    ),
    GetPage(
      name: _Paths.detailPresence,
      page: () => const DetailPresenceView(),
      binding: DetailPresenceBinding(),
    ),
    GetPage(
      name: _Paths.permission,
      page: () => const PermissionView(),
      binding: PermissionBinding(),
    ),
    GetPage(
      name: _Paths.businessTrip,
      page: () => const BusinessTripView(),
      binding: BusinessTripBinding(),
    ),
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: GlobalBinding(),
    ),
    GetPage(
      name: _Paths.vacation,
      page: () => const VacationView(),
      binding: VacationBinding(),
    ),
    GetPage(
      name: _Paths.emergencyAttendance,
      page: () => const EmergencyAttendanceView(),
      binding: EmergencyAttendanceBinding(),
    ),
  ];
}
