class StatusController < ApplicationController
  def show
    render json: { status: "ok", time: Time.current }
  end
end
