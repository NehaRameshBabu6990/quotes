import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quotesapp/love.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
class quote extends StatefulWidget {
  const quote({Key? key}) : super(key: key);

  @override
  State<quote> createState() => _quoteState();
}

class _quoteState extends State<quote> {
  List<String> Categories =["love","inspiration","life","humor"];
  List quotes=[];
  List authors=[];
  bool isDataThere=false;
  @override
  void initState(){
    super.initState();
    setState(() {
      getquotes();
    });
  }
  getquotes() async{
    String url="https://quotes.toscrape.com/";
    Uri uri=Uri.parse(url);
    http.Response response= await http.get(uri);
    dom.Document document= parser.parse(response.body);
    final quotesclass= document.getElementsByClassName("quote");
    quotes=
        quotesclass.map((element)=>element.getElementsByClassName('text')[0].innerHtml).toList();
    authors=
        quotesclass.map((element)=>element.getElementsByClassName('author')[0].innerHtml).toList();
    setState(() {
      isDataThere=true;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
              children: [
                Container(
                  child:  Text(
                    'Quotes App',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ),
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount:2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  shrinkWrap: true,
                  children: Categories.map((Category){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>love(Category)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(child: Text(Category.toUpperCase(),style: TextStyle(color: Colors.white),)),

                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 40,),
                isDataThere==false?Center(child: CircularProgressIndicator(),):
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:quotes.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Container(
                          child: Card(
                            child: Column(
                                children:[
                                  Text(quotes[index]) ,
                                  Text(authors[index]),
                                ]
                            ),
                          ));
                    })]),
        ));
  }
}