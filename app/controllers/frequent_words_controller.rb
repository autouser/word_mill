class FrequentWordsController < ApplicationController

  def execute
    @result = FrequentWords.new(text: params[:text])
    if @result.execute
      render json: @result
    else
      render json: @result, :status => :unprocessable_entity
    end
  end

end
