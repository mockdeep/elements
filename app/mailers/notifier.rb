class Notifier < ActionMailer::Base
  default :from => 'lobati.fricha@gmail.com'

  def signup_email(user)
    mail({
      :to => user.email,
      :subject => 'Thanks for signing up'
    })
  end
end
