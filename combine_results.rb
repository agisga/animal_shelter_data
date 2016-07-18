# combine results to the submission format required by kaggle:
# https://www.kaggle.com/c/shelter-animal-outcomes/details/evaluation

adoption_pred = IO.readlines("adoption_pred.txt").map { |i| i.to_f }
died_pred = IO.readlines("died_pred.txt").map { |i| i.to_f }
euthanasia_pred = IO.readlines("euthanasia_pred.txt").map { |i| i.to_f }
transfer_pred = IO.readlines("transfer_pred.txt").map { |i| i.to_f }
return_to_owner_pred = IO.readlines("return_to_owner_pred.txt").map { |i| i.to_f }

require 'daru'
shelter_data = Daru::DataFrame.from_csv 'animal_shelter_test.csv'
glm_results = Daru::DataFrame.new({ID: shelter_data['ID'].to_a,
                                   Adoption: adoption_pred,
                                   Died: died_pred,
                                   Euthanasia: euthanasia_pred,
                                   Return_to_owner: return_to_owner_pred,
                                   Transfer: transfer_pred},
                                 order: [:ID, :Adoption, :Died,
                                         :Euthanasia, :Return_to_owner,
                                         :Transfer])

glm_results.write_csv "combined_pred.csv"
