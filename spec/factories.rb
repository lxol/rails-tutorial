FactoryGirl.define do
  factory :user do
    name "Alex Olkhovskiy"
    email "alex+gravatar@olkhovskiy.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
