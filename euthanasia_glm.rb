require 'daru'
require 'statsample-glm'

train_data = Daru::DataFrame.from_csv 'animal_shelter_train_processed.csv'

# define the 0-1-valued response variable
train_data.to_category 'OutcomeType'
train_data['Euthanasia'] = (train_data['OutcomeType'].contrast_code)['OutcomeType_Euthanasia']

# fit the model
formula = 'Euthanasia~AnimalType+Breed+AgeuponOutcome+Color+SexuponOutcome'
glm_euthanasia = Statsample::GLM::Regression.new formula, train_data, :logistic

# predict on test data
test_data = Daru::DataFrame.from_csv 'animal_shelter_train_processed.csv'
euthanasia_pred = glm_euthanasia.predict test_data 

# save the result
File.open('euthanasia_pred.txt', 'w') { |f| f.puts euthanasia_pred.to_a }
