import 'package:flutter/material.dart';

class SegundaTela extends StatefulWidget{
  @override
  _SegundaTelaState createState() => _SegundaTelaState();
}

class _SegundaTelaState extends State<SegundaTela>{
  List _items = [];

  void _loadItems(){
    _items = [];
    for (int i = 0; i<21;i++){
      Map<String, dynamic> item = Map();
      item["Titulo"] = "Item $i ";
      item["Descrição"] = "Este é o item $i da lista";
      _items.add(item);
    }
  }

  @override
  Widget build(BuildContext context){
    _loadItems();

    String valor = ModalRoute.of(context)?.settings.arguments as String;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo, ${valor.split('@')[0]}"), // Divide a string onde tem o '@' e pega a primeira parte(tudo que vem antes)
      ),
      drawer: Drawer(),
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(26),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text("Alerta"),
                      content: Text("Você clicou no item $index"),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text("Sim")),
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text("Não"))
                      ],
                    );
                  });
              },
              title: Text(_items[index]["Titulo"]),
              subtitle:  Text(_items[index]["Descrição"]),
            );
          },
        ),
      )
    );
  }
}