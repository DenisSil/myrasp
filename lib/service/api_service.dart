import 'dart:convert';
import 'package:http/http.dart' as http;

class Subject {
  var data;
  var timeStart;
  var timeEnd;
  var dayOfTheWeek;
  var subjectName;
  var teacher;
  var classroom;

  Subject(
    data,
    String this.timeStart,
    String this.timeEnd,
    String this.dayOfTheWeek,
    String this.subjectName,
    String this.teacher,
    String this.classroom,
  ) {
    this.data = data.substring(5, 10).replaceFirst('-', '.');
  }
}

class APIService {
  Future<Map<String, dynamic>> getScheduleData(int id, String date) async {
    List<Subject> listSubject = [];
    String requestType;
    Map<String, String> responseType = {
      'idGroup': 'группы',
      'idAudLine': 'аудитории',
      'idTeacher': 'преподователя'
    };
    Map<String, List<Subject>> listSubjects = {};

    if (id > 50000 && id.toString().length == 5) {
      requestType = "idGroup";
    } else if (id.toString().length == 9) {
      requestType = "idAudLine";
    } else {
      requestType = "idTeacher";
    }

    var url = Uri.https(
        'edu.donstu.ru', 'api/Rasp', {requestType: '$id', 'sdate': date});

    final response = await http.get(url);
    var responseJson = jsonDecode(response.body)['data'];
    var name;
    switch (requestType) {
      case 'idGroup':
        name = responseJson['info']['group']['name'];
      case 'idAudLine':
        name = responseJson['rasp'][0]['аудитория'];
      case 'idTeacher':
        name = responseJson['info']['prepod']['name'];
    }

    final data = responseJson['rasp'];

    data.forEach((subject) {
      listSubject.add(Subject(
          subject['дата'],
          subject['начало'],
          subject['конец'],
          subject['день_недели'],
          subject['дисциплина'],
          subject['преподаватель'],
          subject['аудитория']));
    });
    for (var subject in listSubject) {
      if (listSubjects.keys.contains(subject.data)) {
        listSubjects[subject.data]!.add(subject);
      } else {
        if (subject.subjectName != "лек Военная кафедра") {
          listSubjects[subject.data] = [subject];
        }
      }
    }

    var getDataResponse = {
      'name': name,
      'type': responseType[requestType],
      'listSubjects': listSubjects
    };
    return getDataResponse;
  }

  Future<Map<String, int>?> getSearchData() async {
    Map<String, int> dataForSearch = {};
    var urlGroups =
        Uri.https('edu.donstu.ru', 'api/raspGrouplist', {'year': '2023-2024'});

    var responseGroups = await http.get(urlGroups);
    final dataGroups = jsonDecode(responseGroups.body)['data'];

    dataGroups.forEach((group) {
      dataForSearch[group['name']] = group['id'];
    });

    var urlAudit =
        Uri.https('edu.donstu.ru', 'api/raspAudlist', {'year': '2023-2024'});

    var responseAudit = await http.get(urlAudit);

    final dataAudit = jsonDecode(responseAudit.body)['data'];
    dataAudit.forEach((audit) {
      dataForSearch[audit['name']] = audit['id'];
    });

    var urlTeacher = Uri.https(
        'edu.donstu.ru', 'api/raspTeacherlist', {'year': '2023-2024'});

    var responseTeacher = await http.get(urlTeacher);

    final dataTeacher = jsonDecode(responseTeacher.body)['data'];
    dataTeacher.forEach((teacher) {
      dataForSearch[teacher['name']] = teacher['id'];
    });

    return dataForSearch;
  }

  Future<Map<String, int>> getGroupForSettings() async {
    Map<String, int> dataForSearch = {};
    var urlGroups =
        Uri.https('edu.donstu.ru', 'api/raspGrouplist', {'year': '2023-2024'});

    var responseGroups = await http.get(urlGroups);
    final dataGroups = jsonDecode(responseGroups.body)['data'];

    dataGroups.forEach((group) {
      dataForSearch[group['name']] = group['id'];
    });
    return dataForSearch;
  }
}
