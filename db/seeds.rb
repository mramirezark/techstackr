# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "🌱 Seeding database..."
puts ""

# Create default admin user
admin = User.find_or_create_by!(username: "admin") do |user|
  user.password = "admin123"
  user.password_confirmation = "admin123"
  user.role = :admin
end

puts "✅ Admin user created/verified:"
puts "   Username: admin"
puts "   Password: admin123"
puts "   Role: #{admin.role}"
puts ""

# Create a demo regular user
demo_user = User.find_or_create_by!(username: "demo") do |user|
  user.password = "demo123"
  user.password_confirmation = "demo123"
  user.role = :user
end

puts "✅ Demo user created/verified:"
puts "   Username: demo"
puts "   Password: demo123"
puts "   Role: #{demo_user.role}"
puts ""

# Sample projects for admin user
sample_projects_admin = [
  {
    title: "Healthcare Patient Portal",
    description: "A HIPAA-compliant web application for patients to book appointments, view medical records, and securely message with healthcare providers. The system needs to integrate with existing EHR systems via HL7/FHIR APIs, support role-based access control for patients, doctors, and administrators, and handle approximately 10,000 active users with real-time appointment availability updates.",
    project_type: "web_application",
    industry: "Healthcare"
  },
  {
    title: "E-commerce Marketplace Platform",
    description: "A multi-vendor marketplace connecting buyers and sellers with integrated payment processing, inventory management, order tracking, and seller analytics dashboard. Features include product search with filters, shopping cart, secure checkout with multiple payment options, review system, and automated email notifications. Expected to handle 50,000 daily active users with peak traffic during sales events.",
    project_type: "web_application",
    industry: "E-commerce"
  },
  {
    title: "FinTech Investment Portfolio Tracker",
    description: "A mobile application for iOS and Android that allows users to track their investment portfolios across multiple accounts and asset classes. Features include real-time stock quotes, portfolio performance analytics, risk assessment, tax optimization suggestions, and secure authentication with biometric support. Must comply with financial regulations and handle sensitive financial data with encryption.",
    project_type: "mobile_application",
    industry: "Finance"
  },
  {
    title: "Bridging Agent",
    description: "AI Agents system that will run the bridging process for a software development company.
It should have agents that do all of the following:
Get a Lead’s information from Zoho, including documentation and introduction call.
Use the Lead’s information to generate a proposed team composition, taking into account our available talent pool, which is saved on a database.
Use the Lead’s information to generate a proposal, using the company’s standards for team composition and processes.",
    project_type: "api_backend",
    industry: "Technology"
  }
]

sample_projects_demo = [
  {
    title: "Online Learning Management System",
    description: "A comprehensive LMS for educational institutions with features for course creation, student enrollment, assignment submission, grading, video lectures, discussion forums, and progress tracking. Needs to support 5,000 concurrent users during peak hours, integrate with video conferencing tools, and provide accessibility features for students with disabilities.",
    project_type: "web_application",
    industry: "Education"
  },
  {
    title: "Restaurant Reservation & POS System",
    description: "An integrated system combining table reservations, point-of-sale, inventory management, and customer loyalty programs for restaurant chains. Features include real-time table availability, waitlist management, order processing, kitchen display system, payment processing, and analytics for business insights. Needs offline capability for POS terminals.",
    project_type: "web_application",
    industry: "Travel & Hospitality"
  },
  {
    title: "Real Estate Property Management Platform",
    description: "A web platform for property managers to handle tenant applications, lease agreements, rent collection, maintenance requests, and property listings. Includes tenant portal, automated rent reminders, document management, financial reporting, and integration with payment gateways. Expected to manage 1,000+ properties with 5,000+ active tenants.",
    project_type: "web_application",
    industry: "Real Estate"
  },
  {
    title: "IoT Manufacturing Monitoring System",
    description: "A real-time monitoring system for manufacturing facilities with IoT sensor integration, predictive maintenance alerts, production analytics, and quality control tracking. Backend service processes sensor data from 500+ devices, detects anomalies using machine learning, and provides REST API for dashboard integrations. Requires high availability and low latency.",
    project_type: "api_backend",
    industry: "Manufacturing"
  },
  {
    title: "Content Streaming Platform",
    description: "A Netflix-like streaming service for independent content creators with video upload, transcoding, adaptive bitrate streaming, user subscriptions, content recommendations, and creator analytics. Needs CDN integration, DRM for content protection, and support for 100,000+ concurrent streams. Mobile apps for iOS and Android with offline viewing capability.",
    project_type: "web_application",
    industry: "Entertainment"
  }
]

puts "📋 Creating sample projects..."
puts ""

# Create projects for admin
sample_projects_admin.each do |project_data|
  project = admin.projects.find_or_create_by!(title: project_data[:title]) do |p|
    p.description = project_data[:description]
    p.project_type = project_data[:project_type]
    p.industry = project_data[:industry]
    p.estimated_team_size = project_data[:estimated_team_size]
  end
  puts "✅ Created: #{project.title} (#{project.industry})"
end

puts ""

# Create projects for demo user
sample_projects_demo.each do |project_data|
  project = demo_user.projects.find_or_create_by!(title: project_data[:title]) do |p|
    p.description = project_data[:description]
    p.project_type = project_data[:project_type]
    p.industry = project_data[:industry]
    p.estimated_team_size = project_data[:estimated_team_size]
  end
  puts "✅ Created: #{project.title} (#{project.industry})"
end

puts ""
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "🎉 Seeding complete!"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts ""
puts "📊 Summary:"
puts "   Users: #{User.count} (#{User.where(role: :admin).count} admin, #{User.where(role: :user).count} regular)"
puts "   Projects: #{Project.count} total"
puts "   - Admin projects: #{admin.projects.count}"
puts "   - Demo user projects: #{demo_user.projects.count}"
puts ""
puts "🔑 Login credentials:"
puts "   Admin:  username: admin, password: admin123"
puts "   Demo:   username: demo,  password: demo123"
puts ""
puts "⚠️  IMPORTANT: Change passwords in production!"
puts ""
