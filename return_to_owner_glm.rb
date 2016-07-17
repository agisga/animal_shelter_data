require 'daru'
require 'statsample-glm'

train_data = Daru::DataFrame.from_csv 'animal_shelter_train_processed.csv'

# define the 0-1-valued response variable
train_data.to_category 'OutcomeType'
train_data['Return_to_owner'] = (train_data['OutcomeType'].contrast_code(full: true))['OutcomeType_Return_to_owner']

# fit the model
formula = 'Return_to_owner~AnimalType+Breed+AgeuponOutcome+Color+SexuponOutcome'
glm_return_to_owner = Statsample::GLM::Regression.new formula, train_data, :logistic, epsilon: 1e-2

# predict on test data
test_data = Daru::DataFrame.from_csv 'animal_shelter_train_processed.csv'
return_to_owner_pred = glm_return_to_owner.predict test_data 

# save the result
File.open('return_to_owner_pred.txt', 'w') { |f| f.puts return_to_owner_pred.to_a }
