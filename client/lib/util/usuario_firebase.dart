import 'package:carcontrol/model/usuario_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioFirebase {
  static Future<User?> getUsuarioAtual() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  static Future<Usuario> getDadosUsuarioLogado() async {
    User? firebaseUser = await getUsuarioAtual();

    FirebaseFirestore db = FirebaseFirestore.instance;
    final snapshot = await db.collection('usuarios').where('id', isEqualTo: firebaseUser!.uid).get();

    Map<String, dynamic>? dados;
    for (var element in snapshot.docs) {
      dados = element.data();
      break;
    }

    if (dados != null) {
      String id = dados["id"];
      String cpf = dados["cpf"];
      String email = dados["email"];
      String nome = dados["nome"];
      String telefone = dados["telefone"];
      String tipoUsuario = dados["tipoUsuario"];

      Usuario usuario = Usuario();
      usuario.id = id;
      usuario.cpf = cpf;
      usuario.email = email;
      usuario.nome = nome;
      usuario.telefone = telefone;
      usuario.tipoUsuario = tipoUsuario;

      return usuario;
    } else {
      throw Exception("Dados do usuário não encontrados");
    }
  }
}
