require 'rails_helper'

RSpec.describe UlidRecord, type: :model do
  # 抽象クラスのテストなのでダミークラスを用意する
  dummy_table = SecureRandom.urlsafe_base64

  before do
    ApplicationRecord.lease_connection.create_table(dummy_table, id: false) do |t|
      t.string :id, null: false, primary_key: true
      t.timestamps
    end

    stub_const(
      'TestClass',
      Class.new(UlidRecord) do
        self.table_name = dummy_table
      end
    )
  end

  after { ApplicationRecord.lease_connection.drop_table(dummy_table) }

  describe 'scope' do
    describe 'created(from:, to:)' do
      let!(:sources) do
        Array.new(5) { travel_to(1.day.from_now) or next TestClass.create! }
             .index_by { it.created_at.to_date }
      end

      before { freeze_time }

      context 'from/to を指定しないケース' do
        it '作成日時による絞り込みをしない' do
          aggregate_failures do
            scope = TestClass.created(from: nil, to: nil)
            expect(scope.pluck(:id)).to match_array sources.values.map(&:id)
          end
        end
      end

      context 'to を指定しないケース' do
        it '作成日時の始点による絞り込みを行う' do
          aggregate_failures do
            from = sources.keys[1]
            scope = TestClass.created(from:)
            expect(scope.pluck(:id)).to match_array(
              sources.filter { it >= from }.values.map(&:id)
            )
          end
        end
      end

      context 'from を指定しないケース' do
        it '作成日時の終点による絞り込みを行う' do
          aggregate_failures do
            to = sources.keys[3]
            scope = TestClass.created(to:)
            expect(scope.pluck(:id)).to match_array(
              sources.filter { it < to }.values.map(&:id)
            )
          end
        end
      end

      context 'from/to を指定するケース' do
        it '作成日時の始点と終点による絞り込みを行う' do
          aggregate_failures do
            from = sources.keys[1]
            to = sources.keys[3]
            scope = TestClass.created(from:, to:)
            expect(scope.pluck(:id)).to match_array(
              sources.filter { it >= from && it < to }.values.map(&:id)
            )
          end
        end
      end
    end
  end

  describe 'callback' do
    describe 'before_validation' do
      let(:model) { TestClass.new }

      
      it 'ULIDを生成して設定する' do
        aggregate_failures do
          expect { model.validate! }.not_to raise_error
          expect(model.id).to be_present
          expect(model.id.length).to eq 26
        end
      end
    end
  end
end
