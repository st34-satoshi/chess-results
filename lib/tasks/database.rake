# frozen_string_literal: true

require 'csv'

namespace :database do
  desc 'csvファイルから対局結果をデータベースに保存する'
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

  desc 'プレイヤーごとの統計情報を計算する'
  task create_player_stats: :environment do
  Player.all.each do |player|
      Rails.logger.info "start #{player.name_jp}"
      total_game_count = player.games.size
      total_win_count = player.win_games_of("RP").size + player.win_games_of("ST").size 
      total_draw_count = player.draw_games_of("RP").size + player.draw_games_of("ST").size 
      total_loss_count = player.loss_games_of("RP").size + player.loss_games_of("ST").size 
      opponent_rating_sum = 0
      opponent_rating_count = 0
      player.white_games.each do |game|
        next if game.black_rating < 400
        opponent_rating_sum += game.black_rating
        opponent_rating_count += 1
      end
      player.black_games.each do |game|
        next if game.white_rating < 400
        opponent_rating_sum += game.white_rating
        opponent_rating_count += 1
      end
      total_opponent_rating_average = 0.0
      total_opponent_rating_average = opponent_rating_sum / opponent_rating_count.to_f if opponent_rating_count > 0
      
      player.update(
        total_game_count: total_game_count,
        total_win_count: total_win_count,
        total_draw_count: total_draw_count,
        total_loss_count: total_loss_count,
        total_opponent_rating_average: total_opponent_rating_average,
      )
    end
  end
end

module CreateData
  def read_data(file)
    # csvファイルを読み込んでデータベースに保存する
    Rails.logger.info "read: #{file}"
    csv_data = CSV.read(file, headers: true)

    csv_data.each do |row|
      # playerが保存されてなければ保存する
      white_id = row['White ID']
      black_id = row['Black ID']
      white = Player.find_by(ncs_id: white_id)
      white ||= Player.create(ncs_id: white_id, name_en: row['White Name'], name_jp: row['White Kanji'])
      black = Player.find_by(ncs_id: black_id)
      black ||= Player.create(ncs_id: black_id, name_en: row['Black Name'], name_jp: row['Black Kanji'])

      # tournamentがなければ保存する
      start_at = row['Date'].to_date
      tournament_name = row['Source']
      tournament = Tournament.find_by(name: tournament_name, start_at:)
      tournament ||= Tournament.create(name: tournament_name, start_at:)

      # gameを保存する
      white_rating = row['White Rating']
      white_rating = 0 if white_rating.nil?
      white_k = row['White K']
      black_rating = row['Black Rating']
      black_rating = 0 if black_rating.nil?
      black_k = row['Black K']
      white_point = row['White Point']
      time_type = row['Time']
      g = Game.create(
        white:, white_k:, white_rating:,
        black:, black_k:, black_rating:,
        white_point:,
        time_type:,
        tournament:,
        start_at:
      )
      puts g.errors.full_messages if g.errors.present?
    end
  end

  def get_directories
    directory_pathes = []
    directory_path = 'data/'
    entries = Dir.entries(directory_path)
    entries.each do |entry|
      next unless File.directory?(File.join(directory_path, entry)) && (entry.size > 4) # ディレクトリ以外と4文字以下は飛ばす

      directory_pathes.push(File.join(directory_path, entry))
    end
    directory_pathes
  end

  def get_csv_files(directory)
    file_pathes = []
    entries = Dir.entries(directory)
    entries.each do |entry|
      next unless entry.include? '.csv'

      file_pathes.push(File.join(directory, entry))
    end
    file_pathes
  end
end
