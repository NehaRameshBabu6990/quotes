import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
class love extends StatefulWidget {
  final String categoryname;
  love(this.categoryname);

  @override
  State<love> createState() => _loveState();
}

class _loveState extends State<love> {
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
    String url="https://quotes.toscrape.com/tag/${widget.categoryname}/";
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
        body:isDataThere==false?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 40),
                  child: Text(
                    "${widget.categoryname} quotes",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:quotes.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Container(
                          child: Card(
                            child: Column(
                                children:[
                                  Text(quotes[index],style: TextStyle(color:Colors.black),) ,
                                  Text(authors[index],style: TextStyle(color: Colors.black),),
                                ]
                            ),
                          ));
                    })]),
        ));
  }
}