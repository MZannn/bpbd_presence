import 'package:bpbd_presence/app/models/user_model.dart';
import 'package:bpbd_presence/app/routes/app_pages.dart';
import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:bpbd_presence/app/themes/themes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView(this.user, {Key? key, UserModel? state}) : super(key: key);
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    String? name = user?.data?.user?.name;
    String getInitials(String userName) => userName.isNotEmpty
        ? userName.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';
    getInitials(name!);
    final textTheme = Themes.light.textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            color: ColorConstants.mainColor,
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorConstants.mainColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 27,
                      ),
                      Text(
                        "Profile",
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 105,
                            width: 105,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 90,
                                width: 90,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: user?.data?.user?.profilePhotoPath ==
                                          null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            getInitials(name),
                                            style:
                                                textTheme.bodyLarge!.copyWith(
                                              fontSize: 28,
                                              color: ColorConstants.mainColor,
                                            ),
                                          ),
                                        )
                                      : Image.network(
                                          "${user?.data?.user?.profilePhotoPath}",
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.editProfile, arguments: {
                                'name': user?.data?.user?.name,
                                'position': user?.data?.user?.position,
                                'phoneNumber': user?.data?.user?.phoneNumber,
                                'profilePhotoPath':
                                    user?.data?.user?.profilePhotoPath,
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.only(top: 65, left: 65),
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
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        '${user?.data?.user?.position}',
                        style:
                            textTheme.bodyMedium!.copyWith(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Flexible(
                        child: Text(
                          '${user?.data?.user?.name}',
                          style: textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        '${user?.data?.user?.phoneNumber}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     Get.toNamed(Routes.permission, arguments: {
                      //       'nip': user?.data?.user?.nip,
                      //       'office_id': user?.data?.user?.officeId,
                      //       'presence_id': user?.data?.presences?.first.id,
                      //     });
                      //   },
                      //   child: Row(
                      //     children: [
                      //       const Icon(Icons.coronavirus),
                      //       const SizedBox(
                      //         width: 12,
                      //       ),
                      //       Text(
                      //         "Izin atau Sakit",
                      //         style: textTheme.bodyLarge!.copyWith(
                      //           color: const Color(0xFF383838),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 16,
                      // ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.businessTrip, arguments: {
                            'nip': user?.data?.user?.nip,
                            'office_id': user?.data?.user?.officeId,
                            'presence_id': user?.data?.presences?.first.id,
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.work),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Perjalanan Dinas",
                              style: textTheme.bodyLarge!.copyWith(
                                color: const Color(0xFF383838),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.vacation, arguments: {
                            'nip': user?.data?.user?.nip,
                            'office_id': user?.data?.user?.officeId,
                            'presence_id': user?.data?.presences?.first.id,
                            'leave_rules': user?.data?.leaveRules,
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.map_rounded),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Cuti",
                              style: textTheme.bodyLarge!.copyWith(
                                color: const Color(0xFF383838),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.emergencyAttendance, arguments: {
                            'nip': user?.data?.user?.nip,
                            'office_id': user?.data?.user?.officeId,
                            'presence_id': user?.data?.presences?.first.id,
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.warning_rounded),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Absensi Darurat",
                              style: textTheme.bodyLarge!.copyWith(
                                color: const Color(0xFF383838),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.changeDevice, arguments: [
                            user?.data?.user?.nip,
                            user?.data?.user?.officeId,
                          ]);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.mobile_screen_share),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Ganti Device",
                              style: textTheme.bodyLarge!.copyWith(
                                color: const Color(0xFF383838),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
