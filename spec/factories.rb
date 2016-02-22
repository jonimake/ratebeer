FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :anotheruser, class: User do
    username "Pätkä"
    password "Salasana1"
    password_confirmation "Salasana1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :brewery do
    sequence(:name) { |n| "brewery#{n}" }
    year 1900
  end

  factory :beer_club do
    name "viikin kaljaseura"
    founded 2016
    city "Helsinki"
  end

  factory :style do
    name "anon style"
    description "anon style desc"
  end

  factory :beer do
    name "anonymous"
    brewery
  end


end