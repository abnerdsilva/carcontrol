import 'package:carcontrol/shared/components/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplyPage extends StatelessWidget {
  const SupplyPage({Key? key}) : super(key: key);

  static const String route = '/supply';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 22),
                    const Center(
                      child: Text(
                        'Abastecimento',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text('Data'),
                    const CustomTextFormField(),
                    const Text('Hora'),
                    const CustomTextFormField(),
                    const Text('Preço combustível'),
                    const CustomTextFormField(),
                    const Text('Litros'),
                    const CustomTextFormField(),
                    const Text('Tipo combustível'),
                    const CustomTextFormField(),
                    const SizedBox(height: 22),
                    TextFormField(
                      minLines: 2,
                      maxLines: 4,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        labelText: 'Observação',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Lançar'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
