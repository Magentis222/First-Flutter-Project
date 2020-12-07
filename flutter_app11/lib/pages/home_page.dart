import 'package:flutter/material.dart';
import 'package:flutter_app11/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'category.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app11/helpers/newss.dart';
import 'package:flutter_app11/models/article_models.dart';
import 'package:flutter_app11/models/category_model.dart';
import 'package:flutter_app11/helpers/data.dart';
import 'package:flutter_app11/pages/article.dart';
import 'package:webview_flutter/webview_flutter.dart';



class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<CategoryModel> categories=new List<CategoryModel>();
  List<Article> article=new List<Article>();
  bool _loading = true;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;
  @override
  void initState(){
    super.initState();
    categories=getCategories();
    getNews();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

  }
  getNews() async{
    Newss newsClass=Newss();
    await newsClass.getNews();
    article=newsClass.news;
    setState(() {
      _loading=false;
    });
  }


  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('News'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
      body: _loading ? Center(
        child:   Container(child: CircularProgressIndicator(),
        ),
      ):SingleChildScrollView(

        child: Column(
          children: <Widget>[
            Container(
                height: 70,
                child:ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection:  Axis.horizontal,
                    itemBuilder:(context,index){
                      return CategoryCard(
                        imageUrl: categories[index].imageUrl,
                        categoryName: categories[index].categoryName,
                      );
                    }
                )
            ),
            ////blog


            Container(
              padding: EdgeInsets.only(top:16),
              child:ListView.builder(
                  itemCount: article.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return BlogTitle(
                        imageUrl: article[index].urlToImage,
                        title: article[index].title,
                        desc: article[index].description,
                        url:article[index].articleUrl);


                  }

              ),

            )
          ],
        ) ,
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final imageUrl,categoryName;
  CategoryCard({this.imageUrl,this.categoryName});
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CategoryNews(
              newsCategory: categoryName.toLowerCase(),
            )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(imageUrl:imageUrl,width: 120,height: 60,fit:BoxFit.cover)
            ),
            Container(
              alignment: Alignment.center,
              width: 120,height: 60,
              color: Colors.black26,
              child: Text(categoryName,style: TextStyle(color: Colors.white),),
            )

          ],
        ),
      ),
    );
  }
}
class BlogTitle extends StatelessWidget {

  final String imageUrl,title,desc,url;
  BlogTitle({@required this.imageUrl,@required this.desc,@required this.title,@required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ArticleView(postUrl: url)
        ));

      },
      child: Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
                child: Image.network(imageUrl)),
            Text(title,style: TextStyle(
                fontSize: 17,
                color:Colors.black87
            ),),
            Text(desc,style: TextStyle(color: Colors.grey),)
          ],
        ),

      ),
    );
  }
}