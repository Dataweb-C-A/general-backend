User.create(name: 'Javier Diaz', username: 'Javier', role: 'Taquilla', cedula: 'V-29543140', email: 'javierdiazt406@gmail.com', password: '12345678', password_confirmation: '12345678')

User.create(name: 'Evanan Semprun', username: 'EvananSemprun', role: 'Taquilla', cedula: 'V-23203012', email: 'evanansemprun@gmail.com', password: '12345678', password_confirmation: '12345678')

User.create(name: 'Bob', username: 'BotBob', role: 'Taquilla', cedula: 'AUTO', email: 'bot@rifamax.com', password: '12345678', password_confirmation: '12345678')

Taquilla.create(name: 'La Maxima', owner_id: 1, users_ids: [1, 2])

Rifa.create(awardSign: 'Una moto', awardNoSign: '1000$', is_send: false, rifDate: Date.today, loteria: 'Zulia 7A', money: '$', price: 1.0, pin: nil, serial: SecureRandom.hex(6), verify: false, plate: 'AA2OD08', numbers: 203, year: 2020, taquillas_ids: [1], user_id: 1)

Draw.create(title: "Sorteo de una moto", first_prize: "Una moto bera", second_prize: "1000$", uniq: "89374ad", init_date: Date.today, numbers: 293, tickets_count: 3000, loteria: "Zulia 7A", has_winners: false, is_active: true, draw_type: "Progressive", limit: 100, price_unit: 1.0, money: "$", visible_taquillas_ids: [1], automatic_taquillas_ids: [1])
