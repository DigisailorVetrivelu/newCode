import 'package:get/get.dart';
import 'package:iukl_admin/models/cert.dart';

class UserController extends GetxController {
  final Cert cert;
  static UserController instance = Get.find();
  UserController(this.cert);
}
