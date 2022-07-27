import 'package:flutter/material.dart';
import 'package:syslab_admin/utilities/app_bars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/font_style.dart';

class ShowAnalyseScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final analysesDetails;

  const ShowAnalyseScreen({Key key, this.analysesDetails}) : super(key: key);
  @override
  _ShowAnalyseScreenState createState() => _ShowAnalyseScreenState();
}

class _ShowAnalyseScreenState extends State<ShowAnalyseScreen> {
  @override
  void initState() {
     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, widget.analysesDetails.name),
      body: _buildContent()
    );
  }

  Widget _buildContent() {
    return Stack(
      //overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 0.0,
                  left: 20,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Text("Titre:", style: kAppBarTitleStyle),
                      // const SizedBox(height: 10),
                      Text(
                        widget.analysesDetails.titre,
                        style: kCardSubTitleStyle,
                      ),
                      const SizedBox(height: 30),
                      const Text("Nom d'analyse: ", style: kAppBarTitleStyle),
                      // const SizedBox(height: 10),
                      Text(
                        widget.analysesDetails.name,
                        style: kCardSubTitleStyle,
                      ),
                      const SizedBox(height: 30),
                      const Text("Description:", style: kAppBarTitleStyle),
                      // const SizedBox(height: 10),
                      Text(
                        widget.analysesDetails.description,
                        style: kCardSubTitleStyle,
                      ),
                      const SizedBox(height: 30),
                      const Text("Prix:", style: kAppBarTitleStyle),
                      // const SizedBox(height: 10),
                      Text(
                        widget.analysesDetails.price,
                        style: kCardSubTitleStyle,
                      ),
                      const SizedBox(height: 30),
                      const Text("Bilan:", style: kAppBarTitleStyle),
                      // const SizedBox(height: 10),
                      Text(
                        widget.analysesDetails.libBilan,
                        style: kCardSubTitleStyle,
                      ),
                      const SizedBox(height: 30),
                      const Text("Valeur Reference:", style: kAppBarTitleStyle),
                      // const SizedBox(height: 10),
                      Text(
                        widget.analysesDetails.valeurReference,
                        style: kCardSubTitleStyle,
                      ),
                      const SizedBox(height: 30),
                      const Text("Unite:", style: kAppBarTitleStyle),
                      // const SizedBox(height: 10),
                      Text(
                        widget.analysesDetails.unite,
                        style: kCardSubTitleStyle,
                      ),
                      const SizedBox(height: 30),
                      const Text("Examen bilogique:", style: kAppBarTitleStyle),
                      // const SizedBox(height: 10),
                      Text(
                        widget.analysesDetails.categoryName,
                        style: kCardSubTitleStyle,
                      ),
                    ],
                  ),
                )
              ),
          ),
        )
      ],
    );
  }
}
