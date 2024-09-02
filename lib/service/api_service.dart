import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Subject {
  late DateTime _date;
  final String timeStart;
  final String timeEnd;
  final String dayOfTheWeek;
  final String subjectName;
  final String teacher;
  final String classroom;

  DateTime get date => _date;

  Subject(
    DateTime date,
    this.timeStart,
    this.timeEnd,
    this.dayOfTheWeek,
    this.subjectName,
    this.teacher,
    this.classroom,
  ) : _date = date;

  Map<String, dynamic> toJson() {
    return {
      'дата': date.toString(),
      'начало': timeStart,
      'конец': timeEnd,
      'день_недели': dayOfTheWeek,
      'дисциплина': subjectName,
      'преподаватель': teacher,
      'аудитория': classroom,
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {

    late DateTime date;

    try{
      date = DateTime.parse(json['дата']); 
    }catch (e){
      date = DateTime.now();
    }

    return Subject(
        date,
        json['начало'],
        json['конец'],
        json['день_недели'],
        json['дисциплина'],
        json['преподаватель'],
        json['аудитория'],);
  }

  static List<Subject> listFromJson(Map<String, dynamic> json) {
    List<Subject> list = [];

    List<dynamic> listJson = json['rasp'];

    listJson.forEach((element) {
      list.add(Subject.fromJson(element));
    });

    return list;
  }

  static List<Subject> listMapToListSubjects(List<Map<String, dynamic>> json) {
    return json.map((subject) => Subject.fromJson(subject)).toList();
  }
}

class DataResponce {
  String _name;
  String _responceType;
  Map<String, List<Subject>> _listSubjects;

  String get name => _name;
  set name(String value) => _name = value;

  String get responceType => _responceType;
  set responceType(String value) => _responceType = value;

  Map<String, List<Subject>> get listSubjects => _listSubjects;
  set listSubjects(Map<String, List<Subject>> value) => _listSubjects = value;

  DataResponce(
    String name,
    String responceType,
    Map<String, List<Subject>> listSubjects,
  )   : _name = name,
        _responceType = responceType,
        _listSubjects = listSubjects;
}

class APIService {
  Future<DataResponce> getScheduleData(int id, DateTime date) async {
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

    var url = Uri.https('edu.donstu.ru', 'api/Rasp',
        {requestType: '$id', 'sdate': DateFormat("dd.MM.yyyy").format(date)});

    final response = await http.get(url);
    var responseJson = jsonDecode(response.body)['data'];
    late String name;
    switch (requestType) {
      case 'idGroup':
        name = responseJson['info']['group']['name'];
      case 'idAudLine':
        name = responseJson['rasp'][0]['аудитория'];
      case 'idTeacher':
        name = responseJson['info']['prepod']['name'];
    }

    listSubject = Subject.listFromJson(responseJson);

    var dateTimeFormat = DateFormat('MM.dd');

    for (var subject in listSubject) {
      if (listSubjects.keys.contains(subject.date.toString())) {
        listSubjects[subject.date.toString()]!.add(subject);
      } else {
        if (subject.subjectName == "лек Военная кафедра") {
          continue;
        }
        listSubjects[subject.date.toString()] = [subject];
      }
    }

    var getDataResponse = DataResponce(
      name,
      responseType[requestType]!,
      listSubjects,
    );

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
