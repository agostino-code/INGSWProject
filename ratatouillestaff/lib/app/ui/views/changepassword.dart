import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:ratatouillestaff/app/controllers/changepassword_controller.dart';


class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({super.key, required this.firstLogin});

  final ChangePasswordController _controller = ChangePasswordController();
  final TextEditingController _strenghtcontroller = TextEditingController();

  final bool firstLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (firstLogin) {
                      _controller.refused();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text('Modifica password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                ),
              ],
            ),
            if (firstLogin)
              const SizedBox(
                height: 10,
              ),
            if (firstLogin)
              const Text(
                'È il tuo primo login modifica la password che ti è stata assegnata',
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              onChanged: (value) {
                _controller.password = value;
              },
              obscureText: true,
              obscuringCharacter: '*',
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
              ],
              decoration: const InputDecoration(
                labelText: 'Vecchia password',
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              onChanged: (value) {
                _controller.newPassword.value = value;
              },
              obscureText: true,
              obscuringCharacter: '*',
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
              ],
              controller: _strenghtcontroller,
              decoration: const InputDecoration(
                labelText: 'Nuova password',
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ValueListenableBuilder(
              valueListenable: _controller.newPassword,
              builder: (BuildContext context, value, Widget? child) {
                if (value!.isNotEmpty) {
                  return FlutterPwValidator(
                    controller: _strenghtcontroller,
                    minLength: 8,
                    uppercaseCharCount: 1,
                    numericCharCount: 1,
                    specialCharCount: 1,
                    normalCharCount: 1,
                    width: 350,
                    height: 150,
                    onSuccess: () {},
                    defaultColor: Theme.of(context).colorScheme.onError,
                    successColor: Theme.of(context).colorScheme.primary,
                  );
                } else {
                  return const SizedBox(
                    height: 50,
                  );
                }
              },
            ),
            TextField(
              onChanged: (value) {
                _controller.confirmPassword = value;
              },
              obscureText: true,
              obscuringCharacter: '*',
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
              ],
              decoration: const InputDecoration(
                labelText: 'Conferma la nuova password',
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 600,
                height: 60,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    _controller.changePassword();
                  },
                  label: Text(
                    'Salva',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontFamily: 'Actor'),
                  ),
                  elevation: 10,
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
