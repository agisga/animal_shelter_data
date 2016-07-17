require 'daru'
require 'statsample-glm'

train_data = Daru::DataFrame.from_csv 'animal_shelter_train_processed.csv'

# define the 0-1-valued response variable
train_data.to_category 'OutcomeType'
train_data['Died'] = (train_data['OutcomeType'].contrast_code)['OutcomeType_Died']

# fit the model
formula = 'Died~AnimalType+Breed+AgeuponOutcome+Color+SexuponOutcome'
glm_died = Statsample::GLM::Regression.new formula, train_data, :logistic, epsilon: 1e-2

# predict on test data
test_data = Daru::DataFrame.from_csv 'animal_shelter_test_processed.csv'
died_pred = glm_died.predict test_data 

# save the result
File.open('died_pred.txt', 'w') { |f| f.puts died_pred.to_a }
