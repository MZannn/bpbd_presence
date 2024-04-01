import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:bpbd_presence/app/themes/themes.dart';
import 'package:bpbd_presence/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_presence_controller.dart';

class DetailPresenceView extends GetView<DetailPresenceController> {
  const DetailPresenceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Themes.light.textTheme;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Detail Presensi",
      ),
      body: controller.obx(
        (state) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: FutureBuilder(
              future: controller.formattedDate(
                  '${state?.data?.detailPresence?.presenceDate}'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(
                        '${snapshot.data}',
                        style:
                            textTheme.bodyLarge!.copyWith(color: Colors.black),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Masuk",
                            style: textTheme.labelMedium,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Jam Masuk : ',
                                style: textTheme.labelSmall,
                              ),
                              Text(
                                state?.data?.detailPresence?.attendanceClock ??
                                    "-",
                                style: textTheme.labelSmall,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Status Kehadiran : ',
                                style: textTheme.labelSmall,
                              ),
                              Flexible(
                                child: Text(
                                  state?.data?.detailPresence
                                          ?.attendanceEntryStatus
                                          ?.toUpperCase() ??
                                      "-",
                                  style: state?.data?.detailPresence
                                              ?.attendanceEntryStatus ==
                                          "TERLAMBAT"
                                      ? textTheme.labelSmall!.copyWith(
                                          color: ColorConstants.redColor,
                                          fontWeight: FontWeight.w700,
                                        )
                                      : textTheme.labelSmall!.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Lokasi Kehadiran : ',
                                style: textTheme.labelSmall,
                              ),
                              Flexible(
                                child: Text(
                                  state?.data?.detailPresence?.entryPosition ??
                                      "-",
                                  style: textTheme.labelSmall,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Jarak Kehadiran : ',
                                style: textTheme.labelSmall,
                              ),
                              Text(
                                '${state?.data?.detailPresence?.entryDistance ?? "-"} m',
                                style: textTheme.labelSmall,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Keluar",
                            style: textTheme.labelMedium,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Jam Keluar : ',
                                style: textTheme.labelSmall,
                              ),
                              Text(
                                state?.data?.detailPresence
                                        ?.attendanceClockOut ??
                                    "-",
                                style: textTheme.labelSmall,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Status Kehadiran : ',
                                style: textTheme.labelSmall,
                              ),
                              Flexible(
                                child: Text(
                                  state?.data?.detailPresence
                                          ?.attendanceExitStatus
                                          ?.toUpperCase() ??
                                      "-",
                                  style: textTheme.labelSmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Lokasi Kehadiran : ',
                                style: textTheme.labelSmall,
                              ),
                              Flexible(
                                child: Text(
                                  state?.data?.detailPresence?.exitPosition ??
                                      "-",
                                  style: textTheme.labelSmall,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Jarak Kehadiran : ',
                                style: textTheme.labelSmall,
                              ),
                              Text(
                                '${state?.data?.detailPresence?.exitDistance ?? "-"} m',
                                style: textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
