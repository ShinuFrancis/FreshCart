import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class AddProfile extends StatefulWidget {
  @override
  _AddProfile createState() => _AddProfile();
}


class _AddProfile extends State<AddProfile> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

          title: Text("ShopX"),

          //leading: Icon(Icons.menu),

          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: ()  {
              // Navigator.push(
              // context, new MaterialPageRoute(
              // builder: (context) =>  Search(),),
              // );
            }
            ),



            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            //title: Text(widget.title),
          ]
      ),


      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), title: Text('Category')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile')),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.person), title: Text('Profile')),
        ],

      ),

      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Abhishek Mishra"),
              accountEmail: Text("abhishekm977@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category), title: Text("Shop by Categories"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_shopping_cart), title: Text("Add to cart"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings), title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body:
      SingleChildScrollView(
        child: Column(

          children: <Widget>[

            Container(
              padding: EdgeInsets.all(10),
                constraints: BoxConstraints.expand(
                    height: 200
                ),
                child: imageSlider(context)
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: Text("View order"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: Text("Set Delivery date"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: Text("Add Product"),
                  ),
                ],
              ),


            ),

            Container(

              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: ListView.builder(

                scrollDirection: Axis.horizontal,
                //itemCount: products.length,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      // context,
                      // MaterialPageRoute(
                      // builder: (ctx) => DetailsScreen(id: i),
                      // ),
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.0),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            //Image.network("data:image/jpeg;base64,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",),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9.0),
                              child: Image.network("https://cdn11.bigcommerce.com/s-pkla4xn3/images/stencil/1280x1280/products/11753/114418/2018-Fashion-New-Male-Shirt-Long-Sleeve-Mens-Clothes-Oblique-Button-Dress-Shirts-Mandarin-Collar-Men__02469.1537167876.jpg?c=2",),
                            ),
                          ],
                        ),

                      ),
                    ),
                  );
                },
              ),
            ),
            Container(

              height: 150,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: ListView.builder(

                scrollDirection: Axis.horizontal,
                //itemCount: products.length,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      // context,
                      // MaterialPageRoute(
                      // builder: (ctx) => DetailsScreen(id: i),
                      // ),
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.0),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            //Image.network("data:image/jpeg;base64,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",),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9.0),
                              child: Image.network("https://img1.cfcdn.club/fe/26/fea52d13fd5582097397e42c688c8a26_350x350.jpg",),
                            ),
                          ],
                        ),

                      ),
                    ),
                  );
                },
              ),
            ),
            Container(

              height: 150,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: ListView.builder(

                scrollDirection: Axis.horizontal,
                //itemCount: products.length,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      // context,
                      // MaterialPageRoute(
                      // builder: (ctx) => DetailsScreen(id: i),
                      // ),
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9.0),
                      child: Container(



                      ),
                    ),
                  );
                },
              ),
            ),



          ],
        ),
      ),
    );



  }


}
Swiper imageSlider(context){

  return new Swiper(
    autoplay: true,
    itemBuilder: (BuildContext context, int index) {
      return new Image.network(
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQULSPRITweJUsEVCo4TVpDV6wwKYbHDPol_A&usqp=CAU', fit: BoxFit.fitHeight,
      );

    },
    itemCount: 10,
    viewportFraction: 0.8,
    scale: 0.9,
  );

}
