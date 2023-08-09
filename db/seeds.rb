User.create(name: 'Javier Diaz', username: 'Javier', role: 'Taquilla', cedula: 'V-29543140', email: 'javierdiazt406@gmail.com', password: '12345678', password_confirmation: '12345678')

User.create(name: 'Evanan Semprun', username: 'EvananSemprun', role: 'Taquilla', cedula: 'V-23203012', email: 'evanansemprun@gmail.com', password: '12345678', password_confirmation: '12345678')

User.create(name: 'Bob', username: 'BotBob', role: 'Taquilla', cedula: 'AUTO', email: 'bot@rifamax.com', password: '12345678', password_confirmation: '12345678')

# Taquilla.create(name: 'La Maxima', owner_id: 1, users_ids: [1, 2])

# Rifa.create(awardSign: 'Una moto', awardNoSign: '1000COP', is_send: false, rifDate: Time.now.in_time_zone("Caracas").to_date(), loteria: 'Zulia 7A', money: 'COP', price: 1.0, pin: nil, serial: SecureRandom.hex(6), verify: false, plate: 'AA2OD08', numbers: 203, year: 2020, taquillas_ids: [1], user_id: 1)

# Draw.create(title: "Sorteo de una moto", owner_id: 1, first_prize: "Una moto bera", second_prize: "1000COP", uniq: "89374ad", init_date: Time.now.in_time_zone("Caracas").to_date(), numbers: 293, tickets_count: 100, loteria: "Zulia 7A", has_winners: false, is_active: true, draw_type: "Progressive", limit: 100, price_unit: 1.0, money: "COP", visible_taquillas_ids: [1], automatic_taquillas_ids: [1])

# Draw.create(title: "Sorteo de un mercedes", owner_id: 1, first_prize: "Una moto mercedes", second_prize: "2500COP", uniq: "89374bc", init_date: Time.now.in_time_zone("Caracas").to_date(), numbers: 293, tickets_count: 1000, loteria: "Zulia 7A", has_winners: false, is_active: true, draw_type: "End-To-Date", limit: 100, price_unit: 25.0, money: "BsF", visible_taquillas_ids: [1], automatic_taquillas_ids: [1])

Exchange.create(variacion_bs: 28.01, variacion_cop: 4172.50, automatic: true)

Whitelist.create(user_id: 221, email: "rifamaxmaxima02@gmail.com", name: "Maxima02", role: "Taquilla")

# Whitelist.create(user_id: 2, email: "4bocasauto@gmail.com", name: "4 Bocas", role: "Auto")

# Client.create(name: "Javier Diaz", dni: "V-29543140", phone: "0412-1688466", email: "javierdiazt406@gmail.com")

Quadre.create(day: Date.today, total: 0, gastos: 0, agency_id: 221)

Denomination.create(money: "COP", power: 0.5, quantity: 0, category: 'CASH', ammount: nil, label: '1000 COP', quadre_id: 1)
Denomination.create(money: "COP", power: 1.0, quantity: 0, category: 'CASH', ammount: nil, label: '2000 COP', quadre_id: 1)
Denomination.create(money: "COP", power: 5.0, quantity: 0, category: 'CASH', ammount: nil, label: '5000 COP', quadre_id: 1)
Denomination.create(money: "COP", power: 10.0, quantity: 0, category: 'CASH', ammount: nil, label: '10.000 COP', quadre_id: 1)
Denomination.create(money: "COP", power: 20.0, quantity: 0, category: 'CASH', ammount: nil, label: '20.000 COP', quadre_id: 1)
Denomination.create(money: "COP", power: 50.0, quantity: 0, category: 'CASH', ammount: nil, label: '50.000 COP', quadre_id: 1)
Denomination.create(money: "COP", power: 100.0, quantity: 0, category: 'CASH', ammount: nil, label: '100.000 COP', quadre_id: 1)
Denomination.create(money: "COP", power: nil, quantity: nil, category: 'TRANSFER', ammount: 0.0, label: 'Transferencia', quadre_id: 1)
Denomination.create(money: "COP", power: nil, quantity: 0, category: 'TRANSFER', ammount: 0.0, label: 'Sencillo', quadre_id: 1)
Denomination.create(money: "COP", power: nil, quantity: 0, category: 'DEBT', ammount: 0.0, label: 'Gastos', quadre_id: 1)