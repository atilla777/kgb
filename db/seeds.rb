# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
organization = Organization.create(name: 'KGB')
user = User.create(name: 'Admin',
            email: 'kgb@ussr.su',
            password: 'smersh',
            password_confirmation: 'smersh',
            organization_id: organization.id,
            active: true)
user.add_role(:admin)
