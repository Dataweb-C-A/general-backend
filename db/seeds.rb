User.create(name: 'Javier Diaz', username: 'Javiersito', cedula: 'V-29543140', email: 'javierdiazt406@gmail.com', password: '12345678', password_confirmation: '12345678')

User.create(name: 'Evanan Semprun', username: 'EvananSemprun', cedula: 'V-23203012', email: 'evanansemprun@gmail.com', password: '12345678', password_confirmation: '12345678')

User.create(name: 'Bot Bob', username: 'BotBob', cedula: 'AUTO', email: 'bot@rifamax.com', password: '12345678', password_confirmation: '12345678')

Taquilla.create(name: 'La Maxima', apikey: 'API-AW98DAW8D7821930-ZA989WA', owner_id: 1, riferos_ids: [1, 2], taquillas_auto_ids: [3])
