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
end
