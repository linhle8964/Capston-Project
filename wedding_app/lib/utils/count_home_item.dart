import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/model/task_model.dart';

int countBudget(List<Budget> listBudget){
  int count = 0;
  if(listBudget != null){
    for(Budget budget in listBudget){
      if(budget.money > 0){
        count += budget.money.toInt();
      }
    }
  }
  return count;
}

int countFinisedTask(List<Task> listTask){
  int count = 0;
  if(listTask != null){
    for(Task task in listTask){
      if(task.status) count++;
    }
  }
  return count;
}

int countConfirmedGuest(List<Guest> listGuest){
  int count = 0;
  if(listGuest != null){
    for(Guest guest in listGuest){
      if(guest.status == 1) count++;
    }
  }
  return count;
}