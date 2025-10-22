class RecommendationsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])

    # Update project status to processing
    @project.update(status: :processing)

    # Generate AI recommendation
    ai_service = AiRecommendationService.new(@project)
    ai_result = ai_service.generate_recommendation

    if ai_result[:error]
      @project.update(status: :failed)
      if request.xhr?
        head :unprocessable_entity
      else
        redirect_to @project, alert: "Failed to generate recommendation: #{ai_result[:error]}"
      end
      return
    end

    # Create recommendation and associated records
    timeline_data = ai_result["estimated_timeline"]
    timeline_display = timeline_data.is_a?(Hash) ? timeline_data["total_duration"] : timeline_data

    @recommendation = @project.build_recommendation(
      ai_response: ai_result.to_json,
      summary: ai_result["summary"],
      recommended_team_size: ai_result["recommended_team_size"],
      estimated_timeline: timeline_display
    )

    if @recommendation.save
      # Create technologies
      ai_result["technologies"]&.each do |tech|
        @recommendation.technologies.create(
          name: tech["name"],
          category: tech["category"],
          description: tech["description"],
          reason: tech["reason"]
        )
      end

      # Create team members
      ai_result["team_composition"]&.each do |member|
        @recommendation.team_members.create(
          role: member["role"],
          count: member["count"],
          skills: member["skills"],
          responsibilities: member["responsibilities"]
        )
      end

      @project.update(status: :completed)

      if request.xhr?
        head :ok
      else
        redirect_to @project, notice: "Recommendation successfully generated!"
      end
    else
      @project.update(status: :failed)
      if request.xhr?
        head :unprocessable_entity
      else
        redirect_to @project, alert: "Failed to save recommendation."
      end
    end
  rescue StandardError => e
    @project&.update(status: :failed)
    if request.xhr?
      head :internal_server_error
    else
      redirect_to @project, alert: "An error occurred: #{e.message}"
    end
  end
end
