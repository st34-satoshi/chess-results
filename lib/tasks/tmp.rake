# 一時的に必要なタスク。消しても問題ないコードをこのファイルに書く。

namespace :tmp do
  # 実行方法: docker compose exec web rake 'tmp:change_player_id[before_id,after_id]'
  desc 'プレーヤーのIDを変更する'
  task :change_player_id, [:before, :after] => :environment do |_task, args|
    puts "change player id: #{args.before} => #{args.after}"
    player = Player.find_by(ncs_id: args.before)
    if player.nil?
      puts "no player"
      exit
    end

    new_id = args.after
    puts "player id: #{player.id}"
    player.update(ncs_id: new_id)

    PlayerYear.all.each do |year|
      puts year.created_year
      year_player = Player.clone
      year_player.table_name = "#{year.created_year}_players"
      p = year_player.find_by(ncs_id: args.before)
      if p.nil?
        puts "no player"
        next
      end

      p.update(ncs_id: new_id)
      puts "updated"
    end
  end

  desc 'playersのバリデーションチェック'
  task check_players_validation: :environment do
    puts "start checking playres validation"
    puts "Player table"
    Player.all.each do |player|
      unless player.valid?
        puts "ID=#{player.id}, ncs_id=#{player.ncs_id} is invalid: #{player.errors.full_messages.to_sentence}"
      end
    end

    puts "year player tables"
    PlayerYear.all.each do |year|
      puts year.created_year
      year_player = Player.clone
      year_player.table_name = "#{year.created_year}_players"
      year_player.all.each do |player|
        unless player.valid?
          puts "ID=#{player.id}, ncs_id=#{player.ncs_id} is invalid: #{player.errors.full_messages.to_sentence}"
        end
      end
    end
  end
end