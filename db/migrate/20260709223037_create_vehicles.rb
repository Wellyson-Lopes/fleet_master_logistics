# frozen_string_literal: true

class CreateVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicles, id: :uuid do |t|
      t.string :type, null: false                 # tipo: caminhão, trator, escavadeira, etc.
      t.string :plate, null: false                # placa única (ABC-1234)
      t.string :brand                             # marca (Volvo, Scania, Mercedes)
      t.string :model                             # modelo (FH 460, R 450)
      t.integer :year                             # ano de fabricação
      t.integer :load_capacity_kg                 # capacidade de carga em kg
      t.integer :current_mileage_km               # kilometragem atual
      t.string :status, default: 'active'         # active | maintenance | inactive
      t.string :chassis                           # número do chassi (opcional)
      t.string :renavam                           # Renavam (opcional)

      t.references :company, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_index :vehicles, :plate, unique: true
  end
end
