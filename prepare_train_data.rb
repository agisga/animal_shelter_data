require 'daru'

shelter_data = Daru::DataFrame.from_csv 'animal_shelter_train.csv'

# get rid of some of the variables
shelter_data.delete_vectors *%W[AnimalID Name DateTime OutcomeSubtype]

# get rid of rows with missing values
shelter_data = shelter_data.filter_rows do
  |row| !row.has_missing_data?
end

puts "Are there any missing values left?"
puts shelter_data.has_missing_data?
shelter_data.vectors.to_a.each { |i| puts shelter_data[i].include? "" }

# transform AgeuponOutcome to a numeric variable
shelter_data['AgeuponOutcome'].map! do |age|
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
end

# define categorical variables
shelter_data.to_category 'OutcomeType', 'AnimalType', 'SexuponOutcome', 'Breed', 'Color'

# recode Breed
other_breed = shelter_data['Breed'].categories.select { |i| shelter_data['Breed'].count(i) < 100 }
other_breed_hash = other_breed.zip(['other']*other_breed.size).to_h
shelter_data['Breed'].rename_categories other_breed_hash
shelter_data['Breed'].base_category = 'other'
shelter_data['Breed'].frequencies

# recode Color
other_color = shelter_data['Color'].categories.select { |i| shelter_data['Color'].count(i) < 100 }
other_color_hash = other_color.zip(['other']*other_color.size).to_h
shelter_data['Color'].rename_categories other_color_hash
shelter_data['Color'].base_category = 'other'
shelter_data['Color'].frequencies

# save result
shelter_data.write_csv "animal_shelter_train_processed.csv"
