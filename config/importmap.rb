# config/importmap.rb
pin "application", preload: true
pin "@hotwired/turbo", to: "turbo.js"
pin "controllers", to: "controllers/*"
pin "@hotwired/stimulus", to: "stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
