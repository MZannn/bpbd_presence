import 'dart:io';

import 'package:bkd_presence/app/models/user_model.dart';
import 'package:bkd_presence/app/modules/edit_profile/provider/edit_profile_provider.dart';
import 'package:bkd_presence/app/routes/app_pages.dart';
import 'package:bkd_presence/app/themes/color_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController with StateMixin<UserModel?> {
  final EditProfileProvider _editProfileProvider;
  EditProfileController(this._editProfileProvider);
  late TextEditingController nameController;
  late TextEditingController positionController;
  late TextEditingController phoneNumberController;
  RxBool isEmpty = true.obs;
  File? file;

  Future editProfile() async {
    change(null, status: RxStatus.loading());
    try {
      final response = await _editProfileProvider.editProfile(
        phoneNumberController.text,
        file,
      );

      change(response, status: RxStatus.success());
      if (response!.code == 200) {
        Get.offAllNamed(Routes.home);
        Get.rawSnackbar(
          message: 'Berhasil Mengubah Profile',
          backgroundColor: ColorConstants.mainColor,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.rawSnackbar(
          message: 'Gagal Mengubah Profile',
          backgroundColor: ColorConstants.mainColor,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future pickFile() async {
    try {
      isEmpty.value = true;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );
      if (result != null) {
        file = File(result.files.single.path!);
        final fileSize = await file!.length();
        isEmpty.value = false;
        if (fileSize > 2 * 1024 * 1024) {
          await file!.delete();
          isEmpty.value = true;
          Get.dialog(
            AlertDialog(
              title: const Text('Ukuran File Terlalu Besar'),
              content: const Text('Ukuran File Tidak Boleh Lebih Dari 2 MB'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      e.toString();
    }
  }

  @override
  void onInit() {
    nameController = TextEditingController(text: Get.arguments['name']);
    positionController = TextEditingController(text: Get.arguments['position']);
    phoneNumberController =
        TextEditingController(text: Get.arguments['phoneNumber']);
    super.onInit();
  }
}
