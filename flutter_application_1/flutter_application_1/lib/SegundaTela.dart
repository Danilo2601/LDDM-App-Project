import 'package:flutter/material.dart';

class SegundaTela extends StatefulWidget{
  const SegundaTela({super.key});

  @override
  _SegundaTelaState createState() => _SegundaTelaState();
}

class _SegundaTelaState extends State<SegundaTela>{
  List _items = [];

  void _loadItems(){
    _items = [];
    for (int i = 0; i<21;i++){
      Map<String, dynamic> item = {};
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
      drawer: const Drawer(),
      body: Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(26),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: const Text("Alerta"),
                      content: Text("Você clicou no item $index"),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: const Text("Sim")),
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: const Text("Não"))
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