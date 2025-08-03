# frozen_string_literal: true

namespace :learning_questions do
  task create_all: :environment do
    dir_path = Rails.root.join("db", "seeds", "learning_questions")

    unless Dir.exist?(dir_path)
      puts "Error: Directory not found at #{dir_path}"
      exit 1
    end

    yaml_files = Dir.glob("#{dir_path}/*.yml")

    if yaml_files.empty?
      puts "No YAML files found in #{dir_path}"
      exit 1
    end

    # Delete all existing questions first
    existing_count = LearningQuestion.count
    if existing_count > 0
      puts "Deleting #{existing_count} existing questions..."
      LearningQuestion.destroy_all
      puts "All existing questions deleted."
    end

    puts "\nFound #{yaml_files.count} YAML files to process"

    total_created = 0
    total_failed = 0

    yaml_files.each do |file|
      puts "\n" + "=" * 50
      puts "Processing: #{File.basename(file)}"

      begin
        data = YAML.load_file(file)
        questions_data = data["learning_questions"]

        if questions_data.nil? || questions_data.empty?
          puts "  Warning: No learning questions found in #{File.basename(file)}"
          next
        end

        questions_data.each do |category_questions|
          category_name = category_questions["category_name"]
          questions = category_questions["questions"]

          category = LearningCategory.find_by(name: category_name)

          if category.nil?
            puts "  Error: Category '#{category_name}' not found"
            puts "    Please create the category first using: rails learning_categories:create"
            total_failed += questions.count
            next
          end

          puts "\n  Processing category: #{category_name}"
          puts "  " + "-" * 48

          questions.each do |question_data|
            question = LearningQuestion.new(
              category: category,
              statement: question_data["statement"],
              answer: question_data["answer"]
            )

            if question.save
              puts "    ✓ #{question.statement[0..50]}..."
              total_created += 1
            else
              puts "    ✗ Failed: #{question.statement[0..50]}..."
              puts "      Errors: #{question.errors.full_messages.join(', ')}"
              total_failed += 1
            end
          end
        end
      rescue StandardError => e
        puts "  Error loading #{File.basename(file)}: #{e.message}"
      end
    end

    puts "\n" + "=" * 50
    puts "Final Summary:"
    puts "  Deleted: #{existing_count} old questions"
    puts "  Created: #{total_created} new questions"
    puts "  Failed: #{total_failed} questions"
    puts "  Total questions in database: #{LearningQuestion.count}"
  end
end
