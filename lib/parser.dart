import 'dart:convert';

import 'package:http/http.dart' as http;



// https://edu.donstu.ru/api/Rasp?idGroup=43732&sdate=2023-05-11&year=2022-2023

void main(){
  getData(43732,'2023-05-11');
}

Future<List<Subject>> getData(int idGroup, String date) async{
  List<Subject> listSubject = [];
  var url = Uri.https('edu.donstu.ru', 'api/Rasp', {'idGroup':'$idGroup','sdate':'$date', 'year':'2022-2023'});

  final response = await http.get(url);

  var data = jsonDecode(response.body)['data']['rasp'];

  data.forEach((subject){
    listSubject.add(Subject(subject['дата'],
                            subject['начало'],
                            subject['конец'],
                            subject['день_недели'],
                            subject['дисциплина'],
                            subject['преподаватель'],
                            subject['аудитория']));
  });
  print(listSubject[0].timeStart);
  return listSubject;
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