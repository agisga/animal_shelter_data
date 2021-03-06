require 'daru'
require 'statsample-glm'

train_data = Daru::DataFrame.from_csv 'animal_shelter_train_processed.csv'

# define the 0-1-valued response variable
train_data.to_category 'OutcomeType'
train_data['Transfer'] = (train_data['OutcomeType'].contrast_code)['OutcomeType_Transfer']

# fit the model
formula = 'Transfer~AnimalType+Breed+AgeuponOutcome+Color+SexuponOutcome'
glm_transfer = Statsample::GLM::Regression.new formula, train_data, :logistic, epsilon: 1e-2

# predict on test data
test_data = Daru::DataFrame.from_csv 'animal_shelter_test_processed.csv'
transfer_pred = glm_transfer.predict test_data 

# save the result
File.open('transfer_pred.txt', 'w') { |f| f.puts transfer_pred.to_a }
