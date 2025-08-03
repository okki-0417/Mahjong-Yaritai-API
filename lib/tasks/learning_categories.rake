namespace :learning_categories do
  task create: :environment do
    yaml_file = Rails.root.join("db", "seeds", "learning_categories.yml")

    unless File.exist?(yaml_file)
      puts "Error: YAML file not found at #{yaml_file}"
      exit 1
    end

    begin
      data = YAML.load_file(yaml_file)
      categories = data["learning_categories"]

      if categories.nil? || categories.empty?
        puts "Error: No learning categories found in YAML file"
        exit 1
      end

      # Delete all existing categories first
      existing_count = LearningCategory.count
      if existing_count > 0
        puts "Deleting #{existing_count} existing categories..."
        LearningCategory.destroy_all
        puts "All existing categories deleted."
      end

      created_count = 0
      failed_count = 0

      categories.each do |category_data|
        category = LearningCategory.new(
          name: category_data["name"],
          description: category_data["description"]
        )

        if category.save
          puts "✓ Created category: #{category.name}"
          created_count += 1
        else
          puts "✗ Failed to create category: #{category.name}"
          puts "  Errors: #{category.errors.full_messages.join(', ')}"
          failed_count += 1
        end
      end

      puts "\nSummary:"
      puts "  Deleted: #{existing_count} old categories"
      puts "  Created: #{created_count} new categories"
      puts "  Failed: #{failed_count} categories"
      puts "  Total categories in database: #{LearningCategory.count}"

    rescue StandardError => e
      puts "Error loading YAML file: #{e.message}"
      exit 1
    end
  end
end
