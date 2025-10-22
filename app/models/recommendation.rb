class Recommendation < ApplicationRecord
  belongs_to :project
  has_many :technologies, dependent: :destroy
  has_many :team_members, dependent: :destroy

  validates :ai_response, presence: true

  def timeline_breakdown
    return nil unless ai_response.present?

    begin
      response_data = JSON.parse(ai_response)
      timeline_data = response_data["estimated_timeline"]

      if timeline_data.is_a?(Hash)
        timeline_data["breakdown"]
      else
        nil
      end
    rescue JSON::ParserError
      nil
    end
  end

  def complexity_analysis
    return nil unless ai_response.present?

    begin
      response_data = JSON.parse(ai_response)
      timeline_data = response_data["estimated_timeline"]

      if timeline_data.is_a?(Hash)
        timeline_data["complexity_analysis"]
      else
        nil
      end
    rescue JSON::ParserError
      nil
    end
  end

  def risk_factors
    return nil unless ai_response.present?

    begin
      response_data = JSON.parse(ai_response)
      timeline_data = response_data["estimated_timeline"]

      if timeline_data.is_a?(Hash)
        timeline_data["risk_factors"]
      else
        nil
      end
    rescue JSON::ParserError
      nil
    end
  end
end
