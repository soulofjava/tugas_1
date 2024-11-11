// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:tugas_1/main.dart';

void main() => runApp(const FileMgr());

class FileMgr extends StatefulWidget {
  const FileMgr({super.key});

  @override
  _FileMgrState createState() => _FileMgrState();
}

class _FileMgrState extends State<FileMgr> {
  final FileManagerController controller = FileManagerController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: ControlBackButton(
        controller: controller,
        child: Scaffold(
          appBar: appBar(context),
          body: FileManager(
            controller: controller,
            builder: (context, snapshot) {
              final List<FileSystemEntity> entities = snapshot;
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  FileSystemEntity entity = entities[index];
                  return Card(
                    child: ListTile(
                      leading: FileManager.isFile(entity)
                          ? Icon(Icons.feed_outlined)
                          : Icon(Icons.folder),
                      title: Text(FileManager.basename(
                        entity,
                        showFileExtension: true,
                      )),
                      subtitle: subtitle(entity),
                      onTap: () async {
                        if (FileManager.isDirectory(entity)) {
                          controller.openDirectory(entity);
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
          // Removed the floating action button
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => createFolder(context),
          icon: Icon(Icons.create_new_folder_outlined),
        ),
        IconButton(
          onPressed: () => sort(context),
          icon: Icon(Icons.sort_rounded),
        ),
        IconButton(
          onPressed: () => selectStorage(context),
          icon: Icon(Icons.sd_storage_rounded),
        ),
      ],
      title: ValueListenableBuilder<String>(
        valueListenable: controller.titleNotifier,
        builder: (context, title, _) => Text(title),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Navigate back to main.dart or the initial screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const KalkulatorPage()), // Replace with your main screen widget
          );
        },
      ),
    );
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;
            return Text("${FileManager.formatBytes(size)}");
          }
          return Text("${snapshot.data!.modified}".substring(0, 10));
        } else {
          return const Text("");
        }
      },
    );
  }

  Future<void> selectStorage(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FutureBuilder<List<Directory>>(
          future: FileManager.getStorageList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching storage'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No storage available'));
            } else {
              final List<FileSystemEntity> storageList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: storageList
                      .map((e) => ListTile(
                            title: Text("${FileManager.basename(e)}"),
                            onTap: () {
                              controller.openDirectory(e);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> sort(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Name"),
                onTap: () {
                  controller.sortBy(SortBy.name);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Size"),
                onTap: () {
                  controller.sortBy(SortBy.size);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Date"),
                onTap: () {
                  controller.sortBy(SortBy.date);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Type"),
                onTap: () {
                  controller.sortBy(SortBy.type);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createFolder(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController folderName = TextEditingController();
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: TextField(
                    controller: folderName,
                    decoration: const InputDecoration(labelText: 'Folder Name'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FileManager.createFolder(
                        controller.getCurrentPath,
                        folderName.text,
                      );
                      controller.setCurrentPath =
                          '${controller.getCurrentPath}/${folderName.text}';
                    } catch (e) {
                      // Handle error (e.g., show a dialog)
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Create Folder'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}