User.create(name: 'Javier Diaz', username: 'Javiersito', role: 'Taquilla', cedula: 'V-29543140', email: 'javierdiazt406@gmail.com', password: '12345678', password_confirmation: '12345678')

User.create(name: 'Evanan Semprun', username: 'EvananSemprun', role: 'Taquilla', cedula: 'V-23203012', email: 'evanansemprun@gmail.com', password: '12345678', password_confirmation: '12345678')

User.create(name: 'Bob', username: 'BotBob', role: 'Taquilla', cedula: 'AUTO', email: 'bot@rifamax.com', password: '12345678', password_confirmation: '12345678')

Taquilla.create(name: 'La Maxima', owner_id: 1, users_ids: [1, 2])

Rifa.create(awardSign: 'Una moto', awardNoSign: '1000$', is_send: false, rifDate: Date.today, loteria: 'Zulia 7A', money: '$', price: 1.0, pin: nil, serial: SecureRandom.hex(6), verify: false, plate: 'AA2OD08', numbers: 203, year: 2020, taquillas_ids: [1], user_id: 1)
