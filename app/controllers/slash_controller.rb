class SlashController < ApplicationController

  def index
    HitCounter.hit!
    render json: {"Hello" => "World (with a database)", "Hit Count" => HitCounter.hits}
  end
end
