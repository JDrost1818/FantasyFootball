class UserMailer < ActionMailer::Base
  default from: "no-reply@gmail.com"

  def welcome_email user
    @user = user
    mail(to: @user.email, subject: 'Welcome to my Awesome Site', mail: "This is the first email you will ever receive from us")
  end

  def weekly_email team
  	# This would be better if there was only one email
  	# per user, but in this application of Fantasy Football
  	# each league can end at different times, so it's dependent
  	# on the team. Sorry 'bout it
  	@team = team
  	@user = team.user
  	@game = @team.get_current_game
  	@is_email = true
  	mail(to: @user.email, subject: 'Your Weekly Fantasy Update')
  end
end
