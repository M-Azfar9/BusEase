import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final Color myColor;

  const RoundButton({super.key,
    required this.title,
    required this.onTap,
    required this.myColor,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height/17,
        decoration: BoxDecoration(
          color: myColor,
          borderRadius: BorderRadius.circular(size.width/30),
        ),
        child: Center(
          child: loading? CircularProgressIndicator (color: Colors.white, ):
          Text(title, style: GoogleFonts.play(
              fontStyle: FontStyle.italic,
              color: Colors.white, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
