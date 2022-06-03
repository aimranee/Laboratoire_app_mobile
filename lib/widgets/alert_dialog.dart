import 'package:flutter/material.dart';
class SimpleCustomAlert1 extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  // ignore: use_key_in_widget_constructors
  const SimpleCustomAlert1(this.title);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4)
      ),
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white70,
                child: const Icon(Icons.account_balance_wallet, size: 60,),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.redAccent,
                child: SizedBox.expand(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(title,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          	ElevatedButton(
                            child: const Text('D\'accord'),
                            onPressed: ()=> {
                              Navigator.of(context).pop()

                            },
                          ),
                        ],
                      ),
                    ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SimpleCustomAlert extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  // ignore: use_key_in_widget_constructors
  const SimpleCustomAlert(this.title);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4)
      ),
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white70,
                child: const Icon(Icons.account_balance_wallet, size: 60,),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.redAccent,
                child: SizedBox.expand(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(title,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          	ElevatedButton(
                            child: const Text('D\'accord'),
                            onPressed: ()=> {
                              Navigator.of(context).pop()

                            },
                          ),
                          ElevatedButton(
                            child: const Text('Skipe'),
                            onPressed: ()=> {
                              Navigator.of(context).pop()
                            },
                          )
                        ],
                      ),
                    ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AdvanceCustomAlert extends StatelessWidget {
  const AdvanceCustomAlert({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0)
      ),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  const Text('Warning !!!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  const SizedBox(height: 5,),
                  const Text('You can not access this file', style: TextStyle(fontSize: 20),),
                  const SizedBox(height: 20,),
                  RaisedButton(onPressed: () {
                    Navigator.of(context).pop();
                  },
                    color: Colors.redAccent,
                    child: const Text('Okay', style: TextStyle(color: Colors.white),),
                  )
                ],
              ),
            ),
          ),
          const Positioned(
            top: -60,
            child: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              radius: 60,
              child: const Icon(Icons.assistant_photo, color: Colors.white, size: 50,),
            )
          ),
        ],
      )
    );
  }
}

