require 'test_helper'

class EmprestimoTest < ActiveSupport::TestCase
  fixtures :emprestimos

  def test_should_be_invalid
    emprestimo = Emprestimo.create
    assert !emprestimo.valid?, "O Emprestimo nao deve ser criado"
  end

  def test_should_require_data_de_emprestimo
    emprestimo = create(:data_de_emprestimo => nil)
    assert !emprestimo.valid?, "O Emprestimo nao deve ser criado"
  end

  def test_should_require_data_de_devolucao
    emprestimo = create(:data_de_devolucao => nil)
    assert !emprestimo.valid?, "O Emprestimo nao deve ser criado"
  end

  def test_should_require_livro
    emprestimo = create(:livro_id => nil)
    assert !emprestimo.valid?, "O Emprestimo nao deve ser criado"
  end

  def test_should_require_aluno
    emprestimo = create(:aluno_id => nil)
    assert !emprestimo.valid?, "O Emprestimo nao deve ser criado"
  end

  def test_should_create_a_new_emprestimo
    assert_difference ('Emprestimo.count') do
      emprestimo1 = create(:data_de_emprestimo => "07/05/2013", :data_de_devolucao => "10/05/2013",
                          :livro_id => 810307477, :aluno_id => 980190962)
      assert emprestimo1.save
      emprestimo1_copy = Emprestimo.find(emprestimo1.id)
      assert_equal emprestimo1.data_de_emprestimo, emprestimo1_copy.data_de_emprestimo
      assert_equal emprestimo1.data_de_devolucao, emprestimo1_copy.data_de_devolucao
      assert_equal emprestimo1.livro_id, emprestimo1_copy.livro_id
      assert_equal emprestimo1.aluno_id, emprestimo1_copy.aluno_id
    end
  end

  def test_should_edit_a_new_emprestimo
    emprestimo2 = create(:data_de_emprestimo => "08/05/2013", :data_de_devolucao => "12/05/2013",
                         :livro_id => 810307477, :aluno_id => 980190962)
    assert emprestimo2.save
    emprestimo2_copy = Emprestimo.find(emprestimo2.id)
    emprestimo2.data_de_emprestimo = "09/05/2013"
    emprestimo2.data_de_devolucao = "15/05/2013"
    emprestimo2.livro_id = 692395561
    emprestimo2.aluno_id = 298486374
    assert emprestimo2.save
    assert_not_equal(emprestimo2.data_de_emprestimo, emprestimo2_copy.data_de_emprestimo)
    assert_not_equal(emprestimo2.data_de_devolucao, emprestimo2_copy.data_de_devolucao)
    assert_not_equal(emprestimo2.livro_id, emprestimo2_copy.livro_id)
    assert_not_equal(emprestimo2.aluno_id, emprestimo2_copy.aluno_id)
  end

  def test_should_destroy_a_emprestimo
    emprestimo3 = create(:data_de_emprestimo => "12/05/2013", :data_de_devolucao => "17/05/2013",
                         :livro_id => 810307477, :aluno_id => 980190962)
    assert emprestimo3.destroy
  end

  private
  def create(options={})
    Emprestimo.create({
                          :data_de_emprestimo => "01/05/2013",
                          :data_de_devolucao => "05/05/2013",
                          :livro_id => 507653822,
                          :aluno_id => 298486374
                      }.merge(options))
  end
end
