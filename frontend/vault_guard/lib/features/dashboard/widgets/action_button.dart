import '../../../main_exports.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;

  const ActionButton({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon), const SizedBox(height: 8), Text(title)],
      ),
    );
  }
}
