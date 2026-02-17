require 'rails_helper'

RSpec.describe 'List display function', type: :system do
  # Immediate creation of test data with let!
  let!(:oldest_task) do
    FactoryBot.create(:task,
                      title: 'third_task',
                      content: 'Oldest content',
                      created_at: Date.new(2022, 2, 16))
  end

  let!(:middle_task) do
    FactoryBot.create(:task,
                      title: 'second_task',
                      content: 'Middle content',
                      created_at: Date.new(2022, 2, 17))
  end

  let!(:newest_task) do
    FactoryBot.create(:task,
                      title: 'first_task',
                      content: 'Newest content',
                      created_at: Date.new(2022, 2, 18))
  end

  # Shared setup for all tests
  before do
    visit tasks_path
    expect(page).to have_css('table', wait: 10)  # wait for table to load
  end

  context 'When transitioning to the list screen' do
    it 'The list of created tasks is displayed in descending order of creation date and time.' do
      visit tasks_path
    
      expect(page).to have_content 'DEBUG: Loaded 3 tasks in controller', wait: 5
      expect(page).to have_content 'Tasks count in view: 3', wait: 5  # add this if you added debug in view
    
      task_rows = all('tr').drop(1)
    
      puts "Found #{task_rows.size} data rows"
    
      expect(task_rows.size).to eq(3)
    
      expect(task_rows[0]).to have_content 'first_task', wait: 10
      expect(task_rows[1]).to have_content 'second_task', wait: 10
      expect(task_rows[2]).to have_content 'third_task', wait: 10
    end
  end

  context 'When creating a new task' do
    it 'New task is displayed at the top' do
      visit new_task_path

      fill_in 'タイトル', with: 'newest_task'
      fill_in '内容', with: 'This is the newest task'
      click_button '登録する'

      expect(page).to have_content 'タスクを登録しました。', wait: 10

      visit tasks_path

      expect(page).to have_css('table', wait: 10)

      first_row = all('tr').drop(1).first

      expect(first_row).to have_content 'newest_task', wait: 10
    end
  end
end