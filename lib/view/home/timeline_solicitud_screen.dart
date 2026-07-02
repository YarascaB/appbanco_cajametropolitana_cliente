import 'package:flutter/material.dart';
import '../../services/timeline_service.dart';

class TimelineSolicitudesScreen extends StatefulWidget {
  const TimelineSolicitudesScreen({super.key});

  @override
  State<TimelineSolicitudesScreen> createState() =>
      _TimelineSolicitudesScreenState();
}

class _TimelineSolicitudesScreenState extends State<TimelineSolicitudesScreen>
    with SingleTickerProviderStateMixin {

  Color obtenerColor(String estado) {
    switch (estado) {
      case "pendiente":
        return Colors.orange;
      case "aprobado":
        return Colors.blue;
      case "desembolsado":
        return Colors.green;
      case "rechazado":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  double getProgress(String estado) {
    switch (estado) {
      case "pendiente":
        return 0.25;
      case "aprobado":
        return 0.60;
      case "desembolsado":
        return 1.0;
      case "rechazado":
        return 0.40;
      default:
        return 0.0;
    }
  }

  int getStepIndex(String estado) {
    switch (estado) {
      case "pendiente":
        return 1;
      case "aprobado":
        return 2;
      case "desembolsado":
        return 4;
      case "rechazado":
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text("Seguimiento de solicitud"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: TimelineService().obtenerEstado(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final credito = snapshot.data!;
          final estado = credito["estado"];

          final progress = getProgress(estado);
          final activeStep = getStepIndex(estado);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _ProgressHeader(
                  estado: estado,
                  progress: progress,
                  color: obtenerColor(estado),
                ),

                const SizedBox(height: 25),

                _TimelineStep(
                  index: 1,
                  activeStep: activeStep,
                  title: "Solicitud enviada",
                  subtitle: "Recibimos tu solicitud",
                  isFirst: true,
                  isLast: false,
                ),

                _TimelineStep(
                  index: 2,
                  activeStep: activeStep,
                  title: "Evaluación",
                  subtitle: "Revisión de datos",
                  isFirst: false,
                  isLast: false,
                ),

                _TimelineStep(
                  index: 3,
                  activeStep: activeStep,
                  title: "Aprobación",
                  subtitle: "Decisión final",
                  isFirst: false,
                  isLast: false,
                ),

                _TimelineStep(
                  index: 4,
                  activeStep: activeStep,
                  title: "Desembolso",
                  subtitle: "Dinero liberado",
                  isFirst: false,
                  isLast: true,
                ),

                const SizedBox(height: 30),

                _StatusCard(
                  estado: estado,
                  color: obtenerColor(estado),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

//🔵 HEADER PROGRESO (FINTECH PREMIUM)

class _ProgressHeader extends StatelessWidget {
  final String estado;
  final double progress;
  final Color color;

  const _ProgressHeader({
    required this.estado,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Progreso de tu solicitud",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0, end: progress),
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(color),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          Text(
            estado.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// 🔥 TIMELINE PRO (CON LÍNEA + ANIMACIÓN)

class _TimelineStep extends StatelessWidget {
  final int index;
  final int activeStep;
  final String title;
  final String subtitle;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
    required this.index,
    required this.activeStep,
    required this.title,
    required this.subtitle,
    required this.isFirst,
    required this.isLast,
  });

  bool get isActive => index <= activeStep;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 120)),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Column(
                  children: [

                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? Colors.blue : Colors.grey.shade300,
                      ),
                      child: Icon(
                        isActive ? Icons.check : Icons.radio_button_unchecked,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),

                    if (!isLast)
                      Container(
                        width: 2,
                        height: 60,
                        color: isActive ? Colors.blue : Colors.grey.shade300,
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.black : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// 💳 STATUS CARD FINAL (NEOBANK STYLE)

class _StatusCard extends StatelessWidget {
  final String estado;
  final Color color;

  const _StatusCard({
    required this.estado,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "ESTADO ACTUAL",
            style: TextStyle(
              color: Colors.white70,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            estado.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}