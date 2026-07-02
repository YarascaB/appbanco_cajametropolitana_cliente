import 'package:flutter/material.dart';
import '../../services/notificaciones_service.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() =>
      _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {

  final Set<int> leidas = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Notificaciones"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: NotificacionesService().obtener(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data as List;

          if (lista.isEmpty) {
            return const Center(
              child: Text("No tienes notificaciones"),
            );
          }

          final noLeidas =
              lista.length - leidas.length;

          return Column(
            children: [

              // 🔴 HEADER CON CONTADOR
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Inbox",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (noLeidas > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "$noLeidas nuevas",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: lista.length,
                  itemBuilder: (_, index) {
                    final item = lista[index];

                    final bool isRead = leidas.contains(index);

                    return _AnimatedItem(
                      index: index,
                      child: Dismissible(
                        key: UniqueKey(),

                        direction: DismissDirection.endToStart,

                        onDismissed: (_) {
                          setState(() {
                            leidas.add(index);
                          });
                        },

                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),

                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              leidas.add(index);
                            });
                          },

                          child: _NotificationCard(
                            titulo: item["titulo"],
                            mensaje: item["mensaje"],
                            fecha: item["created_at"],
                            isRead: isRead,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

//🔔 CARD PRO (LEÍDA / NO LEÍDA)

class _NotificationCard extends StatelessWidget {
  final String titulo;
  final String mensaje;
  final String fecha;
  final bool isRead;

  const _NotificationCard({
    required this.titulo,
    required this.mensaje,
    required this.fecha,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {

    final date = fecha.toString().substring(0, 10);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [

          // 🔵 INDICADOR NO LEÍDO
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRead ? Colors.transparent : Colors.blue,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isRead ? Colors.grey[700] : Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  mensaje,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//🎬 ANIMACIÓN DE ENTRADA

class _AnimatedItem extends StatelessWidget {
  final Widget child;
  final int index;

  const _AnimatedItem({
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 250 + (index * 80)),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: child,
          ),
        );
      },
    );
  }
}