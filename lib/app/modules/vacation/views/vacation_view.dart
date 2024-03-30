import 'package:bkd_presence/app/themes/color_constants.dart';
import 'package:bkd_presence/app/themes/themes.dart';
import 'package:bkd_presence/app/widgets/button.dart';
import 'package:bkd_presence/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/vacation_controller.dart';

class VacationView extends GetView<VacationController> {
  const VacationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final textTheme = Themes.light.textTheme;
    return Scaffold(
      appBar: const CustomAppBar(title: "Permintaan Cuti"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Form(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 115,
                      child: Text(
                        "Tanggal Dimulai",
                        style:
                            textTheme.bodySmall!.copyWith(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                      child: Text(
                        ":",
                        style:
                            textTheme.bodySmall!.copyWith(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: controller.startDateController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Tanggal Dimulai',
                          suffixIcon: const Icon(Icons.calendar_month_outlined),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tanggal dimulai tidak boleh kosong';
                          }
                          return null;
                        },
                        onTap: () {
                          controller.selectStartDate(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 115,
                      child: Text(
                        "Tanggal Berakhir",
                        style:
                            textTheme.bodySmall!.copyWith(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                      child: Text(
                        ":",
                        style:
                            textTheme.bodySmall!.copyWith(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: controller.endDateController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Tanggal Berakhir',
                          suffixIcon: const Icon(Icons.calendar_month_outlined),
                        ),
                        onTap: () {
                          controller.selectEndDate(context);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tanggal berakhir tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 115,
                      child: Text(
                        "Surat Cuti",
                        style:
                            textTheme.bodySmall!.copyWith(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                      child: Text(
                        ":",
                        style:
                            textTheme.bodySmall!.copyWith(color: Colors.black),
                      ),
                    ),
                    Obx(
                      () => Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.pickFile();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 45,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black54,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    controller.fileName.value != ''
                                        ? controller.fileName.value
                                        : "Surat Cuti",
                                    style: textTheme.labelLarge!.copyWith(
                                      color: controller.fileName.value != ''
                                          ? Colors.black
                                          : Colors.black54,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                controller.fileName.value != ''
                                    ? InkWell(
                                        onTap: () {
                                          controller.delete();
                                        },
                                        child: Icon(
                                          Icons.delete_forever,
                                          color: ColorConstants.redColor,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.attach_file,
                                        color: Colors.black54,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Alasan Ingin Cuti",
                  style: textTheme.labelSmall,
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: double
                      .infinity, // set width ke nilai tak terhingga untuk mengambil lebar layar penuh
                  height: 120, // set tinggi TextField
                  decoration: BoxDecoration(
                    color: Colors.white, // set warna background
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
                  child: TextFormField(
                    controller: controller.reasonController,
                    maxLines:
                        null, // set maxLines ke null agar TextField dapat menyesuaikan jumlah baris yang dibutuhkan
                    keyboardType: TextInputType
                        .multiline, // set jenis keyboard yang muncul ketika TextField di-tap
                    decoration: const InputDecoration(
                      hintText: 'Masukkan Alasan Anda...', // set hint text
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10), // set padding
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Button(
                    height: 41,
                    width: 200,
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          controller.fileName.value != '') {
                        controller.vacation();
                      }
                    },
                    child: Text(
                      "Ajukan Cuti",
                      style: textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
