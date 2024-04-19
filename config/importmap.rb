# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin 'bootstrap', preload: true
pin 'chart', preload: true
pin 'chartjs-plugin-datalabels', preload: true
pin 'player/index'
pin 'player/show'
pin 'home/health'

pin_all_from 'app/javascript/controllers', under: 'controllers'
