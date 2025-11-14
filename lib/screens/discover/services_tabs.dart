import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/supabase_client.dart';
import '../../providers/auth/auth_provider.dart';

// Provider para reservas disponíveis
final reservasProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      establishmentId,
    ) async {
      final client = SupabaseClientService.client;
      final results = await client
          .from('table_reservations')
          .select()
          .eq('establishment_id', establishmentId)
          .order('reserved_for', ascending: true);
      return List<Map<String, dynamic>>.from(results);
    });

// Provider para eventos do estabelecimento
final eventosProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      establishmentId,
    ) async {
      final client = SupabaseClientService.client;
      final results = await client
          .from('events')
          .select()
          .eq('establishment_id', establishmentId)
          .order('date', ascending: true);
      return List<Map<String, dynamic>>.from(results);
    });

// Provider para hospedagens disponíveis
final hospedagensProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      establishmentId,
    ) async {
      final client = SupabaseClientService.client;
      final results = await client
          .from('room_bookings')
          .select()
          .eq('establishment_id', establishmentId)
          .order('check_in', ascending: true);
      return List<Map<String, dynamic>>.from(results);
    });

// ===================== RESERVA DE MESA =====================
class ReservaTab extends ConsumerStatefulWidget {
  final String establishmentId;

  const ReservaTab({super.key, required this.establishmentId});

  @override
  ConsumerState<ReservaTab> createState() => _ReservaTabState();
}

