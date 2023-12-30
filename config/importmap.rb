# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin 'bootstrap', preload: true

pin_all_from "app/javascript/controllers", under: "controllers"
