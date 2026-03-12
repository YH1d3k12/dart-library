import 'dart:io';

void main() async {
  stdout.write("Digite seu nome: ");
  String name = stdin.readLineSync()!;

  final socket = await Socket.connect('127.0.0.1', 4040);

  print("Conectado ao chat!");

  // Escutar mensagens (STREAM)
  socket.listen((data) {
    print(String.fromCharCodes(data).trim());
  });

  // Enviar mensagens
  while (true) {
    String? message = stdin.readLineSync();

    if (message != null) {
      socket.write("$name: $message");
    }
  }
}