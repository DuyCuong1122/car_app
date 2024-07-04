import 'package:do_an_tot_nghiep_final/common/entities/entities.dart';
import 'package:do_an_tot_nghiep_final/common/entities/user.dart';
import 'package:get/get.dart';

class ApplicationState {
  final _page = 0.obs;
  int get page => _page.value;
  set page(value) => _page.value = value;
  var user = Rxn<UserDB>();
}
