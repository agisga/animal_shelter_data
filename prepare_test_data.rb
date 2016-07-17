require 'daru'

shelter_data = Daru::DataFrame.from_csv 'animal_shelter_test.csv'

# get rid of some of the variables
shelter_data.delete_vectors *%W[ID Name DateTime]

# transform AgeuponOutcome to a numeric variable
shelter_data['AgeuponOutcome'].map! do |age|
  unless age.nil?
    num, unit = age.split
    num = num.to_f
    case unit
    when "year", "years"
      52.0 * num
    when "month", "months"
      4.5 * num
    when "week", "weeks"
      num
    when "day", "days"
      num / 7.0
    else
      raise "Unknown AgeuponOutcome unit!"
    end  
  else
    nil 
  end
end

# impute missing age values
mean_age = shelter_data['AgeuponOutcome'].to_a.mean
shelter_data['AgeuponOutcome'].each_with_index do |age, ind|
  shelter_data['AgeuponOutcome'][ind] = mean_age if age.nil?
end

# save the result
shelter_data.write_csv "animal_shelter_test_processed.csv"
