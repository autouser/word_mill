WordMill::Application.routes.draw do

  post "/frequent_words" => "frequent_words#execute"

end
