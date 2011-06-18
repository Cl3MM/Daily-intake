class Meal < ActiveRecord::Base
  has_many :amounts, :dependent => :destroy
  has_many :ingredients, :through => :amounts

  def update_amount (ingredient, amountVal)
    amount = amounts.find_by_ingredient_id(ingredient.id)
    amount.ingredientAmount = amountVal
    amount.save
  end

  def find_or_create_by_ingredient (ingredient, amountVal)
    amountVal = ( ["", nil].include?(amountVal) ? 0 : amountVal )
    ingredients << ingredient unless ingredients.include? ingredient
    update_amount(ingredient, amountVal)
  end

  def self.totalDailyDetailsOn (date)
    ar = joins(:ingredients).
    where("date = ?", date)
    .select( "sum(amounts.ingredientAmount*ingredients.protein/100) as totalDailyProtein, sum(amounts.ingredientAmount*ingredients.carbs/100) as totalDailyCarbs, sum(amounts.ingredientAmount*ingredients.fat/100) as totalDailyFat ").
    map{ |x| [x.totalDailyProtein, x.totalDailyCarbs, x.totalDailyFat] }.
    flatten
    
    a = [ "totalDailyProtein", "totalDailyCarbs", "totalDailyFat" ]
    arr_to_hash ar, a
  end

  def self.totalDailyCalOn (date)
    joins(:ingredients).
    where("date = ?", date).
    sum("(ingredients.protein*4+ingredients.carbs*4+ingredients.fat*9)*amounts.ingredientAmount/100")
  end

  def self.totalDetail (meal)
    ar = joins(:ingredients).
    where("meals.id = ?", meal.id).
    select("sum(ingredients.protein) as totalProtein, sum(ingredients.carbs) as totalCarbs, sum(ingredients.fat) as totalFat").
    map{ |x| [x.totalDailyProtein, x.totalDailyCarbs, x.totalDailyFat] }.
    flatten
    
    a = [ "totalProtein", "totalCarbs", "totalFat" ]
    arr_to_hash ar, a
  end


  def totalCal
    cal, total = 0, 0
    ingredients.each do |ing|
      cal = ing.protein * 4 + ing.carbs * 4 + ing.fat * 9
      total += cal * amounts.find_by_ingredient_id(ing.id).ingredientAmount
    end
    return total/100
  end

  def totalCarbs
    cal, total = 0, 0
    ingredients.each do |ing|
    #  cal = ing.protein * 4 + ing.carbs * 4 + ing.fat * 9
      total += ing.carbs * amounts.find_by_ingredient_id(ing.id).ingredientAmount
    end
    return total/100

  end
  def totalProtein
    cal, total = 0, 0
    ingredients.each do |ing|
    #  cal = ing.protein * 4 + ing.carbs * 4 + ing.fat * 9
      total += ing.protein * amounts.find_by_ingredient_id(ing.id).ingredientAmount
    end
    return total/100

  end
  def totalFat
    cal, total = 0, 0
    ingredients.each do |ing|
    #  cal = ing.protein * 4 + ing.carbs * 4 + ing.fat * 9
      total += ing.fat * amounts.find_by_ingredient_id(ing.id).ingredientAmount
    end
    return total/100

  end

  scope :meals_at, lambda { |date| where("date = ?", date) }


  def self.arr_to_hash (array, keys)
    h = {}
    array = [0,0,0] unless array.size == keys.size
    # transform query array result into hash
    keys.each.with_index { |x, i| h[x] = array[i]}
    return h
  end

end
