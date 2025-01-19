Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://mahjong-yaritai.netlify.app" # フロントエンドのURLを指定
    resource "*", # 全てのパスを許可
      headers: :any, # 全てのヘッダーを許可
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ], # 許可するHTTPメソッド
      expose: [ "Authorization" ], # 必要に応じてレスポンスヘッダーを追加
      credentials: true # クッキーや認証情報を許可（必要に応じて有効化）
  end
end
