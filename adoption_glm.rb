require 'daru'
require 'statsample-glm'

train_data = Daru::DataFrame.from_csv 'animal_shelter_train_processed.csv'

# define the 0-1-valued response variable
train_data.to_category 'OutcomeType'
train_data['Adoption'] = (train_data['OutcomeType'].contrast_code)['OutcomeType_Adoption']

# fit the model
formula = 'Adoption~AnimalType+Breed+AgeuponOutcome+Color+SexuponOutcome'
glm_adoption = Statsample::GLM::Regression.new formula, train_data, :logistic, epsilon: 1e-2

# predict on test data
test_data = Daru::DataFrame.from_csv 'animal_shelter_test_processed.csv'
adoption_pred = glm_adoption.predict test_data 

# save the result
File.open('adoption_pred.txt', 'w') { |f| f.puts adoption_pred.to_a }
