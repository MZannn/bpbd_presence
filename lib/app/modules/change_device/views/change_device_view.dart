import 'package:bkd_presence/app/themes/themes.dart';
import 'package:bkd_presence/app/widgets/button.dart';
import 'package:bkd_presence/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_device_controller.dart';

class ChangeDeviceView extends GetView<ChangeDeviceController> {
  const ChangeDeviceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final textTheme = Themes.light.textTheme;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Permintaan Ubah Device",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alasan Penggantian Device",
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
                    width: 280,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.changeDevice();
                      }
                    },
                    child: Text(
                      "Ajukan Permintaan Ganti Device",
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
