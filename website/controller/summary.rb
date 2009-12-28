class UserSummaryController < Controller
  map '/summary'

  def index(usr)
    user = User[usr]
    @foods = user.foods
    @user_summary = "#{user.name} - #{user.email}"
  end
end
