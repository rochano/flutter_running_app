import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/models/user.dart';
import 'package:running_app/providers/provider.dart';
import 'package:running_app/util/string_util.dart';
import 'package:running_app/widget/edit_profile_expansion_panel.dart';
import 'package:running_app/widget/image_input.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  DateTime _selectedBirthDate = DateTime.now();
  double _selectedWeight = 50.0;
  double _selectedHeight = 150;
  String _pickedImage;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _editData = {
    'firstName': '',
    'lastName': '',
    'gender': '0',
  };
  var _isInit = true;
  var _isLoading = false;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage.path;
  }

  Widget buildDoneBtn(BuildContext context, Size deviceSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        height: 45,
        width: deviceSize.width,
        //color: Colors.white,
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: () {
            _submit(context);
          },
          child: Expanded(
            child: _isLoading
                ? CircularProgressIndicator()
                : Text(
                    "DONE",
                    style: TextStyle(
                      color: Colors.white,
                      // letterSpacing: 1.5,
                      fontSize: 14.0,
                    ),
                  ),
          ),
          color: kPrimaryColor,
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void updateProfile(BuildContext context) async {
    User user = new User(
      firstName: _editData['firstName'],
      lastName: _editData['lastName'],
      gender: _editData['gender'],
      birthDate: StringUtils.convertDateToString(_selectedBirthDate),
      weight: _selectedWeight,
      height: _selectedHeight,
      image: _pickedImage
    );
    await Provider.of<UserProvider>(context, listen: false).updateUser(user);
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      // // Sign user up
      await updateProfile(context);
      Navigator.of(context).pop();
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        final user = Provider.of<UserProvider>(context).user;
        setState(() {
          _editData['firstName'] = user.firstName;
          _editData['lastName'] = user.lastName;
          if (user.gender != null && user.gender.isNotEmpty) {
            _editData['gender'] = user.gender;
          }
          if (user.birthDate != null && user.gender.isNotEmpty) {
            _selectedBirthDate = user.getBirthDate();
          }
          if (user.weight != 0) {
            _selectedWeight = user.weight;
          }
          if (user.height != 0) {
            _selectedHeight = user.height;
          }
          _pickedImage = user.image;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    List<EditProfileItem> children = <EditProfileItem>[
      EditProfileItem(
          id: 0,
          title: "Birth Date",
          value: _selectedBirthDate,
          display: (DateTime value) {
            return DateFormat.yMMMEd().format(value);
          },
          callback: (DateTime newdate) {
            setState(() {
              _selectedBirthDate = newdate;
            });
          }),
      EditProfileItem(
          id: 1,
          title: "Weight",
          value: _selectedWeight,
          display: (double value) {
            return "${NumberFormat('0.0').format(value)}  KG.";
          },
          callback: (double weight) {
            setState(() {
              _selectedWeight = weight;
            });
          }),
      EditProfileItem(
          id: 2,
          title: "Height",
          value: _selectedHeight,
          display: (double value) {
            return "${NumberFormat('0').format(value)}  CM.";
          },
          callback: (double height) {
            setState(() {
              _selectedHeight = height;
            });
          }),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Edit Profile",
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              // width: deviceSize.width * 0.85,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              // color: Colors.black,
                              // borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.blueAccent)),
                          child: ImageInput(_pickedImage, _selectImage),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  height: 45,
                                  child: TextFormField(
                                    initialValue: _editData['firstName'],
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 14,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'First Name',
                                      // border: InputBorder.none,
                                      prefixIcon: Icon(Icons.person_outline),
                                      contentPadding: EdgeInsets.all(8.0),
                                    ),
                                    keyboardType: TextInputType.text,
                                    onSaved: (value) {
                                      _editData['firstName'] = value;
                                    },
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  child: TextFormField(
                                    initialValue: _editData['lastName'],
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 14,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Last Name',
                                      // border: InputBorder.none,
                                      prefixIcon:
                                          Icon(Icons.family_restroom_outlined),
                                      contentPadding: EdgeInsets.all(8.0),
                                    ),
                                    keyboardType: TextInputType.text,
                                    onSaved: (value) {
                                      _editData['lastName'] = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.8, color: kTextColor),
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: 8),
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Container(
                            width: deviceSize.width * 0.4,
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Gender",
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(left: 5),
                              height: 25,
                              child: ToggleButtons(
                                isSelected: List<bool>.generate(
                                  2,
                                  (int index) {
                                    return _editData["gender"] ==
                                        index.toString();
                                  },
                                ),
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 80,
                                    child: Text("Male"),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 80,
                                    child: Text("Female"),
                                  )
                                ],
                                selectedColor: Colors.white,
                                fillColor: kPrimaryColor,
                                onPressed: (int index) {
                                  setState(() {
                                    _editData["gender"] = index.toString();
                                  });
                                },
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    EditProfileExpansionPanelList(
                      children: children,
                    ),
                    Container(
                      width: deviceSize.width * 0.85,
                      child: buildDoneBtn(context, deviceSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
