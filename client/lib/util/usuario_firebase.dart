import 'package:carcontrol/pages/login/usuario.dart';
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
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(firebaseUser!.uid).get();

    if (snapshot.exists) {
      Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
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
    } else {
      throw Exception("Usuário não encontrado");
    }
  }
}
