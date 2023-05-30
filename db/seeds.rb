User.create(name: 'Javier Diaz', username: 'Javier', role: 'Taquilla', cedula: 'V-29543140', email: 'javierdiazt406@gmail.com', password: '12345678', password_confirmation: '12345678')

User.create(name: 'Evanan Semprun', username: 'EvananSemprun', role: 'Taquilla', cedula: 'V-23203012', email: 'evanansemprun@gmail.com', password: '12345678', password_confirmation: '12345678')

User.create(name: 'Bob', username: 'BotBob', role: 'Taquilla', cedula: 'AUTO', email: 'bot@rifamax.com', password: '12345678', password_confirmation: '12345678')

Taquilla.create(name: 'La Maxima', owner_id: 1, users_ids: [1, 2])

Rifa.create(awardSign: 'Una moto', awardNoSign: '1000$', is_send: false, rifDate: Time.now.in_time_zone("Caracas").to_date(), loteria: 'Zulia 7A', money: '$', price: 1.0, pin: nil, serial: SecureRandom.hex(6), verify: false, plate: 'AA2OD08', numbers: 203, year: 2020, taquillas_ids: [1], user_id: 1)

Draw.create(title: "Sorteo de una moto", owner_id: 1, first_prize: "Una moto bera", second_prize: "1000$", uniq: "89374ad", init_date: Time.now.in_time_zone("Caracas").to_date(), numbers: 293, tickets_count: 3000, loteria: "Zulia 7A", has_winners: false, is_active: true, draw_type: "Progressive", limit: 100, price_unit: 1.0, money: "$", visible_taquillas_ids: [1], automatic_taquillas_ids: [1])

Draw.create(title: "Sorteo de un mercedes", owner_id: 1, first_prize: "Una moto mercedes", second_prize: "2500$", uniq: "89374bc", init_date: Time.now.in_time_zone("Caracas").to_date(), numbers: 293, tickets_count: 3000, loteria: "Zulia 7A", has_winners: false, is_active: true, draw_type: "End-To-Date", limit: 100, price_unit: 25.0, money: "BsF", visible_taquillas_ids: [1], automatic_taquillas_ids: [1])

Exchange.create(money: "USD", value: 25.47, day: Time.now.in_time_zone("Caracas").to_date())

Whitelist.create(user_id: 1, email: "rifamax4bocas@gmail.com", name: "4 Bocas", role: "Taquilla")

Client.create(name: "Javier Diaz", dni: "V-29543140", phone: "0412-1688466", email: "javierdiazt406@gmail.com")