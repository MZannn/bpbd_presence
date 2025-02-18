import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:bpbd_presence/app/themes/themes.dart';
import 'package:bpbd_presence/app/widgets/button.dart';
import 'package:bpbd_presence/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/business_trip_controller.dart';

class BusinessTripView extends GetView<BusinessTripController> {
  const BusinessTripView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Themes.light.textTheme;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Perjalanan Dinas',
      ),
      body: Obx(
        () {
          if (controller.isLoading.value == true) {
            return const SizedBox();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 115,
                        child: Text(
                          "Tanggal Dimulai",
                          style: textTheme.bodySmall!
                              .copyWith(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                        child: Text(
                          ":",
                          style: textTheme.bodySmall!
                              .copyWith(color: Colors.black),
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
                            suffixIcon:
                                const Icon(Icons.calendar_month_outlined),
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
                          style: textTheme.bodySmall!
                              .copyWith(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                        child: Text(
                          ":",
                          style: textTheme.bodySmall!
                              .copyWith(color: Colors.black),
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
                            suffixIcon:
                                const Icon(Icons.calendar_month_outlined),
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
                          "Surat Dinas",
                          style: textTheme.bodySmall!
                              .copyWith(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                        child: Text(
                          ":",
                          style: textTheme.bodySmall!
                              .copyWith(color: Colors.black),
                        ),
                      ),
                      Obx(
                        () => Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.pickFile();
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black54,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      controller.fileName.value != ''
                                          ? controller.fileName.value
                                          : "Surat Dinas",
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
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Button(
                      height: 41,
                      width: 150,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          controller.businessTrip();
                        }
                      },
                      child: Text(
                        "Kirim",
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
          );
        },
      ),
    );
  }
}
