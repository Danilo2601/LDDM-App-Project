import 'package:flutter/material.dart';

class TelaCadastro extends StatefulWidget{
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro>{
  double _fontSize = 16;
  bool _obscureText = true;
  String _radioSelected = '';
  bool _gmail = false;
  bool _whatsapp = false;

  void _switchPasswordVisibility(){
    setState(() {
      _obscureText = !_obscureText; // Troca o estado
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Create an account"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.black, fontSize: _fontSize),
              keyboardType: TextInputType.text,
              maxLength: 20
            )),

            Padding(padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Data de nascimento",
                border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.black, fontSize: _fontSize),
              keyboardType: TextInputType.datetime,
              maxLength: 10
            )),

            Padding(padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Telefone",
                border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.black, fontSize: _fontSize),
              keyboardType: TextInputType.number,
              maxLength: 11
            )),
            
            Padding(padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.black, fontSize: _fontSize),
              keyboardType: TextInputType.emailAddress
            )),
            
            
            Padding(padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _switchPasswordVisibility,
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility))
              ),
              style: TextStyle(color: Colors.black, fontSize: _fontSize),
              maxLength: 20
            )),

            Row(
              children: <Widget>[
                Text("Genero:"),
                SizedBox(width: 20),
                Text("Masculino"),
                Radio(
                  value: "m", 
                  groupValue: _radioSelected, 
                  onChanged: (String? escolha){
                    setState(() {
                      _radioSelected = escolha!;
                    });
                  }
                ),
                const Text("Feminino"),
                Radio(
                  value: "f", 
                  groupValue: _radioSelected, 
                  onChanged: (String? escolha){
                    setState(() {
                      _radioSelected = escolha!;
                    });
                  }
                )
              ],
            ),

            Column(
              children: <Widget>[
                const Text("Notificações:", textAlign: TextAlign.center),
                SwitchListTile(
                  title: const Text("Gmail"),
                  value: _gmail,
                  onChanged: (bool? valor){
                    setState(() {
                      _gmail = valor ?? false;
                    });
                  }
                ),
                SwitchListTile(
                  title: const Text("WhatsApp"),
                  value: _whatsapp,
                  onChanged: (bool? valor){
                    setState(() {
                      _whatsapp = valor ?? false;
                    });
                  }
                )
              ],
            ),

            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Entrar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
              ),
            ),


            Row(
              children: <Widget>[
                Text("Tamanho da fonte:"),
                SizedBox(width: 20),
                Slider(
                  value: _fontSize,
                  min: 10,
                  max: 32,
                  label: _fontSize.toString(),
                  divisions: 22,
                  onChanged: (double? novoValor){
                    setState(() {
                      _fontSize = novoValor!;
                    });
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}