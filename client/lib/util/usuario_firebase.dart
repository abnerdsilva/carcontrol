import 'package:carcontrol/pages/login/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioFirebase {

  static Future<User?> getUsuarioAtual() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  static Future<Usuario> getDadosUsuarioLogado() async {

    User? firebaseUser = await getUsuarioAtual();

    String? idUsuario = firebaseUser?.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
    await db.collection("usuarios").doc(idUsuario).get();

    if (snapshot.exists) {

      Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
      if (dados != null) {
        String tipoUsuario = dados["tipoUsuario"];
        String email = dados["email"];
        String nome = dados["nome"];

        Usuario usuario = Usuario();
        usuario.idUsuario = idUsuario!;
        usuario.tipoUsuario = tipoUsuario;
        usuario.email = email;
        usuario.nome = nome;

        return usuario;
      } else {
        throw Exception("Dados do usuário não encontrados");
      }
    } else {
      throw Exception("Usuário não encontrado");
    }
  }
}
