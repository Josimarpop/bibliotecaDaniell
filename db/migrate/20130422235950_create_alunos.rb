class CreateAlunos < ActiveRecord::Migration
  def change
    create_table :alunos do |t|
      t.string :nome
      t.integer :matricula

      t.timestamps
    end
  end
end
