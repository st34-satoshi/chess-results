namespace :analysis do
  desc "Show player game counts of top 5 players"
  task player_game_counts: :environment do
    puts "Calculating game counts for players..."
    
    player_counts = Player.all.map do |player|
      games_count = Game.where("white_id = ? OR black_id = ?", player.id, player.id)
                       .where(time_type: 'ST')
                       .where("start_at >= ? AND start_at <= ?", Date.new(2024,1,1), Date.new(2024,12,31))
                       .count
      [player, games_count]
    end.sort_by { |_, count| -count }

    puts "\nTop 5 players by game count:"
    puts "-------------------------"
    player_counts.first(5).each.with_index(1) do |(player, count), i|
      puts "#{i}. #{player.name_jp} (#{player.name_en}): #{count} games"
    end
  end

  desc "Export tournament names and dates for a player to CSV"
  task export_player_tournaments: :environment do
    ncs_id = "N01655183"

    player = Player.find_by(ncs_id: ncs_id)
    if player.nil?
      puts "Player not found with NCS ID: #{ncs_id}"
      next
    end

    puts "Exporting tournament data for #{player.name_jp} (#{player.name_en})..."

    games = Game.where("white_id = ? OR black_id = ?", player.id, player.id)
                .where(time_type: 'ST')
                .where("games.start_at >= ? AND games.start_at <= ?", Date.new(2024,1,1), Date.new(2024,12,31))
                .joins(:tournament)
                .select("games.tournament_id, tournaments.name, tournaments.start_at")
                .order("tournaments.start_at DESC")

    CSV.open("player_tournaments_#{ncs_id}.csv", "wb") do |csv|
      csv << ["Tournament Name", "Start Date"]
      games.each do |game|
        csv << [game.tournament.name, game.tournament.start_at&.strftime("%Y-%m-%d")]
      end
    end

    puts "Export completed to player_tournaments_#{ncs_id}.csv"
  end

  desc "Show longest winning/drawing streaks"
  task no_lose_streaks: :environment do
    time_type = "ST"
    puts "Calculating #{time_type} longest winning/drawing streaks..."

    player_streaks = Player.all.map do |player|
      games = Game.where("white_id = ? OR black_id = ?", player.id, player.id)
                  .where(time_type: time_type)
                  .order(start_at: :asc)

      current_no_lose_streak = 0
      max_no_lose_streak = 0
      streak_end_date = nil

      games.each do |game|
        is_white = game.white_id == player.id
        result = if is_white
                  game.white_point
                else 
                  1 - game.white_point
                end
        if result == 1 || result == 0.5 # Win or draw
          current_no_lose_streak += 1
          if current_no_lose_streak > max_no_lose_streak
            max_no_lose_streak = current_no_lose_streak
            streak_end_date = game.start_at
          end
        else # Loss
          current_no_lose_streak = 0
        end
      end
      if max_no_lose_streak > 0 && streak_end_date
        streak_start_date = games.where("start_at <= ?", streak_end_date).reorder(start_at: :desc).limit(max_no_lose_streak).last.start_at
      else
        streak_start_date = nil
      end

      [player, max_no_lose_streak, streak_start_date, streak_end_date]
    end.compact.sort_by { |_, streak, _, _| -streak.to_i }

    puts "\nTop 10 #{time_type} longest winning/drawing streaks:"
    puts "----------------------------------------"
    player_streaks.first(10).each.with_index(1) do |(player, streak, start_date, end_date), i|
      next if streak == 0
      puts "#{i}. #{player.name_jp} (#{player.name_en}): #{streak} games"
      puts "   Period: #{start_date&.strftime('%Y-%m-%d')} to #{end_date&.strftime('%Y-%m-%d')}"
    end
  end
end
