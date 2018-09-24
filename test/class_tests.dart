<<<<<<< HEAD
import 'package:cognito/models/assignment.dart';
///Tester for Class class
import 'package:test/test.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/grade_calculator.dart';
import 'package:cognito/models/task.dart';
=======
///Tester for Class class
import 'package:test/test.dart';
import 'package:cognito/models/class.dart';
>>>>>>> class-model

void main(){
  test("Class Constructor Tests", (){
    Class testClass = Class(
      title: "Test Class title",
      description: "This is a test", 
      location: "Test location",
      start: DateTime.now(),
      end: DateTime(2018, 12, 12), 
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "Test location",
      subjectArea: "Computer Science",
      units: 3
    );
    expect(testClass.title, equals("Test Class title"));
    expect(testClass.description, equals("This is a test"));
    expect(testClass.location, equals("Test location"));
    expect(testClass.courseNumber, equals("146"));
    expect(testClass.instructor, equals("Test instructor"));
    expect(testClass.location, equals("Test location"));
    expect(testClass.subjectArea, equals("Computer Science"));
<<<<<<< HEAD
    expect(testClass.units, equals(3));
  });

  test("Test addOfficeHours", (){
    Class testClass1 = Class(
      title: "Test map",
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "Test location",
      subjectArea: "Computer Science",
      units: 3
    );
    testClass1.officeHours.clear();
    expect(testClass1.officeHours.length, equals(0));

    testClass1.addOfficeHours(DateTime(1997), DateTime(2018));
    expect(testClass1.officeHours.length, equals(1));
  });

  test("Test optional arguments constuctor", (){
    Class testClass2 = Class(
      title: "Test optional constructor",
      start: DateTime.now(),
      end: DateTime(2018, 12, 12), 
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "San Jose",
      subjectArea: "Computer Science",
      units: 3
    );
    expect(testClass2.title, equals("Test optional constructor"));
    expect(testClass2.description, equals(""));
    expect(testClass2.location, equals(""));
    expect(testClass2.courseNumber, equals("146"));
    expect(testClass2.instructor, equals("Test instructor"));

  });

  test("Test todo list Assigment", (){
    Class testClass3 = Class(
      title: "Test optional constructor", 
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "San Jose",
      subjectArea: "Computer Science",
      units: 3
    );
    String key = "assignment";
    Assignment assignTest = Assignment();
    Assignment assignTest1 = Assignment();
    testClass3.addTodoItem(key, assignment: assignTest);
    expect(testClass3.todo[key].length, equals(1));

    testClass3.addTodoItem(key, assignment: assignTest1);
    expect(testClass3.todo[key].length, equals(2));
  });

  test("Test todo list Task", (){
    Class testClass4 = Class(
      title: "Test optional constructor", 
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "San Jose",
      subjectArea: "Computer Science",
      units: 3
    );
    String key = "task";
    Task taskTest = Task();
     Task taskTest1 = Task();
    testClass4.addTodoItem(key, task: taskTest);
    expect(testClass4.todo[key].length, equals(1));

    testClass4.addTodoItem(key, task: taskTest1);
    expect(testClass4.todo[key].length, equals(2));
  });

  test("Test todo list Assessment", (){
    Class testClass5 = Class(
      title: "Test optional constructor", 
      courseNumber: "146",
      instructor: "Test instructor",
      officeLocation: "San Jose",
      subjectArea: "Computer Science",
      units: 3
    );
    String key = "assessment";
    Assignment assignTest = Assignment(isAssessment: true);
    Assignment assignTest1 = Assignment(isAssessment: true);
    testClass5.addTodoItem(key, assignment: assignTest);
    expect(testClass5.todo[key].length, equals(1));

    testClass5.addTodoItem(key, assignment: assignTest1);
    expect(testClass5.todo[key].length, equals(2));
=======

    testClass.officeHours.clear();
    expect(testClass.officeHours.length, equals(0));

    testClass.addOfficeHours(DateTime(1997), DateTime(2018));
    expect(testClass.officeHours.length, equals(1));
    
>>>>>>> class-model
  });
}