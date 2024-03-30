import 'package:bkd_presence/app/themes/color_constants.dart';
import 'package:bkd_presence/app/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLoading extends StatelessWidget {
  const HomeLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: ColorConstants.mainColor,
        ),
        SafeArea(
          child: ListView(
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(top: 24, left: 16, bottom: 16, right: 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 24,
                      child: ShimmerLoading(),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ShimmerLoading(
                            shape: ShimmerShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 20,
                              child: ShimmerLoading(),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              width: 200,
                              height: 12,
                              child: ShimmerLoading(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: Get.height,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: Get.width,
                      child: const ShimmerLoading(),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12,
                                    width: 50,
                                    child: ShimmerLoading(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 20,
                                    child: ShimmerLoading(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 100,
                                height: 10,
                                child: ShimmerLoading(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12,
                                    width: 50,
                                    child: ShimmerLoading(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 20,
                                    child: ShimmerLoading(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 100,
                                height: 10,
                                child: ShimmerLoading(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 12,
                          width: 150,
                          child: ShimmerLoading(),
                        ),
                        SizedBox(
                          height: 12,
                          width: 50,
                          child: ShimmerLoading(),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 3,
                            spreadRadius: 0.02,
                            offset: Offset(0, 0.4),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12,
                                    width: 50,
                                    child: ShimmerLoading(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 20,
                                    child: ShimmerLoading(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 100,
                                height: 10,
                                child: ShimmerLoading(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12,
                                    width: 50,
                                    child: ShimmerLoading(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 20,
                                    child: ShimmerLoading(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 100,
                                height: 10,
                                child: ShimmerLoading(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 3,
                            spreadRadius: 0.02,
                            offset: Offset(0, 0.4),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12,
                                    width: 50,
                                    child: ShimmerLoading(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 20,
                                    child: ShimmerLoading(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 100,
                                height: 10,
                                child: ShimmerLoading(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12,
                                    width: 50,
                                    child: ShimmerLoading(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 20,
                                    child: ShimmerLoading(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 100,
                                height: 10,
                                child: ShimmerLoading(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
