import 'package:Ngoerahsun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:Ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:Ngoerahsun/widgets/gradient_background/gradient_background.dart';
import 'package:intl/intl.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: AppColors.primary, size: 20),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.terms_conditions,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                  children: const [
                    TextSpan(
                      text: "1. Acceptance of Terms\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text:
                          "By accessing or using the Ngoerah Sun Healthcare application (\"Service\"), you agree to be bound by these Terms and Conditions. If you disagree with any part of the terms, you may not access the Service.\n\n",
                    ),
                    TextSpan(
                      text: "2. Medical Disclaimer\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text:
                          "The information provided through our Service is not intended to be a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.\n\n",
                    ),
                    TextSpan(
                      text: "3. Appointment Booking\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "3.1 Booking Confirmation\n"
                          "All appointments are subject to confirmation by the medical provider.\n\n"
                          "3.2 Cancellation Policy\n"
                          "Appointments can be cancelled or rescheduled up to 2 hours before the scheduled time without penalty. Late cancellations may incur charges as per our cancellation policy.\n\n"
                          "3.3 Accuracy of Information\n"
                          "You are responsible for providing accurate personal and medical information when booking appointments.\n\n",
                    ),
                    TextSpan(
                      text: "4. User Accounts\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "4.1 Registration\n"
                          "To use certain features of our Service, you may be required to register for an account. You must provide accurate and complete information and keep your account information updated.\n\n"
                          "4.2 Account Security\n"
                          "You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password.\n\n",
                    ),
                    TextSpan(
                      text: "5. Privacy Policy\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text:
                          "Your use of our Service is also governed by our Privacy Policy, which is incorporated by reference into these Terms and Conditions. Please review our Privacy Policy to understand our practices regarding your personal data.\n\n",
                    ),
                    TextSpan(
                      text: "6. Payments\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "6.1 Fees\n"
                          "Some services may require payment. All fees are in Indonesian Rupiah (IDR) unless otherwise stated.\n\n"
                          "6.2 Refund Policy\n"
                          "Refunds are processed according to our refund policy, which may vary based on the service provided and the circumstances of cancellation.\n\n",
                    ),
                    TextSpan(
                      text: "7. Modifications to Service\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text:
                          "We reserve the right to modify or discontinue, temporarily or permanently, the Service (or any part thereof) with or without notice. You agree that we shall not be liable to you or to any third party for any modification, suspension, or discontinuance of the Service.\n\n",
                    ),
                    TextSpan(
                      text: "8. Limitation of Liability\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text:
                          "In no event shall Ngoerah Sun Healthcare, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the Service.\n\n",
                    ),
                    TextSpan(
                      text: "9. Governing Law\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text:
                          "These Terms shall be governed and construed in accordance with the laws of Indonesia, without regard to its conflict of law provisions.\n\n",
                    ),
                    TextSpan(
                      text: "10. Contact Us\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text:
                          "If you have any questions about these Terms, please contact us at support@ngoerahsun.co.id or call our customer service at +62 888-999-0922.\n\n",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Last updated: September 15, 2025",
                  style: TextStyle(
                    color: AppColors.paleSkyColor,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
