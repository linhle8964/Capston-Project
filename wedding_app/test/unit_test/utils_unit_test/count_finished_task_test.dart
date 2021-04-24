import 'package:test/test.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/utils/count_home_item.dart';

void main() {

  Task task1 = new Task(name: "a", dueDate: DateTime.now(), status: false, note: "", category: "");
  Task task2 = new Task(name: "b", dueDate: DateTime.now(), status: false, note: "", category: "");
  Task task3 = new Task(name: "c", dueDate: DateTime.now(), status: true, note: "", category: "");
  Task task4 = new Task(name: "d", dueDate: DateTime.now(), status: true, note: "", category: "");
  
  test('UTCID01', () {
    List<Task> tasks = [];
    var result = countFinisedTask(tasks);
    expect(result, 0);
  });

  test('UTCID02', () {
    List<Task> tasks;
    var result = countFinisedTask(tasks);
    expect(result, 0);
  });

  test('UTCID03', () {
    List<Task> tasks = [];
    tasks.add(task1);
    var result = countFinisedTask(tasks);
    expect(result, 0);
  });

  test('UTCID04', () {
    List<Task> tasks = [];
    tasks.add(task3);
    var result = countFinisedTask(tasks);
    expect(result, 1);
  });

  test('UTCID05', () {
    List<Task> tasks = [];
    tasks.add(task1);
    tasks.add(task2);
    var result = countFinisedTask(tasks);
    expect(result, 0);
  });

  test('UTCID06', () {
    List<Task> tasks = [];
    tasks.add(task3);
    tasks.add(task4);
    var result = countFinisedTask(tasks);
    expect(result, 2);
  });

  test('UTCID07', () {
    List<Task> tasks = [];
    tasks.add(task2);
    tasks.add(task3);
    var result = countFinisedTask(tasks);
    expect(result, 1);
  });

  test('UTCID08', () {
    List<Task> tasks = [];
    tasks.add(task1);
    tasks.add(task2);
    tasks.add(task3);
    var result = countFinisedTask(tasks);
    expect(result, 1);
  });

  test('UTCID09', () {
    List<Task> tasks = [];
    tasks.add(task2);
    tasks.add(task3);
    tasks.add(task4);
    var result = countFinisedTask(tasks);
    expect(result, 2);
  });

  test('UTCID10', () {
    List<Task> tasks = [];
    tasks.add(task1);
    tasks.add(task2);
    tasks.add(task3);
    tasks.add(task4);
    var result = countFinisedTask(tasks);
    expect(result, 2);
  });

}