namespace :scrape do
  desc 'Scrape departments'
  task start: :environment do
    Department.scrape_from_online
    # Todo: use find_each
    Department.all.each(&:get_geo)
  end

end
