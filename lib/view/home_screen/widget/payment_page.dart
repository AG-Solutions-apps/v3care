import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Constants/app_colors.dart';
import '../../../Utils/api_helper.dart';
import '../../../Utils/const_helper.dart';
import '../../../controller/home_controller.dart';
import '../../../widget/common_button.dart';
import '../../../widget/custom_text_form_field.dart';

enum PaymentOption {
  collectNow,
  noCollectNow,
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  HomeController homeController = Get.put(HomeController());
  TextEditingController traDetailCon = TextEditingController();
  TextEditingController remarkCon = TextEditingController();
  TextEditingController discountCon = TextEditingController();
  TextEditingController totalAmCon = TextEditingController();
  TextEditingController recINCashCon = TextEditingController();

  bool showPaymentTypeError = false;
  Map mapValue = {};
  List popUpList = ["Receive in cash", "Google Pay", "Bank"];
  bool isToggled = false;
  PaymentOption isReceived = PaymentOption.collectNow;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Add listener to auto-calculate total amount after discount
    discountCon.addListener(() {
      String discountText = discountCon.text.trim();
      double discount = double.tryParse(discountText) ?? 0.0;
      double orderAmount = double.tryParse(
        homeController.detailList.first.orderAmount?.toString() ?? "0",
      ) ??
          0.0;

      double finalAmount = orderAmount - discount;
      if (finalAmount < 0) finalAmount = 0.0;

      if (isReceived == PaymentOption.collectNow) {
        // If it's a whole number, show without decimals
        if (finalAmount == finalAmount.roundToDouble()) {
          totalAmCon.text = finalAmount.toInt().toString();
        } else {
          totalAmCon.text = finalAmount.toStringAsFixed(2);
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          /* appBar: AppBar(
        backgroundColor: ConstHelper.whiteColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
        title: Text(
          "Update Payment",
          style: GoogleFonts.inter(
            fontSize: Get.height / 45,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),*/
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.05, vertical: Get.height * 0.02),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.08,
                    ),
                    Text(
                      "Update Payment",
                      style: GoogleFonts.inter(
                        fontSize: Get.height / 45,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: Get.height * 0.84,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.03),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/payment_bg.png"),
                                        fit: BoxFit.fill),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: Get.height * 0.04,
                                        ),
                                        SvgPicture.asset(
                                          "assets/images/svg/done_2_icon.svg",
                                          height: Get.height * 0.09,
                                        ),
                                        Text(
                                          "Update Payment",
                                          style: GoogleFonts.inter(
                                            fontSize: Get.height / 40,
                                            color: AppColors.greenColor,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.01,
                                        ),
                                        // Text(
                                        //   (homeController.detailList.first
                                        //                       .orderService ??
                                        //                   "")
                                        //               .toLowerCase() ==
                                        //           "custom"
                                        //       ? (homeController.detailList.first
                                        //               .orderCustom ??
                                        //           "")
                                        //       : (homeController.detailList.first
                                        //               .orderService ??
                                        //           ""),
                                        //   textAlign: TextAlign.center,
                                        //   style: GoogleFonts.inter(
                                        //     fontSize: Get.height / 45,
                                        //     color: AppColors.primaryColor,
                                        //     fontWeight: FontWeight.w600,
                                        //     letterSpacing: 1,
                                        //   ),
                                        // )
                                        Text(
                                          homeController.detailList.first.orderCustomer?.isNotEmpty == true
                                              ? homeController.detailList.first.orderCustomer!
                                              : "Customer",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            fontSize: Get.height / 45,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        )
                                        ,
                                        SizedBox(height: Get.height * 0.005),
                                        // Text(
                                        //   homeController.detailList.first
                                        //           .orderServicePriceFor ??
                                        //       "",
                                        //   style: GoogleFonts.inter(
                                        //     fontSize: Get.height / 50,
                                        //     color: AppColors.color54,
                                        //     fontWeight: FontWeight.w400,
                                        //   ),
                                        // ),
                                        (
                                            (homeController.detailList.first.orderService ?? "").toLowerCase() == "custom" &&
                                                (homeController.detailList.first.orderServicePriceFor ?? "0") == "0"
                                        )
                                            ? const SizedBox.shrink()
                                            : Text(
                                          homeController.detailList.first.orderServicePriceFor ?? "",
                                          style: GoogleFonts.inter(
                                            fontSize: Get.height / 50,
                                            color: AppColors.color54,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: Get.width * 0.02,
                                                vertical: Get.height * 0.005,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: AppColors.lightGoldColor,
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      "assets/images/svg/calendar.svg"),
                                                  SizedBox(width: Get.width * 0.02),
                                                  Text(
                                                    DateFormat("dd-MM-yyyy").format(
                                                        homeController
                                                            .detailList
                                                            .first
                                                            .orderServiceDate!),
                                                    style: GoogleFonts.inter(
                                                      fontSize: Get.height / 70,
                                                      color: AppColors.goldColor,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: Get.width * 0.02),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: Get.width * 0.02,
                                                vertical: Get.height * 0.005,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: AppColors.lightGoldColor,
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      "assets/images/svg/clock.svg"),
                                                  SizedBox(width: Get.width * 0.02),
                                                  Text(
                                                    DateFormat("hh:mm").format(
                                                        homeController
                                                            .detailList
                                                            .first
                                                            .orderServiceDate!),
                                                    style: GoogleFonts.inter(
                                                      fontSize: Get.height / 70,
                                                      color: AppColors.goldColor,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: Get.width * 0.02),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Get.width * 0.02,
                                                  vertical: Get.height * 0.005),
                                              decoration: const BoxDecoration(
                                                  color: AppColors.greenLightColor),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      "assets/images/svg/coin.svg"),
                                                  SizedBox(
                                                    width: Get.width * 0.02,
                                                  ),
                                                  Text(
                                                    homeController.detailList.first
                                                        .orderAmount
                                                        ?.toString() ??
                                                        "",
                                                    style: GoogleFonts.inter(
                                                      fontSize: Get.height / 70,
                                                      color: AppColors.greenColor,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: Get.height * 0.02),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                homeController.detailList.first.orderServiceDate != null &&
                                                    DateTime.now().isAfter(
                                                        homeController.detailList.first.orderServiceDate!.subtract(const Duration(days: 1)))
                                                    ? (homeController.detailList.first.orderAddress ?? '')
                                                    : [homeController.detailList.first.orderSubLocality, homeController.detailList.first.orderLocality]
                                                    .where((e) => e != null && e.trim().isNotEmpty)
                                                    .join(", "),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontSize: Get.height / 70,
                                                  color: AppColors.secondaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.02,
                                        ),
                                        Row(
                                          children: [
                                            /*  Transform.scale(
                                   scale: 0.7,
                                    child: Switch(
                                      value: isToggled,
                                      onChanged: (value) {
                                        setState(() {
                                          isToggled = value;
                                        });
                                      },
                                    ),
                                  ),*/
                                            /* Text(isToggled
                                      ? "Will receive payment latter"
                                      : "Payment detail"),*/
                                            Text(
                                              "Payment Received ?",
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: Get.width * 0.045,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.03,
                                            ),
                                            Expanded(
                                              child: PaymentChoiceWidget(
                                                onOptionSelected: (selected) {
                                                  isReceived = selected;
                                                  setState(() {});
                                                  if (selected ==
                                                      PaymentOption.collectNow) {
                                                    if (kDebugMode) {
                                                      print(
                                                          "✅ Collecting payment now");
                                                    }
                                                  } else {
                                                    if (kDebugMode) {
                                                      print(
                                                          "🚫 Not collecting payment now");
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (isReceived ==
                                            PaymentOption.collectNow) ...[
                                          SizedBox(
                                            height: Get.height * 0.02,
                                          ),
                                          CustomTextFormField(
                                            hintText:
                                            "Payment details eg. Account/UPI info.",
                                            maxLength: 100,
                                            counterText: "",
                                            controller: traDetailCon,
                                            /* validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Please enter payment detail";
                                    }
                                    return null;
                                  },*/
                                          ),
                                          SizedBox(height: Get.height * 0.02),
                                          CustomTextFormField(
                                            hintText: "Discount eg. ₹ 150",
                                            controller: discountCon,
                                            maxLength: 8,
                                            counterText: "",
                                            keyboardType: const TextInputType
                                                .numberWithOptions(decimal: true),
                                            /* validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Please enter discount";
                                    }
                                    return null;
                                  },*/
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.02,
                                          ),
                                          CustomTextFormField(
                                            hintText: "Payment received",
                                            maxLength: 10,
                                            counterText: "",
                                            keyboardType: const TextInputType
                                                .numberWithOptions(decimal: true),
                                            controller: totalAmCon,
                                            validator: (val) {
                                              if (val == null ||
                                                  val.trim().isEmpty) {
                                                return "Please enter amount received";
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.02,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Get.width * 0.04),
                                            decoration: BoxDecoration(
                                                color: AppColors.lightGrey,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        Get.height * 0.01)),
                                                border: Border.all(
                                                  color: showPaymentTypeError
                                                      ? Colors.red
                                                      : AppColors.grey,
                                                )),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                value: recINCashCon.text
                                                    .trim()
                                                    .isNotEmpty
                                                    ? recINCashCon.text
                                                    : null,
                                                hint: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                            Get.height *
                                                                0.01),
                                                        decoration: BoxDecoration(
                                                          color:
                                                          AppColors.lightGrey,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(
                                                                Get.height * 0.01),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "Payment type",
                                                          textAlign:
                                                          TextAlign.start,
                                                          style: GoogleFonts.inter(
                                                            fontSize:
                                                            Get.width * 0.045,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                items: [
                                                  "Received in cash",
                                                  "Google Pay",
                                                  "Bank"
                                                  //"Completed"
                                                ].map((item) {
                                                  return DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(item),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  FocusManager.instance.primaryFocus
                                                      ?.unfocus();
                                                  recINCashCon.text = value!;
                                                  showPaymentTypeError = false;
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          if (showPaymentTypeError)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: Get.width * 0.04, top: 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Please select payment type",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: Get.width * 0.03,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          /*       CustomTextFormField(
                                  hintText: "Payment type",
                                  controller: recINCashCon,
                                  readOnly: true,

                                  // Ensures only dropdown selection
                                  suffixIcon: PopupMenuButton<String>(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color: Colors.black),
                                    onSelected: (value) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      recINCashCon.text = value;
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      "Received in cash",
                                      "Google Pay",
                                      "Bank"
                                    ]
                                        .map((item) => PopupMenuItem<String>(
                                              value: item,
                                              child: Text(item),
                                            ))
                                        .toList(),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Please select payment type";
                                    }
                                    return null;
                                  },
                                ),*/
                                        ],
                                        SizedBox(
                                          height: Get.height * 0.02,
                                        ),
                                        CustomTextFormField(
                                          hintText: "Remarks here..",
                                          controller: remarkCon,
                                          maxLength: 150,
                                          maxLines: 3,
                                          /*validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return "Please enter remarks";
                                    }
                                    return null;
                                  },*/
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.04,
                                        ),
                                        CustomButton(
                                          radius: Get.height * 0.005,
                                          buttonText: 'Job Complete',
                                          backgroundColor: AppColors.greenColor,
                                          onTap: () async {
                                            if (recINCashCon.text.trim().isEmpty) {
                                              showPaymentTypeError = true;
                                            } else {
                                              showPaymentTypeError = false;
                                            }
                                            setState(() {});
                                            if (formKey.currentState!.validate()) {
                                              completeJobAlertDialog(
                                                  title: 'Mark Job as done ?',
                                                  description:
                                                  'Work completed and submit payment details. This action is final and cannot be changed.',
                                                  context: context,
                                                  onPressed: () async {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    if (isReceived ==
                                                        PaymentOption
                                                            .noCollectNow) {
                                                      remarkCon.clear();
                                                      recINCashCon.clear();
                                                      totalAmCon.clear();
                                                      discountCon.clear();
                                                      traDetailCon.clear();
                                                    }
                                                    EasyLoading.show(
                                                        status: ConstHelper
                                                            .pleaseWaitMsg);

                                                    await ApiHelper.apiHelper
                                                        .paymentUpdateApi(
                                                        ref: homeController
                                                            .detailList
                                                            .first
                                                            .orderRef ??
                                                            "",
                                                        paymentType:
                                                        recINCashCon.text,
                                                        amount: totalAmCon.text,
                                                        discount:
                                                        discountCon.text,
                                                        orderComment:
                                                        remarkCon.text,
                                                        transactionDetail:
                                                        traDetailCon.text)
                                                        .then((value) {
                                                      mapValue = value;
                                                      if (kDebugMode) {
                                                        print(value);
                                                      }
                                                      if (value.isNotEmpty) {
                                                        if (value['code'] == 200) {
                                                          EasyLoading.dismiss();
                                                          Get.back();
                                                          Get.back();
                                                          Get.back();
                                                          ConstHelper.successDialog(
                                                            text: value['msg'] ??
                                                                "Great job! Work completed successfully!",
                                                            seconds: 10,
                                                          );
                                                          //Get.snackbar(
                                                          //  "Success",
                                                          //  value['msg'] ??
                                                          //      "Great job! Work completed successfully!",
                                                          //  snackPosition: SnackPosition
                                                          //      .BOTTOM, // Position: TOP or BOTTOM
                                                          //);
                                                        } else {
                                                          EasyLoading.dismiss();
                                                          ConstHelper.errorDialog(
                                                            text:
                                                            "Unable to update work status. Retry?",
                                                            seconds: 10,
                                                          );
                                                          // Get.snackbar(
                                                          //   "Failed",
                                                          //   "Unable to update work status. Retry?",
                                                          //   snackPosition: SnackPosition
                                                          //       .BOTTOM, // Position: TOP or BOTTOM
                                                          // );
                                                        }
                                                      }
                                                    });
                                                  });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class PaymentChoiceWidget extends StatefulWidget {
  final Function(PaymentOption) onOptionSelected;

  const PaymentChoiceWidget({super.key, required this.onOptionSelected});

  @override
  PaymentChoiceWidgetState createState() => PaymentChoiceWidgetState();
}

class PaymentChoiceWidgetState extends State<PaymentChoiceWidget> {
  PaymentOption _selectedOption = PaymentOption.collectNow;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RadioListTile<PaymentOption>(
            title: const Text("Yes"),
            value: PaymentOption.collectNow,
            groupValue: _selectedOption,
            dense: true,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.black,
            // <-- Set primary color here
            onChanged: (value) {
              setState(() {
                _selectedOption = value!;
              });
              widget.onOptionSelected(value!);
            },
          ),
        ),
        Expanded(
          child: RadioListTile<PaymentOption>(
            title: const Text("No"),
            value: PaymentOption.noCollectNow,
            groupValue: _selectedOption,
            dense: true,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.black,
            // <-- Set primary color here
            onChanged: (value) {
              setState(() {
                _selectedOption = value!;
              });
              widget.onOptionSelected(value!);
            },
          ),
        ),
      ],
    );
  }
}

void completeJobAlertDialog({
  required String title,
  required String description,
  required BuildContext context,
  required void Function() onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: Get.height / 50,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Text(
              description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: AppColors.black.withAlpha(204),
                  fontSize: Get.height / 55,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  height: 1.5),
            ),
          ],
        ),
        actions: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6))),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          letterSpacing: 1,
                          fontSize: Get.height / 60,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6))),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: Get.height / 60,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    },
  );
}
