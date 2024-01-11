// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/auth/Dashboard/dashbord_cubit.dart';
import 'package:cheersclub/cubit/repository/ViewgreetingsRepo.dart';
import 'package:cheersclub/cubit/repository/dashbordRepository.dart';
import 'package:cheersclub/cubit/viewgreetings/view_greetings_cubit.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/models/Restourent/MyGreetings.dart';
import 'package:cheersclub/models/Restourent/Singlegreeting.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer_image/shimmer_image.dart';
import 'package:http/http.dart'as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Updategreeting extends StatefulWidget {
  final int? id;
  const Updategreeting({Key? key,this.id}) : super(key: key);

  @override
  _UpdategreetingState createState() => _UpdategreetingState();
}

class _UpdategreetingState extends State<Updategreeting> {

  GlobalKey<ScaffoldState> _key = GlobalKey();

  bool _isloading=false;
  late MygreetingsCubit mygreetingCubit;
  String? message;
  dynamic filename;
  dynamic greetingpreview;
  String? editmessage;
  String? restId;


  File? file;
  String? filenamecheck;

  int sizeInBytes=20;
  double sizeInMb=5;

  VideoPlayerController? _videoPlayerController;
  bool startedPlaying = false;





  Future selectFile() async {
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'mp4', 'jpeg','mov'],
      );
      final fileName = file != null ? (file!.path) : AppLocalizations.of(context).translate("nofile");

      if (result == null) return;
      final path = result.files.single.path;

      setState(() => file = File(path!));
      filenamecheck = fileName;
      print("******FILE*****"+file!.path);



      sizeInBytes = file!.lengthSync();
      sizeInMb = sizeInBytes / (1024 * 1024);

    }  on PlatformException catch (e) {
      print('failed : $e');
      setState(() {
        _isloading=true;
      });
    }
  }


  Future<void>updateGreetings()async{
    var token = await UserManager.instance.getToken();
    //var headers = {'Authorization': 'Bearer 549|Y7X9RAYR5hri0eQfdsThfjhEYXBgiBJJ5jbqxUzP'};

    ///development
    //var request = http.MultipartRequest('POST', Uri.parse('https://dev.cheerzclub.com/public/api/v1/user/my-greeting-update'));

    ///live
    var request = http.MultipartRequest('POST', Uri.parse('https://www.cheerzclub.com/api/v1/user/my-greeting-update'));

    request.fields.addAll({
      "id":widget.id.toString(),
      "message": editmessage==null?message.toString():editmessage.toString(),
    });
    file?.path == null? null :request.files.add(await http.MultipartFile.fromPath('message_attachment', file!.path));
    request.headers.addAll({'Authorization': 'Bearer $token'});
    print(request.toString()+"***************");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      final res = await http.Response.fromStream(response);
      String responsee = res.body.toString();
      var source = jsonDecode(res.body);

      print("edit prof res......888888.....*...$responsee");
      print("edit prof res......888888.....*...$source");


      Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate("My greeting updated successfully!"),
          backgroundColor: Colors.green,
          textColor: Colors.white);

      setState(() {
        _isloading=false;
      });

      Navigator.pop(context);

    }
    else {

      print(" Update greeting Exeception:" + response.reasonPhrase.toString());

      Fluttertoast.showToast(
          msg: response.reasonPhrase.toString(),
          backgroundColor: Colors.amber,
          textColor: Colors.black);

      setState(() {
        _isloading=false;
      });
    }
  }

  @override
  void initState() {
    mygreetingCubit = MygreetingsCubit(GetOneGreeting());
    // TODO: implement initStat
    restId = widget.id!.toString();
    mygreetingCubit.GetoneGreetingGet(widget.id!);
    //personal_message_Controller = TextEditingController(text: message);
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    //print(restId);
   //personal_message_Controller = TextEditingController(text: message);
    return Scaffold(
      key: _key,
      backgroundColor: HexColor("1A1B1D"),
      endDrawer: drowerAfterlogin(),
      resizeToAvoidBottomInset: true,

      body:  SingleChildScrollView(
        child: BlocProvider(
            create: (context) => mygreetingCubit,
            child: BlocListener<MygreetingsCubit, MygreetingsState>(
              bloc: mygreetingCubit,
              listener: (context, state) {
                if (state is MygreetingsInitial) {}
                if (state is MygreetingsLoading) {

                } else if (state is MygreetingsSuccess) {

                  message=state.gmessage;
                  filename=state.filename;
                  greetingpreview=state.greetingpreview;


                  print("*****MY GREETINGS****"+message.toString());


                } else if (state is MygreetingsFail) {
                  //   Utils.showDialouge(context, AlertType.error, "Oops!", state.msg);
                } else if (state is UpdategreetingsLoading) {
                  //   Utils.showDialouge(context, AlertType.error, "Oops!", state.msg);
                } else if (state is UpdategreetingsSuccess) {

                  message=state.gmessage;
                  filename=state.filename;
                  greetingpreview=state.greetingpreview;


                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context).translate("My greeting updated successfully!"),
                      backgroundColor: Colors.green,
                      textColor: Colors.white);

                  setState(() {
                    _isloading=false;
                  });

                } else if (state is UpdategreetingsFail) {

                  Utils.showDialouge(
                      context, AlertType.error, "Oops!", state.error);

                  setState(() {
                    _isloading=false;
                  });

                }
              },
              child: BlocBuilder<MygreetingsCubit, MygreetingsState>(
                  builder: (context, state) {
                    // print("gjgfjhfjf" + cart_count.toString());
                    if (state is MygreetingsInitial) {
                      return Column(
                        children: [
                          SizedBox(height: 390,),
                          Center(child: CupertinoActivityIndicator(radius: 10,),),
                        ],
                      );
                    }
                    if (state is MygreetingsLoading) {
                      return Column(
                        children: [
                          SizedBox(height: 390,),
                          Center(child: CupertinoActivityIndicator(radius: 10,),),
                        ],
                      );
                    } else if (state is MygreetingsSuccess) {
                      return  updateform();
                    } else if (state is  MygreetingsFail) {
                      return  updateform();
                    } else if (state is UpdategreetingsLoading) {
                      return  updateform();
                    } else if (state is UpdategreetingsSuccess) {
                      return  updateform();
                    } else if (state is UpdategreetingsFail) {
                      return  updateform();
                    } else {
                      return  updateform();
                    }
                  }),
            )),
      ),

    );
  }

  Widget updateform(){
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 1.2,
      color: HexColor("1A1B1D"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: 100,
            child: Container(
              color: HexColor("131313"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 13, top: 25),
                    padding: EdgeInsets.all(5),
                    child: Image.asset(
                      "assets/images/cheerzlogonew.png",
                      fit: BoxFit.fitHeight,
                      height: 55,
                      //width: 220,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _key.currentState!.openEndDrawer();
                          //Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20, top: 40),
                          child: Image.asset(
                            "assets/images/nav.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),


          Container(
            margin: EdgeInsets.only(left: 20, top: 25,bottom: 10),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.only(left: 6),
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white, width: 2)),
                margin: EdgeInsets.only(right: 0, top: 0),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CheersClubText(
                  text: AppLocalizations.of(context).translate("basicinfo"),
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ],
            ),
          ),

          // greetingpreview==null? Container() :  Container(
          //   padding: EdgeInsets.only(left: 30, right: 30,top: 40,),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       CheersClubText(
          //         text: greetingpreview.toString(),
          //         fontColor: Colors.white,
          //         fontSize: 8,
          //         over: TextOverflow.clip,
          //       ),
          //       SizedBox(height: 5,),
          //     ],
          //   ),
          // ),


        greetingpreview==null? Container() :

        greetingpreview.contains(".jpg") || greetingpreview.contains(".jpeg") || greetingpreview.contains(".png")
            || greetingpreview.contains(".tif") || greetingpreview.contains(".tiff") || greetingpreview.contains(".gif") ||

            greetingpreview.contains(".bmp") || greetingpreview.contains(".eps") || greetingpreview.contains(".raw") || greetingpreview.contains(".cr2") || greetingpreview.contains(".nef") || greetingpreview.contains(".orf") || greetingpreview.contains(".sr2")

        ?

        Container(
          margin: EdgeInsets.only(left: 20,top: 60),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200,width:2)),
          height: 120,
          width: 120,
          child:
          ProgressiveImage(
            baseColor: Colors.grey.shade500,
            highlightColor: Colors.grey.shade600,
            height: 120,
            width: 120,
            fit: BoxFit.fill,
            image: greetingpreview.toString(),
            imageError: "assets/images/nia.jpg",

          ),
          // child: Image.network(order!.qr.toString(),fit: BoxFit.contain,)
        ):

        Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: ChewieListItem(
            videoPlayerController: VideoPlayerController.network(greetingpreview),
            looping: false,
          ),
        ),








          //Personal message


          Container(
            margin: EdgeInsets.only(left: 20, right: 220, top: 30),
            child: CheersClubText(
              text:  AppLocalizations.of(context).translate("pmsg"),
              fontColor: Colors.white,
              fontSize: 11.1,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: TextFormField(
              initialValue: message?.toString()??"",
              style: const TextStyle(color: Colors.white),
             // controller:  personal_message_Controller ,
              onChanged: (val){
                editmessage=val;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '',
                hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                filled: true,
                fillColor: HexColor("28292C"),
                contentPadding: const EdgeInsets.only(
                    left: 14.0, bottom: 6.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor("28292C")),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("28292C")),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
          ),

          //Attachment
          Container(
            margin: EdgeInsets.only(left: 20, right: 220, top: 20),
            child: CheersClubText(
              text: AppLocalizations.of(context).translate("attachment"),
              fontColor: Colors.white,
              fontSize: 11.1,
            ),
          ),
          Container(
            height: 47,
            color: HexColor("28292C"),
            margin: EdgeInsets.only(left: 20, right: 20, top: 4),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    selectFile();
                  },
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 4),
                    height: 23,
                    child: Center(
                      child: CheersClubText(
                        alignment: TextAlign.center,
                        text:  AppLocalizations.of(context).translate("cfile"),
                        fontColor: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 1),
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: CheersClubText(
                      text: file?.path==null ? AppLocalizations.of(context).translate("nofilec") : file!.path.toString(),
                      fontColor: Colors.grey.shade600,
                      fontSize: 10,
                      over: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20,top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CheersClubText(
                  text: "File size limit : 100 MB",
                  fontColor: Colors.grey,
                  fontSize: 11,
                ),
              ],
            ),
          ),




          //Save Button
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 220, top: 30, bottom: 30),
            child:  ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0)),
                  primary: HexColor("FEC753"), // background
                  onPrimary: Colors.black, // foreground
                ),
                child: Container(
                  width: 130,
                  child:  Center(
                    child: _isloading ?  Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                      height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,)),) : CheersClubText(
                      text:   AppLocalizations.of(context).translate("save"),
                      fontColor: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                onPressed: () async {

                  if (sizeInMb > 100){

                  Fluttertoast.showToast(
                  msg: "Selected file too large,please select upto 100 MB",
                  backgroundColor: Colors.amber,
                  textColor: Colors.black);

                  }
                  else{

                    setState(() {
                      _isloading = true;
                    });

                    // updategreetings();
                    updateGreetings();
                  }




                }
            ),
          ),


          SizedBox(height: 140,),

          //Reach us
          // Container(
          //   // color: HexColor("5D5D5E"),
          //   height: 40,
          //   padding: EdgeInsets.only(left: 20, right: 20),
          //   margin: EdgeInsets.only(top: 0, bottom: 0),
          //   decoration: BoxDecoration(
          //       border: Border(
          //           bottom: BorderSide(
          //             color: Colors.white,
          //             width: 0.5,
          //           ))),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       CheersClubText(
          //         text:   AppLocalizations.of(context).translate("reachus"),
          //         fontColor: Colors.amber,
          //         fontWeight: FontWeight.w600,
          //         fontSize: 18,
          //       ),
          //       Expanded(child: SizedBox()),
          //     ],
          //   ),
          // ),

          // Container(
          //   // color: HexColor("5D5D5E"),
          //   height: MediaQuery.of(context).size.height * 0.3,
          //   padding: EdgeInsets.only(left: 20, right: 20),
          //   margin: EdgeInsets.only(top: 0, bottom: 0),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       SizedBox(height: 15,),
          //       Row(
          //         children: [
          //           CheersClubText(
          //             text: "Gooimeer 1",
          //             fontColor: Colors.white,
          //             fontWeight: FontWeight.w600,
          //             fontSize: 15,
          //           ),
          //         ],
          //       ),
          //       Row(
          //         children: [
          //           CheersClubText(
          //             text: "1411 DC Naarden",
          //             fontColor: Colors.white,
          //             fontWeight: FontWeight.w600,
          //             fontSize: 15,
          //           ),
          //         ],
          //       ),
          //
          //       Row(
          //         children: [
          //           CheersClubText(
          //             text: "Netherlands",
          //             fontColor: Colors.white,
          //             fontWeight: FontWeight.w600,
          //             fontSize: 15,
          //           ),
          //         ],
          //       ),
          //
          //       SizedBox(height: 15,),
          //
          //       Row(
          //         children: [
          //           CheersClubText(
          //             text: "P:020 4745457 | E:s.kasri@planet.com",
          //             fontColor: Colors.white,
          //             fontWeight: FontWeight.w600,
          //             fontSize: 15,
          //           ),
          //         ],
          //       ),
          //
          //       Row(
          //         children: [
          //           CheersClubText(
          //             text: "WWW.cheerzclub.com",
          //             fontColor: Colors.amber,
          //             fontWeight: FontWeight.w600,
          //             fontSize: 15,
          //           ),
          //         ],
          //       ),
          //
          //       SizedBox(height: 20,),
          //
          //       Row(
          //         children: [
          //
          //           FaIcon(FontAwesomeIcons.facebookF,size: 25,color: Colors.amber,),
          //
          //           SizedBox(width: 15,),
          //
          //           FaIcon(FontAwesomeIcons.instagram,size: 25,color: Colors.amber,),
          //
          //           SizedBox(width: 15,),
          //
          //           FaIcon(FontAwesomeIcons.twitter,size: 25,color: Colors.amber,),
          //
          //           SizedBox(width: 15,),
          //
          //           FaIcon(FontAwesomeIcons.linkedin,size: 25,color: Colors.amber,),
          //
          //         ],
          //       ),
          //
          //
          //     ],
          //   ),
          // ),



        ],
      ),
    );
  }

 // void updategreetings(){
 //   mygreetingCubit.updateGreeting(
 //     restId!,editmessage==null?message.toString():editmessage.toString(),file!.path.toString(),);
 // }

}


class ChewieListItem extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
  final VideoPlayerController? videoPlayerController;
  final bool? looping;

  ChewieListItem({
    this.videoPlayerController,
    this.looping,
  });

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    // Wrapper on top of the videoPlayerController
    _chewieController = ChewieController(
      showControls: true,
      showOptions: true,
      fullScreenByDefault: false,
      allowPlaybackSpeedChanging: true,
      showControlsOnInitialize: true,
      autoPlay: false,
      placeholder: Center(child: CircularProgressIndicator(strokeWidth: 1,color: Colors.amber,)),
      videoPlayerController: widget.videoPlayerController!,
      // aspectRatio: 16/9,
      allowFullScreen: false,
      isLive: false,
      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      looping: false,
      // Errors can occur for example when trying to play a video
      // from a non-existent URL
      errorBuilder: (context, errorMessage) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Text(
              "Video is not available right now.",
              style: TextStyle(color: Colors.white,fontSize: 10),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController!,
    );
  }

  @override
  void dispose() {
    super.dispose();
    // IMPORTANT to dispose of all the used resources
    widget.videoPlayerController!.dispose();
    _chewieController!.dispose();
  }
}
