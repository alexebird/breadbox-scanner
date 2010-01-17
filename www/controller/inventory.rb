class InventoryController < Controller
  layout :secure

  def index
    @user = session_user
  end
end
