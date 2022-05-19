import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laboratoire_app/Service/AuthService/authservice.dart';

class BottomUserInfo extends StatelessWidget {
  final bool isCollapsed;
  final bool isConn;

  const BottomUserInfo({
    Key key, this.isCollapsed, this.isConn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isCollapsed ? 70 : 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isCollapsed
          ? Center(
              child: Row(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: isConn ? TextButton(
                                onPressed: () {
                                  AuthService.signOut();
                                  Get.offAllNamed('/HomePage');
                                },
                                  
                              child: const Text(
                                "Log Out",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                            ): TextButton( 
                                onPressed : () {
                                  Get.toNamed(
                                    "/AuthScreen",
                                  );
                                },
                                child: const Text(
                                "Log In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: isConn ? IconButton(
                        onPressed: () {
                          AuthService.signOut();
                          Get.offAllNamed('/HomePage');
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ): IconButton(
                        onPressed: () {
                         Get.toNamed(
                            "/AuthScreen",
                          );
                        },
                        icon: const Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: isConn ? IconButton(
                    onPressed: () {
                      AuthService.signOut();
                      Get.offAllNamed('/HomePage');
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 20,
                    ),
                  ): IconButton(
                    onPressed: () {
                      Get.toNamed(
                        "/AuthScreen",
                      );
                    },
                    icon: const Icon(
                      Icons.login,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                ),
              ],
            ),
    );
  }
}
