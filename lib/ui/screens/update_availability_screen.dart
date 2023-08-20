import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';
import 'package:rokto_bondhu/ui/widgets/my_button.dart';

class UpdateAvailabilityScreen extends StatefulWidget {
  const UpdateAvailabilityScreen({Key? key}) : super(key: key);

  @override
  State<UpdateAvailabilityScreen> createState() => _UpdateAvailabilityScreenState();
}

class _UpdateAvailabilityScreenState extends State<UpdateAvailabilityScreen> {

  final isAvailable = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool inProgress = false;
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> updateAvailability() async {
    if (_formKey.currentState!.validate()) {
      inProgress = true;
      setState(() {});
      final DocumentReference documentReference = FirebaseFirestore.instance.collection('donors').doc(currentUser?.uid);
      try {
        await documentReference.update({
          'isAvailable': isAvailable.text,
        });
        inProgress = false;
        setState(() {});
        Fluttertoast.showToast(msg: "Status changed successfully.");
      } catch (e) {
        inProgress = false;
        setState(() {});
        print('Error updating field: $e');
      }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: ColorManager.red,
        title: Text(
          "Update Availability",
        ),
        centerTitle: true,

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Flexible(
                      child: DropdownButtonFormField(
                        validator: (value) =>
                        value == null ? "Do you want to be a donor?" : null,
                        onChanged: (String? val) {
                          setState(() {
                          });
                          isAvailable.text = val!;

                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        hint: Text("Are you available to donate?"),
                        items: [
                          DropdownMenuItem(
                            child: Text("Yes"),
                            value: "Yes",
                          ),
                          DropdownMenuItem(
                            child: Text("No"),
                            value: "NO",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            MyButton(visible: inProgress, voidCallback: updateAvailability, text: 'Update Availability')
          ],
        ),
      ),
    );
  }
}
