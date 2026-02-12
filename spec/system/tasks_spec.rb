require 'rails_helper'

RSpec.describe 'List display function', type: :system do
  # Immediate creation with let!
  let!(:oldest_task) do
    FactoryBot.create(:task, title: 'third_task', created_at: Date.new(2022, 2, 16))
  end

  let!(:middle_task) do
    FactoryBot.create(:task, title: 'second_task', created_at: Date.new(2022, 2, 17))
  end

  let!(:newest_task) do
    FactoryBot.create(:task, title: 'first_task', created_at: Date.new(2022, 2, 18))
  end

  # Shared setup
  before do
    visit tasks_path
  end

  context 'When transitioning to the list screen' do
    it 'The list of created tasks is displayed in descending order of creation date and time.' do
      # Get all data rows (skip header if needed)
      task_rows = all('tbody tr')

      # Expect 3 rows
      expect(task_rows.size).to eq(3)

      # Newest first
      expect(task_rows[0]).to have_content 'first_task'
      # Middle
      expect(task_rows[1]).to have_content 'second_task'
      # Oldest last
      expect(task_rows[2]).to have_content 'third_task'
    end
  end

  context 'When creating a new task' do
    it 'New task is displayed at the top' do
      # Go to new page
      visit new_task_path

      # Fill form (using Japanese labels from ja.yml)
      fill_in t('activerecord.attributes.task.title'), with: 'newest_task'
      fill_in t('activerecord.attributes.task.content'), with: 'This is brand new!'
      click_button t('helpers.submit.create')

      # Back to index
      visit tasks_path

      # First row should be the new one
      first_row = all('tbody tr').first
      expect(first_row).to have_content 'newest_task'
    end
  end
end