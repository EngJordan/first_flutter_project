import 'package:english_words/english_words.dart';
import 'package:first_flutter_project/api.dart';
import 'package:first_flutter_project/new_music_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Music?> musics = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _updateMusics();
        },
        child: Center(
          child: ListView.builder(
            itemCount: musics.length,
            itemBuilder: (context, index) {
              return ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Deletar música'),
                            content: Text(
                                'Tem certeza que deseja deletar a música ${musics[index]!.title}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Api()
                                      .deleteMusic(musics[index]!.id!)
                                      .then((value) {
                                    _updateMusics();
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text('Deletar'),
                              ),
                            ],
                          );
                        });
                  },
                ),
                title: Text(musics[index]!.title!),
                subtitle: Text(musics[index]!.seconds.toString()),
                onTap: () {},
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Namer App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewMusicForm(),
            ),
          ).then((value) => _updateMusics());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateMusics();
  }

  void _updateMusics() {
    Api().getMusics().then((value) {
      setState(() {
        musics = value;
      });
    });
  }
}
