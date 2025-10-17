class AiRecommendationService
  def initialize(project)
    @project = project
    @api_key = ENV.fetch("GEMINI_API_KEY", "")
  end

  def generate_recommendation
    return { error: "Google Gemini API key not configured. Get free key at https://makersuite.google.com/app/apikey" } if @api_key.blank?

    prompt = build_prompt

    begin
      client = Gemini.new(
        credentials: {
          service: "generative-language-api",
          api_key: @api_key
        },
        options: { model: "gemini-2.5-flash" }
      )

      result = client.generate_content({
        contents: { role: "user", parts: { text: prompt } }
      })

      # Extract the response text
      full_response = result.dig("candidates", 0, "content", "parts", 0, "text") || ""

      parse_ai_response(full_response)
    rescue StandardError => e
      { error: "AI service error: #{e.message}" }
    end
  end

  private

  def build_prompt
    <<~PROMPT
      You are a technical consultant specializing in technology stack recommendations and team composition.

      Based on the following project information, provide detailed technology stack recommendations and team composition.

      Project Details:
      - Title: #{@project.title}
      - Project Type: #{@project.project_type}
      - Industry: #{@project.industry}
      - Estimated Team Size: #{@project.estimated_team_size} people
      - Description: #{@project.description}

      IMPORTANT: Respond ONLY with valid JSON in exactly this format (no markdown, no code blocks, just raw JSON):
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

      Remember: Return ONLY the JSON object, no other text.
    PROMPT
  end

  def parse_ai_response(response)
    content = response.to_s.strip

    return { error: "No response from AI" } unless content.present?

    # Remove markdown code blocks if present (```json ... ```)
    content = content.gsub(/```json\s*/, "").gsub(/```\s*$/, "").strip

    # Extract JSON from the response
    json_match = content.match(/\{.*\}/m)

    if json_match
      JSON.parse(json_match[0])
    else
      # If no JSON found, return error with raw response for debugging
      { error: "No JSON found in response", raw_response: content[0..500] }
    end
  rescue JSON::ParserError => e
    { error: "Failed to parse AI response: #{e.message}", raw_response: content[0..500] }
  end
end
