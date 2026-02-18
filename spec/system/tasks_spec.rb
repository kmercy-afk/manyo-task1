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

  # Shared setup
  before do
    visit tasks_path
    expect(page).to have_css('table', wait: 10)  # wait for table to load
  end

  context 'When transitioning to the list screen' do
    it 'The list of created tasks is displayed in descending order of creation date and time.' do
  visit tasks_path

  # Wait for the newest task to appear (proof tasks are rendered)
  expect(page).to have_content 'first_task', wait: 10

  # Find all text blocks containing task titles
  task_blocks = page.all(:xpath, '//text()[contains(., "task")]//ancestor::*[self::div or self::p or self::span or self::li or self::tr]')

  puts "Found #{task_blocks.size} task blocks on the page"

  expect(task_blocks.size).to be >= 3, "Expected at least 3 task blocks, found #{task_blocks.size}"

  # Check order by looking at the text of the first few blocks
  expect(task_blocks[0].text).to match(/first_task/), "First block should contain first_task"
  expect(task_blocks[1].text).to match(/second_task/), "Second block should contain second_task"
  expect(task_blocks[2].text).to match(/third_task/), "Third block should contain third_task"
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