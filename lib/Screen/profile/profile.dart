import 'package:admin/Screen/Aunthentication/login.dart';
import 'package:admin/Service/session.dart';
import 'package:admin/Service/user_service.dart';
import 'package:admin/color.dart';
import 'package:admin/main.dart';
import 'package:admin/snackbar_utils.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> _user = {};
  late bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      var user = await UserService().getUser();
      setState(() {
        _user = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      SnackbarUtils.showErrorSnackbar(
          context, 'Terjadi kesalahan, coba lagi nanti');
    }
  }

  void _logout() async {
    await SessionManager.clearToken();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FirstScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage('images/img-icon.png'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: primaryColor,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "${_user['username'] ?? ''}",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "HP ${_user['noHp'] ?? ''}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 30),
                    Divider(thickness: 1.5),
                    // SizedBox(height: 20),
                    // ListTile(
                    //   leading: Icon(Icons.account_circle, color: Colors.blueAccent),
                    //   title: Text('Account Settings'),
                    //   trailing: Icon(Icons.arrow_forward_ios),
                    //   onTap: () {
                    //     // Navigate to account settings
                    //   },
                    // ),
                    // Divider(thickness: 1.5),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        _logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
