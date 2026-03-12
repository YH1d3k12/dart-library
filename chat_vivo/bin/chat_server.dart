import 'dart:io';

void main() async {
  final server = await ServerSocket.bind('127.0.0.1', 4040);
  print("Servidor rodando em ${server.address.address}:${server.port}");

  List<Socket> clients = [];

  server.listen((client) {
    print("Cliente conectado: ${client.remoteAddress.address}");
    clients.add(client);

    client.listen((data) {
      String message = String.fromCharCodes(data).trim();

      print("Mensagem recebida: $message");

      for (var c in clients) {
        c.write("$message\n");
      }
    });

    client.done.then((_) {
      clients.remove(client);
      print("Cliente desconectado.");
    });
  });
}