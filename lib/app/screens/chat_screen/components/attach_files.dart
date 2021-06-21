import 'package:camera_camera/camera_camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AttachFiles extends StatelessWidget {
  final Function(Map<String, dynamic>) addMessage;
  AttachFiles({Key? key, required this.addMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void sendImageMessage() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', "jpeg", "png", "mp4"],
      );
      if (result != null) {
        if (result.files.single.path!.contains(".jpg"))
          addMessage({"image": result.files.single.path, "extension": "jpg"});
        if (result.files.single.path!.contains(".jpeg"))
          addMessage({"image": result.files.single.path, "extension": "jpeg"});
        if (result.files.single.path!.contains(".png"))
          addMessage({"image": result.files.single.path, "extension": "png"});
        if (result.files.single.path!.contains(".mp4"))
          addMessage({"video": result.files.single.path, "extension": "mp4"});
      }
      Navigator.pop(context);
    }

    void sendDocumentFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf", "doc", "docx"],
      );
      if (result != null) {
        if (result.files.single.path!.contains(".pdf"))
          addMessage({"pdf": result.files.single.path, "extension": "pdf"});
        if (result.files.single.path!.contains(".doc"))
          addMessage({"doc": result.files.single.path, "extension": "doc"});
        if (result.files.single.path!.contains(".docx"))
          addMessage({"docx": result.files.single.path, "extension": "docx"});
      }
      Navigator.pop(context);
    }

    void sendAudioFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );
      if (result != null) {
        if (result.files.single.path!.contains(".mp3"))
          addMessage({"mp3": result.files.single.path, "extension": "mp3"});
      }
      Navigator.pop(context);
    }

    void sendCaptureImage(result) {
      if (result.path.contains(".jpg"))
        addMessage({"image": result.path, "extension": "jpg"});
      if (result.path.contains(".jpeg"))
        addMessage({"image": result.path, "extension": "jpeg"});
      if (result.path.contains(".mp4"))
        addMessage({"video": result.path, "extension": "mp4"});
      Navigator.pop(context);
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            // FilePickerResult? result = await FilePicker.platform.pickFiles(
            //   type: FileType.custom,
            //   allowedExtensions: ['jpg'],
            // );

            // addMessage({"image": result!.files.single.path});

            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    insetPadding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.7,
                      bottom: 56,
                      left: 30,
                      right: 30,
                    ),
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Selecione o tipo de arquivo",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                alignment: WrapAlignment.start,
                                key: Key(DateTime.now().toString()),
                                children: [
                                  IconButton(
                                    color: Colors.white,
                                    key: Key(DateTime.now().toString()),
                                    onPressed: sendImageMessage,
                                    icon: Icon(
                                      Icons.image_rounded,
                                    ),
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    key: Key(DateTime.now().toString()),
                                    onPressed: sendDocumentFile,
                                    icon: Icon(Icons.file_present_rounded),
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    key: Key(DateTime.now().toString()),
                                    onPressed: sendAudioFile,
                                    icon: Icon(
                                      Icons.audiotrack_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          child: Container(
            color: Colors.transparent,
            child: Icon(
              Icons.attach_file,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CameraCamera(
                  onFile: sendCaptureImage,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.transparent,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
