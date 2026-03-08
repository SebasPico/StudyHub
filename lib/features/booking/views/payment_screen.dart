import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';

/// Pantalla de pago simulado (RF-11).
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;

  final _paymentMethods = [
    {'icon': Icons.account_balance_wallet, 'name': 'Nequi', 'desc': '**** 4532'},
    {'icon': Icons.credit_card, 'name': 'Tarjeta de crédito', 'desc': '**** 8721'},
    {'icon': Icons.paypal_outlined, 'name': 'PayPal', 'desc': 'usuario@email.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pago')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen del monto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Total a pagar',
                      style: AppTextStyles.body2.copyWith(color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text('\$45.000',
                      style: AppTextStyles.heading1.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Clase de Programación en Dart - 60 min',
                      style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Método de pago
            Text('Método de pago', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            ...List.generate(_paymentMethods.length, (index) {
              final method = _paymentMethods[index];
              final isSelected = _selectedMethod == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedMethod = index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.06)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(method['icon'] as IconData,
                          color:
                              isSelected ? AppColors.primary : AppColors.textHint),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(method['name'] as String,
                                style: AppTextStyles.subtitle1),
                            Text(method['desc'] as String,
                                style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      Radio<int>(
                        value: index,
                        groupValue: _selectedMethod,
                        onChanged: (v) =>
                            setState(() => _selectedMethod = v!),
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar método de pago'),
            ),

            const Spacer(),

            // Política de cancelación (RF-12)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Reembolso completo si cancelas con al menos 24 horas de antelación.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            PrimaryButton(
              text: 'Pagar \$45.000',
              icon: Icons.lock_outline,
              onPressed: () {
                _showPaymentSuccess(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showPaymentSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            Text('¡Pago exitoso!', style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            Text(
              'Tu clase ha sido agendada. El tutor recibirá una notificación.',
              style: AppTextStyles.body2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Ver mis clases',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
