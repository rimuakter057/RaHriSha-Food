import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

void main() async{
  // await dotenv.load(fileName: ".env");
  // print("object");
  // dotenv.env["URL"];
  // dotenv.env["URL"];
  await Supabase.initialize(
      url: "https://szylekgapqhyqynnnodu.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN6eWxla2dhcHFoeXF5bm5ub2R1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE0Mzk1NDIsImV4cCI6MjA2NzAxNTU0Mn0.Er7oIPUYI5hrxlsUylC6N4ezTYth0wzjNwmjOQi4fGU"
  );
  runApp(const RaHriShaFood());
}