class _ReservaTabState extends ConsumerState<ReservaTab> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late int _partySize;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _selectedTime = TimeOfDay.now();
    _partySize = 2;
  }

  @override
  Widget build(BuildContext context) {
    final reservasAsync = ref.watch(reservasProvider(widget.establishmentId));
    final auth = ref.watch(authProvider).value;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Calendário
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecione Data e Hora',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 60)),
                    focusedDay: _selectedDate,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDate, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Hora
                  Row(
                    children: [
                      const Text('Horário: '),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (time != null) {
                            setState(() => _selectedTime = time);
                          }
                        },
                        child: Text(
                          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Número de pessoas
                  Row(
                    children: [
                      const Text('Número de Pessoas: '),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: _partySize,
                        items: List.generate(
                          10,
                          (i) => DropdownMenuItem(
                            value: i + 1,
                            child: Text('${i + 1}'),
                          ),
                        ),
                        onChanged: (v) {
                          if (v != null) setState(() => _partySize = v);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: auth == null
                          ? null
                          : () => _submitReserva(auth.userId),
                      child: const Text('Confirmar Reserva'),
                    ),
                  ),
                ],
              ),
            ),
            // Reservas próximas
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Próximas Reservas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  reservasAsync.when(
                    data: (reservas) {
                      if (reservas.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Nenhuma reserva realizada'),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reservas.length,
                        itemBuilder: (context, index) {
                          final reserva = reservas[index];
                          return Card(
                            child: ListTile(
                              title: Text('${reserva['party_size']} pessoa(s)'),
                              subtitle: Text('Status: ${reserva['status']}'),
                              trailing: Text(
                                '${reserva['reserved_for']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, st) => Center(child: Text('Erro: $err')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReserva(String? userId) async {
    if (userId == null) {
      Fluttertoast.showToast(msg: 'Usuário não autenticado');
      return;
    }

    try {
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await SupabaseClientService.client.from('table_reservations').insert({
        'establishment_id': widget.establishmentId,
        'user_id': userId,
        'reserved_for': dateTime.toIso8601String(),
        'party_size': _partySize,
        'status': 'requested',
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ref.invalidate(reservasProvider(widget.establishmentId));
        Fluttertoast.showToast(msg: 'Reserva realizada com sucesso!');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erro ao criar reserva: $e');
    }
  }
}

// ===================== INGRESSOS =====================
class IngressosTab extends ConsumerWidget {
  final String establishmentId;

  const IngressosTab({super.key, required this.establishmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventosAsync = ref.watch(eventosProvider(establishmentId));
    final auth = ref.watch(authProvider).value;

    return eventosAsync.when(
      data: (eventos) {
        if (eventos.isEmpty) {
          return const Center(child: Text('Nenhum evento disponível'));
        }
        return ListView.builder(
          itemCount: eventos.length,
          itemBuilder: (context, index) {
            final evento = eventos[index];
            final remaining =
                (evento['total_tickets'] ?? 0) - (evento['sold_tickets'] ?? 0);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(evento['name'] ?? 'Evento'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Data: ${evento['date']}'),
                    Text(
                      'Preço: R\$ ${evento['price']?.toStringAsFixed(2) ?? '0.00'}',
                    ),
                    Text('Ingressos: $remaining disponíveis'),
                  ],
                ),
                trailing: remaining > 0
                    ? ElevatedButton(
                        onPressed: auth == null
                            ? null
                            : () => _buyTickets(
                                context,
                                ref,
                                evento['id'],
                                auth.userId,
                                evento['price'],
                              ),
                        child: const Text('Comprar'),
                      )
                    : const Chip(label: Text('Esgotado')),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Erro: $err')),
    );
  }

  void _buyTickets(
    BuildContext context,
    WidgetRef ref,
    String eventId,
    String? userId,
    double price,
  ) {
    if (userId == null) return;

    int quantity = 1;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Comprar Ingressos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Quantidade:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: quantity > 1
                        ? () => setState(() => quantity--)
                        : null,
                  ),
                  Text('$quantity'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => quantity++),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Total: R\$ ${(price * quantity).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await SupabaseClientService.client
                      .from('ticket_purchases')
                      .insert({
                        'event_id': eventId,
                        'user_id': userId,
                        'quantity': quantity,
                        'total': price * quantity,
                        'created_at': DateTime.now().toIso8601String(),
                      });

                  if (context.mounted) {
                    Navigator.pop(context);
                    ref.invalidate(eventosProvider(establishmentId));
                    Fluttertoast.showToast(msg: 'Ingressos comprados!');
                  }
                } catch (e) {
                  Fluttertoast.showToast(msg: 'Erro: $e');
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== HOSPEDAGEM =====================
class HospedagemTab extends ConsumerStatefulWidget {
  final String establishmentId;

  const HospedagemTab({super.key, required this.establishmentId});

  @override
  ConsumerState<HospedagemTab> createState() => _HospedagemTabState();
}

class _HospedagemTabState extends ConsumerState<HospedagemTab> {
  late DateTime _checkIn;
  late DateTime _checkOut;
  late int _guests;

  @override
  void initState() {
    super.initState();
    _checkIn = DateTime.now();
    _checkOut = DateTime.now().add(const Duration(days: 1));
    _guests = 1;
  }

  @override
  Widget build(BuildContext context) {
    final hospedagensAsync = ref.watch(
      hospedagensProvider(widget.establishmentId),
    );
    final auth = ref.watch(authProvider).value;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecione Datas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Check-in
                ListTile(
                  title: const Text('Check-in'),
                  trailing: Text(
                    '${_checkIn.day}/${_checkIn.month}/${_checkIn.year}',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _checkIn,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => _checkIn = date);
                    }
                  },
                ),
                // Check-out
                ListTile(
                  title: const Text('Check-out'),
                  trailing: Text(
                    '${_checkOut.day}/${_checkOut.month}/${_checkOut.year}',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _checkOut,
                      firstDate: _checkIn.add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => _checkOut = date);
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Número de hóspedes
                Row(
                  children: [
                    const Text('Número de Hóspedes: '),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _guests,
                      items: List.generate(
                        8,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('${i + 1}'),
                        ),
                      ),
                      onChanged: (v) {
                        if (v != null) setState(() => _guests = v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth == null
                        ? null
                        : () => _submitBooking(auth.userId),
                    child: const Text('Confirmar Hospedagem'),
                  ),
                ),
              ],
            ),
          ),
          // Bookings
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hospedagens Reservadas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                hospedagensAsync.when(
                  data: (hospedagens) {
                    if (hospedagens.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Nenhuma hospedagem reservada'),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: hospedagens.length,
                      itemBuilder: (context, index) {
                        final booking = hospedagens[index];
                        return Card(
                          child: ListTile(
                            title: Text('${booking['guests']} hóspede(s)'),
                            subtitle: Text(
                              'De ${booking['check_in']} até ${booking['check_out']}',
                            ),
                            trailing: Text(
                              booking['status'] ?? 'pending',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, st) => Center(child: Text('Erro: $err')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitBooking(String? userId) async {
    if (userId == null) {
      Fluttertoast.showToast(msg: 'Usuário não autenticado');
      return;
    }

    try {
      await SupabaseClientService.client.from('room_bookings').insert({
        'establishment_id': widget.establishmentId,
        'user_id': userId,
        'check_in': _checkIn.toIso8601String(),
        'check_out': _checkOut.toIso8601String(),
        'guests': _guests,
        'status': 'requested',
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ref.invalidate(hospedagensProvider(widget.establishmentId));
        Fluttertoast.showToast(msg: 'Hospedagem reservada com sucesso!');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erro ao reservar hospedagem: $e');
    }
  }
}
