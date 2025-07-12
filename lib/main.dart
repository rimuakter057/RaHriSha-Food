import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

void main() async{
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
   await dotenv.load(fileName: ".env");
   print('dotenv.env["URL"];');
  await Supabase.initialize(
      url: dotenv.env["URL"]??'',
    anonKey: dotenv.env["ANON_KEY"]??''
  );
  runApp(const RaHriShaFood());
}




