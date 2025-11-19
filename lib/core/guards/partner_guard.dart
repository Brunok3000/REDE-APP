import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../repositories/mock/mock_singleton.dart';
import '../../models/user.dart';

class PartnerGuard extends ConsumerStatefulWidget {
  final Widget child;
  const PartnerGuard({super.key, required this.child});

  @override
  ConsumerState<PartnerGuard> createState() => _PartnerGuardState();
}

class _PartnerGuardState extends ConsumerState<PartnerGuard> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final u = await userRepositoryMock.getCurrentUser();
    if (u == null || u.role != UserRole.partner) {
      // redirect to login
      // use microtask to avoid calling during build
      scheduleMicrotask(() => GoRouter.of(context).go('/login'));
    } else {
      setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return widget.child;
  }
}
