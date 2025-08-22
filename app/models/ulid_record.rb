class UlidRecord < ApplicationRecord
  self.abstract_class = true

  # 保存前のバリデーション時に未設定ならULIDを生成する
  before_validation :generate_id!

  # ULIDを使って日付の範囲選択を高速にする
  # created_at にインデックスを張らなくてもよくなる
  scope :created, ->(from: nil, to: nil) {
    # 乱数部分をランダムのままにすると範囲検索が不安定になる
    suffix = '0' * 16
    from_id = from ? ULID.generate(from.to_time, suffix:) : nil
    to_id = to ? ULID.generate(to.to_time, suffix:) : nil
    where(id: from_id..to_id)
  }

  def generate_id!
    self.id ||= ULID.generate if self.class.primary_key == 'id'
  end
end
