# Rifamax General Backend

<p align="center">
  <img src="https://rifa-max.com/logo-rifamax.png" />
</p>

Welcome to Rifamax, a raffle system designed for managing all modules of raffles and Dataweb Systems. This system is coded on [Ruby on Rails](https://rubyonrails.org/) with [PostgreSQL](https://www.postgresql.org/), [Sidekiq](https://sidekiq.org/) and [Redis](https://redis.io/).

<p align="center">
  <img src="https://i.imgur.com/d4dhkty.png" style="width: 80%;">
</p>  

## Features
Rifamax comes with the following features:

1. Ability to create, edit, and delete raffles
2. Option to specify start and end dates for each raffle
3. Multiple prizes and winners for each raffle
4. Automatic selection of winners at the end of each raffle
5. Email notifications to winners
6. Admin dashboard for managing raffles and winners
7. Integration with Redis for caching and background jobs

## Installation
To install Rifamax on your local machine, follow these steps:

1. Clone the repository using:
```bash
git clone https://github.com/Dataweb-C-A/general-backend
```

2. Navigate to the project directory using:
```bash
cd general-backend
```

3. Install dependencies using:
```bash
bundler
```

4. Regenerate credentials
```bash
rails credentials:edit
```

5. Create the database using:
```bash
rails db:create
```

6. Run migrations using:
```bash
rails db:create
```

7. Start the server using:
```bash
rails server
```

## Setup
Once you have Rifamax installed, you can use it to manage your raffles by following these steps:

1. Create an Admin User through rails console

2. Create a Taquilla User with it's relation

3. Create Riferos Users and add it to Taquilla

4. Create Raffles with Taquilla and Riferos

5. Enjoy your raffles and if you want to see DB with and interactive interface use [Rails Admin Gem](https://github.com/railsadminteam/rails_admin)

## Contributing
If you would like to contribute to Rifamax, please follow these steps:

1. Fork the repository

2. Create a new branch for your changes using git checkout -b feature/your-feature-name

3. Make your changes and commit them using git commit -m "Your commit message"

4. Push your changes to your fork using git push origin feature/your-feature-name

5. Create a pull request to merge your changes into the main branch of the repository

6. Rifamax is licensed under the MIT License. See the LICENSE file for more information.
