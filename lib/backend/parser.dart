import 'dart:convert';
import 'dart:isolate';
import 'dart:io';
import 'package:http/http.dart' as http;


void checkInternetContection(SendPort internetConnectionPort) async {

  final stopwatch = Stopwatch();
  stopwatch.start();
  while (true){
    if (stopwatch.elapsedMilliseconds > 3000) {
      stopwatch.reset();
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          internetConnectionPort.send(true);
        }
      } on SocketException catch (_) {
        internetConnectionPort.send(false);
      }
    }
  }
}

Future<Map<String, dynamic>> getData(int id, String date) async{
  List<Subject> listSubject = [];
  var url;
  var type;
  Map<String,List<Subject>> listSubjects = {};

  if (id > 50000 && id.toString().length == 5) {
    url = Uri.https(
        'edu.donstu.ru', 'api/Rasp', {'idGroup': '$id', 'sdate': date});
    type = 'группы';
  }else if(id.toString().length == 9) {
    url = Uri.https(
        'edu.donstu.ru', 'api/Rasp', {'idAudLine': '$id', 'sdate': date});
    type = 'аудитории';
  }else {
    url = Uri.https(
        'edu.donstu.ru', 'api/Rasp', {'idTeacher': '$id', 'sdate': date});
    type = 'преподователя';

  }
  final response = await http.get(url);
  var responseJson = jsonDecode(response.body)['data'];
  var name;
  switch(type){
    case 'группы':
      name = responseJson['info']['group']['name'];
    case 'аудитории':
      name = responseJson['rasp'][0]['аудитория'];
    case 'преподователя':
      name = responseJson['info']['prepod']['name'];
  }

  final data = responseJson['rasp'];

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

  var getDataResponse = {'name':name, 'type':type, 'listSubjects': listSubjects};
  return getDataResponse;
}


Future<Map<String,int>?> getDataForSearch() async {
  Map<String,int> dataForSearch = {};
  var url_groups = Uri.https(
      'edu.donstu.ru',
      'api/raspGrouplist',
      {'year': '2023-2024'}
  );

  var response_groups = await http.get(url_groups);
  final data_groups = jsonDecode(response_groups.body)['data'];


  data_groups.forEach((group){
    dataForSearch[group['name']] = group['id'];
  });


  var url_audit = Uri.https(
      'edu.donstu.ru',
      'api/raspAudlist',
      {'year': '2023-2024'}
  );

  var response_audit = await http.get(url_audit);

  final data_audit = jsonDecode(response_audit.body)['data'];
  data_audit.forEach((audit){
    dataForSearch[audit['name']] = audit['id'];
  });

  var url_teacher = Uri.https(
      'edu.donstu.ru',
      'api/raspTeacherlist',
      {'year': '2023-2024'}
  );

  var response_teacher = await http.get(url_teacher);

  final data_teacher = jsonDecode(response_teacher.body)['data'];
  data_teacher.forEach((teacher){
    dataForSearch[teacher['name']] = teacher['id'];
  });

  return dataForSearch;

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