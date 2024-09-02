import 'package:localstore/localstore.dart';
import 'package:myrasp/service/api_service.dart';

class ScheduleService {
  final Localstore _db = Localstore.instance;

  Future<bool> checkIsThereDataInDb(int id, DateTime date) async {

    date = DateTime(date.year, date.month, date.day);

    var currentIdReferenceInDb = _db.collection('schedules').doc('$id');
    var scheduleSubjectData =
        await currentIdReferenceInDb.collection("subjects").get();

    if (scheduleSubjectData == null) {
      return false;
    }

    List<String> listDate = scheduleSubjectData.keys
        .toList()
        .map((e) => e.split("/").last)
        .toList();

    if (!listDate.contains(date.toString())) {
      return false;
    }

    return true;
  }

  Future<DataResponce> getSchedule(int id, DateTime date) async {
    DataResponce schedule;

    if (await checkIsThereDataInDb(id, date)) {
      schedule = await LocalstoreSchedule().getScheduleData(id, date);
    } else {
      schedule = await APIService().getScheduleData(id, date);

      LocalstoreSchedule().saveScheduleInLocalstore(id, schedule);
    }
    return schedule;
  }

}

class LocalstoreSchedule {
  final Localstore _db = Localstore.instance;

  Future<DataResponce> getScheduleData(int id, DateTime date) async {
    var currentIdReferenceInDb = _db.collection('schedules').doc('$id');

    var scheduleData = await currentIdReferenceInDb.get();

    if (scheduleData == null) {
      return DataResponce("name", "responce", {});
    }

    var scheduleSubjectData =
        await currentIdReferenceInDb.collection("subjects").get();

  
    print('Date: $date');
    print('Start of week: ${date.subtract(Duration(days: date.weekday - 1))}');
    print('End of week: ${date.add(Duration(days: DateTime.daysPerWeek - date.weekday))}');


    if (scheduleSubjectData == null) {
      return DataResponce("name", "responce", {});
    }
    var scheduleSubjectsKeys = scheduleSubjectData.keys.toList();

    Map<String, List<Subject>> listSubjects = {};

    for (var date in scheduleSubjectsKeys) {
      var noCastSubjects =
          scheduleSubjectData[date]['subjects'] as List<dynamic>;
      var subjects = noCastSubjects.cast<Map<String, dynamic>>();
      listSubjects[date] = Subject.listMapToListSubjects(subjects);
    }

    return DataResponce(
        scheduleData['name'], scheduleData['responceType'], listSubjects);
  }

  Future<void> saveScheduleInLocalstore(
      int id, DataResponce schedule) async {
    var currentIdReferenceInDb = _db.collection('schedules').doc('$id');

    currentIdReferenceInDb
        .set({"name": schedule.name, "responceType": schedule.responceType});

    var currentDataInIdIdSchedule =
        currentIdReferenceInDb.collection("subjects");

    schedule.listSubjects.forEach((key, value) {
      currentDataInIdIdSchedule
          .doc(key)
          .set({"subjects": value.map((e) => e.toJson()).toList()});
    });
  }
}
