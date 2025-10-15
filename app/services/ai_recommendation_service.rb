class AiRecommendationService
  def initialize(project)
    @project = project
    @client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY", ""))
  end

  def generate_recommendation
    return { error: "OpenAI API key not configured" } if ENV["OPENAI_API_KEY"].blank?

    prompt = build_prompt

    begin
      response = @client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            {
              role: "system",
              content: "You are a technical consultant specializing in technology stack recommendations and team composition. Provide detailed, practical recommendations in JSON format."
            },
            {
              role: "user",
              content: prompt
            }
          ],
          response_format: { type: "json_object" },
          temperature: 0.7
        }
      )

      parse_ai_response(response)
    rescue StandardError => e
      { error: "AI service error: #{e.message}" }
    end
  end

  private

  def build_prompt
    <<~PROMPT
      Based on the following project information, provide technology stack recommendations and team composition:

      Project Title: #{@project.title}
      Project Type: #{@project.project_type}
      Industry: #{@project.industry}
      Estimated Team Size: #{@project.estimated_team_size} people
      Description: #{@project.description}

      Please provide your response in the following JSON format:
      {
        "summary": "Brief overview of recommendations tailored to the #{@project.industry} industry",
        "technologies": [
          {
            "name": "Technology name",
            "category": "Category (e.g., Frontend, Backend, Database, DevOps, Testing)",
            "description": "Brief description",
            "reason": "Why this technology is recommended for this #{@project.industry} project"
          }
        ],
        "team_composition": [
          {
            "role": "Role title (e.g., Frontend Developer, Backend Developer)",
            "count": 2,
            "skills": "Required skills",
            "responsibilities": "Key responsibilities"
          }
        ],
        "additional_notes": "Any additional recommendations or considerations"
      }

      Focus on modern, industry-standard technologies appropriate for:
      - The #{@project.industry} industry
      - A team of #{@project.estimated_team_size} people
      - The #{@project.project_type} project type

      Ensure the team composition aligns with the estimated team size of #{@project.estimated_team_size}.
    PROMPT
  end

  def parse_ai_response(response)
    content = response.dig("choices", 0, "message", "content")
    return { error: "No response from AI" } unless content

    JSON.parse(content)
  rescue JSON::ParserError => e
    { error: "Failed to parse AI response: #{e.message}", raw_response: content }
  end
end
