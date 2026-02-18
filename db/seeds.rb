50.times do |i|
    Task.create!(
      title: "タスク #{i+1}",
      content: "これはテストタスク#{i+1}の詳細です。",
      created_at: rand(1..30).days.ago
    )
  end
  
  puts "Created 50 tasks!"