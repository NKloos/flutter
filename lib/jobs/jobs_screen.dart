import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpd_ss23/Search/search_job.dart';
import 'package:cpd_ss23/Widgets/bottom_nav_bar.dart';
import 'package:cpd_ss23/Widgets/job_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Persistent/persistent.dart';
import '../services/global_variables.dart';
import '../user_state.dart';

class JobScreen extends StatefulWidget {
  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? jobCategoryFilter;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text(
            "Job Category",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.jobCategoryList.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      jobCategoryFilter = Persistent.jobCategoryList[index];
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    print(
                        "jobCategoryList[index], ${Persistent.jobCategoryList[index]}");
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_right_alt_outlined,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Persistent.jobCategoryList[index],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  jobCategoryFilter = null;
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text("Cancel Filter",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
      body: Stack(
        children: [
          Image.network(
            signupUrlImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: size.height - 18, // Adjust for bottom overflow
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.search_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (c) => SearchScreen()),
                          );
                        },
                      ),
                    ],
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.filter_list_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _showTaskCategoriesDialog(size: size);
                      },
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("jobs")
                          .where("jobCategory", isEqualTo: jobCategoryFilter)
                          .where("recruitment", isEqualTo: true)
                          .orderBy("createdAt", descending: false)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.data?.docs.isNotEmpty == true) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return JobWidget(
                                  jobTitle: snapshot.data?.docs[index]
                                      ["jobTitle"],
                                  jobDescription: snapshot.data!.docs[index]
                                      ["jobDescription"],
                                  jobId: snapshot.data?.docs[index]["jobId"],
                                  uploadedBy: snapshot.data?.docs[index]
                                      ["uploadedBy"],
                                  userImage: snapshot.data?.docs[index]
                                      ["userImage"],
                                  name: snapshot.data?.docs[index]["name"],
                                  recruitment: snapshot.data?.docs[index]
                                      ["recruitment"],
                                  email: snapshot.data?.docs[index]["email"],
                                  location: snapshot.data?.docs[index]
                                      ["location"],
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text("There are no jobs"),
                            );
                          }
                        }
                        return const Center(
                          child: Text(
                            "Something went wrong",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
