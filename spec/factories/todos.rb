FactoryGirl.define do
  factory :todo_1 do
    title "To-do number 1"
    completed true
  end
  factory :todo_2 do
    title "To-do number 2"
    completed false
  end
end
