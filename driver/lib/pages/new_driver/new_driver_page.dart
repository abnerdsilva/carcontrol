import 'package:carcontrol/pages/new_driver_analyse/new_driver_analyze_page.dart';
import 'package:carcontrol/shared/components/custom_button.dart';
import 'package:carcontrol/shared/components/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class NewDriverPage extends StatelessWidget {
  const NewDriverPage({Key? key}) : super(key: key);

  static const String route = '/new-driver';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  //child: Image.asset('assets/images/carro.png'),
                  ),
              /*const Text(
                'Cadastro de motorista',
                style: TextStyle(fontSize: 18),
              ),*/
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.of(context).size.width * .7,
                child: const CustomTextFormField(
                  radiusBorder: 10,
                  heightWithLabel: 53,
                  height: 30,
                  label: 'Nome Completo',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * .7,
                child: const CustomTextFormField(
                  radiusBorder: 10,
                  heightWithLabel: 53,
                  height: 30,
                  label: 'Data de Nascimento',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * .7,
                child: const CustomTextFormField(
                  radiusBorder: 10,
                  heightWithLabel: 53,
                  height: 30,
                  label: 'Celular',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * .7,
                child: const CustomTextFormField(
                  radiusBorder: 10,
                  heightWithLabel: 53,
                  height: 30,
                  label: 'Cidade',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * .7,
                child: const CustomTextFormField(
                  radiusBorder: 10,
                  heightWithLabel: 53,
                  height: 30,
                  label: 'Email',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * .7,
                child: const CustomTextFormField(
                  radiusBorder: 10,
                  heightWithLabel: 53,
                  height: 30,
                  label: 'Veiculo',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * .7,
                child: const CustomTextFormField(
                  radiusBorder: 10,
                  heightWithLabel: 53,
                  height: 30,
                  label: 'Número da CNH',
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Prosseguir',
                fontSize: 22,
                height: 55,
                alignment: Alignment.center,
                onClick: () => Navigator.popAndPushNamed(
                    context, NewDriverAnalyzePage.route),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
