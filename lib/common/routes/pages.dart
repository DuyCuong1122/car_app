import 'package:do_an_tot_nghiep_final/admin_user/user/gemini/text_image/index.dart';
import 'package:do_an_tot_nghiep_final/welcomePage.dart';
import 'package:get/get.dart';

import '../../admin_user/admin/addCar/index.dart';
import '../../admin_user/admin/addImage/index.dart';
import '../../admin_user/admin/addSpec/index.dart';
import '../../admin_user/admin/deleteCar/index.dart';
import '../../admin_user/admin/deleteSpec/index.dart';
import '../../admin_user/profile/index.dart';
import '../../admin_user/user/application/index.dart';
import '../../admin_user/user/compareCar/index.dart';
import '../../admin_user/user/detailCar/index.dart';
import '../../admin_user/user/displayCar/index.dart';
import '../../admin_user/user/home_page/index.dart';
import '../../admin_user/user/showroom/index.dart';
import '../../sign_in_up/sign_in/index.dart';
import '../../sign_in_up/sign_up/index.dart';
import 'names.dart';

class AppPages {
  // static const INITIAL = AppRoutes.INITIAL;
  static const APPlication = AppRoutes.Application;
  static const SignIn = AppRoutes.SignIn;
  static const SignUp = AppRoutes.SignUp;
  // static const DeleteCar = AppRoutes.DeleteCar;
  // static const CompareCar = AppRoutes.Compare;
  static const Welcome = AppRoutes.Welcome;

  static final List<GetPage> routes = [
    GetPage(
        name: AppRoutes.DETAIL,
        page: () =>  const DetailCarPage(),
        binding: DetailCarBinding()),
    GetPage(
        name: AppRoutes.AddCar,
        page: () => const AddCarPage(),
        binding: AddCarBinding()),
    GetPage(
        name: AppRoutes.DeleteCar,
        page: () => const DeleteCarPage(),
        binding: DeleteCarBinding()),
    GetPage(
        name: AppRoutes.Compare,
        page: () => const ComparePage(),
        binding: CompareBinding()),
    GetPage(
        name: AppRoutes.AddSpec,
        page: () => const AddSpecPage(),
        binding: AddSpecBinding()),
    GetPage(
        name: AppRoutes.Homepage,
        page: () => const HomePage(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.AddImage,
        page: () => const AddImagePage(),
        binding: AddImageBindings()),
    GetPage(
        name: AppRoutes.DeleteSpec,
        page: () => const DeleteSpecPage(),
        binding: DeleteSpecBinding()),
    GetPage(
        name: AppRoutes.DISPLAYALLCAR,
        page: () => const DisplayCarPage(),
        binding: DisplayCarBinding()),
    // GetPage(name: AppRoutes.Center, page: () => const CenterPage()),
    GetPage(
        name: AppPages.APPlication,
        page: () => ApplicationPage(),
        binding: ApplicationBinding()),
    GetPage(
        name: AppPages.SignIn,
        page: () => SignInPage(),
        binding: SignInBinding()),
    GetPage(
        name: AppRoutes.SignUp,
        page: () => SignUpPage(),
        binding: SignUpBinding()),
    GetPage(
        name: AppRoutes.Profile,
        page: () => const ProfilePage(),
        binding: ProfileBinding()),
    GetPage(
        name: AppRoutes.TextImage,
        page: () => const TextWithImagePage(),
        binding: TextWithImageBinding()),
    GetPage(name: AppPages.Welcome, page: () => WelcomePage()),
    GetPage(
        name: AppRoutes.Showroom,
        page: () => ShowroomPage(),
        binding: ShowroomBinding())
  ];
}
