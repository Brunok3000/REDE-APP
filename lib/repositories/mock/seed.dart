import 'package:uuid/uuid.dart';
import '../../repositories/mock/mock_singleton.dart';
import '../../models/partner_profile.dart';
import '../../models/establishment_type.dart';
import '../../models/menu_item.dart';
import '../../models/room.dart';

final _uuid = Uuid();

Future<void> seedAll() async {
  // Seed partners
  final p1 = PartnerProfile(
    id: _uuid.v4(),
    userId: 'partner-user-1',
    name: 'Pousada do Vale',
    description: 'Pousada charmosa com vista para o vale',
    types: [EstablishmentType.hotel],
    active: true,
    address: 'Rua das Flores, 123',
    gallery: [],
    contact: {'phone': '+55 11 99999-0001'},
  );
  final p2 = PartnerProfile(
    id: _uuid.v4(),
    userId: 'partner-user-2',
    name: 'Restaurante Sabor',
    description: 'Comida caseira e ambiente familiar',
    types: [EstablishmentType.restaurant],
    active: true,
    address: 'Av. Central, 45',
    gallery: [],
    contact: {'phone': '+55 11 99999-0002'},
  );
  await partnerRepositoryMock.createPartner(p1);
  await partnerRepositoryMock.createPartner(p2);

  // Seed menu items
  await menuRepositoryMock.create(
    MenuItem(
      id: '',
      partnerId: p2.id,
      title: 'Prato do dia',
      description: 'Arroz, feijão, carne e salada',
      price: 29.9,
      photos: [],
      tags: [],
    ),
  );
  await menuRepositoryMock.create(
    MenuItem(
      id: '',
      partnerId: p2.id,
      title: 'Pizza Marguerita',
      description: 'Mussarela, tomate e manjericão',
      price: 42.0,
      photos: [],
      tags: [],
    ),
  );

  // Seed rooms
  await roomRepositoryMock.create(
    Room(
      id: '',
      partnerId: p1.id,
      title: 'Suíte Standard',
      description: 'Cama queen, café da manhã incluso',
      photos: [],
      price: 180.0,
      capacity: 2,
      availability: null,
    ),
  );

  // Ensure demo user exists and is set as current user
  final demo = await userRepositoryMock.getCurrentUser();
  String demoUserId;
  String demoUserName;
  if (demo == null) {
    final created = await userRepositoryMock.createUser(
      name: 'Demo User',
      email: 'demo@local',
    );
    userRepositoryMock.setCurrentUser(created.id);
    demoUserId = created.id;
    demoUserName = created.name;
  } else {
    demoUserId = demo.id;
    demoUserName = demo.name;
  }

  // Seed demo posts
  final contents = [
    'Bom dia! Preparando um café e planejando meu dia ☕️',
    'Alguém recomenda um bom lugar para trabalhar remoto na cidade?',
    'Acabei de conhecer a Pousada do Vale, lugar incrível para descansar.',
    'Dica rápida: sempre confira o cardápio antes de ir ao restaurante.',
    'Foto do pôr do sol hoje — momento perfeito para desacelerar.',
    'Workshop de Flutter na próxima semana, espero ver vocês lá!',
    'Liquidificador estragou, alguém tem indicação de conserto?',
    'Promoção especial no Restaurante Sabor: 20% off no prato do dia!',
  ];

  for (final text in contents) {
    await postRepositoryMock.create(
      authorId: demoUserId,
      authorName: demoUserName,
      content: text,
    );
  }
  // Give the demo user a like on the first two posts (if present)
  final posts = await postRepositoryMock.listAll();
  if (posts.length >= 2) {
    await postRepositoryMock.like(posts[0].id, demoUserId);
    await postRepositoryMock.like(posts[1].id, demoUserId);
  }
}
