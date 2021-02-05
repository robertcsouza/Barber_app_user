import 'package:barber_app_user/views/Perfil/Perfil.dart';
import 'package:barber_app_user/views/Register/Register.dart';
import 'package:barber_app_user/views/Register/UserSelectImage.dart';
import 'package:barber_app_user/views/Scheduling/Schedules.dart';

routes() {
  return {
    '/register': (context) => Register(),
    '/register/image': (context) => UserSelectImage(),
    '/schedules': (context) => Schedules(),
    '/perfil': (context) => Perfil(),
    /* '/register/pin': (context) => ConfirmPin(),
    '/register/user': (context) => CreateUser(),
    '/register/image': (context) => SelectImage(),
'/register/image': (context) => SelectImage(),
    // admin Routes
    'admin/scheduling': (context) => Scheduling(),
    'admin/employe': (context) => Employe(),
    'admin/config': (context) => Configurations(),
    'admin/token': (context) => GenerateToken(),
    'admin/gallery': (context) => Gallery(),
    'admin/analytics': (context) => Analytics(),
    'admin/detailImage': (context) => DetailImage(),
    'admin/select/user': (context) => SelectUser(),

    // Barber Routes
    'barber/scheduling': (context) => SchedulingBarber(),
    'barber/profile': (context) => Profile(),
    'barber/reconfirm': (context) => ReconfirmPin(),
    'barber/scheduling/selectUser': (context) => SchedulingBarberSelectUser(),

    //rating
    'rating/screen': (context) => Rating(),

    // Notifications
    '/notifications': (context) => Notifications(),
    '/notifications/barber': (context) => NotificationsBarber(),
  */
  };
}
