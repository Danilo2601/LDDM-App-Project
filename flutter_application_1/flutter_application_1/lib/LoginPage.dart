import 'package:flutter/material.dart';
import "TelaCadastro.dart";

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String emailTeste = "eumesmo@gmail.com";
  String senhaTeste = "12345";
  
  bool _remember = false;
  bool _obscureText = true;
  void _switchPasswordVisibility(){
    setState(() {
      _obscureText = !_obscureText; 
    });
  }
  
  void _showErrorDialog(String message){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Dados inválidos'),
          content: Text(message),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("Ok"))
          ],
        );
      });
  }

  void _validarLogin (){
    String email = _nameController.text;
    String senha = _passwordController.text;

    if (email != emailTeste){ // Email incorreto
      _showErrorDialog("Email incorreto");
    
    } else if (senha != senhaTeste){ // Senha incorreta
      _showErrorDialog("Senha incorreta");
    
    } else { // Email e senha corretos
      Navigator.of(context).pushNamed(
        "/segunda", arguments: email
      );
    }
  }

  
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Login "),
          backgroundColor: Colors.orange,
        ),
        backgroundColor: Colors.blue[900],
        drawer: Drawer(),

        body: Align(
          alignment: Alignment.center,
          child: Container(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Texto "TrailGuide"
              Text(
                'TrailGuide',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 20),

              // Ícone de pessoa com borda laranja
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange, // Borda laranja
                    width: 4,
                  ),
                  color: Colors.blue[900], // Fundo azul escuro
                ),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white, // Ícone branco
                ),
              ),

              SizedBox(height: 20),
                Container(
                    width: 300,
                    child: TextField(decoration: const InputDecoration(
                                        labelText: "Email",
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white),
                                      style: const TextStyle(color: Colors.black, fontSize: 16),
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _nameController,),
                    ),

                SizedBox(height: 20),
                Container(
                      width: 300,
                      child: TextField(decoration: InputDecoration(
                                        labelText: "Senha",
                                        border: const OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white,
                                        suffixIcon: IconButton(
                                              onPressed: _switchPasswordVisibility,
                                              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility))),
                                        style: const TextStyle(color: Colors.black, fontSize: 16),
                                        controller: _passwordController,
                                        obscureText: _obscureText,),),

                                                        SizedBox(height: 20),
                CheckboxListTile(
                  title: Text("Lembrar de mim?",
                    style: TextStyle(color: Colors.white),),
                  value: _remember,
                  onChanged: (bool? valor){
                    setState(() {
                      _remember = valor ?? false;
                    });
                },
                checkColor: Colors.black,  // Cor do "check" dentro da caixa
                fillColor: WidgetStatePropertyAll(Colors.white)
                ),

                SizedBox(height: 20),
                ElevatedButton(onPressed: _validarLogin,
                                child: Text("Entrar"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),),  

                SizedBox(height: 20),
                RichText(text: TextSpan(text: "Não tem conta?", style: TextStyle(color: Colors.white),
                                        children: [WidgetSpan(child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => TelaCadastro()));
                                          },
                                          child: Text("Criar uma nova", style: TextStyle(color: Colors.blue[300]),),),
                                        ))]),)      
                ],
            ),
          ),
        ),
        
        
    );
  }

}