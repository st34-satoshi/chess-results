require "csv"

namespace :database do
  desc "csvファイルから対局結果をデータベースに保存する"
  task create_data: :environment do
    include CreateData
    directories = get_directories
    directories.each do |directory|
      csv_files = get_csv_files(directory)
      csv_files.each do |file|
        read_data(file)
      end
    end
  end
end

module CreateData
  def read_data(file)
    # csvファイルを読み込んでデータベースに保存する
    Rails.logger.info "read: #{file}"
    csv_data = CSV.read(file, headers: true)
    
    # TODO: indexがあっているか確認した方が良い
    headers = csv_data.headers
    white_id_index = 5
    white_name_en_index = 6
    white_name_jp_index = 7
    black_id_index = 18
    black_name_en_index = 19
    black_name_jp_index = 20

    csv_data.each do |row|
      white_id = row[white_id_index]
      black_id = row[black_id_index]
      white = Player.find_by(ncs_id: white_id)
      white ||= Player.create(ncs_id: white_id, name_en: row[white_name_en_index], name_jp: row[white_name_jp_index])
      black = Player.find_by(ncs_id: black_id)
      black ||= Player.create(ncs_id: black_id, name_en: row[black_name_en_index], name_jp: row[black_name_jp_index])

    end
  end

  def add_player(id, name_en, name_jp)

  end

  def get_directories
    directory_pathes = []
    directory_path = "data/"
    entries = Dir.entries(directory_path)
    entries.each do |entry|
      next unless File.directory?(File.join(directory_path, entry)) and entry.size > 4 # ディレクトリ以外と4文字以下は飛ばす
      directory_pathes.push(File.join(directory_path, entry))
    end
    directory_pathes
  end

  def get_csv_files(directory)
    file_pathes = []
    entries = Dir.entries(directory)
    entries.each do |entry|
      next unless entry.include? ".csv"
      file_pathes.push(File.join(directory, entry))
    end
    file_pathes
  end
end