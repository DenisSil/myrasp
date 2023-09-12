import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;

void checkInternetContection(SendPort internetConnectionPort) async {

  var url = Uri.https('google.com');


  final stopwatch = Stopwatch();

  stopwatch.start();
  while (true){
    if (stopwatch.elapsedMilliseconds > 1000) {
      try {
        final response = await http.get(url);
        internetConnectionPort.send(true);
      } catch (e) {
        internetConnectionPort.send(false);
      }
    }
  }
}

Future<Map<String,List<Subject>>> getData(int idGroup, String date) async{
  List<Subject> listSubject = [];

  Map<String,List<Subject>> listSubjects = {};

  var url = Uri.https('edu.donstu.ru', 'api/Rasp', {'idGroup':'$idGroup','sdate':date});

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
    if (listSubjects!.keys.contains(subject.data)) {
      listSubjects[subject.data]!.add(subject);
    } else {
      if(subject.subjectName != "лек Военная кафедра"){
        listSubjects[subject.data] = [subject];
      }
    }
  });
  return listSubjects;
}


Future<Map<String,int>?> getGroups() async {
  Map<String,int> groups = {};

  var url = Uri.https(
      'edu.donstu.ru',
      'api/raspGrouplist',
      {'year': '2023-2024'}
  );

  var response = await http.get(url);

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
    String this.timeStart,
    String this.timeEnd,
    String this.dayOfTheWeek,
    String this.subjectName,
    String this.teacher,
    String this.classroom,
      ){
    this.data = data.substring(5,10).replaceFirst('-','.');
  }

}