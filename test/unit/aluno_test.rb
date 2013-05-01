require 'test_helper'

class AlunoTest < ActiveSupport::TestCase

  fixtures :alunos

  def test_should_be_invalid
    aluno = Aluno.create
    assert !aluno.valid?, "O Aluno nao deve ser criado"
  end

  def test_should_require_nome
    aluno = create(:nome => nil)
    assert !aluno.valid?, "O Aluno nao deve ser criado"

  end

  def test_should_require_matricula
    aluno = create(:matricula => nil)
    assert !aluno.valid?, "O Aluno nao deve ser criado"

  end

  def test_should_create_a_new_student
    assert_difference ('Aluno.count') do
      aluno1 = create(:nome => "Fabio Silva", :matricula => 3232)
      assert aluno1.save
      aluno1_copy = Aluno.find(aluno1.id)
      assert_equal aluno1.nome, aluno1_copy.nome
      assert_equal aluno1.matricula, aluno1_copy.matricula
    end

  end

  def test_should_edit_a_new_student
    aluno2 = create(:nome => "Rafael Santos", :matricula => 4348)
    assert aluno2.save
    aluno2_copy = Aluno.find(aluno2.id)
    aluno2.nome = "Maria Oliveira"
    aluno2.matricula = 9090
    assert aluno2.save
    assert_not_equal(aluno2.nome, aluno2_copy.nome)
    assert_not_equal(aluno2.matricula, aluno2_copy.matricula)

  end

  def test_should_destroy_a_student
    aluno3 = create(:nome => "Arthur Lima", :matricula => 235)
    assert aluno3.destroy
  end

  private
    def create(options={})
      Aluno.create({
          :nome => "Joao da Silva",
          :matricula => 342424
      }.merge(options))

    end

end
