import 'dart:convert';
import 'package:http/http.dart' as http;


// https://edu.donstu.ru/api/Rasp?idGroup=50884&sdate=2023-09-05

Future<Map<String,List<Subject>>> getData(int idGroup, String date) async{
  List<Subject> listSubject = [];

  Map<String,List<Subject>> listSubjects = {};

  var url = Uri.https('edu.donstu.ru', 'api/Rasp', {'idGroup':'$idGroup','sdate':'$date'});

  final response = await http.get(url);

  final data = jsonDecode(response.body)['data']['rasp'];

  data.forEach((subject){

    listSubject.add(Subject(subject['дата'],
                            subject['начало'],
                            subject['конец'],
                            subject['день_недели'],
                            subject['дисциплина'],
                            subject['преподаватель'],
                            subject['аудитория']));
  });


  listSubject.forEach((subject) {
    if (listSubjects.keys.contains(subject.data)){
      listSubjects[subject.data]!.add(subject);
    }else{
      listSubjects[subject.data] = [subject];
    }
  });
  return listSubjects;
}


Future<Map<String,int>> getGroups() async {
  Map<String,int> groups = {};

  var url = Uri.https('edu.donstu.ru', 'api/raspGrouplist',
      {'year': '2023-2024'});

  var response;

  response = await http.get(url);

  final data = jsonDecode(response.body)['data'];


  data.forEach((group){
    groups[group['name']] = group['id'];
  });
  return groups;

}


class Subject{

  var data;
  var timeStart;
  var timeEnd;
  var dayOfTheWeek;
  var subjectName;
  var teacher;
  var classroom;

  Subject(data,
    String timeStart,
    String timeEnd,
    String dayOfTheWeek,
    String subjectName,
    String teacher,
    String classroom,
      ){
    this.data = data.substring(5,10).replaceFirst('-','.');
    this.timeStart = timeStart;
    this.timeEnd = timeEnd;
    this.dayOfTheWeek = dayOfTheWeek;
    this.subjectName = subjectName;
    this.teacher = teacher;
    this.classroom = classroom;
  }

}