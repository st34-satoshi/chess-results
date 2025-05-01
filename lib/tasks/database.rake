# frozen_string_literal: true

require 'csv'

# rubocop:disable Metrics/BlockLength, Metrics/MethodLength, Metrics/AbcSize, Metrics/ModuleLength
namespace :database do
  desc 'csvファイルから対局結果をデータベースに保存する'
  task create_data: :environment do
    include CreateData
    directories = csv_directories
    directories.each do |directory|
      files = csv_files(directory)
      files.each do |file|
        read_data(file)
      end
    end
  end

  desc '特定のcsvファイルから対局結果をデータベースから削除する'
  task :remove_from_a_file, [:file_path] => :environment do |_task, args|
    include CreateData
    puts 'remove from a file'
    remove_data(args.file_path)
  end

  desc '特定のcsvファイルから対局結果をデータベースに保存する'
  task :create_from_a_file, [:file_path] => :environment do |_task, args|
    include CreateData
    puts 'create from a file'
    read_data(args.file_path)
  end

  desc 'csvファイルから棋譜をデータベースに保存する'
  task add_pgn_moves: :environment do
    include CreateData
    directories = csv_directories
    directories.each do |directory|
      files = csv_files(directory)
      files.each do |file|
        read_pgn_data(file)
      end
    end
  end

  desc 'プレーヤーごとの統計情報を計算する'
  task create_player_stats: :environment do
    # TODO: clean use player year class
    Player.all.each do |player|
      Rails.logger.info "start #{player.name_jp}"
      total_game_count = player.games.size
      total_win_count = player.win_games_of('RP').size + player.win_games_of('ST').size
      total_draw_count = player.draw_games_of('RP').size + player.draw_games_of('ST').size
      total_loss_count = player.loss_games_of('RP').size + player.loss_games_of('ST').size
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
      total_opponent_rating_average = opponent_rating_sum / opponent_rating_count.to_f if opponent_rating_count.positive?

      player.update(
        total_game_count:,
        total_win_count:,
        total_draw_count:,
        total_loss_count:,
        total_opponent_rating_average:
      )
    end
  end

  desc '年ごとにプレーヤーのランキングを保存する'
  task create_year_player_ranking: :environment do
    Rails.logger.info 'start year player ranking'
    oldest_year = Game.order(:start_at).first.start_at.year
    latest_year = Game.order(:start_at).last.start_at.year
    (oldest_year..latest_year).each do |y|
      Rails.logger.info y
      PlayerYear.create_player_table(y)
      PlayerYear.update_players(y)
    end
    Rails.logger.info 'finish year player ranking'
  end

  desc '特定の年のプレーヤーランキングを保存する'
  task :create_year_player_ranking_in, [:year] => :environment do |_task, args|
    include CreateData
    y = args.year.to_i
    Rails.logger.info "start year player ranking in #{y}"
    PlayerYear.create_player_table(y)
    PlayerYear.update_players(y)
    Rails.logger.info "finish year player ranking in #{y}"
  end
end

module CreateData
  def remove_data(file)
    # csvファイルを読み込んでデータベースから削除する
    Rails.logger.info "remove data: #{file}"
    csv_data = CSV.read(file, headers: true)

    csv_data.each do |row|
      # playerを取得する
      white_id = row['White ID']
      black_id = row['Black ID']
      white = Player.find_by(ncs_id: white_id)
      black = Player.find_by(ncs_id: black_id)

      # tournamentを取得する
      start_at = row['Date'].to_date
      tournament_name = row['Source']
      tournament = Tournament.find_by(name: tournament_name, start_at:)

      # 条件が同じgameを削除する
      white_rating = row['White Rating']
      white_rating = 0 if white_rating.nil?
      white_k = row['White K']
      black_rating = row['Black Rating']
      black_rating = 0 if black_rating.nil?
      black_k = row['Black K']
      white_point = row['White Point']
      time_type = row['Time']
      # 間違えて重複して保存している場合はすべて削除する
      Game.where(
        white:, white_k:, white_rating:,
        black:, black_k:, black_rating:,
        white_point:,
        time_type:,
        tournament:,
        start_at:
      ).destroy_all
    end
  end

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
      round = row['Round']&.to_i
      white_rating = row['White Rating']
      white_rating = 0 if white_rating.nil?
      white_k = row['White K']
      black_rating = row['Black Rating']
      black_rating = 0 if black_rating.nil?
      black_k = row['Black K']
      white_point = row['White Point']
      time_type = row['Time']
      white_change = row['White Change']&.to_f
      black_change = row['Black Change']&.to_f
      g = Game.create(
        white:, white_k:, white_rating:,
        black:, black_k:, black_rating:,
        white_point:,
        time_type:,
        tournament:,
        start_at:,
        white_change:,
        black_change:,
        round:
      )
      puts g.errors.full_messages if g.errors.present?
    end
  end

  def read_pgn_data(file)
    # csvファイルを読み込んで png のみをデータベースに保存する
    Rails.logger.info "read pgn: #{file}"
    csv_data = CSV.read(file, headers: true)

    csv_data.each do |row|
      pgn_moves = row['PGN Moves']

      # pgn がなければスキップ
      next if pgn_moves.nil? || pgn_moves.empty?

      white_id = row['White ID']
      black_id = row['Black ID']
      tournament_name = row['Source']
      start_at = row['Date'].to_date
      white = Player.find_by(ncs_id: white_id)
      black = Player.find_by(ncs_id: black_id)
      tournament = Tournament.find_by(name: tournament_name, start_at:)

      # プレイヤー, トーナメントが存在しなければスキップ
      next if white.nil? || black.nil? || tournament_name.nil?

      g = Game.find_by(white:, black:, tournament:, start_at:)

      # ゲームが存在しなければスキップ
      next if g.nil?

      g.pgn_moves = pgn_moves
      g.save
    end
  end

  def csv_directories
    directory_pathes = []
    directory_path = 'data/'
    entries = Dir.entries(directory_path)
    entries.each do |entry|
      next unless File.directory?(File.join(directory_path, entry)) && (entry.size > 4) # ディレクトリ以外と4文字以下は飛ばす

      directory_pathes.push(File.join(directory_path, entry))
    end
    directory_pathes
  end

  def csv_files(directory)
    file_pathes = []
    entries = Dir.entries(directory)
    entries.each do |entry|
      next unless entry.include? '.csv'

      file_pathes.push(File.join(directory, entry))
    end
    file_pathes
  end
end
# rubocop:enable Metrics/BlockLength, Metrics/MethodLength, Metrics/AbcSize, Metrics/ModuleLength
