import 'package:dermaai/libs/libraries.dart';

class Warningmessage extends StatelessWidget {
  final String message;
  const Warningmessage({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(  width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}


