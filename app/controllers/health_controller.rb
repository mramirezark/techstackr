class HealthController < ApplicationController
  def show
    # Check database connection
    ActiveRecord::Base.connection.execute("SELECT 1")

    render json: { status: "ok", timestamp: Time.current }, status: :ok
  rescue StandardError => e
    render json: { status: "error", error: e.message }, status: :service_unavailable
  end
end
