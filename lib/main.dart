import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mhofficials/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_page.dart';
import 'about_page.dart';
import 'contact_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Hunter Official Website',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> slideImages = [
    'assets/slide1.png',
    'assets/slide2.png',
    'assets/slide3.png',
    'assets/slide4.png',
    'assets/slide5.png',
  ];

  final List<String> gameImages = [
    'assets/mhn.png',
    'assets/mhgu.png',
    'assets/mhw.png',
    'assets/mhwi.png',
    'assets/rise.png',
    'assets/rise2.png',
    'assets/stories.png',
    // ... tambahkan path gambar game yang lain sesuai kebutuhan
  ];

  final List<String> newsImages = [
    'assets/news1.png',
    'assets/news2.png',
    'assets/news3.png',
    'assets/news4.png',
    'assets/news5.png',
    // ... tambahkan path gambar berita yang lain sesuai kebutuhan
  ];

  final List<String> newsContents = [
    'New design coming to official Capcom apparel on Amazon!',
    'Vote for your favorite monster in the Hunters choice (Top Monster)!',
    'Monster Hunter Rise: Sunbreak All Title Update Out Now!',
    'MONSTER HUNTER RISE (Xbox Series X|S/Xbox One/Windows/PS5/PS4) ',
    'Monster Hunter Rise: Sunbreak Roadmap Free Title Updates',
  ];

  final List<String> newsHeadlines = [
    'Latest News Headline 1',
    'Latest News Headline 2',
    'Latest News Headline 3',
    'Latest News Headline 4',
    'Latest News Headline 5',
  ];

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < slideImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Hunter Official Website'),
        backgroundColor: Color(0xFF4E2208),
        leading: Image.asset(
          'assets/mhlogofix.png',
          width: 40,
          height: 40,
        ),
        actions: [
          Tooltip(
            message: 'About',
            child: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ),
          Tooltip(
            message: 'Account',
            child: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () async {
                int? userId = await getUserId();

                if (userId != null) {
                  // User_id is present, navigate to LoginPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  // User_id is not present, navigate to AdminPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminPage()),
                  );
                }
              },
            ),
          ),
          Tooltip(
            message: 'Contact',
            child: IconButton(
              icon: Icon(Icons.phone),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 185.0,
              color: Colors.purple[100],
              child: PageView.builder(
                controller: _pageController,
                itemCount: slideImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 0.0),
                    child: Image.asset(
                      slideImages[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            ),
            Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  '**OUR GAMES**',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: gameImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print('Game ${index + 1} clicked!');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 16.0,
                      height: MediaQuery.of(context).size.width / 3 - 16.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            gameImages[index],
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 8.0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  '**NEWS**',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                children: List.generate(5, (index) {
                  String newsImage = newsImages[index % newsImages.length];
                  return GestureDetector(
                    onTap: () {
                      print('News ${index + 1} clicked!');
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              newsImage,
                              width: 200.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            newsHeadlines[index],
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            newsContents[index],
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            Container(
              color: Colors.black,
              child: Center(
                child: Text(
                  '', // Kosongkan teks
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF4E2208),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  print('Copyright clicked!');
                },
                child: Text(
                  'Copyright',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('Terms clicked!');
                },
                child: Text(
                  'Terms',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('Privacy Policy clicked!');
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('Cookie Policy clicked!');
                },
                child: Text(
                  'Cookie Policy',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
