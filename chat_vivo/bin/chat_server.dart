import 'dart:io';
import 'dart:convert';

void main() async {
  final server = await ServerSocket.bind('127.0.0.1', 4040);
  print("Servidor rodando em 127.0.0.1:4040");

  List<Socket> clients = [];

  server.listen((client) {
    print("Novo cliente conectado");
    clients.add(client);

    client
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((message) {

      print(message);

      for (var c in clients) {
        c.writeln(message);
      }

    }, onDone: () {
      clients.remove(client);
      print("Cliente desconectado");
    });
  });
}