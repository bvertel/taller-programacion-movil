import 'dart:convert';
import 'package:http/http.dart' as http;


// definimos los modelo de datos User
class User {
  final int id;
  final String name;
  final String username;
  final String email;

  User({required this.id, required this.name, required this.username, required this.email});


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }
}

// Función para realizar la petición HTTP y obtener los usuarios
Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  if (response.statusCode == 200) {
    List<dynamic> usersJson = json.decode(response.body);
    return usersJson.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}

// aqui podremos filtrar y mostrar usuarios donde `username` tenga más de 6 caracteres
void filterUsersByUsernameLength(List<User> users) {
  final filteredUsers = users.where((user) => user.username.length > 6).toList();
  print('Usuarios con username de más de 6 caracteres:');
  for (var user in filteredUsers) {
    print('${user.name} (${user.username})');
  }
}

//codigo para contar e imprimir la cantidad de usuarios cuyo correo electrónico pertenece al dominio `biz`
void countUsersWithEmailDomainBiz(List<User> users) {
  final count = users.where((user) => user.email.endsWith('.biz')).length;
  print('Cantidad de usuarios con el dominio de correo @biz: $count');
}

// esta es la funcion principal que cree para ejecuar el programa
void main() async {
  try {
    List<User> users = await fetchUsers();

    filterUsersByUsernameLength(users);
    countUsersWithEmailDomainBiz(users);
  } catch (e) {
    print('Error: $e');
  }
}
