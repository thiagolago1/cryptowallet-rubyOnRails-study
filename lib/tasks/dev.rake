namespace :dev do
  desc "Configurar ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando DB...") do
        %x(rails db:drop)
      end
      show_spinner("Criando novo DB...") { %x(rails db:create) }
      show_spinner("Executando migrações na DB...") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    end
  end

  desc "Cadastro de moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
      coins = [
        {
          description: "Bitcoin",
          acronym: "BTC",
          url_image: "https://assets.cambiostore.com/assets/bitcoin-logo-11961d79a8fde725e878473bd3497adff1fb6d362c1378e9eb182c870a617a2a.png",
          mining_type: MiningType.find_by(acronym: 'PoW')
        },
        {
          description: "Dash",
          acronym: "DASH",
          url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/131.png",
          mining_type: MiningType.all.sample
        },
        {
          description: "Dogecoin",
          acronym: "DOGE",
          url_image: "https://logos-download.com/wp-content/uploads/2018/04/DogeCoin_logo_cercle-1.svg",
          mining_type: MiningType.all.sample
        },
        {
          description: "Ethereum",
          acronym: "ETH",
          url_image: "https://icon-library.com/images/eth-alt-512_19124.png",
          mining_type: MiningType.all.sample
        },
        {
          description: "Litecoin",
          acronym: "LTC",
          url_image: "https://img2.gratispng.com/20180525/wal/kisspng-litecoin-cryptocurrency-bitcoin-logo-cryptocurrency-5b081f1979b524.5871818715272589054985.jpg",
          mining_type: MiningType.all.sample
        }
      ]
      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastro de tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando tipos de mineração...") do
      mining_types = [
        { description: "Proof of Work", acronym: "PoW" },
        { description: "Proof of Stake", acronym: "PoS" },
        { description: "Proof of Capacity", acronym: "PoC" },
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

private

  def show_spinner(msg_start, msg_end = "Concluído com sucesso!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
