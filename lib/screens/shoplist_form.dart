import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/left_drawer.dart';

class ShopFormPage extends StatefulWidget {
    const ShopFormPage({super.key});

    @override
    State<ShopFormPage> createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
    final _formKey = GlobalKey<FormState>();
    String _name = "";
    int _price = 0;
    String _description = "";

    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
            appBar: AppBar(
                title: const Center(
                child: Text(
                    'Add Product Form',
                ),
                ),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
            ),
            // TODO: Add the previously created drawer here
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Product Name",
                                    labelText: "Product Name",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                    ),
                                ),
                                onChanged: (String? value) {
                                    setState(() {
                                        _name = value!;
                                    });
                                },
                                validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                        return "Name cannot be empty!";
                                    }
                                    return null;
                                },
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Price",
                                    labelText: "Price",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                    ),
                                ),
                                onChanged: (String? value) {
                                    setState(() {
                                        _price = int.parse(value!);
                                    });
                                },
                                validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                        return "Price cannot be empty!";
                                    }
                                    if (int.tryParse(value) == null) {
                                        return "Price must be a number!";
                                    }
                                    return null;
                                },
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                hintText: "Description",
                                labelText: "Description",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                ),
                                ),
                                onChanged: (String? value) {
                                setState(() {
                                    _description = value!;
                                });
                                },
                                validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                    return "Description cannot be empty!";
                                }
                                return null;
                                },
                            ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(Colors.indigo),
                                ),
                                onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                        // Send request to Django and wait for the response
                                        // TODO: Change the URL to your Django app's URL. Don't forget to add the trailing slash (/) if needed.
                                        final response = await request.postJson(
                                        "http://127.0.0.1:8000/create-flutter/",
                                        jsonEncode(<String, String>{
                                            'name': _name,
                                            'price': _price.toString(),
                                            'description': _description,
                                            // TODO: Adjust the fields with your Django model
                                        }));
                                        if (response['status'] == 'success') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                            content: Text("New product has saved successfully!"),
                                            ));
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => MyHomePage()),
                                            );
                                        } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                content:
                                                    Text("Something went wrong, please try again."),
                                            ));
                                        }
                                    }
                                },
                                child: const Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                ),
                                ),
                                
                            ),
                        ),
                        ],
                    ),
                ),
            ),
        );
    }
}