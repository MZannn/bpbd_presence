import 'package:bpbd_presence/app/themes/themes.dart';
import 'package:bpbd_presence/app/widgets/button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Themes.light.textTheme;
    final formKey = GlobalKey<FormState>();
    return Scaffold(body: Obx(() {
      if (controller.isLoading.value == true) {
        return const SizedBox();
      }
      return SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 75),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: textTheme.titleLarge,
                    ),
                    Text(
                      "Sistem Presensi Badan Penanggulangan Bencana Daerah Kota Bogor",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bpbd.png"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("NIP", style: textTheme.labelMedium),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: controller.nipController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Color(0xFFA4A4A4),
                            ),
                          ),
                          hintStyle: textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFF666666),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "NIP tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Password",
                        style: textTheme.labelMedium,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Obx(
                        () => TextFormField(
                          controller: controller.passwordController,
                          obscuringCharacter: "●",
                          obscureText: controller.isHidden.value,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: Color(0xFFA4A4A4),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.hiddenPassword();
                              },
                              icon: controller.isHidden.value
                                  ? const Icon(
                                      Icons.visibility_outlined,
                                    )
                                  : const Icon(
                                      Icons.visibility_off_outlined,
                                    ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Button(
                  height: 41,
                  width: 150,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.login();
                    }
                  },
                  child: Text(
                    "Masuk",
                    style: textTheme.labelMedium!.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }
}
