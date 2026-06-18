import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';

class DonationTypeScreen extends StatelessWidget {
  final bool appBackButton;

  const DonationTypeScreen({super.key, required this.appBackButton});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> organizations = [
      {
        'title': 'Alkhidmat Foundation Pakistan',
        'bank': 'Bank of Punjab (Taqwa Islamic Banking)',
        'account': '5310067845100016',
        'iban': 'PK19BPUN5310067845100016',
        'url': 'https://alkhidmat.org/',
      },
      {
        'title': 'Islamic Relief',
        'bank': 'Askari Bank Limited (Branch: F-10 Markaz)',
        'account': '00260100022000',
        'iban': 'PK69ASCM0000260100022000',
        'url': 'https://islamic-relief.org.pk/',
      },
      {
        'title': 'Abdul Sattar Edhi Foundation',
        'bank': 'Allied Bank Ltd',
        'account': '0010016462880030',
        'iban': 'PK50ABPA0010016462880030',
        'url': 'https://www.edhi.org/',
      },
      {
        'title': 'Shifa Foundation',
        'bank': 'Faysal Bank',
        'account': 'PK94FAYS0169150900218363',
        'iban': '', // only format given
        'url': 'https://shifafoundation.org/',
      },
      {
        'title': 'Chhipa Welfare Association',
        'bank': 'MEEZAN BANK LTD',
        'account': '0103970978',
        'iban': 'PK58MEZN0001480103970978',
        'url': 'https://www.chhipa.org/',
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: "donation".tr,
        isBackButtonExist: appBackButton,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
              itemCount: organizations.length,
              itemBuilder: (context, index) {
                final org = organizations[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).cardColor,
                  shadowColor: Get.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                  child: ExpansionTile(
                    title: Text(
                      org['title'] ?? '',
                      style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      child: Icon(Icons.volunteer_activism, color: Theme.of(context).primaryColor),
                    ),
                    childrenPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(context, "Bank Name:", org['bank'] ?? ''),
                      if ((org['account'] ?? '').isNotEmpty && org['account'] != org['iban'])
                        _buildDetailRow(context, "Account No:", org['account'] ?? ''),
                      if ((org['iban'] ?? '').isNotEmpty)
                        _buildDetailRow(context, "IBAN:", org['iban'] ?? ''),
                      if ((org['url'] ?? '').isNotEmpty) ...[
                        const Divider(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Always verify donation details from the organization's official website before making a donation.",
                                style: robotoRegular.copyWith(
                                  fontSize: 10,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            TextButton.icon(
                              onPressed: () async {
                                final url = Uri.parse(org['url']!);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                }
                              },
                              icon: const Icon(Icons.open_in_new, size: 16),
                              label: const Text("Visit Website"),
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: robotoMedium.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: Dimensions.FONT_SIZE_SMALL,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                Get.snackbar(
                  'Copied', 
                  '$label copied to clipboard',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Theme.of(context).primaryColor,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Icon(Icons.copy, size: 16, color: Theme.of(context).primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
