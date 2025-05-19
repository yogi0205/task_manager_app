import 'package:daily_do/data/database.dart';
import 'package:daily_do/utils/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  final _controller = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  void checkBoxChanged(int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      db.toDoList.add([_controller.text.trim(), false]);
      _controller.clear();
    });
    db.updateDataBase();
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void editTask(int index) {
    TextEditingController editController =
        TextEditingController(text: db.toDoList[index][0]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[200],
          title: const Text("Edit Task"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: "Edit task"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  db.toDoList[index][0] = editController.text;
                });
                db.updateDataBase();
                Navigator.of(context).pop();
              },
              child: const Text("Save", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: const Text('Simple ToDo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                const SizedBox(height: 10),
                searchBox(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: db.toDoList.length,
                    itemBuilder: (context, index) {
                      final taskName = db.toDoList[index][0];
                      if (searchText.isNotEmpty &&
                          !taskName.toLowerCase().contains(searchText.toLowerCase())) {
                        return const SizedBox.shrink();
                      }
                      return TodoList(
                        taskName: taskName,
                        taskCompleted: db.toDoList[index][1],
                        onChanged: (value) => checkBoxChanged(index),
                        deleteFunction: (context) => deleteTask(index),
                        searchText: searchText,
                        onEdit: (context) => editTask(index), // ✅ Long press edit
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Add a new todo item',
                        filled: true,
                        fillColor: Colors.deepPurple.shade200,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 56,
                    width: 56,
                    child: FloatingActionButton(
                      onPressed: saveNewTask,
                      backgroundColor: Colors.deepPurple,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.90, // 👈 85% of screen width
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    ),
  );
}

}
