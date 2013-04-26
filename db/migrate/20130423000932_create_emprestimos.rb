class CreateEmprestimos < ActiveRecord::Migration
  def change
    create_table :emprestimos do |t|
      t.date :data_de_emprestimo
      t.date :data_de_devolucao
      t.date :devolvido_em
      t.references :aluno
      t.references :livro

      t.timestamps
    end
    add_index :emprestimos, :aluno_id
    add_index :emprestimos, :livro_id
  end
end
