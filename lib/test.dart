import 'package:http/http.dart' as http;


void main() async {
  
  print(await checkInternetContection());

}

Future<bool> checkInternetContection() async {
  bool internetConnection = true;
  try {
    var url = Uri.https('google.com');

    await http.get(url);
  }catch (e){
    internetConnection = false;
  }finally{
    return internetConnection;
  }

}