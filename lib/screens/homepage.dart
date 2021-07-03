import 'package:flutter/material.dart';
import '/screens/taskpage.dart';
import '../widgets/taskcard.dart';
import '../database/database_helper.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          width: double.infinity,
          color: Color(0xFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 32, bottom: 32),
                    child: Image(
                      image: AssetImage("assets/images/logo.png"),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _dbHelper.getTasks(),
                      builder: (context, AsyncSnapshot snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Taskpage(
                                            task: snapshot.data[index],
                                          ),
                                        ),
                                      ).then((value) {
                                        {
                                          setState(() {});
                                        }
                                      });
                                    },
                                    child: TaskCard(
                                      title: snapshot.data[index].title,
                                      description:
                                          snapshot.data[index].description == ""
                                              ? "No description Added"
                                              : snapshot
                                                  .data[index].description,
                                    ),
                                  );
                                })
                            : Center(
                                child: Text("No data found!"),
                              );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Taskpage(
                                task: null,
                              ))).then(
                    (value) => setState(() {}),
                  ),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image(
                      image: AssetImage("assets/images/add_icon.png"),
                    ),
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
