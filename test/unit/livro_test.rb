require 'test_helper'

class LivroTest < ActiveSupport::TestCase

  fixtures :livros

  def setup
    @user = User.create!(
        :email => 'user@email.com',
        :password => '12345678',
        :password_confirmation => '12345678'
    )
  end

  def test_should_be_invalid
    livro = Livro.create
    assert !livro.valid?, "O Livro nao deve ser criado"
  end

  def test_should_require_titulo
    livro = create(:titulo => nil)
    assert !livro.valid?, "O Livro nao deve ser criado"

  end

  def test_should_require_autor
    livro = create(:autor => nil)
    assert !livro.valid?, "O Livro nao deve ser criado"
  end

  def test_should_create_a_new_book
    assert_difference ('Livro.count') do
      livro1 = create(:titulo => "Head first rails", :autor => "OReilly")
      assert livro1.save
      livro1_copy = Livro.find(livro1.id)
      assert_equal livro1.titulo, livro1_copy.titulo
      assert_equal livro1.autor, livro1_copy.autor
    end
  end

  def test_should_edit_a_new_book
    book2 = create(:titulo => "C como Programar", :autor => "Deitel")
    assert book2.save
    book2_copy = Livro.find(book2.id)
    book2.titulo = "Software Engineering"
    book2.autor = "Ian Sommerville"
    assert book2.save
    assert_not_equal(book2.titulo, book2_copy.titulo)
    assert_not_equal(book2.autor, book2_copy.autor)
  end

  def test_should_destroy_a_student
    book3 = create(:titulo => "Agile Web Development with Rails", :autor => "Dave Thomas")
    assert book3.destroy
  end


  private
  def create(options={})
    Livro.create({
                     :titulo => "Head first rails",
                     :autor => "OReilly"
                 }.merge(options))

  end


  test "Os atributos de livro nao devem ser nulos" do
    livro = Livro.new

    assert livro.invalid?
    assert livro.errors[:titulo].any?
    assert livro.errors[:autor].any?
  end

  test "Livro nao pode ter o mesmo nome" do
    livro1 = livros(:livro1)
    livro = Livro.new( {
                           :titulo => livro1.titulo,
                           :autor => livro1.autor
                       }
                      )

    assert livro.invalid?
    assert livro.errors[:author].none?
    assert livro.errors[:titulo].any?

    livro.titulo = "XXX"

    assert livro.valid?
    assert livro.errors[:author].none?
    assert livro.errors[:titulo].none?
  end

end
