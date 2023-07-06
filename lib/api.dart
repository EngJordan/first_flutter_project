import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  String url = 'http://192.168.0.104:8001';

  // chamar endpoint delete music
  Future<void> deleteMusic(int id) async {
    var response = await http.delete(Uri.parse('$url/musics/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar a música');
    }
  }

  //chamar o endpoint /musics
  Future<List<Music>> getMusics() async {
    var response = await http.get(Uri.parse('$url/musics'));
    if (response.statusCode == 200) {
      var musics = json.decode(response.body) as List;
      return musics.map((music) => Music.fromJson(music)).toList();
    } else {
      throw Exception('Erro ao carregar as músicas');
    }
  }

  // chamar endpoint post music
  Future<Music> postMusic(Music music) async {
    var response = await http.post(
      Uri.parse('$url/musics/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(music.toJson()),
    );
    if (response.statusCode == 201) {
      return Music.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao salvar a música');
    }
  }
}

class Music {
  int? id;
  String? title;
  int? seconds;

  Music({this.id, this.title, this.seconds});

  Music.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    seconds = json['seconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['seconds'] = seconds;
    return data;
  }
}
