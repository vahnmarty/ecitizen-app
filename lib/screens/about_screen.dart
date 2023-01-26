import 'package:flutter/material.dart';

import '../themes.dart';
import '../widgets/title_card_with_shadow.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Hero(
          tag: 'logo',
          child: Image(
            image: AssetImage('assets/logo/logo.png'),
            height: 20,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.iconLightGrey,
            )),
      ),
      body: Column(
        children: const [
          TitleCardWithShadow(
            title: 'About',
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
                'Iligan City: “Industrial City of the South” and “City of Majestic Waterfalls”',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
                'Iligan City had its beginnings in the village of Bayug, four (4) kilometers north of the present Poblacion. It was the earliest pre-Spanish settlement of native sea dwellers. The monotony of indigenous life in the territory was broken when in the later part of the 16th century, the inhabitants were subdued by the Visayan migrants from the island kingdom of Panglao. In the accounts of Jesuit historian Francisco Combes, the Mollucan King of Ternate invaded Panglao. This caused Panglaons to flee in large numbers to Dapitan, Zamboanga del Norte. In Dapitan, the surviving Prince of Panglao Pagbuaya, received Legazpi’s expedition in 1565. Later, Pagbuaya’s son Manook was baptized Pedro Manuel Manook. The Christianized Manook subdued the Higaunon village in Bayug and established it as one of the earliest Christian settlements in the country. The settlement survived other raids from other enemies, and, because of their faith in God and in their patron saint, Saint Michael the Archangel, the early Iliganons moved their settlement from Bayug to Iligan. The name Iligan is from the Higaonon word iligan or ilijan’ meaning “fortress of defense” against frequent attacks by pirates and other hostile Mindanao tribes.',
                style: TextStyle(fontSize: 16)),
          )),
        ],
      ),
    );
  }
}
