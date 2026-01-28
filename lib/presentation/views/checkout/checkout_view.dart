import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/orders_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/biometric_service.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final cartController = Get.find<CartController>();
    final ordersController = Get.find<OrdersController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _OrderSummaryCard(cartController: cartController),
            const SizedBox(height: 24),
            Text(
              'Shipping Address',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _ShippingForm(formKey: formKey),
            const SizedBox(height: 24),
            _PlaceOrderButton(
              formKey: formKey,
              ordersController: ordersController,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final CartController cartController;
  const _OrderSummaryCard({required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...cartController.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.productName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text(
                  '\$${cartController.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShippingForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  const _ShippingForm({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'address',
            decoration: const InputDecoration(
              labelText: 'Address',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'city',
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: FormBuilderValidators.required(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FormBuilderTextField(
                  name: 'state',
                  decoration: const InputDecoration(labelText: 'State'),
                  validator: FormBuilderValidators.required(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'postalCode',
                  decoration: const InputDecoration(labelText: 'Postal Code'),
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.required(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FormBuilderTextField(
                  name: 'country',
                  decoration: const InputDecoration(labelText: 'Country'),
                  validator: FormBuilderValidators.required(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlaceOrderButton extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final OrdersController ordersController;
  const _PlaceOrderButton({
    required this.formKey,
    required this.ordersController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton(
        onPressed: ordersController.isCreatingOrder
            ? null
            : () => _placeOrder(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: ordersController.isCreatingOrder
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Place Order'),
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!(formKey.currentState?.saveAndValidate() ?? false)) return;
    final biometricService = Get.find<BiometricService>();
    if (await biometricService.canAuthenticate()) {
      final authenticated = await biometricService.authenticate(
        reason: 'Confirm your order',
      );
      if (!authenticated) {
        Get.snackbar('Authentication Failed', 'Please try again');
        return;
      }
    }
    final values = formKey.currentState!.value;
    await ordersController.createOrder(
      shippingAddressLine1: values['address'] as String?,
      shippingCity: values['city'] as String?,
      shippingStateProvince: values['state'] as String?,
      shippingPostalCode: values['postalCode'] as String?,
      shippingCountry: values['country'] as String?,
      paymentMethod: 'credit_card',
    );
  }
}
