import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:tripers/colors.dart' as colors;
import 'package:tripers/instance.dart';
import 'package:tripers/model/post/post_class_model.dart';
import 'package:tripers/view/UserProfilePages/NewBlogAndPost/user_post_add_screen.dart';

import '../../../widgets.dart';

class UserPosts extends StatefulWidget {
  const UserPosts({Key? key}) : super(key: key);

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  late Future<List<PostGet>> futurePost;

  @override
  void initState() {
    loadList();
    super.initState();
  }

  Future loadList() async {
    setState(() {
      futurePost = postApi.fetchPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadList,
          child: FutureBuilder<List<PostGet>>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data![index].author.toString() ==
                          postController.logInUserId) {
                        return postUser(snapshot, index);
                      } else {
                        return const Text('');
                      }
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget postUser(AsyncSnapshot<List<PostGet>> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 4, right: 4),
            width: 100.w,
            height: 35.h,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                  offset: Offset(
                    0.0,
                    1.0,
                  ), // shadow direction: bottom right
                )
              ],
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(snapshot.data![index].postImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  size: 25.sp,
                ),
              ),
              PopupMenuButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                        onTap: () => Get.back(),
                        child: TextButton(
                          onPressed: () async {
                            await deleteBox(
                                'Are you sure to delete.', snapshot, index);
                            Get.back();
                          },
                          child: Text(
                            'Delete',
                            style: GoogleFonts.openSans(
                              fontSize: 10.sp,
                            ),
                          ),
                        )),
                    PopupMenuItem(
                        child: TextButton(
                      onPressed: () {
                        postController.postTitleController.text =
                            snapshot.data![index].title;
                        postController.postDescriptionController.text =
                            snapshot.data![index].description;
                        postController.onePostImage =
                            snapshot.data![index].postImage;
                        postController.currentId = snapshot.data![index].id;
                        Get.to(AddPoster(
                          check: 1,
                        ));
                        setState(() {});
                      },
                      child: Text(
                        'Update',
                        style: GoogleFonts.openSans(
                          fontSize: 10.sp,
                        ),
                      ),
                    )),
                  ];
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            width: 100.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.data![index].title,
                  style: GoogleFonts.roboto(
                    color: colors.mainText,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  snapshot.data![index].description,
                  style: GoogleFonts.roboto(
                      color: colors.subText, fontSize: 10.sp),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 2.h, left: 2.h),
                    child: Text(
                      'Add a Comment..',
                      style: GoogleFonts.roboto(
                          color: colors.subText, fontSize: 9.sp),
                    ),
                    width: 100.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
