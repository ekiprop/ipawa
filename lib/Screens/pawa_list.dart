import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ipawa/Models/pawa.dart';
import 'package:ipawa/Utils/database_helper.dart';
import 'package:ipawa/Screens/pawa_detail.dart';
import 'package:sqflite/sqflite.dart';

class PawaList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PawaListState();
  }
}

class PawaListState extends State<PawaList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Pawa> pawaList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (pawaList == null) {
      pawaList = List<Pawa>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pawas'),
      ),
      body: getPawaListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Pawa('', '', ''), 'Add Pawa');
        },
        tooltip: 'Add Pawa',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getPawaListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.pawaList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.pawaList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.pawaList[position].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _delete(context, pawaList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.pawaList[position], 'Edit Pawa');
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  // Color getPriorityColor(int priority) {
  // 	switch (priority) {
  // 		case 1:
  // 			return Colors.red;
  // 			break;
  // 		case 2:
  // 			return Colors.yellow;
  // 			break;

  // 		default:
  // 			return Colors.yellow;
  // 	}
  // }
  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  // Returns the priority icon
  // Icon getPriorityIcon(int priority) {
  // 	switch (priority) {
  // 		case 1:
  // 			return Icon(Icons.play_arrow);
  // 			break;
  // 		case 2:
  // 			return Icon(Icons.keyboard_arrow_right);
  // 			break;

  // 		default:
  // 			return Icon(Icons.keyboard_arrow_right);
  // 	}
  // }

  void _delete(BuildContext context, Pawa pawa) async {
    int result = await databaseHelper.deletePawa(pawa.id);
    if (result != 0) {
      _showSnackBar(context, 'Pawa Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Pawa pawa, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PawaDetail(pawa, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Pawa>> pawaListFuture = databaseHelper.getPawaList();
      pawaListFuture.then((pawaList) {
        setState(() {
          this.pawaList = pawaList;
          this.count = pawaList.length;
        });
      });
    });
  }
}
