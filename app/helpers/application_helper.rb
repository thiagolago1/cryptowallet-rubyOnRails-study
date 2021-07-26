module ApplicationHelper
  def data_br(data_us)
    data_us.strftime("%d/%m/%Y")
  end

  def locale
    I18n.locale == :en ? 'USA' : 'Português (Brasil)'
  end

  def name_application
    "Crypto Wallet APP"
  end

  def ambiente_rails
    if Rails.env.development?
      "Desenvolvimento"
    elsif Rails.env.production?
      "Produção"
    else
      "Testes"
    end
  end
end
