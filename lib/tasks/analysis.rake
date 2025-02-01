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
end
