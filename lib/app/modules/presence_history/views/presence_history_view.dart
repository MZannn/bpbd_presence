import 'package:bkd_presence/app/routes/app_pages.dart';
import 'package:bkd_presence/app/themes/color_constants.dart';
import 'package:bkd_presence/app/themes/themes.dart';
import 'package:bkd_presence/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/presence_history_controller.dart';

class PresenceHistoryView extends GetView<PresenceHistoryController> {
  const PresenceHistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Themes.light.textTheme;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Riwayat Presensi',
      ),
      body: controller.obx(
        (state) => ListView.builder(
          itemCount: state?.data?.presences?.length,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: controller
                  .formatDate('${state?.data?.presences?[index].presenceDate}'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String formattedDate = snapshot.data!;
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.detailPresence,
                        arguments: state?.data?.presences?[index].id,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Masuk",
                                    style: textTheme.labelMedium,
                                  ),
                                  Text(
                                    state?.data?.presences?[index]
                                            .attendanceClock ??
                                        '-',
                                    style: textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  state?.data?.presences?[index]
                                              .attendanceEntryStatus ==
                                          "Terlambat"
                                      ? Text(
                                          "${state?.data?.presences?[index].attendanceEntryStatus}",
                                          style: textTheme.labelMedium!
                                              .copyWith(
                                                  color:
                                                      ColorConstants.redColor),
                                        )
                                      : const SizedBox(
                                          height: 14,
                                        ),
                                  Text(
                                    formattedDate,
                                    style: textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w400,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Keluar",
                                    style: textTheme.labelMedium,
                                  ),
                                  Text(
                                    state?.data?.presences?[index]
                                            .attendanceClockOut ??
                                        '-',
                                    style: textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w400,
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
        ),
      ),
    );
  }
}
