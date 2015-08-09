json.array!(@kanjis) do |kanji|
  json.extract! kanji, :id, :kanji, :due
  json.url kanji_url(kanji, format: :json)
end
