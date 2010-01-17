class FoodController < Controller
  layout :secure
  helper :food_helper

  def index
    @user = session_user
    @foods = []
    @user.foods_created.each do |food|
      @foods << food
    end
  end

  def new
    @user = session_user
  end

  def create
    @user = session_user
    @food = food_from_request(request)
    if @food.save
      puts @food.inspect
      flash[:message] = "#{@food.name} has been created."
    else
      flash[:message] = "Problem: #{@food.errors.full_messages.first}"
    end
      redirect rs(:index)
  end

  def edit(id)
    @user = session_user
    @food = Food[id.to_i]
  end

  def update
    @user = session_user
    redirect rs(:index)
  end

  def delete(id)
    @user = session_user
    @food = Food[id.to_i]
    @user.remove_foods_created(@food)
    @user.remove_inventory(@food)
    @food.remove_all_scans
    @food.destroy
    flash[:message] = "#{@food.name} has been deleted."
    redirect rs(:index)
  end
end
