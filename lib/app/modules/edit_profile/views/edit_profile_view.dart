import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:bpbd_presence/app/themes/themes.dart';
import 'package:bpbd_presence/app/widgets/button.dart';
import 'package:bpbd_presence/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String? name = Get.arguments['name'];
    String getInitials(String userName) => userName.isNotEmpty
        ? userName.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';
    getInitials(name!);
    final textTheme = Themes.light.textTheme;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Edit Profile",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: ColorConstants.mainColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 90,
                            width: 90,
                            child: Obx(
                              () => ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: controller.isEmpty.value == false &&
                                        controller.file != null
                                    ? Image.file(
                                        controller.file!,
                                        fit: BoxFit.cover,
                                      )
                                    : Get.arguments['profilePhotoPath'] == null
                                        ? CircleAvatar(
                                            backgroundColor:
                                                ColorConstants.mainColor,
                                            child: Text(
                                              getInitials(name),
                                              style:
                                                  textTheme.bodyLarge!.copyWith(
                                                fontSize: 28,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : Image.network(
                                            "${Get.arguments['profilePhotoPath']}",
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.pickFile();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(top: 60, left: 60),
                          decoration: BoxDecoration(
                            color: ColorConstants.redColor,
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Nama",
                style: textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: controller.nameController,
                enabled: false,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFE8E8E8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                    borderSide: const BorderSide(
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Color(
                        0xFFA9A9A9,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Jabatan",
                style: textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: controller.positionController,
                enabled: false,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFE8E8E8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                    borderSide: const BorderSide(
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Color(
                        0xFFA9A9A9,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "No Hp",
                style: textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: controller.phoneNumberController,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                    borderSide: const BorderSide(
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Color(
                        0xFFA9A9A9,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              Align(
                alignment: Alignment.center,
                child: Button(
                  height: 41,
                  width: 150,
                  onPressed: () {
                    controller.editProfile();
                  },
                  child: Text(
                    "Simpan",
                    style: textTheme.labelMedium!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
