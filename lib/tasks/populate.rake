namespace :db do
  desc 'Erase and fill database'
  task :populate => :environment do
    if Rails.env.production?
      raise 'This task is not to be used in production!'
    end

    [Element, User].each(&:delete_all)
    User.create!({
      :email => 'b@b.com',
      :username => 'blah',
      :password => 'blah',
      :password_confirmation => 'blah',
    })

    10.times do
      User.create!({
        :email => Faker::Internet.email,
        :username => Faker::Internet.user_name,
        :password => 'pizza',
        :password_confirmation => 'pizza',
      })
    end
  end
end
