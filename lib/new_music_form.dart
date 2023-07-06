import 'package:first_flutter_project/api.dart';
import 'package:flutter/material.dart';

class NewMusicForm extends StatefulWidget {
  const NewMusicForm({Key? key}) : super(key: key);

  @override
  _NewMusicFormState createState() => _NewMusicFormState();
}

class _NewMusicFormState extends State<NewMusicForm> {
  final _titleController = TextEditingController();
  final _secondsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Música'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                ),
              ),
              TextFormField(
                controller: _secondsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Duração',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isNotEmpty &&
                      _secondsController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Salvando...'),
                      ),
                    );
                    Api()
                        .postMusic(
                      Music(
                        title: _titleController.text,
                        seconds: int.parse(_secondsController.text),
                      ),
                    )
                        .then((value) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Salvo com sucesso!'),
                        ),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao salvar!'),
                        ),
                      );
                    });
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
