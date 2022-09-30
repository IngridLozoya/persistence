import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:persistence/Screens/taken_picture_screen.dart';
import 'package:persistence/helpers/database_helper.dart';
import '../models/cat_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? catId;
  final textControllerRace = TextEditingController();
  final textControllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite example with cats'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            TextFormField(controller: textControllerRace, decoration: const InputDecoration(
              icon: Icon(Icons.catching_pokemon),
              labelText: 'Input the race of the cat'
            )
            ),
            TextFormField(controller: textControllerName, decoration: const InputDecoration(
              icon: Icon(Icons.castle),
              labelText: 'Input the name of the cat'
            )
            ),
            ElevatedButton(
              onPressed: () async {
                final cameras = await availableCameras();
                final firstCamera = cameras.first;
                if(!mounted) return;
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context)=> TakenPictureScreen(
                      camera: firstCamera,
                      )
                  )
                );
              }, 
              child: const Text('Take a picture')),
            Center(
              child: (
                FutureBuilder<List<Cat>>(
                  future: DatabaseHelper.instance.getCats(),
                  builder: (BuildContext context, AsyncSnapshot<List<Cat>> snapshot){
                    if(!snapshot.hasData) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: const Text('Loading....'),
                        ),
                      );
                    }
                    else{
                      return snapshot.data!.isEmpty
                      ?Center(
                        child: Container(child: const Text('No cats in the list'))) 
                        : ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data!.map((cat){
                            return Center(
                              child: Card(
                                color: catId == cat.id ? const Color.fromARGB(255, 5, 106, 156) : const Color.fromARGB(255, 172, 200, 248),
                                child: ListTile(
                                  textColor: catId == cat.id ? Colors.white : Colors.black,
                                  title: Text('Name: ${cat.name} | Race: ${cat.race}'),
                                  onLongPress: (){
                                    setState(() {
                                      DatabaseHelper.instance.delete(cat.id!);
                                    });
                                  },
                                  onTap: (){
                                    setState(() {
                                      if(catId == null){
                                        textControllerName.text = cat.name;
                                        textControllerRace.text = cat.race;
                                        catId = cat.id;
                                      }
                                      else{
                                        textControllerName.clear();
                                        textControllerRace.clear();
                                        catId = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList()
                        );
                    }
                  },
                )
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {

          if(catId != null){
            await DatabaseHelper.instance.update(
              Cat(
                race: textControllerRace.text,
                name: textControllerName.text,
                id: catId
                )
            );
          }
          else{
            DatabaseHelper.instance.add(
              Cat(
                race: textControllerRace.text,
                name: textControllerName.text
                )
          );
          }
          setState(() {
            textControllerRace.clear();
            textControllerName.clear();
          });
        },
      ),
    );
  }
}