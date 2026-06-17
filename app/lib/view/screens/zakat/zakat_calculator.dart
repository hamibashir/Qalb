// ignore_for_file: non_constant_identifier_names, deprecated_member_use, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qalb/controller/quran_settings_controller.dart';
import 'package:qalb/helper/route_helper.dart';
import 'package:qalb/util/images.dart';
import 'package:qalb/view/base/custom_app_bar.dart';
import 'package:qalb/view/base/custom_button.dart';
import 'package:qalb/view/screens/zakat/item_field.dart';
import 'package:qalb/view/screens/zakat/result_field.dart';
import '../../../controller/zakat_calculator_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

class ZakatCalculator extends StatefulWidget {
  final bool appBackButton;
  const ZakatCalculator({super.key, required this.appBackButton});

  @override
  State<ZakatCalculator> createState() => _ZakatCalculatorState();
}

class _ZakatCalculatorState extends State<ZakatCalculator> {
  // helper widgets
  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: robotoMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE,
                color: Theme.of(context).primaryColor,
              ),
            ),
            if (subtitle != null && subtitle.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.justify,
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
              ),
            ],
            const SizedBox(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: Theme.of(context).primaryColor.withOpacity(0.3), thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: robotoMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Divider(color: Theme.of(context).primaryColor.withOpacity(0.3), thickness: 1)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.find<SettingsController>().fetchMosqueSettingsData();
    return Scaffold(
      // Appbar start ===>
      appBar: CustomAppBar(
        title: "zakat_calculator".tr,
        isBackButtonExist: widget.appBackButton == true ? true : false,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RouteHelper.zakatDetaile);
            },
            icon: SvgPicture.asset(
              Images.Icon_Details,
              color: Get.isDarkMode
                  ? Theme.of(context).textTheme.bodyMedium!.color
                  : Theme.of(context).cardColor,
              height: 28,
            ),
          )
        ],
      ),

      // body start
      body: SingleChildScrollView(
        child: GetBuilder<ZakatCalculatorController>(
          init: ZakatCalculatorController(),
          initState: (_) {},
          builder: (zakatCalculatorController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Form(
                key: zakatCalculatorController.zakatCalculatorformkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(context, "what_i_own".tr),

                    _buildSectionCard(
                      context: context,
                      title: "my_cash".tr,
                      subtitle: "enter_the_amount_of_cash_you_have".tr,
                      children: [
                        ItemField(
                          fieldName: "cash_in_bank_accounts".tr,
                          controllerValue: zakatCalculatorController.own_bank_cash,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "cash_in_hand".tr,
                          controllerValue: zakatCalculatorController.own_cash,
                        ),
                      ],
                    ),

                    _buildSectionCard(
                      context: context,
                      title: "money_owed_to_me".tr,
                      subtitle: "if_you_have_lent_money_to_someone_and_are_confident_it_will_be_repaid".tr,
                      children: [
                        ItemField(
                          fieldName: "loan".tr,
                          controllerValue: zakatCalculatorController.own_loan,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "money_expected_from_a_sale".tr,
                          controllerValue: zakatCalculatorController.own_money_expected,
                        ),
                      ],
                    ),

                    _buildSectionCard(
                      context: context,
                      title: "my_gold_and_silver".tr,
                      subtitle: "if_you_are_not_sure_how_much_your_gold_and_silver".tr,
                      children: [
                        ItemField(
                          fieldName: "gold".tr,
                          controllerValue: zakatCalculatorController.own_gold,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "silver".tr,
                          controllerValue: zakatCalculatorController.own_silver,
                        ),
                      ],
                    ),

                    _buildSectionCard(
                      context: context,
                      title: "my_shares".tr,
                      subtitle: "if_you_own_stocks_and_shares_zakat_is_due_on_them".tr,
                      children: [
                        ItemField(
                          fieldName: "sharesbought_exclusively_to_resell_for_capital_gain".tr,
                          controllerValue: zakatCalculatorController.own_shares_bought_exclusively,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "shares_bought_for_any_other_reason".tr,
                          controllerValue: zakatCalculatorController.own_shares_bought,
                        ),
                      ],
                    ),

                    _buildSectionCard(
                      context: context,
                      title: "my_pensions".tr,
                      subtitle: "if_you_have_a_defined_contribution_pension_scheme".tr,
                      children: [
                        ItemField(
                          fieldName: "amount_of_pension".tr,
                          controllerValue: zakatCalculatorController.own_pension,
                        ),
                      ],
                    ),

                    _buildSectionCard(
                      context: context,
                      title: "my_ISAs_junior_ISAs_and_child_trust_funds".tr,
                      subtitle: "zakat_is_payable_on_ISAs_and_Child_Trust_Funds".tr,
                      children: [
                        ItemField(
                          fieldName: "stocks_and_shares_ISA_CTF".tr,
                          controllerValue: zakatCalculatorController.own_stocks,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "cash_ISA".tr,
                          controllerValue: zakatCalculatorController.own_cash_isa,
                        ),
                      ],
                    ),

                    _buildSectionCard(
                      context: context,
                      title: "my_crypto".tr,
                      subtitle: "enter_the_value_of_any_cryptocurrencies_you_own_in_pounds".tr,
                      children: [
                        ItemField(
                          fieldName: "cryptocurrency_value".tr,
                          controllerValue: zakatCalculatorController.own_cryptocurrency,
                        ),
                      ],
                    ),

                    _buildSectionCard(
                      context: context,
                      title: "my_business_assets".tr,
                      subtitle: "business_assets_include_cash".tr,
                      children: [
                        ItemField(
                          fieldName: "business_cash".tr,
                          controllerValue: zakatCalculatorController.own_business_cash,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "business_receivables".tr,
                          controllerValue: zakatCalculatorController.own_business_receivables,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "business_stock".tr,
                          controllerValue: zakatCalculatorController.own_business_stock,
                        ),
                      ],
                    ),

                    _buildSectionHeader(context, "money_i_owe".tr),

                    _buildSectionCard(
                      context: context,
                      title: "for_long_term_debts".tr,
                      children: [
                        ItemField(
                          fieldName: "mortgage".tr,
                          controllerValue: zakatCalculatorController.owe_mortgage,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "utility_bills".tr,
                          controllerValue: zakatCalculatorController.owe_utility_bills,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "personal_loans".tr,
                          controllerValue: zakatCalculatorController.owe_personal_loans,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "overdraft".tr,
                          controllerValue: zakatCalculatorController.owe_overdraft,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "credit_card".tr,
                          controllerValue: zakatCalculatorController.owe_credit_card,
                        ),
                        const SizedBox(height: 10),
                        ItemField(
                          fieldName: "business_liabilities".tr,
                          controllerValue: zakatCalculatorController.owe_business_libilities,
                        ),
                      ],
                    ),

                    _buildSectionHeader(context, "all_done".tr),

                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ResultField(
                                      readOnly: true,
                                      labelText: "what_i_have".tr,
                                      controllerValue: zakatCalculatorController.totalOwn),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ResultField(
                                      readOnly: true,
                                      labelText: "what_i_owe".tr,
                                      controllerValue: zakatCalculatorController.totalOwe),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ResultField(
                                        readOnly: true,
                                        labelText: "is_equal_to".tr,
                                        controllerValue: zakatCalculatorController.equal),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ResultField(
                                      readOnly: zakatCalculatorController.isApiNisabExist.text == "" ? false : true,
                                      labelText: "todays_nisab".tr,
                                      controllerValue: Get.find<SettingsController>()
                                                  .mosqueSettingsApiData!
                                                  .data!
                                                  .automaticPayerTime ==
                                              true
                                          ? zakatCalculatorController.totalNisab
                                          : zakatCalculatorController.isApiNisabExist,
                                      onSaved: (value) {
                                        zakatCalculatorController.nisab = value!;
                                      },
                                      validator: (value) {
                                        return zakatCalculatorController.validateTotalNisab(value!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Highlighted Final Zakat Amount
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      ),
                      child: TextField(
                        readOnly: true,
                        keyboardType: TextInputType.none,
                        controller: zakatCalculatorController.totalZakat,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          labelText: "my_zakat_is".tr,
                          labelStyle: TextStyle(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                            fontWeight: FontWeight.w400,
                          ),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    CustomButton(
                        buttonWidth: Get.width,
                        buttonName: "click_for_result".tr,
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        onPressed: () {
                          final isValidForm = zakatCalculatorController
                              .zakatCalculatorformkey.currentState!
                              .validate();
                          if (isValidForm) {
                            zakatCalculatorController.getTotalOwn();
                            zakatCalculatorController.getTotalOwe();
                            zakatCalculatorController.getEqual();
                            zakatCalculatorController.getZakat();
                          }
                        }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
