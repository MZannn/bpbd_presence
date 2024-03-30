import 'package:bkd_presence/app/modules/profile/views/profile_view.dart';
import 'package:bkd_presence/app/routes/app_pages.dart';
import 'package:bkd_presence/app/themes/color_constants.dart';
import 'package:bkd_presence/app/themes/constants.dart';
import 'package:bkd_presence/app/themes/themes.dart';
import 'package:bkd_presence/app/widgets/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';
import 'home_loading.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Themes.light.textTheme;
    return Scaffold(
      body: controller.obx(
        (state) {
          String? name = state?.data?.user?.name;
          String getInitials(String userName) => userName.isNotEmpty
              ? userName.trim().split(' ').map((l) => l[0]).take(2).join()
              : '';
          DateTime dateTime =
              DateTime.parse("${state?.data?.presences?.first.presenceDate}");
          var presencesDate =
              DateFormat('EEEE, dd-MM-yyyy', 'id_ID').format(dateTime);

          getInitials(name!);
          return Obx(
            () => IndexedStack(
              index: controller.selectedIndex.value,
              children: [
                Obx(
                  () {
                    if (controller.isLoading.value == true) {
                      return const SizedBox();
                    }
                    return Stack(
                      children: [
                        Container(
                          color: ColorConstants.mainColor,
                        ),
                        SafeArea(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await controller.getUser();
                            },
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 24,
                                    left: 16,
                                    bottom: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Badan Penanggulangan Bencana Daerah",
                                        style: textTheme.titleMedium,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(3),
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: state?.data?.user
                                                            ?.profilePhotoPath ==
                                                        null
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Text(
                                                          getInitials(name),
                                                          style: textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                            fontSize: 22,
                                                            color:
                                                                ColorConstants
                                                                    .mainColor,
                                                          ),
                                                        ),
                                                      )
                                                    : Image.network(
                                                        'http://12.12.12.6:8000/storage/${state?.data?.user?.profilePhotoPath}',
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${state?.data?.user?.name}',
                                                style: textTheme.bodyLarge,
                                              ),
                                              Text(
                                                '${state?.data?.user?.position}',
                                                style: textTheme.bodySmall,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 200,
                                        width: double.infinity,
                                        child: GoogleMap(
                                          markers: {
                                            Marker(
                                              markerId: const MarkerId("BPBD"),
                                              position: LatLng(
                                                Constants.latitude,
                                                Constants.longitude,
                                              ),
                                            ),
                                          },
                                          zoomControlsEnabled: false,
                                          circles: {
                                            Circle(
                                              circleId:
                                                  const CircleId("circle"),
                                              center: LatLng(Constants.latitude,
                                                  Constants.longitude),
                                              radius: Constants
                                                      .maxAttendanceDistance *
                                                  1000, // convert ke meter
                                              strokeWidth: 1,
                                              strokeColor: Colors.blue,
                                              fillColor:
                                                  Colors.blue.withOpacity(0.1),
                                            ),
                                          },
                                          onCameraMove: (position) {
                                            position =
                                                controller.cameraPosition;
                                          },
                                          initialCameraPosition:
                                              controller.cameraPosition,
                                          // ignore: prefer_collection_literals
                                          gestureRecognizers: Set()
                                            ..add(Factory<PanGestureRecognizer>(
                                                () => PanGestureRecognizer()))
                                            ..add(Factory<
                                                    ScaleGestureRecognizer>(
                                                () => ScaleGestureRecognizer()))
                                            ..add(Factory<TapGestureRecognizer>(
                                                () => TapGestureRecognizer()))
                                            ..add(
                                              Factory<
                                                  VerticalDragGestureRecognizer>(
                                                () =>
                                                    VerticalDragGestureRecognizer(),
                                              ),
                                            )
                                            ..add(
                                              Factory<
                                                  HorizontalDragGestureRecognizer>(
                                                () =>
                                                    HorizontalDragGestureRecognizer(),
                                              ),
                                            ),
                                          myLocationEnabled: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(Routes.detailPresence,
                                              arguments: state
                                                  ?.data?.presences?.first.id);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Masuk",
                                                        style: textTheme
                                                            .labelMedium,
                                                      ),
                                                      Text(
                                                        state
                                                                ?.data
                                                                ?.presences
                                                                ?.first
                                                                .attendanceClock ??
                                                            "-",
                                                        style: textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      state
                                                                  ?.data
                                                                  ?.presences
                                                                  ?.first
                                                                  .attendanceEntryStatus ==
                                                              "Terlambat"
                                                          ? Text(
                                                              "${state?.data?.presences?.first.attendanceEntryStatus}",
                                                              style: textTheme
                                                                  .labelMedium!
                                                                  .copyWith(
                                                                      color: ColorConstants
                                                                          .redColor),
                                                            )
                                                          : const SizedBox(
                                                              height: 14,
                                                            ),
                                                      Text(
                                                        presencesDate,
                                                        style: textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Keluar",
                                                        style: textTheme
                                                            .labelMedium,
                                                      ),
                                                      Text(
                                                        state
                                                                ?.data
                                                                ?.presences
                                                                ?.first
                                                                .attendanceClockOut ??
                                                            '-',
                                                        style: textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        presencesDate,
                                                        style: textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Presensi 5 hari terakhir",
                                            style: textTheme.labelMedium,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Get.toNamed(
                                                  Routes.presenceHistory);
                                            },
                                            child: const Text("Lebih banyak"),
                                          ),
                                        ],
                                      ),
                                      ListView.builder(
                                        itemCount:
                                            state?.data?.presences?.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return FutureBuilder(
                                            future: controller.formatDate(
                                                '${state?.data?.presences?[index].presenceDate}'),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                String formattedDate =
                                                    snapshot.data!;
                                                return GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(
                                                        Routes.detailPresence,
                                                        arguments: state
                                                            ?.data
                                                            ?.presences?[index]
                                                            .id);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                      vertical: 16,
                                                    ),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 7,
                                                          offset: const Offset(
                                                              0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text("Masuk",
                                                                    style: textTheme
                                                                        .labelMedium),
                                                                Text(
                                                                  state
                                                                          ?.data
                                                                          ?.presences?[
                                                                              index]
                                                                          .attendanceClock ??
                                                                      "-",
                                                                  style: textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                state?.data?.presences?[index]
                                                                            .attendanceEntryStatus ==
                                                                        "Terlambat"
                                                                    ? Text(
                                                                        "${state?.data?.presences?[index].attendanceEntryStatus}",
                                                                        style: textTheme
                                                                            .labelMedium!
                                                                            .copyWith(color: ColorConstants.redColor),
                                                                      )
                                                                    : const SizedBox(
                                                                        height:
                                                                            14,
                                                                      ),
                                                                Text(
                                                                  formattedDate,
                                                                  style: textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Keluar",
                                                                  style: textTheme
                                                                      .labelMedium,
                                                                ),
                                                                Text(
                                                                  '${state?.data?.presences?[index].attendanceClockOut ?? "-"} ',
                                                                  style: textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  formattedDate,
                                                                  style: textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                ProfileView(state),
              ],
            ),
          );
        },
        onLoading: const HomeLoading(),
        onError: (error) {
          return SafeArea(
            child: RefreshIndicator(
                onRefresh: () async {
                  await controller.getUser();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: Get.width,
                    height: Get.height - 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Data User Tidak Berhasil Diload Silahkan Refresh Kembali atau Tekan Tombol Refresh Dibawah ini",
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Button(
                          onPressed: () async {
                            await controller.getUser();
                          },
                          height: 41,
                          width: 150,
                          child: Text(
                            "Refresh",
                            style: textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          child: Container(
            color: Colors.white,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.selectedIndex.value = 0;
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: SvgPicture.asset(
                          'assets/icons/home${controller.selectedIndex.value == 0 ? '_active.svg' : '.svg'}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Home",
                        style: textTheme.bodySmall!.copyWith(
                          color: controller.selectedIndex.value == 0
                              ? ColorConstants.mainColor
                              : ColorConstants.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.selectedIndex.value = 1;
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: SvgPicture.asset(
                          'assets/icons/profile${controller.selectedIndex.value == 1 ? '_active.svg' : '.svg'}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Akun",
                        style: textTheme.bodySmall!.copyWith(
                          color: controller.selectedIndex.value == 1
                              ? ColorConstants.mainColor
                              : ColorConstants.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        if (controller.isWaiting.value == true) {
          return const SizedBox();
        }
        return FloatingActionButton(
          onPressed: () async {
            await controller.presenceOutChecker();
          },
          elevation: 0,
          backgroundColor: controller.now.isAfter(controller.clockOut) &&
                  controller
                          .user?.data?.presences?.first.attendanceEntryStatus !=
                      null
              ? ColorConstants.mainColor
              : ColorConstants.greyColor,
          child: SvgPicture.asset(
              "assets/icons/${controller.now.isAfter(controller.clockOut) && controller.user?.data?.presences?.first.attendanceEntryStatus != null ? 'presence.svg' : 'presence_disabled.svg'}"),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
