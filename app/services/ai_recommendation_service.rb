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

      Based on the following project information, provide detailed technology stack recommendations and optimal team composition.

      Project Details:
      - Title: #{@project.title}
      - Project Type: #{@project.project_type}
      - Industry: #{@project.industry}
      - Description: #{@project.description}

      IMPORTANT: Respond ONLY with valid JSON in exactly this format (no markdown, no code blocks, just raw JSON):
      {
        "summary": "Brief overview of recommendations tailored to the #{@project.industry} industry",
        "recommended_team_size": [ANALYZE_PROJECT_AND_DETERMINE_OPTIMAL_TEAM_SIZE],
        "estimated_timeline": {
          "total_duration": "[OVERALL_PROJECT_TIMELINE]",
          "breakdown": {
            "planning_requirements": "[TIMELINE_FOR_PLANNING_PHASE]",
            "design_prototyping": "[TIMELINE_FOR_DESIGN_PHASE]",#{' '}
            "development": "[TIMELINE_FOR_DEVELOPMENT_PHASE]",
            "testing_qa": "[TIMELINE_FOR_TESTING_PHASE]",
            "deployment_launch": "[TIMELINE_FOR_DEPLOYMENT_PHASE]"
          },
          "complexity_analysis": "[BRIEF_ANALYSIS_OF_PROJECT_COMPLEXITY_FACTORS]",
          "risk_factors": "[IDENTIFIED_RISK_FACTORS_THAT_COULD_AFFECT_TIMELINE]"
        },
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
            "count": [NUMBER_OF_PEOPLE_FOR_THIS_ROLE],
            "skills": "Required skills",
            "responsibilities": "Key responsibilities"
          }
        ],
        "additional_notes": "Any additional recommendations or considerations"
      }

      CRITICAL INSTRUCTIONS FOR DYNAMIC ANALYSIS:

      1. TEAM SIZE ANALYSIS:
         - Read the project description carefully
         - Consider the scope, complexity, and requirements
         - For simple projects (basic websites, simple apps): 1-3 people
         - For medium projects (e-commerce, complex web apps): 4-8 people#{'  '}
         - For large projects (enterprise systems, complex platforms): 9-20+ people
         - Base your recommendation on ACTUAL project needs, not examples

      2. TIMELINE ESTIMATION:
         Analyze project complexity and provide detailed timeline breakdown:
      #{'   '}
         COMPLEXITY FACTORS TO CONSIDER:
         - Number of features and functionalities
         - Integration requirements (APIs, third-party services)
         - User authentication and authorization complexity
         - Database design and data relationships
         - Frontend complexity (simple UI vs complex dashboards)
         - Mobile app requirements (iOS, Android, or both)
         - Real-time features (websockets, live updates)
         - Payment processing and e-commerce features
         - Security requirements and compliance needs
         - Scalability and performance requirements
      #{'   '}
         DEVELOPMENT PHASES TO INCLUDE:
         - Planning and requirements gathering (3-8% of timeline)
         - UI/UX design and prototyping (5-12% of timeline)
         - Backend development (35-50% of timeline)
         - Frontend development (25-40% of timeline)
         - Integration and API development (8-15% of timeline)
         - Testing (unit, integration, user acceptance) (12-20% of timeline)
         - Deployment and DevOps setup (3-8% of timeline)
         - Bug fixes and refinements (8-12% of timeline)
      #{'   '}
         TIMELINE GUIDELINES:
         - Simple projects (basic websites, landing pages): 2-6 weeks
         - Small projects (basic web apps, simple mobile apps): 1-2 months
         - Medium projects (e-commerce sites, business applications): 2-4 months
         - Complex projects (multi-platform apps, enterprise systems): 4-8 months
         - Large projects (complex platforms, enterprise solutions): 6-12 months
         - Enterprise projects (large-scale systems, complex integrations): 8-18 months
      #{'   '}
         CONSIDER THESE ADDITIONAL FACTORS:
         - Team experience level (junior vs senior developers)
         - Technology stack familiarity
         - Client feedback and iteration cycles
         - Regulatory compliance requirements
         - Internationalization and localization needs
         - Performance optimization requirements
         - Maintenance and support considerations
      #{'   '}
         EFFICIENCY GUIDELINES FOR PLANNING & DESIGN:
         - Planning should be lean and focused (not over-engineered)
         - Use proven design patterns and existing UI frameworks to reduce design time
         - Prioritize MVP features first, iterate later
         - Leverage existing design systems and component libraries
         - Focus on user stories and core functionality, not extensive documentation
         - Use rapid prototyping tools and templates when possible
         - Consider agile methodologies that overlap phases for efficiency
      #{'   '}
         Provide a realistic timeline based on ACTUAL project scope and complexity analysis.

      3. TEAM COMPOSITION:
         - Create roles based on the specific project needs
         - Ensure role counts add up to your recommended_team_size
         - Include appropriate roles for the project type and complexity

      4. TECHNOLOGY STACK:
         - Recommend technologies that match the project requirements
         - Consider the #{@project.industry} industry standards
         - Choose appropriate tools for the #{@project.project_type} project type

      Remember: Analyze the ACTUAL project description and provide DYNAMIC recommendations based on real project needs, not example values.

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
