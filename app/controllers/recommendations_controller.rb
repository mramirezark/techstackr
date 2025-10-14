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
      redirect_to @project, alert: "Failed to generate recommendation: #{ai_result[:error]}"
      return
    end

    # Create recommendation and associated records
    @recommendation = @project.build_recommendation(
      ai_response: ai_result.to_json,
      summary: ai_result["summary"]
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
      redirect_to @project, notice: "Recommendation successfully generated!"
    else
      @project.update(status: :failed)
      redirect_to @project, alert: "Failed to save recommendation."
    end
  rescue StandardError => e
    @project&.update(status: :failed)
    redirect_to @project, alert: "An error occurred: #{e.message}"
  end
end
